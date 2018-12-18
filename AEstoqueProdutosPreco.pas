unit AEstoqueProdutosPreco;
{          Autor: Rafael Budag
    Data Criação: 16/04/1999;
          Função: Gerar um orçamento

    Motivo alteração:
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Localizacao, StdCtrls, Buttons, Componentes1, Db, DBTables, ExtCtrls,
  PainelGradiente, Grids, DBGrids, Tabela, DBKeyViolation, DBCtrls, Mask,
  numericos, LabelCorMove, CheckLst, Parcela, BotaoCadastro, Psock, NMpop3,
  EditorImagem, ConvUnidade;

type
  TFEstoqueProdutosPreco = class(TFormularioPermissao)
    CadProdutos: TQuery;
    Localiza: TConsultaPadrao;
    DataCadProdutos: TDataSource;
    PanelColor2: TPanelColor;
    PanelColor5: TPanelColor;
    Label3: TLabel;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    EClassificacaoProduto: TEditLocaliza;
    CProAti: TCheckBox;
    PanelColor16: TPanelColor;
    ENomeProduto: TEditColor;
    CadProdutosC_COD_PRO: TStringField;
    CadProdutosC_COD_UNI: TStringField;
    CadProdutosC_NOM_PRO: TStringField;
    CadProdutosC_ATI_PRO: TStringField;
    CadProdutosN_QTD_PRO: TFloatField;
    GProdutos: TGridIndice;
    CadProdutosI_SEQ_PRO: TIntegerField;
    PainelGradiente1: TPainelGradiente;
    BFechar: TBitBtn;
    CadProdutosC_Cod_Bar: TStringField;
    BitBtn1: TBitBtn;
    Soma: TQuery;
    numerico1: Tnumerico;
    numerico2: Tnumerico;
    numerico3: Tnumerico;
    CadProdutosvalorcompra: TFloatField;
    CadProdutosn_vlr_com: TFloatField;
    CadProdutosvalorvenda: TFloatField;
    CadProdutosn_vlr_ven: TFloatField;
    Zerados: TCheckBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CProAtiClick(Sender: TObject);
    procedure BKitClick(Sender: TObject);
    procedure EClassificacaoProdutoSelect(Sender: TObject);
    procedure EClassificacaoProdutoRetorno(Retorno1, Retorno2: String);
    procedure ENomeProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BFecharClick(Sender: TObject);
    procedure EClassificacaoProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ENomeProdutoEnter(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure AtualizaConsulta;
    procedure AdicionaFiltrosProduto(VpaSelect : TStrings);
  public
  end;

var
  FEstoqueProdutosPreco: TFEstoqueProdutosPreco;

implementation

uses APrincipal, Constantes,ConstMsg, AProdutosKit, ANovoProduto,
  AImprimeEstoqueProduto;
{$R *.DFM}


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                               eventos do filtro superior
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************** carrega a select do localiza classificacao ****************}
procedure TFEstoqueProdutosPreco.EClassificacaoProdutoSelect(Sender: TObject);
begin
  EClassificacaoProduto.ASelectLocaliza.text := 'Select * from CadClassificacao '+
                                                ' where c_nom_Cla like ''@%'''+
                                                ' and I_cod_emp = ' + InttoStr(Varia.CodigoEmpresa)+
                                                ' and C_Con_Cla  = ''S'''+
                                                ' and C_Tip_Cla = ''P''';
  EClassificacaoProduto.ASelectValida.text := 'Select * from CadClassificacao '+
                                                ' where C_Cod_Cla = ''@'''+
                                                ' and I_cod_emp = ' + InttoStr(Varia.CodigoEmpresa)+
                                                ' and C_Con_Cla = ''S'''+
                                                ' and C_Tip_Cla = ''P''';
end;

{**************** chama a rotina para atualizar a consulta ********************}
procedure TFEstoqueProdutosPreco.EClassificacaoProdutoRetorno(Retorno1,
  Retorno2: String);
begin
  AtualizaConsulta;
end;

{*************Chama a Rotina para atualizar a select dos produtos**************}
procedure TFEstoqueProdutosPreco.CProAtiClick(Sender: TObject);
begin
  AtualizaConsulta;
  BFechar.Default := true;
end;

{************ se for pressionado enter atualiza a consulta ********************}
procedure TFEstoqueProdutosPreco.ENomeProdutoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case key of
    13 : AtualizaConsulta;
  end;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                         ações da consulta do produto
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************** atualiza a consulta dos produtos **************************}
procedure TFEstoqueProdutosPreco.AtualizaConsulta;
begin
  CadProdutos.sql.clear;
  CadProdutos.sql.add('Select '+
                     ' C_Cod_Pro, qtd.n_qtd_pro, qtd.c_cod_bar, '+
                     ' Pro.I_SEQ_PRO,  Pro.C_COD_UNI,  Pro.C_NOM_PRO, '+
                     '(tab.n_vlr_ven * moe2.n_vlr_dia) n_vlr_ven, ' +
                     ' Pro.C_ATI_PRO, Pro.C_KIT_PRO, ' +
                     '((moe1.n_vlr_dia * qtd.n_vlr_com) * n_qtd_pro) valorcompra, ' +
                     ' (qtd.n_vlr_com * moe1.n_vlr_dia) n_vlr_com, ' +
                     ' ((tab.n_vlr_ven * moe2.n_vlr_dia) * n_qtd_pro) valorvenda ' +
                     ' from CadProdutos pro, MovQdadeProduto Qtd, cadmoedas moe1, cadmoedas moe2, movtabelapreco tab ');
  AdicionaFiltrosProduto(Cadprodutos.Sql);
  CadProdutos.sql.add(' and Qtd.I_Seq_Pro = Pro.I_Seq_Pro '  +
                      ' and pro.i_cod_moe = moe1.i_cod_moe ' +
                      ' and pro.i_seq_pro = tab.i_seq_pro ' +
                      ' and tab.i_cod_tab = ' + intToStr(varia.TabelaPreco )  +
                      ' and tab.i_cod_emp =  ' + IntToStr(varia.CodigoEmpresa) +
                      ' and tab.i_cod_moe = moe2.i_cod_moe ' );
  CadProdutos.sql.add( ' order by pro.c_nom_pro ' );
  CadProdutos.Open;

  // soma total estoque
  soma.sql.clear;
  soma.sql.add('Select sum(QTD.N_QTD_PRO) Qdade, ' +
                     ' sum((moe1.n_vlr_dia * qtd.n_vlr_com) * n_qtd_pro) valorCompra, ' +
                     ' sum((tab.n_vlr_ven * moe2.n_vlr_dia) * n_qtd_pro) valorvenda ' +
                     ' from CadProdutos pro, MovQdadeProduto Qtd, cadmoedas moe1, cadmoedas moe2, movtabelapreco tab  ');
  AdicionaFiltrosProduto(soma.Sql);
  soma.sql.add(' and Qtd.I_Seq_Pro = Pro.I_Seq_Pro ' +
               ' and pro.i_cod_moe = moe1.i_cod_moe ' +
               ' and pro.i_seq_pro = tab.i_seq_pro ' +
               ' and tab.i_cod_tab = ' + intToStr(varia.TabelaPreco )  +
               ' and tab.i_cod_emp =  ' + IntToStr(varia.CodigoEmpresa) +
               ' and tab.i_cod_moe = moe2.i_cod_moe ' );
  soma.Open;
  numerico1.AValor := Soma.fieldByName('qdade').AsCurrency;
  numerico2.AValor := Soma.fieldByName('valorCompra').AsCurrency;
  numerico3.AValor := Soma.fieldByName('valorvenda').AsCurrency;
end;

{******************* adiciona os filtros da consulta **************************}
procedure TFEstoqueProdutosPreco.AdicionaFiltrosProduto(VpaSelect : TStrings);
begin
  VpaSelect.add('Where Qtd.I_Emp_Fil = ' + inttostr(Varia.CodigoEmpFil));

  if ENomeProduto.text <> '' Then
    VpaSelect.Add('and Pro.C_Nom_Pro like '''+ENomeProduto.text +'%''') else VpaSelect.add(' ');
  if EClassificacaoProduto.text <> ''Then
    VpaSelect.add(' and Pro.C_Cod_Cla like '''+ EClassificacaoProduto.text+ '%''') else VpaSelect.add(' ');
  if CProAti.Checked then
    VpaSelect.add(' and Pro.C_Ati_Pro = ''S''') else VpaSelect.add(' ');
  if zerados.Checked then
    VpaSelect.add(' and qtd.n_qtd_pro > 0 ') else VpaSelect.add(' ');
end;


{ ******************* chama o formulario para visualizar kit **************** }
procedure TFEstoqueProdutosPreco.BKitClick(Sender: TObject);
begin
   FProdutosKit := TFProdutosKit.CriarSDI(Application,'',FPrincipal.VerificaPermisao('FProdutosKit'));
   FProdutosKit.MostraKit(CadProdutosI_Seq_Pro.Asstring,Varia.CodigoEmpFil);
end;

{ ****************** Na criação do Formulário ******************************** }
procedure TFEstoqueProdutosPreco.FormCreate(Sender: TObject);
begin
  GProdutos.Columns[0].FieldName := varia.CodigoProduto;
  AtualizaConsulta;
end;


{ ******************* Quando o formulario e fechado ************************** }
procedure TFEstoqueProdutosPreco.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := CaFree;
end;


procedure TFEstoqueProdutosPreco.BFecharClick(Sender: TObject);
begin
  self.close;
end;




procedure TFEstoqueProdutosPreco.EClassificacaoProdutoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case key of
    40 :
      begin
        GProdutos.setfocus;
        CadProdutos.next;
      end;
    Vk_Up :
      begin
        GProdutos.setfocus;
        CadProdutos.Prior;
      end;
  end;
  if Key = 13 then
     AtualizaConsulta;
end;

procedure TFEstoqueProdutosPreco.ENomeProdutoEnter(Sender: TObject);
begin
  BFechar.Default := false;
end;

procedure TFEstoqueProdutosPreco.BitBtn1Click(Sender: TObject);
begin
{  FImprimeEstoqueProduto := TFImprimeEstoqueProduto.CriarSDI(application, '', true);
  FImprimeEstoqueProduto.carregaImpressao( CadProdutos.SQL.Text, '','','0', EClassificacaoProduto.Text);}
end;

procedure TFEstoqueProdutosPreco.BBAjudaClick(Sender: TObject);
begin
    Application.HelpCommand(HELP_CONTEXT,FEstoqueProdutosPreco.HelpContext);
end;

procedure TFEstoqueProdutosPreco.FormShow(Sender: TObject);
begin
  Self.HelpFile := Varia.PathHelp + 'MEstoqueCusto.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
  GProdutos.AListaCAmpos.clear;
  GProdutos.AListaCAmpos.Add(Varia.CodigoProduto);
  GProdutos.AListaCAmpos.Add('c_nom_pro');
end;

Initialization
{ *************** Registra a classe para evitar duplicidade ****************** }
 RegisterClasses([TFEstoqueProdutosPreco]);
end.
