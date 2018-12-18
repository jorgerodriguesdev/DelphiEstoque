unit ARetornoOrcamento;

//                Autor: Leonardo Emanuel Pretti
//      Data da Criação: 02/09/2001
//               Função: Recebe do Fornecedor um Orçamento de Compra
//         Alterado por:
//    Data da Alteração:
//  Motivo da Alteração:

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Buttons, BotaoCadastro, Componentes1, ExtCtrls, PainelGradiente,
  Localizacao, Grids, DBGrids, Tabela, DBKeyViolation, Db, DBTables, UnCompras,
  ComCtrls, Mask, numericos, DBCtrls, UCrpe32;

type
  TFRetornoOrcamento = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    LocalizaOrcamento: TEditLocaliza;
    Label1: TLabel;
    Label2: TLabel;
    Localiza: TConsultaPadrao;
    SpeedButton1: TSpeedButton;
    CadCompras: TQuery;
    DataCadCompras: TDataSource;
    PanelColor2: TPanelColor;
    BotaoFechar1: TBitBtn;
    BBAjuda: TBitBtn;
    BtCancelar: TBitBtn;
    DataMovCompras: TDataSource;
    MovCompras: TQuery;
    MovComprasI_COD_COM: TIntegerField;
    MovComprasI_EMP_FIL: TIntegerField;
    MovComprasI_SEQ_PRO: TIntegerField;
    MovComprasC_COD_UNI: TStringField;
    MovComprasC_COD_PRO: TStringField;
    MovComprasN_QTD_PRO: TFloatField;
    MovComprasD_ULT_ALT: TDateField;
    MovComprasN_VLR_IPI: TFloatField;
    MovComprasN_VLR_ICM: TFloatField;
    MovComprasN_VLR_TOT: TFloatField;
    MovComprasN_VLR_UNI: TFloatField;
    Aux: TQuery;
    BtGravar: TBitBtn;
    PanelColor5: TPanelColor;
    Label12: TLabel;
    Produto: TQuery;
    ProdutoI_SEQ_PRO: TIntegerField;
    ProdutoC_COD_PRO: TStringField;
    ProdutoC_NOM_PRO: TStringField;
    MovComprasProduto: TStringField;
    Relatorio: TCrpe;
    PanelColor3: TPanelColor;
    PanelColor4: TPanelColor;
    TotCom: Tnumerico;
    Label3: TLabel;
    Grade: TDBGridColor;
    Label4: TLabel;
    TotICM: Tnumerico;
    Label5: TLabel;
    TotIPI: Tnumerico;
    CadComprasI_COD_COM: TIntegerField;
    CadComprasI_EMP_FIL: TIntegerField;
    CadComprasI_COD_CLI: TIntegerField;
    CadComprasD_ULT_ALT: TDateField;
    CadComprasD_DAT_CAD: TDateField;
    CadComprasD_DAT_PRE: TDateField;
    CadComprasD_DAT_ENV: TDateField;
    CadComprasC_SIT_COM: TStringField;
    CadComprasI_COD_SIT: TIntegerField;
    CadComprasC_OBS_COM: TMemoField;
    CadComprasC_CON_COM: TMemoField;
    CadComprasT_HOR_ENV: TTimeField;
    CadComprasT_HOR_PRE: TTimeField;
    CadComprasI_COD_PAG: TIntegerField;
    CadComprasN_TOT_IPI: TFloatField;
    CadComprasN_TOT_ICM: TFloatField;
    CadComprasN_TOT_COM: TFloatField;
    CadComprasD_DAT_APR: TDateField;
    CadComprasT_HOR_APR: TTimeField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BotaoFechar1Click(Sender: TObject);
    procedure LocalizaOrcamentoRetorno(Retorno1, Retorno2: String);
    procedure BtCancelarClick(Sender: TObject);
    procedure LocalizaOrcamentoSelect(Sender: TObject);
    procedure GradeEnter(Sender: TObject);
    procedure GradeExit(Sender: TObject);
    procedure BtGravarClick(Sender: TObject);
    procedure MovComprasAfterPost(DataSet: TDataSet);
    procedure MovComprasAfterEdit(DataSet: TDataSet);
    procedure MovComprasAfterScroll(DataSet: TDataSet);
    procedure MovComprasBeforeScroll(DataSet: TDataSet);
    procedure MovComprasBeforePost(DataSet: TDataSet);
  private
    UnCompras : TFuncoesCompras;
    procedure AtualizaConsulta;
  public
  end;

var
  FRetornoOrcamento: TFRetornoOrcamento;

implementation

uses APrincipal, Constantes, fundata, funstring, constmsg, funObjeto,
     FunSql, funnumeros, UnImpressao, UnClassesImprimir, ACadCompras;

{$R *.DFM}

{ ****************** Na criação do Formulário ******************************** }
procedure TFRetornoOrcamento.FormCreate(Sender: TObject);
begin
  LimpaEdits(PanelColor1);
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFRetornoOrcamento.FormClose(Sender: TObject;  var Action: TCloseAction);
begin
  CadCompras.Close;  // FECHA TABELAS E UNCOMPRAS
  MovCompras.Close;
  UnCompras.Free;
  Action := caFree;
end;

{|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                                DAS TABELAS
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||}

{**************************** Atualiza Consulta *******************************}
procedure TFRetornoOrcamento.AtualizaConsulta;
begin
  LimpaSQLTabela(MovCompras);
  UnCompras.LocalizaMovCompras(MovCompras, Varia.CodigoEmpFil,StrToInt(LocalizaOrcamento.Text));
  AbreTabela(MovCompras);// Chama Procedure da UNCOMPRAS Os materiais de cada ordem de compra
end;

{|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                                ATUALIZA AS TABELAS
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||}

{**************************** Atualiza Consulta *******************************}
procedure TFRetornoOrcamento.LocalizaOrcamentoRetorno(Retorno1, Retorno2: String);
begin
  if Retorno1 <> '' then
   begin
     AtualizaConsulta;   //CHAMA PROCEDURE PARA ATUALIZAR OS GRIDS
     Grade.SetFocus;
   end;
end;

{|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
        EVENTOS DE CADASTRO, CANCELAMENTO E EXCLUSÃO DE UMA ORDEM DECOMPRA
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||}

{************************* Cancela Uma Ordem de Compra ************************}
procedure TFRetornoOrcamento.BtCancelarClick(Sender: TObject);
begin
  MovCompras.Cancel;
end;

procedure TFRetornoOrcamento.LocalizaOrcamentoSelect(Sender: TObject);
begin
  LocalizaOrcamento.ASelectValida.Clear;
  LocalizaOrcamento.ASelectValida.add(' Select COM.I_COD_COM, CLI.C_NOM_CLI '+
                                      ' From CadCompras as COM, CadClientes as Cli '+
                                      ' Where  COM.I_COD_CLI = CLI.I_COD_CLI '+
                                      '  and  CLI.I_COD_CLI = ''@''' +
                                      '  and  COM.C_SIT_COM = ''E'' ');
  LocalizaOrcamento.ASelectLocaliza.Clear;
  LocalizaOrcamento.ASelectLocaliza.add(' Select COM.I_COD_COM, CLI.C_NOM_CLI '+
                                        ' From CadCompras as COM, CadClientes as Cli '+
                                        ' Where COM.I_COD_CLI = CLI.I_COD_CLI '+
                                        '  and  CLI.C_NOM_CLI like ''@%''' +
                                        '  and  COM.C_SIT_COM = ''E'' ');
end;

procedure TFRetornoOrcamento.GradeEnter(Sender: TObject);
begin
  MovCompras.Edit;
end;

procedure TFRetornoOrcamento.GradeExit(Sender: TObject);
begin
  if MovCompras.State in [dsEdit] then
    MovCompras.Post;
end;

procedure TFRetornoOrcamento.BtGravarClick(Sender: TObject);
begin
  MovCompras.Post;
end;

procedure TFRetornoOrcamento.MovComprasAfterPost(DataSet: TDataSet);
begin
   AlterarEnabledDet([BtGravar, BtCancelar],false);
end;

procedure TFRetornoOrcamento.MovComprasAfterEdit(DataSet: TDataSet);
begin
 AlterarEnabledDet([BtGravar, BtCancelar],true);
end;

procedure TFRetornoOrcamento.MovComprasAfterScroll(DataSet: TDataSet);
begin
  if not MovCompras.Eof then
    MovCompras.Edit;
end;

procedure TFRetornoOrcamento.MovComprasBeforeScroll(DataSet: TDataSet);
var
 ICMS, IPI, TOTAL : Double;
begin
  MovCompras.Edit;
  MovComprasN_VLR_TOT.AsFloat := MovComprasN_VLR_IPI.AsFloat + MovComprasN_VLR_ICM.AsFloat +
                                (MovComprasN_QTD_PRO.AsFloat * MovComprasN_VLR_UNI.AsFloat);
  MovCompras.Post;
  LimpaSQLTabela(CadCompras);
  AdicionaSQLAbreTabela(CadCompras,'Select * from cadcompras where I_COD_COM = '+ IntToStr(MovComprasI_COD_COM.AsInteger));
  CadCompras.Edit;
  UnCompras.SomaValores(ICMS, IPI, TOTAL, Aux, MovComprasI_COD_COM.AsInteger,
                                       MovComprasI_EMP_FIL.AsInteger);
  TotICM.AValor := ICMS;
  TotIPI.AValor := IPI;
  TotCom.AValor := TOTAL;
  CadComprasN_TOT_IPI.AsFloat := IPI;
  CadComprasN_TOT_ICM.AsFloat := ICMS;
  CadComprasN_TOT_COM.AsFloat := TOTAL;
  CadCompras.Post;
end;

procedure TFRetornoOrcamento.MovComprasBeforePost(DataSet: TDataSet);
begin
end;

{*********************** Fecha o Formulário Corrente **************************}
procedure TFRetornoOrcamento.BotaoFechar1Click(Sender: TObject);
begin
  Self.Close;  // FECHA A TELA
end;

Initialization
  RegisterClasses([TFRetornoOrcamento]);
end.
