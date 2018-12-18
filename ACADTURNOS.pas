unit ACadTurnos;
   //Autor : Jorge Eduardo Rodrigues
   //Função: Cadastrar Novos Turnos
   //Data de criação: 04 de abril de 2001
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Grids, DBGrids, Tabela, DBKeyViolation, StdCtrls, Componentes1,
  Localizacao, Mask, DBCtrls, BotaoCadastro, Buttons, ExtCtrls,
  PainelGradiente, Db, DBTables;

type
  TFCADTURNOS = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    Bevel1: TBevel;
    BtFechar: TBotaoFechar;
    MoveBasico1: TMoveBasico;
    BtCadastrar: TBotaoCadastrar;
    BtAlterar: TBotaoAlterar;
    BtExcluir: TBotaoExcluir;
    BtGravar: TBotaoGravar;
    BtCancelar: TBotaoCancelar;
    BBAjuda: TBitBtn;
    Edescricao: TDBEditColor;
    Label1: TLabel;
    Label2: TLabel;
    EHInicial: TDBEditColor;
    EHfinal: TDBEditColor;
    EQTDHoras: TDBEditColor;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Consulta: TLocalizaEdit;
    GGrid: TGridIndice;
    CadTurnos: TSQL;
    ValidaGravacao1: TValidaGravacao;
    CadTurnosI_EMP_FIL: TIntegerField;
    CadTurnosI_COD_TUR: TIntegerField;
    CadTurnosC_DES_TUR: TStringField;
    CadTurnosH_HOR_INI: TTimeField;
    CadTurnosH_HOR_FIM: TTimeField;
    CadTurnosN_QTD_HOR: TFloatField;
    DataCadTurnos: TDataSource;
    ECodigo: TDBFilialColor;
    ProximoCodigoFilial1: TProximoCodigoFilial;
    CadTurnosD_ULT_ALT: TDateField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtFecharClick(Sender: TObject);
    procedure CadTurnosAfterCancel(DataSet: TDataSet);
    procedure CadTurnosAfterEdit(DataSet: TDataSet);
    procedure CadTurnosAfterInsert(DataSet: TDataSet);
    procedure CadTurnosAfterPost(DataSet: TDataSet);
    procedure ECodigoChange(Sender: TObject);
    procedure CadTurnosBeforePost(DataSet: TDataSet);
    procedure GGridOrdem(Ordem: String);
  private
    procedure ConfiguraConsulta(acao:boolean);
  public
    { Public declarations }
  end;

var
  FCADTURNOS: TFCADTURNOS;

implementation
uses Aprincipal,constantes,funObjeto,funSql;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFCADTURNOS.FormCreate(Sender: TObject);
begin
 Self.HelpFile := Varia.PathHelp + 'MaGeral.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
    cadTurnos.SQL.clear;
    cadTurnos.sql.Add('Select * from CadTurnos' +
                     ' Where I_EMP_FIL = ' + IntToStr(Varia.CodigoEmpFil) );
    cadTurnos.sql.Add(' Order by I_COD_TUR ' );
    cadTurnos.Open;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFCADTURNOS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 { fecha tabelas }
 { chamar a rotina de atualização de menus }
 CadTurnos.close;
 Action := CaFree;
end;


{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFCADTURNOS.BtFecharClick(Sender: TObject);
begin
Close;
end;
{ ********************* quando cancela a operacao *************************** }
procedure TFCADTURNOS.CadTurnosAfterCancel(DataSet: TDataSet);
begin
  ConfiguraConsulta(True);
end;
{*********************Coloca o campo chave em read-only (somente leitura)************************}
procedure TFCADTURNOS.CadTurnosAfterEdit(DataSet: TDataSet);
begin
   ECodigo.ReadOnly := True;
   ConfiguraConsulta(false);
end;
{ ******************* Apos a Inserção de um novo grupo, configura filial ***** }
procedure TFCADTURNOS.CadTurnosAfterInsert(DataSet: TDataSet);
begin
   CadTurnosI_EMP_FIL.AsInteger := Varia.CodigoEmpFil;
   ProximoCodigoFilial1.execute('cadTurnos','I_EMP_FIL',Varia.CodigoEmpFil);
   ECodigo.ReadOnly := false;
   ConfiguraConsulta(false);
end;
{******************************Atualiza a tabela*******************************}
procedure TFCADTURNOS.CadTurnosAfterPost(DataSet: TDataSet);
begin
  CadTurnos.Close;
  CadTurnos.Open;
  Consulta.AtualizaTabela;
  ConfiguraConsulta(true);
end;
{****** configura a consulta, caso edit ou insert enabled = false *********** }
//Trava os componentes Abaixo apos cadastrar//
procedure TFCADTURNOS.ConfiguraConsulta(acao:boolean);
begin
   Consulta.Enabled := acao;
   GGrid.Enabled := acao;
   Label6.Enabled := acao;
end;
{************  valida gravacao do formulario ******************************** }
procedure TFCADTURNOS.ECodigoChange(Sender: TObject);
begin
if (CadTurnos.State in [dsInsert, dsEdit]) then
  ValidaGravacao1.Execute;
end;
{********Verifica se o codigo ja foi utilizado por algum usuario da rede*******}
procedure TFCADTURNOS.CadTurnosBeforePost(DataSet: TDataSet);
begin
  //atualiza a data de alteracao para poder exportar
  CadTurnosD_ULT_ALT.AsDateTime := Date;
  if CadTurnos.State = dsinsert then
    ProximoCodigoFilial1.VerificaCodigo;
end;
{ *************  Altera a order by da consulta ****************************** }
procedure TFCADTURNOS.GGridOrdem(Ordem: String);
begin
Consulta.AOrdem := Ordem;
end;
 //abre Ajuda//abre Ajuda//abre Ajuda
Initialization
 RegisterClasses([TFCADTURNOS]);
end.
