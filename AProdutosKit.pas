unit AProdutosKit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, LabelCorMove, ExtCtrls, Componentes1, Localizacao, Buttons, Db,
  DBTables, Grids, DBGrids, Tabela, Mask, numericos;

type
  TFProdutosKit = class(TFormularioPermissao)
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    PanelColor3: TPanelColor;
    Label3D1: TLabel3D;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    Label2: TLabel;
    Kit: TEditLocaliza;
    Localiza: TConsultaPadrao;
    DBGridColor1: TDBGridColor;
    MovKit: TQuery;
    DataMovKit: TDataSource;
    BFechar: TBitBtn;
    QtdKit: Tnumerico;
    Aux: TQuery;
    Label3: TLabel;
    MovKitCodigo: TStringField;
    MovKitC_Nom_Pro: TStringField;
    MovKitC_cod_Uni: TStringField;
    MovKitN_qtd_Pro: TFloatField;
    MovKitQtdKit: TFloatField;
    MovKitValorVenda: TStringField;
    Label4: TLabel;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure KitSelect(Sender: TObject);
    procedure BFecharClick(Sender: TObject);
    procedure KitRetorno(Retorno1, Retorno2: String);
    procedure BBAjudaClick(Sender: TObject);
  private
    FilialAtual : Integer;
    procedure PosicionaMovKit(codigo : String; CodigoEmpFil : Integer);
    function RetornaQtdKit : Double;
  public
    procedure MostraKit(CodigoKit : String; CodigoEmpFil : Integer);
  end;

var
  FProdutosKit: TFProdutosKit;

implementation

uses APrincipal,Constantes;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFProdutosKit.FormCreate(Sender: TObject);
begin
   KitSelect(self);
   Self.HelpFile := Varia.PathHelp + 'MPONTOLOJA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFProdutosKit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   MovKit.close;
   Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações dos localizas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{**********************Carrega a selectdo Localiza*****************************}
procedure TFProdutosKit.KitSelect(Sender: TObject);
begin
   kit.ASelectValida.Text := ' Select * from CadProdutos as pro, MovQdadeProduto as mov ' +
                             ' Where C_Kit_Pro = ''K'' ' +
                             ' and ' + varia.CodigoProduto + ' = ''@''' +
                             ' and pro.i_seq_pro = mov.i_seq_pro ';
   kit.ASelectLocaliza.Text := ' Select * from CadProdutos as pro, MovQdadeProduto as mov ' +
                               ' Where  C_Kit_Pro = ''K'' ' +
                               ' and c_nom_pro like ''@%'' ' +
                               ' and pro.i_seq_pro = mov.i_seq_pro ';
  if FilialAtual > 10 then
  begin
    kit.ASelectValida.Text := kit.ASelectValida.Text + ' and mov.i_emp_fil = ' +  IntToStr(FilialAtual);
    kit.ASelectLocaliza.Text := kit.ASelectLocaliza.Text + ' and mov.i_emp_fil = ' +  IntToStr(FilialAtual);
  end;

  kit.ASelectLocaliza.Text := kit.ASelectLocaliza.Text +   ' order by c_nom_pro ';

end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações do movkit
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***************Posiciona o mov kit de acordo com o codigo do kit**************}
procedure TFProdutosKit.PosicionaMovKit(codigo : String; CodigoEmpFil : Integer);
begin
   FilialAtual := CodigoEmpFil;
   MovKit.close;
   movkit.sql.clear;
   movkit.sql.add(' Select ' + varia.CodigoProduto + ' Codigo ' +
                  ', pro.C_Nom_Pro, pro.C_cod_Uni, mov.N_qtd_Pro, kit.n_qtd_pro QtdKit, ' +
                  ' tab.c_cif_moe + '' '' + cast(Tab.N_VLR_VEN as char) as ValorVenda '+
                  ' from MovKit as kit, CadProdutos as Pro, ' +
                  ' MovQdadeProduto as mov, MovTabelaPreco Tab ' +
                  ' Where  Kit.I_pro_kit = ' + codigo +
                  ' and kit.i_seq_pro = Pro.i_seq_pro ' +
                  ' and Mov.I_seq_pro =* pro.I_seq_pro ' );

   if CodigoEmpFil > 10 then
      movkit.sql.add(' and Mov.I_emp_fil = ' + IntToStr(codigoEmpFil));

     movkit.sql.add(' and pro.i_seq_pro = tab.i_seq_pro ' +
                    ' and tab.i_cod_tab = ' + IntToStr(varia.TabelaPreco) );
   movkit.open;
   QtdKit.AValor := RetornaQtdKit;
end;

{***************** calcula a quantidade em estoque ************************** }
function TFProdutosKit.RetornaQtdKit : Double;
var
  MenorValor : Double;
begin
  MenorValor := (MovKit.fieldByname('n_qtd_pro').AsCurrency / MovKit.fieldByname('QtdKit').AsCurrency);
  while not MovKit.Eof do
  begin
    if MenorValor > (MovKit.fieldByname('n_qtd_pro').AsCurrency / MovKit.fieldByname('QtdKit').AsCurrency) then
      MenorValor := (MovKit.fieldByname('n_qtd_pro').AsCurrency / MovKit.fieldByname('QtdKit').AsCurrency);
    MovKit.Next;
  end;
  result := Trunc(MenorValor);
  if result < 0 then
    result := 0;
  MovKit.First;
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações que carregam o Kit
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***************************Mostra o kit selecionado***************************}
procedure TFProdutosKit.MostraKit(CodigoKit : String; CodigoEmpFil : Integer);
begin
   PosicionaMovKit( CodigoKit, CodigoEmpFil );
   label4.Caption := 'Filial - ' + IntToStr(FilialAtual);
   Showmodal;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************************Fecha o Formulario corrente***********************}
procedure TFProdutosKit.BFecharClick(Sender: TObject);
begin
   Close;
end;


procedure TFProdutosKit.KitRetorno(Retorno1, Retorno2: String);
begin
   if retorno1 <> '' then
      PosicionaMovKit(retorno1, FilialAtual);
end;


procedure TFProdutosKit.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FProdutosKit.HelpContext);
end;

Initialization
{ *************** Registra a classe para evitar duplicidade ****************** }
 RegisterClasses([TFProdutosKit]);
end.
