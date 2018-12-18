unit ACicloProduto;
{          Autor: Sergio Luiz Censi
    Data Criação: 06/04/1999;
  Data Alteração: 06/04/1999;
    Alterado por: Sergio Luis Censi
Motivo alteração: - Adicionado os comentários e o blocos nas rotinas, e realizado
                    um teste - 06/04/199 
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Db, DBTables, Grids, DBGrids, Tabela, PainelGradiente, StdCtrls, Buttons,
  ExtCtrls, Componentes1, DBKeyViolation, Localizacao, UnNotafiscal, Mask,
  numericos;

type
  TFCicloProduto = class(TFormularioPermissao)
    PanelColor1: TPanelColor;
    PainelGradiente1: TPainelGradiente;
    grade: TDBGridColor;
    MovComposicao: TQuery;
    Aux: TQuery;
    ConsultaPadrao1: TConsultaPadrao;
    DataComposicaoProduto: TDataSource;
    Unidade: TLabel;
    MovComposicaoI_EMP_FIL: TIntegerField;
    MovComposicaoI_SEQ_CIC: TIntegerField;
    MovComposicaoI_SEQ_PRO: TIntegerField;
    MovComposicaoC_COD_UNI: TStringField;
    MovComposicaoN_CIC_PRO: TFloatField;
    MovComposicaoN_PES_CIC: TFloatField;
    MovComposicaoN_QTD_CIC: TFloatField;
    MovComposicaoD_ULT_ALT: TDateField;
    MovComposicaoC_UNI_TEM: TStringField;
    Novo: TPanelColor;
    numerico1: Tnumerico;
    numerico2: Tnumerico;
    numerico3: Tnumerico;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    MovComposicaoc_nom_pro: TStringField;
    MovComposicaoc_cod_pro: TStringField;
    MovComposicaoc_cod_bar: TStringField;
    PanelColor2: TPanelColor;
    PanelColor3: TPanelColor;
    Label3: TLabel;
    EClassificacao: TEditColor;
    SpeedButton3: TSpeedButton;
    LNomClassificacao: TLabel;
    Label12: TLabel;
    EProduto: TEditLocaliza;
    SpeedButton4: TSpeedButton;
    Label11: TLabel;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    BBAjuda: TBitBtn;
    ComboBoxColor2: TComboBoxColor;
    BitBtn5: TBitBtn;
    Label2: TLabel;
    ComboBoxColor1: TComboBoxColor;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure EClassificacaoExit(Sender: TObject);
    procedure EClassificacaoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BBAjudaClick(Sender: TObject);
    procedure EProdutoSelect(Sender: TObject);
    procedure gradeKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn2Click(Sender: TObject);
    procedure EProdutoRetorno(Retorno1, Retorno2: String);
    procedure gradeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    SeqPro : integer;
    procedure AdicionaNovo(Ciclo, peso, qdade : Double; Uni, UniTempo : string );
    procedure CarregaMovComposicao;
    function ValidaClassificacao : Boolean;
    Function LocalizaClassificacao : Boolean;
    function ValidaUnidade( CodUnidade : string ) : Boolean;
  public
  end;

var
  FCicloProduto: TFCicloProduto;

implementation

uses APrincipal, constantes, constmsg, ALocalizaClassificacao, FunSql, funstring;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFCicloProduto.FormCreate(Sender: TObject);
begin
   ComboBoxColor1.ItemIndex := 1;
   ComboBoxColor2.ItemIndex := 1;
   grade.Columns[0].FieldName := varia.CodigoProduto;
   SeqPro := 0;
   Self.HelpFile := Varia.PathHelp + 'MPONTOLOJA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
   CarregaMovComposicao;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFCicloProduto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MovComposicao.close;
  Aux.close;
  Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações de Inicalização
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}


{**************************Carrega o Movimento *******************************}
procedure TFCicloProduto.CarregaMovComposicao;
var
  SeqProduto : string;
begin
  MovComposicao.close;
  MovComposicao.sql.clear;
  MovComposicao.SQL.Add(' Select ci.*, pro.c_nom_pro, pro.c_cod_pro, mov.c_cod_bar ' +
                        ' from CadCicloProduto ci, cadprodutos pro, movqdadeproduto mov '+
                        ' Where ci.i_seq_pro = pro.i_seq_pro ' +
                        ' and pro.i_cod_emp = ' +  IntToStr(varia.CodigoEmpresa) +
                        ' and ci.I_EMP_FIL = ' +  IntToStr(varia.CodigoEmpFil) +
                        ' and mov.i_seq_pro = ci.i_seq_pro ' +
                        ' and mov.I_EMP_FIL = ' +  IntToStr(varia.CodigoEmpFil) );

 if EClassificacao.Text <> '' then
    AdicionaSQLTabela(MovComposicao,' and pro.C_Cod_Cla like  '''+ EClassificacao.Text + '%''');

  if SeqPro <> 0 then
    MovComposicao.SQL.Add(' and ci.i_seq_pro = ' + Inttostr(SeqPro) );

  if CheckBox1.Checked then
    MovComposicao.SQL.Add(' and isnull(ci.n_cic_pro,0) = 0');
  MovComposicao.open;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                          eventos dos filtros
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{*************** valida se a classificacao Existe *****************************}
function TFCicloProduto.ValidaClassificacao : Boolean;
begin
  AdicionaSQLAbreTabela(Aux,' Select * from CadClassificacao' +
                            ' Where C_Cod_Cla = ''' + EClassificacao.text + '''' +
                            ' and c_Tip_Cla = ''P''');
  result := not Aux.Eof;
  LNomClassificacao.Caption := Aux.FieldByName('C_Nom_Cla').Asstring;
end;

{****************** localiza a classificacao do produto ***********************}
Function TFCicloProduto.LocalizaClassificacao: Boolean;
Var
  VpfCodClassificacao,VpfNomClassificacao : String;
begin
  FLocalizaClassificacao := TFLocalizaClassificacao.criarSDI(Application,'',FPrincipal.VerificaPermisao('FLocalizaClassificacao'));
  result := FLocalizaClassificacao.LocalizaClassificacao(VpfCodClassificacao,VpfNomClassificacao,'P');
  if result Then
  begin
    EClassificacao.Text := VpfCodClassificacao;
    LNomClassificacao.Caption := VpfNomClassificacao;
  end;
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************************Fecha o Formulario corrente***********************}
procedure TFCicloProduto.BitBtn1Click(Sender: TObject);
begin
  self.close
end;

{********************** quando sai do codigo da classificacao *****************}
procedure TFCicloProduto.EClassificacaoExit(Sender: TObject);
begin
  if EClassificacao.text <> '' then
  begin
    if  ValidaClassificacao then
      CarregaMovComposicao
    else
      if not LocalizaClassificacao Then
        EClassificacao.SetFocus
      else
       CarregaMovComposicao;
  end
  else
    CarregaMovComposicao;
end;

{********************** filtra as teclas pressionadas *************************}
procedure TFCicloProduto.EClassificacaoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    Vk_F3 : LocalizaClassificacao;
       13 : EClassificacaoExit(nil);
  end;
end;


function TFCicloProduto.ValidaUnidade( CodUnidade : string ) : Boolean;
begin
   AdicionaSQLAbreTabela(Aux,'Select * from cadunidade where c_cod_uni = ''' + CodUnidade + '''');
   result := aux.eof;
end;

procedure TFCicloProduto.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,self.HelpContext);
end;

procedure TFCicloProduto.EProdutoSelect(Sender: TObject);
begin
  EProduto.ASelectValida.Clear;
  EProduto.ASelectValida.add(  ' Select Pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
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
  EProduto.ASelectLocaliza.Clear;
  EProduto.ASelectLocaliza.add(' Select pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
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


procedure TFCicloProduto.gradeKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = '.' then  //se for pressinado ponto substitui por vírgula
     key := ',';
end;

procedure TFCicloProduto.BitBtn2Click(Sender: TObject);
begin
  if confirmacao('Deseja realmente adicionar todos os produtos ao cadastro de ciclos ?') then
  begin
    LimpaSQLTabela(aux);
    AdicionaSQLTabela(aux,' insert into cadcicloproduto(i_emp_fil, i_seq_cic,i_seq_pro, d_ult_alt) ' +
                          ' (select ' + Inttostr(varia.CodigoEmpFil) + ',1,i_seq_pro, ' +
                          SQLTextoDataAAAAMMMDD(date) + ' from CADPRODUTOS ' +
                          ' where i_seq_pro not in ' +
                          ' (select i_seq_pro from CADCICLOPRODUTO where i_emp_fil = ' +
                          Inttostr(varia.CodigoEmpFil) +'))' );
    aux.ExecSQL;
    CarregaMovComposicao;
  end;
end;

procedure TFCicloProduto.EProdutoRetorno(Retorno1, Retorno2: String);
begin
  if Retorno1 <> '' then
    SeqPro := strtoint(retorno1)
  else
    if EProduto.Text = '' then
     SeqPro := 0;
  CarregaMovComposicao;
end;

procedure TFCicloProduto.gradeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key = vk_f2 then
    BitBtn5.Click;
end;

procedure  TFCicloProduto.AdicionaNovo(Ciclo, peso, qdade : Double; Uni, UniTempo : string );
begin
  ExecutaComandoSql(Aux, ' update cadcicloproduto ' +
                         ' set n_cic_pro = ' + SubstituiStr(floattostr(Ciclo),',','.') +
                         ' ,n_pes_cic = ' + SubstituiStr(floattostr(peso),',','.') +
                         ' ,n_qtd_cic = ' + SubstituiStr(floattostr(qdade),',','.') +
                         ' ,c_cod_uni = ''' + uni + '''' +
                         ' ,c_uni_tem = ''' + uniTempo + '''' +
                         ' ,d_ult_alt = ' + SQLTextoDataAAAAMMMDD(date) +
                         ' where i_emp_fil = ' + Inttostr(varia.CodigoEmpFil) +
                         ' and i_seq_pro = ' + MovComposicaoI_SEQ_PRO.asstring );
end;

procedure TFCicloProduto.BitBtn3Click(Sender: TObject);
var
  ponto : TBookmark;
begin
  Novo.Visible := false;
  AdicionaNovo(numerico1.AValor, numerico2.AValor, numerico3.AValor, ComboBoxColor1.text, ComboBoxColor2.text);
  ponto := MovComposicao.GetBookmark;
  CarregaMovComposicao;
  MovComposicao.GotoBookmark(ponto);
  MovComposicao.FreeBookmark(ponto);
  grade.SetFocus;
end;

procedure TFCicloProduto.BitBtn4Click(Sender: TObject);
begin
  Novo.Visible := false;
  grade.SetFocus;
end;

procedure TFCicloProduto.BitBtn5Click(Sender: TObject);
begin
  numerico1.AValor := MovComposicaoN_CIC_PRO.AsFloat;
  numerico2.AValor := MovComposicaoN_PES_CIC.AsFloat;
  numerico3.AValor := MovComposicaoN_QTD_CIC.AsFloat;
  if MovComposicaoC_COD_UNI.AsString = 'gr' then
    ComboBoxColor2.ItemIndex := 0
  else
    if MovComposicaoC_COD_UNI.AsString = 'kg' then
      ComboBoxColor2.ItemIndex := 1
     else
       if MovComposicaoC_COD_UNI.AsString = 'tn' then
         ComboBoxColor2.ItemIndex := 2;

  if MovComposicaoC_UNI_TEM.AsString = 'S' then
    ComboBoxColor1.ItemIndex := 0
  else
    if MovComposicaoC_UNI_TEM.AsString = 'M' then
      ComboBoxColor1.ItemIndex := 1
    else
      if MovComposicaoC_UNI_TEM.AsString = 'H' then
        ComboBoxColor1.ItemIndex := 2;

  Novo.Visible := true;
  numerico1.SetFocus;
end;

procedure TFCicloProduto.SpeedButton3Click(Sender: TObject);
begin
  LocalizaClassificacao;
  CarregaMovComposicao;
end;

procedure TFCicloProduto.CheckBox1Click(Sender: TObject);
begin
  CarregaMovComposicao;
end;

Initialization
 RegisterClasses([TFCicloProduto]);
end.
