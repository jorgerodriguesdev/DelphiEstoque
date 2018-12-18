unit ACadCompras;

//                Autor: Leonardo Emanuel Pretti
//      Data da Criação: 20/08/2001
//               Função: Cadastrar uma Ordem de Compras
//         Alterado por:
//    Data da Alteração:
//  Motivo da Alteração:

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  ExtCtrls, PainelGradiente, ConstMsg, StdCtrls, Buttons, BotaoCadastro, Componentes1,
  Db, DBTables, Grids, DBGrids, Tabela, DBKeyViolation, Mask, DBCtrls,
  Localizacao, ComCtrls, UnCompras, unProdutos, numericos;

type
  TFCadCompras = class(TFormularioPermissao)
    PanelColor1: TPanelColor;
    Grade: TGridIndice;
    CadCompras: TSQL;
    Localiza: TConsultaPadrao;
    DataCadCompras: TDataSource;
    MovCompras: TQuery;
    DataMovCompras: TDataSource;
    Aux: TQuery;
    CadProdutos: TQuery;
    Produtos: TQuery;
    ELocalizaProduto: TDBEditLocaliza;
    Label1: TLabel;
    LocalizaFornecedor: TDBEditLocaliza;
    SpeedLocaliza: TSpeedButton;
    Shape2: TShape;
    Label5: TLabel;
    Label2: TLabel;
    DBText1: TDBText;
    Shape3: TShape;
    Label6: TLabel;
    Label7: TLabel;
    ValidaGravacao1: TValidaGravacao;
    Tempo: TPainelTempo;
    PanelColor3: TPanelColor;
    BotaoFechar1: TBotaoFechar;
    BotaoCancelar1: TBotaoCancelar;
    BotaoGravar1: TBotaoGravar;
    BTCadastrar: TBitBtn;
    BBImprimir: TBitBtn;
    Label11: TLabel;
    CadComprasI_COD_COM: TIntegerField;
    CadComprasI_EMP_FIL: TIntegerField;
    CadComprasI_COD_CLI: TIntegerField;
    CadComprasD_ULT_ALT: TDateField;
    CadComprasD_DAT_CAD: TDateField;
    CadComprasD_DAT_PRE: TDateField;
    CadComprasD_DAT_ENV: TDateField;
    CadComprasC_SIT_COM: TStringField;
    MovComprasI_COD_COM: TIntegerField;
    MovComprasI_EMP_FIL: TIntegerField;
    MovComprasI_SEQ_PRO: TIntegerField;
    MovComprasC_COD_UNI: TStringField;
    MovComprasC_COD_PRO: TStringField;
    MovComprasN_QTD_PRO: TFloatField;
    MovComprasD_ULT_ALT: TDateField;
    Shape1: TShape;
    Label14: TLabel;
    EHoraPrevEntre: TDBEditColor;
    MovComprasNomeProdu: TStringField;
    CadComprasI_COD_SIT: TIntegerField;
    CadComprasC_OBS_COM: TMemoField;
    CadComprasC_CON_COM: TMemoField;
    Label8: TLabel;
    EDataPrevEntre: TDBEditColor;
    DBContato: TDBMemoColor;
    Label10: TLabel;
    Label12: TLabel;
    DBObeservacao: TDBMemoColor;
    Label13: TLabel;
    SpeedButton2: TSpeedButton;
    Label15: TLabel;
    LocalizaSituacao: TDBEditLocaliza;
    CadComprasT_HOR_ENV: TTimeField;
    CadComprasT_HOR_PRE: TTimeField;
    Label9: TLabel;
    SpeedButton1: TSpeedButton;
    Label16: TLabel;
    LocalizaPagamento: TDBEditLocaliza;
    CadComprasN_TOT_IPI: TFloatField;
    CadComprasN_TOT_ICM: TFloatField;
    CadComprasN_TOT_COM: TFloatField;
    MovComprasN_VLR_IPI: TFloatField;
    MovComprasN_VLR_ICM: TFloatField;
    MovComprasN_VLR_TOT: TFloatField;
    MovComprasN_VLR_UNI: TFloatField;
    CadComprasI_COD_PAG: TIntegerField;
    Shape4: TShape;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    TotCompra: Tnumerico;
    TotICMS: Tnumerico;
    TotIPI: Tnumerico;
    CadIcms: TQuery;
    CadIcmsC_COD_EST: TStringField;
    CadIcmsN_ICM_INT: TFloatField;
    CadIcmsN_ICM_EXT: TFloatField;
    CadIcmsD_ULT_ALT: TDateField;
    ProdutosI_SEQ_PRO: TIntegerField;
    ProdutosC_COD_PRO: TStringField;
    ProdutosN_PER_IPI: TFloatField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BotaoFechar1Click(Sender: TObject);
    procedure CadComprasBeforePost(DataSet: TDataSet);
    procedure GradeEnter(Sender: TObject);
    procedure BTCadastrarClick(Sender: TObject);
    procedure MovComprasAfterInsert(DataSet: TDataSet);
    procedure GradeColExit(Sender: TObject);
    procedure ELocalizaProdutoSelect(Sender: TObject);
    procedure ELocalizaProdutoRetorno(Retorno1, Retorno2: String);
    procedure GradeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GradeKeyPress(Sender: TObject; var Key: Char);
    procedure MovComprasAfterPost(DataSet: TDataSet);
    procedure MovComprasBeforePost(DataSet: TDataSet);
    procedure ELocalizaProdutoEnter(Sender: TObject);
    procedure MovComprasBeforeInsert(DataSet: TDataSet);
    procedure GradeExit(Sender: TObject);
    procedure BotaoCancelar1Atividade(Sender: TObject);
    procedure BotaoCancelar1DepoisAtividade(Sender: TObject);
    procedure LocalizaFornecedorChange(Sender: TObject);
    procedure MovComprasAfterDelete(DataSet: TDataSet);
    procedure MovComprasBeforeEdit(DataSet: TDataSet);
    procedure GradeCellClick(Column: TColumn);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BotaoGravar1DepoisAtividade(Sender: TObject);
    procedure BBImprimirClick(Sender: TObject);
    procedure LocalizaFornecedorRetorno(Retorno1, Retorno2: String);
    procedure SpeedLocalizaMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BotaoGravar1AntesAtividade(Sender: TObject);
  private
    UnCompras : TFuncoesCompras;
    UnProduto : TFuncoesProduto;
    function ValidaData(DataPrevisao : TdateTime) : Boolean;
    function ValidaHora(HoraPrevisao : TdateTime) : Boolean;
    function verificaProduto(var CodPro, CodUni : string) : Boolean;
    procedure Movimentacoes;
  public
    procedure NovaCompra;
  end;

var
  FCadCompras: TFCadCompras;

implementation
uses APrincipal, Constantes, FunSql, FunObjeto, FunValida, FunData,
     FunNumeros, FunString, ALocalizaProdutos, AImprimeReqMaterial;
{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFCadCompras.FormCreate(Sender: TObject);
begin
  UnCompras := TFuncoesCompras.Criar(self, FPrincipal.BaseDados);
  UnProduto := TFuncoesProduto.Criar(self, FPrincipal.BaseDados);
  Self.HelpFile := Varia.PathHelp + 'MAGeal.HLP>janela';{ chamar a rotina de atualização de menus }
  NovaCompra;                   //CHAMA PROCEDURE PARA CARREGAR INSERT
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFCadCompras.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CadCompras.Close;{ fecha tabelas }
  MovCompras.Close;
  UnCompras.Free;  {finaliza Un´s}
  UnProduto.Free;
  Action := CaFree;{ chamar a rotina de atualização de menus }
end;

{|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                                DAS TABELAS
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||}

{ ************************** Grava o dia da alteração ************************ }
procedure TFCadCompras.CadComprasBeforePost(DataSet: TDataSet);
var
 ICMS, IPI, TOTAL : Double;
begin
  CadComprasN_TOT_IPI.AsInteger := TotIPI.AsInteger;    // TOTAL DE IPI RECEBE VALOR QUE ESTA NO NUMERICO
  CadComprasN_TOT_ICM.AsInteger := TotICMS.AsInteger;   // TOTAL DE ICMS RECEBE VALOR QUE ESTA NO NUMERICO
  CadComprasN_TOT_COM.AsInteger := TotCompra.AsInteger; // TOTAL DA COMPRA RECEBE VALOR QUE ESTA NO NUMERICO
  CadComprasD_ULT_ALT.AsDateTime := Date; // DATA DA ULTIMA ALTERACAO REBECE A DATA ATUAL
  UnCompras.SomaValores(ICMS, IPI, TOTAL, CadCompras, CadComprasI_COD_COM.AsInteger, CadComprasI_EMP_FIL.AsInteger);
  TotICMS.AValor := ICMS;        //NUMERIO RECEBE VALOR SOMADO NA UN
  TotIPI.AValor := IPI;
  TotCompra.AValor := TOTAL;
end;

{ ****** Passa os dados I_EMP_FIL e I_COD_COM da Tabela Cad para a Mov ******* }
procedure TFCadCompras.MovComprasAfterInsert(DataSet: TDataSet);
begin
  MovComprasI_EMP_FIL.AsInteger := CadComprasI_EMP_FIL.AsInteger; //A MOV RECEBE O CODIGO DA CADCOMPRAS
  MovComprasI_COD_COM.AsInteger := CadComprasI_COD_COM.AsInteger; //A MOV RECEBE O CODIGO DA CADCOMPRAS
end;

{******************* Antes do Insert ***************************************}
procedure TFCadCompras.MovComprasBeforeInsert(DataSet: TDataSet);
begin
  if Grade.Focused then       // Seta o Cursor na 1ª Coluna da Grade
    Grade.SelectedIndex := 0;
end;

{ ******** Adiciona uma nova linha de registros no grid para gravacao ******** }
procedure TFCadCompras.MovComprasAfterPost(DataSet: TDataSet);
var
 ICMS, IPI, TOTAL : Double;
begin
  AtualizaSQLTabela(MovCompras); //Limpa tabela
  MovCompras.Last;               //Passa para uma nova linha
  LocalizaFornecedorChange(nil); // CHAMA EVENTO "LOCALIZAFORNECEDOR" ON CHANGE
  UnCompras.SomaValores(ICMS, IPI, TOTAL, CadCompras, CadComprasI_COD_COM.AsInteger, CadComprasI_EMP_FIL.AsInteger);
  TotICMS.AValor := ICMS;        //NUMERIO RECEBE VALOR SOMADO NA UN
  TotIPI.AValor := IPI;
  TotCompra.AValor := TOTAL;
end;

{ ********* Evita que uma linha fique sem o C_COD_PRO e o I_SEQ_PRO ********** }
procedure TFCadCompras.MovComprasBeforePost(DataSet: TDataSet);
begin
 MovComprasD_ULT_ALT.AsDateTime := Date; //DATA DA ULTIMA ALTERACAO RECEBE A DATA DO DIA
 if MovComprasC_COD_PRO.IsNull or MovComprasN_QTD_PRO.IsNull or MovComprasN_VLR_UNI.IsNull or
    MovComprasN_VLR_ICM.IsNull or MovComprasN_VLR_TOT.IsNull or MovComprasN_VLR_IPI.IsNull then
    Abort;   //ABORTA A GRAVAÇÃO CASO OS DADOS ESTEJAM VAZIOS
 if not UnProduto.ValidaUnidade.ValidaUnidade(UnProduto.UnidadePadrao(MovComprasI_SEQ_PRO.AsInteger),MovComprasC_COD_UNI.AsString) then
 begin             //VALIDA CODIGO SEQUENCIAL DO PRODUTO
   Grade.SetFocus;
   Abort;          //SE NAO FOR VALIDO ABORTA OPERACAO
 end;
end;

{************************ Depois do delete ***********************************}
procedure TFCadCompras.MovComprasAfterDelete( DataSet: TDataSet);
begin
  LocalizaFornecedorChange(nil); // CHAMA EVENTO "LOCALIZAFORNECEDOR" ON CHANGE
end;

{************************************* antes do edit *************************}
procedure TFCadCompras.MovComprasBeforeEdit(DataSet: TDataSet);
begin
  Grade.Columns[2].PickList := UnProduto.ValidaUnidade.UnidadesParentes(MovComprasC_COD_UNI.AsString);
//VALIDA A UNIDADE DO PRODUTO  (UN, KG, MG, LT)
end;

procedure TFCadCompras.LocalizaFornecedorRetorno(Retorno1, Retorno2: String);
begin
  if Retorno1 <> '' then
    CadComprasC_CON_COM.AsString := Retorno1; //CONTATO DO CLIENTE
  if Retorno2 <> '' then
    AdicionaSQLAbreTabela(CadIcms,'Select * from CadICMSestados '+
                                  'Where C_COD_EST = '''+ Retorno2 +'''');
                 //LOCALIZA O ESTADO PARA PEGAR O PERCENTUAL DE ICMS "N_ICM_INT"
//    CadComprasC_OBS_COM.AsString := Retorno2; //OBS DO CLIENTE
end;

{ ****** A tabela Mov recebe o I_SEQ_PRO e o C_COD_UNI automaticamente ******* }
procedure TFCadCompras.ELocalizaProdutoRetorno(Retorno1, Retorno2: String);
begin
  if MovCompras.State in [ dsEdit, dsInsert ] then
    if Retorno2 <> '' then
    begin
      MovComprasI_SEQ_PRO.AsInteger := StrToInt(Retorno2); //SEQUENCIAL DO PRODUTO
      MovComprasC_COD_UNI.AsString := Retorno1;            //CODIGO UNITARIO (UN, KG, MG, LT)
      AdicionaSQLAbreTabela(Produtos,'Select * from CadProdutos '+
                                     'Where I_SEQ_PRO = '+ Retorno2);
                //LOCALIZA O PRODUTO PARA PEGAR O PERCENTUAL DE IPI "N_PER_IPI"
    end;
end;

{|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                               VALIDA DATA E HORA
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||}

{***************** VERIFICA SE A HORA DE ENVIO É VALIDA ***********************}
function TFCadCompras.ValidaHora(HoraPrevisao : TdateTime) : Boolean;
begin
  result := true;
  if HoraPrevisao < Time then
  begin
    result := false;
    Informacao (' Hora invalida! ');
  end;
end;

{***************** VERIFICA SE A DATA DE ENVIO É VALIDA ***********************}
function TFCadCompras.ValidaData(DataPrevisao : TdateTime) : Boolean;
begin
  result := true;
  if DataPrevisao < Date then
  begin
    result := false;
    Informacao (' Data invalida! ');
  end;
end;

{|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                               AÇÕES DO GRID
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||}

{ ********************* Ao descer para a Grade ******************************* }
procedure TFCadCompras.GradeEnter(Sender: TObject);
begin
  if CadCompras.State in [dsEdit, dsInsert ] then
    begin  //VERIFICA SE OS CAMPOS NAO ESTAO NULOS
      If (LocalizaSituacao.Field.IsNull) or (LocalizaFornecedor.Field.IsNull) or
         (CadComprasI_COD_COM.IsNull) or (CadComprasI_COD_SIT.IsNull) then
          begin                                  //Verifica se os Campos estão preenchidos
            aviso('Faltam dados no Cadastro'); //Msg de erro de algum dado estiver nulo
            if LocalizaFornecedor.Enabled then
               LocalizaFornecedor.SetFocus;     //SETA NO EDIT LOCALIZA FORNECEDOR
          end
      else
        if not (MovCompras.Active) then //SE A MOV ESTIVER DESATIVADA
          begin
            LimpaSQLTabela(MovCompras);  //LOCALIZA A MOV CONFORME O CODIGO DA CADCOMPRAS
            UnCompras.LocalizaMovCompras(MovCompras,CadComprasI_EMP_FIL.AsInteger,CadComprasI_COD_COM.AsInteger);
            MovCompras.Open; //ABRE TABELA
          end;
    end;
end;

{ Criar uma seleção para verificar se o C_COD_PRO, fornecido existe e é válido }
procedure TFCadCompras.GradeColExit(Sender: TObject);
 var  CodProduto, CodUnidade : string;
begin
  if MovCompras.State in [dsInsert, dsEdit] then // SE ESTIER EM ESTADO DE EDICAO OU INSERCAO
  begin // 01
    CodProduto := MovComprasC_COD_PRO.AsString; //ARMAZENA CODIGO DO PRODUTO NUMA ARIAEL
    case Grade.SelectedIndex of // Inicio CASE
        0 : begin // 02                    "0" porque é primeira coluna da Grade
             if verificaProduto (CodProduto, CodUnidade) then
               begin // 03
                 ELocalizaProdutoSelect(nil); //CHAMA EVENTO DO "LOCALIZAPRODUTO"
                 ELocalizaProduto.AAbreLocalizacao;
               end // 03
             else
               begin // 04
                 MovComprasI_SEQ_PRO.AsInteger := strtoint(CodProduto);
                 MovComprasC_COD_UNI.AsString := CodUnidade;
               end; // 04
             Grade.Columns[2].PickList := UnProduto.ValidaUnidade.UnidadesParentes(MovComprasC_COD_UNI.AsString);
          end; // 02

        4 : begin // 05   SE OS VALORES NAO FOREM NULOS, CALCULA O ICMS
              if not (MovComprasN_VLR_UNI.IsNull) and not(MovComprasN_QTD_PRO.IsNull) then
                MovComprasN_VLR_ICM.AsFloat := (((MovComprasN_VLR_UNI.AsFloat * MovComprasN_QTD_PRO.AsFloat) * CadIcmsN_ICM_INT.AsFloat) / 100);

              if not (MovComprasN_VLR_UNI.IsNull) and not(MovComprasN_QTD_PRO.IsNull) then
                begin// 06  SE OS VALORES NAO FOREM NULOS, CALCULA O IPI
                  MovComprasN_VLR_IPI.AsFloat := (((MovComprasN_VLR_UNI.AsFloat * MovComprasN_QTD_PRO.AsFloat) * ProdutosN_PER_IPI.AsFloat) / 100);
                      //CALCULA O VALOR TOTAL SOMANDO ICMS, IPI + (QTD * PRECO UNITARIO)
                  MovComprasN_VLR_TOT.AsFloat := MovComprasN_VLR_ICM.AsFloat + MovComprasN_VLR_IPI.AsFloat + (MovComprasN_VLR_UNI.AsFloat * MovComprasN_QTD_PRO.AsInteger);
                end; // 06
            end; // 05
    end; // Fim CASE
  end; // 01
end;

{ *************** Chama a consulta pressionando F3 (key 114) ******************}
procedure TFCadCompras.GradeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if (Key = 114)  and (Grade.SelectedIndex = 0) then  // localiza produtos pressionado F3
     begin
       if not (MovCompras.State in [ DsEdit, dsInsert ]) then
         MovCompras.Insert;
       ELocalizaProdutoSelect(nil); //ABRE LOCALIZAÇÃO DO PRODUTO
       ELocalizaProduto.AAbreLocalizacao;
     end;

  if ( not MovCompras.IsEmpty) and (key = 46) then
    if Confirmacao(CT_DeletaRegistro) then
      MovCompras.Delete;    //DELETA REGISTRO

  if Key = 45 then
  begin
    MovCompras.Append;
    Key := 0;
  end;
end;

{ *********** AO ENTRAR NO LOCALIZA PRODUTO QUE ESTÁ SOB A GRADE ************* }
procedure TFCadCompras.ELocalizaProdutoEnter(Sender: TObject);
begin
  Grade.SetFocus;
end;

{ ********************* Subtitui o ponto por vírgula ************************* }
procedure TFCadCompras.GradeKeyPress(Sender: TObject;  var Key: Char);
begin
  if Key = '.' then
     Key := ',';   //substitui o ponto pela vírgula
end;

{ ********************* na saida do gride ************************************ }
procedure TFCadCompras.GradeExit(Sender: TObject);
begin
   if MovCompras.State in [dsInsert, dsEdit ] then
     if (MovComprasC_COD_PRO.IsNull or MovComprasN_QTD_PRO.IsNull) and
        (not BotaoCancelar1.Focused) then
        Grade.SetFocus
     else
       if MovCompras.State in [dsEdit, dsInsert] then
         MovCompras.Post; //GRAVA TABELA
end;

{********************** No click de uma coluna *******************************}
procedure TFCadCompras.GradeCellClick(Column: TColumn);
begin
  if Grade.SelectedIndex = 2 then
    if ( not (MovCompras.State in [dsEdit, dsinsert])) and (MovComprasC_COD_UNI.AsString <> '') then
      MovCompras.Edit;  //EDITA TABELA MOVCOMPRAS
end;

{|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                                AÇÕES DOS BOTÕES
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||}

{ **************** Fornece os dados necessários aos ítens ******************** }
procedure TFCadCompras.BTCadastrarClick(Sender: TObject);
begin
  MovCompras.Close;             //FECHA TABELA
  NovaCompra;                   //CHAMA PROCEDURE
  LocalizaFornecedor.SetFocus;  //SETA O COMPONENTE LOCALIZA FORNECEDOR
end;

{************************* Antes do click cancelar *************************}
procedure TFCadCompras.BotaoCancelar1Atividade(Sender: TObject);
begin          //CHAMA PROCEDURE DA UN PARA EXCLUIR A ORDEM DE COMPRA
  UnCompras.ExcluirCompra(CadComprasI_EMP_FIL.AsInteger,CadComprasI_COD_COM.AsInteger);
end;

{*************************  Depois do click cancelar *************************}
procedure TFCadCompras.BotaoCancelar1DepoisAtividade(Sender: TObject);
begin
  CadCompras.Close;           //FECHA TABELA
  MovCompras.Close;           //FECHA TABELA
  BotaoGravar1.Enabled := False;
  LimpaLabel([Label7, Label15, Label16]); //Deixa os label´s dos localizas vazios
end;

{**************** Valida data e hora de entrega antes de gravar ***************}
procedure TFCadCompras.BotaoGravar1AntesAtividade(Sender: TObject);
begin
  if CadCompras.State in [DsInsert, DsEdit] then // Se a Tabela "ESTIVER" em estado de Edição ou Incerção
   begin //01
    if not ValidaData(CadComprasD_DAT_PRE.AsDateTime) then
      begin //02                     Chama procedure para validar a data
       EDataPrevEntre.SetFocus;   // seta o edit da data de previsao
       Abort;                     // se a data for invalida aborta ação de gravar
      end   //02
    else                  // Se a data de envio for igual a data de previsão
      if CadComprasD_DAT_PRE.AsDateTime = Date then
        if not ValidaHora(CadComprasT_HOR_PRE.AsDateTime) then
          begin //03                      Chama procedure para validar hora caso a data seja valida
           EHoraPrevEntre.SetFocus;    // seta o edit da hora de previsao
           Abort;                      // se a hora for invalida aborta ação de gravar
          end   //03
   end   //01
  else   // Se a Tabela "NAO ESTIVER" em estado de Edição ou Incerção
   begin // 04
     BotaoGravar1.Enabled := False;
     Abort;
   end;  // 04
end;

{******************** Chama Procedure Para Movimentar Estoque *****************}
procedure TFCadCompras.BotaoGravar1DepoisAtividade(Sender: TObject);
begin
  Movimentacoes; //CHAMA PROCEDURE MOVIMENTACOES PARA MOVIMENTAR ESTOQUE
end;

{************************** Chama a tela de impressao *************************}
procedure TFCadCompras.BBImprimirClick(Sender: TObject);
begin
{  if not BotaoCancelar1.Enabled then
  begin
    if varia.TipoImpGra_matReqMat <> 1 then
        UnCompras.ImprimeCompras(CadComprasI_COD_COM.AsInteger, varia.CodigoEmpFil)
    else
    begin
      FImprimeReqMaterial := TFImprimeReqMaterial.CriarSDI(application,'',FPrincipal.VerificaPermisao('FImprimeReqMaterial'));
      FImprimeReqMaterial.CarregaReqmateria(CadComprasI_COD_COM.AsInteger,CadComprasI_Emp_Fil.AsInteger, varia.NomeFilial);
    end;
  end;}
end;

{|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                                CARREGA INSERT
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||}

{ ***************** Grava o intem I_COD_COM e reedita a tabela *************** }
procedure TFCadCompras.NovaCompra;
var
   CodigoCompra : Integer;
begin
  LimpaEdits(PanelColor1);                    //Limpra os Edits e os Numericos
  LimpaLabel([Label7,  Label15, Label16]);    //Deixa os label´s dos localizas vazios
  AdicionaSQLAbreTabela(CadCompras,' Select * From CadCompras ');
  CadCompras.Insert; //INSERT NA TABELA CADCOMPRAS
  CadComprasI_COD_COM.AsInteger := ProximoCodigoFilial('CadCompras','I_COD_COM','I_EMP_FIL',varia.CodigoEmpFil,FPrincipal.BaseDados);
  CadComprasI_EMP_FIL.AsInteger := Varia.CodigoEmpFil;
  CadComprasD_DAT_CAD.AsDateTime := Date;     //Data de Cadastro recebe a data do dia
  CadComprasC_SIT_COM.AsString := 'O';        //TIPO DE COMPRA RECEBE ORCAMENTO
  CadComprasI_COD_SIT.AsInteger := 11017;     //TIPO DE COMPRA RECEBE CODIGO PADRAO
  CodigoCompra := CadComprasI_COD_COM.AsInteger;
  CadCompras.Post;                            //GRAVA TABELA CADCOMPRAS
  UnCompras.LocalizaCadCompras(CadCompras,CadComprasI_EMP_FIL.AsInteger,CadComprasI_COD_COM.AsInteger);
  CadCompras.Edit;                            //EDITA TABELA CADCOMPRAS
  LocalizaSituacao.Atualiza;
  BotaoGravar1.Enabled := False;
end;

{**************AO DIGITAR QUALAQUER COISA NO LOCALIZA FORNECEDOR **************}
procedure TFCadCompras.LocalizaFornecedorChange(Sender: TObject);
begin
 if CadCompras.State in [dsInsert, dsEdit] then
   ValidaGravacao1.Execute;
 BotaoGravar1.Enabled := not MovCompras.IsEmpty;
end;

{********* PROCEDURE QUE DA BAIXA NO ESTOQUE DOS PRODUTOS SELECIONADOS ********}
procedure TFCadCompras.Movimentacoes;
var
  Unidade:String;
begin
{  MovCompras.DisableControls;
  begin
    Tempo.execute('Movimentando Estoque...');
    MovCompras.First;
    while not MovCompras.Eof do
    begin
      Unidade := UnProduto.UnidadePadrao(MovComprasI_SEQ_PRO.AsInteger);
      UnProduto.BaixaProdutoEstoque( MovComprasI_SEQ_PRO.AsInteger,
                                    strtoint(EditLocaliza2.text),
                                     0, 0, Varia.MoedaBase,0,date,
                                     MovComprasN_QTD_PRO.AsFloat,
                                     0, MovComprasC_COD_UNI.AsString,Unidade);
      MovCompras.Next;
    end;
    Tempo.Fecha;
  end;
  MovCompras.EnableControls;
}end;

{|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                                 DIVERSOS
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||}

{******************* Nao Permite Ação do Botão Localizar **********************}
procedure TFCadCompras.SpeedLocalizaMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin                  //Se a tabela nao estiver em estado de Inserção ou Edição
  if not (CadCompras.State in [DsInsert, DsEdit]) then
    Abort;             //aporta operacao de click do mouse
end;

{ ******** Função para saber se o nº fornecido no C_COD_PRO é válido ********* }
function  TFCadCompras.verificaProduto(var CodPro, CodUni : string) : Boolean;
begin
  AdicionaSQLAbreTabela(aux, ' select * from cadprodutos ' +
                             ' where c_cod_pro = ''' + CodPro + '''' +
                             ' and i_cod_emp = ' + Inttostr(varia.CodigoEmpresa));
  result := Aux.Eof;  //retorna com um dado que é "V" ou "F"
  CodPro := Aux.FieldByname('i_seq_pro').AsString;
  CodUni := Aux.FieldByname('c_cod_uni').AsString;
  Aux.Close;
end;

{ *********** Faz a select para abrir a localização de produtos ************** }
procedure TFCadCompras.ELocalizaProdutoSelect(Sender: TObject);
begin
  ELocalizaProduto.ASelectValida.Clear;
  ELocalizaProduto.ASelectValida.Add(  ' Select Pro.C_COD_PRO, Pro.C_NOM_PRO,' +
                                       '        Pro.C_COD_UNI, Pro.I_SEQ_PRO ' +
                                       ' From CadProdutos as Pro ' +
                                       ' Where Pro.I_COD_EMP = ' + IntToStr(Varia.CodigoEmpresa) +
                                       ' and ' + Varia.CodigoProduto + ' = ''@''' +
                                       ' and Pro.C_KIT_PRO = ''P'' ' );
  ELocalizaProduto.ASelectLocaliza.Clear;
  ELocalizaProduto.ASelectLocaliza.Add(' Select Pro.C_COD_PRO, Pro.C_NOM_PRO, '+
                                       '        Pro.C_COD_UNI, Pro.I_SEQ_PRO  '+
                                       ' From CadProdutos as Pro ' +
                                       ' where Pro.I_COD_EMP = ' + IntToStr(varia.CodigoEmpresa) +
                                       ' and Pro.C_NOM_PRO like ''@%''' +
                                       ' and Pro.C_KIT_PRO = ''P'' ' );
end;

{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFCadCompras.BotaoFechar1Click(Sender: TObject);
begin
  Self.Close; // FECHA A TELA
end;

{************************ verifica se pode ou nao fechar o formulario ********}
procedure TFCadCompras.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := BTCadastrar.Enabled;
end;

Initialization
  RegisterClasses([TFCadCompras]);
end.
