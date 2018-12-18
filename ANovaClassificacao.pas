unit ANovaClassificacao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Mask, Db, DBTables, Tabela, DBCtrls, ExtCtrls,
  Componentes1, BotaoCadastro, PainelGradiente, DBKeyViolation, formularios,
  AProdutos, UnClassificacao;

type
  TFNovaClassificacao = class(TFormularioPermissao)
    PanelColor1: TPanelColor;
    PanelColor3: TPanelColor;
    Label1: TLabel;
    Empresa: TDBEditColor;
    Label4: TLabel;
    CadClassificacao: TTabela;
    Desc: TDBEditColor;
    DataCadClassificacao: TDataSource;
    PainelGradiente: TPainelGradiente;
    BotaoGravar1: TBotaoGravar;
    BotaoCancelar1: TBotaoCancelar;
    CodCla: TMaskEditColor;
    CadClassificacaoI_COD_EMP: TIntegerField;
    CadClassificacaoC_COD_CLA: TStringField;
    CadClassificacaoC_NOM_CLA: TStringField;
    CadClassificacaoC_CON_CLA: TStringField;
    DBEditChar1: TDBEditChar;
    Label2: TLabel;
    Label3: TLabel;
    ValidaGravacao1: TValidaGravacao;
    CadClassificacaoC_TIP_CLA: TStringField;
    BotaoFechar1: TBotaoFechar;
    CadClassificacaoD_ULT_ALT: TDateField;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BotaoGravar1DepoisAtividade(Sender: TObject);
    procedure BotaoCancelar1DepoisAtividade(Sender: TObject);
    procedure CodClaExit(Sender: TObject);
    procedure BotaoGravar1Atividade(Sender: TObject);
    procedure EmpresaChange(Sender: TObject);
    procedure BotaoFechar1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CadClassificacaoBeforePost(DataSet: TDataSet);
    procedure BBAjudaClick(Sender: TObject);
  private
    { Private declarations }
    acao:Boolean;
    codigo : string;
    UnCla : TFuncoesClassificacao;
    TipoDeCla : string;
  public
    { Public declarations }
    modo:byte;
    function Inseri(Info : TClassificacao; var Descricao : string; TamanhoPicture : Integer; TipoCla : string ) : Boolean;
    function Alterar(Codigo : string; CodigoRed : string; var Descricao : string; TipoCla : string; Alterar: Boolean) : Boolean;
  end;

var
  FNovaClassificacao: TFNovaClassificacao;

implementation

uses APrincipal, funstring, constantes, constMsg;

{$R *.DFM}


{******************************************************************************
                        Inseri nova classificacao
****************************************************************************** }
function TFNovaClassificacao.Inseri(Info : TClassificacao; var Descricao : string; TamanhoPicture : Integer; TipoCla : string  ) : Boolean;
begin
  self.codigo := info.codigo; // recebe o codigo pai
  self.TipoDeCla := TipoCla;

  CodCla.EditMask  := UnCla.GeraMascara(TamanhoPicture);

  CadClassificacao.Insert;
  empresa.Field.AsInteger := varia.CodigoEmpresa;
  CadClassificacaoC_CON_CLA.AsString := 'S';
  CadClassificacaoC_TIP_CLA.AsString := TipoCla;
  CodCla.ReadOnly := FALSE;
  CodCla.Text := UnCla.ProximoCodigoClassificacao( TamanhoPicture, codigo, TipoCla );

  ShowModal;

  Info.codigo := codigo + CodCla.Text;
  Info.CodigoRed := CodCla.Text;
  Descricao := Desc.Text;
  result := Acao;
end;

{******************************************************************************
                        destroy o formulario
****************************************************************************** }
procedure TFNovaClassificacao.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  
  UnCla.Destroy;
  Action := CaFree;
end;

{******************************************************************************
                        Alterar classificacao
****************************************************************************** }
function TFNovaClassificacao.Alterar(Codigo : string; CodigoRed : string; var Descricao : string; TipoCla : string; Alterar: Boolean) : Boolean;
begin
  self.TipoDeCla := TipoCla;
  // Classificação é por empresa e não por filial.
  if CadClassificacao.FindKey([Varia.CodigoEmpresa,codigo, TipoCla]) then
  begin
    if Alterar then
    begin
      CadClassificacao.edit;
      CodCla.Text := CodigoRed;
      CodCla.ReadOnly := true;
      ShowModal;
      Descricao := Desc.Text;
      result := Acao;
    end
    else
    begin
      CodCla.Text := CodigoRed;
      CodCla.ReadOnly := true;
      ShowModal;
      Result := False;
    end;
  end
  else
  begin
    Aviso('Classificação não encontrada.');
    Result := False;
    Close;
  end;
end;

{ *****************************************************************************
  FormShow :  serve para colocar o componente de edicao do
              código read only se for uma alteracao
****************************************************************************** }
procedure TFNovaClassificacao.FormCreate(Sender: TObject);
begin
  UnCla := TFuncoesClassificacao.criar(self,FPrincipal.BaseDados);
  Self.HelpFile := Varia.PathHelp + 'MPONTOLOJA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
  CadClassificacao.open;
end;

{*****************************************************************************
                   serve para indicar que o usuario confirmou
****************************************************************************** }
procedure TFNovaClassificacao.BotaoGravar1DepoisAtividade(Sender: TObject);
begin
  Acao:=TRUE;
  Close;
end;

{******************************************************************************
             serve para indicar que o usuario cancelou
****************************************************************************** }
procedure TFNovaClassificacao.BotaoCancelar1DepoisAtividade(Sender: TObject);
begin
  acao:=FALSE;
  Close;
end;

{******************************************************************************
   na saida da caixa de codigo, faz verificações de duplicação de código
****************************************************************************** }
procedure TFNovaClassificacao.CodClaExit(Sender: TObject);
begin
  if CadClassificacao.state = dsinsert Then
    if CodCla.text <> '' then
    begin
       if not UnCla.ClassificacaoExistente(codigo + CodCla.Text, TipoDeCla) then
         CodCla.SetFocus;
    end;
end;

{************ configura o codigo ******************************************** }
procedure TFNovaClassificacao.BotaoGravar1Atividade(Sender: TObject);
begin
if CadClassificacao.State = dsInsert then
   CadClassificacaoC_COD_CLA.Value := codigo + CodCla.Text;
end;

{*************** valida a gravacao ******************************************* }
procedure TFNovaClassificacao.EmpresaChange(Sender: TObject);
begin
if CadClassificacao.State in [ dsInsert, dsEdit ] then
  ValidaGravacao1.execute;
end;

procedure TFNovaClassificacao.BotaoFechar1Click(Sender: TObject);
begin
  Close;
end;

procedure TFNovaClassificacao.FormShow(Sender: TObject);
begin
  if TipoDeCla = 'S' then
    PainelGradiente.Caption := '  Cadastro de Classificação de Serviços  '
  else
    PainelGradiente.Caption := '  Cadastro de Classificação de Produtos  ';
end;

{******************* antes de gravar o registro *******************************}
procedure TFNovaClassificacao.CadClassificacaoBeforePost(
  DataSet: TDataSet);
begin
  //atualiza a data de alteracao para poder exportar
  CadClassificacaoD_ULT_ALT.AsDateTime := Date;
end;

procedure TFNovaClassificacao.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FNovaClassificacao.HelpContext);
end;

end.
