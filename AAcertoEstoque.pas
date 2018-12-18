unit AAcertoEstoque;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Componentes1, ExtCtrls, PainelGradiente, ComCtrls, StdCtrls, Buttons,
  ConvUnidade, CONSTANTES, Mask, DBCtrls, Tabela, Db, DBTables,
  BotaoCadastro, Localizacao, DBKeyViolation, UnProdutos, numericos;

type
  TFAcertoEstoque = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    Localiza: TConsultaPadrao;
    CadProduto: TQuery;
    PanelColor3: TPanelColor;
    BotaoCadastrar2: TBitBtn;
    BotaoGravar2: TBitBtn;
    BotaoCancelar2: TBitBtn;
    BotaoFechar2: TBitBtn;
    Label12: TLabel;
    EditLocaliza1: TEditLocaliza;
    SpeedButton4: TSpeedButton;
    Label11: TLabel;
    Label14: TLabel;
    EditLocaliza2: TEditLocaliza;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    EditColor1: TEditColor;
    Label20: TLabel;
    ComboBoxColor1: TComboBoxColor;
    Label3: TLabel;
    Label16: TLabel;
    numerico1: Tnumerico;
    Label19: TLabel;
    numerico2: Tnumerico;
    Label15: TLabel;
    MaskEditColor1: TMaskEditColor;
    Label4: TLabel;
    numerico3: Tnumerico;
    BBAjuda: TBitBtn;
    Label5: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBEditLocaliza2Select(Sender: TObject);
    procedure DBEditLocaliza2Retorno(Retorno1, Retorno2: String);
    procedure DBEditLocaliza1Cadastrar(Sender: TObject);
    procedure DBEditLocaliza1Retorno(Retorno1, Retorno2: String);
    procedure DBComboBoxColor1Exit(Sender: TObject);
    procedure DBEditNumerico2Exit(Sender: TObject);
    procedure BotaoFechar2Click(Sender: TObject);
    procedure BotaoCadastrar2Click(Sender: TObject);
    procedure BotaoGravar2Click(Sender: TObject);
    procedure BotaoCancelar2Click(Sender: TObject);
    procedure EditLocaliza2Change(Sender: TObject);
    procedure numerico3Change(Sender: TObject);
    procedure numerico2Exit(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EditLocaliza1Exit(Sender: TObject);
  private
    QdadeProduto : double;
    UnidadePadrao, UnidadeManter : string;
    UnProduto : TFuncoesProduto;
    CodOpe : string;
    procedure AdicionaEstoque;
    procedure MudaEnabled( acao : Boolean );
    procedure ValidaGravacao;
  public

    { Public declarations }
  end;

var
  FAcertoEstoque: TFAcertoEstoque;

implementation

uses APrincipal, AOperacoesEstoques, constMsg, funNumeros, funsql;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFAcertoEstoque.FormCreate(Sender: TObject);
begin
   UnidadeManter := '';
   UnProduto := TFuncoesProduto.criar(self,FPrincipal.BaseDados);
   MaskEditColor1.EditMask := FPrincipal.CorFoco.AMascaraData;
   ComboBoxColor1.Color := FPrincipal.CorFoco.ACorObrigatorio;
   EditLocaliza1.AInfo.CampoCodigo := Varia.CodigoProduto;  // caso codigo pro ou codigo de barras
   if config.MostraCasaDecimalQTD then
      numerico1.AMascara := Varia.MascaraQtd;
   numerico2.AMascara := Varia.MascaraMoeda;
   numerico3.AMascara := Varia.MascaraMoeda;
   numerico2.ADecimal := varia.Decimais;
   numerico3.ADecimal := varia.Decimais;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFAcertoEstoque.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   UnProduto.free;
   Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações dos localizas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{*******************Inicializa as select do localiza***************************}
procedure TFAcertoEstoque.DBEditLocaliza2Select(Sender: TObject);
var
  CodPro : string;
begin
  EditLocaliza1.ASelectValida.Clear;
  EditLocaliza1.ASelectValida.add(  ' Select Pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
                                    ' pro.I_SEQ_PRO, mov.C_COD_BAR ' +
                                    ' From cadprodutos as pro, ' +
                                    ' MovQdadeProduto as mov '+
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
                                    ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil) +
                                    ' order by c_nom_pro asc');
end;

{**********************Retorna o codigo da unidade*****************************}
procedure TFAcertoEstoque.DBEditLocaliza2Retorno(Retorno1,
  Retorno2: String);
begin
if Retorno1 <> '' then
begin
  UnProduto.LocalizaProdutoSequencialQdade(CadProduto, retorno1,IntToStr(varia.CodigoEmpFil));
  label3.Caption := '';
  if Retorno1 <> '' then
  begin
    Label3.Caption := 'Unidade de estoque - ' + CadProduto.fieldByName('C_COD_UNI').AsString;
    ComboBoxColor1.Items := UnProduto.validaUnidade.UnidadesParentes(CadProduto.fieldByName('C_COD_UNI').AsString);
    if UnidadeManter = '' then
      ComboBoxColor1.Text := CadProduto.fieldByName('C_COD_UNI').AsString
    else
    begin
      if UnProduto.ValidaUnidade.ValidaUnidade( UnidadeManter, CadProduto.fieldByName('C_COD_UNI').AsString) then
        ComboBoxColor1.Text := UnidadeManter
      else
        ComboBoxColor1.Text := CadProduto.fieldByName('C_COD_UNI').AsString
    end;
    UnidadePadrao := CadProduto.fieldByName('C_COD_UNI').AsString;
    QdadeProduto := CadProduto.fieldByName('N_QTD_PRO').AsFloat;
    Label5.Caption := '<= Quantidade existente = ' + FormatFloat(Varia.MascaraQtd, QdadeProduto);
    numerico3.AValor := UnProduto.ValorDeVenda(StrtoInt(Retorno1),varia.TabelaPreco);
  end;
end;
end;

{*****************Cadastra uma nova operação de estoque************************}
procedure TFAcertoEstoque.DBEditLocaliza1Cadastrar(Sender: TObject);
begin
   FOperacoesEstoques := TFOperacoesEstoques.CriarSDI(Application,'',FPrincipal.VerificaPermisao('FOperacoesEstoques'));
   FOperacoesEstoques.CadOperacoesEstoques.Insert;
   FOperacoesEstoques.ShowModal;
end;

{ ************** retorno da operaco estoque ********************************** }
procedure TFAcertoEstoque.DBEditLocaliza1Retorno(Retorno1,
  Retorno2: String);
begin
  editcolor1.Text := Retorno1;
  CodOpe := Retorno2;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{******************Chama a rotina para validar a gravacao**********************}
procedure TFAcertoEstoque.DBComboBoxColor1Exit(Sender: TObject);
begin
 if UnidadePadrao <> '' then
   if UnidadePadrao <> ComboBoxColor1.text then
    if not UnProduto.ValidaUnidade.ValidaUnidade(ComboBoxColor1.text, UnidadePadrao) then
      ComboBoxColor1.text := UnidadePadrao;
  ValidaGravacao;
end;

{********************** Verifica a qdade de estoque conforme config geral *****}
procedure TFAcertoEstoque.DBEditNumerico2Exit(Sender: TObject);
begin
 if ( EditLocaliza1.text <> '' ) and (EditColor1.Text = 'S') then
   if not UnProduto.VerificaEstoque( ComboBoxColor1.Text,UnidadePadrao,
                                    numerico1.avalor,
                                    CadProduto.fieldbyName('I_SEQ_PRO').AsString) then
      numerico1.Setfocus;
  ValidaGravacao;
end;

{************* fecha o formulario ******************************************* }
procedure TFAcertoEstoque.BotaoFechar2Click(Sender: TObject);
begin
  self.close;
end;

{************** adiciona o movimento de estoque ****************************** }
procedure TFAcertoEstoque.AdicionaEstoque;
begin
  UnProduto.BaixaProdutoEstoque( CadProduto.fieldByName('I_SEQ_PRO').AsInteger,
                                 StrToInt(EditLocaliza2.text),
                                 0,0,
                                 varia.MoedaBase, 0,
                                 strToDate(MaskEditColor1.text),
                                 numerico1.AValor, numerico2.AValor,
                                 ComboBoxColor1.text, UnidadePadrao);
end;


procedure TFAcertoEstoque.MudaEnabled( acao : Boolean );
var
  laco : integer;
begin
  UnidadePadrao := '';
  for laco := 0 to PanelColor1.ControlCount - 1 do
  begin
    if (PanelColor1.Controls[laco] is TControl) then
      (PanelColor1.Controls[laco] as TControl).Enabled := acao;
    if (PanelColor1.Controls[laco] is TCustomEdit) and not (PanelColor1.Controls[laco] is TMaskEditColor) then
       (PanelColor1.Controls[laco] as TCustomEdit).Clear;
  end;
  MaskEditColor1.Clear;
  ComboBoxColor1.Clear;
  numerico1.AValor := 0;
  numerico2.AValor := 0;
  EditLocaliza1.Atualiza;
  if CheckBox2.Checked then   // caso manter o mesma operacao para todos os cadastros
    EditLocaliza2.Text := CodOpe;
  EditLocaliza2.Atualiza;
  Label3.Caption := 'Unidade';
  BotaoCadastrar2.Enabled := not acao;
  BotaoGravar2.Enabled := acao;
  BotaoCancelar2.Enabled := acao;
  BotaoFechar2.Enabled := not acao;
  EditColor1.Enabled := false;
  Label5.Caption := '';
end;


procedure TFAcertoEstoque.BotaoCadastrar2Click(Sender: TObject);
begin
  MudaEnabled(true);
  BotaoGravar2.Enabled := false;
  MaskEditColor1.Text := datetostr(Date);
  EditLocaliza1.SetFocus;
end;

procedure TFAcertoEstoque.BotaoGravar2Click(Sender: TObject);
begin
  if CheckBox3.Checked then
    UnidadeManter := ComboBoxColor1.text;
  if EditColor1.Text = 'S' then
    UnProduto.VerificaPontoPedido( CadProduto.fieldByname('I_SEQ_PRO').AsInteger,
                                   UnProduto.CalculaQdadePadrao(ComboBoxColor1.text,
                                   UnidadePadrao,numerico1.avalor,
                                   CadProduto.fieldByname('I_SEQ_PRO').AsString));
  AdicionaEstoque;
  MudaEnabled(false);
  if CheckBox1.Checked then
    BotaoCadastrar2.Click;
end;

procedure TFAcertoEstoque.BotaoCancelar2Click(Sender: TObject);
begin
  MudaEnabled(false);
end;

procedure TFAcertoEstoque.ValidaGravacao;
begin
  if (EditLocaliza1.text = '') or (EditLocaliza2.text = '')  or
     (EditColor1.text = '' ) or  ( ComboBoxColor1.Text = '' ) or
     (numerico1.AValor = 0 ) or (MaskEditColor1.Text[1] = ' ') then
     BotaoGravar2.Enabled := false
  else
     BotaoGravar2.Enabled := true;
end;


procedure TFAcertoEstoque.EditLocaliza2Change(Sender: TObject);
begin
  ValidaGravacao;
end;

procedure TFAcertoEstoque.numerico3Change(Sender: TObject);
begin
  if numerico1.AValor <> 0 then
    numerico2.AValor := numerico3.AValor * numerico1.AValor;
end;

procedure TFAcertoEstoque.numerico2Exit(Sender: TObject);
begin
  if numerico3.AValor = 0 then
    numerico3.AValor := numerico2.AValor / numerico1.AValor;
end;

procedure TFAcertoEstoque.BBAjudaClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,FAcertoEstoque.HelpContext);
end;

procedure TFAcertoEstoque.FormShow(Sender: TObject);
begin
 Self.HelpFile := Varia.PathHelp + 'MEstoqueCusto.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
end;

procedure TFAcertoEstoque.EditLocaliza1Exit(Sender: TObject);
begin
  if (CheckBox2.Checked) and (ComboBoxColor1.Enabled) then
    ComboBoxColor1.SetFocus;
end;

Initialization
 RegisterClasses([TFAcertoEstoque]);
end.
