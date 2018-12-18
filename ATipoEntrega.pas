unit ATipoEntrega;
{   Autor: Sergio Luiz Censi
    Data Criação: 29/03/1999;
          Função: Cadastrar um novo Tipo de entrega
  Data Alteração: 29/03/1999;
Motivo alteração: Adicionado os comementários e os blocos e testado - 29/03/1999 / Rafael Budag
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Componentes1, ExtCtrls, PainelGradiente, BotaoCadastro,
  StdCtrls, Buttons, Db, DBTables, Tabela, Mask, DBCtrls, Localizacao,
  DBKeyViolation, Grids, DBGrids;

type
  TFTipoEntrega = class(TFormularioPermissao)
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
    DataTipoEntrega: TDataSource;
    Label2: TLabel;
    DBEditColor1: TDBEditColor;
    DBKeyViolation1: TDBKeyViolation;
    Bevel1: TBevel;
    DBGridColor1: TGridIndice;
    ProximoCodigo1: TProximoCodigo;
    CadTipoEntrega: TSQL;
    consulta: TLocalizaEdit;
    Label6: TLabel;
    BFechar: TBitBtn;
    ValidaGravacao1: TValidaGravacao;
    BBAjuda: TBitBtn;
    CadTipoEntregaI_COD_ENT: TIntegerField;
    CadTipoEntregaC_DES_ENT: TStringField;
    CadTipoEntregaD_ULT_ALT: TDateField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CadTipoEntregaAfterInsert(DataSet: TDataSet);
    procedure CadTipoEntregaBeforePost(DataSet: TDataSet);
    procedure CadTipoEntregaAfterPost(DataSet: TDataSet);
    procedure BFecharClick(Sender: TObject);
    procedure CadTipoEntregaAfterEdit(DataSet: TDataSet);
    procedure CadTipoEntregaAfterCancel(DataSet: TDataSet);
    procedure DBGridColor1Ordem(Ordem: String);
    procedure DBKeyViolation1Change(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
  private
    procedure ConfiguraConsulta( acao : Boolean);
  public
    { Public declarations }
  end;

var
  FTipoEntrega : TFTipoEntrega;

implementation

uses APrincipal, Constantes;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFTipoEntrega.FormCreate(Sender: TObject);
begin
   Self.HelpFile := Varia.PathHelp + 'FINANCEIRO.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
   CadTipoEntrega.open;  {  abre tabelas }
end;

{ ******************* Quando o formulario e fechado ************************** }
 procedure TFTipoEntrega.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   CadTipoEntrega.close; { fecha tabelas }
   Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações das Tabelas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***********************Gera o proximo codigo disponível***********************}
procedure TFTipoEntrega.CadTipoEntregaAfterInsert(DataSet: TDataSet);
begin
   ProximoCodigo1.execute('CadTipoEntrega');
   DBKeyViolation1.ReadOnly := False;
   ConfiguraConsulta(false);
end;

{********Verifica se o codigo ja foi utilizado por algum usuario da rede*******}
procedure TFTipoEntrega.CadTipoEntregaBeforePost(DataSet: TDataSet);
begin
   CadTipoEntregaD_ULT_ALT.AsDateTime := date;
  If CadTipoEntrega.State = dsInsert Then
    ProximoCodigo1.VerificaCodigo;
end;

{***************Caso o codigo tenha sido utilizado, efetua refresh*************}
procedure TFTipoEntrega.CadTipoEntregaAfterPost(DataSet: TDataSet);
begin
   consulta.AtualizaTabela;
   ConfiguraConsulta(true);
end;

{*********************Coloca o campo chave em read-only************************}
procedure TFTipoEntrega.CadTipoEntregaAfterEdit(DataSet: TDataSet);
begin
   DBKeyViolation1.ReadOnly := true;
   ConfiguraConsulta(false);
end;

{ ********************* quando cancela a operacao *************************** }
procedure TFTipoEntrega.CadTipoEntregaAfterCancel(DataSet: TDataSet);
begin
  ConfiguraConsulta(true);
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****** configura a consulta, caso edit ou insert enabled = false *********** }
procedure TFTipoEntrega.ConfiguraConsulta( acao : Boolean);
begin
   Consulta.Enabled := acao;
   DBGridColor1.Enabled := acao;
   Label6.Enabled := acao;
end;

{***************************Fechar o Formulario corrente***********************}
procedure TFTipoEntrega.BFecharClick(Sender: TObject);
begin
   self.close;
end;

{********** adiciona order by na tabela ************************************ }
procedure TFTipoEntrega.DBGridColor1Ordem(Ordem: String);
begin
consulta.AOrdem := ordem;
end;

procedure TFTipoEntrega.DBKeyViolation1Change(Sender: TObject);
begin
if CadTipoEntrega.State in [ dsEdit, dsInsert ] then
  ValidaGravacao1.execute;
end;

procedure TFTipoEntrega.BBAjudaClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,FTipoEntrega.HelpContext);
end;

Initialization
 RegisterClasses([TFTipoEntrega]);
end.
  