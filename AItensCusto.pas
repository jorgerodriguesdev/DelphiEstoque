unit AItensCusto;
{          Autor: Sergio Luiz Censi
    Data Criação: 05/04/1999;
          Função: Cadastrar um novo
  Data Alteração: 05/04/1999;
    Alterado por: Rafael Budag
Motivo alteração: - Adicionado os comentários e o blocos nas rotinas, e realizado
                    um teste - 05/04/199 / Rafael Budag
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Componentes1, ExtCtrls, PainelGradiente, Db, DBTables, Tabela,
  BotaoCadastro, StdCtrls, Buttons, Localizacao, Grids, DBGrids,
  DBCtrls, Mask, DBKeyViolation;

type
  TFItensCusto = class(TFormularioPermissao)
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
    DataCadItensCusto: TDataSource;
    Label2: TLabel;
    DBEditColor1: TDBEditColor;
    Bevel1: TBevel;
    CadItensCusto: TSQL;
    BFechar: TBitBtn;
    CadItensCustoI_COD_ITE: TIntegerField;
    CadItensCustoC_NOM_ITE: TStringField;
    Consulta: TLocalizaEdit;
    Label3: TLabel;
    BBAjuda: TBitBtn;
    Label4: TLabel;
    DBEditChar1: TDBEditChar;
    CadItensCustoC_ADI_CAD: TStringField;
    CadItensCustoN_VLR_PAD: TFloatField;
    CadItensCustoN_PER_PAD: TFloatField;
    DBEditNumerico1: TDBEditNumerico;
    DBEditNumerico2: TDBEditNumerico;
    Label5: TLabel;
    Label6: TLabel;
    ValidaGravacao1: TValidaGravacao;
    CadItensCustoD_ULT_ALT: TDateField;
    DBGridColor1: TGridIndice;
    codigo: TDBFilialColor;
    CadItensCustoC_TIP_LUC: TStringField;
    CadItensCustoI_DES_IMP: TIntegerField;
    DBRadioGroup1: TDBRadioGroup;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CadOperacoesEstoquesAfterInsert(DataSet: TDataSet);
    procedure CadOperacoesEstoquesBeforePost(DataSet: TDataSet);
    procedure CadOperacoesEstoquesAfterPost(DataSet: TDataSet);
    procedure BFecharClick(Sender: TObject);
    procedure CadItensCustoAfterEdit(DataSet: TDataSet);
    procedure BBAjudaClick(Sender: TObject);
    procedure DBEditNumerico1Exit(Sender: TObject);
    procedure DBEditNumerico2Exit(Sender: TObject);
    procedure CodigoChange(Sender: TObject);
    procedure DBGridColor1Ordem(Ordem: String);
    procedure CadItensCustoAfterCancel(DataSet: TDataSet);
    procedure DBRadioGroup1Change(Sender: TObject);
  private
    procedure ConfiguraConsulta( acao : Boolean);
  public
    { Public declarations }
  end;

var
  FItensCusto: TFItensCusto;

implementation

uses APrincipal, Constantes;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFItensCusto.FormCreate(Sender: TObject);
begin
  CadItensCusto.open;
  codigo.ACodFilial := varia.CodigoEmpFil;
  Self.HelpFile := Varia.PathHelp + 'MEstoqueCusto.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFItensCusto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   CadItensCusto.close;
   Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            Ações da Tabela
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***********************Gera o proximo codigo disponível***********************}
procedure TFItensCusto.CadOperacoesEstoquesAfterInsert(
  DataSet: TDataSet);
begin
   Codigo.ProximoCodigo;
   codigo.ReadOnly := false;
   CadItensCustoC_ADI_CAD.AsString := 'N';
   CadItensCustoN_VLR_PAD.AsCurrency := 0;
   CadItensCustoN_PER_PAD.AsCurrency := 0;
   CadItensCustoC_TIP_LUC.AsString := 'N';
   CadItensCustoI_DES_IMP.AsInteger := 1;
   ConfiguraConsulta(false);
end;

{********Verifica se o codigo ja foi utilizado por algum usuario da rede*******}
procedure TFItensCusto.CadOperacoesEstoquesBeforePost(
  DataSet: TDataSet);
begin
  CadItensCustoD_ULT_ALT.AsDateTime := Date;
   if CadItensCusto.State = dsinsert then
      codigo.VerificaCodigoRede;
end;

{******************************Atualiza a tabela*******************************}
procedure TFItensCusto.CadOperacoesEstoquesAfterPost(
  DataSet: TDataSet);
begin
   Consulta.AtualizaTabela;
   ConfiguraConsulta(true);
end;

{*********************Coloca o campo chave em read-only************************}
procedure TFItensCusto.CadItensCustoAfterEdit(DataSet: TDataSet);
begin
   codigo.ReadOnly := True;
   ConfiguraConsulta(false);
end;

{ ********************* quando cancela a operacao *************************** }
procedure TFItensCusto.CadItensCustoAfterCancel(DataSet: TDataSet);
begin
  ConfiguraConsulta(true);
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****** configura a consulta, caso edit ou insert enabled = false *********** }
procedure TFItensCusto.ConfiguraConsulta( acao : Boolean);
begin
   Consulta.Enabled := acao;
   DBGridColor1.Enabled := acao;
   Label3.Enabled := acao;
end;

{****************************Fecha o Formulario corrente***********************}
procedure TFItensCusto.BFecharClick(Sender: TObject);
begin
   self.close;
end;

{********** adiciona order by na tabela ************************************ }
procedure TFItensCusto.DBGridColor1Ordem(Ordem: String);
begin
  Consulta.AOrdem := Ordem;
end;

procedure TFItensCusto.CodigoChange(Sender: TObject);
begin
  if CadItensCusto.State in [ dsEdit, dsInsert ] then
    ValidaGravacao1.execute;
end;

procedure TFItensCusto.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FItensCusto.HelpContext);
end;


procedure TFItensCusto.DBEditNumerico1Exit(Sender: TObject);
begin
  if DBEditNumerico1.Field.AsInteger <> 0 then
    DBEditNumerico2.Field.AsInteger := 0;
end;

procedure TFItensCusto.DBEditNumerico2Exit(Sender: TObject);
begin
  if DBEditNumerico2.Field.AsInteger <> 0 then
    DBEditNumerico1.Field.AsInteger := 0;
end;


procedure TFItensCusto.DBRadioGroup1Change(Sender: TObject);
begin
  if CadItensCusto.State in [dsEdit, dsInsert ] then
    if DBRadioGroup1.ItemIndex in [0,2] then
      CadItensCustoN_VLR_PAD.AsFloat := 0;
end;

Initialization
 RegisterClasses([TFItensCusto]);
end.
