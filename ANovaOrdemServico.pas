unit ANovaOrdemServico;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  ComCtrls, PainelGradiente, StdCtrls, Buttons, ExtCtrls, Componentes1,
  Mask, DBCtrls, Tabela, Localizacao, Db, DBTables, DBKeyViolation,
  Grids, DBGrids, BotaoCadastro, UnOrdemServico, numericos;

type
  TFNovaOrdemServico = class(TFormularioPermissao)
    PanelColor2: TPanelColor;
    BFechar: TBitBtn;
    BBAjuda: TBitBtn;
    Paginas: TPageControl;
    TabSheet3: TTabSheet;
    Localiza: TConsultaPadrao;
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
    Label39: TLabel;
    DBEditLocaliza7: TDBEditLocaliza;
    SpeedButton11: TSpeedButton;
    Shape10: TShape;
    Label40: TLabel;
    Label41: TLabel;
    DBEditColor11: TDBEditColor;
    Label42: TLabel;
    DBEditColor12: TDBEditColor;
    Label43: TLabel;
    DBEditColor13: TDBEditColor;
    Label44: TLabel;
    DBEditColor14: TDBEditColor;
    Shape13: TShape;
    Label45: TLabel;
    DBEditColor15: TDBEditColor;
    Label46: TLabel;
    DBEditColor16: TDBEditColor;
    Label47: TLabel;
    DBEditColor17: TDBEditColor;
    BotaoCadastrar2: TBotaoCadastrar;
    BotaoGravar2: TBotaoGravar;
    BotaoCancelar2: TBotaoCancelar;
    BotaoExcluir1: TBotaoExcluir;
    BotaoAlterar1: TBotaoAlterar;
    MovTerceirosN_VLR_COB: TFloatField;
    Label59: TLabel;
    DBEditColor24: TDBEditColor;
    MovTerceirosD_ULT_ALT: TDateField;
    Label3: TLabel;
    DBEditColor5: TDBEditColor;
    Label11: TLabel;
    Shape4: TShape;
    DBEditColor9: TDBEditColor;
    MovTerceirosC_DES_PRO: TStringField;
    Label12: TLabel;
    DBEditColor1: TDBEditColor;
    ValidaGravacao1: TValidaGravacao;
    MovTerceirosC_ACE_TER: TStringField;
    MovTerceirosI_COD_TRA: TIntegerField;
    MovTerceirosC_MOD_GRA: TStringField;
    MovTerceirosC_LAU_GAR: TStringField;
    Label17: TLabel;
    DBEditColor2: TDBEditColor;
    DBEditLocaliza6: TDBEditLocaliza;
    SpeedButton1: TSpeedButton;
    Label19: TLabel;
    Label20: TLabel;
    Shape2: TShape;
    Shape5: TShape;
    Label21: TLabel;
    Label22: TLabel;
    Label24: TLabel;
    DBEditColor3: TDBEditColor;
    DBEditColor7: TDBEditColor;
    Label1: TLabel;
    Label27: TLabel;
    DBEditLocaliza8: TDBEditLocaliza;
    SpeedButton2: TSpeedButton;
    Label70: TLabel;
    Label31: TLabel;
    DBEditLocaliza9: TDBEditLocaliza;
    SpeedButton3: TSpeedButton;
    Label71: TLabel;
    Label67: TLabel;
    DBEditLocaliza10: TDBEditLocaliza;
    SpeedButton4: TSpeedButton;
    Label72: TLabel;
    MovTerceirosC_NRO_SER: TStringField;
    MovTerceirosI_COD_EQU: TIntegerField;
    MovTerceirosI_COD_MAR: TIntegerField;
    MovTerceirosI_COD_MOD: TIntegerField;
    Label81: TLabel;
    DBComboBoxColor4: TDBComboBoxColor;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure MovTerceirosAfterInsert(DataSet: TDataSet);
    procedure MovTerceirosBeforePost(DataSet: TDataSet);
    procedure MovTerceirosAfterPost(DataSet: TDataSet);
    procedure DBEditColor17Exit(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    UnOS : TFuncoesOrdemServico;
    CadOS, CadUsu : Integer;
  public
    procedure AdiconarNovoTerceiro( CadOS, CadEqu, CadMarca, CadModelo : Integer; NroSerie : string );
    procedure AlterarTerceiro( CadOS, SeqMOv : Integer );
  end;

var
  FNovaOrdemServico: TFNovaOrdemServico;

implementation

{$R *.DFM}


uses
   funsql, APrincipal, constmsg, constantes, ASituacoes,
   funobjeto, AEquipamento, AMarca,
   AModelo, funnumeros;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                  Formulario
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{ ****************** Na criação do Formulário ******************************** }
procedure TFNovaOrdemServico.FormCreate(Sender: TObject);
begin
  UnOS := TFuncoesOrdemServico.Criar(self,FPrincipal.BaseDados);
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFNovaOrdemServico.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FechaTabelaGrava(MovTerceiros);
  UnOS.Free;
  Action := CaFree;
end;

{********************** fecha formulario ************************************ }
procedure TFNovaOrdemServico.BFecharClick(Sender: TObject);
begin
  self.close;
end;


{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                  Terceiros
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

procedure TFNovaOrdemServico.AdiconarNovoTerceiro( CadOS, CadEqu, CadMarca, CadModelo : Integer; NroSerie : string );
begin
  self.CadOS := CadOS;
  MovTerceiros.Open;
  MovTerceiros.insert;
  if CadEqu <> 0 then
    MovTerceirosI_COD_EQU.AsInteger := CadEqu;
  if CadModelo <> 0 then
    MovTerceirosI_COD_MOD.AsInteger := CadModelo;
  if CadMarca <> 0 then
    MovTerceirosI_COD_MAR.AsInteger := CadMarca;
  MovTerceirosC_NRO_SER.AsString := NroSerie;
  AtualizaLocalizas([DBEditLocaliza8,DBEditLocaliza9,DBEditLocaliza10]);
  self.ShowModal;
end;

procedure TFNovaOrdemServico.AlterarTerceiro( CadOS, SeqMOv : Integer );
begin
  self.CadOS := CadOS;
  unos.LocalizaItemTerceiro(MovTerceiros, CadOS, SeqMOv);
  MovTerceiros.edit;
  AtualizaLocalizas([DBEditLocaliza6,DBEditLocaliza8,DBEditLocaliza9,DBEditLocaliza10]);
  self.ShowModal;
end;

procedure TFNovaOrdemServico.MovTerceirosAfterInsert(DataSet: TDataSet);
begin
  MovTerceirosI_EMP_FIL.AsInteger := varia.CodigoEmpFil;
  MovTerceirosI_COD_ORS.AsInteger := CadOS;
end;

procedure TFNovaOrdemServico.MovTerceirosBeforePost(DataSet: TDataSet);
begin
  MovTerceirosD_ULT_ALT.AsDateTime := date;
  if not FPrincipal.BaseDados.InTransaction then
    FPrincipal.BaseDados.StartTransaction;
  MovTerceirosI_SEQ_MOV.AsInteger := ProximoCodigoFilialCampo('MovTerceiroOS','i_seq_mov','i_emp_fil', 'i_cod_ors',varia.CodigoEmpFil,CadOS, FPrincipal.BaseDados);
  if FPrincipal.BaseDados.InTransaction then
    FPrincipal.BaseDados.Commit;
end;

procedure TFNovaOrdemServico.MovTerceirosAfterPost(DataSet: TDataSet);
begin
  AtualizaSQLTabela(MovTerceiros);
end;

procedure TFNovaOrdemServico.DBEditColor17Exit(Sender: TObject);
begin
   if MovTerceiros.State in [ dsEdit, dsInsert ] then
     if MovTerceirosN_VLR_COB.AsCurrency = 0 then
       MovTerceirosN_VLR_COB.AsCurrency :=  MovTerceirosN_VLR_SER.AsCurrency;
end;

procedure TFNovaOrdemServico.FormShow(Sender: TObject);
begin
    DBEditLocaliza7.SetFocus;
end;


Initialization
 RegisterClasses([TFNovaOrdemServico]);
end.
