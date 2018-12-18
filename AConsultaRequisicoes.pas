unit AConsultaRequisicoes;
//Autor:Jorge Eduardo Rodrigues
//Função:Consultar Requisições
//Data:03 de maio de 2001
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Buttons, BotaoCadastro, Componentes1, ExtCtrls, PainelGradiente,
  Localizacao, Grids, DBGrids, Tabela, DBKeyViolation, Db, DBTables, UnRequisicaoMaterial,
  ComCtrls, Mask, numericos, DBCtrls, UCrpe32;

type
  TFConsultaRequisicoes = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    EditUsuario: TEditLocaliza;
    Label1: TLabel;
    Label2: TLabel;
    ConsultaPadrao1: TConsultaPadrao;
    SpeedButton1: TSpeedButton;
    Data1: TCalendario;
    Data2: TCalendario;
    Label3: TLabel;
    Label4: TLabel;
    ConsultaReq: TQuery;
    DataConsultaReq: TDataSource;
    PanelColor2: TPanelColor;
    BotaoFechar1: TBitBtn;
    BBAjuda: TBitBtn;
    BotaoCadastrar1: TBitBtn;
    BotaoCancelar1: TBitBtn;
    BBImprimir: TBitBtn;
    GridReq: TGridIndice;
    Label5: TLabel;
    EUsuReq: TEditLocaliza;
    SpeedButton2: TSpeedButton;
    Label6: TLabel;
    ConsultaReqI_Emp_Fil: TIntegerField;
    ConsultaReqI_Cod_Req: TIntegerField;
    ConsultaReqI_Cod_Usu: TIntegerField;
    ConsultaReqNomeReq: TStringField;
    ConsultaReqI_Usu_Req: TIntegerField;
    ConsultaReqNomeUsu: TStringField;
    ConsultaReqD_Dat_Req: TDateField;
    CodReq: Tnumerico;
    Label7: TLabel;
    CSituacao: TComboBoxColor;
    Label8: TLabel;
    ConsultaReqc_sit_req: TStringField;
    Grade2: TGridIndice;
    DataMovReq: TDataSource;
    MovReq: TQuery;
    MovReqN_Qtd_Pro: TFloatField;
    MovReqC_Nom_pro: TStringField;
    MovReqC_Cod_Uni: TStringField;
    MovReqC_Cod_Pro: TStringField;
    MovReqc_cod_bar: TStringField;
    DBMemoColor1: TDBMemoColor;
    ConsultaReqL_obs_req: TMemoField;
    ConsultaReqi_nro_ors: TIntegerField;
    ConsultaReqi_nro_orp: TIntegerField;
    ConsultaReqi_nro_nof: TIntegerField;
    ConsultaReqi_nro_ped: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BotaoFechar1Click(Sender: TObject);
    procedure Data1CloseUp(Sender: TObject);
    procedure EditUsuarioRetorno(Retorno1, Retorno2: String);
    procedure BBExlcuirClick(Sender: TObject);
    procedure BBImprimirClick(Sender: TObject);
    procedure BotaoCadastrar1Click(Sender: TObject);
    procedure BotaoCancelar1Click(Sender: TObject);
    procedure ConsultaReqAfterScroll(DataSet: TDataSet);
  private
    rel : TCrpe;
    UnReqMat : TFuncoesReqMaterial;
    procedure LimpaFiltros;
    procedure AdicionaFiltros (VPaSelect: Tstrings);
    procedure AtualizaConsulta;
  public
  end;

var
  FConsultaRequisicoes: TFConsultaRequisicoes;

implementation

uses APrincipal,Constantes,fundata, funstring,constmsg,funObjeto,
     FunSql,ARequisicaodeMaterial,funnumeros,UnImpressao,UnClassesImprimir,
  AImprimeReqMaterial;

{$R *.DFM}

{ ****************** Na criação do Formulário ******************************** }
procedure TFConsultaRequisicoes.FormCreate(Sender: TObject);
begin
  UnReqMat := TFuncoesReqMaterial.Criar(self, FPrincipal.BaseDados);
  Data1.Date := PrimeiroDiaMes(Date);
  Data2.Date := UltimoDiaMes(Date);
  CSituacao.ItemIndex := 0;
  AtualizaConsulta;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFConsultaRequisicoes.FormClose(Sender: TObject;  var Action: TCloseAction);
begin
  ConsultaReq.Close;
  UnReqMat.free;
  rel.free;
  Action := CaFree;
end;

{************************** FECHAR ******************************************}
procedure TFConsultaRequisicoes.BotaoFechar1Click(Sender: TObject);
begin
  close;
end;

//                     PROCEDURE ATUALIZA CONSULTA
procedure TFConsultaRequisicoes.AtualizaConsulta;
begin
  ConsultaReq.Close;
  ConsultaReq.Sql.Clear;
  ConsultaReq.Sql.add(' select CadReq.I_Emp_Fil, cadreq.c_sit_req, ' +
                      ' CadReq.I_Cod_Req,CadReq.I_Cod_Usu, ' +
                      ' CadUsu1.C_Nom_Usu NomeReq,CadReq.I_Usu_Req, ' +
                      ' CadUsu2.C_Nom_Usu NomeUsu,CadReq.D_Dat_Req, cadReq.L_obs_req, ' +
                      ' cadreq.i_nro_ors, cadreq.i_nro_orp, cadreq.i_nro_nof, cadreq.i_nro_ped ' +
                      ' From ' +
                      ' CadRequisicaoMaterial as CadReq, ' +
                      ' CadUsuarios as CadUsu1, ' +
                      ' CadUsuarios as CadUsu2 ' );
  AdicionaFiltros(ConsultaReq.SQL);
  ConsultaReq.Sql.add(' and CadReq.I_Cod_Usu = CadUsu2.I_Cod_Usu ' +
                      ' and CadReq.I_Usu_Req = CadUsu1.i_Cod_usu ' );
  ConsultaReq.SQL.Add(' order by CadReq.i_cod_req');
  ConsultaReq.Open;
end;

// ADICIONA FILTROS
procedure TFConsultaRequisicoes.AdicionaFiltros(VPaSelect: TStrings);
begin
  VpaSelect.add(' Where CadReq.I_Emp_Fil = ' + IntToStr(Varia.CodigoEmpFil));
  VpaSelect.add(SQLTextoDataEntreAAAAMMDD( 'd_dat_req', data1.DateTime, data2.DateTime, true));

  if EditUsuario.Text <> '' then
    VpaSelect.add(' and CadReq.I_COD_USU = ' + EditUsuario.text)
  else
   VpaSelect.add(' ');

  if EUsuReq.Text <> '' then
    VpaSelect.add(' and CadReq.I_USU_REQ = ' + EUsuReq.text )
  else
   VpaSelect.add(' ');

  if CodReq.AValor <> 0 then
    VpaSelect.add(' and CadReq.I_COD_REQ = ' + Inttostr(trunc(CodReq.AValor)) )
  else
    VpaSelect.add(' ');

  case CSituacao.ItemIndex of
    0 : VpaSelect.add(' and CadReq.c_sit_req = ''E''');
    1 : VpaSelect.add(' and CadReq.c_sit_req = ''C''');
    2 : VpaSelect.add(' ');
  end;

end;

//                              LimpaFiltros
procedure TFConsultaRequisicoes.LimpaFiltros;
begin
  LimpaEdits(PanelColor1);
  AtualizaLocalizas([EditUsuario]);
  Data1.Date := PrimeiroDiaMes(Date);
  Data2.Date := UltimoDiaMes(Date);
end;

//                       Data1 AtualizaConsulta
procedure TFConsultaRequisicoes.Data1CloseUp(Sender: TObject);
begin
  AtualizaConsulta;
end;

{********************************** EDITLOCALIZA  EVENTO      *************************}
procedure TFConsultaRequisicoes.EditUsuarioRetorno(Retorno1,
  Retorno2: String);
begin
  AtualizaConsulta;
end;


{******************************** Chama a procedure DeletaRequisicoes ***********************}
procedure TFConsultaRequisicoes.BBExlcuirClick(Sender: TObject);
begin
end;

{*************************************** Recebe Parâmetro Imprime Req **********************}
procedure TFConsultaRequisicoes.BBImprimirClick(Sender: TObject);
var
  TextoDoc : string;
  NroDoc : integer;
begin
  if ConsultaReqI_NRO_ORS.AsInteger <> 0 then
  begin
    TextoDoc := 'Nro OS :';
    NroDoc := ConsultaReqI_NRO_ORS.AsInteger;
  end
  else
    if ConsultaReqI_NRO_ORP.AsInteger <> 0 then
    begin
      TextoDoc := 'Nro OP :';
      NroDoc := ConsultaReqI_NRO_ORP.AsInteger;
    end
    else
      if ConsultaReqI_NRO_PED.AsInteger <> 0 then
      begin
        TextoDoc := 'Nro Pedido :';
        NroDoc := ConsultaReqI_NRO_PED.AsInteger;
      end
      else
        if ConsultaReqI_NRO_NOF.AsInteger <> 0 then
        begin
          TextoDoc := 'Nro NF :';
          NroDoc := ConsultaReqI_NRO_NOF.AsInteger;
        end;

  case varia.TipoImpGra_matReqMat of
    1 : UnReqMat.ImprimeRequisicoes(ConsultaReqI_Cod_Req.AsInteger, varia.CodigoEmpFil);
    2 : begin
         FImprimeReqMaterial := TFImprimeReqMaterial.CriarSDI(application,'',FPrincipal.VerificaPermisao('FImprimeReqMaterial'));
         FImprimeReqMaterial.CarregaReqmateria(ConsultaReqI_Cod_Req.AsInteger,ConsultaReqI_Emp_Fil.AsInteger,NroDoc, varia.NomeFilial,TextoDoc );
        end;
    3 : Begin
            if rel <> nil then
              rel.free;

            rel := TCrpe.Create(self);
            rel.ReportName := varia.PathRel + 'Diverso\RequisicaoMaterial.rpt';
            rel.Connect.Retrieve;
            rel.Connect.DatabaseName := varia.AliasBAseDados;
            rel.Connect.ServerName := varia.AliasRelatorio;
            rel.WindowState := wsMaximized;

            rel.ParamFields.Retrieve;
            rel.ParamFields[0].Value := ConsultaReqI_COD_REQ.AsString;
            rel.ParamFields[1].Value := ConsultaReqI_EMP_FIL.AsString;
            rel.ParamFields[2].value := varia.NomeFilial;

            rel.execute;
         end;
    end;
end;

procedure TFConsultaRequisicoes.BotaoCadastrar1Click(Sender: TObject);
begin
  FRequisicaoDeMaterial := TFRequisicaoDeMaterial.CriarSDI(Application,'',FPrincipal.VerificaPermisao('FRequisicaoDeMaterial'));
  FRequisicaoDeMaterial.NovaRequiciaoDeMaterial;
  FRequisicaoDeMaterial.ShowModal;
  AtualizaConsulta;
end;

procedure TFConsultaRequisicoes.BotaoCancelar1Click(Sender: TObject);
begin
  if Varia.CodOpeReqMatCancelar <> 0 then
  begin
    if SenhaFaturamento then
      if confirmacao('Deseja realmente cancelar esta requisição?')   Then
      begin
        UnReqMat.cancelaReq(ConsultaReqI_Cod_Req.AsInteger, varia.CodigoEmpFil);
        AtualizaConsulta;
      end;
  end
  else
    aviso('');
end;

procedure TFConsultaRequisicoes.ConsultaReqAfterScroll(DataSet: TDataSet);
begin
  UnReqMat.LocalizaConsultaMovReqImpressao(MovReq,ConsultaReqI_Cod_Req.AsInteger,ConsultaReqI_Emp_Fil.AsInteger);
end;

Initialization
  RegisterClasses([TFConsultaRequisicoes]);
end.                                //AMANHÃ TEM MAIS!!!!!!!!!
