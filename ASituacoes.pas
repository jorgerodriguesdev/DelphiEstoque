unit ASituacoes;
{   Autor: Sergio Luiz Censi
    Data Criação: 29/03/1999;
          Função: Cadastrar um novo Banco
  Data Alteração: 29/03/1999;
    Alterado por: Rafael Budag
Motivo alteração: Adicionado os comementários e os blocos e testado - 29/03/1999 / Rafael Budag
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Componentes1, ExtCtrls, PainelGradiente, BotaoCadastro,
  StdCtrls, Buttons, Db, DBTables, Tabela, Mask, DBCtrls, Localizacao,
  DBKeyViolation, Grids, DBGrids;

type
  TFSituacoes = class(TFormularioPermissao)
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
    DataBancos: TDataSource;
    Label2: TLabel;
    DBEditColor1: TDBEditColor;
    Bevel1: TBevel;
    DBGridColor1: TGridIndice;
    CadSituacoes: TSQL;
    consulta: TLocalizaEdit;
    Label6: TLabel;
    BFechar: TBitBtn;
    ValidaGravacao1: TValidaGravacao;
    BBAjuda: TBitBtn;
    CadSituacoesI_COD_SIT: TIntegerField;
    CadSituacoesC_NOM_SIT: TStringField;
    CadSituacoesC_FLA_SIT: TStringField;
    DBRadioGroup1: TDBRadioGroup;
    CadSituacoesC_IGN_FLU: TStringField;
    CadSituacoesC_EMP_BAN: TStringField;
    DBRadioGroup2: TDBRadioGroup;
    Label3: TLabel;
    DBEditChar2: TDBEditChar;
    DBFilialColor1: TDBFilialColor;
    CadSituacoesD_ULT_ALT: TDateField;
    DBEditColor2: TDBEditColor;
    Label4: TLabel;
    CadSituacoesI_QTD_DIA: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CadSituacoesAfterInsert(DataSet: TDataSet);
    procedure CadSituacoesBeforePost(DataSet: TDataSet);
    procedure CadSituacoesAfterPost(DataSet: TDataSet);
    procedure BFecharClick(Sender: TObject);
    procedure CadSituacoesAfterEdit(DataSet: TDataSet);
    procedure CadSituacoesAfterCancel(DataSet: TDataSet);
    procedure DBGridColor1Ordem(Ordem: String);
    procedure DBKeyViolation1Change(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
    procedure DBRadioGroup1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure ConfiguraConsulta( acao : Boolean);
  public
    { Public declarations }
  end;

var
  FSituacoes: TFSituacoes;

implementation

uses APrincipal, Constantes;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFSituacoes.FormCreate(Sender: TObject);
begin
   CadSituacoes.open;  {  abre tabelas }
   DBFilialColor1.ACodFilial := Varia.CodigoFilCadastro;
   Self.HelpFile := Varia.PathHelp + 'FINANCEIRO.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
end;

{ ******************* Quando o formulario e fechado ************************** }
 procedure TFSituacoes.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   CadSituacoes.close; { fecha tabelas }
 Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações das Tabelas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***********************Gera o proximo codigo disponível***********************}
procedure TFSituacoes.CadSituacoesAfterInsert(DataSet: TDataSet);
begin
   DBFilialColor1.ProximoCodigo;
   DBFilialColor1.ReadOnly := False;
   ConfiguraConsulta(false);
   CadSituacoesC_FLA_SIT.AsString := 'PR';
   CadSituacoesC_IGN_FLU.AsString := 'N';
   CadSituacoesC_EMP_BAN.AsString := 'B';
   CadSituacoesI_QTD_DIA.AsInteger := 0;
end;

{********Verifica se o codigo ja foi utilizado por algum usuario da rede*******}
procedure TFSituacoes.CadSituacoesBeforePost(DataSet: TDataSet);
begin
  CadSituacoesD_ULT_ALT.AsDateTime := Date;
  If CadSituacoes.State = dsInsert Then
    DBFilialColor1.VerificaCodigoRede;
end;

{***************Caso o codigo tenha sido utilizado, efetua refresh*************}
procedure TFSituacoes.CadSituacoesAfterPost(DataSet: TDataSet);
begin
   consulta.AtualizaTabela;
   ConfiguraConsulta(true);
end;

{*********************Coloca o campo chave em read-only************************}
procedure TFSituacoes.CadSituacoesAfterEdit(DataSet: TDataSet);
begin
   DBFilialColor1.ReadOnly := true;
   ConfiguraConsulta(false);
end;

{ ********************* quando cancela a operacao *************************** }
procedure TFSituacoes.CadSituacoesAfterCancel(DataSet: TDataSet);
begin
  ConfiguraConsulta(true);
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****** configura a consulta, caso edit ou insert enabled = false *********** }
procedure TFSituacoes.ConfiguraConsulta( acao : Boolean);
begin
   Consulta.Enabled := acao;
   DBGridColor1.Enabled := acao;
   Label6.Enabled := acao;
end;

{***************************Fechar o Formulario corrente***********************}
procedure TFSituacoes.BFecharClick(Sender: TObject);
begin
   self.close;
end;

{********** adiciona order by na tabela ************************************ }
procedure TFSituacoes.DBGridColor1Ordem(Ordem: String);
begin
consulta.AOrdem := ordem;
end;

procedure TFSituacoes.DBKeyViolation1Change(Sender: TObject);
begin
if CadSituacoes.State in [ dsEdit, dsInsert ] then
  ValidaGravacao1.execute;
end;

procedure TFSituacoes.BBAjudaClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,FSituacoes.HelpContext);
end;

procedure TFSituacoes.DBRadioGroup1Change(Sender: TObject);
begin
  if DBRadioGroup1.ItemIndex > 0 then
  begin
    DBRadioGroup2.Enabled := false;
    DBEditChar2.Enabled := false;
  end
  else
  begin
    DBRadioGroup2.Enabled := true;
    DBEditChar2.Enabled := true;
  end;
end;

procedure TFSituacoes.FormShow(Sender: TObject);
begin
  DBRadioGroup1.Controls[0].Enabled := (ConfigModulos.ContasAPagar or ConfigModulos.ContasAReceber);
  DBRadioGroup1.Controls[0].Enabled := (ConfigModulos.PedidoVenda or  ConfigModulos.OrcamentoVenda);
  DBRadioGroup1.Controls[1].Enabled := ConfigModulos.OrdemServico;
  DBRadioGroup1.Controls[3].Enabled := ConfigModulos.PCP;
end;

Initialization
 RegisterClasses([TFSituacoes]);
end.
 