unit AConsultaCaixas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Db, DBTables, Grids, DBGrids, Tabela, StdCtrls, Buttons, Componentes1,
  ExtCtrls, PainelGradiente, ComCtrls, DBKeyViolation, DBCtrls, Mask,
  numericos, Localizacao;

type
  TFConsultaCaixas = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    BFechar: TBitBtn;
    Consulta: TQuery;
    DataConsulta: TDataSource;
    PanelColor3: TPanelColor;
    Label3: TLabel;
    Data1: TCalendario;
    data2: TCalendario;
    Label4: TLabel;
    TipoTipo: TComboBoxColor;
    Label1: TLabel;
    TipoSituacao: TComboBoxColor;
    TipoData: TComboBoxColor;
    Label2: TLabel;
    Grade: TGridIndice;
    DBMemoColor1: TDBMemoColor;
    BitBtn1: TBitBtn;
    Aux: TQuery;
    BitBtn2: TBitBtn;
    Painel: TCorPainelGra;
    PanelColor4: TPanelColor;
    RTipo: TRadioGroup;
    Rsituacao: TRadioGroup;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    Sumariza: TCheckBox;
    NroCaixa: Tnumerico;
    Label5: TLabel;
    TotalPeso: Tnumerico;
    Label6: TLabel;
    Label7: TLabel;
    TotalPeca: Tnumerico;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    GroupBox1: TGroupBox;
    ENroNota: Tnumerico;
    ESerie: TEditColor;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    NroNF: Tnumerico;
    Serie: TEditColor;
    Label12: TLabel;
    Label13: TLabel;
    EditLocaliza1: TEditLocaliza;
    SpeedButton4: TSpeedButton;
    Label14: TLabel;
    ConsultaPadrao1: TConsultaPadrao;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure TipoDataChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure SumarizaClick(Sender: TObject);
    procedure Data1CloseUp(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure RTipoClick(Sender: TObject);
    procedure ENroNotaExit(Sender: TObject);
    procedure ESerieExit(Sender: TObject);
    procedure EditLocaliza1Select(Sender: TObject);
    procedure EditLocaliza1Retorno(Retorno1, Retorno2: String);
  private
     SeqProduto : integer;
     procedure CarregaConsulta;
  public
    { Public declarations }
  end;

var
  FConsultaCaixas: TFConsultaCaixas;

implementation

uses APrincipal, funsql, constantes, constmsg, AImprimeCaixa, funstring;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFConsultaCaixas.FormCreate(Sender: TObject);
begin
  SeqProduto := 0;
  Data1.Date := date;
  Data2.Date := date;
  TipoTipo.ItemIndex := 0;
  TipoData.ItemIndex := 0;
  TipoSituacao.ItemIndex := 0;
  CarregaConsulta;
  RSituacao.Controls[1].Enabled := false;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFConsultaCaixas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 consulta.close;
 aux.close;
 Action := CaFree;
end;

{****************** Carrega Consulta de Caixas ******************************* }
procedure TFConsultaCaixas.CarregaConsulta;
begin
   LimpaSQLTabela(Consulta);
   InseriLinhaSQL(Consulta, 0, ' Select ' );
   InseriLinhaSQL(Consulta, 1, ' *, pro.i_qtd_cai SomaCaixa ' );
   InseriLinhaSQL(Consulta, 2, ' from MOVCAIXAESTOQUE mov, cadprodutos as pro ');
   InseriLinhaSQL(Consulta, 3, ' where mov.i_emp_fil = ' + inttostr(varia.CodigoEmpFil) );

   case TipoData.ItemIndex of
     0 : InseriLinhaSQL(Consulta, 4, ' ');
     1 : InseriLinhaSQL(Consulta, 4, SQLTextoDataEntreAAAAMMDD('mov.D_DAT_ENT',Data1.DateTime,Data2.DateTime, true));
     2 : InseriLinhaSQL(Consulta, 4, SQLTextoDataEntreAAAAMMDD('mov.D_DAT_SAI',Data1.DateTime,Data2.DateTime, true));
     3 : InseriLinhaSQL(Consulta, 4, SQLTextoDataEntreAAAAMMDD('mov.D_DAT_CAN',Data1.DateTime,Data2.DateTime, true));
   end;

   case TipoTipo.ItemIndex  of
     0 : InseriLinhaSQL(Consulta, 5, ' and mov.c_sit_cai = ''A'' ');
     1 : InseriLinhaSQL(Consulta, 5, ' and mov.c_sit_cai = ''E'' ');
     2 : InseriLinhaSQL(Consulta, 5, ' ');
   end;

   case TipoSituacao.ItemIndex  of
     0 : InseriLinhaSQL(Consulta, 6, ' and (mov.c_tip_cai = ''N'' or mov.c_tip_cai = ''D'')');
     1 : InseriLinhaSQL(Consulta, 6, ' and mov.c_tip_cai = ''N'' ');
     2 : InseriLinhaSQL(Consulta, 6, ' and mov.c_tip_cai = ''C'' ');
     3 : InseriLinhaSQL(Consulta, 6, ' and mov.c_tip_cai = ''D'' ');
     4 : InseriLinhaSQL(Consulta, 6, ' and mov.c_tip_cai = ''I'' ');
     5 : InseriLinhaSQL(Consulta, 6, ' and mov.c_tip_cai = ''E'' ');
     6 : InseriLinhaSQL(Consulta, 6, ' and (mov.c_tip_cai = ''N'' or mov.c_tip_cai = ''D'' or mov.c_tip_cai = ''E'')');
     7 : InseriLinhaSQL(Consulta, 6, ' ');
   end;

   InseriLinhaSQL(Consulta, 7, ' and pro.i_seq_pro = mov.i_seq_pro ' +
                               ' and pro.i_cod_emp = ' + inttostr(varia.CodigoEmpresa) );

   if NroCaixa.AValor <> 0 then
     InseriLinhaSQL(Consulta, 8,' and mov.i_nro_cai = ' + Inttostr(trunc(NroCaixa.AValor)))
   else
     InseriLinhaSQL(Consulta, 8,' ');

   if NroNF.AValor <> 0 then
     InseriLinhaSQL(Consulta, 9,' and mov.i_nro_not = ' + Inttostr(trunc(NroNF.AValor)))
   else
     InseriLinhaSQL(Consulta, 9,' ');

   if Serie.text <> '' then
     InseriLinhaSQL(Consulta, 10,' and mov.c_ser_not = ''' + serie.text + '''')
   else
     InseriLinhaSQL(Consulta, 10,' ');

   if SeqProduto <> 0 then
     InseriLinhaSQL(Consulta, 11,' and mov.i_seq_pro = ' + Inttostr(SeqProduto))
   else
     InseriLinhaSQL(Consulta, 11,' ');

   aux.sql.Text := Consulta.Text;
   DeletaLinhaSQL(Aux, 1);
   InseriLinhaSQL(Aux, 1, ' sum(mov.i_pes_cai) i_pes_cai, sum(pro.i_qtd_cai) qdadeCaixa ' );
   Aux.open;
   TotalPeso.AValor := aux.fieldByName('I_PES_CAI').AsFloat;
   TotalPeca.AValor := aux.fieldByName('QdadeCaixa').AsFloat;
   aux.close;



   if Sumariza.Checked then
   begin
     DeletaLinhaSQL(Consulta, 1);
     InseriLinhaSQL(Consulta, 1, ' sum(mov.i_pes_cai) i_pes_cai, mov.c_cod_pro, pro.c_nom_pro, ' +
                                 ' count(i_nro_cai) i_nro_cai, sum(isnull(pro.i_qtd_cai,0)) SomaCaixa ');
     InseriLinhaSQL(Consulta, 12, ' group by mov.c_cod_pro, pro.c_nom_pro ');
     InseriLinhaSQL(Consulta, 13, ' order by mov.c_cod_pro ');
   end
   else
   begin
     InseriLinhaSQL(Consulta, 12, '  ');
     InseriLinhaSQL(Consulta, 13, ' order by mov.i_seq_cai ');
  end;

   AbreTabela(Consulta);

  if (Consulta.FieldByName('i_pes_cai') is TFloatField) then
    (Consulta.FieldByName('i_pes_cai') as TFloatField).DisplayFormat := varia.MascaraQtd + 'kg';
end;

procedure TFConsultaCaixas.BFecharClick(Sender: TObject);
begin
  self.Close;
end;


procedure TFConsultaCaixas.TipoDataChange(Sender: TObject);
begin
  if not Sumariza.Checked then
  begin
    bitbtn1.Enabled :=  not (TipoSituacao.ItemIndex in [0,2,4,5,6,7]);
    bitbtn2.Enabled :=  TipoSituacao.ItemIndex in [0,1,3,4,5];
  end;
  Data1.Enabled := TipoData.ItemIndex <> 0;
  Data2.Enabled := TipoData.ItemIndex <> 0;
  label3.Enabled := TipoData.ItemIndex <> 0;
  CarregaConsulta;
end;

procedure TFConsultaCaixas.BitBtn1Click(Sender: TObject);
var
  TextoCancelada : string;
begin
  TextoCancelada := '';
  if Confirmacao('Deseja realmente cancelar a caixa nº ' +  Consulta.fieldByName('I_NRO_CAI').AsString + #13 +
                 ' ESTA OPERAÇÃO NÃO BAIXA O ESTOQUE DO PRODUTO')  then
    if Entrada('Observação','Digite a observação do cancelamento', TextoCancelada,false,fprincipal.CorFoco.AFundoComponentes, FPrincipal.CorForm.ACorFormulario) then
  begin
    ExecutaComandoSql(Aux, ' update movcaixaestoque '+
                           ' set d_dat_sai = null,  ' +
                           ' c_tip_cai = ''C'', ' +
                           ' c_obs_cai = ''' + TextoCancelada + ''',' +
                           ' d_dat_can = ' + SQLTextoDataAAAAMMMDD(date)  +
                           ' ,d_ult_alt = ' + SQLTextoDataAAAAMMMDD(date)  +
                           ' where i_nro_cai = ' + Consulta.fieldByName('I_NRO_CAI').AsString  +
                           ' and i_emp_fil =  ' + inttostr(varia.CodigoEmpFil) +
                           ' and i_seq_pro = ' + Inttostr(Consulta.fieldByName('I_SEQ_PRO').AsInteger));
    CarregaConsulta;
  end;
end;

procedure TFConsultaCaixas.BitBtn2Click(Sender: TObject);
begin
 RTipo.ItemIndex := TipoTipo.ItemIndex;
 Rsituacao.ItemIndex := TipoSituacao.ItemIndex;
 painel.Visible := true;
end;

procedure TFConsultaCaixas.BitBtn3Click(Sender: TObject);
var
  tipo, situacao, NroNota : string;
  Atualizar : Boolean;
begin
  Atualizar := true;
  NroNota := '';
  painel.Visible := false;
  case RTipo.ItemIndex  of
     0 : tipo := 'A';
     1 : tipo := 'E';
   end;
   case RSituacao.ItemIndex  of
     0 : situacao := 'N';
     1 : situacao := 'C';
     2 : situacao := 'D';
     3 : situacao := 'I';
     4 : situacao := 'E';
   end;

   // caso vinculo com nota fiscal
   if (ENroNota.avalor <> 0) and (ESerie.text <> '') then
   begin
     AdicionaSQLAbreTabela(aux, ' select * from cadnotafiscais ' +
                                ' where i_emp_fil = ' + IntToStr(varia.CodigoEmpFil)  +
                                ' and i_nro_not = ' + inttostr(trunc(ENroNota.AValor)) +
                                ' and c_ser_not = ' +  ESerie.text );
     if not aux.Eof then
       NroNota  := ', i_nro_not = ' + aux.FieldByname('i_nro_not').AsString +
                   ', c_ser_not = ' + aux.FieldByname('c_ser_not').AsString +
                   ', i_seq_not = ' + aux.FieldByname('i_seq_not').AsString ;
   end;

   if tipo = 'A' then
     NroNota  := ', i_nro_not = null, c_ser_not = null, i_seq_not = null ';

   ExecutaComandoSql(Aux,' update movcaixaestoque ' +
                         ' set c_sit_cai = ''' + tipo + ''', ' +
                         ' c_tip_cai = ''' + situacao + '''' +
                         NroNota +
                         ' ,d_ult_alt = ' + SQLTextoDataAAAAMMMDD(date)  +
                         ' where i_nro_cai = ' + Consulta.fieldByName('I_NRO_CAI').AsString +
                         ' and i_emp_fil = ' + Inttostr(Consulta.fieldByName('I_EMP_FIL').AsInteger) +
                         ' and i_seq_pro = ' + Inttostr(Consulta.fieldByName('I_SEQ_PRO').AsInteger) );
  CarregaConsulta;
end;

procedure TFConsultaCaixas.BitBtn4Click(Sender: TObject);
begin
  painel.Visible := false;
end;

procedure TFConsultaCaixas.SumarizaClick(Sender: TObject);
begin
  Consulta.close;
  if Sumariza.Checked then
  begin
    DBMemoColor1.DataField := '';
    BitBtn1.Enabled := false;
    BitBtn2.Enabled := false;
    Grade.Columns[3].Visible := false;
    Grade.Columns[5].Visible := false;
    Grade.Columns[6].Visible := false;
    Grade.Columns[9].Visible := false;
  end
  else
  begin
    DBMemoColor1.DataField := 'C_OBS_CAI';
    BitBtn1.Enabled := true;
    BitBtn2.Enabled := true;
    TipoDataChange(nil);
    Grade.Columns[3].Visible := true;
    Grade.Columns[5].Visible := true;
    Grade.Columns[6].Visible := true;
    Grade.Columns[9].Visible := true;
  end;
  CarregaConsulta;
end;

procedure TFConsultaCaixas.Data1CloseUp(Sender: TObject);
begin
  CarregaConsulta;
end;

procedure TFConsultaCaixas.BitBtn5Click(Sender: TObject);
begin
  fImprimeCaixa := TfImprimeCaixa.CriarSDI(application, '', FPrincipal.VerificaPermisao('fImprimeCaixa'));
  fImprimeCaixa.carregaImpressao( Consulta.sql.Text, varia.NomeEmpresa, varia.nomefilial,
                                  FormatFloat(varia.MascaraQtd + ' kg', TotalPeso.AValor) , TotalPeca.Text,
                                  TipoData.Text + ' / ' + tipotipo.Text + ' / ' + TipoSituacao.text, TipoSituacao.text );
end;

procedure TFConsultaCaixas.BitBtn6Click(Sender: TObject);
var
  Retorno : string;
begin
  Retorno := Consulta.fieldByName('i_pes_cai').AsString;
  if EntradaNumero('Novo Peso','Digite Novo Peso da Caixa',Retorno,false,FPrincipal.CorFoco.AFundoComponentes, FPrincipal.CorForm.ACorPainel, false, CurrencyDecimals) then
     if Retorno <> '' then
     begin
       ExecutaComandoSql(Aux, ' update movcaixaestoque '+
                              ' set I_PES_CAI = ' + SubstituiStr(Retorno,',','.') +
                              ' ,d_ult_alt = ' + SQLTextoDataAAAAMMMDD(date)  +
                              ' where i_nro_cai = ' + Consulta.fieldByName('I_NRO_CAI').AsString  +
                              ' and i_emp_fil =  ' + inttostr(varia.CodigoEmpFil) );
       CarregaConsulta;
     end;
end;

procedure TFConsultaCaixas.RTipoClick(Sender: TObject);
begin
  Label8.Enabled := Rtipo.ItemIndex = 1;
  Label9.Enabled := Rtipo.ItemIndex = 1;
  ENroNota.Enabled := Rtipo.ItemIndex = 1;
  ESerie.Enabled := Rtipo.ItemIndex = 1;
end;

procedure TFConsultaCaixas.ENroNotaExit(Sender: TObject);
begin
  if ENroNota.AValor <> 0 then
    ESerie.SetFocus;
end;

procedure TFConsultaCaixas.ESerieExit(Sender: TObject);
begin
 if (ENroNota.AValor <> 0) and (ESerie.Text = '') then
 begin
   aviso('Série invalida');
   ESerie.SetFocus;
   abort;
 end;
end;

procedure TFConsultaCaixas.EditLocaliza1Select(Sender: TObject);
begin
  EditLocaliza1.ASelectValida.Clear;
  EditLocaliza1.ASelectValida.add(  ' Select Pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
                                    ' pro.I_SEQ_PRO, mov.C_COD_BAR ' +
                                    ' From cadprodutos as pro, ' +
                                    ' MovQdadeProduto as mov ' +
                                    ' Where pro.I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                                    ' and ' + varia.CodigoProduto + ' = ''@''' +
                                    ' and pro.C_KIT_PRO = ''P'' ' +
                                    ' and pro.I_seq_pro = Mov.I_seq_pro ' +
                                    ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil) );
  EditLocaliza1.ASelectLocaliza.Clear;
  EditLocaliza1.ASelectLocaliza.add(' Select pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
                                    ' pro.I_SEQ_PRO, mov.C_COD_BAR ' +
                                    ' from cadprodutos as pro, ' +
                                    ' MovQdadeProduto as mov ' +
                                    ' Where pro.I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                                    ' and pro.c_nom_pro like ''@%''' +
                                    ' and pro.C_KIT_PRO = ''P'' ' +
                                    ' and pro.I_seq_pro = Mov.I_seq_pro ' +
                                    ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil));
end;

procedure TFConsultaCaixas.EditLocaliza1Retorno(Retorno1,
  Retorno2: String);
begin
  if Retorno1 <> '' then
    SeqProduto := strtoint(Retorno1)
  else
    if EditLocaliza1.text = '' then
      SeqProduto := 0;
  CarregaConsulta;    
end;

Initialization
 RegisterClasses([TFConsultaCaixas]);
end.
