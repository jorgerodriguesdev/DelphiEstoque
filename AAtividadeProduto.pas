unit AAtividadeProduto;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Buttons, Componentes1, ExtCtrls, PainelGradiente, Db, DBTables,
  Grids, DBGrids, Tabela, DBKeyViolation, Localizacao, Spin;

type
  TFAtividadeProduto = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    BFechar: TBitBtn;
    BTirar: TBitBtn;
    GridIndice1: TGridIndice;
    CadProdutos: TQuery;
    DataCadProdutos: TDataSource;
    CadProdutosI_SEQ_PRO: TIntegerField;
    CadProdutosC_COD_PRO: TStringField;
    CadProdutosC_COD_UNI: TStringField;
    CadProdutosC_NOM_PRO: TStringField;
    CadProdutosC_ATI_PRO: TStringField;
    CadProdutosC_KIT_PRO: TStringField;
    CadProdutosC_Cod_Bar: TStringField;
    CadProdutosN_QTD_MIN: TFloatField;
    CadProdutosN_QTD_PRO: TFloatField;
    CadProdutosN_QTD_PED: TFloatField;
    CadProdutosN_VLR_VEN: TFloatField;
    CadProdutosN_QTD_RES: TFloatField;
    CadProdutosQdadeReal: TFloatField;
    RAtividade: TRadioGroup;
    EClassificacaoProduto: TEditLocaliza;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    Localiza: TConsultaPadrao;
    Label3: TLabel;
    ENomeProduto: TEditColor;
    BColocar: TBitBtn;
    Aux: TQuery;
    ECodigo: TEditColor;
    Label4: TLabel;
    Label5: TLabel;
    EMesesMovimentacao: TSpinEditColor;
    CZerado: TCheckBox;
    Label6: TLabel;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RAtividadeClick(Sender: TObject);
    procedure BFecharClick(Sender: TObject);
    procedure ENomeProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EClassificacaoProdutoSelect(Sender: TObject);
    procedure BColocarClick(Sender: TObject);
    procedure BTirarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
  private
    { Private declarations }
    procedure AtualizaConsulta(VpaGuardar:Boolean = false);
    procedure AdicionaFiltros(VpaSelect : TStrings);
    procedure ColocaEmAtividade;
    procedure TiraAtividade;
  public
    { Public declarations }
  end;

var
  FAtividadeProduto: TFAtividadeProduto;

implementation

uses APrincipal,Constantes, UnProdutos, FunSql, funData;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFAtividadeProduto.FormCreate(Sender: TObject);
begin
  {  abre tabelas }
  { chamar a rotina de atualização de menus }
  Atualizaconsulta;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFAtividadeProduto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 { fecha tabelas }
 { chamar a rotina de atualização de menus }
 Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos da consulta
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{*********************** atualiza a consulta **********************************}
procedure TFAtividadeProduto.AtualizaConsulta(VpaGuardar:Boolean = false);
Var
  VpfPosicao : TBookMark;
begin
  if VpaGuardar then
    VpfPosicao := CadProdutos.GetBookmark;

  CadProdutos.sql.clear;
  CadProdutos.sql.add('Select '+ varia.CodigoProduto+ ' C_Cod_Pro, '+
                     ' Pro.I_SEQ_PRO,  Pro.C_COD_UNI,  Pro.C_NOM_PRO, ' +
                     ' Pro.C_ATI_PRO, Pro.C_KIT_PRO,  Qtd.C_Cod_Bar, ' +
                     ' Qtd.N_QTD_MIN, QTD.N_QTD_PRO, QTD.N_QTD_PED, ' +
                     ' (PRE.N_VLR_VEN * MOE.N_Vlr_Dia) N_VLR_VEN, QTD.N_QTD_RES, ' +
                     ' (QTD.N_QTD_PRO - QTD.N_QTD_RES) QdadeReal ' +
                     ' from dba.CadProdutos pro, MovQdadeProduto Qtd, MovTabelaPreco Pre, ' +
                     ' CadMoedas Moe');
  AdicionaFiltros(Cadprodutos.Sql);
  CadProdutos.sql.add(' and Pre.I_Cod_Tab = ' + IntToStr(Varia.TabelaPreco)+
                      ' and Qtd.I_Emp_Fil = '+ IntToStr(Varia.CodigoEmpFil)+
                      ' and Qtd.I_Seq_Pro = Pro.I_Seq_Pro '+
                      ' and Pre.I_Cod_Emp = Pro.I_Cod_Emp '+
                      ' and Pre.I_Seq_Pro = Pro.I_Seq_Pro '+
                      ' and Moe.I_Cod_Moe = Pro.I_Cod_Moe');
  CadProdutos.Open;
  if VpaGuardar then
  begin
    CadProdutos.GotoBookmark(VpfPosicao);
    CadProdutos.FreeBookmark(vpfPosicao);
  end;
end;

{***************** adiciona os filtros da consulta ****************************}
procedure TFAtividadeProduto.AdicionaFiltros(VpaSelect : TStrings);
begin
  VpaSelect.Add(' Where Pro.I_Cod_Emp = ' + IntToStr(Varia.CodigoEmpresa));

  case RAtividade.ItemIndex of
    0 : VpaSelect.add('and Pro.C_Ati_Pro = ''S''');
    1 : VpaSelect.add('and Pro.C_Ati_Pro = ''N''');
  end;
  if EClassificacaoProduto.Text <> '' Then
    VpaSelect.Add('and Pro.C_Cod_Cla like ''' + EClassificacaoProduto.Text+'%''');

  if ENomeProduto.text <>'' Then
    VpaSelect.add('and Pro.C_Nom_Pro like ''' + ENomeProduto.Text +'%''');

  if ECodigo.Text <> '' Then
    VpaSelect.Add('And ' + Varia.CodigoProduto + '= ' + ECodigo.text);

  {if CZerado.Checked then
      VpaSelect.Add(' And Pro.I_Seq_Pro in (select i_seq_pro from movqdadeproduto Qtd '+
                    ' Where Pro.I_Seq_Pro = Qtd.I_Seq_Pro '+
                    ' and IsNull(Qtd.n_qtd_pro,0) = 0 )')}

  if EMesesMovimentacao.Value > 0 then
    VpaSelect.Add(' and Pro.I_Seq_Pro in ( Select I_Seq_Pro from MovEstoqueProdutos '+
                   ' group by I_Seq_Pro '+
                   ' Having max(D_Dat_Mov) <='+ SQLTextoDataAAAAMMMDD(DecMes(Date,EMesesMovimentacao.Value))+')');

end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos da atividade
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************** coloca os produtos em atividade ***************************}
procedure TFAtividadeProduto.ColocaEmAtividade;
var
  Produto : TFuncoesProduto;
begin
  if ECodigo.TExt <> '' then
  begin
    Produto := TFuncoesProduto.criar(Self,FPrincipal.BaseDados);
    Produto.ColocaProdutoEmAtividade(CadProdutosI_SEQ_PRO.AsString);
    Produto.free;
  end
  else
  begin
    Aux.Sql.Clear;
    aux.Sql.Add('Update CadProdutos pro '+
                ' Set C_Ati_Pro = ''S''');
    // d_ult_alt
    AdicionaFiltros(Aux.Sql);
    Aux.ExecSql;
  end;
  AtualizaConsulta;
end;

{***************** tira os produtos de atividade ******************************}
procedure TFAtividadeProduto.TiraAtividade;
var
  Produto : TFuncoesProduto;
begin
  if ECodigo.TExt <> '' then
  begin
    Produto := TFuncoesProduto.criar(Self,FPrincipal.BaseDados);
    Produto.TiraProdutoAtividade(CadProdutosI_SEQ_PRO.AsString);
    Produto.free;
  end
  else
  begin
    Aux.Sql.Clear;
    aux.Sql.Add('Update CadProdutos pro '+
                ' Set C_Ati_Pro = ''N''');
    AdicionaFiltros(Aux.Sql);
    Aux.ExecSql;
  end;
  AtualizaConsulta;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                         eventos dos filtros superiores
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{************* chama a rotina para atualiza a consulta ************************}
procedure TFAtividadeProduto.RAtividadeClick(Sender: TObject);
begin
  AtualizaConsulta;
end;

{******************** quando pressiona enter **********************************}
procedure TFAtividadeProduto.ENomeProdutoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case key of
    13 : AtualizaConsulta;
  end;
end;

{****************** carrega a select da classificacao *************************}
procedure TFAtividadeProduto.EClassificacaoProdutoSelect(Sender: TObject);
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

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos diversos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}


{******************** fecha o formulario corrente *****************************}
procedure TFAtividadeProduto.BFecharClick(Sender: TObject);
begin
  close;
end;

{************** chama a rotina que coloca os produtos em atividade ************}
procedure TFAtividadeProduto.BColocarClick(Sender: TObject);
begin
  ColocaEmAtividade;
end;

{***************** tira os produtos de atividade *****************************}
procedure TFAtividadeProduto.BTirarClick(Sender: TObject);
begin
  TiraAtividade;
end;

procedure TFAtividadeProduto.FormShow(Sender: TObject);
begin
  Self.HelpFile := Varia.PathHelp + 'MEstoqueCusto.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
end;

procedure TFAtividadeProduto.BBAjudaClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,FAtividadeProduto.HelpContext);
end;

Initialization
{ *************** Registra a classe para evitar duplicidade ****************** }
 RegisterClasses([TFAtividadeProduto]);
end.
