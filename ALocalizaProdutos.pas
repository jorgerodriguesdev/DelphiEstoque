unit ALocalizaProdutos;
{          Autor: Rafael Budag
    Data Criação: 16/04/1999;
          Função: Gerar um orçamento

    Motivo alteração:
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Localizacao, StdCtrls, Buttons, Componentes1, Db, DBTables, ExtCtrls,
  PainelGradiente, Grids, DBGrids, Tabela, DBKeyViolation, DBCtrls, Mask,
  numericos, LabelCorMove, CheckLst, Parcela, BotaoCadastro, Psock, NMpop3,
  EditorImagem, ConvUnidade;

type
  TFlocalizaProduto = class(TFormularioPermissao)
    CadProdutos: TQuery;
    Localiza: TConsultaPadrao;
    DataCadProdutos: TDataSource;
    PanelColor2: TPanelColor;
    PanelColor5: TPanelColor;
    Label3: TLabel;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    EClassificacaoProduto: TEditLocaliza;
    CProAti: TCheckBox;
    PanelColor16: TPanelColor;
    ENomeProduto: TEditColor;
    CadProdutosC_COD_PRO: TStringField;
    CadProdutosC_COD_UNI: TStringField;
    CadProdutosC_NOM_PRO: TStringField;
    CadProdutosC_ATI_PRO: TStringField;
    CadProdutosC_KIT_PRO: TStringField;
    CadProdutosL_DES_TEC: TMemoField;
    CadProdutosN_PER_KIT: TFloatField;
    CadProdutosN_QTD_MIN: TFloatField;
    CadProdutosN_QTD_PRO: TFloatField;
    CadProdutosN_VLR_VEN: TFloatField;
    GProdutos: TGridIndice;
    CadProdutosC_Nom_Moe: TStringField;
    CadProdutosI_SEQ_PRO: TIntegerField;
    DBMemoColor1: TDBMemoColor;
    BKit: TSpeedButton;
    PainelGradiente1: TPainelGradiente;
    CadProdutosN_QTD_RES: TFloatField;
    CadProdutosQdadeReal: TFloatField;
    BFechar: TBitBtn;
    BitBtn1: TBitBtn;
    BotaoCadastrar1: TBitBtn;
    CadProdutosN_QTD_PED: TFloatField;
    CadProdutosC_Cod_Bar: TStringField;
    BBAjuda: TBitBtn;
    CodPro: TEditColor;
    Label4: TLabel;
    Label18: TLabel;
    EClientes: TEditLocaliza;
    SpeedButton6: TSpeedButton;
    Label20: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CProAtiClick(Sender: TObject);
    procedure BKitClick(Sender: TObject);
    procedure EClassificacaoProdutoSelect(Sender: TObject);
    procedure EClassificacaoProdutoRetorno(Retorno1, Retorno2: String);
    procedure ENomeProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BFecharClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure CadProdutosAfterScroll(DataSet: TDataSet);
    procedure BotaoCadastrar1Click(Sender: TObject);
    procedure EClassificacaoProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ENomeProdutoEnter(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
    procedure EClientesRetorno(Retorno1, Retorno2: String);
  private
    { Private declarations }
    Cadastrou, VoltarTabelaPreco : Boolean;
    acao : boolean;
    procedure AtualizaConsulta;
    procedure AdicionaFiltrosProduto(VpaSelect : TStrings);
  public
    function LocalizaProduto( var Cadastrou : Boolean; var seqPRoduto : integer; var codProduro : string; Var EstoqueAtual : Double; CodCliente : Integer  ) : boolean; overload;
    function LocalizaProduto( Var Cadastrou : Boolean; var seqPRoduto : integer; var codProduro, VpaNomProduto : string; CodCliente : Integer ) : boolean; overload;
    function LocalizaProduto( Var Cadastrou : Boolean; var seqPRoduto : integer; var codProduro, CodUnidade : string; Var ValorVenda, QtdEstoque, QtdPedido, QtdMinima  : Double; CodCliente : Integer) : boolean; overload;
  end;

var
  FlocalizaProduto: TFlocalizaProduto;

implementation

uses APrincipal, Constantes,ConstMsg, AProdutosKit, ANovoProduto;
{$R *.DFM}


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                               eventos do filtro superior
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************** carrega a select do localiza classificacao ****************}
procedure TFlocalizaProduto.EClassificacaoProdutoSelect(Sender: TObject);
begin
  EClassificacaoProduto.ASelectLocaliza.text := 'Select * from CadClassificacao '+
                                                ' where c_nom_Cla like ''@%'''+
                                                ' and I_cod_emp = ' + InttoStr(Varia.CodigoEmpresa)+
                                                ' and C_Con_Cla  = ''S'''+
                                                ' and C_Tip_Cla = ''P''';
  EClassificacaoProduto.ASelectValida.text := 'Select * from CadClassificacao '+
                                                ' where C_Cod_Cla = ''@'''+
                                                ' and I_cod_emp = ' + InttoStr(Varia.CodigoEmpresa)+
                                                ' and C_Con_Cla = ''S'''+
                                                ' and C_Tip_Cla = ''P''';
end;

{**************** chama a rotina para atualizar a consulta ********************}
procedure TFlocalizaProduto.EClassificacaoProdutoRetorno(Retorno1,
  Retorno2: String);
begin
  if self.visible then // quana tualizar com a cla padrao nao dar erro
    AtualizaConsulta;
end;

{*************Chama a Rotina para atualizar a select dos produtos**************}
procedure TFlocalizaProduto.CProAtiClick(Sender: TObject);
begin
  AtualizaConsulta;
  BFechar.Default := true;
end;

{************ se for pressionado enter atualiza a consulta ********************}
procedure TFlocalizaProduto.ENomeProdutoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case key of
    13 : AtualizaConsulta;
  end;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                         ações da consulta do produto
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************** atualiza a consulta dos produtos **************************}
procedure TFlocalizaProduto.AtualizaConsulta;
begin
  CadProdutos.sql.clear;
  CadProdutos.sql.add('Select C_Cod_Pro, '+
                     ' Pro.I_SEQ_PRO,  Pro.C_COD_UNI,  Pro.C_NOM_PRO, ' +
                     ' Pro.C_ATI_PRO, Pro.C_KIT_PRO, Pro.L_DES_TEC, ' +
                     ' Pro.N_PER_KIT, Qtd.C_Cod_Bar, ' +
                     ' Qtd.N_QTD_MIN, QTD.N_QTD_PRO, QTD.N_QTD_PED, ' +
                     ' (PRE.N_VLR_VEN * MOE.N_Vlr_Dia) N_VLR_VEN, QTD.N_QTD_RES, ' +
                     ' Moe.C_Nom_Moe, (QTD.N_QTD_PRO - QTD.N_QTD_RES) QdadeReal ' +
                     ' from dba.CadProdutos pro, MovQdadeProduto Qtd, MovTabelaPreco Pre, ' +
                     ' CadMoedas Moe');
  AdicionaFiltrosProduto(Cadprodutos.Sql);
  CadProdutos.sql.add(' and Pre.I_Cod_Tab = ' + IntToStr(Varia.TabelaPreco) +
                      ' and Qtd.I_Seq_Pro = Pro.I_Seq_Pro '+
                      ' and Pre.I_Cod_Emp = Pro.I_Cod_Emp '+
                      ' and Pre.I_Seq_Pro = Pro.I_Seq_Pro '+
                      ' and Moe.I_Cod_Moe = Pre.I_Cod_Moe');
  CadProdutos.Open;
end;

{******************* adiciona os filtros da consulta **************************}
procedure TFlocalizaProduto.AdicionaFiltrosProduto(VpaSelect : TStrings);
begin
  VpaSelect.add('Where Qtd.I_Emp_Fil = ' + inttostr(Varia.CodigoEmpFil));

  if ENomeProduto.text <> '' Then
    VpaSelect.Add('and Pro.C_Nom_Pro like '''+ENomeProduto.text +'%''');
  if EClassificacaoProduto.text <> ''Then
    VpaSelect.add(' and Pro.C_Cod_Cla like '''+ EClassificacaoProduto.text+ '%''');
  if CProAti.Checked then
    VpaSelect.add(' and Pro.C_Ati_Pro = ''S''');

  if CodPro.Text <> '' then
    VpaSelect.add(' and ' + Varia.CodigoProduto  + '= ''' + CodPro.text+ '''');

  VpaSelect.add(' and Pro.c_ven_avu = ''S''');

end;


{ ******************* chama o formulario para visualizar kit **************** }
procedure TFlocalizaProduto.BKitClick(Sender: TObject);
begin
   FProdutosKit := TFProdutosKit.CriarSDI(Application,'',FPrincipal.VerificaPermisao('FProdutosKit'));
   FProdutosKit.MostraKit(CadProdutosI_Seq_Pro.Asstring,Varia.CodigoEmpFil);
end;



{ ****************** Na criação do Formulário ******************************** }
procedure TFlocalizaProduto.FormCreate(Sender: TObject);
begin
  GProdutos.Columns[0].FieldName := varia.CodigoProduto;
  Self.HelpFile := Varia.PathHelp + 'MPONTOLOJA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
  CadProdutosN_VLR_VEN.EditFormat := Varia.MascaraValor;
  CadProdutosN_VLR_VEN.DisplayFormat := Varia.MascaraValor;
  Cadastrou := false;
  VoltarTabelaPreco := false;
  if varia.ClassificacaoPadraoVenda <> '' then
  begin
    EClassificacaoProdutoSelect(nil);
    EClassificacaoProduto.Text := varia.ClassificacaoPadraoVenda;
    EClassificacaoProduto.Atualiza;
  end;
  GProdutos.Columns[7].Visible := config.MostrarReservado;
end;


{ ******************* Quando o formulario e fechado ************************** }
procedure TFlocalizaProduto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if   VoltarTabelaPreco then // neste caso chamado pelo menu, sem cliente
    varia.TabelaPreco := varia.TabelaPrecoPadrao;
   Action := CaFree;
end;

{ ********************** chamada externa da localizacao de produtos ********** }
function TFlocalizaProduto.LocalizaProduto( var Cadastrou : Boolean; var seqPRoduto : integer; var codProduro : string; Var EstoqueAtual : Double; CodCliente : Integer ) : boolean;
begin
  BotaoCadastrar1.Visible := Cadastrou;
  if CodCliente <> 0 then
    EClientes.Text := IntToStr(CodCliente)
  else
    VoltarTabelaPreco := true; // neste caso chamado pelo menu, sem cliente

  EClientes.Atualiza;
  self.ShowModal;
  result := acao;
  Cadastrou := Self.Cadastrou;

  if CadProdutos.IsEmpty then
    result := false;

  if acao then
  begin
    seqPRoduto := CadProdutosI_SEQ_PRO.AsInteger;
    codProduro := CadProdutos.fieldbyname(varia.CodigoProduto).AsString;
    EstoqueAtual := CadProdutosQdadeReal.AsFloat;
  end
  else
  begin
    seqPRoduto := 0;
    codProduro := '';
  end;
end;

{************************** localiza o produto ********************************}
function TFlocalizaProduto.LocalizaProduto( var cadastrou : Boolean; var seqPRoduto : integer; var codProduro, VpaNomProduto : string; CodCliente : Integer ) : boolean;
begin
  BotaoCadastrar1.Visible  := Cadastrou;
  if CodCliente <> 0 then
    EClientes.Text := IntToStr(CodCliente)
  else
    VoltarTabelaPreco := true; // neste caso chamado pelo menu, sem cliente

  EClientes.Atualiza;
  self.ShowModal;
  result := acao;
  Cadastrou := Self.Cadastrou;

  if CadProdutos.IsEmpty then
    result := false;

  if acao then
  begin
    seqPRoduto := CadProdutosI_SEQ_PRO.AsInteger;
    codProduro := CadProdutos.fieldbyname(varia.CodigoProduto).AsString;
    VpaNomProduto := CadProdutosC_NOM_PRO.AsString;
  end
  else
  begin
    seqPRoduto := 0;
    codProduro := '';
    VpaNomProduto := '';
  end;
end;

{************************** localiza o produto ********************************}
function TFlocalizaProduto.LocalizaProduto( var Cadastrou : Boolean; var seqPRoduto : integer; var codProduro, CodUnidade : string; Var ValorVenda, QtdEstoque, QtdPedido, QtdMinima : Double; CodCliente : Integer) : boolean;
begin
  if CodCliente <> 0 then
    EClientes.Text := IntToStr(CodCliente)
  else
    VoltarTabelaPreco := true; // neste caso chamado pelo menu, sem cliente

  EClientes.Atualiza;

  self.ShowModal;
  result := acao;

  if CadProdutos.IsEmpty then  // se a tabela estiver vazia, entao nao encontrou
    result := false;

  if acao then  // se achou carrega os dados das variaveis do parametro
  begin
    seqPRoduto := CadProdutosI_SEQ_PRO.AsInteger;
    codProduro := CadProdutos.fieldbyname(varia.CodigoProduto).AsString;
    CodUnidade := CadProdutosC_COD_UNI.AsString;
    ValorVenda := CadProdutosN_VLR_VEN.AsFloat;
    QtdEstoque := CadProdutosQdadeReal.AsFloat;
    QtdMinima  := CadProdutosN_QTD_MIN.AsFloat;
    QtdPedido  := CadProdutosN_QTD_PED.AsFloat;
  end
  else
  begin
    seqPRoduto := 0;
    codProduro := '';
  end;
end;


procedure TFlocalizaProduto.BFecharClick(Sender: TObject);
begin
  acao := true;
  self.close;
end;

procedure TFlocalizaProduto.BitBtn1Click(Sender: TObject);
begin
  acao := false;
  self.close;
end;

procedure TFlocalizaProduto.CadProdutosAfterScroll(DataSet: TDataSet);
begin
  if CadProdutosC_KIT_PRO.AsString = 'K' then
    bkit.Enabled := true
  else
    bkit.Enabled := false;
end;

procedure TFlocalizaProduto.BotaoCadastrar1Click(Sender: TObject);
begin
  FNovoProduto := TFNovoProduto.CriarSDI(application, '', true);
  FNovoProduto.InsereNovoProduto(true);
  AtualizaConsulta;
  Cadastrou := true;
end;

procedure TFlocalizaProduto.EClassificacaoProdutoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case key of
    40 :
      begin
        GProdutos.setfocus;
        CadProdutos.next;
      end;
    Vk_Up :
      begin
        GProdutos.setfocus;
        CadProdutos.Prior;
      end;
  end;
  if Key = 13 then
     AtualizaConsulta;
end;

procedure TFlocalizaProduto.ENomeProdutoEnter(Sender: TObject);
begin
BFechar.Default := false;
end;

procedure TFlocalizaProduto.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FlocalizaProduto.HelpContext);
end;

{*************** atualiza a tabela de preco dos produtos ******************** }
procedure TFlocalizaProduto.EClientesRetorno(Retorno1,
  Retorno2: String);
begin
  if Retorno1 <> '' then
    CodigoTabelaPreco(StrtoInt(retorno1), FPrincipal.BaseDados)
  else
   CodigoTabelaPreco(0, FPrincipal.BaseDados);
  AtualizaConsulta;
end;

Initialization
{ *************** Registra a classe para evitar duplicidade ****************** }
 RegisterClasses([TFlocalizaProduto]);
end.
