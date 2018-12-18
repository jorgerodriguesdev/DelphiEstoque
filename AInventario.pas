unit AInventario;
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
  TFInventario = class(TFormularioPermissao)
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
    Label1: TLabel;
    Label2: TLabel;
    BFechar: TBitBtn;
    Bevel1: TBevel;
    Label3: TLabel;
    Consulta: TLocalizaEdit;
    CadInventario: TSQL;
    ValidaGravacao1: TValidaGravacao;
    BBAjuda: TBitBtn;
    CadInventarioI_EMP_FIL: TIntegerField;
    CadInventarioI_NRO_IVE: TIntegerField;
    CadInventarioD_DAT_IVE: TDateField;
    DBEditNumerico1: TDBEditNumerico;
    DBEditColor1: TDBEditColor;
    CadInventarioD_ULT_ALT: TDateField;
    CadInventarioC_NOM_IVE: TStringField;
    Label4: TLabel;
    DBEditColor2: TDBEditColor;
    ProximoCodigoFilial1: TProximoCodigoFilial;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CadInventarioAfterInsert(DataSet: TDataSet);
    procedure CadInventarioBeforePost(DataSet: TDataSet);
    procedure BFecharClick(Sender: TObject);
    procedure CadInventarioAfterPost(DataSet: TDataSet);
    procedure CadInventarioAfterEdit(DataSet: TDataSet);
    procedure CadInventarioAfterCancel(DataSet: TDataSet);
    procedure DBGridColor1Ordem(Ordem: String);
    procedure DBKeyViolation1Change(Sender: TObject);
  private
    procedure ConfiguraConsulta( acao : Boolean);
  public
    { Public declarations }
  end;

var
  FInventario: TFInventario;

implementation

uses APrincipal,constantes;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFInventario.FormCreate(Sender: TObject);
begin
  CadInventario.open;
  Self.HelpFile := Varia.PathHelp + 'Mageral.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFInventario.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CadInventario.close;
  Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            Ações da Tabela
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}


{*********************Gera o próximo código livre******************************}
procedure TFInventario.CadInventarioAfterInsert(DataSet: TDataSet);
begin
   CadInventarioI_EMP_FIL.AsInteger := varia.CodigoEmpFil;
   ProximoCodigoFilial1.execute('CadInventario','I_EMP_FIL',varia.CodigoEmpFil);
   CadInventarioD_DAT_IVE.AsDateTime := date;
   ConfiguraConsulta(false);
end;

{**********Verifica se o codigo já foi utilizado por outro usuario na rede*****}
procedure TFInventario.CadInventarioBeforePost(DataSet: TDataSet);
begin
  CadInventarioD_ULT_ALT.AsDateTime := Date;
   if CadInventario.State = dsinsert then
     ProximoCodigoFilial1.VerificaCodigo;
end;

{***************************Atualiza a tabela**********************************}
procedure TFInventario.CadInventarioAfterPost(DataSet: TDataSet);
begin
  Consulta.AtualizaTabela;
  ConfiguraConsulta(true);
end;

{*********************Coloca o campo chave em read-only************************}
procedure TFInventario.CadInventarioAfterEdit(DataSet: TDataSet);
begin
   DBEditNumerico1.ReadOnly := true;
   ConfiguraConsulta(false);
end;

{ ********************* quando cancela a operacao *************************** }
procedure TFInventario.CadInventarioAfterCancel(DataSet: TDataSet);
begin
   ConfiguraConsulta(true);
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****** configura a consulta, caso edit ou insert enabled = false *********** }
procedure TFInventario.ConfiguraConsulta( acao : Boolean);
begin
   Consulta.Enabled := acao;
   DBGridColor1.Enabled := acao;
   Label3.Enabled := acao;
end;

{**************************Fecha o formulario corrente*************************}
procedure TFInventario.BFecharClick(Sender: TObject);
begin
   close;
end;

{********** adiciona order by na tabela ************************************ }
procedure TFInventario.DBGridColor1Ordem(Ordem: String);
begin
Consulta.AOrdem := Ordem;
end;

procedure TFInventario.DBKeyViolation1Change(Sender: TObject);
begin
if CadInventario.State in [ dsEdit, dsInsert ] then
 ValidaGravacao1.execute;
end;

Initialization
 RegisterClasses([TFInventario]);
end.
