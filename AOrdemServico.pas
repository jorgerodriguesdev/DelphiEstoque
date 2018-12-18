unit AOrdemServico;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  ComCtrls, PainelGradiente, StdCtrls, Buttons, ExtCtrls, Componentes1,
  Mask, DBCtrls, Tabela, Localizacao, Db, DBTables, DBKeyViolation, UnNotaFiscal,
  Grids, DBGrids, UnProdutos, BotaoCadastro, UnOrdemServico, numericos,
  UCrpe32;

type
  TFOrdemServico = class(TFormularioPermissao)
    PanelColor2: TPanelColor;
    BFechar: TBitBtn;
    BBAjuda: TBitBtn;
    Paginas: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Localiza: TConsultaPadrao;
    cadClientes: TQuery;
    DataClientes: TDataSource;
    CadOS: TSQL;
    DataCadOS: TDataSource;
    CadOSI_EMP_FIL: TIntegerField;
    CadOSI_COD_ORS: TIntegerField;
    CadOSI_COD_SIT: TIntegerField;
    CadOSI_COD_CLI: TIntegerField;
    CadOSI_SEQ_PRO: TIntegerField;
    CadOSD_DAT_CAD: TDateField;
    CadOSD_DAT_AGE: TDateField;
    CadOSH_HOR_AGE: TTimeField;
    CadOSC_CLI_PRO: TStringField;
    CadOSC_OBS_EQU: TStringField;
    CadOSN_TEM_GAS: TFloatField;
    CadOSN_VLR_HOR: TFloatField;
    CadOSI_COD_FRM: TIntegerField;
    CadOSI_COD_PAG: TIntegerField;
    CadOSD_DAT_FEC: TDateField;
    CadOSC_CLI_REC: TStringField;
    CadOSD_DAT_EMP: TDateField;
    CadOSD_DAT_DEV: TDateField;
    ProximoCodigoFilial1: TProximoCodigoFilial;
    cadClientesc_nom_cli: TStringField;
    cadClientesc_cgc_cli: TStringField;
    cadClientesc_cpf_cli: TStringField;
    cadClientesc_ins_cli: TStringField;
    cadClientesenderco: TStringField;
    cadClientesC_Bai_Cli: TStringField;
    cadClientesC_Cep_Cli: TStringField;
    cadClientesMunicipio: TStringField;
    cadClientesfone: TStringField;
    CadOSC_COD_PRO: TStringField;
    Label37: TLabel;
    DBEditColor10: TDBEditColor;
    MovOS: TQuery;
    DataMovOS: TDataSource;
    Grade: TDBGridColor;
    GServicos: TDBGridColor;
    Shape7: TShape;
    Shape8: TShape;
    MovOSI_EMP_FIL: TIntegerField;
    MovOSI_COD_ORS: TIntegerField;
    MovOSI_SEQ_MOV: TIntegerField;
    MovOSI_SEQ_PRO: TIntegerField;
    MovOSI_COD_EMP: TIntegerField;
    MovOSI_COD_SER: TIntegerField;
    MovOSI_COD_USU: TIntegerField;
    MovOSN_QTD_MOV: TFloatField;
    MovOSN_VLR_UNI: TFloatField;
    MovOSN_VLR_TOT: TFloatField;
    MovOSC_COD_UNI: TStringField;
    CadProdutos: TQuery;
    Produtos: TQuery;
    MovOSNomeProduto: TStringField;
    MovOSC_COD_PRO: TStringField;
    MovOSD_ULT_ALT: TDateField;
    CadOSD_ULT_ALT: TDateField;
    ECodServico: TDBEditLocaliza;
    MovOSServico: TQuery;
    StringField4: TStringField;
    DataMovOSServico: TDataSource;
    MovOSServicoI_EMP_FIL: TIntegerField;
    MovOSServicoI_COD_ORS: TIntegerField;
    MovOSServicoI_SEQ_MOV: TIntegerField;
    MovOSServicoI_SEQ_PRO: TIntegerField;
    MovOSServicoI_COD_EMP: TIntegerField;
    MovOSServicoI_COD_USU: TIntegerField;
    MovOSServicoN_QTD_MOV: TFloatField;
    MovOSServicoN_VLR_UNI: TFloatField;
    MovOSServicoN_VLR_TOT: TFloatField;
    MovOSServicoC_COD_UNI: TStringField;
    MovOSServicoC_COD_PRO: TStringField;
    MovOSServicoD_ULT_ALT: TDateField;
    MovOSServicoI_COD_SER: TIntegerField;
    CadOSL_OBS_MOV: TMemoField;
    Shape9: TShape;
    DBMemoColor1: TDBMemoColor;
    CadServico: TQuery;
    MovTerceiros: TSQl;
    DataMovTerceiros: TDataSource;
    MovTerceirosI_EMP_FIL: TIntegerField;
    MovTerceirosI_COD_ORS: TIntegerField;
    MovTerceirosI_SEQ_MOV: TIntegerField;
    MovTerceirosI_COD_CLI: TIntegerField;
    MovTerceirosD_DAT_COM: TDateField;
    MovTerceirosI_NOT_COM: TIntegerField;
    MovTerceirosI_NOT_REM: TIntegerField;
    MovTerceirosI_NOT_FOR: TIntegerField;
    MovTerceirosD_DAT_REM: TDateField;
    MovTerceirosD_DAT_RET: TDateField;
    MovTerceirosN_VLR_SER: TFloatField;
    Shape11: TShape;
    DBGridColor1: TDBGridColor;
    Shape12: TShape;
    DBEditColor19: TDBEditColor;
    Label49: TLabel;
    Label52: TLabel;
    DBEditColor18: TDBEditColor;
    CadOSC_SIT_ORS: TStringField;
    BitBtn2: TBitBtn;
    ImpResumo: TBitBtn;
    PanelColor1: TPanelColor;
    Label48: TLabel;
    EOS: TEditLocaliza;
    SpeedButton12: TSpeedButton;
    Label50: TLabel;
    ValidaGravacao1: TValidaGravacao;
    CadOSN_TOT_PRO: TFloatField;
    CadOSN_TOT_SER: TFloatField;
    Label51: TLabel;
    DBEditColor20: TDBEditColor;
    Label53: TLabel;
    DBEditColor21: TDBEditColor;
    Label54: TLabel;
    Label55: TLabel;
    DBEditColor23: TDBEditColor;
    CadOSN_TOT_TER: TFloatField;
    Total: TDBEditColor;
    Shape14: TShape;
    Label56: TLabel;
    AcrDes: TDBRadioGroup;
    EDescAcr: TDBEditNumerico;
    CadOSN_VLR_PER: TFloatField;
    CadOSC_DES_ACR: TStringField;
    CadOSN_TOT_ORS: TFloatField;
    Label34: TLabel;
    ECondPagamento: TDBEditLocaliza;
    SpeedButton8: TSpeedButton;
    EformaPgto: TDBEditLocaliza;
    SpeedButton9: TSpeedButton;
    Label57: TLabel;
    Label33: TLabel;
    Label36: TLabel;
    Label58: TLabel;
    DBEditColor22: TDBEditColor;
    CadOSN_TOT_HOR: TFloatField;
    MovTerceirosN_VLR_COB: TFloatField;
    Shape2: TShape;
    DBMemoColor2: TDBMemoColor;
    CadOSL_OBS_TER: TMemoField;
    MovTerceirosD_ULT_ALT: TDateField;
    BotaoGravar1: TBotaoGravar;
    BotaoCancelar1: TBotaoCancelar;
    BotaoCadastrar1: TBotaoCadastrar;
    BotaoAlterar2: TBotaoAlterar;
    Shape5: TShape;
    Shape4: TShape;
    Label21: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    DBText3: TDBText;
    DBText4: TDBText;
    DBText5: TDBText;
    DBText7: TDBText;
    Label22: TLabel;
    Label24: TLabel;
    DBText9: TDBText;
    DBText16: TDBText;
    DBText17: TDBText;
    DBText20: TDBText;
    SpeedButton1: TSpeedButton;
    Shape3: TShape;
    Label16: TLabel;
    SpeedButton7: TSpeedButton;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label23: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    DelCliente: TDBEditLocaliza;
    DBEditLocaliza6: TDBEditLocaliza;
    DBEditColor1: TDBEditColor;
    DBEditColor2: TDBEditColor;
    DBEditColor3: TDBEditColor;
    DBEditColor4: TDBEditColor;
    DBEditColor5: TDBEditColor;
    Shape15: TShape;
    Label1: TLabel;
    DBEditLocaliza1: TDBEditLocaliza;
    SpeedButton5: TSpeedButton;
    Shape1: TShape;
    Label2: TLabel;
    Label4: TLabel;
    DBEditLocaliza2: TDBEditLocaliza;
    SpeedButton6: TSpeedButton;
    Label6: TLabel;
    Shape10: TShape;
    Label7: TLabel;
    DBEditLocaliza3: TDBEditLocaliza;
    SpeedButton11: TSpeedButton;
    Label8: TLabel;
    Shape13: TShape;
    Label10: TLabel;
    Label13: TLabel;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
    SpeedButton15: TSpeedButton;
    LabelEmprestimo: TLabel;
    Label15: TLabel;
    DBEditLocaliza4: TDBEditLocaliza;
    SpeedButton17: TSpeedButton;
    Label28: TLabel;
    CadOSI_COD_USU: TIntegerField;
    CadOSC_OBS_ABE: TStringField;
    Label30: TLabel;
    EtipoEntrega: TDBEditLocaliza;
    SpeedButton16: TSpeedButton;
    Label39: TLabel;
    CadOSI_COD_ENT: TIntegerField;
    Shape6: TShape;
    Label32: TLabel;
    Label35: TLabel;
    SpeedButton10: TSpeedButton;
    Label38: TLabel;
    Label29: TLabel;
    DBEditColor9: TDBEditColor;
    eproduto: TDBEditLocaliza;
    DBEditColor7: TDBEditColor;
    MovTerceirosC_DES_PRO: TStringField;
    DBEditColor11: TDBEditColor;
    Label40: TLabel;
    cadClientesi_cod_cli: TIntegerField;
    CadOSD_DAT_PRE: TDateField;
    CadOSC_NOM_USU: TStringField;
    Label41: TLabel;
    DBEditColor12: TDBEditColor;
    Label42: TLabel;
    DBEditColor13: TDBEditColor;
    Shape16: TShape;
    Label43: TLabel;
    DBEditColor14: TDBEditColor;
    SpeedButton18: TSpeedButton;
    SpeedButton19: TSpeedButton;
    CadOSI_COD_ATE: TIntegerField;
    Label44: TLabel;
    DBEditLocaliza5: TDBEditLocaliza;
    SpeedButton20: TSpeedButton;
    Label45: TLabel;
    CadOSC_NON_AVI: TStringField;
    CadOSD_DAT_AVI: TDateField;
    Label59: TLabel;
    DBEditLocaliza7: TDBEditLocaliza;
    SpeedButton21: TSpeedButton;
    Label60: TLabel;
    Label46: TLabel;
    DBEditColor15: TDBEditColor;
    Label47: TLabel;
    DBEditColor16: TDBEditColor;
    Shape17: TShape;
    Label61: TLabel;
    BitBtn1: TBitBtn;
    Kit: TQuery;
    CadOSC_CHA_TEC: TStringField;
    CadOSC_TIP_CHA: TStringField;
    Label62: TLabel;
    DBComboBox1: TDBComboBoxColor;
    DBEditNumerico1: TDBEditNumerico;
    Label63: TLabel;
    CadOSI_NRO_ATE: TIntegerField;
    numerico1: Tnumerico;
    Label64: TLabel;
    ImpAbertura: TBitBtn;
    BitBtn3: TBitBtn;
    DBEditNumerico2: TDBEditNumerico;
    CadOSC_ACE_EMP: TStringField;
    Label66: TLabel;
    DBEditColor17: TDBEditColor;
    Label65: TLabel;
    Label27: TLabel;
    SpeedButton2: TSpeedButton;
    Label31: TLabel;
    SpeedButton3: TSpeedButton;
    Label67: TLabel;
    SpeedButton4: TSpeedButton;
    Label70: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label80: TLabel;
    Label81: TLabel;
    DBEditLocaliza8: TDBEditLocaliza;
    DBEditLocaliza9: TDBEditLocaliza;
    DBEditLocaliza10: TDBEditLocaliza;
    DBEditColor6: TDBEditColor;
    DBEditColor8: TDBEditColor;
    DBComboBoxColor1: TDBComboBoxColor;
    DBComboBoxColor2: TDBComboBoxColor;
    DBComboBoxColor3: TDBComboBoxColor;
    DBComboBoxColor4: TDBComboBoxColor;
    CadOSI_COD_EQU: TIntegerField;
    CadOSI_COD_MAR: TIntegerField;
    CadOSI_COD_MOD: TIntegerField;
    CadOSC_VOL_ENT: TStringField;
    CadOSC_ORC_EQU: TStringField;
    CadOSC_NRO_NOT: TStringField;
    CadOSC_DEF_APR: TStringField;
    CadOSC_NRO_SER: TStringField;
    CadOSC_ACE_EQU: TStringField;
    CadOST_HOR_PRE: TDateTimeField;
    BitBtn4: TBitBtn;
    cadClientesc_tip_pes: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure CadOSAfterInsert(DataSet: TDataSet);
    procedure CadOSBeforePost(DataSet: TDataSet);
    procedure ECondPagamentoSelect(Sender: TObject);
    procedure DelClienteRetorno(Retorno1, Retorno2: String);
    procedure eprodutoSelect(Sender: TObject);
    procedure eprodutoRetorno(Retorno1, Retorno2: String);
    procedure MovOSAfterInsert(DataSet: TDataSet);
    procedure GradeCellClick(Column: TColumn);
    procedure GradeColEnter(Sender: TObject);
    procedure GradeColExit(Sender: TObject);
    procedure GradeEditButtonClick(Sender: TObject);
    procedure GradeKeyPress(Sender: TObject; var Key: Char);
    procedure MovOSN_VLR_UNIChange(Sender: TField);
    procedure MovOSC_COD_UNIChange(Sender: TField);
    procedure MovOSAfterEdit(DataSet: TDataSet);
    procedure MovOSAfterPost(DataSet: TDataSet);
    procedure MovOSBeforePost(DataSet: TDataSet);
    procedure GradeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GServicosColExit(Sender: TObject);
    procedure ECodServicoRetorno(Retorno1, Retorno2: String);
    procedure ECodServicoSelect(Sender: TObject);
    procedure ECodServicoCadastrar(Sender: TObject);
    procedure GServicosEditButtonClick(Sender: TObject);
    procedure GServicosEnter(Sender: TObject);
    procedure GServicosExit(Sender: TObject);
    procedure GServicosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GServicosKeyPress(Sender: TObject; var Key: Char);
    procedure MovOSServicoAfterInsert(DataSet: TDataSet);
    procedure MovOSServicoAfterPost(DataSet: TDataSet);
    procedure MovOSServicoBeforePost(DataSet: TDataSet);
    procedure MovOSServicoN_QTD_MOVChange(Sender: TField);
    procedure EOSSelect(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BotaoCadastrar1DepoisAtividade(Sender: TObject);
    procedure DBEditLocaliza6Change(Sender: TObject);
    procedure DelClienteCadastrar(Sender: TObject);
    procedure DBEditLocaliza6Cadastrar(Sender: TObject);
    procedure EOSRetorno(Retorno1, Retorno2: String);
    procedure PaginasChange(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure DBEditColor20Change(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBEditColor17Exit(Sender: TObject);
    procedure BotaoCancelar1DepoisAtividade(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton14Click(Sender: TObject);
    procedure SpeedButton15Click(Sender: TObject);
    procedure DBEditColor10KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ImpAberturaClick(Sender: TObject);
    procedure c(Sender: TObject);
    procedure EtipoEntregaCadastrar(Sender: TObject);
    procedure GradeExit(Sender: TObject);
    procedure SpeedButton18Click(Sender: TObject);
    procedure SpeedButton19Click(Sender: TObject);
    procedure DBEditLocaliza5Select(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure DBComboBox1Change(Sender: TObject);
    procedure numerico1Exit(Sender: TObject);
    procedure BotaoGravar1DepoisAtividade(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure DBEditLocaliza8Cadastrar(Sender: TObject);
    procedure DBEditLocaliza9Cadastrar(Sender: TObject);
    procedure DBEditLocaliza10Cadastrar(Sender: TObject);
    procedure eprodutoCadastrar(Sender: TObject);
  private
    rel : TCrpe;
    NF : TFuncoesNotaFiscal;
    CodigoProdutoAtual,TextosCodigoProduto : string; // utilizado para guardar o codigo do produto quando entra na calula cod pro quando sair se igual naum localizar novamente
    ValorUnitario : Double;
    ConsultandoOS, Inserindo : Boolean;  // somente para consulta
    UnProdutos : TFuncoesProduto;
    UnOS : TFuncoesOrdemServico;
    DesServico : String;
    procedure CarregaDadosCliente(VpaCodCliente : String);
    function ValidaProduto : Boolean;
    function AbreLocalizacaoProduto : Boolean;
    procedure AdicionaItemsProduto( SeqPro : Integer );
    procedure CalculaTotal;
    procedure ConfiguraOrdemServico;
  public
    procedure NovaOS;
    procedure AlteraOS(NroOS : integer);
    procedure ConsultaOS(NroOS : integer);
  end;

var
  FOrdemServico: TFOrdemServico;

implementation

{$R *.DFM}


uses
   funsql, APrincipal, constmsg, constantes, ALocalizaProdutos,
   ANovoServico, funobjeto, AEquipamento, ANovoCliente, ASituacoes, AMarca,
   AModelo, funnumeros, ANovaOrdemServico, ATipoEntrega, AAtendimentoExtra,
  AMostraParReceber, ANovoProduto;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                  Formulario
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{ ****************** Na criação do Formulário ******************************** }
procedure TFOrdemServico.FormCreate(Sender: TObject);
begin
  NF := TFuncoesNotaFiscal.criar(self,FPrincipal.BaseDados);
  UnProdutos := TFuncoesProduto.criar(self,FPrincipal.BaseDados);
  UnOS := TFuncoesOrdemServico.Criar(self,FPrincipal.BaseDados);
  ConsultandoOS := false;
  Inserindo := false;
  TextosCodigoProduto := '1';
  ECodServicoSelect(ECodServico); // atualiza a select caso utilzar F3 direto na consulta de serviço
  EOSSelect(EOS); // atualiza a select caso utilzar F3 direto na consulta de OS
  ConfiguraOrdemServico;
  Eproduto.AInfo.CampoCodigo := Varia.CodigoProduto;  // caso codigo pro ou codigo de barras
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFOrdemServico.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  rel.free;
  varia.TabelaPreco := varia.TabelaPrecoPadrao;
  FechaTabelaGrava(CadOS);
  FechaTabelaGrava(MovOS);
  FechaTabelaGrava(MovOSServico);
  FechaTabelaGrava(MovTerceiros);
  CadProdutos.close;
  Produtos.close;
  cadClientes.close;
  CadServico.close;

  NF.free;
  UnOS.Free;
  UnProdutos.Free;
  Action := CaFree;
end;

{********************** fecha formulario ************************************ }
procedure TFOrdemServico.BFecharClick(Sender: TObject);
begin
  if CadOS.State in [ dsEdit, dsInsert ] then
    CadOS.post;
  self.close;
end;

{***************** quando e inicializado o formulario ************************ }
procedure TFOrdemServico.FormShow(Sender: TObject);
begin
  if Paginas.ActivePage = TabSheet1 then
   DBEditLocaliza6.SetFocus
  else
    if Paginas.ActivePage = TabSheet2 then
    begin
      EOS.SetFocus;
      if paginas.Enabled then
        DBEditLocaliza1.setfocus;
    end;
end;

procedure TFOrdemServico.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    115 : if Paginas.ActivePage = TabSheet1 then
             SpeedButton2.Click
          else
            if Paginas.ActivePage = TabSheet3 then
              SpeedButton13.Click;
    116 : if TabSheet1.TabVisible then paginas.ActivePage := TabSheet1;
    117 : if TabSheet2.TabVisible then paginas.ActivePage := TabSheet2;
    118 : if TabSheet3.TabVisible then paginas.ActivePage := TabSheet3;
    119 : if TabSheet4.TabVisible then paginas.ActivePage := TabSheet4;
  end;
end;

procedure TFOrdemServico.ConfiguraOrdemServico;
begin
  TabSheet3.TabVisible := Config.UsarTerceiro;
  label55.Enabled := Config.UsarTerceiro;
  DBEditColor23.Enabled := Config.UsarTerceiro;
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 Consulta OS
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{********************* select de consulta de OS ***************************** }
procedure TFOrdemServico.EOSSelect(Sender: TObject);
begin
  EOS.ASelectValida.clear;
  EOS.ASelectLocaliza.clear;
  EOS.ASelectValida.Add(' Select *  from CadOrdemServico ord, cadClientes cli ' +
                        ' where ord.i_cod_ors = @ ' +
                        ' and ord.i_cod_cli = cli.i_cod_cli ');
  if not ConsultandoOS then
    EOS.ASelectValida.Add(' and ord.c_sit_ors = ''A'' ' );
  EOS.ASelectValida.Add(' order by C_nom_cli ' );

  EOS.ASelectLocaliza.Add(' Select *  from CadOrdemServico ord, cadClientes cli ' +
                          ' where cli.c_nom_cli like ''@%'' ' +
                          ' and ord.i_cod_cli = cli.i_cod_cli ' );
  if not ConsultandoOS then
    EOS.ASelectLocaliza.Add(' and ord.c_sit_ors = ''A'' ' );
  EOS.ASelectLocaliza.Add(' order by C_nom_cli ' );
end;

{************* retorno da consulta localiza os ******************************* }
procedure TFOrdemServico.EOSRetorno(Retorno1, Retorno2: String);
begin
  if Retorno1 <> '' then
  begin
    ConsultandoOS := true;
    Paginas.Enabled := true;
    UnOS.LocalizaCadOS(CadOS, StrToInt(Retorno1));
    UnOS.LocalizaProdutos(Produtos,StrToInt(Retorno1));
    while not Produtos.Eof do
    begin
      TextosCodigoProduto := TextosCodigoProduto  + ', ' +  Produtos.fieldByname('I_SEQ_PRO').AsString;
      Produtos.Next;
    end;
    UnOS.LocalizaMovOS(MovOS, StrToInt(Retorno1));
    UnOS.LocalizaMovOSServico(MovOSServico, StrToInt(Retorno1));
    UnOS.LocalizaTerceiroOS(MovTerceiros, StrToInt(Retorno1));

    if CadOSC_SIT_ORS.AsString = 'A' then
      CadOS.edit;

    DataCadOS.AutoEdit := CadOSC_SIT_ORS.AsString = 'A';
    DataMovOS.AutoEdit := CadOSC_SIT_ORS.AsString = 'A';
    DataMovOSServico.AutoEdit := CadOSC_SIT_ORS.AsString = 'A';
    DataMovTerceiros.AutoEdit := CadOSC_SIT_ORS.AsString = 'A';
    BotaoCadastrar1.Enabled := CadOSC_SIT_ORS.AsString = 'A';
    ImpAbertura.Enabled := CadOSC_SIT_ORS.AsString = 'A';
    BotaoGravar1.Enabled := CadOSC_SIT_ORS.AsString = 'A';
    BotaoCancelar1.Enabled := CadOSC_SIT_ORS.AsString = 'A';
    BotaoAlterar2.Enabled := CadOSC_SIT_ORS.AsString = 'A';
    grade.ReadOnly := CadOSC_SIT_ORS.AsString <> 'A';
    GServicos.ReadOnly := CadOSC_SIT_ORS.AsString <> 'A';
    BitBtn2.Enabled := CadOSC_SIT_ORS.AsString = 'A';
    SpeedButton13.Enabled := CadOSC_SIT_ORS.AsString = 'A';
    SpeedButton14.Enabled := CadOSC_SIT_ORS.AsString = 'A';
    SpeedButton15.Enabled := CadOSC_SIT_ORS.AsString = 'A';

    AtualizaLocalizas([ECondPagamento, DelCliente,EformaPgto,
    eproduto, EtipoEntrega, DBEditLocaliza4, DBEditLocaliza5,
    DBEditLocaliza1,DBEditLocaliza7,DBEditLocaliza6,
    DBEditLocaliza8,DBEditLocaliza9,DBEditLocaliza10]);

    LabelEmprestimo.Caption := 'Material Emprestado : ' + Label38.Caption;
  end
  else
    Paginas.Enabled := false;
  Label17.Caption := '';  // para forcar nova atualizacao dos edits
  // caso a pagina abreOS estiver ativa, senau a a tualizacao ocorre no click da pagina
  if paginas.ActivePage = TabSheet1 then
    PaginasChange(paginas);
  ConsultandoOS := CadOSC_SIT_ORS.AsString <> 'A';

  if Paginas.ActivePage = TabSheet2 then
    if (DBEditLocaliza1.Enabled) and (self.visible) and (paginas.enabled) then
      DBEditLocaliza1.SetFocus;
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                  Abre OS
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{************************* carrega clientes ********************************* }
procedure TFOrdemServico.CarregaDadosCliente(VpaCodCliente : String);
begin
  if VpaCodCliente <> '' then
  begin
    AdicionaSQLAbreTabela(cadClientes,' Select i_cod_cli,c_nom_cli, c_cgc_cli, c_cpf_cli, c_ins_cli,'+
                                      ' C_End_Cli || '', '' ||  I_Num_end enderco,'+
                                      ' C_Bai_Cli, C_Cep_Cli, C_Cid_Cli || '' - '' || C_Est_Cli Municipio, '+
                                      ' c_fo1_cli ||  '' / '' || c_fon_fax fone, c_tip_pes ' +
                                      ' from CadClientes '+
                                      ' Where I_Cod_Cli = ' + VpaCodCliente);
    CodigoTabelaPreco(cadClientes.FieldByName('i_cod_cli').AsInteger, FPrincipal.BaseDados);

   if cadClientesc_tip_pes.AsString = 'F' then
     DBText17.DataField := 'c_cpf_cli'
   else                                  
     DBText17.DataField := 'c_cgc_cli';
  end;
end;

procedure TFOrdemServico.CadOSAfterInsert(DataSet: TDataSet);
begin
  CadOSI_EMP_FIL.AsInteger := varia.CodigoEmpFil;
  ProximoCodigoFilial1.execute('CadOrdemServico','I_EMP_FIL',varia.CodigoEmpFil);
  CadOSD_DAT_CAD.AsDateTime := date;
  CadOSC_SIT_ORS.AsString := 'A';   // A aberta,  C Cancelada, F Fecahda
  CadOSC_CHA_TEC.AsString := 'Balcao';
  CadOSC_TIP_CHA.AsString := 'A'; // A aberto, C cancelado, F fechado, N nao e chamado  
  DBMemoColor1.Lines.Clear;
  CadOSL_OBS_MOV.Clear;
  CadOSI_COD_ATE.AsInteger := VARIA.CodigoUsuario;
  DBEditLocaliza5.Atualiza;
  CadOSI_COD_SIT.AsInteger := varia.CodSituacaoPadraoOS;
  DBEditLocaliza6.atualiza;
end;

procedure TFOrdemServico.CadOSBeforePost(DataSet: TDataSet);
begin
  CadOSD_ULT_ALT.AsDateTime := date;
  If CadOS.State = dsInsert Then
    ProximoCodigoFilial1.VerificaCodigo;
end;

procedure TFOrdemServico.ECondPagamentoSelect(Sender: TObject);
begin
  ECondPagamento.ASelectValida.Text := 'select * from cadcondicoespagto '+
                                       ' where I_Cod_pag = @ ' +
                                       ' and D_VAl_Con >= ' + SQLTextoDataAAAAMMMDD(Date);
  ECondPagamento.ASelectLocaliza.Text := 'select * from cadcondicoespagto '+
                                         ' where c_nom_pag like ''@%''' +
                                         ' and D_VAl_Con >= ' + SQLTextoDataAAAAMMMDD(Date);
end;

procedure TFOrdemServico.DelClienteRetorno(Retorno1, Retorno2: String);
var
  ValorIna : double;
begin
  if Retorno1 <> '' then
  begin
    CarregaDadosCliente(Retorno1);

    // mostra inadimplentes
    ValorIna := 0;
    if (config.VerificarInaOS) and (Inserindo) then
    begin
      ValorIna := unOS.calculaParcelaAbertaCli(StrToInt(Retorno1));
      if valorIna <> 0 then
      begin
        FMostraParReceber := TFMostraParReceber.CriarSDI(application, '');
        FMostraParReceber.MostraInadimplentes(StrToInt(Retorno1), ValorIna);
        FMostraParReceber.ShowModal;
        if not SenhaDeLiberacao then
          if Self.Visible then
          begin
            DelCliente.Text := '';
            DelCliente.SetFocus;
            abort;
          end;
      end;
    end;  
  end;
end;


procedure TFOrdemServico.eprodutoSelect(Sender: TObject);
begin
  eproduto.ASelectValida.Clear;
  eproduto.ASelectValida.add(  ' Select Pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
                                    ' pro.I_SEQ_PRO, mov.C_COD_BAR, ' +
                                    ' (tab.n_vlr_ven * moe.n_vlr_dia) as n_vlr_ven ' +
                                    ' From cadprodutos as pro, ' +
                                    ' MovQdadeProduto as mov, MovTabelaPreco as Tab, CadMoedas as Moe ' +
                                    ' Where pro.I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                                    ' and ' + varia.CodigoProduto + ' = ''@''' +
                                    ' and pro.C_KIT_PRO = ''P'' ' +
                                    ' and pro.I_seq_pro = Mov.I_seq_pro ' +
                                    ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil) +
                                    ' and tab.i_cod_tab = ' + IntTostr(varia.TabelaPreco) +
                                    ' and tab.i_cod_emp = ' + IntTostr(varia.CodigoEmpresa) +
                                    ' and pro.i_seq_pro = tab.i_seq_pro ' +
                                    ' and tab.i_cod_moe = moe.i_cod_moe' );
  eproduto.ASelectLocaliza.Clear;
  eproduto.ASelectLocaliza.add(' Select pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
                                    ' (tab.n_vlr_ven * moe.n_vlr_dia) as n_vlr_ven, ' +
                                    ' pro.I_SEQ_PRO, mov.C_COD_BAR ' +
                                    ' from cadprodutos as pro, ' +
                                    ' MovQdadeProduto as mov, MovTabelaPreco as Tab, CadMoedas as Moe ' +
                                    ' Where pro.I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                                    ' and pro.c_nom_pro like ''@%''' +
                                    ' and pro.C_KIT_PRO = ''P'' ' +
                                    ' and pro.I_seq_pro = Mov.I_seq_pro ' +
                                    ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil) +
                                    ' and tab.i_cod_tab = ' + IntTostr(varia.TabelaPreco) +
                                    ' and tab.i_cod_emp = ' + IntTostr(varia.CodigoEmpresa) +
                                    ' and pro.i_seq_pro = tab.i_seq_pro ' +
                                    ' and tab.i_cod_moe = moe.i_cod_moe' +
                                    ' order by c_nom_pro asc');
end;

procedure TFOrdemServico.eprodutoRetorno(Retorno1, Retorno2: String);
begin
  if Retorno1 <> '' then
  begin
    if CadOSI_SEQ_PRO.AsInteger <> StrToInt(Retorno1) then  // evita recolacar a data na alteracao
      if CadOS.State in [ dsEdit, dsInsert ] then
      begin
        CadOSI_SEQ_PRO.AsInteger := StrToInt(Retorno1);
        CadOSD_DAT_EMP.AsDateTime := date;
      end;
  end
  else
  begin
     CadOSD_DAT_EMP.Clear;
     CadOSI_SEQ_PRO.Clear;
  end;
end;

procedure TFOrdemServico.BotaoCadastrar1DepoisAtividade(Sender: TObject);
begin
  LimpaLabel([label33,label36, label38, label17,label28,label70,label71,label72]);
  cadClientes.close;
  CadOS.Post;
  UnOS.LocalizaCadOS(CadOS, CadOSI_COD_ORS.AsInteger);
  CadOS.Edit;
  DBEditLocaliza6.setfocus;
  BotaoGravar1.Enabled := false;
  numerico1.Enabled := true;
  label64.Enabled := true;
  numerico1.AValor := 0;
end;

procedure TFOrdemServico.DBEditLocaliza6Change(Sender: TObject);
begin
  if CadOS.State in [dsedit, dsInsert] then
    ValidaGravacao1.execute;
end;


procedure TFOrdemServico.DelClienteCadastrar(Sender: TObject);
begin
   FNovoCliente := TFNovoCliente.CriarSDI(application,'', true);
   FNovoCliente.CadClientes.Insert;
   FNovoCliente.ShowModal;
   Localiza.AtualizaConsulta;
end;

procedure TFOrdemServico.DBEditLocaliza6Cadastrar(Sender: TObject);
begin
  FSituacoes := TFSituacoes.CriarSDI(application, '',Fprincipal.VerificaPermisao('FSituacoes'));
  FSituacoes.ShowModal;
  localiza.AtualizaConsulta;
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                  Produto
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

procedure TFOrdemServico.MovOSAfterInsert(DataSet: TDataSet);
begin
  MovOSI_EMP_FIL.AsInteger := varia.CodigoEmpFil;
  MovOSI_COD_ORS.AsInteger := CadOSI_COD_ORS.AsInteger;
  MovOSI_COD_USU.AsInteger := Varia.CodigoUsuario;
  CodigoProdutoAtual := '0';
  if ConsultandoOS then
    MovOS.cancel;
end;

procedure TFOrdemServico.GradeCellClick(Column: TColumn);
begin
  if grade.SelectedIndex = 2 then
      MovOS.edit;
end;

procedure TFOrdemServico.GradeColEnter(Sender: TObject);
begin
  CodigoProdutoAtual := MovOSC_COD_PRO.AsString;
  if Grade.SelectedIndex = 4 then
    ValorUnitario := MovOSN_VLR_UNI.AsCurrency;
end;

procedure TFOrdemServico.GradeColExit(Sender: TObject);
var
  codPro : string;
begin
    if not ConsultandoOS then
      case grade.SelectedIndex of
        0 : begin
             if (CodigoProdutoAtual <> MovOSC_COD_PRO.AsString) or ( MovOSC_COD_PRO.AsString = '') then
                if not ValidaProduto then
                  abort;
            end;
        4 : begin
              if MovOS.State in [ dsInsert, dsEdit] then
              begin
                MovOSC_COD_UNI.AsString := LowerCase(MovOSC_COD_UNI.AsString);
                if not  NF.ValidaUnidade(MovOSC_COD_UNI.AsString, CadProdutos.FieldByname('c_cod_uni').AsString) then
                   abort;
              end;
            end;
      end;
end;

{*********************** Valida o  Produto ********************************** }
function TFOrdemServico.ValidaProduto : Boolean;
var
  SeqPro :integer;
begin
  result := true;
  if MovOS.State in [ dsedit, dsinsert ] then
  begin
    if NF.VerificaExisteProduto(MovOSC_COD_PRO.AsString, SeqPro) then // valida o campo codigo caso esteja vazio
    begin
      TextosCodigoProduto := TextosCodigoProduto + ', ' + IntToStr(SeqPro);
      NF.LocalizaProdutoCodigos(Produtos, TextosCodigoProduto );
      MovOSI_SEQ_PRO.AsInteger := SeqPro;
    end
    else
      result := AbreLocalizacaoProduto;
    if Result then
      AdicionaItemsProduto(MovOSI_SEQ_PRO.AsInteger);
  end;
end;

{*********************** Abre a localizacao dos produto ********************** }
function TFOrdemServico.AbreLocalizacaoProduto : Boolean;
var
  SeqPro :integer;
  codPro : string;
  cadastrou : boolean;
  EstoqueAtual : Double;
begin
   cadastrou := true;
   FLocalizaProduto := TFLocalizaProduto.CriarSDI(application,'',true);
   result := FLocalizaProduto.LocalizaProduto( cadastrou, seqpro, CodPro, EstoqueAtual, cadOsI_COD_CLI.asinteger );
   if cadastrou then  // caso tenha cadastrado um produto na consulta
     AtualizaSQLTabela(Produtos);
   if result then
   begin
     if not (MovOS.State in [ dsEdit, dsInsert ]) then
       MovOS.Insert;
     TextosCodigoProduto := TextosCodigoProduto + ', ' + IntToStr(SeqPro);
     NF.LocalizaProdutoCodigos(Produtos, TextosCodigoProduto );
     MovOSI_SEQ_PRO.AsInteger := SeqPro;
     MovOSC_COD_PRO.AsString := codPro;
   end;
end;

{********* adiciona os itens do produto localizado *************************** }
procedure TFOrdemServico.AdicionaItemsProduto( SeqPro : Integer );
var
  CodProKit : integer;
  Reducao, AdicionarKit : Boolean;
begin
  NF.LocalizaProdutoQdadeTabelaSeqPro(CadProdutos, SeqPro);
  if CadProdutos.FieldByName('C_KIT_PRO').AsString = 'P' then
  begin
    MovOSC_COD_UNI.AsString := CadProdutos.FieldByname('c_cod_uni').AsString;
    MovOSN_VLR_UNI.AsFloat := CadProdutos.FieldByname('n_vlr_ven').AsFloat;
    grade.Columns[2].PickList := NF.UnidadesParentes(CadProdutos.FieldByname('c_cod_uni').AsString);
  end
  else
  begin
//     Tempo.execute('Adicionando Kit à Nota Fiscal ....');
     CodProKit := CadProdutos.FieldByName('I_SEQ_PRO').AsInteger;
     MovOS.Cancel;
     NF := TFuncoesNotaFiscal.criar(self, FPrincipal.BaseDados);
     NF.LocalizaKit(Kit,CodProKit);
     while not kit.eof do
     begin
       MovOS.Append;
       TextosCodigoProduto := TextosCodigoProduto  + ', ' +  Kit.fieldByname('I_SEQ_PRO').AsString;
       NF.LocalizaProdutoCodigos(Produtos, TextosCodigoProduto );
       MovOSI_EMP_FIL.AsInteger := varia.CodigoEmpFil;
       MovOSI_COD_ORS.AsInteger := CadOSI_COD_ORS.AsInteger;
       MovOSI_COD_USU.AsInteger := Varia.CodigoUsuario;
       MovOSI_SEQ_PRO.AsInteger := kit.fieldByName('I_SEQ_PRO').AsInteger;
       MovOSI_SEQ_MOV.AsInteger := ProximoCodigoFilialCampo('movOrdemServico','i_seq_mov','i_emp_fil','i_cod_ors',varia.CodigoEmpFil, CadOSI_COD_ORS.AsInteger, FPrincipal.BaseDados);
       MovOSN_VLR_UNI.AsString := kit.fieldByName('I_SEQ_PRO').AsString;
       MovOSN_QTD_MOV.AsFloat :=  Kit.fieldByName('N_QTD_PRO').AsFloat;
       MovOSC_COD_PRO.AsString := kit.fieldByName(Varia.CodigoProduto).AsString;
       MovOSD_ULT_ALT.AsDateTime := date;
       MovOSC_COD_UNI.AsString := kit.fieldByName('C_COD_UNI').AsString;
       kit.Next;
     end;
     kit.close;
//     Tempo.fecha;
  end;
end;

procedure TFOrdemServico.GradeEditButtonClick(Sender: TObject);
begin
 if not grade.ReadOnly then
   AbreLocalizacaoProduto; // localiza produto pelas reticencias
end;

procedure TFOrdemServico.GradeKeyPress(Sender: TObject; var Key: Char);
begin
  if key = '.' then  //se for pressinado ponto substitui por vírgula
     if Grade.SelectedIndex in [3,4] Then
        key := ',';
end;

procedure TFOrdemServico.CalculaTotal;
var
  Horas : double;
begin
  if not ConsultandoOS then
  begin
    if CadOS.Active then
       if not (CadOS.State in [ dsEdit, dsInsert ]) then
          CadOS.edit;

    if CadOS.State in [ dsEdit, dsInsert ] then
    begin
      CadOSN_TOT_PRO.AsCurrency := UnOS.CalculaTotalProdutos(CadOSI_COD_ORS.AsInteger);
      CadOSN_TOT_SER.AsCurrency := UnOS.CalculaTotalServico(CadOSI_COD_ORS.AsInteger, Horas);
      CadOSN_TOT_HOR.AsCurrency := MinutosParaDecimal(horas);

      if config.UsarTerceiro then
        CadOSN_TOT_TER.AsCurrency := UnOS.CalculaTotalTerceiro(CadOSI_COD_ORS.AsInteger);

      CadOSN_TOT_ORS.AsCurrency := CadOSN_TOT_PRO.AsCurrency + CadOSN_TOT_SER.AsCurrency + CadOSN_TOT_TER.AsCurrency;

      // calcula desconto ou acrescimos
      if CadOSN_VLR_PER.AsCurrency <> 0 then
      begin
        if AcrDes.ItemIndex = 0 then
          CadOSN_TOT_ORS.AsCurrency := CadOSN_TOT_ORS.AsCurrency + CadOSN_VLR_PER.AsCurrency
        else
          CadOSN_TOT_ORS.AsCurrency := CadOSN_TOT_ORS.AsCurrency - CadOSN_VLR_PER.AsCurrency;
      end;
    end;
  end;
end;


procedure TFOrdemServico.MovOSN_VLR_UNIChange(Sender: TField);
begin
  MovOSN_VLR_TOT.AsCurrency := MovOSN_QTD_MOV.AsCurrency * MovOSN_VLR_UNI.AsCurrency;
end;

procedure TFOrdemServico.MovOSC_COD_UNIChange(Sender: TField);
begin
 if Grade.SelectedIndex = 2 then
   MovOSN_VLR_UNI.AsCurrency := NF.CalculaValorPadrao( MovOSC_COD_UNI.AsString,
                                                       CadProdutos.FieldByname('c_cod_uni').AsString,
                                                       CadProdutos.FieldByname('n_vlr_ven').AsFloat,
                                                       MovOSI_SEQ_PRO.AsInteger );
end;

procedure TFOrdemServico.MovOSAfterEdit(DataSet: TDataSet);
begin
  NF.LocalizaProdutoQdadeTabelaSeqPro(CadProdutos, MovOSI_SEQ_PRO.AsInteger);
  grade.Columns[2].PickList := NF.UnidadesParentes(CadProdutos.FieldByname('c_cod_uni').AsString);
end;

procedure TFOrdemServico.MovOSAfterPost(DataSet: TDataSet);
begin
  AtualizaSQLTabela(MovOS);
  MovOS.last;
  CalculaTotal;
end;

procedure TFOrdemServico.MovOSBeforePost(DataSet: TDataSet);
begin
  MovOSD_ULT_ALT.AsDateTime := date;

    if MovOSC_COD_PRO.IsNull or MovOSC_COD_UNI.IsNull or
       MovOSN_QTD_MOV.IsNull or MovOSN_VLR_UNI.IsNull then
      if grade.Focused then
        abort
      else
      begin
        MovOS.Cancel;
        abort;
      end;

      if not UnProdutos.VerificaEstoque( MovOSC_COD_UNI.AsString, cadProdutos.fieldByName('c_cod_uni').AsString, MovOSN_QTD_MOV.AsFloat,MovOSI_SEQ_PRO.AsString) then
       abort;
      UnProdutos.TextoQdadeMinimaPedido( cadprodutos.fieldByName('n_qtd_ped').AsFloat,
                                         cadprodutos.fieldByName('n_qtd_min').AsFloat,
                                         MovOSN_QTD_MOV.AsFloat);

    if not FPrincipal.BaseDados.InTransaction then
      FPrincipal.BaseDados.StartTransaction;
    MovOSI_SEQ_MOV.AsInteger := ProximoCodigoFilialCampo('movOrdemServico','i_seq_mov','i_emp_fil','i_cod_ors',varia.CodigoEmpFil, CadOSI_COD_ORS.AsInteger, FPrincipal.BaseDados);
    if FPrincipal.BaseDados.InTransaction then
      FPrincipal.BaseDados.Commit;

end;

procedure TFOrdemServico.GradeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not Grade.ReadOnly then
  begin
    if not ConsultandoOS then
    begin
       if ( not MovOS.IsEmpty) and (key = 46)and
          (MovOS.State = dsBrowse) then // para deletar um item
         if Confirmacao(CT_DeletarItem) Then
         begin
            MovOS.Delete;
            CalculaTotal;
            key := 0;
         end;

      if (Key = 114)  and (grade.SelectedIndex = 0) then  // localiza produtos
         AbreLocalizacaoProduto;

      if grade.SelectedIndex = 2 then
        if (key = 113) or (key = 13) then
          MovOS.edit;
    end;

    if key = 45 then
    begin
      MovOS.Append;
      key := 0;
    end;
  end;
end;

{************** ao sair da tela de produtos *********************************}
procedure TFOrdemServico.GradeExit(Sender: TObject);
begin
  if MovOS.State in [ dsinsert, dsEdit ] then
    MovOS.post;
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                  Servico
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

procedure TFOrdemServico.GServicosColExit(Sender: TObject);
begin
  if not ConsultandoOS then
    case GServicos.SelectedIndex of
      0 : begin
            ECodServico.Atualiza;
            if MovOSServico.State in [ dsEdit, dsInsert ] then
               MovOSServicoN_VLR_UNI.AsCurrency := nf.RetornaValorServico(MovOSServicoI_COD_SER.AsInteger);
          end;
    end;
end;

procedure TFOrdemServico.ECodServicoRetorno(Retorno1, Retorno2: String);
begin
  if Retorno1 = '' then
  begin
    ECodServico.Field.Clear;
    GServicos.SelectedIndex := 0;
  end
  else
    DesServico := retorno2;
  GServicos.SetFocus;
end;

procedure TFOrdemServico.ECodServicoSelect(Sender: TObject);
begin
  ECodServico.ASelectValida.Clear;
  ECodServico.ASelectValida.Add( ' Select * from CadServico ' +
                                 ' Where i_cod_ser = @ ' +
                                 ' and I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                                 ' and c_ati_ser <> ''N''' );
  ECodServico.ASelectLocaliza.Clear;
  ECodServico.ASelectLocaliza.Add( ' Select * from CadServico ' +
                                   ' Where c_nom_ser like ''@%'' ' +
                                   ' and I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                                   ' and c_ati_ser <> ''N''' +
                                   ' order by c_nom_ser' );
end;

procedure TFOrdemServico.ECodServicoCadastrar(Sender: TObject);
var
  CodCla, DescCal, CodSequencia : string;
begin
  FNovoServico := TFNovoServico.CriarSDI(application, '', true);
  FNovoServico.InsereNovoServico( CodCla, DescCal, CodSequencia, true );
  Localiza.AtualizaConsulta;
  AtualizaSQLTabela(CadServico);
end;

procedure TFOrdemServico.GServicosEditButtonClick(Sender: TObject);
begin
  if not GServicos.ReadOnly then
  begin
    if not (MovOSServico.State in [ dsEdit, dsInsert ]) then   // caso entre na grade sen insercao, evita erra de localizacao sem insercao com f3
      MovOSServico.insert;
    ECodServico.AAbreLocalizacao;
  end;
end;

procedure TFOrdemServico.GServicosEnter(Sender: TObject);
begin
 if not MovOSServico.Active then
   nf.LocalizaCadServico(CadServico);

  ActiveControl := GServicos;
  GServicos.SelectedIndex := 0;
end;

procedure TFOrdemServico.GServicosExit(Sender: TObject);
begin
  if not ConsultandoOS then
  begin
    if MovOSServico.State in [ dsinsert, dsEdit ] then
      MovOSServico.post;
  end;
end;

procedure TFOrdemServico.GServicosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not GServicos.ReadOnly then
  begin
    if not ConsultandoOS then
    begin
       if ( not MovOSServico.IsEmpty) and (key = 46)and
          (MovOSServico.State = dsBrowse) then // para deletar um item
         if Confirmacao(CT_DeletarItem) Then
         begin
            MovOSServico.Delete;
            CalculaTotal;
            key := 0;
         end;

      if (Key = 114)  and (GServicos.SelectedIndex = 0) then  // localiza produtos
      begin
        // caso entre na grade sen insercao, evita erra de localizacao sem insercao com f3
        if not (MovOSServico.State in [ dsEdit, dsInsert ]) then
          MovOSServico.insert;
         ECodServico.AAbreLocalizacao;
      end;

      if key = 45 then
      begin
        MovOSServico.Append;
        key := 0;
      end;
    end;
  end;
end;

procedure TFOrdemServico.GServicosKeyPress(Sender: TObject; var Key: Char);
begin
  if key = '.' then  //se for pressinado ponto substitui por vírgula
     if GServicos.SelectedIndex in [2,3] Then
        key := ',';
end;

procedure TFOrdemServico.MovOSServicoAfterInsert(DataSet: TDataSet);
begin
  if not ConsultandoOS then
  begin
    MovOSServicoI_EMP_FIL.AsInteger := varia.CodigoEmpFil;
    MovOSServicoI_COD_ORS.AsInteger := CadOSI_COD_ORS.AsInteger;
    MovOSServicoI_COD_USU.AsInteger := Varia.CodigoUsuario;
    MovOSServicoI_COD_EMP.AsInteger := Varia.CodigoEmpresa;
    CodigoProdutoAtual := '0';
  end
  else
    MovOSServico.cancel;
end;

procedure TFOrdemServico.MovOSServicoAfterPost(DataSet: TDataSet);
begin
  if not (CadOS.State in [ dsEdit, dsInsert ]) then
    CadOS.Edit;
  if DesServico <> '' then
    CadOSL_OBS_MOV.AsString :=  CadOSL_OBS_MOV.AsString  + #13 + DesServico;
  AtualizaSQLTabela(MovOSServico);
  MovOSServico.last;
  CalculaTotal;
end;


procedure TFOrdemServico.MovOSServicoBeforePost(DataSet: TDataSet);
begin
  MovOSServicoD_ULT_ALT.AsDateTime := date;

  if MovOSServicoI_COD_SER.IsNull or MovOSServicoN_QTD_MOV.IsNull or
     MovOSServicoN_VLR_UNI.IsNull then
    if GServicos.Focused then
      abort
    else
    begin
      MovOSServico.Cancel;
      abort;
    end;


    if not FPrincipal.BaseDados.InTransaction then
      FPrincipal.BaseDados.StartTransaction;
    MovOSServicoI_SEQ_MOV.AsInteger := ProximoCodigoFilialCampo('movOrdemServico','i_seq_mov','i_emp_fil','i_cod_ors',varia.CodigoEmpFil, CadOSI_COD_ORS.AsInteger, FPrincipal.BaseDados);
    if FPrincipal.BaseDados.InTransaction then
      FPrincipal.BaseDados.Commit;
end;

procedure TFOrdemServico.MovOSServicoN_QTD_MOVChange(Sender: TField);
begin
  MovOSServicoN_VLR_TOT.AsCurrency := HoraParaDecimal(MovOSServicoN_QTD_MOV.AsCurrency) * MovOSServicoN_VLR_UNI.AsCurrency;
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                  Terceiros
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }


procedure TFOrdemServico.DBEditColor17Exit(Sender: TObject);
begin
   if MovTerceiros.State in [ dsEdit, dsInsert ] then
     if MovTerceirosN_VLR_COB.AsCurrency = 0 then
       MovTerceirosN_VLR_COB.AsCurrency :=  MovTerceirosN_VLR_SER.AsCurrency;
end;

procedure TFOrdemServico.Button2Click(Sender: TObject);
begin
  if SpeedButton13.Enabled then
  begin
    FNovaOrdemServico := TFNovaOrdemServico.criarSDI(application, '', true);
    FNovaOrdemServico.AdiconarNovoTerceiro( CadOSI_COD_ORS.AsInteger, CadOSI_COD_EQU.AsInteger,
                                            CadOSI_COD_MAR.AsInteger, CadOSI_COD_MOD.AsInteger, CadOSC_NRO_SER.AsString );
    AtualizaSQLTabela(MovTerceiros);
    CalculaTotal;
  end;
end;


procedure TFOrdemServico.SpeedButton14Click(Sender: TObject);
begin
  FNovaOrdemServico := TFNovaOrdemServico.criarSDI(application, '', true);
  FNovaOrdemServico.AlterarTerceiro(MovTerceirosI_COD_ORS.AsInteger, MovTerceirosI_SEQ_MOV.AsInteger);
  AtualizaSQLTabela(MovTerceiros);
  CalculaTotal;
end;

procedure TFOrdemServico.SpeedButton15Click(Sender: TObject);
begin
  if Confirmacao(CT_DeletarItem + ' ? ') then
  begin
    UnOS.ExcluiItemTerceiroOS(MovTerceirosI_COD_ORS.AsInteger, MovTerceirosI_SEQ_MOV.AsInteger);
    AtualizaSQLTabela(MovTerceiros);
    CalculaTotal;
  end;
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 Fecha OS
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }


procedure TFOrdemServico.BitBtn2Click(Sender: TObject);
begin
  if (ECondPagamento.Text <> '') and (EformaPgto.Text <> '' ) then
  begin
    if (CadOSC_NON_AVI.AsString <> '') and (not CadOSD_DAT_AVI.IsNull) then
    begin
      if CadOS.State in [ dsinsert, dsEdit ] then
      begin
        if (CadOSI_SEQ_PRO.AsInteger <> 0) and (CadOSD_DAT_DEV.IsNull) then
          aviso('Esta Ordem de Serviço não poderá ser fechada enquanto não houver a devolução do material empretado.')
        else
        begin
          CadOSC_SIT_ORS.AsString := 'F';  // OS fechada
          CadOSD_DAT_FEC.AsDateTime := date;
          CadOS.post;
          BitBtn2.Enabled := false;
        end;
      end;
  end
  else
    aviso('Definir data e contato do término do serivço !');
   end
   else
     aviso('A Condição de Pagamento ou forma de pagamento estão vazias !');
end;

procedure TFOrdemServico.DBEditColor20Change(Sender: TObject);
begin
  CalculaTotal;
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 Chamadas externas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{*********************** gera um nova OS ************************************* }
procedure TFOrdemServico.NovaOS;
begin
  Inserindo := true;
  TabSheet2.TabVisible := false;
  TabSheet3.TabVisible := false;
  TabSheet4.TabVisible := false;
  CadOS.open;
  CadOS.Insert;
  CadOS.post;
  UnOS.LocalizaCadOS(CadOS, CadOSI_COD_ORS.AsInteger);
  CadOS.Edit;
  Label48.Enabled := FALSE;
  EOS.Enabled := false;
  Label50.Enabled := false;
  SpeedButton12.Enabled := false;
  cadClientes.close;
  BotaoGravar1.Enabled := false;
  Label64.Enabled := True;
  numerico1.Enabled := true;
  self.ShowModal;
end;

procedure TFOrdemServico.AlteraOS(NroOS : integer);
begin
  Paginas.ActivePage := TabSheet2;
  if NroOS <> 0 then
  begin
    EOS.Text := IntToStr(NroOS);
//    EOS.Atualiza;
  end
  else
    Paginas.Enabled := false;
  BotaoCadastrar1.Visible := false;
  BotaoAlterar2.Visible := false;
  ImpAbertura.Enabled := false;
  self.ShowModal;
end;

procedure TFOrdemServico.PaginasChange(Sender: TObject);
begin
   if Paginas.Tag <> CadOSI_COD_SIT.AsInteger then
   begin
     DBEditLocaliza6.Atualiza;
     DBEditLocaliza1.Atualiza;
     DBEditLocaliza7.atualiza;
     DBEditLocaliza2.Atualiza;
     DBEditLocaliza3.Atualiza;
     paginas.Tag := CadOSI_COD_SIT.AsInteger;
  end;

  if Paginas.ActivePage = TabSheet4 then
    if CadOS.State in [ dsEdit, dsInsert ] then
    begin
     CalculaTotal;
//      if CadOSI_SEQ_PRO.AsInteger <> 0 then
//        CadOSD_DAT_DEV.AsDateTime := date;
//      CadOSD_DAT_FEC.AsDateTime := date;
    end;
end;

procedure TFOrdemServico.BotaoCancelar1DepoisAtividade(Sender: TObject);
begin
  if not TabSheet4.TabVisible then  // caso esteja somente em cadastro
  begin
    MovOS.close;
    MovOS.open;
    UnOS.ExcluiOS(CadOSI_COD_ORS.AsInteger);
    CadOS.close;
    CadOS.open;
  end;
end;


procedure TFOrdemServico.DBEditColor10KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key = 46 then
  begin
    DBEditColor10.Field.clear;
    DBEditColor10.text := ''
  end;
end;

procedure TFOrdemServico.ImpAberturaClick(Sender: TObject);
begin
  case varia.TipoRelatorioOS of
   0 : UnOS.ImprimeChamado80(CadOSI_COD_ORS.AsInteger);
   1 : begin
         if rel <> nil then
           rel.free;
         rel := TCrpe.Create(self);
         rel.ReportName := varia.PathRel + 'diverso\AberturaOrdemServico.rpt';
         rel.Connect.Retrieve;
         rel.Connect.DatabaseName := varia.AliasBAseDados;
         rel.Connect.ServerName := varia.AliasRelatorio;
         rel.WindowState := wsMaximized;
         rel.ParamFields.Retrieve;
         rel.ParamFields[0].Value := CadOSI_COD_ORS.AsString;
         rel.ParamFields[1].Value := CadOSI_EMP_FIL.AsString;
         rel.execute;
       end;
  end;
end;

procedure TFOrdemServico.c(Sender: TObject);
begin
  if not (BotaoGravar1.Enabled) then
  begin
    if (not MovOS.IsEmpty) or (not MovOSServico.IsEmpty) then
    begin
      if (CadOSC_NON_AVI.AsString <> '') and (not CadOSD_DAT_AVI.IsNull) then
      begin
        case varia.TipoRelatorioOS of
         0 : UnOS.ImprimeResumo80(CadOSI_COD_ORS.AsInteger);
         1 : begin
               if rel <> nil then
                 rel.free;
               rel := TCrpe.Create(self);
               rel.ReportName := varia.PathRel + 'diverso\ResumoOrdemServico.rpt';
               rel.Connect.Retrieve;
               rel.Connect.DatabaseName := varia.AliasBAseDados;
               rel.Connect.ServerName := varia.AliasRelatorio;
               rel.WindowState := wsMaximized;
               rel.ParamFields.Retrieve;
               rel.ParamFields[0].Value := CadOSI_COD_ORS.AsString;
               rel.ParamFields[1].Value := CadOSI_EMP_FIL.AsString;
               rel.execute;
             end;
        end;
      end
      else
        aviso('Definir data e contato do término do serivço !');
     end
     else
       aviso('Não a produtos nem serviços viculadas a esta ordem de serviço');
   end
   else
     aviso('Você deve gravar o ordem de serviço antes');
end;

procedure TFOrdemServico.EtipoEntregaCadastrar(Sender: TObject);
begin
  FTipoEntrega := TFTipoEntrega.CriarSDI(application, '',FPrincipal.VerificaPermisao('FTipoEntrega'));
  FTipoEntrega.ShowModal;
  Localiza.AtualizaConsulta;
end;



procedure TFOrdemServico.ConsultaOS(NroOS : integer);
begin
  ConsultandoOS := true;
  EOSSelect(nil);
  Paginas.ActivePage := TabSheet1;
  if NroOS <> 0 then
  begin
    EOS.Text := IntToStr(NroOS);
    EOS.Atualiza;
  end
  else
    Paginas.Enabled := false;
  DataClientes.AutoEdit := false;
  DataMovOs.AutoEdit := false;
  DataMovOSServico.AutoEdit := false;
  DataMovTerceiros.AutoEdit := false;
  DataCadOs.AutoEdit := false;
  BotaoGravar1.Enabled := false;
  BotaoCadastrar1.Visible := false;
  BotaoAlterar2.Visible := false;
//  ImpAbertura.Visible := false;
  if CadOS.State in [dsEdit, dsInsert ] then
    CadOS.Cancel;
  self.ShowModal;
end;


procedure TFOrdemServico.SpeedButton18Click(Sender: TObject);
begin
  CadOSD_DAT_AGE.Clear;
end;

procedure TFOrdemServico.SpeedButton19Click(Sender: TObject);
begin
  CadOSH_HOR_AGE.Clear;
end;

procedure TFOrdemServico.DBEditLocaliza5Select(Sender: TObject);
begin
  if (sender is TDBEditLocaliza) then
  begin
    (sender as TDBEditLocaliza).ASelectValida.clear;
    (sender as TDBEditLocaliza).ASelectValida.add(' SELECT * FROM CADUSUARIOS ' +
                                                  ' WHERE I_COD_USU = @  ' +
                                                  ' and C_USU_ATI = ''S'' ' );
    (sender as TDBEditLocaliza).ASelectLocaliza.clear;
    (sender as TDBEditLocaliza).ASelectLocaliza.add(' SELECT * FROM CADUSUARIOS ' +
                                                ' WHERE C_NOM_USU like ''@%''  ' +
                                                ' and C_USU_ATI = ''S'' ' );
 end;
end;

procedure TFOrdemServico.BitBtn1Click(Sender: TObject);
begin
  case varia.TipoRelatorioOS of
    0 : UnOS.ImprimeFichaTecnica80(CadOSI_COD_ORS.AsInteger);
    1 : begin
          if rel <> nil then
            rel.free;
          rel := TCrpe.Create(self);
          rel.ReportName := varia.PathRel + 'diverso\PropostaOrdemServico.rpt';
          rel.Connect.Retrieve;
          rel.Connect.DatabaseName := varia.AliasBAseDados;
          rel.Connect.ServerName := varia.AliasRelatorio;
          rel.WindowState := wsMaximized;
          rel.ParamFields.Retrieve;
          rel.ParamFields[0].Value := CadOSI_COD_ORS.AsString;
          rel.ParamFields[1].Value := CadOSI_EMP_FIL.AsString;
          rel.execute;
        end;
    2 : begin end;
  end;
end;

procedure TFOrdemServico.DBComboBox1Change(Sender: TObject);
begin
  if CadOS.State in [dsInsert, dsEdit] then
  begin
    Label25.Enabled := DBComboBox1.Text = 'Chamado';
    Label26.Enabled := DBComboBox1.Text = 'Chamado';
    DBEditColor5.Enabled := DBComboBox1.Text = 'Chamado';
    DBEditColor4.Enabled := DBComboBox1.Text = 'Chamado';
    SpeedButton18.Enabled := DBComboBox1.Text = 'Chamado';
    SpeedButton19.Enabled := DBComboBox1.Text = 'Chamado';
  end;
end;

procedure TFOrdemServico.numerico1Exit(Sender: TObject);
begin
  if BotaoCadastrar1.Enabled then  // caso a os nao esteja em insercao nem edicao
  begin
    CadOS.insert;
    BotaoCadastrar1DepoisAtividade(nil);
  end;

  if numerico1.avalor <> 0 then
    if UnOS.CopiaOS(CadOS, CadOSI_COD_ORS.AsInteger, trunc(numerico1.avalor)) then
    begin
      numerico1.Enabled := false;
      label64.Enabled := false;
      AtualizaLocalizas([DelCliente,DBEditLocaliza8,DBEditLocaliza9,DBEditLocaliza10]);
      CalculaTotal;
    end;
end;

procedure TFOrdemServico.BotaoGravar1DepoisAtividade(Sender: TObject);
begin
  if Inserindo then
    UnOS.AdicionaProdutoServico( CadOSI_COD_ORS.AsString, CadOSI_COD_EQU.AsString,
                                 CadOSI_COD_MAR.AsString,CadOSI_COD_MOD.AsString);

end;

procedure TFOrdemServico.BitBtn4Click(Sender: TObject);
begin
  FAtendimentoExtra := TFAtendimentoExtra.CriarSDI(application, '', true);
  FAtendimentoExtra.AlteraAtendimento(CadOSI_COD_ORS.AsInteger);
end;

procedure TFOrdemServico.DBEditLocaliza8Cadastrar(Sender: TObject);
begin
  FEquipamento := TFEquipamento.CriarSDI(application, '',Fprincipal.VerificaPermisao('FEquipamento'));
  FEquipamento.ShowModal;
end;

procedure TFOrdemServico.DBEditLocaliza9Cadastrar(Sender: TObject);
begin
  FMarca := TFMarca.CriarSDI(application, '',Fprincipal.VerificaPermisao('FMarca'));
  FMarca.ShowModal;
end;

procedure TFOrdemServico.DBEditLocaliza10Cadastrar(Sender: TObject);
begin
  FModelo := TFModelo.CriarSDI(application, '',Fprincipal.VerificaPermisao('FModelo'));
  FModelo.ShowModal;
end;

procedure TFOrdemServico.eprodutoCadastrar(Sender: TObject);
begin
  FNovoProduto := TFNovoProduto.CriarSDI(application, '', FPrincipal.VerificaPermisao('FNovoProduto'));
  FNovoProduto.InsereNovoProduto(false);
end;

Initialization
 RegisterClasses([TFOrdemServico]);
end.
