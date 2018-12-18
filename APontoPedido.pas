unit APontoPedido;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Grids, DBGrids, Tabela, BotaoCadastro, StdCtrls, Buttons, Componentes1,
  ExtCtrls, PainelGradiente, Localizacao, Db, DBTables, ComCtrls,
  DBKeyViolation;

type
  TFPontoPedido = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    BFechar: TBitBtn;
    Localiza: TConsultaPadrao;
    PanelColor3: TPanelColor;
    Grade: TGridIndice;
    Produtos: TQuery;
    DataProdutos: TDataSource;
    RPontoPedido: TRadioButton;
    RQdadeMinima: TRadioButton;
    ProdutosN_QTD_PRO: TFloatField;
    ProdutosN_QTD_MIN: TFloatField;
    ProdutosN_QTD_PED: TFloatField;
    ProdutosC_NOM_PRO: TStringField;
    ProdutosC_COD_UNI: TStringField;
    CAtividade: TCheckBox;
    CNulo: TCheckBox;
    Label8: TLabel;
    EClassificacao: TEditLocaliza;
    SpeedButton1: TSpeedButton;
    Label4: TLabel;
    BitBtn1: TBitBtn;
    ProdutosI_SEQ_PRO: TIntegerField;
    ProdutosC_COD_BAR: TStringField;
    ProdutosC_COD_PRO: TStringField;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure EClassificacaoSelect(Sender: TObject);
    procedure GradeOrdem(Ordem: String);
    procedure CAtividadeClick(Sender: TObject);
    procedure EClassificacaoRetorno(Retorno1, Retorno2: String);
    procedure BitBtn1Click(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    OrderBy : string;
    procedure PosicionaProduto;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FPontoPedido: TFPontoPedido;

implementation

uses APrincipal, Constantes, FunSql, ConstMsg, ANovoCliente, fundata,
  AProdutosFornecedores, funSistema;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFPontoPedido.FormCreate(Sender: TObject);
begin
  Grade.Columns[0].FieldName := varia.CodigoProduto;
  PosicionaProduto;
  OrderBy := ' order by pro.c_nom_pro ';
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFPontoPedido.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações do Localiza
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{*************Carrega a Select para localizar e Validar o produto**************}
procedure TFPontoPedido.EClassificacaoSelect(Sender: TObject);
begin
   EClassificacao.ASelectValida.clear;
   EClassificacao.ASelectValida.add( 'Select * from dba.CadClassificacao'+
                                    ' where I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                                    ' and c_Cod_Cla = ''@''' +
                                    ' and c_tip_cla = ''P''' +
                                    ' and c_Con_cla = ''S'' ' );
   EClassificacao.ASelectLocaliza.Clear;
   EClassificacao.ASelectLocaliza.add( 'Select * from dba.cadClassificacao'+
                                      ' where I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                                      ' and c_nom_Cla like ''@%'' ' +
                                      ' and c_tip_cla = ''P''' +
                                      ' and c_Con_cla = ''S'' ' +
                                      ' order by c_cod_Cla asc');
end;



{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Acoes do Fornecedor
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{******************Posicona o fornecedor conforme o produto********************}
procedure TFPontoPedido.PosicionaProduto;
var
  VpaTipo, VpaAtividade, VpaClassificacao : string;
begin
   if RPontoPedido.Checked then  // caso ponto de pedido ou qdade minima
     if CNulo.Checked then
       VpaTipo := ' isnull(mov.n_qtd_pro,0) <= isnull(mov.n_qtd_ped,0) '
     else
       VpaTipo := ' mov.n_qtd_pro <= n_qtd_ped '
   else
     if CNulo.Checked then    // caso valores nulo ou naum
       VpaTipo := ' isnull(mov.n_qtd_pro,0) <= isnull(mov.n_qtd_min,0) '
     else
       VpaTipo := ' mov.n_qtd_pro <= mov.n_qtd_min ';

   if CAtividade.Checked then   // caso produto em atividade ou naum
     VpaAtividade :=  ' and pro.c_ati_pro = ''S'''
   else
     VpaAtividade := '';

   if EClassificacao.Text <> '' then  // filtrar com classificao ou naum
     VpaClassificacao := ' and pro.c_cod_cla like ''' + EClassificacao.Text + '%'''
   else
     VpaClassificacao := '';

  // monta select ...............
  LimpaSQLTabela(Produtos);
  AdicionaSQLTabela(Produtos, ' select ' +
                              ' isnull(mov.n_qtd_pro,0) n_qtd_pro, ' +
                              ' isnull(mov.n_qtd_min,0) n_qtd_min, ' +
                              ' isnull(mov.n_qtd_ped,0) n_qtd_ped, ' +
                              ' pro.c_nom_pro, pro.c_cod_uni, ' +
                              ' mov.i_seq_pro, mov.c_cod_bar, pro.c_cod_pro ' +
                              ' from MovQdadeProduto as mov, cadProdutos as pro ' +
                              ' where ' + VpaTipo + VpaClassificacao +  VpaAtividade +
                              ' and mov.i_seq_pro = pro.i_seq_pro ' +
                              ' and  mov.i_emp_fil = ' + IntTostr(varia.CodigoEmpFil) );
  AdicionaSQLTabela(Produtos,  OrderBy);
  AbreTabela(Produtos);
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************************Fecha o Formulario corrente***********************}
procedure TFPontoPedido.BFecharClick(Sender: TObject);
begin
   Close;
end;

procedure TFPontoPedido.GradeOrdem(Ordem: String);
begin
OrderBy := Ordem;
end;

procedure TFPontoPedido.CAtividadeClick(Sender: TObject);
begin
  PosicionaProduto;
end;

procedure TFPontoPedido.EClassificacaoRetorno(Retorno1, Retorno2: String);
begin
 PosicionaProduto;
end;

procedure TFPontoPedido.BitBtn1Click(Sender: TObject);
begin
  if Produtos.fieldByName('i_seq_pro').AsString <> '' then
  begin
    if not VerificaFormCriado( 'TFProdutosFornecedores') then
      FProdutosFornecedores := TFProdutosFornecedores.criarMDI(application, varia.CT_AreaX, varia.CT_AreaY, FPrincipal.VerificaPermisao('FProdutosFornecedores'));
    FProdutosFornecedores.CarregaProduto(Produtos.fieldByName('i_seq_pro').AsString);
    FProdutosFornecedores.BringToFront;
  end;
end;

procedure TFPontoPedido.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FPontoPedido.HelpContext);
end;

procedure TFPontoPedido.FormShow(Sender: TObject);
begin
  Self.HelpFile := Varia.PathHelp + 'MEstoqueCusto.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
end;

Initialization
{ *************** Registra a classe para evitar duplicidade ****************** }
 RegisterClasses([TFPontoPedido]);
end.
