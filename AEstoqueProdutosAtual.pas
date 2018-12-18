unit AEstoqueProdutosAtual;
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
  TFEstoqueProdutosAtual = class(TFormularioPermissao)
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
    CadProdutosC_KIT_PRO: TStringField;
    CadProdutosN_QTD_PRO: TFloatField;
    GProdutos: TGridIndice;
    CadProdutosI_SEQ_PRO: TIntegerField;
    BKit: TSpeedButton;
    PainelGradiente1: TPainelGradiente;
    CadProdutosN_QTD_RES: TFloatField;
    CadProdutosQdadeReal: TFloatField;
    BFechar: TBitBtn;
    CadProdutosC_Cod_Bar: TStringField;
    BitBtn1: TBitBtn;
    Soma: TQuery;
    PanelColor1: TPanelColor;
    Label4: TLabel;
    numerico1: Tnumerico;
    Label5: TLabel;
    numerico2: Tnumerico;
    Label6: TLabel;
    numerico3: Tnumerico;
    Label24: TLabel;
    EFilial: TEditLocaliza;
    SpeedButton5: TSpeedButton;
    Label25: TLabel;
    CZerada: TCheckBox;
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
    procedure CadProdutosAfterScroll(DataSet: TDataSet);
    procedure ENomeProdutoEnter(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure EFilialRetorno(Retorno1, Retorno2: String);
    procedure BBAjudaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure AtualizaConsulta;
    procedure AdicionaFiltrosProduto(VpaSelect : TStrings);
  public
  end;

var
  FEstoqueProdutosAtual: TFEstoqueProdutosAtual;

implementation

uses APrincipal, Constantes,ConstMsg, AProdutosKit, ANovoProduto,
  AImprimeEstoqueProduto;
{$R *.DFM}


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                               eventos do filtro superior
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************** carrega a select do localiza classificacao ****************}
procedure TFEstoqueProdutosAtual.EClassificacaoProdutoSelect(Sender: TObject);
begin
  EClassificacaoProduto.ASelectLocaliza.text := 'Select * from CadClassificacao '+
                                                ' where c_nom_Cla like ''@%'''+
                                                ' and I_cod_emp = ' + InttoStr(Varia.CodigoEmpresa)+
                                                ' and C_Tip_Cla = ''P''';
  EClassificacaoProduto.ASelectValida.text := 'Select * from CadClassificacao '+
                                                ' where C_Cod_Cla = ''@'''+
                                                ' and I_cod_emp = ' + InttoStr(Varia.CodigoEmpresa)+
                                                ' and C_Tip_Cla = ''P''';
end;

{**************** chama a rotina para atualizar a consulta ********************}
procedure TFEstoqueProdutosAtual.EClassificacaoProdutoRetorno(Retorno1,
  Retorno2: String);
begin
  AtualizaConsulta;
end;

{*************Chama a Rotina para atualizar a select dos produtos**************}
procedure TFEstoqueProdutosAtual.CProAtiClick(Sender: TObject);
begin
  AtualizaConsulta;
  BFechar.Default := true;
end;

{************ se for pressionado enter atualiza a consulta ********************}
procedure TFEstoqueProdutosAtual.ENomeProdutoKeyDown(Sender: TObject;
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
procedure TFEstoqueProdutosAtual.AtualizaConsulta;
begin
  CadProdutos.sql.clear;
  CadProdutos.sql.add('Select '+
                     ' C_Cod_Pro, isnull(qtd.n_qtd_pro,0) n_qtd_pro, qtd.c_cod_bar, '+
                     ' Pro.I_SEQ_PRO,  Pro.C_COD_UNI,  Pro.C_NOM_PRO, ' +
                     ' Pro.C_ATI_PRO, Pro.C_KIT_PRO,  ' +
                     '  isnull(QTD.N_QTD_RES,0) N_QTD_RES, ' +
                     ' (isnull(QTD.N_QTD_PRO,0) - isnull(QTD.N_QTD_RES,0)) QdadeReal ' +
                     ' from CadProdutos pro, MovQdadeProduto Qtd ');
 CadProdutos.sql.add(' where Qtd.I_Seq_Pro = Pro.I_Seq_Pro ' );
 AdicionaFiltrosProduto(Cadprodutos.Sql);
 CadProdutos.sql.add( ' order by pro.c_nom_pro ' );

  CadProdutos.Open;

  // soma total estoque
  soma.sql.clear;
  soma.sql.add('Select sum(QTD.N_QTD_PRO) Qdade, sum(QTD.N_QTD_RES) QdadeRes, ' +
                     ' sum(isnull(QTD.N_QTD_PRO,0) - isnull(QTD.N_QTD_RES,0)) QdadeReal ' +
                     ' from CadProdutos pro, MovQdadeProduto Qtd ');
        soma.sql.add(' where Qtd.I_Seq_Pro = Pro.I_Seq_Pro ' );
  AdicionaFiltrosProduto(soma.Sql);
  soma.Open;
  numerico1.AValor := Soma.fieldByName('qdade').AsCurrency;
  numerico2.AValor := Soma.fieldByName('qdadeRes').AsCurrency;
  numerico3.AValor := Soma.fieldByName('qdadeReal').AsCurrency;
end;

{******************* adiciona os filtros da consulta **************************}
procedure TFEstoqueProdutosAtual.AdicionaFiltrosProduto(VpaSelect : TStrings);
begin
  if EFilial.Text <> '' then
    VpaSelect.add(' and Qtd.I_Emp_Fil = ' + EFilial.text) else VpaSelect.add(' ');
  if ENomeProduto.text <> '' Then
    VpaSelect.Add('and Pro.C_Nom_Pro like '''+ENomeProduto.text +'%''') else VpaSelect.add(' ');
  if EClassificacaoProduto.text <> ''Then
    VpaSelect.add(' and Pro.C_Cod_Cla like '''+ EClassificacaoProduto.text+ '%''') else VpaSelect.add(' ');
  if CProAti.Checked then
    VpaSelect.add(' and Pro.C_Ati_Pro = ''S''') else VpaSelect.add(' ');
  if CZerada.Checked then
    VpaSelect.add(' and isnull(Qtd.n_qtd_pro,0) <> 0 ') else VpaSelect.add(' ');
end;


{ ******************* chama o formulario para visualizar kit **************** }
procedure TFEstoqueProdutosAtual.BKitClick(Sender: TObject);
begin
   FProdutosKit := TFProdutosKit.CriarSDI(Application,'',FPrincipal.VerificaPermisao('FProdutosKit'));
   FProdutosKit.MostraKit(CadProdutosI_Seq_Pro.Asstring,Varia.CodigoEmpFil);
end;

{ ****************** Na criação do Formulário ******************************** }
procedure TFEstoqueProdutosAtual.FormCreate(Sender: TObject);
begin
  GProdutos.Columns[4].Visible := Config.MostrarReservado;
  EFilial.Text := IntTostr(varia. CodigoEmpFil);
  EFilial.Atualiza;
  GProdutos.Columns[0].FieldName := varia.CodigoProduto;
  AtualizaConsulta;
end;


{ ******************* Quando o formulario e fechado ************************** }
procedure TFEstoqueProdutosAtual.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := CaFree;
end;


procedure TFEstoqueProdutosAtual.BFecharClick(Sender: TObject);
begin
  self.close;
end;


procedure TFEstoqueProdutosAtual.CadProdutosAfterScroll(DataSet: TDataSet);
begin
  if CadProdutosC_KIT_PRO.AsString = 'K' then
    bkit.Enabled := true
  else
    bkit.Enabled := false;
end;

procedure TFEstoqueProdutosAtual.ENomeProdutoEnter(Sender: TObject);
begin
  BFechar.Default := false;
end;

procedure TFEstoqueProdutosAtual.BitBtn1Click(Sender: TObject);
begin
  FImprimeEstoqueProduto := TFImprimeEstoqueProduto.CriarSDI(application, '', true);
  FImprimeEstoqueProduto.carregaImpressao( CadProdutos.SQL.Text, Varia.NomeEmpresa, label25.Caption,
                                           FormatFloat(varia.MascaraValor, numerico1.avalor),
                                           FormatFloat(varia.MascaraValor, numerico2.avalor),
                                           FormatFloat(varia.MascaraValor, numerico3.avalor),
                                           EClassificacaoProduto.Text);
end;

procedure TFEstoqueProdutosAtual.EFilialRetorno(Retorno1,
  Retorno2: String);
begin
  AtualizaConsulta;
end;

procedure TFEstoqueProdutosAtual.BBAjudaClick(Sender: TObject);
begin
    Application.HelpCommand(HELP_CONTEXT,FEstoqueProdutosAtual.HelpContext);
end;

procedure TFEstoqueProdutosAtual.FormShow(Sender: TObject);
begin
  Self.HelpFile := Varia.PathHelp + 'MEstoqueCusto.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
  GProdutos.AListaCAmpos.clear;
  GProdutos.AListaCAmpos.Add(Varia.CodigoProduto);
  GProdutos.AListaCAmpos.Add('c_nom_pro');
end;

Initialization
{ *************** Registra a classe para evitar duplicidade ****************** }
 RegisterClasses([TFEstoqueProdutosAtual]);
end.
