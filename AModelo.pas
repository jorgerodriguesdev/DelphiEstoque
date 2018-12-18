unit AModelo;
{          Autor: Rafael Budag
    Data Criação: 25/03/1999;
          Função: Cadastrar uma nova transportadora
  Data Alteração: 25/03/1999;
    Alterado por:
Motivo alteração:
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Mask, DBCtrls, Tabela, Db, DBTables, Grids, DBGrids,
  BotaoCadastro, Buttons, Componentes1, ExtCtrls, PainelGradiente,
  DBKeyViolation, Localizacao;

type
  TFModelo = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor2: TPanelColor;
    BotaoCadastrar1: TBotaoCadastrar;
    BotaoAlterar1: TBotaoAlterar;
    BotaoExcluir1: TBotaoExcluir;
    BotaoGravar1: TBotaoGravar;
    BotaoCancelar1: TBotaoCancelar;
    MoveBasico1: TMoveBasico;
    PanelColor1: TPanelColor;
    DBGridColor1: TGridIndice;
    DataEventos: TDataSource;
    DBEditColor2: TDBEditColor;
    Label1: TLabel;
    Label2: TLabel;
    BFechar: TBitBtn;
    Bevel1: TBevel;
    Label3: TLabel;
    Consulta: TLocalizaEdit;
    CadModelo: TSQL;
    ValidaGravacao1: TValidaGravacao;
    BBAjuda: TBitBtn;
    DBFilialColor1: TDBFilialColor;
    CadModeloI_COD_MOD: TIntegerField;
    CadModeloC_NOM_MOD: TStringField;
    CadModeloD_ULT_ALT: TDateField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CadModeloAfterInsert(DataSet: TDataSet);
    procedure CadModeloBeforePost(DataSet: TDataSet);
    procedure BFecharClick(Sender: TObject);
    procedure CadModeloAfterPost(DataSet: TDataSet);
    procedure CadModeloAfterEdit(DataSet: TDataSet);
    procedure CadModeloAfterCancel(DataSet: TDataSet);
    procedure DBGridColor1Ordem(Ordem: String);
    procedure DBKeyViolation1Change(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
  private
    procedure ConfiguraConsulta( acao : Boolean);
  public
    { Public declarations }
  end;

var
  FModelo : TFModelo;

implementation

uses APrincipal,constantes;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }

procedure TFModelo.FormCreate(Sender: TObject);
begin
  CadModelo.open;
  Self.HelpFile := Varia.PathHelp + 'Mageral.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
  DBFilialColor1.ACodFilial := Varia.CodigoFilCadastro;
end;

{ ******************* Quando o formulario e fechado ************************** }

procedure TFModelo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 CadModelo.close;
 Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            Ações da Tabela
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}


{*********************Gera o próximo código livre******************************}

procedure TFModelo.CadModeloAfterInsert(DataSet: TDataSet);
begin
   DBFilialColor1.ProximoCodigo;
   DBFilialColor1.ReadOnly := false;
   ConfiguraConsulta(false);
end;

{**********Verifica se o codigo já foi utilizado por outro usuario na rede*****}

procedure TFModelo.CadModeloBeforePost(DataSet: TDataSet);
begin
  CadModeloD_ULT_ALT.AsDateTime := Date;
   if CadModelo.State = dsinsert then
      DBFilialColor1.VerificaCodigoRede;
end;

{***************************Atualiza a tabela**********************************}

procedure TFModelo.CadModeloAfterPost(DataSet: TDataSet);
begin
  Consulta.AtualizaTabela;
  ConfiguraConsulta(true);
end;

{*********************Coloca o campo chave em read-only************************}
procedure TFModelo.CadModeloAfterEdit(DataSet: TDataSet);
begin
   DBFilialColor1.ReadOnly := true;
   ConfiguraConsulta(false);
end;

{ ********************* quando cancela a operacao *************************** }
procedure TFModelo.CadModeloAfterCancel(DataSet: TDataSet);
begin
   ConfiguraConsulta(true);
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****** configura a consulta, caso edit ou insert enabled = false *********** }
procedure TFModelo.ConfiguraConsulta( acao : Boolean);
begin
   Consulta.Enabled := acao;
   DBGridColor1.Enabled := acao;
   Label3.Enabled := acao;
end;

{**************************Fecha o formulario corrente*************************}
procedure TFModelo.BFecharClick(Sender: TObject);
begin
   close;
end;

{********** adiciona order by na tabela ************************************ }
procedure TFModelo.DBGridColor1Ordem(Ordem: String);
begin
Consulta.AOrdem := Ordem;
end;

procedure TFModelo.DBKeyViolation1Change(Sender: TObject);
begin
if CadModelo.State in [ dsEdit, dsInsert ] then
 ValidaGravacao1.execute;
end;

procedure TFModelo.BBAjudaClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,FModelo.HelpContext);
end;

Initialization
 RegisterClasses([TFModelo]);
end.
