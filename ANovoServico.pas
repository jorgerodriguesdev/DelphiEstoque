unit ANovoServico;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Mask, DBCtrls, Tabela, Db, BotaoCadastro, Buttons,
  DBTables, Grids, DBGrids, Componentes1, formularios, PainelGradiente,
  DBKeyViolation, LabelCorMove, Localizacao, EditorImagem, UnProdutos, UnClassificacao,
  numericos, UnServicos;

type
  TFNovoServico = class(TFormularioPermissao)
    DataServico: TDataSource;
    PainelGradiente1: TPainelGradiente;
    PanelColor2: TPanelColor;
    Localiza: TConsultaPadrao;
    ValidaGravacao1: TValidaGravacao;
    PanelColor1: TPanelColor;
    Label4: TLabel;
    CodigoFil: TDBEditColor;
    Label1: TLabel;
    Label3: TLabel;
    Descricao: TDBEditColor;
    Label6: TLabel;
    ECodClassificacao: TDBEditColor;
    BCla: TSpeedButton;
    LCla: TLabel;
    CadServico: TQuery;
    CadServicoI_COD_SER: TIntegerField;
    CadServicoC_NOM_SER: TStringField;
    CadServicoI_COD_EMP: TIntegerField;
    CadServicoC_COD_CLA: TStringField;
    CadServicoC_TIP_CLA: TStringField;
    CadServicoL_OBS_SER: TMemoField;
    CadServicoC_ATI_SER: TStringField;
    DBEditColor1: TDBEditColor;
    Label2: TLabel;
    DBMemoColor1: TDBMemoColor;
    Label5: TLabel;
    BGravar: TBitBtn;
    BCancelar: TBitBtn;
    BFechar: TBitBtn;
    DBFilialColor1: TDBFilialColor;
    CadServicoD_ULT_ALT: TDateField;
    BBAjuda: TBitBtn;
    CadServicoN_PER_COM: TFloatField;
    DBEditNumerico1: TDBEditNumerico;
    Label7: TLabel;
    DBEditNumerico2: TDBEditNumerico;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBEditLocaliza1Change(Sender: TObject);
    procedure BClaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ECodClassificacaoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BFecharClick(Sender: TObject);
    procedure CadServicoAfterInsert(DataSet: TDataSet);
    procedure CadServicoAfterEdit(DataSet: TDataSet);
    procedure CadServicoBeforePost(DataSet: TDataSet);
    procedure BGravarClick(Sender: TObject);
    procedure BCancelarClick(Sender: TObject);
    procedure DBEditColor1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CadServicoAfterPost(DataSet: TDataSet);
    procedure BBAjudaClick(Sender: TObject);
    procedure DBEditNumerico2Exit(Sender: TObject);
  private
    { Private declarations }
    VprDescricao, VprCodigo : String;
    UnCla : TFuncoesClassificacao;
    Servicos : TFuncoesServico;
    VprInseriu : Boolean;
    function LocalizaClassificacao : Boolean;
  public
    function InsereNovoServico(VpaCodClassificacao: string;var VpaCodServico, VpaDescricao : string; ChamadaExterna: Boolean): Boolean;
    function AlteraServico(VpaCodClassificacao : String; var VpaCodServico, VpaDescricao : string; VpaAlterar: Boolean): Boolean;
  end;

var
  FNovoServico: TFNovoServico;

implementation

uses APrincipal, FunSql, funObjeto, constantes, ConstMsg,
     ALocalizaClassificacao;

{$R *.DFM}


{**********************ocorre na criação do formulario*************************}
procedure TFNovoServico.FormCreate(Sender: TObject);
begin
  UnCla := TFuncoesClassificacao.criar(self, FPrincipal.BaseDados);
  Self.HelpFile := Varia.PathHelp + 'MPONTOLOJA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
  Servicos := TFuncoesServico.Cria;
  AdicionaSQLAbreTabela(CadSErvico,'Select * from Cadservico ');
  if config.UsarCodFilServico then
    DBFilialColor1.ACodFilial := Varia.CodigoFilCadastro
  else
  begin
    DBEditNumerico2.Visible := true;
    DBFilialColor1.Visible := false;
  end;
end;

{********************ocorre quando o formulario é fechado**********************}
procedure TFNovoServico.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  CAdServico.Close;
  Action := Cafree;
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            Ações de camadas externas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{********************** inseri um novo servico ********************************}
function TFNovoServico.InsereNovoServico(VpaCodClassificacao: string;var VpaCodServico, VpaDescricao : string; ChamadaExterna: Boolean): Boolean;
begin
  try
    // carrega a mascara da classificacao
    ECodClassificacao.Field.EditMask := RetornaPicture(varia.mascaraCLASer, VpaCodClassificacao, '_');

    CadServico.Insert;
    BCla.Enabled := ChamadaExterna;
    ECodClassificacao.Enabled := ChamadaExterna;

    CadServicoC_COD_CLA.Value := VpaCodClassificacao;
    if not ChamadaExterna then
       LCla.Caption := UnCla.RetornaNomeClassificacao(VpaCodClassificacao,'S');

    if  ShowModal = MrOK Then
    begin
      VpaCodServico := VprCodigo;
      VpaDescricao  := VprDescricao;
      Result := True;
    end
    else
      result  := false;
  except
    Result := False;
    Aviso('Erro na inclusão do serviço.');
    CadServico.Cancel;
  end;
end;

{***************** altera o servico passado como parametro ********************}
function TFNovoServico.AlteraServico(VpaCodClassificacao : String; var VpaCodServico, VpaDescricao : string; VpaAlterar: Boolean): Boolean;
begin
  try
    ECodClassificacao.Field.EditMask := RetornaPicture(varia.mascaraCLASer, VpaCodClassificacao, '_');
    LCla.Caption := UnCla.RetornaNomeClassificacao(VpaCodClassificacao,'S');

    AdicionaSQLAbreTabela(CadServico,'Select * from CadServico ' +
                                     ' Where I_Cod_Emp = ' + IntToStr(Varia.CodigoEmpresa) +
                                     ' and I_Cod_Ser = ' + VpaCodServico);
    if not CadServico.Eof then
    begin
      if VpaAlterar then
      begin
        ActiveControl := Descricao;
        CadServico.Edit;
        if ShowModal =  mrOk Then
        begin
          VpaCodServico := VprCodigo;
          VpaDescricao := VprDescricao;
          Result := True;
        end
        else
        result := false;
      end
      else
      begin
        Descricao.Enabled := False;
        BGravar.Enabled := false;
        BCancelar.Enabled := False;
        ShowModal;
        Result := False;
      end;
    end
    else
    begin
      Aviso('Não foi possível localizar este serviço.');
      Result := False;
      Close;
    end;
  except
    Result := False;
    Aviso('Erro na alteração do serviço.');
    CadServico.Cancel;
  end;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            eventos da tabela servico
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{************** apo o evento de insercao da tabela de servico *****************}
procedure TFNovoServico.CadServicoAfterInsert(DataSet: TDataSet);
begin
  if config.UsarCodFilServico then
  begin
    DBFilialColor1.ProximoCodigo;
    DBFilialColor1.ReadOnly := false;
  end;
  CadServicoI_COD_EMP.AsInteger := Varia.CodigoEmpresa;
  CadServicoC_TIP_CLA.AsString := 'S';
  CadServicoC_Ati_Ser.Asstring := 'S';
  VprInseriu := true;
end;

{**************** nao permite alterar o codigo da classificacao ***************}
procedure TFNovoServico.CadServicoAfterEdit(DataSet: TDataSet);
begin
  if config.UsarCodFilServico then
    DBFilialColor1.ReadOnly := true
  else
    DBEditNumerico2.ReadOnly := true;  
  VprInseriu := false;
end;

{*********************** eventos antes de gravar ******************************}
procedure TFNovoServico.CadServicoBeforePost(DataSet: TDataSet);
begin
  CadServicoD_ULT_ALT.AsDateTime := Date;
  // guarda a descricao porque depois de gravado o registro é perdido
  VprDescricao := CadServicoC_Nom_Ser.Asstring;
  VprCodigo := CadServicoI_Cod_Ser.Asstring;
end;

{******************* eventos apos a gravacao da tabela ************************}
procedure TFNovoServico.CadServicoAfterPost(DataSet: TDataSet);
begin
  if VprInseriu then
    Servicos.AdicionaServicoNaTabelaPreco(CadServicoI_cod_Ser.AsInteger,varia.MoedaBase,
                                           varia.TabelaPrecoServico, 0, CurrencyString );

end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              eventos da classificacao
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{************************ localiza a classificacao ****************************}
procedure TFNovoServico.ECodClassificacaoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = 114 then
    LocalizaClassificacao;
end;

{************* abre a localizacao das classificacao ************************* }
function TFNovoServico.LocalizaClassificacao : Boolean;
var
  VpfCodClassificacao, VpfDescricao : string;
begin
  result := true;
  FLocalizaClassificacao := TFLocalizaClassificacao.CriarSDI(application,'', true);
  if FLocalizaClassificacao.LocalizaClassificacao(VpfCodClassificacao, VpfDescricao, 'S') then
  begin
    CadServicoC_COD_CLA.AsString := VpfCodClassificacao;
    LCla. Caption := VpfDescricao;
  end
  else
    result := false;
end;

{******************* chama a localizacao da classificacao *********************}
procedure TFNovoServico.BClaClick(Sender: TObject);
begin
  LocalizaClassificacao;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                    eventos dos botoes inferiores
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{************************* fecha o formulario *********************************}
procedure TFNovoServico.BFecharClick(Sender: TObject);
begin
  close;
end;

{************************* grava o servico ************************************}
procedure TFNovoServico.BGravarClick(Sender: TObject);
begin
  CadServico.post;
end;

{************-************* cancela o servico ********************************}
procedure TFNovoServico.BCancelarClick(Sender: TObject);
begin
  CadServico.cancel;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{******************** quando o formulario é mostrado **************************}
procedure TFNovoServico.FormShow(Sender: TObject);
begin
  if ECodClassificacao.Enabled then
    ECodClassificacao.SetFocus
  else
    if not DBFilialColor1.ReadOnly Then
      if DBFilialColor1.Visible then
       DBFilialColor1.SetFocus
      else
       DBEditNumerico2.SetFocus;
end;

{****************************Valida a gravacao*********************************}
procedure TFNovoServico.DBEditLocaliza1Change(Sender: TObject);
begin
  if CadServico.State in [ dsInsert, dsEdit ] then
     ValidaGravacao1.execute;
end;

procedure TFNovoServico.DBEditColor1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not(key in [78,83,8,9,46]) Then
    key := 0
end;

procedure TFNovoServico.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FNovoServico.HelpContext);
end;

procedure TFNovoServico.DBEditNumerico2Exit(Sender: TObject);
begin
  if CadServico.State = dsInsert then
    if Servicos.VerificasExisteServico(CadServicoI_COD_SER.AsInteger) then
    begin
      DBEditNumerico2.SetFocus;
      aviso(CT_CodServicoRepetido);
    end;
end;

end.
