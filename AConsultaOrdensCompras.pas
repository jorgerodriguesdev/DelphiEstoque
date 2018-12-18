unit AConsultaOrdensCompras;

//                Autor: Leonardo Emanuel Pretti
//      Data da Criação: 30/08/2001
//               Função: Consultar Uma Ordem de Compras
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
  TFConsultaOrdensCompras = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    LocalizaFornecedor: TEditLocaliza;
    Label1: TLabel;
    Label2: TLabel;
    Localiza: TConsultaPadrao;
    SpeedButton1: TSpeedButton;
    CadCompras: TQuery;
    DataCadCompras: TDataSource;
    PanelColor2: TPanelColor;
    BotaoFechar1: TBitBtn;
    BBAjuda: TBitBtn;
    BtCadastrar: TBitBtn;
    BtCancelar: TBitBtn;
    BBImprimir: TBitBtn;
    Grade_1: TGridIndice;
    Label5: TLabel;
    LocalizaSituacao: TEditLocaliza;
    SpeedButton2: TSpeedButton;
    Label6: TLabel;
    Label7: TLabel;
    Tipo: TComboBoxColor;
    Label8: TLabel;
    DataMovCompras: TDataSource;
    MovCompras: TQuery;
    DBMemoColor1: TDBMemoColor;
    NumOrdem: TEditColor;
    Label9: TLabel;
    Label10: TLabel;
    Datas: TComboBoxColor;
    Data1: TCalendario;
    Data2: TCalendario;
    CadComprasI_COD_COM: TIntegerField;
    CadComprasI_EMP_FIL: TIntegerField;
    CadComprasI_COD_CLI: TIntegerField;
    CadComprasD_DAT_CAD: TDateField;
    CadComprasD_DAT_PRE: TDateField;
    CadComprasD_DAT_ENV: TDateField;
    CadComprasC_SIT_COM: TStringField;
    CadComprasI_COD_SIT: TIntegerField;
    CadComprasC_OBS_COM: TMemoField;
    CadComprasC_CON_COM: TMemoField;
    CadComprasT_HOR_ENV: TTimeField;
    CadComprasT_HOR_PRE: TTimeField;
    MovComprasI_COD_COM: TIntegerField;
    MovComprasI_EMP_FIL: TIntegerField;
    MovComprasI_SEQ_PRO: TIntegerField;
    MovComprasC_COD_UNI: TStringField;
    MovComprasC_COD_PRO: TStringField;
    MovComprasN_QTD_PRO: TFloatField;
    CadComprasD_ULT_ALT: TDateField;
    MovComprasD_ULT_ALT: TDateField;
    MovComprasN_VLR_IPI: TFloatField;
    MovComprasN_VLR_ICM: TFloatField;
    MovComprasN_VLR_TOT: TFloatField;
    MovComprasN_VLR_UNI: TFloatField;
    Aux: TQuery;
    CadComprasC_NOM_CLI: TStringField;
    CadComprasC_NOM_SIT: TStringField;
    BtRecebido: TBitBtn;
    PanelColor5: TPanelColor;
    Label12: TLabel;
    PanelColor4: TPanelColor;
    Label13: TLabel;
    Produto: TQuery;
    ProdutoI_SEQ_PRO: TIntegerField;
    ProdutoC_COD_PRO: TStringField;
    ProdutoC_NOM_PRO: TStringField;
    MovComprasProduto: TStringField;
    Relatorio: TCrpe;
    Grade: TDBGridColor;
    PanelColor3: TPanelColor;
    Label3: TLabel;
    Label4: TLabel;
    Label11: TLabel;
    TotCom: Tnumerico;
    TotICM: Tnumerico;
    TotIPI: Tnumerico;
    CadComprasN_TOT_COM: TFloatField;
    CadComprasN_TOT_IPI: TFloatField;
    CadComprasN_TOT_ICM: TFloatField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BotaoFechar1Click(Sender: TObject);
    procedure LocalizaFornecedorRetorno(Retorno1, Retorno2: String);
    procedure BBImprimirClick(Sender: TObject);
    procedure BtCadastrarClick(Sender: TObject);
    procedure BtCancelarClick(Sender: TObject);
    procedure CadComprasAfterScroll(DataSet: TDataSet);
    procedure NumOrdemExit(Sender: TObject);
    procedure BtRecebidoClick(Sender: TObject);
  private
    UnCompras : TFuncoesCompras;
    procedure AdicionaFiltros (VPaSelect: Tstrings);
    procedure AtualizaConsulta;
  public
  end;

var
  FConsultaOrdensCompras: TFConsultaOrdensCompras;

implementation

uses APrincipal, Constantes, fundata, funstring, constmsg, funObjeto,
     FunSql, funnumeros, UnImpressao, UnClassesImprimir, ACadCompras;

{$R *.DFM}

{ ****************** Na criação do Formulário ******************************** }
procedure TFConsultaOrdensCompras.FormCreate(Sender: TObject);
begin
  Data1.DateTime := PrimeiroDiaMes(Date);
  Data2.DateTime := UltimoDiaMes(Date);
  LimpaEdits(PanelColor1);
  Datas.ItemIndex := 0; // CADASTRO
  Tipo.ItemIndex := 0;  // ABERTAS
  AtualizaConsulta;     // CHAMA PROCEDURE PARA ATUALIZAR OS GRIDS
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFConsultaOrdensCompras.FormClose(Sender: TObject;  var Action: TCloseAction);
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
procedure TFConsultaOrdensCompras.AtualizaConsulta;
begin
  LimpaSQLTabela(CadCompras);
  AdicionaSQLTabela(CadCompras,'Select Cad.I_COD_COM, Cad.I_EMP_FIL, Cad.I_COD_SIT, ' +
                               '       Cad.I_COD_CLI, Cad.C_CON_COM, Cad.C_OBS_COM, ' +
                               '       Cad.D_DAT_ENV, Cad.T_HOR_ENV, Cad.D_DAT_CAD, ' +
                               '       Cad.D_DAT_PRE, Cad.T_HOR_PRE, Cad.D_ULT_ALT, ' +
                               '       Cad.C_SIT_COM, Cad.N_TOT_COM, Cad.N_TOT_IPI, ' +
                               '       Cad.N_TOT_ICM, Cli.I_COD_CLI, Cli.C_NOM_CLI, ' +
                               '       Sit.I_COD_SIT, Sit.C_NOM_SIT  ' +
                               ' From CadCompras   as Cad, ' +
                               '      CadClientes  as Cli, ' +
                               '      CadSituacoes as Sit  ' );
  AdicionaFiltros(CadCompras.SQL);
  AdicionaSQLTabela(CadCompras,' and Cad.I_COD_CLI = Cli.I_COD_CLI ' +
                               ' and Cad.I_COD_SIT = Sit.I_COD_SIT ' );
  AdicionaSQLTabela(CadCompras,' Order By CAD.I_COD_COM');
  AbreTabela(CadCompras);
  TotCom.AValor := CadComprasN_TOT_COM.AsFloat;
  TotIPI.AValor := CadComprasN_TOT_IPI.AsFloat;
  TotICM.AValor := CadComprasN_TOT_ICM.AsFloat;
end;

{***************************** Adiciona Filtros *******************************}
procedure TFConsultaOrdensCompras.AdicionaFiltros(VPaSelect: TStrings);
begin
  VPaSelect.Add(' Where Cad.I_EMP_FIL = ' + IntToStr(Varia.CodigoEmpFil));
                  // CODIGO DA FILIAL
  if NumOrdem.Text <> '' then
    VpaSelect.Add(' and Cad.I_COD_COM = ''' + NumOrdem.text + '''')
  else           // CODIGO DA COMPRA
    VpaSelect.Add(' ');

  case Datas.ItemIndex of
   0 : VpaSelect.Add(SQLTextoDataEntreAAAAMMDD('Cad.D_DAT_CAD', data1.DateTime, data2.DateTime, true));
                                               // DATA DE CADASTRO
   1 : VpaSelect.Add(SQLTextoDataEntreAAAAMMDD('Cad.D_DAT_APR', data1.DateTime, data2.DateTime, true));
                                               // DATA DE APROVACAO
   2 : VpaSelect.Add(SQLTextoDataEntreAAAAMMDD('Cad.D_DAT_PRE', data1.DateTime, data2.DateTime, true));
                                               // DATA DA PREVISAO DE ENTREGA
  end;

  case Tipo.ItemIndex of
    0 : VpaSelect.Add(' and Cad.C_SIT_COM = ''A'''); //ABERTAS
    1 : VpaSelect.Add(' and Cad.C_SIT_COM = ''E'''); //ENVIADAS
  end;

  if LocalizaFornecedor.Text <> '' then
    VpaSelect.Add(' and Cad.I_COD_CLI = ' + LocalizaFornecedor.Text)
  else              // CODIGO DO FORNECEDOR
    VpaSelect.Add(' ');

  if LocalizaSituacao.Text <> '' then
    VpaSelect.Add(' and Cad.I_COD_SIT = ' + LocalizaSituacao.Text)
  else              // CODIGO DA SITUACAO
    VpaSelect.Add(' ');

end;

{****************** Localiza MovCompras Conforme a CadCompras *****************}
procedure TFConsultaOrdensCompras.CadComprasAfterScroll(DataSet: TDataSet);
begin
  if not CadCompras.Eof then   // SE A CADCOMPRAS "NAO ESTIVER" VAZIA
   begin
    LimpaSQLTabela(MovCompras);
    UnCompras.LocalizaMovCompras(MovCompras, CadComprasI_EMP_FIL.AsInteger,
                                             CadComprasI_COD_COM.AsInteger);
    AbreTabela(MovCompras);// Chama Procedure da UNCOMPRAS Os materiais de cada ordem de compra
    BBImprimir.Enabled := True;
   end
  else
   begin
    FechaTabela(MovCompras);
    BBImprimir.Enabled := False;
   end;
end;

{|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                                ATUALIZA AS TABELAS
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||}

{**************************** Atualiza Consulta *******************************}
procedure TFConsultaOrdensCompras.LocalizaFornecedorRetorno(Retorno1, Retorno2: String);
begin
  AtualizaConsulta;   //CHAMA PROCEDURE PARA ATUALIZAR OS GRIDS
end;

{**************************** Atualiza Consulta *******************************}
procedure TFConsultaOrdensCompras.NumOrdemExit(Sender: TObject);
begin
  AtualizaConsulta; //CHAMA PROCEDURE PARA ATUALIZAR OS GRIDS
end;

{|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
        EVENTOS DE CADASTRO, CANCELAMENTO E EXCLUSÃO DE UMA ORDEM DECOMPRA
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||}

{******************* Abre a Tela de Compra Ja Cadastrando *********************}
procedure TFConsultaOrdensCompras.BtCadastrarClick(Sender: TObject);
begin
  FCadCompras := TFCadCompras.CriarSDI(Application,'',FPrincipal.VerificaPermisao('FCadCompras'));
  FCadCompras.ShowModal;    //ABRE A TELA PARA CADASTRAR NOVAS COMPRAS
  AtualizaConsulta;         //CHAMA PROCEDURE PARA ATUALIZAR OS GRIDS
end;

{************************** Exclui Uma Ordem de Compra ************************}
procedure TFConsultaOrdensCompras.BtRecebidoClick(Sender: TObject);
begin
if confirmacao('EXCLUIR - Deseja Realmente Excluir esta Ordem de Compras?') Then
 if SenhaDeLiberacao then    // EXCLUI UM ORÇAMENTO DE COMPRA MEDIANTE SENHA
  begin
   UnCompras.ExcluirTodaCompra(Aux, CadComprasI_EMP_FIL.AsInteger,   // Passa os Parametros
                                    CadComprasI_COD_COM.AsInteger);
   AtualizaConsulta;       //CHAMA PROCEDURE PARA ATUALIZAR OS GRIDS
  end
end;

{************************* Cancela Uma Ordem de Compra ************************}
procedure TFConsultaOrdensCompras.BtCancelarClick(Sender: TObject);
begin
if confirmacao('CANCELAR - Deseja Realmente Cancelar esta Ordem de Compras?') Then
 if SenhaDeLiberacao then    // CANCELA UM ORÇAMENTO DE COMPRA MEDIANTE SENHA
  begin
   UnCompras.CancelaTodaCompra(Aux, CadComprasI_COD_COM.AsInteger,  // Passa os Parametros
                                    CadComprasI_EMP_FIL.AsInteger);
   AtualizaConsulta;       //CHAMA PROCEDURE PARA ATUALIZAR OS GRIDS
  end;
end;

{*************************************** Recebe Parâmetro Imprime Req **********************}
procedure TFConsultaOrdensCompras.BBImprimirClick(Sender: TObject);
begin
 Relatorio.Connect.Retrieve;
 Relatorio.Connect.DatabaseName := varia.AliasBAseDados;
 Relatorio.Connect.ServerName := varia.AliasRelatorio;
 Relatorio.WindowState := wsMaximized;
 Relatorio.ParamFields.Retrieve;
 Relatorio.ParamFields[0].Value := IntToStr(Varia.CodigoEmpFil);
 Relatorio.ParamFields[1].Value := IntToStr(CadComprasI_COD_COM.AsInteger);
 Relatorio.ParamFields[2].Value := IntToStr(Dia(Data1.DateTime));
 Relatorio.ParamFields[3].Value := IntToStr(Mes(Data1.DateTime));
 Relatorio.ParamFields[4].Value := IntToStr(Ano4Digito(Data1.DateTime));
 Relatorio.ParamFields[5].Value := IntToStr(Dia(Data2.DateTime));
 Relatorio.ParamFields[6].Value := IntToStr(Mes(Data2.DateTime));
 Relatorio.ParamFields[7].Value := IntToStr(Ano4Digito(Data2.DateTime));
 Relatorio.ParamFields[8].Value := '2';
 Relatorio.Execute;
end;

{*********************** Fecha o Formulário Corrente **************************}
procedure TFConsultaOrdensCompras.BotaoFechar1Click(Sender: TObject);
begin
  Self.Close;  // FECHA A TELA
end;

Initialization
  RegisterClasses([TFConsultaOrdensCompras]);
end.
