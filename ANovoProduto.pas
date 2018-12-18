unit ANovoProduto;
{          Autor: Sergio Luiz Censi
    Data Criação: 06/04/1999;
          Função: Cadastrar um novo
  Data Alteração: 06/04/1999;
Motivo alteração: - Adicionado os comentários e o blocos nas rotinas, e realizado
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Mask, DBCtrls, Tabela, Db, BotaoCadastro, Buttons,
  DBTables, Grids, DBGrids, Componentes1, formularios, PainelGradiente,
  DBKeyViolation, LabelCorMove, Localizacao, EditorImagem, UnProdutos, UnClassificacao,
  numericos, ComCtrls;

type
  TFNovoProduto = class(TFormularioPermissao)
    CadProdutos: TTabela;
    DataProdutos: TDataSource;
    PainelGradiente1: TPainelGradiente;
    PanelColor2: TPanelColor;
    BotaoGravar1: TBotaoGravar;
    BotaoCancelar1: TBotaoCancelar;
    BotaoFechar1: TBitBtn;
    CadUnidades: TTable;
    DataCadunidades: TDataSource;
    EditorImagem1: TEditorImagem;
    Localiza: TConsultaPadrao;
    BKit: TBitBtn;
    ValidaGravacao1: TValidaGravacao;
    CadProdutosI_SEQ_PRO: TIntegerField;
    CadProdutosI_COD_EMP: TIntegerField;
    CadProdutosC_COD_CLA: TStringField;
    CadProdutosC_COD_PRO: TStringField;
    CadProdutosC_COD_UNI: TStringField;
    CadProdutosI_COD_MOE: TIntegerField;
    CadProdutosC_NOM_PRO: TStringField;
    CadProdutosD_DAT_CAD: TDateField;
    CadProdutosN_PER_IPI: TFloatField;
    CadProdutosI_IND_COV: TIntegerField;
    CadProdutosC_ATI_PRO: TStringField;
    CadProdutosC_KIT_PRO: TStringField;
    CadProdutosL_DES_TEC: TMemoField;
    CadProdutosC_CLA_FIS: TStringField;
    CadProdutosC_PAT_FOT: TStringField;
    CadProdutosC_VEN_AVU: TStringField;
    CadProdutosN_RED_ICM: TFloatField;
    CadProdutosN_PER_KIT: TFloatField;
    CadProdutosC_COD_REF: TStringField;
    CadProdutosN_PER_MAK: TFloatField;
    CadProdutosC_BAR_FOR: TStringField;
    DataMovQdade: TDataSource;
    MovQdade: TQuery;
    MovQdadeI_EMP_FIL: TIntegerField;
    MovQdadeI_SEQ_PRO: TIntegerField;
    MovQdadeC_COD_BAR: TStringField;
    MovQdadeN_QTD_PRO: TFloatField;
    MovQdadeN_QTD_MIN: TFloatField;
    MovQdadeN_QTD_PED: TFloatField;
    MovQdadeN_PER_COM: TFloatField;
    CadProdutosN_IND_MUL: TFloatField;
    CadProdutosC_CIF_MOE: TStringField;
    MovQdadeI_COD_BAR: TIntegerField;
    CadProdutosC_TIP_CLA: TStringField;
    CadProdutosD_ULT_ALT: TDateField;
    MovQdadeD_ULT_ALT: TDateField;
    BBAjuda: TBitBtn;
    MovQdadeN_VLR_COM: TFloatField;
    BotaoCadastrar1: TBotaoCadastrar;
    CadProdutosC_PRO_COM: TStringField;
    CadProdutosI_TIP_TRI: TIntegerField;
    Paginas: TPageControl;
    TabSheet1: TTabSheet;
    PanelColor1: TPanelColor;
    DBFilialColor1: TDBFilialColor;
    TabSheet2: TTabSheet;
    PanelColor3: TPanelColor;
    Label10: TLabel;
    DBMemoColor1: TDBMemoColor;
    CadProdutosI_QTD_CAI: TIntegerField;
    MovQdadeN_EST_MAX: TFloatField;
    CadProdutosN_VLR_MAX: TFloatField;
    CadProdutosI_DAT_VAL: TIntegerField;
    CadProdutosI_COD_RED: TIntegerField;
    CadProdutosN_LIQ_CAI: TFloatField;
    CadProdutosc_uni_ven: TStringField;
    BImprime1: TBitBtn;
    GroupBox1: TGroupBox;
    Label31: TLabel;
    DBEditNumerico2: TDBEditNumerico;
    Label26: TLabel;
    Tributo: TComboBoxColor;
    Label19: TLabel;
    DBEditNumerico3: TDBEditNumerico;
    Label28: TLabel;
    EditLocaliza1: TDBEditLocaliza;
    ConsultaReducao: TSpeedButton;
    Label29: TLabel;
    CadProdutosI_ORI_MER: TIntegerField;
    DBComboBoxColor1: TDBComboBoxColor;
    Label34: TLabel;
    LblClassificacaoFiscal: TLabel;
    DecClassificacaoFiscal: TDBEditColor;
    GroupBox2: TGroupBox;
    LblQtdMin: TLabel;
    DecQtdMin: TDBEditNumerico;
    LblQtdPed: TLabel;
    DecQtdPed: TDBEditNumerico;
    Label5: TLabel;
    DBEditNumerico5: TDBEditNumerico;
    Label14: TLabel;
    EQdadePro: Tnumerico;
    Label15: TLabel;
    DBEditNumerico7: TDBEditNumerico;
    Label30: TLabel;
    DBEditNumerico8: TDBEditNumerico;
    Label8: TLabel;
    DBEditNumerico6: TDBEditNumerico;
    GroupBox3: TGroupBox;
    Label17: TLabel;
    EMultiplicador: TDBEditNumerico;
    Label23: TLabel;
    numerico2: Tnumerico;
    Label24: TLabel;
    DBEditNumerico4: TDBEditNumerico;
    Label22: TLabel;
    numerico1: Tnumerico;
    Label27: TLabel;
    DBEditColor6: TDBEditNumerico;
    Label33: TLabel;
    DBEditColor7: TDBEditColor;
    LblVenderAvulso: TLabel;
    DecVenderAvulso: TDBEditChar;
    Label21: TLabel;
    DBEditNumerico1: TDBEditNumerico;
    LblDescontoKit: TLabel;
    DecDescontoKit: TDBEditNumerico;
    BitBtn1: TBitBtn;
    DBText1: TDBText;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label32: TLabel;
    Label11: TLabel;
    Label18: TLabel;
    SpeedButton3: TSpeedButton;
    Label20: TLabel;
    Label25: TLabel;
    Label9: TLabel;
    SpeedButton1: TSpeedButton;
    Label2: TLabel;
    CodigoFil: TDBEditColor;
    descricao: TDBEditColor;
    DBLookupComboBoxColor1: TDBLookupComboBoxColor;
    DBEditColor2: TDBEditColor;
    CodigoPro: TDBEditColor;
    DBEditLocaliza3: TDBEditLocaliza;
    Tipo: TDBComboBoxColor;
    DBEditColor1: TDBEditColor;
    DBEditColor5: TDBEditColor;
    DBEditColor3: TDBEditColor;
    DBEditChar2: TDBEditChar;
    GroupBox5: TGroupBox;
    Label13: TLabel;
    DBEditColor4: TDBEditColor;
    Label16: TLabel;
    DBEditLocaliza2: TDBEditLocaliza;
    SpeedButton2: TSpeedButton;
    Label12: TLabel;
    Label35: TLabel;
    DBEditNumerico9: TDBEditNumerico;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CadProdutosAfterCancel(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure CadProdutosAfterInsert(DataSet: TDataSet);
    procedure DBLookupComboBoxColor1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure CadProdutosBeforeInsert(DataSet: TDataSet);
    procedure CodigoProExit(Sender: TObject);
    procedure CadProdutosAfterEdit(DataSet: TDataSet);
    procedure BKitClick(Sender: TObject);
    procedure DBEditColor4Change(Sender: TObject);
    procedure DBEditLocaliza1Change(Sender: TObject);
    procedure CadProdutosAfterPost(DataSet: TDataSet);
    procedure CadProdutosBeforePost(DataSet: TDataSet);
    procedure BotaoFechar1Click(Sender: TObject);
    procedure BotaoGravar1DepoisAtividade(Sender: TObject);
    procedure DBEditLocaliza3Retorno(Retorno1, Retorno2: String);
    procedure DBEditColor3Exit(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure DBEditColor3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MovQdadeBeforePost(DataSet: TDataSet);
    procedure BBAjudaClick(Sender: TObject);
    procedure CodigoProKeyPress(Sender: TObject; var Key: Char);
    procedure EMultiplicadorExit(Sender: TObject);
    procedure BotaoCadastrar1DepoisAtividade(Sender: TObject);
    procedure BotaoCancelar1AntesAtividade(Sender: TObject);
    procedure TributoChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BotaoCadastrar1AntesAtividade(Sender: TObject);
    procedure BImprime1Click(Sender: TObject);
    procedure DBEditLocaliza2Retorno(Retorno1, Retorno2: String);
    procedure DBEditLocaliza2Exit(Sender: TObject);
    procedure EditLocaliza1Exit(Sender: TObject);
    procedure DecClassificacaoFiscalExit(Sender: TObject);
  private
    { Private declarations }
    acao, fecharFromulario : Boolean;
    UnProdutos : TFuncoesProduto;
    UnCla : TFuncoesClassificacao;
    CifraoMoeda : string;
    Inseriu : boolean;
    procedure EscondeCampQtdCaixa;
    procedure AtualizaLocalizas;
    procedure EstadoBotoes(Estado : Boolean);
    procedure HabilitarKit(Habilitar : Boolean);
    function LocalizaClassificacao : Boolean;
    procedure MudaPagina;
  public
    function EntraNovoProduto(funcao:byte ;var codigo, sequencial : string; var desc : string; var Path : string; var kit, cifrao : string ):Boolean;
    procedure InsereNovoProduto(FecharAposOperacao : Boolean);
  end;

var
  FNovoProduto: TFNovoProduto;

implementation

uses APrincipal,  AMontaKit,
     FunSql, funObjeto, constantes, ConstMsg, UnCodigoBarra,
     ALocalizaClassificacao, AImprimeTag, AImprimeCodigoBarra;

{$R *.DFM}

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                   Ações de Inicialização e fechamento
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{**********************ocorre na criação do formulario*************************}
procedure TFNovoProduto.FormCreate(Sender: TObject);
begin
  DBFilialColor1.ACodFilial := Varia.CodigoFilCadastro;
  DBEditLocaliza2.ACampoObrigatorio := Config.CodigoBarras;
  Self.HelpFile := Varia.PathHelp + 'MPONTOLOJA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
  UnProdutos := TFuncoesProduto.criar(self, FPrincipal.BaseDados);
  UnCla := TFuncoesClassificacao.criar(self, FPrincipal.BaseDados);
  AbreTabela(CadProdutos);
  AbreTabela(MovQdade);
  AbreTabela(CadUnidades);
  GroupBox5.Visible := Config.CodigoBarras;
  if config.MostraCasaDecimalQTD then
    EQdadePro.AMascara := Varia.MascaraQtd;
end;

{********************ocorre quando o formulario é fechado**********************}
procedure TFNovoProduto.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := Cafree;
end;

{*********************Deixa o codigo do produto como foco**********************}
procedure TFNovoProduto.FormShow(Sender: TObject);
begin
 if CadProdutos.State =  dsInsert then
 begin
   if DBEditColor3.Enabled then
     DBEditColor3.SetFocus
   else
   begin
     CodigoPro.SetFocus;
     CodigoPro.SelectAll;
   end;
 end
 else
   Descricao.SetFocus;
 TributoChange(nil);   
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            Ações de camadas externas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}


{*************rotina para chamada de fora do form para carregar*****************
*********************os dados default da tela produtos ************************}
function TFNovoProduto.EntraNovoProduto(funcao:byte; var codigo, sequencial : string; var desc : string;  var Path : string; var kit, cifrao : string):Boolean;
begin
   acao := true;
   fecharFromulario := true;
   DBEditColor3.Enabled := false;
   SpeedButton1.Enabled := false;
  if funcao=1 then {inclusão}
  begin
    DBEditColor3.Field.EditMask := RetornaPicture(varia.mascaraCLA,codigo,'_');
    CadProdutos.Insert;
    CadProdutosI_COD_EMP.Value := varia.CodigoEmpresa;
    CadProdutosC_COD_CLA.Value := codigo;
  end
  else
  begin
    CadProdutos.FindKey([StrToInt(codigo)]);
    DBEditColor3.Field.EditMask := RetornaPicture(varia.mascaraCLA,DBEditColor3.Text,'_');
    if funcao = 2  then    // editar
    begin
       CadProdutos.Edit;
       HabilitarKit(Tipo.ItemIndex = 1);
       Tributo.ItemIndex := CadProdutosI_TIP_TRI.AsInteger;
    end
    else       // caso outro numero consulta
    begin
      DataProdutos.AutoEdit := false;
      DataMovQdade.AutoEdit := false;
      AlterarEnabledDet([ EQdadePro, numerico2], false);
      numerico2.AValor := UnProdutos.PercMaxDesconto(CadProdutosI_SEQ_PRO.AsInteger, varia.TabelaPreco);
      Tributo.ItemIndex := CadProdutosI_TIP_TRI.AsInteger;
      Tributo.Enabled := false;
      numerico2.AValor := UnProdutos.PercMaxDesconto(CadProdutosI_SEQ_PRO.AsInteger, varia.TabelaPreco);
      numerico1.AValor := UnProdutos.RetornaValorProduto(CadProdutosI_SEQ_PRO.AsInteger);
      numerico2.ReadOnly := true;
      numerico1.ReadOnly := true;
    end;
  end;
  DBEditColor3Exit(DBEditColor3);
  ShowModal;
  codigo := CodigoPro.Text;
  desc := Descricao.Text;
  Path := CadProdutos.FieldByName('C_PAT_FOT').AsString;
  Kit := CadProdutos.FieldByName('C_KIT_PRO').AsString;
  sequencial := CadProdutos.FieldByName('I_SEQ_PRO').AsString;
  cifrao := CifraoMoeda;
  EntraNovoProduto:=Acao;
  UnProdutos.Free;
  UnCla.free;
  FechaTabela(CadUnidades);
  FechaTabela(CadProdutos);
  FechaTabela(MovQdade);
end;

{***********rotina para chamada de fora do form para carregar os dados**********
**************default de qualquer lugar, nao vem da tela produtos *************}
procedure TFNovoProduto.InsereNovoProduto( FecharAposOperacao : Boolean );
begin
  fecharFromulario := false;
  BotaoGravar1.Enabled := FecharAposOperacao;
  BotaoCancelar1.Enabled := FecharAposOperacao;
  if UnProdutos.VerificaMascaraClaPro then
  begin
    dbeditcolor3.Enabled := true;
    SpeedButton1.Enabled := true;
    CadProdutos.insert;
    showmodal;
  end
//  else
//    self.close;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                  Validacoes da gravacao dos produtos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{*************deixa os campos de unidades por caixa visível ou invisível*******}
procedure TFNovoProduto.EscondeCampQtdCaixa;
var
  Estado : Boolean;
Begin
  Estado := (CadProdutosC_COD_UNI.AsString = varia.UnidadeCX);

  label32.visible := Estado;
  DBEditColor2.Visible := Estado;
  DBEditColor2.ACampoObrigatorio := Estado;

  if not Estado Then
     if CadProdutos.State in [dsinsert,dsedit] Then
        DBEditColor2.text := '1';  // joga 1 para o campo qtd por causa do valida gravacao.
end;



{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                        acoes da tabela de Cadprodutos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{ ************************* depois de um cancela ************************** }
procedure TFNovoProduto.CadProdutosAfterCancel(DataSet: TDataSet);
begin
   acao := false;
   MovQdade.Cancel;
end;

{ ***************** depois de uma insercao *********************************** }
procedure TFNovoProduto.CadProdutosAfterInsert(DataSet: TDataSet);
begin
  DBFilialColor1.ProximoCodigo;
  CadProdutosI_COD_EMP.AsInteger := varia.CodigoEmpresa;
  CadProdutosC_KIT_PRO.Value := 'P';
  CadProdutosC_ATI_PRO.AsString := 'S';
  CadProdutosC_VEN_AVU.AsString := 'S';
  CadProdutosI_COD_MOE.AsInteger := Varia.MoedaBase;
  CadProdutosC_CIF_MOE.AsString := CurrencyString;
  CadProdutosD_DAT_CAD.AsDateTime := date;
  CadProdutosC_CLA_FIS.AsString := varia.ClassificacaoFiscal;
  CadProdutosC_TIP_CLA.AsString := 'P';
  CadProdutosC_PRO_COM.AsString := 'N';
  CadProdutosI_ORI_MER.AsInteger := 0;
  CodigoPro.ReadOnly := false;
  Tributo.Enabled := true;
  Tributo.ItemIndex := 0;
  DBEditLocaliza3.ReadOnly := false;
  DBLookupComboBoxColor1.ReadOnly := False;
  Tipo.Enabled := true;
  EstadoBotoes(False);
  Inseriu := true;
  AdicionaSQLAbreTabela(MovQdade, 'select * from MovQdadeProduto');
  InserirReg(MovQdade);
  MovQdadeI_EMP_FIL.AsInteger := Varia.CodigoEmpFil;
  MovQdadeI_SEQ_PRO.AsInteger := CadProdutosI_SEQ_PRO.AsInteger;
  MovQdadeN_QTD_MIN.AsFloat := 0;
  MovQdadeN_QTD_PED.AsFloat := 0;
  MovQdadeN_PER_COM.AsFloat := 0;
  MovQdadeN_VLR_COM.asfloat := 0;
end;

{ ***************** antes de insercao de um novo produto ******************* }
procedure TFNovoProduto.CadProdutosBeforeInsert(DataSet: TDataSet);
var
  laco : integer;
begin
  CodigoPro.Field.EditMask := '';
  if config.MascaraProdutoPadrao then  // ver
  begin
    for laco :=1 to length(varia.mascaraPro) do
       CodigoPro.Field.EditMask := CodigoPro.Field.EditMask + 'C';
   CodigoPro.Field.EditMask := CodigoPro.Field.EditMask + ';C;_';
  end;
end;

{ ****************** depois de um edit dos produtos ***********************  }
procedure TFNovoProduto.CadProdutosAfterEdit(DataSet: TDataSet);
begin
   AlterarEnabledDet([Tipo, DBEditColor2, codigopro, eqdadepro,  numerico2, DBEditNumerico4, numerico1], false);
   AlterarEnabledDet([label7,label14,label24,label22,label23, label1, label25, label32], false);
   DBLookupComboBoxColor1.ReadOnly := true;
   AtualizaLocalizas;
   EstadoBotoes(True);
   UnProdutos.LocalizaMovQdadeSequencial( MovQdade, CadProdutosI_SEQ_PRO.AsString, inttostr(varia.codigoempfil));
   EditarReg(MovQdade);
   EQdadePro.AValor := MovQdadeN_QTD_PRO.AsFloat;
   numerico2.AValor := UnProdutos.PercMaxDesconto(CadProdutosI_SEQ_PRO.AsInteger, varia.TabelaPreco);
   numerico1.AValor := UnProdutos.RetornaValorProduto(CadProdutosI_SEQ_PRO.AsInteger);
   Inseriu := false;
   if CadProdutosC_COD_UNI.AsString <> Varia.UnidadeCX then
   begin
     DBEditColor2.Visible := false;
     DBEditColor2.ACampoObrigatorio := false;
   end;
end;

{*******************Depois de gravar atualiza a tabela*************************}
procedure TFNovoProduto.CadProdutosAfterPost(DataSet: TDataSet);
begin
  EstadoBotoes(True);
  GravaReg(MovQdade);
  if Inseriu then
  begin
    UnProdutos.AdicionaProdutoNaTabelaPreco( CadProdutosI_SEQ_PRO.AsInteger, CadProdutosI_COD_MOE.AsInteger,
                                             varia.TabelaPreco, numerico1.AValor, numerico2.AValor, CadProdutosC_CIF_MOE.AsString );
    if ConfigModulos.Custo then
      UnProdutos.AdicionaProdutoNoMovCusto( CadProdutosI_SEQ_PRO.AsInteger );
    if EQdadePro.AValor <> 0 then // efetua baixa do produto
      UnProdutos.BaixaProdutoEstoque( CadProdutosI_SEQ_PRO.AsInteger, varia.OperacaoEstoqueInicial,
                                      0,0,CadProdutosI_COD_MOE.AsInteger, 0,date, EQdadePro.AValor, 0,
                                      CadProdutosC_COD_UNI.AsString, CadProdutosC_COD_UNI.AsString)
  end;
end;

{******************* Antes de gravar atualiza a tabela ************************}
procedure TFNovoProduto.CadProdutosBeforePost(DataSet: TDataSet);
var
   UnBarra : TCodigoBarra;
begin
  CadProdutosD_ULT_ALT.AsDateTime := DATE;
  if CadProdutos.State = dsinsert then
     DBFilialColor1.VerificaCodigoRede;
  if MovQdade.State in [ dsInsert ] then  // caso houve mudanca no seq pro durante a digitacvao en rede
    MovQdadeI_SEQ_PRO.AsInteger := CadProdutosI_SEQ_PRO.AsInteger;

  if MovQdadei_cod_bar.AsInteger <> 0 then
  begin
    UnBarra := TCodigoBarra.create;
    MovQdadeC_COD_BAR.AsString := UnBarra.GeraCodigoBarra(
                                  UnProdutos.MascaraBarra(MovQdadeI_COD_BAR.AsInteger),
                                  IntToStr(varia.CodigoEmpresa),
                                  IntToStr(varia.CodigoEmpFil), CadProdutosC_COD_CLA.AsString,
                                  CadProdutosC_COD_PRO.AsString,CadProdutosC_COD_REF.AsString,
                                  CadProdutosI_SEQ_PRO.AsString,CadProdutosC_BAR_FOR.AsString );
     UnBarra.destroy;
   end;
  end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                    Chamada dos componentes de cadastros
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{ *************** sai do campo de codigo do produto, valida duplicado ******* }
procedure TFNovoProduto.CodigoProExit(Sender: TObject);
begin
   if CadProdutos.State = dsinsert Then
     if not UnProdutos.ProdutoExistente(CodigoPro.Field.AsString, DBEditColor3.field.AsString) then
        CodigoPro.SetFocus;
end;

{*************** valida o compo de unidades ********************************** }
procedure TFNovoProduto.DBLookupComboBoxColor1Click(Sender: TObject);
begin
  if CadProdutos.State in [dsEdit, dsInsert ] then
  begin
     EscondeCampQtdCaixa;
     DBEditLocaliza1Change(nil);
  end;
end;

{***************valida se kit zera qdades e sempre vende avulso****************}
procedure TFNovoProduto.DBEditColor4Change(Sender: TObject);
begin
  if CadProdutos.State in [dsinsert,dsedit] Then
  begin
     HabilitarKit(Tipo.ItemIndex = 1);
     DBEditLocaliza1Change(nil);
  end;
end;

{***********************carrega foto do produto********************************}
procedure TFNovoProduto.BitBtn1Click(Sender: TObject);
begin
  if cadProdutos.State in [ dsInsert, dsedit] then
     if editorImagem1.execute(varia.DriveFoto + cadProdutosC_PAT_FOT.AsString) then
        cadProdutosC_PAT_FOT.Value := EditorImagem1.PathImagem;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Eventos dos localizas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{*************************Atualiza os localizas********************************}
procedure TFNovoProduto.AtualizaLocalizas;
begin
   DBEditLocaliza3.Atualiza;
end;

{*************** retorno do localiza moeda ********************************** }
procedure TFNovoProduto.DBEditLocaliza3Retorno(Retorno1, Retorno2: String);
begin
  if Retorno1 <> '' then
  begin
    CifraoMoeda := Retorno1;
    CadProdutosC_CIF_MOE.AsString := retorno1;
  end;
end;

{************* abre a localizacao das classificacao ************************* }
function TFNovoProduto.LocalizaClassificacao : Boolean;
var
  cla, NomeCla : string;
begin
  result := true;
  FLocalizaClassificacao := TFLocalizaClassificacao.CriarSDI(application,'', true);
  if FLocalizaClassificacao.LocalizaClassificacao(cla,NomeCla, 'P') then
  begin
    CadProdutosC_COD_CLA.AsString := cla;
    label11. Caption := nomecla;
  end
  else
    result := false;
end;

{*************** na saida do campo classificacao ***************************** }
procedure TFNovoProduto.DBEditColor3Exit(Sender: TObject);
var
 NomeCla : string;
begin
  if not BotaoCancelar1.Focused then
    if not UnCla.ValidaClassificacao(CadProdutosC_COD_CLA.AsString, NomeCla, 'P') then
    begin
       if not LocalizaClassificacao then
         DBEditColor3.SetFocus;
    end
    else
    begin
      label11. Caption := nomecla;
    end;
    if CadProdutos.State in [ dsEdit, dsInsert] then
      if CodigoPro.Text = '' then
        CadProdutosC_COD_PRO.AsString := UnProdutos.ProximoCodigoProduto(DBEditColor3.Field.AsString, length(varia.MascaraPro));
end;

{***************** botao que chama a localizacao das classificacoes ********** }
procedure TFNovoProduto.SpeedButton1Click(Sender: TObject);
begin
 LocalizaClassificacao;
end;

{*************** F3 localiza classificacao ********************************** }
procedure TFNovoProduto.DBEditColor3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = 114 then
 LocalizaClassificacao;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Eventos Diversos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{**************************Altera o estado dos Botões**************************}
procedure TFNovoProduto.EstadoBotoes(Estado : Boolean);
begin
  BKit.Enabled := (Estado) and (CadProdutosC_KIT_PRO.AsString = 'K');
end;

{*************************Habilita o kit ou não********************************}
procedure TFNovoProduto.HabilitarKit(Habilitar : Boolean);
begin
  if Habilitar then
  begin
     CadProdutosC_CLA_FIS.Clear;
     CadProdutosC_VEN_AVU.AsString := 'S';
     CadProdutosN_PER_KIT.CLEAR;
  end;

  DecVenderAvulso.Enabled := Not Habilitar;
  LblVenderAvulso.Enabled := Not Habilitar;
  DecDescontoKit.Enabled := not Habilitar;
  LblDescontoKit.Enabled := not Habilitar;
  DecClassificacaoFiscal.Enabled := not Habilitar;
  LblClassificacaoFiscal.Enabled := not Habilitar;
end;

{****************************Valida a gravacao*********************************}
procedure TFNovoProduto.DBEditLocaliza1Change(Sender: TObject);
begin
if CadProdutos.State in [ dsInsert, dsEdit ] then
   ValidaGravacao1.execute;
if BotaoGravar1.Enabled then
  if GroupBox5.Visible then
    BotaoGravar1.Enabled := DBEditLocaliza2.Text <> '';
end;


{**************************Chama a tela de Kit*********************************}
procedure TFNovoProduto.BKitClick(Sender: TObject);
begin
  FMontaKit := TFMontaKit.CriarSDI(application, '', true);
  FMontaKit.CarregaTela(CadProdutosI_SEQ_PRO.AsInteger);
end;


{*********************Limpa o campo de redução de ICms*************************}
procedure TFNovoProduto.BotaoFechar1Click(Sender: TObject);
begin
  Self.close;
end;

procedure TFNovoProduto.BotaoGravar1DepoisAtividade(Sender: TObject);
begin
  if Inseriu then
    if Config.AdicionarNovoProFilial then
      UnProdutos.InsereProdutoEmpresa( CadProdutos.fieldByName('i_seq_pro').AsInteger,
                                       MovQdade.fieldByName('i_cod_bar').AsInteger,
                                       MovQdade.fieldByName('n_qtd_min').AsFloat,
                                       MovQdade.fieldByName('n_qtd_ped').AsFloat,
                                       MovQdade.fieldByName('n_per_com').AsFloat,
                                       CadProdutos.fieldByName('c_cod_cla').AsString,
                                       CadProdutos.fieldByName('c_cod_pro').AsString,
                                       CadProdutos.fieldByName('c_cod_ref').AsString,
                                       CadProdutos.fieldByName('c_bar_for').AsString );
  if CadProdutosC_KIT_PRO.AsString = 'P' then
    if BotaoCadastrar1.Enabled and BotaoCadastrar1.Visible then
       BotaoCadastrar1.SetFocus;
end;

{******************* antes de gravar o registro *******************************}
procedure TFNovoProduto.MovQdadeBeforePost(DataSet: TDataSet);
begin
  //atualiza a data de alteracao para poder exportar
  MovQdadeD_ULT_ALT.AsDateTime := Date;
end;

procedure TFNovoProduto.BBAjudaClick(Sender: TObject);
begin
     Application.HelpCommand(HELP_CONTEXT,FNovoProduto.HelpContext);
end;

procedure TFNovoProduto.CodigoProKeyPress(Sender: TObject; var Key: Char);
begin
  if not config.PermitirAlfaNumericoCodPro then
    if not (key in [#48..#57,#8,#46]) then
       key := #;
end;

procedure TFNovoProduto.EMultiplicadorExit(Sender: TObject);
begin
 if CadProdutos.State in [ dsEdit, dsInsert ] then
   numerico1.AValor := CadProdutosN_IND_MUL.AsCurrency * MovQdadeN_VLR_COM.AsCurrency;
end;

procedure TFNovoProduto.BotaoCadastrar1DepoisAtividade(Sender: TObject);
begin
  dbeditcolor3.Enabled := true;
  SpeedButton1.Enabled := true;
  CadProdutosC_COD_PRO.AsString := UnProdutos.ProximoCodigoProduto(DBEditColor3.Field.AsString, length(varia.MascaraPro));
  DBEditColor3.SetFocus;
end;

procedure TFNovoProduto.BotaoCancelar1AntesAtividade(Sender: TObject);
begin
  if (not Config.PermitirAlfaNumericoCodPro) and (config.codigoUnicoProduto) then
    VoltaCodigo('i_cod_pro','i_emp_fil', varia.CodigoEmpresa, CadProdutosc_cod_pro.AsInteger, FPrincipal.BaseDados);
end;

procedure TFNovoProduto.TributoChange(Sender: TObject);
begin
  if CadProdutos.State in [dsInsert, dsEdit] then
    CadProdutosI_TIP_TRI.AsInteger := Tributo.ItemIndex;
  Label19.Enabled := tributo.ItemIndex = 2;
  DBEditNumerico3.Enabled := tributo.ItemIndex = 2;
  label28.Enabled := tributo.ItemIndex = 2;
  EditLocaliza1.Enabled := tributo.ItemIndex = 2;
  ConsultaReducao.Enabled := tributo.ItemIndex = 2;
  label29.Enabled := tributo.ItemIndex = 2;
end;

procedure TFNovoProduto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if  key = vk_f4 then
  begin
    if Paginas.ActivePage = TabSheet1 then
    begin
      Paginas.ActivePage := TabSheet2;
      TabSheet2.SetFocus;
      MudaPagina;
    end
    else
    begin
      Paginas.ActivePage := TabSheet1;
      descricao.SetFocus;
    end;
   end;

  if ( key = vk_f6 ) and BotaoGravar1.Enabled then
  begin
    CadProdutos.Post;
    BotaoGravar1DepoisAtividade(nil);
  end;

  if ( key = vk_f5 ) and BImprime1.Enabled then
   BImprime1.Click;

  if ( key = vk_f7 ) and BotaoFechar1.Enabled then
   self.close;

end;

procedure TFNovoProduto.BotaoCadastrar1AntesAtividade(Sender: TObject);
begin
  Paginas.ActivePage := TabSheet1;
end;

procedure TFNovoProduto.BImprime1Click(Sender: TObject);
begin
  if config.ImprimeTag then
  begin
    fImprimeTag := TfImprimeTag.CriarSDI(application,'', FPrincipal.VerificaPermisao('fImprimeTag'));
    fImprimeTag.CarregaDados(MovQdadeC_COD_BAR.AsString, trunc(EQdadePro.AValor));
  end
  else
  begin
    FImprimeCodigoBarra := TFImprimeCodigoBarra.CriarSDI(application,'', FPrincipal.VerificaPermisao('FImprimeCodigoBarra'));
    FImprimeCodigoBarra.CarregaDados(MovQdadeC_COD_BAR.AsString, trunc(EQdadePro.AValor));
  end;
end;

procedure TFNovoProduto.DBEditLocaliza2Retorno(Retorno1, Retorno2: String);
begin
if CadProdutos.State in [ dsInsert, dsEdit ] then
   DBEditLocaliza1Change(nil);
end;

procedure TFNovoProduto.MudaPagina;
begin
   Paginas.ActivePage := TabSheet2;
   if DecDescontoKit.Enabled then
     DecDescontoKit.SetFocus
   else
     DBEditColor6.SetFocus;
end;


procedure TFNovoProduto.DBEditLocaliza2Exit(Sender: TObject);
begin
  MudaPagina;
end;

procedure TFNovoProduto.EditLocaliza1Exit(Sender: TObject);
begin
   if not GroupBox5.Visible then
     mudapagina;
end;

procedure TFNovoProduto.DecClassificacaoFiscalExit(Sender: TObject);
begin
   if (not GroupBox5.Visible) and (not DBEditNumerico3.Enabled) then
     mudapagina;
end;

Initialization
{ *************** Registra a classe para evitar duplicidade ****************** }
 RegisterClasses([TFNovoProduto]);
end.



