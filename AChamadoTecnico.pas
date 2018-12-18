unit AChamadoTecnico;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Componentes1, ComCtrls, Localizacao, Buttons, PainelGradiente,
  Grids, DBGrids, Tabela, DBKeyViolation, ExtCtrls, Mask, numericos, Db,
  DBTables, UnOrdemServico;

type
  TFChamadoTecnico = class(TFormularioPermissao)
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
    BCadastrar: TBitBtn;
    BtAlterar: TBitBtn;
    BConsulta: TBitBtn;
    BtExcluir: TBitBtn;
    BFechar: TBitBtn;
    BtCancela: TBitBtn;
    BBAjuda: TBitBtn;
    GOrcamento: TGridIndice;
    GridMov: TDBGridColor;
    Label6: TLabel;
    Label11: TLabel;
    EVendedor: TEditLocaliza;
    SpeedButton4: TSpeedButton;
    Label12: TLabel;
    MovOrdemServico: TQuery;
    DataMovServicos: TDataSource;
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
    Aux: TQuery;
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
    TipoChamado: TComboBoxColor;
    Label2: TLabel;
    Label8: TLabel;
    Flag: TComboBoxColor;
    BEstornar: TBitBtn;
    TipoPeriodo: TComboBoxColor;
    Label4: TLabel;
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
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BConsultaClick(Sender: TObject);
    procedure BtAlterarClick(Sender: TObject);
    procedure BtExcluirClick(Sender: TObject);
    procedure BtCancelaClick(Sender: TObject);
    procedure CTotalClick(Sender: TObject);
    procedure Data1CloseUp(Sender: TObject);
    procedure BEstornarClick(Sender: TObject);
  private
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
  FChamadoTecnico: TFChamadoTecnico;

implementation

uses APrincipal, funsql, fundata, funstring, constantes, funobjeto, constmsg,
     AMostraProSerTerOS, ANovaOrdemServico, AOrdemServico, ANovaNotaFiscal;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFChamadoTecnico.FormCreate(Sender: TObject);
begin
  UnOS := TFuncoesOrdemServico.Criar(self, FPrincipal.BaseDados);
  Data1.Date := PrimeiroDiaMes(Date);
  Data2.Date := UltimoDiaMes(Date);
  TipoChamado.ItemIndex := 0;
  Flag.ItemIndex := 0;
  TipoPeriodo.ItemIndex := 0;
  TeclaPressionada := False;
  AtualizaConsulta;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFChamadoTecnico.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UnOS.free;
  CadOs.close;
  CadClientes.close;
  Action := CaFree;
end;

{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFChamadoTecnico.BFecharClick(Sender: TObject);
begin
  self.close
end;

{************************* atualiza os totais *********************************}
procedure TFChamadoTecnico.CTotalClick(Sender: TObject);
begin
  AtualizaTabelaMarcaPosicao;
end;

{***************************** Atualiza Total *********************************}
procedure TFChamadoTecnico.AtualizaTotal;
begin
  AdicionaSQLAbreTabela(Aux,' Select Sum(N_Vlr_Tot) Valor, Count(I_Cod_Ors) Qtd '+
                            ' from CadOrdemServico Ors ');
  AdicionaFiltros(Aux.Sql);
  Aux.open;
end;

{***************************** Localiza Os  *********************************}
procedure TFChamadoTecnico.LocalizaCadOs(NroOS : integer);
begin
   CadOs.close;
   CadOs.sql.clear;
   CadOs.SQl.add('Select * from CadOrdemServico as Ors, CadClientes as Cli, '+
                 ' CadUsuarios as Usu, CadSituacoes as Sit'+
                 ' Where ' +
                 ' i_emp_fil = ' + IntTostr(varia. CodigoEmpFil) +
                 ' and Ors.i_cod_ors = ' + IntTostr(NroOs) +
                 ' and Cli.I_cod_cli = Ors.I_Cod_cli '+
                 ' and Usu.I_Cod_Usu = Ors.I_cod_Usu '+
                 ' and Sit.I_cod_sit = ors.i_cod_sit ');
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                           eventos dos filtros superiores
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{**************************** Atualiza Consulta *******************************}
procedure TFChamadoTecnico.AtualizaConsulta;
begin
   CadOs.close;
   CadOs.sql.clear;
   CadOs.SQl.add(' Select Ors.I_Cod_Ors, Ors.D_Dat_Cad, Cli.I_Cod_cli,Cli.C_Nom_Cli,'+
                 ' Ors.D_Dat_AGe, Ors.C_Sit_Ors, Ors.I_cod_sit,'+
                 ' Usu.I_Cod_Usu, Usu.C_Nom_Usu, ' +
                 ' Sit.I_Cod_Sit, Sit.C_Nom_sit, ' +
                 ' equ.c_nom_equ, mar.c_nom_mar, mod.c_nom_mod, ' +
                 ' Ors.H_Hor_Age, Ors.C_CHA_TEC, Ors.C_TIP_CHA ' +
                 ' from dba.CadOrdemServico as Ors, dba.CadClientes as Cli, '+
                 ' dba.CadUsuarios as Usu, dba.CadSituacoes as Sit, '+
                 ' cadequipamentos equ, cadmarcas mar, cadmodelo mod ' );
   AdicionaFiltros(CadOs.Sql);
   CadOs.sql.Add(' and Cli.I_Cod_Cli = Ors.I_Cod_Cli ' +
                 ' and Usu.I_Cod_Usu = Ors.I_Cod_Usu ' +
                 ' and Sit.I_cod_sit = ors.i_cod_sit '+
                 ' and Ors.i_cod_equ *= equ.i_cod_equ ' +
                 ' and Ors.i_cod_mar *= mar.i_cod_mar ' +
                 ' and Ors.i_cod_mod *= mod.i_cod_mod ' );
   CadOs.sql.add(' order by Ors.D_DAT_AGE, H_HOR_AGE');
   CadOs.open;
   GOrcamento.ALinhaSQLOrderBy := CadOs.SQL.Count - 1;
end;


{****************** adiciona os filtros da cotacao ****************************}
procedure TFChamadoTecnico.AdicionaFiltros(VpaSelect : TStrings);
var
  CampoData : String;
begin
  VpaSelect.add(' Where Ors.I_Emp_Fil = ' + IntToStr(Varia.CodigoEmpFil));

  case TipoPeriodo.ItemIndex of
   0 : CampoData := 'ors.D_DAT_Age';
   1 : CampoData := 'ors.D_DAT_CAD';
  end;

  VpaSelect.add(SQLTextoDataEntreAAAAMMDD(CampoData,Data1.DateTime, data2.DateTime, true) +
                ' and ors.c_cha_tec = ''Chamado'''  );

  if ECliente.Text <> '' Then
     VpaSelect.Add(' and Ors.I_Cod_Cli = '+ ECliente.text)
  else
     VpaSelect.Add(' ');

  if EVendedor.text <> '' then
     VpaSelect.add(' and Ors.I_Cod_Usu = ' + EVendedor.Text)
  else
     VpaSelect.Add(' ');

  if EOS.text <> '' then
     VpaSelect.add(' and Ors.I_Cod_Ors = ' + EOS.Text)
  else
     VpaSelect.Add(' ');

  case TipoChamado.itemindex of
   0 : VpaSelect.Add(' and ors.c_tip_cha = ''A'''); //aberto
   1 : VpaSelect.Add(' and ors.c_tip_cha = ''F'''); //fechado
   2 : VpaSelect.Add(' ');
   end;

  case Flag.ItemIndex of
    0 : VpaSelect.add(' and ors.C_Sit_Ors = ''A''');
    1 : VpaSelect.add(' and ors.C_Sit_Ors = ''C''');
    2 : VpaSelect.add(' and ors.C_Sit_Ors = ''F''');
    3 : VpaSelect.Add(' ');
  end;

  VpaSelect.add(' and ors.C_Sit_Ors = ''A''');


end;

{*************** marca a posicao e atualiza a tabela de consulta ************* }
procedure TFChamadoTecnico.AtualizaTabelaMarcaPosicao;
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
procedure TFChamadoTecnico.LimpaFiltros;
begin
  LimpaEdits(PanelColor3);
  AtualizaLocalizas([Ecliente,EVendedor]);
  {Flag.ItemIndex := 0;}
  Data1.Date := PrimeiroDiaMes(Date);
  Data2.Date := UltimoDiaMes(Date);
  {ChDatOrs.Checked := true;}
  AtualizaConsulta;
end;


{************************* Apos Scroll ****************************************}
procedure TFChamadoTecnico.CadOsAfterScroll(DataSet: TDataSet);
begin
  BtAlterar.Enabled := CadOs.fieldByName('C_Sit_Ors').asstring = 'A';
  BtExcluir.Enabled := CadOs.fieldByName('C_Sit_Ors').AsString = 'A';
  BtCancela.Enabled := CadOs.fieldByName('C_TIP_CHA').AsString = 'A';
  BEstornar.Enabled := CadOs.fieldByName('C_TIP_CHA').AsString = 'F';

end;

{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
                           Botoes Inferiores
{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{}

{*************************** Mostra produtos, Servicos e Terceiros ************}
procedure TFChamadoTecnico.BitBtn1Click(Sender: TObject);
begin
  FAMostraProSerTerOS := TFAMostraProSerTerOS.CriarSDI(application, '', true);
  FAMostraProSerTerOS.CarregaMovOS(CadOS.fieldByname('i_cod_ors').AsInteger);
end;

{**************************** Botao Cadastrar *********************************}
procedure TFChamadoTecnico.BCadastrarClick(Sender: TObject);
begin
   FOrdemServico := TFOrdemServico.CriarSDI(self,'',true);
   FOrdemServico.NovaOS;
   AtualizaConsulta;
   AtualizaTabelaMarcaPosicao;
end;

{*********************** Botao Alterar ****************************************}
procedure TFChamadoTecnico.BtAlterarClick(Sender: TObject);
begin
  if CadOs.fieldByname('i_cod_ors').AsInteger <> 0 then
  begin
    FOrdemServico := TFOrdemServico.criarSDI(self,'',true);
    AlteraOs(CadOS.fieldByname('i_cod_ors').Asinteger);
    AtualizaConsulta;
    AtualizaTabelaMarcaPosicao;
  end;
end;

{************************ Botao Cancelar **************************************}
procedure TFChamadoTecnico.BtCancelaClick(Sender: TObject);
begin
  if not CadOs.IsEmpty then
    if not(CadOS.fieldByname('i_cod_ors').IsNull) or (CadOs.fieldbyname('C_Sit_Ors').AsString <> 'F') then
    begin
      UnOS.FechaChamado(CadOS.fieldByname('i_cod_ors').AsString);
      AtualizaConsulta;
      AtualizaTabelaMarcaPosicao;
    end;
end;

{************************** Botao Consultar ***********************************}
procedure TFChamadoTecnico.BConsultaClick(Sender: TObject);
begin
  if CadOS.fieldByname('i_cod_ors').AsInteger <> 0 then
  begin
    FOrdemServico := TFOrdemServico.criarSDI(self,'',true);
    ConsultaOs(CadOS.fieldByname('i_cod_ors').AsInteger);
    AtualizaConsulta;
    AtualizaTabelaMarcaPosicao;
  end;
end;

{**************************** Botao Excluir ***********************************}
procedure TFChamadoTecnico.BtExcluirClick(Sender: TObject);
begin
   UnOs.ExcluiOS(CadOS.fieldByname('i_cod_ors').AsInteger);
   AtualizaConsulta;
   AtualizaTabelaMarcaPosicao;
end;


{************************ altera uma OS **********************************}
procedure TFChamadoTecnico.AlteraOs(NroOS : Integer);
begin
  FOrdemServico.AlteraOs(CadOS.fieldByname('i_cod_ors').AsInteger);
  AtualizaConsulta;
  AtualizaTabelaMarcaPosicao;
end;


{************************* consulta a OS *********************************}
procedure TFChamadoTecnico.ConsultaOs(NroOs: integer);
begin
  FOrdemServico.ConsultaOs(CadOS.fieldByname('i_cod_ors').AsInteger);
  AtualizaConsulta;
  AtualizaTabelaMarcaPosicao;
end;


{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
                           Botoes Superiores
{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{}

{************************* Seleciona por cliente*******************************}
procedure TFChamadoTecnico.EclienteRetorno(Retorno1, Retorno2: String);
begin
 AtualizaConsulta;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                  Ações do Grid CadOs e seus Filtros
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}


{*************** quando um click no grid ************************************ }
procedure TFChamadoTecnico.GOrcamentoCellClick(Column: TColumn);
begin
 TeclaPressionada := false;
end;

{****************Quando soltado a tecla posicona o movorcamento****************}
procedure TFChamadoTecnico.GOrcamentoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  TeclaPressionada := False;
   if key in[37..40]  then
      CadOS.fieldByname('i_cod_ors').AsString;
end;

{*******************Não deixa fazer mais os filtros****************************}
procedure TFChamadoTecnico.GOrcamentoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 46 then
    BtExcluirClick(BtExcluir);
  TeclaPressionada := true;
end;

{******************* no enter do grid *************************************** }
procedure TFChamadoTecnico.GOrcamentoEnter(Sender: TObject);
begin
  TeclaPressionada := false;
end;

{******************* Mover seta para baixo *************************************** }
procedure TFChamadoTecnico.FormKeyDown(Sender: TObject; var Key: Word;
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


procedure TFChamadoTecnico.Data1CloseUp(Sender: TObject);
begin
   Atualizaconsulta;
end;

procedure TFChamadoTecnico.BEstornarClick(Sender: TObject);
begin
  if not CadOs.IsEmpty then
    if not(CadOS.fieldByname('i_cod_ors').IsNull) or (CadOs.fieldbyname('C_Sit_Ors').AsString <> 'F') then
    begin
      UnOS.EstornaChamado(CadOS.fieldByname('i_cod_ors').AsString);
      AtualizaConsulta;
      AtualizaTabelaMarcaPosicao;
    end;
end;

Initialization
 RegisterClasses([TFChamadoTecnico]);
end.
