unit AProdutoASerComprado;

//                Autor: Leonardo Emanuel Pretti
//      Data da Criação: 19/09/2001
//               Função: Consulta de Produtos dos Pedidos a Serem Comprados
//         Alterado por:
//    Data da Alteração:
//  Motivo da Alteração:

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Componentes1, Localizacao, Db, DBTables, Grids, DBGrids,
  Tabela, DBKeyViolation, Mask, DBCtrls, Buttons, BotaoCadastro, ExtCtrls,
  ComCtrls, numericos, PainelGradiente, CheckLst, UnCompras, Geradores,
  ImgList, ToolWin;

type
  TDadosFornecedor = class         //Criação de Uma Classe
    CodFornecedor : integer;
end;

type
  TFProdutoASerComprado = class(TFormularioPermissao)
    PanelColor3: TPanelColor;
    BotaoFechar1: TBotaoFechar;
    PanelColor1: TPanelColor;
    SpeedLocalizaCliente: TSpeedButton;
    Localiza: TConsultaPadrao;
    Label4: TLabel;
    DataCadOrcamentos: TDataSource;
    CadOrcamentos: TQuery;
    PainelGradiente1: TPainelGradiente;
    Label8: TLabel;
    PanelColor4: TPanelColor;
    Label7: TLabel;
    CadOrcamentosi_seq_pro: TIntegerField;
    CadOrcamentosUniEst: TStringField;
    CadOrcamentoscompra: TFloatField;
    CadOrcamentosUniCom: TStringField;
    CadOrcamentosNome: TStringField;
    CadOrcamentosnecessario: TFloatField;
    CadOrcamentosestoque: TFloatField;
    LocalizaProduto: TEditLocaliza;
    Aux: TQuery;
    PanelFornecedor: TComponenteMove;
    Label1: TLabel;
    ListaFornecedor: TCheckListBox;
    ToolBar1: TToolBar;
    BtZoom: TToolButton;
    ImageList1: TImageList;
    PanelColor2: TPanelColor;
    Grade2: TDBGridColor;
    QtdPed: TQuery;
    DataQtdPed: TDataSource;
    QtdPedi_nro_ped: TIntegerField;
    PanelColor5: TPanelColor;
    Grade: TGridIndice;
    Insert: TQuery;
    IntegerField1: TIntegerField;
    IntegerField2: TIntegerField;
    QtdPedQtd: TFloatField;
    CadOrcamentosCodPro: TStringField;
    CadCompras: TQuery;
    CadComprasI_COD_COM: TIntegerField;
    CadComprasI_EMP_FIL: TIntegerField;
    BtOk: TBitBtn;
    GeraOrcamento: TBitBtn;
    PanelColor6: TPanelColor;
    SpeedButton1: TSpeedButton;
    Label5: TLabel;
    Label2: TLabel;
    Existe: TQuery;
    IntegerField3: TIntegerField;
    IntegerField4: TIntegerField;
    LocalizaFornecedor: TEditLocaliza;
    CadOrcamentosaprovado: TFloatField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BotaoFechar1Click(Sender: TObject);
    procedure LocalizaProdutoRetorno(Retorno1, Retorno2: String);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GradeDblClick(Sender: TObject);
    procedure CadOrcamentosAfterScroll(DataSet: TDataSet);
    procedure BtZoomClick(Sender: TObject);
    procedure PanelFornecedorExit(Sender: TObject);
    procedure GeraOrcamentoClick(Sender: TObject);
    procedure LocalizaProdutoExit(Sender: TObject);
    procedure BtOkClick(Sender: TObject);
  private
    UnCompras : TFuncoesCompras;
    Gerado : Boolean;
    procedure AtualizaConsulta;
    procedure AtualizaPedidos;
    procedure AtualizaPanelFornecedor;
    procedure AdicionaFiltros (VpaSelect : TStrings);
    procedure GeraFornecedor;
    procedure LerFornecedor;
    procedure CarregaInsert(CodFornecedor : integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FProdutoASerComprado: TFProdutoASerComprado;

implementation
uses APrincipal, ConstMsg, Constantes, FunSql, FunData, FunObjeto, FunNumeros,
     FunValida,FunString;
{$R *.DFM}

{|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                            No Abrir e Fechar o Formulario
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||}
{ ****************** Na criação do Formulário ******************************** }
procedure TFProdutoASerComprado.FormCreate(Sender: TObject);
begin
  LimpaEdits(PanelColor1);
  PanelFornecedor.Top := 309;  //ACERTA A ALTURA DO PANEL
  PanelFornecedor.Left := 217; //ACERTA A LINHA LATERAL DO PANEL
  AtualizaConsulta;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFProdutoASerComprado.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CadOrcamentos.Close; { fecha tabelas }
  Aux.Close;
  QtdPed.Close;
  CadCompras.Close;
  Insert.Close;
  Existe.Close;
  UnCompras.Free;
  Action := CaFree;
end;

{|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                      Procedure que Atualiza os Dados no Grid
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||}
{ ***************************** Atualiza Consulta **************************** }
procedure TFProdutoASerComprado.AtualizaConsulta;
begin
  LimpaSQLTabela(CadOrcamentos);
  AdicionaSQLTabela(CadOrcamentos,' Select Mov.I_SEQ_PRO,                                 '+
                                  '  isnull(sum(Mov.N_QTD_PRO),0)  as necessario,         '+
                                  ' (Select isnull(sum(N_QTD_PRO),0) from Movcompras Mov1,'+
                                  '  cadcompras CAD1 where Mov1.I_SEQ_PRO = Mov.I_SEQ_PRO  '+
                                  '  and CAD1.I_COD_COM = Mov1.I_COD_COM                   '+
                                  '  and CAD1.C_SIT_COM = ''A'') aprovado,                 '+
                                  ' (Select isnull(N_QTD_PRO,0) from Movqdadeproduto Qtd  '+
                                  '  where Qtd.I_SEQ_PRO = Mov.I_SEQ_PRO                  '+
                                  '  and Qtd.I_EMP_FIL = Mov.I_EMP_FIL) estoque,          '+
                                  ' (Select C_COD_PRO  from cadprodutos pro               '+
                                  '  where pro.I_SEQ_PRO = Mov.I_SEQ_PRO ) CodPro,        '+
                                  ' (Select C_COD_UNI  from cadprodutos pro               '+
                                  '  where pro.I_SEQ_PRO = Mov.I_SEQ_PRO ) UniEst,        '+
                                  ' isnull((necessario-estoque-aprovado),0) compra,       '+
                                  ' Mov.C_COD_UNI UniCom,                                 '+
                                  ' (Select C_NOM_PRO  from cadprodutos produ             '+
                                  '  where produ.I_SEQ_PRO = Mov.I_SEQ_PRO ) Nome         '+
                                  ' From CadOrcamentos as CAD, '+
                                  '      MovOrcamentos as Mov, ');
  AdicionaFiltros(CadOrcamentos.SQL);
  AdicionaSQLTabela(CadOrcamentos,' and Mov.I_EMP_FIL = CAD.I_EMP_FIL '+
                                  ' and Mov.I_LAN_ORC = CAD.I_LAN_ORC '+
                                  ' and CAD.C_TIP_CAD = ''P'' '+
                                  ' and CAD.C_FLA_SIT = ''A'' '+
                                  ' group by Mov.I_EMP_FIL, Mov.I_SEQ_PRO, Mov.C_COD_UNI '+
                                  ' having compra > 0');
  AdicionaSQLTabela(CadOrcamentos,' Order  by  Mov.I_SEQ_PRO');
  AbreTabela(CadOrcamentos);
  AtualizaPedidos;
end;

{ ******************** Atualiza os Pedidos de Cada Produto ******************* }
procedure TFProdutoASerComprado.AtualizaPedidos;
begin
  LimpaSQLTabela(QtdPed);
  AdicionaSQLTabela(QtdPed,'Select I_NRO_PED, Sum(N_QTD_PRO)Qtd'+
                           ' From CadOrcamentos Cad,'+
                           '      MovOrcamentos Mov');
  AdicionaFiltros(QtdPed.SQL);
  AdicionaSQLTabela(QtdPed,' and Cad.I_EMP_FIL = Mov.I_EMP_FIL '+
                           ' and Cad.I_LAN_ORC = Mov.I_LAN_ORC '+
                           ' and I_SEQ_PRO = '+ IntToStr(CadOrcamentosi_seq_pro.AsInteger)+
                           ' and Cad.C_TIP_CAD = ''P'''+
                           ' and Cad.C_FLA_SIT = ''A'''+
                           ' group by I_NRO_PED');
  AbreTabela(QtdPed);
end;

{ ***************************** Adiciona Filtros ***************************** }
procedure TFProdutoASerComprado.AdicionaFiltros (VpaSelect : TStrings);
begin
  VpaSelect.Add(' Where MOV.I_EMP_FIL = ' + IntToStr (Varia.CodigoEmpFil));

  if LocalizaProduto.Text <> '' then
    VpaSelect.Add(' and MOV.I_SEQ_PRO = ' + LocalizaProduto.Text)
  else              // CODIGO DO PRODUTO
    VpaSelect.Add(' ');

end;

{|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
       Controle do Panel Fornecedor e Geramento de Orçamentos de Compra
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||}
{ ************ Carrega os Fornecedores de Determinado Produto **************** }
procedure TFProdutoASerComprado.GeraFornecedor;
Var
  Dados : TDadosFornecedor;  //Declaração de Variáveis
  Item : integer;
begin
  Gerado := False;
  ListaFornecedor.Items.Clear;   //Limpa os Itens que podem estar na Lista
//Localiza os Fornecedores de determinado produto usando procedimento da UnCompras
  UnCompras.LocalizaFornecedorProduto(Aux,CadOrcamentosi_seq_pro.AsInteger);

  while not Aux.Eof do //Enquanto a tabela não estiver vazia
   begin
     Dados := TDadosFornecedor.Create; //Cria um item na classe
     Dados.CodFornecedor := Aux.FieldByName('I_COD_CLI').AsInteger; //Passa o Código do fornecedor para a classe
     Item := ListaFornecedor.Items.AddObject(Aux.FieldByName('I_COD_CLI').AsString + ' - '
{Passa o codigo e o nome do fornecedor}    + Aux.FieldByName('C_NOM_CLI').AsString, Dados);
     Aux.Next;               //Vai para o proximo registro da tabela
   end;
  BtZoom.Click;
end;

{ **** Procedure que efetua a leitura dos fornededores marcados na Lista ***** }
procedure TFProdutoASerComprado.LerFornecedor;
var
  Laco, CodFornecedor : integer;
begin
  if Gerado = False then
  begin
   Gerado := True;
   For Laco := 0 to ListaFornecedor.Items.Count - 1 do  // (-1) pq começa em zero e nao em 1
    if ListaFornecedor.Checked[Laco] then   //Se o item da lista estiver "cheked"(marcado)
     begin
      //Passa o cód. do fornecedor para uma varialvel p/ ser usado no insert do CadCompras
      CodFornecedor := TDadosFornecedor(ListaFornecedor.Items.Objects[Laco]).CodFornecedor;
      //Chama procedure de insert nas tabelas passando o cód. do fornecedor como parâmetro
      CarregaInsert(CodFornecedor);
     end;
   if LocalizaFornecedor.Text <> '' then
     CarregaInsert(StrToInt(LocalizaFornecedor.Text));
     //Chama procedure de insert nas tabelas passando o cód. do fornecedor como parâmetro
  end;
  AtualizaPanelFornecedor; //Chama Procedure que deixa invisivel o Panel Fornecedor
end;

{ ************* Procedure que gerencia os insert´s nas tabelas *************** }
procedure TFProdutoASerComprado.CarregaInsert(CodFornecedor : integer);
begin
  LimpaSQLTabela(CadCompras); //Localiza CadCompras por Fornecedor
  AdicionaSQLAbreTabela(CadCompras,'Select * from CadCompras Where I_COD_CLI = '+
                      IntToStr(CodFornecedor)+' and  C_SIT_COM = ''O'' ');
  //Se não Existir Nenhuam Ordem de Compras Aberta p/ o Fornecedor Marcado
  if CadCompras.Eof then
   begin
    LimpaSQLTabela(CadCompras);
    AdicionaSQLAbreTabela(CadCompras,' Select * From CadCompras ');
    LimpaSQLTabela(Insert);                          //Abre uma OC para aquele Fornecedor
    ExecutaComandoSql(Insert,'Insert CadCompras(I_EMP_FIL, I_COD_COM, I_COD_CLI, I_COD_SIT, '+
                             '                  C_SIT_COM, D_DAT_CAD, D_ULT_ALT) '+
                             'Values('+IntToStr(Varia.CodigoEmpFil)+','+
                                       IntToStr(ProximoCodigoFilial('CadCompras','I_COD_COM','I_EMP_FIL',varia.CodigoEmpFil,FPrincipal.BaseDados))+','+
                                       IntToStr(CodFornecedor)+','+
                                       IntToStr(11017)+',''O'','+
                                       SQLTextoDataAAAAMMMDD(Date)+','+
                                       SQLTextoDataAAAAMMMDD(Date)+')');

    //Localiza a Ordem de Compras que acabou de ser cadastrada para inserir registro na MOV
    LimpaSQLTabela(CadCompras);
    AdicionaSQLAbreTabela(CadCompras,'Select * from CadCompras Where I_COD_CLI = '+
                                      IntToStr(CodFornecedor)+' and  C_SIT_COM = ''O'' ');

    LimpaSQLTabela(Insert);         //Inseri um novo produto na MovCompras
    ExecutaComandoSql(Insert,'Insert MovCompras(I_EMP_FIL, I_COD_COM, I_SEQ_PRO, C_COD_PRO, '+
                             '                  C_COD_UNI, N_QTD_PRO, D_ULT_ALT, N_VLR_TOT, '+
                             '                  N_VLR_UNI, N_VLR_ICM, N_VLR_IPI) '+
                             'Values('+IntToStr(Varia.CodigoEmpFil)+','+
                                       IntToStr(CadComprasI_COD_COM.AsInteger) +','+
                                       IntToStr(CadOrcamentosi_seq_pro.AsInteger) +','''+
                                                CadOrcamentosCodPro.AsString +''','''+
                                                CadOrcamentosUniEst.AsString +''','+
                        SubstituiStr(FloatToStr(CadOrcamentoscompra.AsFloat),',','.')+','+
                                       SQLTextoDataAAAAMMMDD(Date)+','+
                                       '0, 0, 0, 0)');

   end
  else //Senao (se existir uma OC aberta, adiciona um produto no MOVCOMPRAS
   begin
    LimpaSQLTabela(Existe);
    //Localiza as o OC com seus produtos e verifica se esse prudoto já está contido no OC
    AdicionaSQLAbreTabela(Existe,'Select * from MovCompras Where I_COD_COM = '+
                                 IntToStr(CadComprasI_COD_COM.AsInteger) +
                                 ' and I_SEQ_PRO = '+
                                 IntToStr(CadOrcamentosi_seq_pro.AsInteger));
    //Se o produto ainda não estiver contido naquele OC
    if Existe.Eof then
     begin
      LimpaSQLTabela(Insert);           //Inseri um novo produto na MovCompras
      ExecutaComandoSql(Insert,'Insert MovCompras(I_EMP_FIL, I_COD_COM, I_SEQ_PRO, C_COD_PRO, '+
                               '                  C_COD_UNI, N_QTD_PRO, D_ULT_ALT, N_VLR_TOT, '+
                               '                  N_VLR_UNI, N_VLR_ICM, N_VLR_IPI) '+
                               'Values('+IntToStr(Varia.CodigoEmpFil)+','+
                                         IntToStr(CadComprasI_COD_COM.AsInteger)+','+
                                         IntToStr(CadOrcamentosi_seq_pro.AsInteger)+','''+
                                                  CadOrcamentosCodPro.AsString +''','''+
                                                  CadOrcamentosUniEst.AsString+''','+
                          SubstituiStr(FloatToStr(CadOrcamentoscompra.AsFloat),',','.')+','+
                                         SQLTextoDataAAAAMMMDD(Date)+','+
                                         ' 0, 0, 0, 0)');
     end
    else//Se o produto já estiver contido naquela OC
      aviso('Já existe um Orçamento de Compra aberto para esse fornecedor e para esse produto');
   end;
end;

{ ********************** Atualiza o Panel Fornecedor(Azul) ******************* }
procedure TFProdutoASerComprado.AtualizaPanelFornecedor;
begin
  LocalizaFornecedor.Clear; //Limpa o texto do edit localiza
  LimpaLabel([Label2]);     //Limpa o label de informação do edit localiza
  BtZoom.ImageIndex := 0;    //Passa a Imagem "0" do ImageList
  BtZoom.Down := False;      //Deixa o botão levantado
  AlterarVisibleDet([PanelFornecedor], False);  //Panel Fornecedor fica Invisivel
end;

{|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                                Ação dos Botões
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||}
{ *************************** Acao do Botão OK ******************************* }
procedure TFProdutoASerComprado.BtOkClick(Sender: TObject);
begin
  Gerado := True;
  AtualizaPanelFornecedor; //Chama Procedure que deixa invisivel o Panel Fornecedor
end;

{ *********************** Acao dos Botoes No Formulario ********************** }
procedure TFProdutoASerComprado.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if BtZoom.Down = False then
   if Key = 120 then
     begin
      GeraFornecedor;
      BtZoom.ImageIndex := 2;  //Passa a Imagem "2" do ImageList
      BtZoom.Down := True;     //Deixa o botão clicado
      AlterarVisibleDet([PanelFornecedor], True); //Panel Fornecedor fica Visivel
     end;

  If PanelFornecedor.Visible then
    If Key = 27 then
      begin
       AtualizaPanelFornecedor;//Chama Procedure que deixa invisivel o Panel Fornecedor
      end;

//FProdutoASerComprado.Caption := IntToStr(Key);
end;

{ ********* Chama Procedure Para Atualizar o Quadro de Fornecedores ********** }
procedure TFProdutoASerComprado.GradeDblClick(Sender: TObject);
begin
   if BtZoom.Down then  //Se o Panel Fornecedor estiver visivel (botão for "Clicado")
     AtualizaPanelFornecedor //Chama Procedure que deixa invisivel o Panel Fornecedor
   else //Senao (Panel Fornecedor estiver invisivel)
    begin
     GeraFornecedor;
     BtZoom.ImageIndex := 2;  //Passa a Imagem "2" do ImageList
     BtZoom.Down := True;     //Deixa o botão clicado
     AlterarVisibleDet([PanelFornecedor], True); //Panel Fornecedor fica Visivel
    end;
end;

{ *************** Ação de Click do Botao Gerar Orçamento ********************* }
procedure TFProdutoASerComprado.GeraOrcamentoClick(Sender: TObject);
begin
  LerFornecedor;
end;

{ ******************** Ação de Click do Botao Zoom *************************** }
procedure TFProdutoASerComprado.BtZoomClick(Sender: TObject);
begin
   if BtZoom.Down then  //Se o botão for "Clicado"
   begin
    BtZoom.ImageIndex := 2; //Passa a Imagem "2" do ImageList
    AlterarVisibleDet([PanelFornecedor], True); //Panel Fornecedor fica Visivel
   end
   else    //Senão
   begin
    BtZoom.ImageIndex := 0;  //Passa a Imagem "0" do ImageList
    AlterarVisibleDet([PanelFornecedor], False);  //Panel Fornecedor fica Invisivel
   end;
end;

{|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                             Eventos Diversos
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||}
{ ********* Chama Procedure Para Atualizar o Quadro de Fornecedores ********** }
procedure TFProdutoASerComprado.CadOrcamentosAfterScroll( DataSet: TDataSet);
begin
  AtualizaPedidos;
  GeraFornecedor;
end;

{  Chama Procedure para efetuar a leitura dos fornecedores marcados na Lista  }
procedure TFProdutoASerComprado.PanelFornecedorExit(Sender: TObject);
begin
   if Gerado = False then //Se ainda nao tiver sido gerado as Ordens de Compra
     if Confirmacao('Deseja Gerar um Orçamento de Compra para os Fornecedores Selecionados?') then
       LerFornecedor;
 LocalizaFornecedor.Clear; //Limpa o texto do edit localiza
 LimpaLabel([Label2]);     //Limpa o label de informação do edit localiza
 GeraFornecedor;
end;

{ ***************************** Atualiza Consulta **************************** }
procedure TFProdutoASerComprado.LocalizaProdutoExit(Sender: TObject);
begin
  AtualizaConsulta;
end;

{ ***************************** Atualiza Consulta **************************** }
procedure TFProdutoASerComprado.LocalizaProdutoRetorno(Retorno1, Retorno2: String);
begin
  if Retorno1 <> '' then
    AtualizaConsulta;
end;

{ ******************************** Fecha a Tela ****************************** }
procedure TFProdutoASerComprado.BotaoFechar1Click(Sender: TObject);
begin
  Self.Close; // FECHA TELA
end;

Initialization
 RegisterClasses([TFProdutoASerComprado]);
end.
