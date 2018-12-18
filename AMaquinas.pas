unit AMaquinas;
{          Autor: Sergio 
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
  TFMaquinas = class(TFormularioPermissao)
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
    DataMaquina: TDataSource;
    DBEditColor2: TDBEditColor;
    Label1: TLabel;
    Label2: TLabel;
    BFechar: TBitBtn;
    Bevel1: TBevel;
    Label3: TLabel;
    Consulta: TLocalizaEdit;
    CadMaquina: TSQL;
    ValidaGravacao1: TValidaGravacao;
    BBAjuda: TBitBtn;
    DBFilialColor1: TDBFilialColor;
    CadMaquinaI_COD_MAQ: TIntegerField;
    CadMaquinaC_NOM_MAQ: TStringField;
    CadMaquinaN_PER_CIC: TFloatField;
    CadMaquinaD_ULT_ALT: TDateField;
    Label4: TLabel;
    DBEditNumerico1: TDBEditNumerico;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CadMaquinaAfterInsert(DataSet: TDataSet);
    procedure CadMaquinaBeforePost(DataSet: TDataSet);
    procedure BFecharClick(Sender: TObject);
    procedure CadMaquinaAfterPost(DataSet: TDataSet);
    procedure CadMaquinaAfterEdit(DataSet: TDataSet);
    procedure CadMaquinaAfterCancel(DataSet: TDataSet);
    procedure DBGridColor1Ordem(Ordem: String);
    procedure DBKeyViolation1Change(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
  private
    procedure ConfiguraConsulta( acao : Boolean);
  public
    { Public declarations }
  end;

var
  FMaquinas: TFMaquinas;

implementation

uses APrincipal,constantes;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }

procedure TFMaquinas.FormCreate(Sender: TObject);
begin
  CadMaquina.open;
  Self.HelpFile := Varia.PathHelp + 'Mageral.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
  DBFilialColor1.ACodFilial := Varia.CodigoFilCadastro;
end;

{ ******************* Quando o formulario e fechado ************************** }

procedure TFMaquinas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 CadMaquina.close;
 Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            Ações da Tabela
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}


{*********************Gera o próximo código livre******************************}

procedure TFMaquinas.CadMaquinaAfterInsert(DataSet: TDataSet);
begin
   DBFilialColor1.ProximoCodigo;
   DBFilialColor1.ReadOnly := false;
   ConfiguraConsulta(false);
end;

{**********Verifica se o codigo já foi utilizado por outro usuario na rede*****}

procedure TFMaquinas.CadMaquinaBeforePost(DataSet: TDataSet);
begin
  CadMaquinaD_ULT_ALT.AsDateTime := Date;
   if CadMaquina.State = dsinsert then
      DBFilialColor1.VerificaCodigoRede;
end;

{***************************Atualiza a tabela**********************************}

procedure TFMaquinas.CadMaquinaAfterPost(DataSet: TDataSet);
begin
  Consulta.AtualizaTabela;
  ConfiguraConsulta(true);
end;

{*********************Coloca o campo chave em read-only************************}
procedure TFMaquinas.CadMaquinaAfterEdit(DataSet: TDataSet);
begin
   DBFilialColor1.ReadOnly := true;
   ConfiguraConsulta(false);
end;

{ ********************* quando cancela a operacao *************************** }
procedure TFMaquinas.CadMaquinaAfterCancel(DataSet: TDataSet);
begin
   ConfiguraConsulta(true);
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****** configura a consulta, caso edit ou insert enabled = false *********** }
procedure TFMaquinas.ConfiguraConsulta( acao : Boolean);
begin
   Consulta.Enabled := acao;
   DBGridColor1.Enabled := acao;
   Label3.Enabled := acao;
end;

{**************************Fecha o formulario corrente*************************}
procedure TFMaquinas.BFecharClick(Sender: TObject);
begin
   close;
end;

{********** adiciona order by na tabela ************************************ }
procedure TFMaquinas.DBGridColor1Ordem(Ordem: String);
begin
Consulta.AOrdem := Ordem;
end;

procedure TFMaquinas.DBKeyViolation1Change(Sender: TObject);
begin
if CadMaquina.State in [ dsEdit, dsInsert ] then
 ValidaGravacao1.execute;
end;

procedure TFMaquinas.BBAjudaClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,FMaquinas.HelpContext);
end;

Initialization
 RegisterClasses([TFMaquinas]);
end.
