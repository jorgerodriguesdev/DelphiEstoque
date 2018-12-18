unit AMarca;
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
  TFMarca = class(TFormularioPermissao)
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
    CadMarca: TSQL;
    ValidaGravacao1: TValidaGravacao;
    BBAjuda: TBitBtn;
    DBFilialColor1: TDBFilialColor;
    CadMarcaI_COD_MAR: TIntegerField;
    CadMarcaC_NOM_MAR: TStringField;
    CadMarcaD_ULT_ALT: TDateField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CadMarcaAfterInsert(DataSet: TDataSet);
    procedure CadMarcaBeforePost(DataSet: TDataSet);
    procedure BFecharClick(Sender: TObject);
    procedure CadMarcaAfterPost(DataSet: TDataSet);
    procedure CadMarcaAfterEdit(DataSet: TDataSet);
    procedure CadMarcaAfterCancel(DataSet: TDataSet);
    procedure DBGridColor1Ordem(Ordem: String);
    procedure DBKeyViolation1Change(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
  private
    procedure ConfiguraConsulta( acao : Boolean);
  public
    { Public declarations }
  end;

var
  FMarca: TFMarca;

implementation

uses APrincipal,constantes;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }

procedure TFMarca.FormCreate(Sender: TObject);
begin
  CadMarca.open;
  Self.HelpFile := Varia.PathHelp + 'Mageral.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
  DBFilialColor1.ACodFilial := Varia.CodigoFilCadastro;
end;

{ ******************* Quando o formulario e fechado ************************** }

procedure TFMarca.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 CadMarca.close;
 Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            Ações da Tabela
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}


{*********************Gera o próximo código livre******************************}

procedure TFMarca.CadMarcaAfterInsert(DataSet: TDataSet);
begin
   DBFilialColor1.ProximoCodigo;
   DBFilialColor1.ReadOnly := false;
   ConfiguraConsulta(false);
end;

{**********Verifica se o codigo já foi utilizado por outro usuario na rede*****}

procedure TFMarca.CadMarcaBeforePost(DataSet: TDataSet);
begin
  CadMarcaD_ULT_ALT.AsDateTime := Date;
   if CadMarca.State = dsinsert then
      DBFilialColor1.VerificaCodigoRede;
end;

{***************************Atualiza a tabela**********************************}

procedure TFMarca.CadMarcaAfterPost(DataSet: TDataSet);
begin
  Consulta.AtualizaTabela;
  ConfiguraConsulta(true);
end;

{*********************Coloca o campo chave em read-only************************}
procedure TFMarca.CadMarcaAfterEdit(DataSet: TDataSet);
begin
   DBFilialColor1.ReadOnly := true;
   ConfiguraConsulta(false);
end;

{ ********************* quando cancela a operacao *************************** }
procedure TFMarca.CadMarcaAfterCancel(DataSet: TDataSet);
begin
   ConfiguraConsulta(true);
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****** configura a consulta, caso edit ou insert enabled = false *********** }
procedure TFMarca.ConfiguraConsulta( acao : Boolean);
begin
   Consulta.Enabled := acao;
   DBGridColor1.Enabled := acao;
   Label3.Enabled := acao;
end;

{**************************Fecha o formulario corrente*************************}
procedure TFMarca.BFecharClick(Sender: TObject);
begin
   close;
end;

{********** adiciona order by na tabela ************************************ }
procedure TFMarca.DBGridColor1Ordem(Ordem: String);
begin
Consulta.AOrdem := Ordem;
end;

procedure TFMarca.DBKeyViolation1Change(Sender: TObject);
begin
if CadMarca.State in [ dsEdit, dsInsert ] then
 ValidaGravacao1.execute;
end;

procedure TFMarca.BBAjudaClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,FMarca.HelpContext);
end;

Initialization
 RegisterClasses([TFMarca]);
end.
