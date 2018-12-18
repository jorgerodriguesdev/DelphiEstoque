unit AConsultaOP;
 //Autor: Jorge Eduardo Rodrigues}}}
  //Data de criação : 03 de abril de 2001}}}
 // Função: Consultar Ordem de Produção}}}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  ExtCtrls, PainelGradiente, StdCtrls, Buttons, Componentes1, ComCtrls,
  Grids, DBGrids, Tabela, DBKeyViolation, Localizacao, Db, DBTables, Mask,
  DBCtrls, BotaoCadastro, UCrpe32, unordemproducao;

type
  TFConsultaOP = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor3: TPanelColor;
    GAtualiza: TGridIndice;
    Data1: TCalendario;
    Data2: TCalendario;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Flag: TComboBoxColor;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ESituacao: TEditLocaliza;
    SpeedButton3: TSpeedButton;
    Localiza: TConsultaPadrao;
    DataConsultaOP: TDataSource;
    Label12: TLabel;
    DBEdit6: TDBEdit;
    Label7: TLabel;
    CadOP: TQuery;
    Label8: TLabel;
    Tipo: TComboBoxColor;
    PanelColor2: TPanelColor;
    BBFechar: TBitBtn;
    BBAjuda: TBitBtn;
    BtCadastrar: TBitBtn;
    BtAlterar: TBitBtn;
    BtExcluir: TBitbtn;
    BtCancelar: TBitBtn;
    CadOPN_qtd_pro: TFloatField;
    CadOPD_dat_emi: TDateField;
    CadOPD_dat_ent: TDateField;
    CadOPD_Dat_pro: TDateField;
    CadOPI_nro_ped: TIntegerField;
    CadOPI_nro_orp: TIntegerField;
    CadOPC_cod_pro: TStringField;
    CadOPC_nom_pro: TStringField;
    CadOPC_nom_sit: TStringField;
    EnumOperacao: TEditColor;
    EnunPedido: TEditColor;
    BtConsultar: TBotaoConsultar;
    BitBtn2: TBitBtn;
    Rel: TCrpe;
    CadOPi_emp_fil: TIntegerField;
    BitBtn1: TBitBtn;
    CadOPc_nom_maq: TStringField;
    CadOPn_qtd_ter: TFloatField;
    BitBtn3: TBitBtn;
    CadOPi_seq_pro: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BBFecharClick(Sender: TObject);
    procedure Data2CloseUp(Sender: TObject);
    procedure ESituacaoRetorno(Retorno1, Retorno2: String);
    procedure GAtualizaCellClick(Column: TColumn);
    procedure GAtualizaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GAtualizaEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BtExcluirClick(Sender: TObject);
    procedure BtCancelarClick(Sender: TObject);
    procedure BtCadastrarClick(Sender: TObject);
    procedure BtAlterarClick(Sender: TObject);
    procedure BtConsultarClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    TeclaPressionada : boolean;
    unop : TFuncoesOrdemProducao;
    procedure LimpaFiltros;
    procedure AtualizaConsulta;
    procedure AdicionaFiltros(VpaSelect : TStrings);
    procedure localizaCadOP(NroOP : integer);
  public
   { Public declarations }
  end;

var
  FConsultaOP: TFConsultaOP;

implementation

uses APrincipal,funsql, fundata, funstring, constantes, funobjeto, constmsg,
     ANovoProduto,ANovaClassificacao, AOrdemProducao,ASituacoesClientes,
  AFechaOrdemProducao;


{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFConsultaOP.FormCreate(Sender: TObject);
begin
  unop := TFuncoesOrdemProducao.Criar(self,fprincipal.BaseDados);
  cadop.Open;
  Data1.Date := PrimeiroDiaMes(Date);
  Data2.Date := UltimoDiaMes(Date);
  TeclaPressionada := False;
  Flag.ItemIndex := 0;
  tipo.ItemIndex := 0;
  AtualizaConsulta;

end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFConsultaOP.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   unop.free;
   CadOP.close;
   Action := CaFree;
end;

{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFConsultaOP.BBFecharClick(Sender: TObject);
begin
   Self.close;
end;

//***************************** Localiza OP  *********************************}
procedure TFConsultaOP.LocalizaCadOP(NroOP: integer);
begin
   CadOP.close;
   CadOP.sql.clear;
   CadOP.SQl.add(' Select * from CadOrdemProducao as OP '+
                 ' CadSituacoes as Sit'+
                 ' Where ' +
                 ' OP.i_emp_fil = ' + IntTostr(varia. CodigoEmpFil) +
                 ' and OP.i_nro_Orp = ' + IntTostr(NroOP) +
                 ' and Sit.I_cod_sit = OP.I_Cod_sit ');
end;

{**************************** Atualiza Consulta *******************************}
procedure TFConsultaOP.AtualizaConsulta;
begin
   CadOP.close;
   CadOP.sql.clear;
   CadOP.SQl.add('Select maq.c_nom_maq,op.i_emp_fil,OP.N_qtd_pro, OP.D_dat_emi, OP.D_dat_ent,  OP.D_Dat_pro,'+
                 'OP.I_nro_ped,op.I_nro_orp,'+
                 ' OP.C_cod_pro, PRO.C_nom_pro, Sit.C_nom_sit, op.n_qtd_ter , op.i_seq_pro' +
                 ' from CadOrdemProducao as OP,'+
                 ' CadProdutos as Pro,'+
                 ' CadSituacoes as Sit,' +
                 ' CadMaquinas as Maq ');
   AdicionaFiltros(CadOP.Sql);
   CadOP.sql.Add(' and OP.I_Seq_pro = Pro.I_Seq_pro' +
                 ' and Sit.I_cod_sit = OP.I_cod_sit  ' +
                 ' and Op.i_cod_maq *= maq.i_cod_maq ');
   CadOP.sql.add(' order by Pro.C_Cod_pro');
   CadOP.open;
   GAtualiza.ALinhaSQLOrderBy := CadOP.SQL.Count - 1;

end;
{****************** adiciona os filtros da cotacao ****************************}
procedure TFConsultaOP.AdicionaFiltros(VpaSelect : TStrings);
begin
 VpaSelect.add(' Where OP.I_Emp_Fil = ' + IntToStr(Varia.CodigoEmpFil));
   begin
        case Flag.ItemIndex of
          0 : VpaSelect.add(SQLTextoDataEntreAAAAMMDD('OP.D_DAT_EMI', Data1.Date,Data2.Date, true  ));
          1 : VpaSelect.add(SQLTextoDataEntreAAAAMMDD('OP.D_DAT_PRO', Data1.Date,Data2.Date, true  ));
          2 : VpaSelect.add(SQLTextoDataEntreAAAAMMDD('OP.D_DAT_ENT', Data1.Date,Data2.Date, true  ));
        end;

        if EnumOperacao.Text <> '' Then
           VpaSelect.Add(' and OP.I_Nro_Orp = '+ ENumOperacao.text);

        if ENunPedido.text <> '' then
           VpaSelect.add(' and OP.I_Nro_Ped = ' + ENunpedido.Text);

        case tipo.ItemIndex of
            0 : VpaSelect.add(' and  op.c_tip_orp = ''A''');
            1 : VpaSelect.add(' and  op.c_tip_orp = ''F''');
            2 : VpaSelect.add(' and  op.c_tip_orp = ''C''');
            3 : VpaSelect.add(' ');
        end;
   end;
end;
procedure TFConsultaOP.Data2CloseUp(Sender: TObject);
begin
  AtualizaConsulta;
end;

procedure TFConsultaOP.ESituacaoRetorno(Retorno1, Retorno2: String);
begin
  AtualizaConsulta;
end;

procedure TFConsultaOP.GAtualizaCellClick(Column: TColumn);
begin
  TeclaPressionada := false;
end;

procedure TFConsultaOP.GAtualizaKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  TeclaPressionada := False;
   if key in[37..40]  then
      CadOPI_Nro_Ped.AsString;
end;

procedure TFConsultaOP.GAtualizaEnter(Sender: TObject);
begin
  TeclaPressionada := False;
end;

procedure TFConsultaOP.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
case key  of
    Vk_f5 : LimpaFiltros;
    vk_Up :
      if PossuiFoco(PanelColor3) Then
      begin
        GAtualiza.setfocus;
        Atualizaconsulta;
      end;
    vk_Down :
      if PossuiFoco(PanelColor3) Then
      begin
        GAtualiza.setfocus;
        Atualizaconsulta;
      end;
  end;
end;

procedure TFConsultaOp.LimpaFiltros;
begin
  LimpaEdits(PanelColor3);
  AtualizaLocalizas([EnumOperacao,EnunPedido]);
  Flag.ItemIndex := 0;
  Data1.Date := PrimeiroDiaMes(Date);
  Data2.Date := UltimoDiaMes(Date);
  AtualizaConsulta;
end;

procedure TFConsultaOP.BitBtn2Click(Sender: TObject);
begin
 rel.ReportName := varia.PathRel + 'diverso\OrdemProducao.rpt';
 rel.Connect.Retrieve;
 rel.Connect.DatabaseName := varia.AliasBAseDados;
 rel.Connect.ServerName := varia.AliasRelatorio;
 rel.WindowState := wsMaximized;
 rel.ParamFields.Retrieve;
 rel.ParamFields[0].Value := CadOPI_NRO_ORP.AsString;
 rel.ParamFields[1].Value := CadOPI_EMP_FIL.AsString;
 rel.ParamFields[2].Value := CadOPC_nom_pro.AsString;
 rel.ReportTitle  := UpperCase(CadOPC_nom_pro.AsString);
 rel.execute;
end;

procedure TFConsultaOP.BitBtn1Click(Sender: TObject);
begin
  FFechaOrdemProducao := TFFechaOrdemProducao.CriarSDI(application,'',FPrincipal.VerificaPermisao('FFechaOrdemProducao'));
  FFechaOrdemProducao.Carregaalteracao(CadOPI_nro_orp.AsInteger, CadOPi_seq_pro.AsInteger, CadOPN_qtd_pro.AsFloat - CadOPn_qtd_ter.AsFloat);
  FFechaOrdemProducao.ShowModal;
  AtualizaConsulta;
end;

procedure TFConsultaOP.BtExcluirClick(Sender: TObject);
begin
  if not cadop.Eof then
    if Confirmacao('Deseja realmente excluir esta ordem de produção ? ') then
    begin
      unop.ExcluiMovOP(CadOPI_nro_orp.AsInteger);
      unop.ExcluiCadOP(CadOPI_nro_orp.AsInteger);
      AtualizaConsulta;
    end;
end;

procedure TFConsultaOP.BtCancelarClick(Sender: TObject);
begin
  if not cadop.Eof then
    if Confirmacao('Deseja realmente cancelar esta ordem de produção ? ') then
    begin
     unop.CancelaOP(CadOPI_nro_orp.AsInteger);
     AtualizaConsulta;
    end;
end;

procedure TFConsultaOP.BtCadastrarClick(Sender: TObject);
begin
  FOrdemProducao := TFOrdemProducao.CriarSDI(application, '', FPrincipal.VerificaPermisao('FOrdemProducao'));
  FOrdemProducao.AbreNovaOrdemProducao;
end;

procedure TFConsultaOP.BtAlterarClick(Sender: TObject);
begin
  FOrdemProducao := TFOrdemProducao.CriarSDI(application,'',FPrincipal.VerificaPermisao('FOrdemProducao'));
  FOrdemProducao.AlteraOP(CadOPI_nro_orp.AsInteger,true);
  FOrdemProducao.ShowModal;
  AtualizaConsulta;
end;

procedure TFConsultaOP.BtConsultarClick(Sender: TObject);
begin
  FOrdemProducao := TFOrdemProducao.CriarSDI(application,'',FPrincipal.VerificaPermisao('FOrdemProducao'));
  FOrdemProducao.AlteraOP(CadOPI_nro_orp.AsInteger,false);
  FOrdemProducao.ShowModal;
end;

procedure TFConsultaOP.BitBtn3Click(Sender: TObject);
var
  valor : string;
begin
  if EntradaNumero( 'Quantidade','Digite quantidade a ser baixada',valor,false,FPrincipal.CorFoco.ACorFundoFoco,
                     FPrincipal.CorForm.ACorPainel, true, varia.Decimais) then
  begin
    unop.AdicionaEstoqueComposicao(CadOPI_nro_orp.AsInteger,CadOPi_seq_pro.AsInteger, strtofloat(valor));
    AtualizaConsulta;
  end;
end;

Initialization
 RegisterClasses([TFConsultaOP]);
end.


 