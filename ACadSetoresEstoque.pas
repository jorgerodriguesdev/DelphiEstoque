unit ACadSetoresEstoque;

{          Autor: Leonardo Emanuel Pretti
    Data Criação: 16/04/2001
          Função: Cadastrar um novo setor do estoque
    Alterado por:
  Data Alteração:
Motivo alteração:
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Db, DBTables, Tabela, BotaoCadastro, StdCtrls, Buttons, Grids, DBGrids,
  DBKeyViolation, Localizacao, Componentes1, ExtCtrls, PainelGradiente,
  Mask, DBCtrls;

type
  TFSetoresEstoque = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor2: TPanelColor;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EDescSetor: TDBEditColor;
    Grade: TGridIndice;
    PanelColor1: TPanelColor;
    BotaoFechar1: TBotaoFechar;
    MoveBasico1: TMoveBasico;
    BotaoCadastrar1: TBotaoCadastrar;
    BotaoAlterar1: TBotaoAlterar;
    BotaoExcluir1: TBotaoExcluir;
    BotaoGravar1: TBotaoGravar;
    BotaoCancelar1: TBotaoCancelar;
    BitBtn1: TBitBtn;
    SQLSetores: TSQL;
    DataSetores: TDataSource;
    SQLSetoresI_COD_SET: TIntegerField;
    Localiza: TConsultaPadrao;
    ValidaGravacao: TValidaGravacao;
    SQLSetoresC_NOM_SET: TStringField;
    DBFilialColor1: TDBFilialColor;
    Consulta: TLocalizaEdit;
    SQLSetoresD_ULT_ALT: TDateField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BotaoFechar1Click(Sender: TObject);
    procedure GradeOrdem(Ordem: String);
    procedure ESetorChange(Sender: TObject);
    procedure EDescSetorChange(Sender: TObject);
    procedure SQLSetoresAfterInsert(DataSet: TDataSet);
    procedure SQLSetoresAfterCancel(DataSet: TDataSet);
    procedure SQLSetoresAfterEdit(DataSet: TDataSet);
    procedure SQLSetoresAfterPost(DataSet: TDataSet);
    procedure BitBtn1Click(Sender: TObject);
    procedure SQLSetoresBeforePost(DataSet: TDataSet);
  private
    procedure ConfiguraConsulta( acao : Boolean); { Private declarations }
  public
    { Public declarations }
  end;

var
  FSetoresEstoque: TFSetoresEstoque;

implementation
  uses APrincipal, Constantes, ACadPaises;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFSetoresEstoque.FormCreate(Sender: TObject);
begin
   Self.HelpFile := Varia.PathHelp + 'MaGeral.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
   DBFilialColor1.ACodFilial := varia.CodigoFilCadastro;
   SQLSetores.SQL.Clear;
   SQLSetores.SQL.Add (' select * from cadsetoresestoque');
   SQLSetores.SQL.Add ('order by I_COD_SET');
   SQLSetores.Open;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFSetoresEstoque.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   SQLSetores.Close; { fecha tabelas }
  Action := CaFree;
end;

{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFSetoresEstoque.BotaoFechar1Click(Sender: TObject);
begin
  self.close;
end;

procedure TFSetoresEstoque.GradeOrdem(Ordem: String);
begin
  Consulta.AOrdem := Ordem;
end;

procedure TFSetoresEstoque.ESetorChange(Sender: TObject);
begin
  if (SQLSetores.State in [dsInsert, dsEdit]) then
  ValidaGravacao.Execute;
end;

procedure TFSetoresEstoque.ConfiguraConsulta( acao : boolean);
begin
   Label3.Enabled := acao;
   Consulta.Enabled := acao;
   Grade.Enabled := acao;
end;

procedure TFSetoresEstoque.EDescSetorChange(Sender: TObject);
begin
  if (SQLSetores.State in [dsInsert, dsEdit]) then
    ValidaGravacao.Execute;
end;

procedure TFSetoresEstoque.SQLSetoresAfterInsert(DataSet: TDataSet);
begin
   DBFilialColor1.ProximoCodigo;
   DBFilialColor1.ReadOnly := False;
   ConfiguraConsulta(False);
   DBFilialColor1.SetFocus;
end;

procedure TFSetoresEstoque.SQLSetoresAfterCancel(DataSet: TDataSet);
begin
  ConfiguraConsulta(True);
end;

procedure TFSetoresEstoque.SQLSetoresAfterEdit(DataSet: TDataSet);
begin
   DBFilialColor1.ReadOnly := true;
   ConfiguraConsulta(False);
end;

procedure TFSetoresEstoque.SQLSetoresAfterPost(DataSet: TDataSet);
begin
  ConfiguraConsulta(True);
end;

procedure TFSetoresEstoque.BitBtn1Click(Sender: TObject);
begin
 Application.HelpCommand(HELP_CONTEXT,FCadPaises.HelpContext);
end;

procedure TFSetoresEstoque.SQLSetoresBeforePost(DataSet: TDataSet);
begin
   SQLSetoresD_ULT_ALT.AsDateTime := date;
   if SQLSetores.State = dsinsert then
      DBFilialColor1.VerificaCodigoRede;
end;

Initialization
 RegisterClasses([TFSetoresEstoque]);
end.
