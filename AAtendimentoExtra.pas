unit AAtendimentoExtra;
{    Autor: Jorge Eduardo e Leonardo
    Data Criação: 01 de agosto de 2001;
    Função: Cadastrar  Atividades/Atendimentos Extra
    Data Alteração:
    Alterado por:
    Motivo alteração:
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Buttons, ExtCtrls, Componentes1, PainelGradiente, Db, DBTables,
  Tabela, BotaoCadastro, Grids, DBGrids, DBKeyViolation, Localizacao, Mask,
  DBCtrls;

type
  TFAtendimentoExtra = class(TFormularioPermissao)
    PanelColor2: TPanelColor;
    PanelColor3: TPanelColor;
    LocalizaOs: TEditLocaliza;
    Procurador: TConsultaPadrao;
    MovLabOs: TSQL;
    DataMovLabOs: TDataSource;
    SpeedButton2: TSpeedButton;
    Aux: TQuery;
    Label2: TLabel;
    DataMovAtendimentoCampoOS: TDataSource;
    MovAtendimentoCampoOS: TSQL;
    MovAtendimentoCampoOSI_EMP_FIL: TIntegerField;
    MovAtendimentoCampoOSI_COD_ORS: TIntegerField;
    MovAtendimentoCampoOSI_SEQ_MOV: TIntegerField;
    MovAtendimentoCampoOSI_COD_USU: TIntegerField;
    MovAtendimentoCampoOSD_DAT_INI: TDateField;
    MovAtendimentoCampoOSI_KME_INI: TIntegerField;
    MovAtendimentoCampoOSI_KME_FIN: TIntegerField;
    MovAtendimentoCampoOSI_KME_TOT: TIntegerField;
    MovAtendimentoCampoOSD_ULT_ALT: TDateField;
    EditLocaliza1: TDBEditLocaliza;
    MovLabOsI_EMP_FIL: TIntegerField;
    MovLabOsI_COD_ORS: TIntegerField;
    MovLabOsI_SEQ_MOV: TIntegerField;
    MovLabOsI_COD_USU: TIntegerField;
    MovLabOsH_HOR_INI: TTimeField;
    MovLabOsH_HOR_FIM: TTimeField;
    MovLabOsD_DAT_TRA: TDateField;
    MovLabOsD_ULT_ALT: TDateField;
    AuxI_COD_USU: TIntegerField;
    AuxC_NOM_USU: TStringField;
    MovLabOsUsuario: TStringField;
    MovAtendimentoCampoOSI_INS_USU: TIntegerField;
    MovAtendimentoCampoOSI_INS_INI: TIntegerField;
    MovAtendimentoCampoOSI_INS_FIN: TIntegerField;
    MovAtendimentoCampoOSI_INS_TOT: TIntegerField;
    MovAtendimentoCampoOSH_HOR_TOT: TTimeField;
    MovAtendimentoCampoOSD_INS_INI: TDateField;
    Shape15: TShape;
    Shape1: TShape;
    Label17: TLabel;
    SpeedButton5: TSpeedButton;
    Label16: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label18: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    DBHoraFin: TDBEditColor;
    DBHoraIni: TDBEditColor;
    DDataIni: TDBEditColor;
    DBLocaliza: TDBEditLocaliza;
    DBKmFim: TDBEditColor;
    DBKmIni: TDBEditColor;
    DBKmTotal: TDBEditColor;
    Shape2: TShape;
    Label6: TLabel;
    SpeedButton1: TSpeedButton;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    DBHorFimDev: TDBEditColor;
    DBHorIniDev: TDBEditColor;
    DDataIniDev: TDBEditColor;
    DBLocalizaDev: TDBEditLocaliza;
    DBKmFimDev: TDBEditColor;
    DBKmIniDev: TDBEditColor;
    DBKmTotDev: TDBEditColor;
    Label23: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Grade: TDBGridColor;
    Label1: TLabel;
    PanelColor1: TPanelColor;
    BtFechar: TBitBtn;
    BtGravar: TBitBtn;
    BtCancelar: TBitBtn;
    MovAtendimentoCampoOSH_HOR_INI: TDateTimeField;
    MovAtendimentoCampoOSH_HOR_FIM: TDateTimeField;
    MovAtendimentoCampoOSH_INS_INI: TDateTimeField;
    MovAtendimentoCampoOSH_INS_FIM: TDateTimeField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtFecharClick(Sender: TObject);
    procedure LocalizaOsSelect(Sender: TObject);
    procedure LocalizaOsRetorno(Retorno1, Retorno2: String);
    procedure GradeColExit(Sender: TObject);
    procedure EditLocaliza1Retorno(Retorno1, Retorno2: String);
    procedure MovLabOsBeforePost(DataSet: TDataSet);
    procedure GradeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MovLabOsAfterInsert(DataSet: TDataSet);
    procedure MovAtendimentoCampoOSAfterInsert(DataSet: TDataSet);
    procedure MovLabOsBeforeInsert(DataSet: TDataSet);
    procedure BtGravarClick(Sender: TObject);
    procedure MovLabOsAfterPost(DataSet: TDataSet);
    procedure BtCancelarClick(Sender: TObject);
    procedure MovAtendimentoCampoOSAfterEdit(DataSet: TDataSet);
    procedure DBKmIniExit(Sender: TObject);
    procedure DBKmIniDevExit(Sender: TObject);
    procedure MovAtendimentoCampoOSAfterCancel(DataSet: TDataSet);
  private
    procedure CarregaDadosOS( NroOS : integer);
    function ValidaHora(HoraInicial, HoraFinal : TdateTime) : Boolean;
    function ValidaKM(KMInicial, KMFinal : Integer) : Boolean;
    procedure MudaBotao( acao : Boolean );
  public
    procedure  AlteraAtendimento( codOS : Integer);
  end;

var
  FAtendimentoExtra: TFAtendimentoExtra;

implementation

uses APrincipal,Constantes,FunSql,Fundata,FunObjeto,
     FunHardWare,ConstMsg,funstring,funnumeros, AOrdemServico, AVendedores,
     AChamadoTecnico, UsuarioMenu;

{$R *.DFM}

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                          do formulario
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{ ****************** Na criação do Formulário ******************************** }
procedure TFAtendimentoExtra.FormCreate(Sender: TObject);
begin

end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFAtendimentoExtra.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MovLabOs.Close;
  MovAtendimentoCampoOS.Close;
  Action := CaFree;
end;

{ *************** ao fecharo formualrio  *********************************** }
procedure TFAtendimentoExtra.BtFecharClick(Sender: TObject);
begin
  Self.Close;
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                         Localiza os
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{*********************** SELECT QUE LOCALIZA OS E CLIENTE *****************}
procedure TFAtendimentoExtra.LocalizaOsSelect(Sender: TObject);
begin
  LocalizaOS.ASelectValida.clear;
  LocalizaOS.ASelectLocaliza.clear;
  LocalizaOS.ASelectValida.Add(' Select *  from CadOrdemServico ord, cadClientes cli ' +
                               ' where ord.i_cod_ors = @ ' +
                               ' and ord.i_emp_fil = ' + Inttostr(varia.CodigoEmpFil) +
                               ' and ord.i_cod_cli = cli.i_cod_cli ');

  LocalizaOS.ASelectLocaliza.Add(' Select *  from CadOrdemServico ord, cadClientes cli ' +
                                 ' where cli.c_nom_cli like ''@%'' ' +
                                 ' and ord.i_emp_fil = ' + Inttostr(varia.CodigoEmpFil) +
                                 ' and ord.i_cod_cli = cli.i_cod_cli ' );
end;

{*************************** RETORNO DO LOCALIZA OS ***************************}
procedure TFAtendimentoExtra.LocalizaOsRetorno(Retorno1, Retorno2: String);
begin
  if Retorno1 <> '' then
  begin
    CarregaDadosOS(Strtoint(Retorno1));
    PanelColor3.Enabled := true;
    if self.visible then
      Grade.SetFocus;
  end
  else
    PanelColor3.Enabled := true;
end;

procedure TFAtendimentoExtra.MudaBotao( acao : Boolean );
begin
  BtFechar.Enabled := not acao;
  BtCancelar.Enabled := acao;
  BtGravar.Enabled := acao;
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                         Localiza e valida tabelas
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{*************************  INSERE DADOS NOS EDITS DO GROUP BOX ***************}
procedure TFAtendimentoExtra.CarregaDadosOS( NroOS : integer);
begin
  // no laboratorio
  AdicionaSQLAbreTabela(MovLabOs,' select * from MovAtendimentoLabOS ' +
                                 ' where I_EMP_FIL = ' + IntToStr(Varia.CodigoEmpFil)+
                                 ' and  I_COD_ORS = ' + IntToStr(NroOS));
  // no campo
  AdicionaSQLAbreTabela(MovAtendimentoCampoOS,' select * from MovAtendimentoCampoOS ' +
                                              ' where I_EMP_FIL = ' +  IntToStr(Varia.CodigoEmpFil) +
                                              ' and  I_COD_ORS = ' +  IntToStr(NroOS));

  if not MovAtendimentoCampoOS.Eof then  // caso exista o registro do movimento de campo
  begin
    MovAtendimentoCampoOS.Edit;
    DBLocaliza.Atualiza;
    DBLocalizaDev.Atualiza;
  end
  else
    MovAtendimentoCampoOS.Insert;
end;
{************************* ACOES APOS INSERRIR DADOS NA MOVLABOS ***************}
procedure TFAtendimentoExtra.MovLabOsAfterInsert(DataSet: TDataSet);
begin
  if MovLabOs.State in [DsInsert, DsEdit] then
  MovLabOsI_EMP_FIL.AsInteger := Varia.CodigoEmpFil;
  MovLabOsI_COD_ORS.AsString := LocalizaOs.Text;
  MovLabOsI_SEQ_MOV.AsInteger := ProximoCodigoFilialCampo('MovAtendimentoLabOs','I_SEQ_MOV','I_EMP_FIL','I_COD_ORS',Varia.CodigoEmpFil,MovLabOsI_COD_ORS.AsInteger,FPrincipal.BaseDados);
  MovLabOsD_ULT_ALT.AsDateTime := Date;  // DATA DA ULTIMA ALTERAÇAO
  MovLabOsD_DAT_TRA.AsDateTime := date;
end;

{********************* ACOES APOS INSERRIR DADOS NA MOVCAMPOOS ***************}
procedure TFAtendimentoExtra.MovAtendimentoCampoOSAfterInsert(
  DataSet: TDataSet);
begin
  MovAtendimentoCampoOSI_EMP_FIL.AsInteger := Varia.CodigoEmpFil;
  MovAtendimentoCampoOSI_COD_ORS.AsString := LocalizaOs.Text;
  MovAtendimentoCampoOSI_SEQ_MOV.AsInteger := ProximoCodigo('MovAtendimentoCampoOS','I_SEQ_MOV', FPrincipal.BaseDados);
  MovAtendimentoCampoOSD_ULT_ALT.AsDateTime := Date;
  MovAtendimentoCampoOSD_DAT_INI.AsDateTime := (Date);
  MudaBotao(true);
end;

{********* NÃO PERMITE CAMPOS DA TABELA MOVLABOS VAZIOS ******************}
procedure TFAtendimentoExtra.MovLabOsBeforePost(DataSet: TDataSet);
begin
  if MovLabOs.State in [dsInsert, dsEdit] then
    if MovLabOsD_DAT_TRA.IsNull or  MovLabOsI_SEQ_MOV.isnull or
      MovLabOsI_COD_USU.IsNull or  MovLabOsH_HOR_INI.IsNull or
      MovLabOsH_HOR_FIM.IsNull then
    begin
      Informacao (' Dados imcompletos! ');               //NÃO PERMITE CAMPOS VAZIOS
      abort;
    end;
  if not ValidaHora(MovLabOsH_HOR_INI.AsDateTime,MovLabOsH_HOR_FIM.AsDateTime) then
    abort;
end;

{**************************** ACOES APOS GRAVAR DADOS NA TABELA ***************}
procedure TFAtendimentoExtra.MovLabOsAfterPost(DataSet: TDataSet);
begin
  AtualizaSQLTabela(MovLabOs); //Atualiza tabela
  MovLabOs.Last;               //Passa para ultima linha
end;

{******************************* valida enabled dos botoes *******************}
procedure TFAtendimentoExtra.MovAtendimentoCampoOSAfterEdit(
  DataSet: TDataSet);
begin
    MudaBotao(true);
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                          funcoes da grade
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{************************** ACOES DO GRID COM TECLAS DE ATALHO ****************}
procedure TFAtendimentoExtra.GradeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 114)  and (Grade.SelectedIndex = 0) then  // localiza tecnicos pressionado F3
  begin
    if not (MovLabOs.State in [DsInsert, DsEdit]) then
    begin
      if MovLabOsI_COD_USU.AsInteger <> 0 then
        MovLabOs.Insert
      else
        MovLabOs.edit;
    end;
    EditLocaliza1.AAbreLocalizacao;
  end;

  if ( not MovLabOs.IsEmpty) and (key = 46) then
  if Confirmacao(CT_DeletaRegistro) then      // DELETE
  MovLabOs.delete;

  if key = 45 then
  begin
    MovLabOs.Append;      // INSERT
    key := 0;
  end;
end;

{******************** SELECIONA A SEGUNDA COLUNA DO GRID ***********************}
procedure TFAtendimentoExtra.GradeColExit(Sender: TObject);
begin
  if MovLabOs.State in [dsInsert, dsEdit] then
    case grade.SelectedIndex of
      0 : EditLocaliza1.Atualiza;
    end;
end;

{*************************** SELECIONA CAMPO DA GRADE *************************}
procedure TFAtendimentoExtra.MovLabOsBeforeInsert(DataSet: TDataSet);
begin
  if Grade.Focused then
   Grade.SelectedIndex := 0;
end;

{********************** ACAO DO EVENTO ON RETORNO *************************}
procedure TFAtendimentoExtra.EditLocaliza1Retorno(Retorno1,Retorno2: String);
begin
  if Retorno1 <> '' then
    MovLabOsI_COD_USU.AsString := Retorno1;
  MovLabOsUsuario.AsString := Retorno2;
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                          valida componentes
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{************ valida Hora ****************************************************}
function TFAtendimentoExtra.ValidaHora(HoraInicial, HoraFinal : TdateTime) : Boolean;
begin
  result := true;
  if HoraFinal < HoraInicial then
  begin
    result := false;
    Informacao (' Hora invalida! ');
  end;
end;

{************ valida Kilometragem  *******************************************}
function TFAtendimentoExtra.ValidaKM(KMInicial, KMFinal : Integer) : Boolean;
begin
  result := true;
  if KMFinal < KMInicial then
  begin
    result := false;
    Informacao (' Kilometragem Invalida! ');
  end;
end;

{*************** calcula total Kilometro ************************************}
procedure TFAtendimentoExtra.DBKmIniExit(Sender: TObject);
begin
  MovAtendimentoCampoOSI_KME_TOT.AsInteger := MovAtendimentoCampoOSI_KME_FIN.AsInteger - MovAtendimentoCampoOSI_KME_INI.AsInteger;
end;

{*************** calcula total Kilometro ************************************}
procedure TFAtendimentoExtra.DBKmIniDevExit(Sender: TObject);
begin
  MovAtendimentoCampoOSI_INS_TOT.AsInteger := MovAtendimentoCampoOSI_INS_FIN.AsInteger - MovAtendimentoCampoOSI_INS_INI.AsInteger;
end;

{************************ GARVA REGISTRO NAS DUAS TABELAS *********************}
procedure TFAtendimentoExtra.BtGravarClick(Sender: TObject);
begin
  if not ValidaHora(MovAtendimentoCampoOSH_HOR_INI.AsDateTime, MovAtendimentoCampoOSH_HOR_FIM.AsDateTime) then
    DBHoraIni.SetFocus;
  if not ValidaHora(MovAtendimentoCampoOSH_INS_INI.AsDateTime,  MovAtendimentoCampoOSH_INS_FIM.AsDateTime) then
    DBHorIniDev.SetFocus;
  if not ValidaKM(MovAtendimentoCampoOSI_KME_INI.AsInteger, MovAtendimentoCampoOSI_KME_FIN.AsInteger) then
    DBKmIni.SetFocus;
  if not ValidaKM(MovAtendimentoCampoOSI_INS_INI.AsInteger, MovAtendimentoCampoOSI_INS_FIN.AsInteger) then
    DBKmFimDev.SetFocus;

  if BtGravar.Focused then
  begin
    if  MovLabOs.State in [DsInsert, DsEdit]then    // MOVLABOS
      MovLabOs.Post;
    if  MovAtendimentoCampoOS.State in [DsInsert, DsEdit] then  // MOVCAMPOOS
      MovAtendimentoCampoOS.Post;
    MudaBotao(false);
    MovLabOs.close;
    MovAtendimentoCampoOS.close;
    LocalizaOs.Text := '';
    LocalizaOs.Atualiza;
    LocalizaOs.SetFocus;
  end;
end;

{************************** CANCELA OPERAÇAO NAS TABELAS **********************}
procedure TFAtendimentoExtra.BtCancelarClick(Sender: TObject);
begin
  if (MovLabOs.State in [DsInsert, DsEdit]) then    // MOVLABOS
    MovLabOs.Cancel;
  if (MovAtendimentoCampoOS.State in [DsInsert, DsEdit]) then  // MOVCAMPOOS
    MovAtendimentoCampoOS.Cancel;
  MudaBotao(false);
  MovLabOs.close;
  MovAtendimentoCampoOS.close;
  LocalizaOs.Text := '';
  LocalizaOs.Atualiza;
  LocalizaOs.SetFocus;
end;


procedure TFAtendimentoExtra.MovAtendimentoCampoOSAfterCancel(
  DataSet: TDataSet);
begin
  MudaBotao(false);
end;

procedure TFAtendimentoExtra.AlteraAtendimento( codOS : Integer);
begin
  LocalizaOsSelect(nil);
  LocalizaOs.Text := Inttostr(codOs);
  LocalizaOs.Atualiza;
  self.ShowModal
end;


Initialization
 RegisterClasses([TFAtendimentoExtra]);
end.
