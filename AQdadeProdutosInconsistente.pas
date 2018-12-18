unit AQdadeProdutosInconsistente;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Buttons, Componentes1, ExtCtrls, PainelGradiente, Db, Grids,
  DBGrids, Tabela, DBTables, UnSumarizaEstoque, Mask, DBCtrls, Localizacao;

type
  TFQdadeProdutosInconsistente = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    BFechar: TBitBtn;
    Produtos: TQuery;
    DataProdutos: TDataSource;
    DBGridColor1: TDBGridColor;
    ProdutossumaQdade: TFloatField;
    ProdutosMovQdade: TFloatField;
    Produtosc_nom_pro: TStringField;
    Localiza: TConsultaPadrao;
    GroupBox1: TGroupBox;
    Label12: TLabel;
    Label1: TLabel;
    EOpeSaida: TEditLocaliza;
    EOpeEntrada: TEditLocaliza;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label13: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    RAlterar: TRadioGroup;
    Produtosi_seq_pro: TIntegerField;
    BitBtn2: TBitBtn;
    Label3: TLabel;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    UnSum : UnSumarizaEstoque.TFuncoesSumarizaEstoque;
  public
    { Public declarations }
  end;

var
  FQdadeProdutosInconsistente: TFQdadeProdutosInconsistente;

implementation

uses APrincipal, funsql, constmsg, Constantes;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFQdadeProdutosInconsistente.FormCreate(Sender: TObject);
begin
  UnSum := UnSumarizaEstoque.TFuncoesSumarizaEstoque.criar(self,FPrincipal.BaseDados);
  UnSum.LocalizaQdadeInconsistentes(Produtos,0)
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFQdadeProdutosInconsistente.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UnSum.Free;
  Action := CaFree;
end;

{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFQdadeProdutosInconsistente.BFecharClick(Sender: TObject);
begin
 self.close;
end;

procedure TFQdadeProdutosInconsistente.BitBtn1Click(Sender: TObject);
begin
  if (EOpeEntrada.text <> '' ) and (EOpeSaida.text <> '') then
  begin
    if RAlterar.ItemIndex = 0 then
      UnSum.AcertoFechamento( StrToInt(EOpeSaida.text), StrToInt(EOpeEntrada.text),0)
    else
      UnSum.AcertoFechamento(StrToInt(EOpeSaida.text), StrToInt(EOpeEntrada.text),  Produtosi_seq_pro.AsInteger);
  end
  else
    Aviso(Ct_faltaOpeEstoque);
end;

procedure TFQdadeProdutosInconsistente.BitBtn2Click(Sender: TObject);
begin
  if RAlterar.ItemIndex = 0 then
    UnSum.AcertoEstoqueAtual(0)
  else
    UnSum.AcertoEstoqueAtual(Produtosi_seq_pro.AsInteger);
  AtualizaSQLTabela(Produtos);
end;

procedure TFQdadeProdutosInconsistente.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FQdadeProdutosInconsistente.HelpContext);
end;

procedure TFQdadeProdutosInconsistente.FormShow(Sender: TObject);
begin
   Self.HelpFile := Varia.PathHelp + 'MEstoqueCusto.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
end;

Initialization
 RegisterClasses([TFQdadeProdutosInconsistente]);
end.
