unit AEquipamento;
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
  TFEquipamento = class(TFormularioPermissao)
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
    CadEquipamento: TSQL;
    ValidaGravacao1: TValidaGravacao;
    BBAjuda: TBitBtn;
    DBFilialColor1: TDBFilialColor;
    CadEquipamentoI_COD_EQU: TIntegerField;
    CadEquipamentoC_NOM_EQU: TStringField;
    CadEquipamentoD_ULT_ALT: TDateField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CadEquipamentoAfterInsert(DataSet: TDataSet);
    procedure CadEquipamentoBeforePost(DataSet: TDataSet);
    procedure BFecharClick(Sender: TObject);
    procedure CadEquipamentoAfterPost(DataSet: TDataSet);
    procedure CadEquipamentoAfterEdit(DataSet: TDataSet);
    procedure CadEquipamentoAfterCancel(DataSet: TDataSet);
    procedure DBGridColor1Ordem(Ordem: String);
    procedure DBKeyViolation1Change(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
  private
    procedure ConfiguraConsulta( acao : Boolean);
  public
    { Public declarations }
  end;

var
  FEquipamento: TFEquipamento;

implementation

uses APrincipal,constantes;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }

procedure TFEquipamento.FormCreate(Sender: TObject);
begin
  CadEquipamento.open;
  Self.HelpFile := Varia.PathHelp + 'Mageral.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
  DBFilialColor1.ACodFilial := Varia.CodigoFilCadastro;
end;

{ ******************* Quando o formulario e fechado ************************** }

procedure TFEquipamento.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 CadEquipamento.close;
 Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            Ações da Tabela
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}


{*********************Gera o próximo código livre******************************}

procedure TFEquipamento.CadEquipamentoAfterInsert(DataSet: TDataSet);
begin
   DBFilialColor1.ProximoCodigo;
   DBFilialColor1.ReadOnly := false;
   ConfiguraConsulta(false);
end;

{**********Verifica se o codigo já foi utilizado por outro usuario na rede*****}

procedure TFEquipamento.CadEquipamentoBeforePost(DataSet: TDataSet);
begin
  CadEquipamentoD_ULT_ALT.AsDateTime := Date;
   if CadEquipamento.State = dsinsert then
      DBFilialColor1.VerificaCodigoRede;
end;

{***************************Atualiza a tabela**********************************}

procedure TFEquipamento.CadEquipamentoAfterPost(DataSet: TDataSet);
begin
  Consulta.AtualizaTabela;
  ConfiguraConsulta(true);
end;

{*********************Coloca o campo chave em read-only************************}
procedure TFEquipamento.CadEquipamentoAfterEdit(DataSet: TDataSet);
begin
   DBFilialColor1.ReadOnly := true;
   ConfiguraConsulta(false);
end;

{ ********************* quando cancela a operacao *************************** }
procedure TFEquipamento.CadEquipamentoAfterCancel(DataSet: TDataSet);
begin
   ConfiguraConsulta(true);
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****** configura a consulta, caso edit ou insert enabled = false *********** }
procedure TFEquipamento.ConfiguraConsulta( acao : Boolean);
begin
   Consulta.Enabled := acao;
   DBGridColor1.Enabled := acao;
   Label3.Enabled := acao;
end;

{**************************Fecha o formulario corrente*************************}
procedure TFEquipamento.BFecharClick(Sender: TObject);
begin
   close;
end;

{********** adiciona order by na tabela ************************************ }
procedure TFEquipamento.DBGridColor1Ordem(Ordem: String);
begin
Consulta.AOrdem := Ordem;
end;

procedure TFEquipamento.DBKeyViolation1Change(Sender: TObject);
begin
if CadEquipamento.State in [ dsEdit, dsInsert ] then
 ValidaGravacao1.execute;
end;

procedure TFEquipamento.BBAjudaClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,FEQuipamento.HelpContext);
end;

Initialization
 RegisterClasses([TFEquipamento]);
end.
