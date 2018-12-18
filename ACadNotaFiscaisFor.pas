unit ACadNotaFiscaisFor;
{          Função: Notas fiscais de entrada
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Db, DBTables, Tabela, StdCtrls, Mask, DBCtrls, Componentes1, ExtCtrls,
  PainelGradiente,  Buttons, Grids, DBGrids, Constantes,ConstMsg,
  BotaoCadastro, DBKeyViolation, Localizacao, ConvUnidade, UnProdutos, UnNotasFiscaisFor,
  Spin, numericos, UnContasapagar;

type
  TFCadNotaFiscaisFor = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    Label1: TLabel;
    DBEditColor1: TDBEditColor;
    Label2: TLabel;
    DBEditColor2: TDBEditColor;
    Label5: TLabel;
    Label6: TLabel;
    DBEditColor6: TDBEditColor;
    Panel1: TPanel;
    BotaoCadastrar1: TBotaoCadastrar;
    BotaoGravar1: TBotaoGravar;
    Shape1: TShape;
    Label3: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    DBEditColor9: TDBEditColor;
    Shape3: TShape;
    Label10: TLabel;
    DBEditColor10: TDBEditColor;
    DBEditColor11: TDBEditColor;
    Shape4: TShape;
    Label12: TLabel;
    DBMemoColor1: TDBMemoColor;
    Shape5: TShape;
    Label15: TLabel;
    Label16: TLabel;
    DBEditColor12: TDBEditColor;
    DBEditColor13: TDBEditColor;
    Label17: TLabel;
    DBEditColor14: TDBEditColor;
    Label18: TLabel;
    DBEditColor15: TDBEditColor;
    Label19: TLabel;
    Label20: TLabel;
    Label22: TLabel;
    DBEditColor16: TDBEditColor;
    DBEditColor17: TDBEditColor;
    DBEditColor19: TDBEditColor;
    Label24: TLabel;
    Shape6: TShape;
    Grade: TDBGridColor;
    Shape2: TShape;
    Label28: TLabel;
    Label29: TLabel;
    DBEditColor3: TDBEditColor;
    DataCadNotasFiscais: TDataSource;
    cadNotasFiscais: TSQL;
    Label13: TLabel;
    MovNotasFiscais: TQuery;
    DataMovNotasFiscais: TDataSource;
    MovNotasFiscaisI_EMP_FIL: TIntegerField;
    MovNotasFiscaisI_SEQ_NOT: TIntegerField;
    MovNotasFiscaisN_VLR_PRO: TFloatField;
    MovNotasFiscaisN_PER_ICM: TFloatField;
    MovNotasFiscaisN_PER_IPI: TFloatField;
    MovNotasFiscaisN_TOT_PRO: TFloatField;
    CadProdutos: TQuery;
    MovNotasFiscaisI_SEQ_MOV: TIntegerField;
    MovNotasFiscaisC_COD_UNI: TStringField;
    Label30: TLabel;
    DBEditColor4: TDBEditColor;
    Shape7: TShape;
    Label11: TLabel;
    Label21: TLabel;
    Shape8: TShape;
    Shape9: TShape;
    Shape10: TShape;
    Shape11: TShape;
    Shape12: TShape;
    MovNotasFiscaisC_COD_CST: TStringField;
    DBEditLocaliza1: TDBEditLocaliza;
    EditLocaliza1: TEditLocaliza;
    Shape13: TShape;
    Shape14: TShape;
    Shape15: TShape;
    DBEditLocaliza2: TDBEditLocaliza;
    Label7: TLabel;
    Shape16: TShape;
    Emi: TRadioButton;
    des: TRadioButton;
    BCancela: TBitBtn;
    Label25: TLabel;
    AutoCalculo: TCheckBox;
    ICMS1: TICMS;
    Tempo: TPainelTempo;
    BFechar: TBitBtn;
    cadNotasFiscaisI_EMP_FIL: TIntegerField;
    cadNotasFiscaisI_COD_CLI: TIntegerField;
    cadNotasFiscaisI_SEQ_NOT: TIntegerField;
    cadNotasFiscaisI_NRO_NOT: TIntegerField;
    cadNotasFiscaisI_COD_TRA: TIntegerField;
    cadNotasFiscaisD_DAT_EMI: TDateField;
    cadNotasFiscaisD_DAT_SAI: TDateField;
    cadNotasFiscaisL_OBS_NOT: TMemoField;
    cadNotasFiscaisI_TIP_FRE: TIntegerField;
    cadNotasFiscaisN_BAS_CAL: TFloatField;
    cadNotasFiscaisN_VLR_ICM: TFloatField;
    cadNotasFiscaisN_BAS_SUB: TFloatField;
    cadNotasFiscaisN_VLR_SUB: TFloatField;
    cadNotasFiscaisN_TOT_PRO: TFloatField;
    cadNotasFiscaisN_VLR_FRE: TFloatField;
    cadNotasFiscaisN_VLR_SEG: TFloatField;
    cadNotasFiscaisN_OUT_DES: TFloatField;
    cadNotasFiscaisN_TOT_IPI: TFloatField;
    cadNotasFiscaisN_TOT_NOT: TFloatField;
    cadNotasFiscaisC_SER_NOT: TStringField;
    cadNotasFiscaisN_VLR_DES: TFloatField;
    MovNotasFiscaisC_CLA_FIS: TStringField;
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    ValidaGravacao1: TValidaGravacao;
    DelFormaPgto: TEditLocaliza;
    SpeedButton2: TSpeedButton;
    Label9: TLabel;
    Label14: TLabel;
    Shape17: TShape;
    cadNotasFiscaisI_COD_OPE: TIntegerField;
    MovNotasFiscaisI_SEQ_PRO: TIntegerField;
    MovNotasFiscaisC_COD_PRO: TStringField;
    MovNotasFiscaisNomeProduto: TStringField;
    Localiza: TConsultaPadrao;
    PanelColor2: TPanelColor;
    Label31: TLabel;
    DBEditColor5: TDBEditColor;
    Shape18: TShape;
    DBRadioGroup1: TDBRadioGroup;
    DBRadioGroup2: TDBRadioGroup;
    Shape19: TShape;
    cadNotasFiscaisC_DES_ACR: TStringField;
    cadNotasFiscaisC_VLR_PER: TStringField;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    SpinEditColor1: TSpinEditColor;
    SpinEditColor2: TSpinEditColor;
    Label23: TLabel;
    Label26: TLabel;
    LDescAcre: TLabel;
    Label27: TLabel;
    Shape20: TShape;
    SpeedButton4: TSpeedButton;
    EPlano: TEditColor;
    Label32: TLabel;
    SpeedButton5: TSpeedButton;
    Label33: TLabel;
    MovNatureza: TQuery;
    Shape21: TShape;
    MovNotasFiscaisC_COD_NAT: TStringField;
    MovNotasFiscaisN_QTD_PRO: TFloatField;
    cadNotasFiscaisD_ULT_ALT: TDateField;
    MovNotasFiscaisD_ULT_ALT: TDateField;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cadNotasFiscaisAfterInsert(DataSet: TDataSet);
    procedure MovNotasFiscaisAfterInsert(DataSet: TDataSet);
    procedure GradeColExit(Sender: TObject);
    procedure cadNotasFiscaisAfterPost(DataSet: TDataSet);
    procedure GradeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MovNotasFiscaisBeforePost(DataSet: TDataSet);
    procedure MovNotasFiscaisAfterPost(DataSet: TDataSet);
    function LocalizaProduto( CodigoProduto : string; LocalizaF3 : Boolean  ) : Boolean;
    procedure DBEditColor11Exit(Sender: TObject);
    procedure cadNotasFiscaisAfterEdit(DataSet: TDataSet);
    procedure MovNotasFiscaisBeforeEdit(DataSet: TDataSet);
    procedure DBEditLocaliza1Retorno(Retorno1, Retorno2: String);
    procedure MovNotasFiscaisC_COD_UNISetText(Sender: TField;
      const Text: String);
    procedure MovNotasFiscaisBeforeCancel(DataSet: TDataSet);
    procedure iChange(Sender: TField);
    procedure EmiClick(Sender: TObject);
    procedure BCancelaClick(Sender: TObject);
    procedure GradeEnter(Sender: TObject);
    procedure GradeExit(Sender: TObject);
    procedure AutoCalculoClick(Sender: TObject);
    procedure BFecharClick(Sender: TObject);
    procedure DBEditLocaliza1Cadastrar(Sender: TObject);
    procedure DBEditLocaliza2Cadastrar(Sender: TObject);
    procedure DBEditColor1Change(Sender: TObject);
    procedure DelFormaPgtoCadastrar(Sender: TObject);
    procedure EditLocaliza1Cadastrar(Sender: TObject);
    procedure LocalizaCadastrar(Sender: TObject);
    procedure GradeColEnter(Sender: TObject);
    procedure GradeKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure DBRadioGroup2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BotaoCadastrar1AntesAtividade(Sender: TObject);
    procedure BotaoGravar1DepoisAtividade(Sender: TObject);
    procedure EditLocaliza1Retorno(Retorno1, Retorno2: String);
    procedure EPlanoExit(Sender: TObject);
    procedure EPlanoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DelFormaPgtoRetorno(Retorno1, Retorno2: String);
    procedure cadNotasFiscaisBeforePost(DataSet: TDataSet);
    procedure BBAjudaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    UnProduto : TFuncoesProduto;
    UnNF : TFuncoesNFFor;
    UnCP : TFuncoesContasAPagar;
    atualizar : Boolean;
    CodigoAtual : String;
    ICMSPadrao : Double;
    UnidadeAtual, TipoDaFormaPagto : string;
    TextosCodigoProduto : string;
    ItemNatureza : Integer;
    procedure CalculaNota;
    procedure LimpaLocalizas;
    procedure Atualizacoes;
    procedure MontaTextoDescontoAcresimo;
  public
    procedure ConsultaNotaFiscal( SeqNota : Integer);
  end;

var
  FCadNotaFiscaisFor: TFCadNotaFiscaisFor;

implementation

uses APrincipal, fundata, funstring, ANovoCliente,
    ANovaTransportadora, AOperacoesEstoques, ANovoProduto, funsql,
   ANovaNatureza, APlanoConta, AMostraParPagar, funobjeto;

{$R *.DFM}

{ ****************** Na criação do Formulário ******************************** }
procedure TFCadNotaFiscaisFor.FormCreate(Sender: TObject);
begin
//  MudaMacaraEdicaoDisplay([MovNotasFiscaisN_QTD_PRO], varia.mascaraQTD);
//  MudaMacaraEdicaoDisplay([MovNotasFiscaisN_VLR_PRO], varia.MascaraCusto);

  TextosCodigoProduto := '1';
  UnProduto := TFuncoesProduto.criar(self,FPrincipal.BaseDados);
  UnNF := TFuncoesNFFor.criar(self,FPrincipal.BaseDados);
  UnCP := TFuncoesContasAPagar.criar(self,FPrincipal.BaseDados);
  Label28.Caption := varia.NomeFilial;
  AbreTabela(CadNotasFiscais);
  atualizar := false;
//  UnProduto.LocalizaProdutoEmpresa(CadProdutos);
end;

{*********************Quando o formulario e fechado****************************}
procedure TFCadNotaFiscaisFor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UnProduto.free;
  UnNF.free;
  UnCP.Free;
  FechaTabela(MovNatureza);
  FechaTabela(CadNotasFiscais);
  FechaTabela(MovNotasFiscais);
  FechaTabela(CadProdutos);
  Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                           cabecalho da nota fiscal for
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{************* cadastra nova natureza de operacao *************************** }
procedure TFCadNotaFiscaisFor.EditLocaliza1Cadastrar(Sender: TObject);
begin
  FNovaNatureza := TFNovaNatureza.CriarSDI(Application,'',FPrincipal.VerificaPermisao('FNovaNatureza'));
  FNovaNatureza.CadNaturezas.Insert;
  FNovaNatureza.ShowModal;
  Localiza.AtualizaConsulta;
end;

{************************Cadastra um novo cliente******************************}
procedure TFCadNotaFiscaisFor.DBEditLocaliza1Cadastrar(Sender: TObject);
begin
   FNovoCliente := TFNovoCliente.CriarSDI(application,'',true);
   FNovoCliente.CadClientes.Insert;
   FNovoCliente.CadClientesC_TIP_CAD.AsString := 'F';
   FNovoCliente.ShowModal;
   Localiza.AtualizaConsulta;
end;

{****************Retorna se o fornecedor é fisico ou jurídico******************}
procedure TFCadNotaFiscaisFor.DBEditLocaliza1Retorno(Retorno1,
  Retorno2: String);
begin
   if Retorno2 <> '' then
     if (retorno2 = 'J') then
        ICMSPAdrao := ICMS1.ICMS(Retorno1,varia.EstadoPadrao,true)
     else
        if (retorno2 = 'F') then
           ICMSPAdrao := ICMS1.ICMS(Retorno1,varia.EstadoPadrao,false);
end;

{***************************Valida a gravacao**********************************}
procedure TFCadNotaFiscaisFor.DBEditColor1Change(Sender: TObject);
begin
  ValidaGravacao1.execute;
end;

{*************************Atualiza os localizas********************************}
procedure TFCadNotaFiscaisFor.LimpaLocalizas;
begin
   EditLocaliza1.Limpa;
   DBEditLocaliza1.limpa;
   DelFormaPgto.Limpa;
   EPlano.Text := '';
end;

{**********************Cadastra uma nova operação de Estoque*******************}
procedure TFCadNotaFiscaisFor.DelFormaPgtoCadastrar(Sender: TObject);
begin
   FOperacoesEstoques := TFOperacoesEstoques.CriarSDI(Application,'',FPrincipal.VerificaPermisao('FOperacoesEstoques'));
   FOperacoesEstoques.BotaoCadastrar1.Click;
   FOperacoesEstoques.showmodal;
   Localiza.AtualizaConsulta;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                           Ações do CadNotasFiscais
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***********************Gera o proximo codigo disponível***********************}
procedure TFCadNotaFiscaisFor.cadNotasFiscaisAfterInsert(
  DataSet: TDataSet);
begin
   cadNotasFiscaisI_EMP_FIL.AsInteger := varia.CodigoEmpFil;
   cadNotasFiscaisD_DAT_EMI.AsDateTime := date;
   cadNotasFiscaisD_DAT_SAI.AsDateTime := date;
   cadNotasFiscaisC_VLR_PER.AsString := 'V';
   cadNotasFiscaisC_DES_ACR.AsString := 'A';
   CadNotasFiscaisI_TIP_FRE.Value := 1;
   Emi.Checked := true;
   DataMovNotasFiscais.AutoEdit := True;
   BCancela.Enabled := true;
   BFechar.Enabled := false;
   BotaoGravar1.Enabled := false;
   LimpaLocalizas;
end;


{******************************Atualiza a tabela*******************************}
procedure TFCadNotaFiscaisFor.cadNotasFiscaisAfterPost(DataSet: TDataSet);
begin
   BCancela.Enabled := false;
   BFechar.Enabled := true;
end;

{*************************Arruma o estado dos botões***************************}
procedure TFCadNotaFiscaisFor.cadNotasFiscaisAfterEdit(DataSet: TDataSet);
begin
   BCancela.Enabled := true;
   BFechar.Enabled := false;
   BotaoGravar1.Enabled := true;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações do MovNotasfiscais
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{************************Valida a unidade digitada*****************************}
procedure TFCadNotaFiscaisFor.MovNotasFiscaisC_COD_UNISetText(
  Sender: TField; const Text: String);
begin
   if UnProduto.ValidaUnidade.ValidaUnidade(text,UnidadeAtual) then
     sender.Value := text
   else
     abort;
end;

{****************************Calcula o valor Total*****************************}
procedure TFCadNotaFiscaisFor.iChange(
  Sender: TField);
begin
   MovNotasFiscaisN_TOT_PRO.AsCurrency := MovNotasFiscaisN_QTD_PRO.AsCurrency * MovNotasFiscaisN_VLR_PRO.AsCurrency;
end;

{******************* ANTES EDITAR um item do mov notas fiscias ***************}
procedure TFCadNotaFiscaisFor.MovNotasFiscaisBeforeEdit(DataSet: TDataSet);
begin
   UnidadeAtual := MovNotasFiscaisC_COD_UNI.AsString;   // guarda a moeda atual
   CodigoAtual := MovNotasFiscaisC_COD_PRO.AsString;
   Grade.Columns[5].PickList := UnProduto.validaUnidade.UnidadesParentes(MovNotasFiscaisC_COD_UNI.AsString);
end;

{***************** ANTES CANCELAR mov notas fiscias 88************************}
procedure TFCadNotaFiscaisFor.MovNotasFiscaisBeforeCancel(
  DataSet: TDataSet);
begin
   grade.Columns[5].PickList.Clear;
end;


{************** DEPOIS INSERT nos produtos adiciona empresa e codigos *********}
procedure TFCadNotaFiscaisFor.MovNotasFiscaisAfterInsert(
  DataSet: TDataSet);
begin
   MovNotasFiscaisI_EMP_FIL.Value := varia.CodigoEmpFil;
   MovNotasFiscaisI_SEQ_NOT.Value := CadNotasFiscaisI_SEQ_NOT.Value;
   MovNotasFiscaisC_COD_NAT.Value := EditLocaliza1.text;
   MovNotasFiscaisN_PER_ICM.Value := ICMSPAdrao;
   MovNotasFiscaisN_PER_IPI.Value := 0;
   Atualizar := True;
   Grade.SelectedIndex := 0;
   CodigoAtual := '';
end;

{************************* ANTES POST faz validacoes *************************}
procedure TFCadNotaFiscaisFor.MovNotasFiscaisBeforePost(DataSet: TDataSet);
begin
  //atualiza a data de alteracao para poder exportar
  MovNotasFiscaisD_ULT_ALT.AsDateTime := Date;

  if (not LocalizaProduto(MovNotasFiscaisC_COD_PRO.AsString, false)) then
    abort;
  if (MovNotasFiscaisN_QTD_PRO.IsNull) or (MovNotasFiscaisN_VLR_PRO.IsNull) then
  begin
    aviso(CT_ValorQdadeNulo);
    abort;
  end;

  if not FPrincipal.BaseDados.InTransaction then
    FPrincipal.BaseDados.StartTransaction;
  MovNotasFiscaisI_SEQ_MOV.AsInteger := ProximoCodigoFilial('movnotasfiscaisfor','i_seq_mov','i_emp_fil',varia.CodigoEmpFil,FPrincipal.BaseDados);
  if FPrincipal.BaseDados.InTransaction then
    FPrincipal.BaseDados.Commit;

end;

{*********************** DEPOIS POST atualiza tabela *************************}
procedure TFCadNotaFiscaisFor.MovNotasFiscaisAfterPost(DataSet: TDataSet);
begin
   if Atualizar then
   begin
      MovNotasFiscais.DisableControls;
      MovNotasFiscais.CLOSE;
      MovNotasFiscais.OPEN;
      MovNotasFiscais.EnableControls;
      atualizar := false;
   end;
   grade.Columns[5].PickList.Clear;
   CalculaNota;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Tratamento do Grid
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}


{***************** guarda o codigo do produto atual ************************* }
procedure TFCadNotaFiscaisFor.GradeColEnter(Sender: TObject);
begin
if grade.Columns.Grid.SelectedIndex = 0 then
  CodigoAtual := MovNotasFiscaisC_COD_PRO.AsString;
end;

{***************************localiza codigo de produto*************************}
function TFCadNotaFiscaisFor.LocalizaProduto( CodigoProduto : string; LocalizaF3 : Boolean ) : Boolean;
var
  claFis, unidade, codpro, sequencialPro : string;
begin
  result := true;
  if (CodigoProduto <> CodigoAtual) or (CodigoProduto = '' ) or (LocalizaF3) then
  begin
    codpro := CodigoProduto;

    if not UnNF.LocalizaProduto( CodPro,claFis, unidade, sequencialPro, LocalizaF3,
                                FPrincipal.CorForm, FPrincipal.CorFoco, FPrincipal.CorPainelGra ) then
      result := false;

    if not (MovNotasFiscais.State in [ dsEdit, dsInsert]) then
       MovNotasFiscais.Edit;

       MovNotasFiscais.FieldByName('C_Cla_Fis').AsString := claFis;
       MovNotasFiscais.FieldByName('C_Cod_Uni').AsString := unidade;
       MovNotasFiscais.FieldByName('C_Cod_Pro').AsString := codpro;
       MovNotasFiscais.FieldByName('I_SEQ_PRO').AsInteger := StrToInt(sequencialPro);
       TextosCodigoProduto := TextosCodigoProduto + ', ' + MovNotasFiscais.FieldByName('I_SEQ_PRO').AsString;
       UnNF.LocalizaProdutoCodigos(CadProdutos, TextosCodigoProduto );

       Grade.Columns[5].PickList := unProduto.validaUnidade.UnidadesParentes(unidade);
       UnidadeAtual := unidade;
  end;
end;

{**********************verifica a coluna do grid para validacao****************}
procedure TFCadNotaFiscaisFor.GradeColExit(Sender: TObject);
begin
   if ( MovNotasFiscais.State in [dsInsert,dsEdit]) then
      case grade.Columns.Grid.SelectedIndex of
         0 : begin
               if not LocalizaProduto(MovNotasFiscaisC_COD_PRO.AsString, false) then // valida o campo codigo caso esteja vazio
                 abort;

                  TextosCodigoProduto := TextosCodigoProduto + ', ' + MovNotasFiscais.FieldByName('I_SEQ_PRO').AsString;
                  UnNF.LocalizaProdutoCodigos(CadProdutos, TextosCodigoProduto );


                 if MovNotasFiscaisC_COD_PRO.AsString <> CodigoAtual then  // verifica pedido repetido  codigo atual carrega na edicao
                 begin
                    if UnNF.VerificaItemNotaRepetido(cadNotasFiscaisI_SEQ_NOT.AsInteger,
                                                     MovNotasFiscaisI_SEQ_PRO.AsInteger ) then
                    begin
                      Grade.SelectedIndex := 0;
                      Abort;
                    end;
                 end;

             end;
      end;
      CodigoAtual := MovNotasFiscaisC_COD_PRO.AsString;
end;

{*************************quando precionado um tecla***************************}
procedure TFCadNotaFiscaisFor.GradeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not Grade.ReadOnly then
  begin
     if (not MovNotasFiscais.IsEmpty) and (key = 46) and
        (MovNotasFiscais.State = dsBrowse) then // para deletar um item
        if Confirmacao(CT_DeletarItem) Then
        begin
          MovNotasFiscais.Delete;
          calculaNota;
        end;

     if ((MovNotasFiscais.State= dsInsert) and ( KEY = 9 ))  and (grade.Columns.Grid.SelectedIndex = 10)  then  // para adicionar um novo registro   tab na ultima coluna
     begin
      MovNotasFiscais.post;
      MovNotasFiscais.append;
      key := 0;
     end;

     if (MovNotasFiscais.State= dsInsert) and ( KEY = 38 ) then  // para voltar um registro quado estiver no ultim em insercao
     begin
      MovNotasFiscais.post;
      MovNotasFiscais.Last;
     end;

     if ( shift = [ssAlt]) and ( key = 88 ) then  // alt x para ir a parte inferior da nota
     begin
        if (MovNotasFiscaisC_COD_PRO.IsNull) then
           MovNotasFiscais.Cancel;
        DBEditcolor12.SetFocus;
     end;

     if ( shift = [ssAlt]) and ( key = 90 )  then  // alt z para ir a parte superior da nota
     begin
       if (MovNotasFiscaisC_COD_PRO.IsNull) then
          MovNotasFiscais.Cancel;
       DBEditLocaliza1.SetFocus;
     end;

     if (Key = 114)  and (grade.Columns.Grid.SelectedIndex = 0) then  // localiza Materia Prima
       LocalizaProduto(MovNotasFiscaisC_COD_PRO.AsString, true);
  end;
end;

{*************** altera ponto para ponto e virgula ************************** }
procedure TFCadNotaFiscaisFor.GradeKeyPress(Sender: TObject;
  var Key: Char);
begin
 if key = '.' then
   key := ',';
end;

{****************************Quando entra da grade*****************************}
procedure TFCadNotaFiscaisFor.GradeEnter(Sender: TObject);
var
  seqNota : integer;
begin
   if (not Grade.ReadOnly) and (cadNotasFiscais.Active) then
   begin
     if (DBEditColor1.Field.IsNull) or (DBEditColor6.Field.IsNull) or
        ( DBEditLocaliza1.Field.IsNull) or (DelFormaPgto.text = '') or
        (EditLocaliza1.Text = '') or (EPlano.text = '')  then
     begin
        aviso(CT_FaltaDadosNroNota);
        DBEditColor1.SetFocus;
     end
     else
        if CadNotasFiscais.State = dsInsert then
        begin
          // gera codigo sequencial da nota
          if not FPrincipal.BaseDados.InTransaction then
            FPrincipal.BaseDados.StartTransaction;
          cadNotasFiscaisI_SEQ_NOT.AsInteger := ProximoCodigoFilial('CadNotaFiscaisfor','I_SEQ_NOT','i_emp_fil',varia.CodigoEmpFil,FPrincipal.BaseDados);
          SeqNota := CadNotasFiscaisI_SEQ_NOT.AsInteger;
          CadNotasFiscais.Post;
          if FPrincipal.BaseDados.InTransaction then
            FPrincipal.BaseDados.Commit;

           MarcaTransacao(4,CadNotasFiscaisI_SEQ_NOT.AsInteger,varia.CodigoEmpFil);

          UnNF.LocalizaCadNotaFiscal(cadNotasFiscais, SeqNota);
          unNF.LocalizaMovNotaFiscal(MovNotasFiscais, SeqNota);
          CadNotasFiscais.Edit;
        end;
     grade.SelectedIndex := 0;
   end;  
end;

{******************************Quando sai da grade*****************************}
procedure TFCadNotaFiscaisFor.GradeExit(Sender: TObject);
begin
If MovNotasFiscais.State in [ dsInsert, dsEdit] then
try
  MovNotasFiscais.Post;
except
  MovNotasFiscais.cancel;
end;
CalculaNota;
end;

{************* cadastra novo produto ************************************** }
procedure TFCadNotaFiscaisFor.LocalizaCadastrar(Sender: TObject);
begin
FNovoProduto := TFNovoProduto.CriarSDI(application,'',true);
FNovoProduto.InsereNovoProduto(true);
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            calculos da nota
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{**************************Calcula o valor da nota*****************************}
procedure TFCadNotaFiscaisFor.CalculaNota;
var
  icms, ipi, TotalProduto, TotalNota : double;
begin
  if cadNotasFiscais.State in [ dsEdit, dsInsert ] then
    if (MovNotasFiscais.Active) and (not MovNotasFiscais.IsEmpty)  then
    begin
      UnNF.CalculaNota( cadNotasFiscaisn_vlr_des.AsFloat, cadNotasFiscaisN_VLR_FRE.AsFloat,
                        cadNotasFiscaisN_VLR_SEG.AsFloat, cadNotasFiscaisN_OUT_DES.AsFloat,
                        ICMSPadrao,cadNotasFiscaisI_SEQ_NOT.AsInteger,emi.Checked,
                        icms,ipi,totalProduto,TotalNota,cadNotasFiscaisC_DES_ACR.AsString,
                        cadNotasFiscaisC_VLR_PER.AsString );

      CadNotasFiscaisN_VLR_ICM.Value := icms;

      CadNotasFiscaisN_TOT_PRO.Value := TotalProduto;

      CadNotasFiscaisN_TOT_NOT.Value := TotalNota;

      CadNotasFiscaisN_BAS_CAL.Value := TotalNota - ipi;

      CadNotasFiscaisN_TOT_IPI.Value := ipi;
    end;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                          Ações dos botões Inferiores
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***********************Quando for clicado no autoCalculo**********************}
procedure TFCadNotaFiscaisFor.AutoCalculoClick(Sender: TObject);
begin
   if autocalculo.Checked then
     CalculaNota;
   DBEditColor12.ReadOnly := Autocalculo.Checked;
   DBEditColor13.ReadOnly := Autocalculo.Checked;
   DBEditColor17.ReadOnly := Autocalculo.Checked;
   DBEditColor19.ReadOnly := Autocalculo.Checked;
   DBEditColor4.ReadOnly := Autocalculo.Checked;
end;

{***********************Quando é cancelado a nota******************************}
procedure TFCadNotaFiscaisFor.BCancelaClick(Sender: TObject);
begin
   FechaTabela(CadNotasFiscais);
   FechaTabela(MovNotasFiscais);
   UnNF.DeletaNotaFiscalFor(cadNotasFiscaisI_SEQ_NOT.AsInteger);
   BCancela.Enabled := False;
   BFechar.Enabled := True;
   BotaoGravar1.Enabled := False;
   BotaoCadastrar1.Enabled := True;
   LimpaLocalizas;
   DesmarcaTransacao(4);
end;

{****************************Fecha o Formulario corrente***********************}
procedure TFCadNotaFiscaisFor.BFecharClick(Sender: TObject);
begin
close;
end;

{*******************Cadastra uma nova transportadora***************************}
procedure TFCadNotaFiscaisFor.DBEditLocaliza2Cadastrar(Sender: TObject);
begin
   FNovaTransportadora := TFNovaTransportadora.CriarSDI(Application,'',true);
   FNovaTransportadora.CadTransportadoras.Insert;
   FNovaTransportadora.ShowModal;
   Localiza.AtualizaConsulta;
end;

{************ antes cadastrar verifica se a tabela esta aberta ************** }
procedure TFCadNotaFiscaisFor.BotaoCadastrar1AntesAtividade(
  Sender: TObject);
var
  SeqExcluir, FilialExcluir : integer;
begin
 if VerificaTransacao(4,SeqExcluir, FilialExcluir) then
 begin
   UnNF.Exclui_cancelaNotaFiscalDireto(SeqExcluir, FilialExcluir);
   DesmarcaTransacao(4);
 end;

  if  FPrincipal.BaseDados.InTransaction then
    FPrincipal.BaseDados.Rollback;

  if not cadNotasFiscais.Active then
    cadNotasFiscais.open;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***************************Chama o calcla nota********************************}
procedure TFCadNotaFiscaisFor.DBEditColor11Exit(Sender: TObject);
begin
   CalculaNota;
end;

{********************Quando é alterado quem pagara o frete*********************}
procedure TFCadNotaFiscaisFor.EmiClick(Sender: TObject);
begin
   if cadNotasFiscais.State in [ dsInsert, dsEdit ] then
      if Emi.Checked then
        CadNotasFiscaisI_TIP_FRE.Value := 1
      else
        if des.Checked then
          CadNotasFiscaisI_TIP_FRE.Value := 2;
   CalculaNota;
end;

{****** pemite alterar o foco com f4 **************************************** }
procedure TFCadNotaFiscaisFor.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  laco, tag : integer;
begin
  tag := 0;
  if key = 115 then
  begin
    for laco := 0 to PanelColor1.ControlCount - 1 do
     if (PanelColor1.Controls[laco] is TWinControl) then
       if (PanelColor1.Controls[laco] as TWinControl).Focused then
         tag := (PanelColor1.Controls[laco] as TWinControl).Tag;
    case tag of
      1 : Grade.SetFocus;
      2 : DBEditColor12.SetFocus;
      3 : DBEditColor1.SetFocus;
    end
  end;
  if key = 116 then
    BitBtn2.Click;
end;

{************** atualiza estoque, fornecedore, contas a pagar *************** }
procedure TFCadNotaFiscaisFor.Atualizacoes;
var
  Unidade : string;
  Dado : TDadosNovaContaCP;
  FormaPAgto, lancamentoCP : Integer;
  ValorFinal, Valorpago, Frete : Double;

begin

  MovNotasFiscais.DisableControls;
  // atualiza estoque
  if MovNatureza.fieldByname('C_BAI_EST').AsString = 'S' then
  begin
    Tempo.execute('Atualizando Estoque Produto...');
    MovNotasFiscais.First;
    while not MovNotasFiscais.Eof do
    begin
      Unidade := UnProduto.UnidadePadrao(MovNotasFiscaisI_SEQ_PRO.AsInteger);
      UnProduto.BaixaProdutoEstoque( MovNotasFiscaisI_SEQ_PRO.AsInteger, cadNotasFiscaisI_COD_OPE.AsInteger,
                                     MovNotasFiscaisI_SEQ_NOT.AsInteger, cadNotasFiscaisI_NRO_NOT.AsInteger,
                                     varia.MoedaBase,0, cadNotasFiscaisD_DAT_EMI.AsDateTime, MovNotasFiscaisN_QTD_PRO.AsFloat,
                                     MovNotasFiscaisN_TOT_PRO.AsFloat, MovNotasFiscaisC_COD_UNI.AsString,
                                     unidade);
      MovNotasFiscais.Next;
    end;
    Tempo.fecha;
  end;

  Tempo.execute('Atualizando Produto Fornecedores...');
  MovNotasFiscais.First;
  while not MovNotasFiscais.Eof do
  begin
    UnNF.AdicionaFornecedor( MovNotasFiscaisI_SEQ_PRO.AsInteger, cadNotasFiscaisI_SEQ_NOT.AsInteger,
                             cadNotasFiscaisI_COD_CLI.AsInteger,
                             SpinEditColor2.Value, SpinEditColor1.value, cadNotasFiscaisD_DAT_EMI.AsDateTime,
                             MovNotasFiscaisN_QTD_PRO.AsFloat, MovNotasFiscaisN_TOT_PRO.AsFloat,
                             MovNotasFiscaisC_COD_UNI.AsString);
    MovNotasFiscais.Next;
  end;

  if ConfigModulos.ContasAPagar then
  begin
    if (Config.GerarContasAPAgar) and (MovNatureza. FieldbyName('C_GER_FIN').AsString = 'S') Then
    begin
      Tempo.execute('Gerando o Contas a Pagar...');
      Dado := TDadosNovaContaCP.Create;
      Dado.CodEmpFil := Varia.CodigoEmpFil;
      Dado.NroNota := cadNotasFiscaisI_NRO_NOT.AsInteger;
      Dado.SeqNota := cadNotasFiscaisI_SEQ_NOT.AsInteger;
      Dado.CodFornecedor := cadNotasFiscaisI_COD_CLI.AsInteger;
      Dado.CodFrmPagto :=  StrToInt(DelFormaPgto.text);
      Dado.CodMoeda := varia.MoedaBase;
      Dado.CodUsuario := varia.CodigoUsuario;
      Dado.DataMovto := date;
      Dado.DataBaixa := date;
      Dado.DataEmissao := cadNotasFiscaisD_DAT_EMI.AsDateTime;
      Dado.PlanoConta := EPlano.Text;
      Dado.PathFoto := '';
      Dado.NumeroParcela := SpinEditColor1.Value;
      Dado.ValorParcela :=  cadNotasFiscaisN_TOT_NOT.AsCurrency /SpinEditColor1.Value;
      Dado.QtdDiasPriVen := 0;
      Dado.QtdDiasDemaisVen := 30;
      Dado.PercentualDescAcr := 0;
      Dado.VerificarCaixa := true;
      Dado.BaixarConta := true;
      Dado.MostrarParcelas := true;
      Dado.TipoFrmPAgto := TipoDaFormaPagto;
      Dado.CodDespesaFixa := 0;
      Dado.ContaVinculada := 0;
      Dado.ParcelaVinculada := 0;
      lancamentoCP := UnCP.CriaContaPagar( dado,  ValorFinal, Valorpago, FormaPAgto, false );
      Tempo.fecha;
    end;
  end;


  if ConfigModulos.Custo then
  begin
    frete := 0;
    if (des.Checked) and (cadNotasFiscaisN_VLR_FRE.AsCurrency <> 0) then
    begin      // rateio do frete
      MovNotasFiscais.First;
      while not MovNotasFiscais.Eof do
      begin
        frete := frete + MovNotasFiscaisN_QTD_PRO.AsCurrency;
        MovNotasFiscais.next;
      end;
      frete := cadNotasFiscaisN_VLR_FRE.AsCurrency / frete;
    end;

    MovNotasFiscais.First;   // adiciona o valor de custo de compra
    while not MovNotasFiscais.Eof do
    begin
      UnProduto.CalculaCustoCompra(MovNotasFiscaisI_SEQ_PRO.AsInteger,
                                   CadNotasFiscaisN_TOT_NOT.AsCurrency,
                                   MOVNotasFiscaisN_PER_IPI.AsCurrency,
                                   MovNotasFiscaisN_PER_ICM.AsCurrency,
                                   frete);
      MovNotasFiscais.next;
    end;
  end;

  MovNotasFiscais.EnableControls;
  Tempo.fecha;
  DesmarcaTransacao(4);
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                         Desconto na nota fiscal
(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((}

{ ************** quando ok na tela de desconto ****************************** }
procedure TFCadNotaFiscaisFor.BitBtn1Click(Sender: TObject);
begin
  PanelColor2.Visible := false;
  MontaTextoDescontoAcresimo;
  CalculaNota;
end;

{ *************** mostra a tela de descontos ******************************* }
procedure TFCadNotaFiscaisFor.BitBtn2Click(Sender: TObject);
begin
PanelColor2.Visible := true;
DBEditColor5.SetFocus;
end;

{*************** muda a picture conforme o tipo de desconto **************** }
procedure TFCadNotaFiscaisFor.DBRadioGroup2Click(Sender: TObject);
begin
if DBRadioGroup2.ItemIndex = 0 then
  cadNotasFiscaisN_VLR_DES.DisplayFormat := Varia.MascaraMoeda
else
 cadNotasFiscaisN_VLR_DES.DisplayFormat := '##0.00 %'
end;


procedure TFCadNotaFiscaisFor.BotaoGravar1DepoisAtividade(Sender: TObject);
begin
  Atualizacoes;
  FechaTabela(CadNotasFiscais);
  FechaTabela(MovNotasFiscais);
  TextosCodigoProduto := '1';
  BotaoCadastrar1.SetFocus;
end;

procedure TFCadNotaFiscaisFor.MontaTextoDescontoAcresimo;
begin
  LDescAcre.Caption := '';
  if cadNotasFiscaisN_VLR_DES.AsInteger <> 0 then
  begin
    if cadNotasFiscaisC_DES_ACR.AsString = 'A' then
     LDescAcre.Caption := 'Acrescimo de '
    else
     LDescAcre.Caption := 'Desconto de ';

    if cadNotasFiscaisC_VLR_PER.AsString = 'V' then
      LDescAcre.caption := LDescAcre.caption + FormatFloat(varia.MascaraMoeda, cadNotasFiscaisN_VLR_DES.AsFloat)
    else
      LDescAcre.caption := LDescAcre.caption + FormatFloat(varia.MascaraValor, cadNotasFiscaisN_VLR_DES.AsFloat) + ' %';
  end;
end;

procedure TFCadNotaFiscaisFor.EditLocaliza1Retorno(Retorno1,
  Retorno2: String);
begin
  if Retorno1 <> '' then
    if cadNotasFiscais.State in [dsEdit, dsInsert ] then
    begin
      UnNF.LocalizaMovNatureza(MovNatureza, retorno1 );
      cadNotasFiscaisI_COD_OPE.AsInteger := MovNatureza.fieldByName('I_COD_OPE').AsInteger;

      label27.Caption := MovNatureza.fieldByName('C_DES_NOT').AsString;
   end;
end;

procedure TFCadNotaFiscaisFor.ConsultaNotaFiscal( SeqNota : Integer);
begin
  AdicionaSqlAbreTabela(CadProdutos,'Select * from CadProdutos Pro, MovnotasFiscaisFor mov ' +
                                    ' Where Mov.I_Seq_Not = '+ InttoStr(SeqNota) +
                                    ' and Mov.I_Emp_Fil = ' + IntTostr(Varia.CodigoEmpfil) +
                                    ' and mov.i_seq_pro is not null ' +
                                    ' and Mov.I_Seq_Pro = Pro.I_Seq_Pro ');
  UnNF.LocalizaCadNotaFiscal(cadNotasFiscais, SeqNota);
  UnNF.LocalizaMovNotaFiscal(MovNotasFiscais, SeqNota);
  DBEditLocaliza1.Atualiza;
  grade.ReadOnly := true;
  DBEditLocaliza2.Atualiza;
  DelFormaPgto.Atualiza;
  DataCadNotasFiscais.AutoEdit := false;
  DataMovNotasFiscais.AutoEdit := false;
  EditLocaliza1.text := MovNotasFiscaisC_COD_NAT.AsString;
  EditLocaliza1.Atualiza;
  BotaoCadastrar1.Enabled := false;
  BitBtn2.Enabled := false;
  BotaoGravar1.Enabled := false;
  EditLocaliza1.Enabled := false;
  SpeedButton4.Enabled := false;
  self.ShowModal;
end;

procedure TFCadNotaFiscaisFor.EPlanoExit(Sender: TObject);
var
  VpfCodigo : string;
begin
  FPlanoConta := TFPlanoConta.criarSDI(Self, '', True);
  VpfCodigo := EPlano.text;
  if not FPlanoConta.verificaCodigo( VpfCodigo, 'D', Label33, false,(Sender is TSpeedButton) ) then
    EPlano.SetFocus;
  EPlano.text := VpfCodigo;
end;

procedure TFCadNotaFiscaisFor.EPlanoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = 114 then
  EPlanoExit(SpeedButton5);
end;

procedure TFCadNotaFiscaisFor.DelFormaPgtoRetorno(Retorno1,
  Retorno2: String);
begin
  TipoDaFormaPagto := retorno1;
end;

{******************* antes de gravar o registro *******************************}
procedure TFCadNotaFiscaisFor.cadNotasFiscaisBeforePost(DataSet: TDataSet);
begin
  //atualiza a data de alteracao para poder exportar
  cadNotasFiscaisD_ULT_ALT.AsDateTime := Date;
end;

procedure TFCadNotaFiscaisFor.BBAjudaClick(Sender: TObject);
begin
    Application.HelpCommand(HELP_CONTEXT,FCadNotaFiscaisFor.HelpContext);
end;

procedure TFCadNotaFiscaisFor.FormShow(Sender: TObject);
begin
    Self.HelpFile := Varia.PathHelp + 'MEstoqueCusto.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
end;

Initialization
{***************Registra a classe para evitar duplicidade**********************}
   RegisterClasses([TFCadNotaFiscaisFor]);
end.
