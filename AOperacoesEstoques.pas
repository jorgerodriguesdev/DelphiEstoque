unit AOperacoesEstoques;
{          Autor: Sergio Luiz Censi
    Data Criação: 05/04/1999;
          Função: Cadastrar um novo
  Data Alteração: 05/04/1999;
    Alterado por: Rafael Budag
Motivo alteração: - Adicionado os comentários e o blocos nas rotinas, e realizado
                    um teste - 05/04/199 / Rafael Budag
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Componentes1, ExtCtrls, PainelGradiente, Db, DBTables, Tabela,
  BotaoCadastro, StdCtrls, Buttons, Localizacao, Grids, DBGrids,
  DBCtrls, Mask, DBKeyViolation;

type
  TFOperacoesEstoques = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    MoveBasico1: TMoveBasico;
    BotaoCadastrar1: TBotaoCadastrar;
    BotaoAlterar1: TBotaoAlterar;
    BotaoExcluir1: TBotaoExcluir;
    BotaoGravar1: TBotaoGravar;
    BotaoCancelar1: TBotaoCancelar;
    Label1: TLabel;
    DataOperacoesEstoques: TDataSource;
    Label2: TLabel;
    DBEditColor1: TDBEditColor;
    Bevel1: TBevel;
    DBGridColor1: TGridIndice;
    Label3: TLabel;
    Consulta: TLocalizaEdit;
    CadOperacoesEstoques: TSQL;
    CadOperacoesEstoquesI_COD_OPE: TIntegerField;
    CadOperacoesEstoquesC_NOM_OPE: TStringField;
    CadOperacoesEstoquesC_TIP_OPE: TStringField;
    BFechar: TBitBtn;
    CadOperacoesEstoquesC_FUN_OPE: TStringField;
    DBRadioGroup2: TDBRadioGroup;
    DBEditColor2: TDBEditColor;
    Label4: TLabel;
    DBFilialColor1: TDBFilialColor;
    ValidaGravacao1: TValidaGravacao;
    CadOperacoesEstoquesD_ULT_ALT: TDateField;
    BBAjuda: TBitBtn;
    Label14: TLabel;
    OpeBaixa: TDBEditLocaliza;
    SpeedButton2: TSpeedButton;
    Label5: TLabel;
    CadOperacoesEstoquesI_OPE_BAI: TIntegerField;
    Localiza: TConsultaPadrao;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click2(Sender: TObject);
    procedure CadOperacoesEstoquesAfterInsert(DataSet: TDataSet);
    procedure CadOperacoesEstoquesBeforePost(DataSet: TDataSet);
    procedure CadOperacoesEstoquesAfterPost(DataSet: TDataSet);
    procedure CadOperacoesEstoquesAfterEdit(DataSet: TDataSet);
    procedure BFecharClick(Sender: TObject);
    procedure DBGridColor1DblClick(Sender: TObject);
    procedure DBRadioGroup2Change(Sender: TObject);
    procedure DBFilialColor1Change(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
    procedure CadOperacoesEstoquesAfterScroll(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FOperacoesEstoques: TFOperacoesEstoques;

implementation

uses APrincipal, Constantes;

{$R *.DFM}

// FUNÇÕES DAS OPERAÇÕES DE ESTOQUE
//-----------------------------------
// VE  Venda
// CO  Compra
// DV  Devolução de Venda
// DC  Devolução de Compra
// TS  Transferência Saída
// TE  Transferência Entrada
// OS  Outros Saída
// OE  Outro Entrada
//-------------------------------------

{ ****************** Na criação do Formulário ******************************** }
procedure TFOperacoesEstoques.FormCreate(Sender: TObject);
begin
   CadOperacoesEstoques.open;
   Self.HelpFile := Varia.PathHelp + 'MPONTOLOJA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
   DBFilialColor1.ACodFilial := Varia.CodigoFilCadastro;
   label14.Visible := varia.TipoSistema in [2,3,4];
   opeBaixa.Visible := varia.TipoSistema in [2,3,4];
   SpeedButton2.Visible := varia.TipoSistema in [2,3,4];
   label5.Visible := varia.TipoSistema in [2,3,4];
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFOperacoesEstoques.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   CadOperacoesEstoques.close;
   Action := CaFree;
end;


procedure TFOperacoesEstoques.BitBtn1Click2(Sender: TObject);
begin
end;

{***********************Gera o proximo codigo disponível***********************}
procedure TFOperacoesEstoques.CadOperacoesEstoquesAfterInsert(
  DataSet: TDataSet);
begin
   DBFilialColor1.ProximoCodigo;
   DBFilialColor1.ReadOnly := false;
   CadOperacoesEstoquesC_TIP_OPE.AsString := 'E';
   CadOperacoesEstoquesC_FUN_OPE.AsString := 'VE';
end;

{********Verifica se o codigo ja foi utilizado por algum usuario da rede*******}
procedure TFOperacoesEstoques.CadOperacoesEstoquesBeforePost(
  DataSet: TDataSet);
begin
  CadOperacoesEstoquesD_ULT_ALT.AsDateTime := Date;
   if CadOperacoesEstoques.State = dsinsert then
      DBFilialColor1.VerificaCodigoRede;
end;

{******************************Atualiza a tabela*******************************}
procedure TFOperacoesEstoques.CadOperacoesEstoquesAfterPost(
  DataSet: TDataSet);
begin
   Consulta.AtualizaTabela
end;

{*********************Coloca o campo chave em read-only************************}
procedure TFOperacoesEstoques.CadOperacoesEstoquesAfterEdit(
  DataSet: TDataSet);
begin
   DBFilialColor1.ReadOnly := True;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************************Fecha o Formulario corrente***********************}
procedure TFOperacoesEstoques.BFecharClick(Sender: TObject);
begin
   close;
end;

procedure TFOperacoesEstoques.DBGridColor1DblClick(Sender: TObject);
begin
   BotaoAlterar1.Click;
end;

procedure TFOperacoesEstoques.DBRadioGroup2Change(Sender: TObject);
begin
  if CadOperacoesEstoques.State in [ dsInsert, dsEdit ] then
  begin
    if DBRadioGroup2.ItemIndex in [ 0,3,4,6 ] then
      CadOperacoesEstoquesC_TIP_OPE.AsString := 'S'
    else
      CadOperacoesEstoquesC_TIP_OPE.AsString := 'E'
  end;
end;

{********************** valida a gravacao *************************************}
procedure TFOperacoesEstoques.DBFilialColor1Change(Sender: TObject);
begin
  if CadOperacoesEstoques.State in [dsedit,dsinsert] then
    ValidaGravacao1.execute;
end;

procedure TFOperacoesEstoques.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FOperacoesEstoques.HelpContext);
end;

procedure TFOperacoesEstoques.CadOperacoesEstoquesAfterScroll(
  DataSet: TDataSet);
begin
  OpeBaixa.Atualiza;
end;

Initialization
 RegisterClasses([TFOperacoesEstoques]);
end.
