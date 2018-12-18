unit AOrdemProducao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Buttons, Componentes1, ExtCtrls, PainelGradiente, Db, DBTables,
  Tabela, Localizacao, Mask, DBCtrls, Grids, DBGrids, BotaoCadastro,
  DBKeyViolation, UCrpe32, UnOrdemProducao;

type
  TFOrdemProducao = class(TFormularioPermissao)
    PanelColor2: TPanelColor;
    PanelColor3: TPanelColor;
    BitBtn1: TBitBtn;
    BBAjuda: TBitBtn;
    Shape3: TShape;
    Label23: TLabel;
    Shape5: TShape;
    Shape4: TShape;
    Label18: TLabel;
    DBEditColor1: TDBEditColor;
    Label32: TLabel;
    eproduto: TDBEditLocaliza;
    SpeedButton10: TSpeedButton;
    Label38: TLabel;
    CadOP: TSQL;
    DataCadOP: TDataSource;
    Label1: TLabel;
    DBEditColor2: TDBEditColor;
    Label2: TLabel;
    DBEditColor3: TDBEditColor;
    CadOPI_EMP_FIL: TIntegerField;
    CadOPI_NRO_ORP: TIntegerField;
    CadOPI_SEQ_PRO: TIntegerField;
    CadOPI_COD_MAQ: TIntegerField;
    CadOPI_COD_SIT: TIntegerField;
    CadOPI_LAN_ORC: TIntegerField;
    CadOPD_DAT_EMI: TDateField;
    CadOPD_DAT_ENT: TDateField;
    CadOPD_DAT_PRO: TDateField;
    CadOPN_QTD_PRO: TFloatField;
    CadOPN_QTD_SAC: TFloatField;
    CadOPN_PES_CIC: TFloatField;
    CadOPN_CIC_PRO: TFloatField;
    CadOPN_TOT_HOR: TFloatField;
    CadOPI_NRO_PED: TIntegerField;
    CadOPL_OBS_ORP: TMemoField;
    CadOPD_ULT_ALT: TDateField;
    DBGridColor2: TDBGridColor;
    Label3: TLabel;
    DBEditColor4: TDBEditColor;
    Label9: TLabel;
    Shape1: TShape;
    Label4: TLabel;
    DBEditNumerico1: TDBEditNumerico;
    Label5: TLabel;
    Material: TQuery;
    DataMaterial: TDataSource;
    BotaoCadastrar1: TBitbtn;
    BotaoGravar1: TBotaoGravar;
    BotaoCancelar1: TBotaoCancelar;
    ProximoCodigoFilial1: TProximoCodigoFilial;
    CadOPC_COD_PRO: TStringField;
    ConsultaPadrao1: TConsultaPadrao;
    Shape2: TShape;
    Label8: TLabel;
    DBEditNumerico4: TDBEditNumerico;
    Label10: TLabel;
    DBEditNumerico5: TDBEditNumerico;
    Shape13: TShape;
    Label11: TLabel;
    DBEditLocaliza3: TDBEditLocaliza;
    SpeedButton11: TSpeedButton;
    Label12: TLabel;
    Shape9: TShape;
    DBMemoColor1: TDBMemoColor;
    CadProduto: TQuery;
    DBEditNumerico2: TDBEditNumerico;
    Label6: TLabel;
    Label7: TLabel;
    DBEditNumerico3: TDBEditNumerico;
    Label13: TLabel;
    Label14: TLabel;
    DBEditColor5: TDBEditColor;
    BitBtn2: TBitBtn;
    Rel: TCrpe;
    CadOPC_TIP_ORP: TStringField;
    CadOPD_DAT_FEC: TDateField;
    CadOPD_DAT_INI: TDateField;
    CadOPD_DAT_FIM: TDateField;
    CadOPN_QTD_TER: TFloatField;
    Label15: TLabel;
    DBEditLocaliza1: TDBEditLocaliza;
    SpeedButton1: TSpeedButton;
    Label16: TLabel;
    Aux: TQuery;
    MaterialI_SEQ_PRO: TIntegerField;
    MaterialC_COD_UNI: TStringField;
    MaterialN_QTD_PRO: TFloatField;
    MaterialD_ULT_ALT: TDateField;
    MaterialC_UNI_PAI: TStringField;
    Materialc_cod_pro: TStringField;
    Materialc_nom_pro: TStringField;
    MaterialTotal: TFloatField;
    MaterialI_EMP_FIL: TIntegerField;
    MaterialI_NRO_ORP: TIntegerField;
    CadOPN_PES_TOT: TFloatField;
    CadOPN_PEC_HOR: TFloatField;
    DBEditNumerico6: TDBEditNumerico;
    Label17: TLabel;
    DBEditNumerico7: TDBEditNumerico;
    SpeedButton3: TSpeedButton;
    ValidaGravacao1: TValidaGravacao;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure eprodutoSelect(Sender: TObject);
    procedure CadOPBeforePost(DataSet: TDataSet);
    procedure eprodutoRetorno(Retorno1, Retorno2: String);
    procedure CadOPAfterInsert(DataSet: TDataSet);
    procedure DBEditNumerico1Change(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BotaoCadastrar1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BotaoCancelar1DepoisAtividade(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure CadOPAfterEdit(DataSet: TDataSet);
    procedure DBEditLocaliza3Change(Sender: TObject);
    procedure CadOPAfterCancel(DataSet: TDataSet);
    procedure DBEditLocaliza3Cadastrar(Sender: TObject);
  private
    unOP : TFuncoesOrdemProducao;
    Alterando : Boolean;
    procedure NovaOrdemProducao;
  public
    procedure AbreNovaOrdemProducao;
    procedure AlteraOP(NroOp : Integer; PermiteAlterando : Boolean);
  end;

var
  FOrdemProducao: TFOrdemProducao;

implementation

uses APrincipal, funsql, constantes, funobjeto, AMovOP, ASituacoes;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFOrdemProducao.FormCreate(Sender: TObject);
begin
  unOP := TFuncoesOrdemProducao.Criar(self,FPrincipal.BaseDados);
  CadOP.open;
  rel.ReportName := varia.PathRel + 'Diverso\OrdemProducao.rpt';
  Alterando := false;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFOrdemProducao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 CadOp.close;
 material.close;
 cadproduto.close;
 aux.close;
 unOP.free;
 Action := CaFree;
end;


procedure TFOrdemProducao.NovaOrdemProducao;
begin
   AdicionaSQLAbreTabela(CadOP, ' Select * from cadOrdemProducao ');
   cadop.insert;
end;

procedure TFOrdemProducao.AbreNovaOrdemProducao;
begin
  NovaOrdemProducao;
  self.ShowModal;
end;

{ ******************** altera uma ordem de producao ************************* }
procedure TFOrdemProducao.AlteraOP(NroOp : Integer; PermiteAlterando : Boolean);
begin
  Alterando := true;
  unOP.LocalizaOP(CadOp, NroOp);
  unOP.LocalizaMaterialMovOP(material,CadOPI_NRO_ORP.AsInteger,CadOPN_QTD_PRO.AsFloat);
  DBEditLocaliza3.atualiza;
  DBEditLocaliza1.atualiza;
  eproduto.atualiza;
  if PermiteAlterando then
    cadop.edit;
 end;


{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFOrdemProducao.BitBtn1Click(Sender: TObject);
begin
  self.close;
end;

procedure TFOrdemProducao.eprodutoSelect(Sender: TObject);
begin
  eproduto.ASelectValida.Clear;
  eproduto.ASelectValida.add(  ' Select Pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
                               ' pro.I_SEQ_PRO, mov.C_COD_BAR ' +
                               ' From cadprodutos as pro, ' +
                               ' MovQdadeProduto as mov ' +
                               ' Where pro.I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                               ' and ' + varia.CodigoProduto + ' = ''@''' +
                               ' and pro.C_KIT_PRO = ''P'' ' +
                               ' and pro.I_seq_pro = Mov.I_seq_pro ' +
                               ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil) );
  eproduto.ASelectLocaliza.Clear;
  eproduto.ASelectLocaliza.add(' Select pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
                               ' pro.I_SEQ_PRO, mov.C_COD_BAR ' +
                               ' from cadprodutos as pro, ' +
                               ' MovQdadeProduto as mov ' +
                               ' Where pro.I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                               ' and pro.c_nom_pro like ''@%''' +
                               ' and pro.C_KIT_PRO = ''P'' ' +
                               ' and pro.I_seq_pro = Mov.I_seq_pro ' +
                               ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil) );
end;

procedure TFOrdemProducao.CadOPBeforePost(DataSet: TDataSet);
begin
  AlterarEnabledDet([bitbtn2, SpeedButton3], true);
  CadOPD_ULT_ALT.AsDateTime := date;
  If CadOP.State = dsInsert Then
    ProximoCodigoFilial1.VerificaCodigo;
end;

procedure TFOrdemProducao.eprodutoRetorno(Retorno1, Retorno2: String);
var
  CodigoOP : integer;
begin
  if Retorno1 <> '' then
  begin
    LimpaSQLTabela(CadProduto);
    AdicionaSQLTabela(CadProduto, ' Select ci.n_cic_pro, ci.n_pes_cic, n_qtd_cic, pro.i_qtd_cai, ci.n_qtd_cic ' +
                                  ' From cadprodutos as pro,  CADCICLOPRODUTO AS CI ' +
                                  ' Where pro.I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                                  ' and pro.i_seq_pro = ' + Retorno1 +
                                  ' and pro.C_KIT_PRO = ''P'' ' +
                                  ' and pro.i_seq_pro = ci.i_seq_pro ' +
                                  ' and ci.i_emp_fil = ' + IntTostr(varia.CodigoEmpFil)  );
    AbreTabela(CadProduto);

    if CadOP.State in [ dsInsert ] then
    begin
      CodigoOP := CadOPI_NRO_ORP.AsInteger;
      cadop.post;
      unOP.LocalizaOP(CadOP, CodigoOP);
      CadOP.Edit;
    end;

    unOP.ExcluiMovOP(CadOPI_NRO_ORP.AsInteger);
    if CadOP.State in [ dsEdit, dsInsert ] then
    begin
      CadOPN_CIC_PRO.AsFloat := CadProduto.fieldByName('n_cic_pro').AsFloat;
      CadOPN_QTD_SAC.AsFloat := CadProduto.fieldByName('i_qtd_cai').AsFloat;
      CadOPN_PES_CIC.AsFloat := CadProduto.fieldByName('n_pes_cic').AsFloat;
      if CadProduto.fieldByName('n_qtd_cic').AsFloat <> 0 then
        CadOPN_PEC_HOR.AsFloat := ((60 / CadProduto.fieldByName('n_cic_pro').AsFloat ) *
                                  60 ) * CadProduto.fieldByName('n_qtd_cic').AsFloat
      else
        CadOPN_PEC_HOR.AsFloat := 0;

      CadOPI_SEQ_PRO.AsInteger := strtoint(Retorno1);
    end;

    unOP.CarregaMovOP(Aux,strtoint(Retorno1),CadOPI_NRO_ORP.AsInteger);
    unOP.LocalizaMaterialMovOP(material,CadOPI_NRO_ORP.AsInteger,CadOPN_QTD_PRO.AsFloat);
  end;
end;

procedure TFOrdemProducao.CadOPAfterInsert(DataSet: TDataSet);
begin
  CadOPI_EMP_FIL.AsInteger := varia.CodigoEmpFil;
  CadOPD_DAT_EMI.AsDateTime := date;
  CadOPC_TIP_ORP.AsString := 'A';  // A - aberta / F - Fechada / C - cancelada
  ProximoCodigoFilial1.execute('CadOrdemProducao','I_EMP_FIL',varia.CodigoEmpFil);
  AlterarEnabledDet([BitBtn2], false);
end;

procedure TFOrdemProducao.DBEditNumerico1Change(Sender: TObject);
begin
  if cadop.State in [ dsEdit, dsInsert ] then
  begin
     if CadOPN_PEC_HOR.AsFloat <> 0 then
        CadOPN_TOT_HOR.AsFloat := CadOPN_QTD_PRO.AsFloat / CadOPN_PEC_HOR.AsFloat
     else
       CadOPN_TOT_HOR.AsFloat := 0;

     if CadOPN_QTD_PRO.AsFloat <> 0 then
        unOP.LocalizaMaterialMovOP(material,CadOPI_NRO_ORP.AsInteger,CadOPN_QTD_PRO.AsFloat);

     CadOPN_PES_TOT.AsFloat := CadOPN_QTD_PRO.AsFloat * CadOPN_PES_CIC.AsFloat;
  end;
end;

procedure TFOrdemProducao.BitBtn2Click(Sender: TObject);
begin
 rel.Connect.Retrieve;
 rel.Connect.DatabaseName := varia.AliasBAseDados;
 rel.Connect.ServerName := varia.AliasRelatorio;
 rel.WindowState := wsMaximized;
 rel.ParamFields.Retrieve;
 rel.ParamFields[0].Value := CadOPI_NRO_ORP.AsString;
 rel.ParamFields[1].Value := CadOPI_EMP_FIL.AsString;
 rel.ParamFields[2].Value := label16.caption;
 rel.ReportTitle  := UpperCase(label38.caption);
 rel.execute;
end;

procedure TFOrdemProducao.BotaoCadastrar1Click(Sender: TObject);
begin
  NovaOrdemProducao;
  Material.close;
  DBEditLocaliza3.Atualiza;
  DBEditLocaliza1.Atualiza;
  eproduto.atualiZA;
  DBEditLocaliza3.SetFocus;
  LimpaLabel([Label12,Label38, Label16]);
end;

procedure TFOrdemProducao.FormShow(Sender: TObject);
begin
  if DBEditlocaliza3.Enabled then
   DBEditlocaliza3.SetFocus;
end;

procedure TFOrdemProducao.BotaoCancelar1DepoisAtividade(Sender: TObject);
begin
  if not alterando then
  begin
    unOP.ExcluiMovOP(CadOPI_NRO_ORP.AsInteger);
    unOP.ExcluiCadOP(CadOPI_NRO_ORP.AsInteger);
  end;
end;

procedure TFOrdemProducao.SpeedButton3Click(Sender: TObject);
begin
 if cadop.State in [dsedit,dsinsert] then
 begin
   FMovOP := TFMovOP.CriarSDI(application, '', FPrincipal.VerificaPermisao('FMovOP'));
   FMovOP.Carrega(CadOPI_NRO_ORP.AsInteger,MaterialI_SEQ_PRO.AsInteger);
   FMovOP.ShowModal;
   AtualizaSQLTabela(Material);
 end;
end;


procedure TFOrdemProducao.CadOPAfterEdit(DataSet: TDataSet);
begin
  AlterarEnabledDet([BitBtn2], false);
end;

procedure TFOrdemProducao.DBEditLocaliza3Change(Sender: TObject);
begin
  if cadop.State in [dsEdit, dsInsert ] then
    ValidaGravacao1.execute;
end;

procedure TFOrdemProducao.CadOPAfterCancel(DataSet: TDataSet);
begin
  AlterarEnabledDet([BitBtn2], true);
end;

procedure TFOrdemProducao.DBEditLocaliza3Cadastrar(Sender: TObject);
begin
  FSituacoes := TFSituacoes.CriarSDI(application, '', fPrincipal.VerificaPermisao('FSituacoes'));
  FSituacoes.ShowModal;
end;

Initialization
 RegisterClasses([TFOrdemProducao]);
end.
