unit AConsultaOS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Componentes1, ComCtrls, Localizacao, Buttons, PainelGradiente,
  Grids, DBGrids, Tabela, DBKeyViolation, ExtCtrls, Mask, numericos, Db,
  DBTables, UnOrdemServico, UCrpe32;

type
  TFConsultaOS = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor3: TPanelColor;
    Label18: TLabel;
    SpeedButton6: TSpeedButton;
    Label20: TLabel;
    Label3: TLabel;
    Ecliente: TEditLocaliza;
    Data1: TCalendario;
    data2: TCalendario;
    Label1: TLabel;
    CadOs: TQuery;
    dataCadOS: TDataSource;
    Localiza: TConsultaPadrao;
    PanelColor2: TPanelColor;
    Label9: TLabel;
    Label10: TLabel;
    Bevel1: TBevel;
    BMais: TSpeedButton;
    BCadastrar: TBitBtn;
    BtAlterar: TBitBtn;
    EQtdTotal: TEditColor;
    EValorTotal: TEditColor;
    CTotal: TCheckBox;
    BConsulta: TBitBtn;
    BtExcluir: TBitBtn;
    BFechar: TBitBtn;
    BSomaNota: TBitBtn;
    BGeraNota: TBitBtn;
    BtCancela: TBitBtn;
    BBAjuda: TBitBtn;
    BtbImprimir: TBitBtn;
    GOrcamento: TGridIndice;
    GridMov: TDBGridColor;
    Label5: TLabel;
    ESituacao: TEditLocaliza;
    SpeedButton2: TSpeedButton;
    Label6: TLabel;
    Label11: TLabel;
    EVendedor: TEditLocaliza;
    SpeedButton4: TSpeedButton;
    Label12: TLabel;
    BitBtn1: TBitBtn;
    MovOrdemServico: TQuery;
    DataMovServicos: TDataSource;
    MovOrdemServicoI_EMP_FIL: TIntegerField;
    MovOrdemServicoI_COD_ORS: TIntegerField;
    MovOrdemServicoI_SEQ_MOV: TIntegerField;
    MovOrdemServicoI_SEQ_PRO: TIntegerField;
    MovOrdemServicoI_COD_EMP: TIntegerField;
    MovOrdemServicoI_COD_SER: TIntegerField;
    MovOrdemServicoI_COD_USU: TIntegerField;
    MovOrdemServicoN_QTD_MOV: TFloatField;
    MovOrdemServicoN_VLR_UNI: TFloatField;
    MovOrdemServicoN_VLR_TOT: TFloatField;
    MovOrdemServicoC_COD_UNI: TStringField;
    MovOrdemServicoC_COD_PRO: TStringField;
    MovOrdemServicoD_ULT_ALT: TDateField;
    EOS: TEditLocaliza;
    SpeedButton12: TSpeedButton;
    Label50: TLabel;
    cadClientes: TQuery;
    cadClientesc_nom_cli: TStringField;
    cadClientesc_cgc_cli: TStringField;
    cadClientesc_cpf_cli: TStringField;
    cadClientesc_ins_cli: TStringField;
    cadClientesenderco: TStringField;
    cadClientesC_Bai_Cli: TStringField;
    cadClientesC_Cep_Cli: TStringField;
    cadClientesMunicipio: TStringField;
    cadClientesfone: TStringField;
    DataClientes: TDataSource;
    PainelTempo1: TPainelTempo;
    Aux: TQuery;
    CadOsi_emp_fil: TIntegerField;
    CadOsI_Cod_Ors: TIntegerField;
    CadOsD_Dat_Cad: TDateField;
    CadOsI_Cod_cli: TIntegerField;
    CadOsC_Nom_Cli: TStringField;
    CadOsD_Dat_Fec: TDateField;
    CadOsC_Sit_Ors: TStringField;
    CadOsI_cod_sit: TIntegerField;
    CadOsC_Nom_Usu: TStringField;
    CadOsC_Nom_sit: TStringField;
    CadOsN_Tot_pro: TFloatField;
    CadOsN_tot_Ser: TFloatField;
    CadOsN_Tot_Ors: TFloatField;
    Flag: TComboBoxColor;
    Label8: TLabel;
    Label7: TLabel;
    CadOsI_Cod_Usu: TIntegerField;
    Periodo: TComboBoxColor;
    BitBtn2: TBitBtn;
    CadOsd_dat_pre: TDateField;
    Tempo: TPainelTempo;
    NroAtendimento: Tnumerico;
    Label2: TLabel;
    CadOsI_NRO_ATE: TIntegerField;
    Label4: TLabel;
    BEstornar: TBitBtn;
    CadOsC_NON_AVI: TStringField;
    CadOsD_DAT_AVI: TDateField;
    BitBtn3: TBitBtn;
    CadOsc_nom_equ: TStringField;
    CadOsc_nom_mar: TStringField;
    CadOsc_nom_mod: TStringField;
    CadOsc_nro_ser: TStringField;
    CadOst_hor_pre: TDateTimeField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure CadOsAfterScroll(DataSet: TDataSet);
    procedure BitBtn1Click(Sender: TObject);
    procedure BCadastrarClick(Sender: TObject);
    procedure GOrcamentoCellClick(Column: TColumn);
    procedure GOrcamentoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GOrcamentoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GOrcamentoEnter(Sender: TObject);
    procedure EclienteRetorno(Retorno1, Retorno2: String);
    procedure FlagClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BConsultaClick(Sender: TObject);
    procedure BtAlterarClick(Sender: TObject);
    procedure BtExcluirClick(Sender: TObject);
    procedure BtCancelaClick(Sender: TObject);
    procedure CTotalClick(Sender: TObject);
    procedure BMaisClick(Sender: TObject);
    procedure BGeraNotaClick(Sender: TObject);
    procedure Data1CloseUp(Sender: TObject);
    procedure BtbImprimirClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BSomaNotaClick(Sender: TObject);
    procedure BEstornarClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);

  private
    rel : TCrpe;
    UnOS : TFuncoesOrdemServico;
    TeclaPressionada : boolean;
    procedure localizaCadOs(NroOS : integer);
    procedure AtualizaConsulta;
    procedure AdicionaFiltros(VpaSelect : TStrings);
    procedure LimpaFiltros;
    procedure AtualizaTabelaMarcaPosicao;
    procedure atualizatotal;

  public
    { Public declarations }
    procedure ConsultaOs(NroOs: integer);
    procedure AlteraOs(NroOs: integer);
  end;

var
  FConsultaOS: TFConsultaOS;

implementation

uses APrincipal, funsql, fundata, funstring, constantes, funobjeto, constmsg,
     AMostraProSerTerOS, ANovaOrdemServico, AOrdemServico, ANovaNotaFiscal,
  AGeraNotaOS, APosicionaOS;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFConsultaOS.FormCreate(Sender: TObject);
begin
  UnOS := TFuncoesOrdemServico.Criar(self, FPrincipal.BaseDados);
  Data1.Date := PrimeiroDiaMes(Date);
  Data2.Date := UltimoDiaMes(Date);
  TeclaPressionada := False;
  Flag.ItemIndex := 0;
  Periodo.ItemIndex := 0;
  AtualizaConsulta;

end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFConsultaOS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  rel.free;
  UnOS.free;
  CadOs.close;
  CadClientes.close;
  Action := CaFree;
end;

{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFConsultaOS.BFecharClick(Sender: TObject);
begin
  self.close
end;

{************************* atualiza os totais *********************************}
procedure TFConsultaOS.CTotalClick(Sender: TObject);
begin
  AtualizaTabelaMarcaPosicao;
end;

procedure TFConsultaOS.BMaisClick(Sender: TObject);
begin
  PanelColor3.Visible := not BMais.Down;
end;

{*************************** Ver Nota *****************************************}
procedure TFConsultaOS.BGeraNotaClick(Sender: TObject);
begin
{  AdicionaSQLAbreTabela(Aux,' Select I_Seq_Not from CadNotaFiscais '+
                            ' Where I_Emp_Fil = '+ InttoStr(Varia.CodigoEmpFil) +
                            ' and I_Cod_Ors = '+ CadOsI_Cod_Ors.AsString);
  if Aux.eof then
    aviso(CT_NAOEXISTENOTA);

  While not Aux.Eof do
  begin
    FNovaNotaFiscal := TFNovaNotaFiscal.criarSDI(Application,'',FPrincipal.VerificaPermisao('FNovaNotaFiscal'));
    FNovaNotaFiscal.ConsultaNotafiscal(Aux.FieldByName('I_Seq_Not').AsInteger);
    FNovaNotaFiscal.free;
    Aux.Next;
  end;   }
  tempo.execute('Gerando Nota Fiscal da Ordem de Serviço...');
  FNovaNotaFiscal := TFNovaNotaFiscal.criarSDI(Application,'',FPrincipal.VerificaPermisao('FNovaNotaFiscal'));
  FNovaNotaFiscal.GeraNotaOS(CadOsI_Cod_Ors.AsString,false);
  tempo.fecha;
end;

{***************************** Atualiza Total *********************************}
procedure TFConsultaOs.AtualizaTotal;
begin
  AdicionaSQLAbreTabela(Aux,' Select Sum(N_tot_ors) Valor, Count(I_Cod_Ors) Qtd '+
                            ' from CadOrdemServico Ors ');
  AdicionaFiltros(Aux.Sql);
  Aux.open;
  EValorTotal.Text := FormatFloat(varia.MascaraMoeda,Aux.FieldByName('Valor').AsFloat);
  EQtdTotal.Text := Aux.FieldByName('Qtd').Asstring;
end;

{***************************** Localiza Os  *********************************}
procedure TFConsultaOs.LocalizaCadOs(NroOS : integer);
begin
   CadOs.close;
   CadOs.sql.clear;
   CadOs.SQl.add(' Select * from CadOrdemServico as Ors, CadClientes as Cli, '+
                 ' CadUsuarios as Usu, CadSituacoes as Sit'+
                 ' Where ' +
                 ' ors.i_emp_fil = ' + IntTostr(varia. CodigoEmpFil) +
                 ' and Ors.i_cod_ors = ' + IntTostr(NroOs) +
                 ' and Cli.I_cod_cli = Ors.I_Cod_cli '+
                 ' and Usu.I_Cod_Usu = Ors.I_cod_Usu '+
                 ' and Sit.I_cod_sit = Ors.I_Cod_sit ');
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                           eventos dos filtros superiores
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}


{**************************** Atualiza Consulta *******************************}
procedure TFConsultaOs.AtualizaConsulta;
begin
   CadOs.close;
   CadOs.sql.clear;
   CadOs.SQl.add(' Select ors.i_emp_fil, Ors.I_Cod_Ors, Ors.D_Dat_Cad, Cli.I_Cod_cli,'+
                 ' Cli.C_Nom_Cli,Ors.D_Dat_Fec, Ors.C_Sit_Ors, Ors.I_cod_sit,'+
                 ' Usu.I_Cod_Usu, Usu.C_Nom_Usu, ors.C_NON_AVI, Ors.D_DAT_AVI,' +
                 ' ORs.d_dat_pre, ors.t_hor_pre,Ors.I_NRO_ATE, ' +
                 ' Sit.C_Nom_sit,equ.c_nom_equ, mar.c_nom_mar, mod.c_nom_mod, ' +
                 ' Ors.N_Tot_pro, Ors.N_tot_Ser, Ors.N_Tot_Ors, ors.c_nro_ser ' +
                 ' from dba.CadOrdemServico as Ors, dba.CadClientes as Cli, '+
                 ' dba.CadUsuarios as Usu, CadSituacoes as Sit, ' +
                 ' cadequipamentos equ, cadmarcas mar, cadmodelo mod ');
   AdicionaFiltros(CadOs.Sql);
   CadOs.sql.Add(' and Cli.I_Cod_Cli = Ors.I_Cod_Cli ' +
                 ' and Usu.I_Cod_Usu =* Ors.I_Cod_Usu ' +
                 ' and Sit.I_cod_sit =* Ors.I_cod_sit ' +
                 ' and Ors.i_cod_equ *= equ.i_cod_equ ' +
                 ' and Ors.i_cod_mar *= mar.i_cod_mar ' +
                 ' and Ors.i_cod_mod *= mod.i_cod_mod ' );
   CadOs.sql.add(' order by Ors.I_Cod_Ors');
   CadOs.open;
  GOrcamento.ALinhaSQLOrderBy := CadOs.SQL.Count - 1;
   if CTotal.Checked then
     AtualizaTotal
   else
   begin
     EValorTotal.text := '0';
     EQtdTotal.text := '0';
   end;
end;


{****************** adiciona os filtros da cotacao ****************************}
procedure TFConsultaOS.AdicionaFiltros(VpaSelect : TStrings);
begin
  VpaSelect.add(' Where Ors.I_Emp_Fil = ' + IntToStr(Varia.CodigoEmpFil));

  case Periodo.ItemIndex of
    0 : VpaSelect.add(SQLTextoDataEntreAAAAMMDD('ors.D_DAT_CAD', Data1.Date,Data2.Date, true  ));
    1 : VpaSelect.add(SQLTextoDataEntreAAAAMMDD('ors.D_DAT_FEC', Data1.Date,Data2.Date, true  ));
    2 : VpaSelect.add(SQLTextoDataEntreAAAAMMDD('ors.D_DAT_PRE', Data1.Date,Data2.Date, true  ));
    3 : VpaSelect.add('  ');
  end;

  if ECliente.Text <> '' Then
     VpaSelect.Add(' and Ors.I_Cod_Cli = '+ ECliente.text);

  if EVendedor.text <> '' then
     VpaSelect.add(' and Ors.I_Cod_Usu = ' + EVendedor.Text);

  if EOS.text <> '' then
     VpaSelect.add(' and Ors.I_Cod_Ors = ' + EOS.Text);

  if ESituacao.text <> '' then
     VpaSelect.add(' and Ors.I_Cod_Sit = ' + Esituacao.Text);

  if NroAtendimento.AValor <> 0 then
     VpaSelect.add(' and Ors.I_NRO_ATE = ' + Inttostr(Trunc(NroAtendimento.avalor)));

  case Flag.ItemIndex of
    0 : VpaSelect.add(' and ors.C_Sit_Ors = ''A''');
    1 : VpaSelect.add(' and ors.C_Sit_Ors = ''C''');
    2 : VpaSelect.add(' and ors.C_Sit_Ors = ''F''');
    3 : VpaSelect.Add(' ');
  end;

end;



{*************** marca a posicao e atualiza a tabela de consulta ************* }
procedure TFConsultaOS.AtualizaTabelaMarcaPosicao;
var
  VpfPosicao : TBookmark;
begin
  VpfPosicao := CadOs.GetBookmark;
  AtualizaConsulta;
  try
    if not CadOs.eof then
      CadOs.GotoBookmark(VpfPosicao);
  except
    CadOs.First;
  end;
  CadOs.FreeBookmark(VpfPosicao);
end;


{******************* limpa os filtros da consulta *****************************}
procedure TFConsultaOs.LimpaFiltros;
begin
  LimpaEdits(PanelColor3);
  AtualizaLocalizas([Ecliente,EVendedor]);
  Flag.ItemIndex := 0;
  Data1.Date := PrimeiroDiaMes(Date);
  Data2.Date := UltimoDiaMes(Date);
  AtualizaConsulta;
end;

{************************* Apos Scroll ****************************************}
procedure TFConsultaOS.CadOsAfterScroll(DataSet: TDataSet);
begin
  BtAlterar.Enabled := CadOsC_Sit_Ors.AsString = 'A';
  BtExcluir.Enabled := CadOsC_Sit_Ors.AsString = 'A';
  BtCancela.Enabled := CadOsC_Sit_Ors.AsString = 'A';
  BGeraNota.Enabled := CadOsC_Sit_Ors.AsString = 'F';
  BEstornar.Enabled := CadOsC_Sit_Ors.AsString = 'F';
end;


{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
                           Botoes Inferiores
{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{}

{*************************** Mostra produtos, Servicos e Terceiros ************}
procedure TFConsultaOS.BitBtn1Click(Sender: TObject);
begin
  FAMostraProSerTerOS := TFAMostraProSerTerOS.CriarSDI(application, '', true);
  FAMostraProSerTerOS.CarregaMovOS(CadOS.fieldByname('i_cod_ors').AsInteger);
end;

{**************************** Botao Cadastrar *********************************}
procedure TFConsultaOS.BCadastrarClick(Sender: TObject);
begin
   FOrdemServico := TFOrdemServico.CriarSDI(self,'',true);
   FOrdemServico.NovaOS;
   AtualizaConsulta;
   AtualizaTabelaMarcaPosicao;
end;

{*********************** Botao Alterar ****************************************}
procedure TFConsultaOS.BtAlterarClick(Sender: TObject);
begin
  if CadOsI_Cod_Ors.AsInteger <> 0 then
  begin
    FOrdemServico := TFOrdemServico.criarSDI(self,'',true);
    AlteraOs(CadOsI_cod_Ors.Asinteger);
    AtualizaConsulta;
    AtualizaTabelaMarcaPosicao;
  end;
end;

{************************ Botao Cancelar **************************************}
procedure TFConsultaOS.BtCancelaClick(Sender: TObject);
begin
  if SenhaDeLiberacao then
  begin
   if Confirmacao('Deseja realmente cancelar esta ordem de serviço ?') then
   begin
     if not CadOs.IsEmpty then
      if not(CadOsI_Cod_Ors.IsNull) or (CadOsC_Sit_Ors.AsString <> 'F') then
      begin
        unos.CancelaOS(CadOsI_Cod_Ors.AsString);
        AtualizaConsulta;
        AtualizaTabelaMarcaPosicao;
      end;
    end;
  end;
end;

{************************** Botao Consultar ***********************************}
procedure TFConsultaOS.BConsultaClick(Sender: TObject);
begin
  if CadOsI_Cod_Ors.AsInteger <> 0 then
  begin
    FPosicionaOS := TFPosicionaOS.criarSDI(self,'',true);
    FPosicionaOS.ConsultaOS(CadOsI_Cod_Ors.AsInteger);
  end;
end;

{**************************** Botao Excluir ***********************************}
procedure TFConsultaOS.BtExcluirClick(Sender: TObject);
begin
  if SenhaDeLiberacao then
  begin
   if not CadOs.IsEmpty then
     if Confirmacao('Deseja realmente excluir esta ordem de servico ') then
     begin
       UnOs.ExcluiOS(CadOsI_Cod_Ors.AsInteger);
       AtualizaConsulta;
       AtualizaTabelaMarcaPosicao;
     end;
   end;
end;


{************************ altera uma OS **********************************}
procedure TFConsultaOs.AlteraOs(NroOS : Integer);
begin
  FOrdemServico.AlteraOs(CadOsI_Cod_Ors.AsInteger);
  AtualizaConsulta;
  AtualizaTabelaMarcaPosicao;
end;


{************************* consulta a OS *********************************}
procedure TFConsultaOs.ConsultaOs(NroOs: integer);
begin
  FOrdemServico.ConsultaOs(CadOsI_Cod_Ors.AsInteger);
  AtualizaConsulta;
  AtualizaTabelaMarcaPosicao;
end;


{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
                           Botoes Superiores
{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{}

{************************* Seleciona tipos de OS ******************************}
procedure TFConsultaOS.FlagClick(Sender: TObject);
begin
  AtualizaConsulta;
end;

{************************* Seleciona por cliente*******************************}
procedure TFConsultaOS.EclienteRetorno(Retorno1, Retorno2: String);
begin
 AtualizaConsulta;
end;



{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                  Ações do Grid CadOs e seus Filtros
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}


{*************** quando um click no grid ************************************ }
procedure TFConsultaOS.GOrcamentoCellClick(Column: TColumn);
begin
 TeclaPressionada := false;
end;

{****************Quando soltado a tecla posicona o movorcamento****************}
procedure TFConsultaOS.GOrcamentoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  TeclaPressionada := False;
   if key in[37..40]  then
      CadOsI_Cod_Ors.AsString;
end;

{*******************Não deixa fazer mais os filtros****************************}
procedure TFConsultaOS.GOrcamentoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 46 then
    BtExcluirClick(BtExcluir);
  TeclaPressionada := true;
end;

{******************* no enter do grid *************************************** }
procedure TFConsultaOS.GOrcamentoEnter(Sender: TObject);
begin
  TeclaPressionada := false;
end;

{******************* Mover seta para baixo *************************************** }
procedure TFConsultaOS.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
case key  of
    Vk_f5 : LimpaFiltros;
    vk_Up :
      if PossuiFoco(PanelColor3) Then
      begin
        GOrcamento.setfocus;
        Atualizaconsulta;
      end;
    vk_Down :
      if PossuiFoco(PanelColor3) Then
      begin
        GOrcamento.setfocus;
        Atualizaconsulta;
      end;
  end;
end;


procedure TFConsultaOS.Data1CloseUp(Sender: TObject);
begin
 AtualizaConsulta;
end;

procedure TFConsultaOS.BtbImprimirClick(Sender: TObject);
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

procedure TFConsultaOS.BitBtn2Click(Sender: TObject);
begin
  if CadOsC_Sit_Ors.AsString = 'F' then
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
     aviso('Você deve gravar o ordem de serviço antes');
end;

procedure TFConsultaOS.BSomaNotaClick(Sender: TObject);
begin
  FGeraNotaOS := TFGeraNotaOS.CriarSDI(application, '',FPrincipal.VerificaPermisao('FGeraNotaOS'));
  FGeraNotaOS.ShowModal;
end;

procedure TFConsultaOS.BEstornarClick(Sender: TObject);
begin
    if SenhaDeLiberacao then
  begin
   if Confirmacao('Deseja realmente estornar o fechamento desta ordem de serviço ?') then
   begin
     if not CadOs.IsEmpty then
      if not(CadOsI_Cod_Ors.IsNull) or (CadOsC_Sit_Ors.AsString = 'F') then
      begin
        UnOS.EstornaFechaOS(CadOsI_Cod_Ors.AsString);
        AtualizaConsulta;
        AtualizaTabelaMarcaPosicao;
      end;
    end;
  end;
end;

procedure TFConsultaOS.BitBtn3Click(Sender: TObject);
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

Initialization
 RegisterClasses([TFConsultaOS]);
end.
