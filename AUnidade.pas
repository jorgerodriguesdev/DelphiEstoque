unit AUnidade;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Componentes1, ExtCtrls, PainelGradiente, Db, DBTables, Tabela, Grids,
  DBGrids, StdCtrls, Mask, DBCtrls, DBKeyViolation, BotaoCadastro,
   Buttons, Localizacao, FunObjeto;

type
  TFUnidades = class(TFormularioPermissao)
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
    DataUnidade: TDataSource;
    Label2: TLabel;
    DBKeyViolation1: TDBKeyViolation;
    DBEditColor1: TDBEditColor;
    Bevel1: TBevel;
    DBGridColor1: TDBGridColor;
    Indice: TIndiceGrid;
    Bevel2: TBevel;
    CadUnidades2: TTable;
    CadUnidades1: TTable;
    MovIndiceConversao: TTable;
    DataIndeceConversao: TDataSource;
    MovIndiceConversaoC_UNI_ATU: TStringField;
    MovIndiceConversaoC_UNI_COV: TStringField;
    MovIndiceConversaoN_IND_COV: TFloatField;
    MovIndiceConversaoUnidadePai: TStringField;
    MovIndiceConversaoUnidadeFilho: TStringField;
    GradeMovUnidade: TDBGridColor;
    Label3: TLabel;
    BAlterar: TBitBtn;
    BOK: TBitBtn;
    Consulta: TLocalizaEdit;
    Label4: TLabel;
    CadUnidade: TSQL;
    CadUnidadeC_COD_UNI: TStringField;
    CadUnidadeC_NOM_UNI: TStringField;
    BFechar: TBitBtn;
    CadUnidadeD_ULT_ALT: TDateField;
    MovIndiceConversaoD_ULT_ALT: TDateField;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridColor1TitleClick(Column: TColumn);
    procedure BAlterarClick(Sender: TObject);
    procedure BOKClick(Sender: TObject);
    procedure CadUnidadeBeforeEdit(DataSet: TDataSet);
    procedure MovIndiceConversaoAfterPost(DataSet: TDataSet);
    procedure CadUnidadeAfterInsert(DataSet: TDataSet);
    procedure BFecharClick(Sender: TObject);
    procedure CadUnidadeBeforePost(DataSet: TDataSet);
    procedure MovIndiceConversaoBeforePost(DataSet: TDataSet);
    procedure BBAjudaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FUnidades: TFUnidades;

implementation

uses APrincipal, Constantes;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFUnidades.FormCreate(Sender: TObject);
begin
   CadUnidades2.Filter := 'c_cod_uni <> ''' + varia.UnidadeCX + ''' and c_cod_uni <> ''' + varia.UnidadeUN + '''';
   CadUnidades1.Filter := 'c_cod_uni <> ''' + varia.UnidadeCX + ''' and c_cod_uni <> ''' + varia.UnidadeUN + '''';
   CadUnidade.open;  {  abre tabelas }
   CadUnidades1.open;
   CadUnidades2.open;
   MovIndiceConversao.Open;
   Self.HelpFile := Varia.PathHelp + 'MPONTOLOJA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFUnidades.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   CadUnidade.close;  { fecha tabelas }
   CadUnidades1.close;
   CadUnidades2.close;
   MovIndiceConversao.close;
   Action := CaFree;
end;

{*********************Coloca o campo chave em read-only************************}
procedure TFUnidades.CadUnidadeBeforeEdit(DataSet: TDataSet);
begin
DBKeyViolation1.ReadOnly := true;
end;

{******************************Atualiza a tabela*******************************}
procedure TFUnidades.MovIndiceConversaoAfterPost(DataSet: TDataSet);
begin
   movIndiceConversao.close;
   movIndiceConversao.open;
end;

{***********************Gera o proximo codigo disponível***********************}
procedure TFUnidades.CadUnidadeAfterInsert(DataSet: TDataSet);
begin
   DBKeyViolation1.ReadOnly := false;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações da Movimentação
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{************************Altera o indice de Conversão**************************}
procedure TFUnidades.BAlterarClick(Sender: TObject);
begin
   GradeMovUnidade.Options := [dgEditing,dgTitles,dgIndicator,dgColumnResize,dgColLines,dgRowLines,dgTabs,dgConfirmDelete,dgCancelOnExit];
   AlterarEnabled([BAlterar,BOk]);
   PanelColor1.Enabled := false;
end;

{*********************Grava a alteração do indice******************************}
procedure TFUnidades.BOKClick(Sender: TObject);
begin
   GradeMovUnidade.Options := [dgTitles,dgIndicator,dgColumnResize,dgColLines,dgRowLines,dgTabs,dgRowSelect,dgAlwaysShowSelection,dgConfirmDelete,dgCancelOnExit];
   AlterarEnabled([BAlterar,BOk]);
   PanelColor1.Enabled := true;
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{**********Altera a ordem da tabela e atualiza o indice do grid****************}
procedure TFUnidades.DBGridColor1TitleClick(Column: TColumn);
begin
   if Column.Index = 0 then
       Consulta.AOrdem := ' order by C_COD_Uni'
      else
        if Column.Index = 1 then
           Consulta.Aordem := ' order by C_NOM_UNI';
   Indice.ALterarIndice(column.Index);
   consulta.AtualizaTabela;
end;

{****************************Fecha o Formulario corrente***********************}
procedure TFUnidades.BFecharClick(Sender: TObject);
begin
   close;
end;

{******************* antes de gravar o registro *******************************}
procedure TFUnidades.CadUnidadeBeforePost(DataSet: TDataSet);
begin
  //atualiza a data de alteracao para poder exportar
  CadUnidadeD_ULT_ALT.AsDateTime := Date;
end;

{******************* antes de gravar o registro *******************************}
procedure TFUnidades.MovIndiceConversaoBeforePost(DataSet: TDataSet);
begin
  //atualiza a data de alteracao para poder exportar
  MovIndiceConversaoD_ULT_ALT.AsDateTime := Date;
end;

procedure TFUnidades.BBAjudaClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,FUnidades.HelpContext);
end;

Initialization
{ *************** Registra a classe para evitar duplicidade ****************** }
 RegisterClasses([TFUnidades]);
end.
