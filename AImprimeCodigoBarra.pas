unit AImprimeCodigoBarra;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Componentes1, ExtCtrls, PainelGradiente, StdCtrls, Buttons, Db, DBTables,
  Mask, numericos, Grids, UnImpressao, Tabela, DBGrids, DBKeyViolation,
  FileCtrl, ComCtrls, UCrpe32, Localizacao;

type
  TFImprimeCodigoBarra = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    EcodPro: TEditColor;
    BFechar: TBitBtn;
    Aux: TQuery;
    Label1: TLabel;
    SpeedButton5: TSpeedButton;
    numerico1: Tnumerico;
    CAD_DOC: TSQL;
    CAD_DOCN_ALT_ETI: TFloatField;
    CAD_DOCN_LIN_ETI: TFloatField;
    CAD_DOCI_NRO_DOC: TIntegerField;
    CAD_DOCC_NOM_DOC: TStringField;
    CAD_DOCN_COM_ETI: TFloatField;
    CAD_DOCN_COL_ETI: TFloatField;
    DATA_CAD_DOC: TDataSource;
    Label2: TLabel;
    Label3: TLabel;
    GroupBox1: TGroupBox;
    LPosicao: TLabel;
    PainelFundo: TPanelColor;
    Fundo: TShape;
    Shape1: TShape;
    Label5: TLabel;
    Label6: TLabel;
    Shape2: TShape;
    Label7: TLabel;
    Shape3: TShape;
    BitBtn1: TBitBtn;
    CAD_DOCC_COD_BAR: TStringField;
    BBAjuda: TBitBtn;
    GradePro: TListBoxColor;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Paginas: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label4: TLabel;
    GDoc: TGridIndice;
    Label9: TLabel;
    ComboBoxColor1: TComboBoxColor;
    Arquivos: TFileListBox;
    BitBtn4: TBitBtn;
    Label8: TLabel;
    EditLocaliza1: TEditLocaliza;
    SpeedButton1: TSpeedButton;
    Label10: TLabel;
    Localiza: TConsultaPadrao;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EcodProExit(Sender: TObject);
    procedure BFecharClick(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure CAD_DOCAfterScroll(DataSet: TDataSet);
    procedure numerico1Exit(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure ArquivosClick(Sender: TObject);
    procedure PaginasChange(Sender: TObject);
    procedure EditLocaliza1Select(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
  private
    rel : TCrpe;
    Colunas, Linhas : integer;
    SeqProAImprimir : Integer;
    PosicaoImpressao : Integer;
    Etiquetas : array[1..400] of TShape;
    IMP : TFuncoesImpressao;
    SeqProdutos, QdadeProdutos : TStringList;
    function SomaQdade : Double;
    procedure SomaTotais(SeqPro, qdade : TStringList );
    function AtualizaProduto(CodProduto : string) : boolean;
    procedure ValidaProduto;
    procedure AbreLocalizacao;
    procedure MontaPosicao( QtdaLinha, QtdColuna : Integer );
    procedure MarcaSelecaoAImprimir(Sender: TObject;
                                    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MarcaEtiqueta( Posicao : Integer );
    procedure AcertaRetorno;
    procedure Adiciona( SeqPro, Qdade : integer; NomeProduto : string);
  public
    procedure CarregaDados(CodigoProduto : string; Qdade : Integer);
  end;

    type
    TDadoPro = class
      SeqPro : integer;
      Qdade : integer;
    end;


var
  FImprimeCodigoBarra: TFImprimeCodigoBarra;

implementation

uses APrincipal, funsql, constantes, ALocalizaProdutos,
  AImprimeEtiquetaBarra, constmsg;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFImprimeCodigoBarra.FormCreate(Sender: TObject);
begin
  TabSheet2.TabVisible := config.CodigoBarras;
  IMP := TFuncoesImpressao.Criar(self,FPrincipal.BaseDados);
  SeqProdutos := TStringList.create;
  QdadeProdutos := TStringList.create;
    AdicionaSQLAbreTabela(CAD_DOC,
    ' SELECT * FROM CAD_DOC as doc, cad_codigo_barra as bar WHERE C_TIP_DOC  = ' +
    ' ''CDB'' ' +
    ' and doc.i_cod_bar = bar.i_cod_bar' );
  Arquivos.Color := numerico1.Color;
  Arquivos.Directory := Varia.PathRel + 'EtiquetaProduto';
  ArquivosClick(nil);
end;


{ ******************* Quando o formulario e fechado ************************** }
procedure TFImprimeCodigoBarra.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if rel <> nil then
    rel.free;
 Imp.Free;
 SeqProdutos.free;
 QdadeProdutos.free;
 Action := CaFree;
end;

{************************** Na abertura do formulario ***********************}
procedure TFImprimeCodigoBarra.FormShow(Sender: TObject);
begin
  Self.HelpFile := Varia.PathHelp + 'MEstoqueCusto.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                     Localiza o produto
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{************************* atualiza o codigo e nome do produto ************** }
function TFImprimeCodigoBarra.AtualizaProduto(CodProduto : string) : boolean;
begin
  AdicionaSQLAbreTabela( Aux, ' Select pro.i_seq_pro, pro.c_nom_pro, ' + varia.CodigoProduto +
                              ' from CadProdutos as pro, MovQdadeProduto as mov, ' +
                              ' where ' + varia.CodigoProduto + ' = ''' + CodProduto + '''' +
                              ' and pro.i_cod_emp = ' + intToStr(varia.CodigoEmpresa) +
                              ' and mov.I_EMP_FIL = ' + intToStr(varia.CodigoEmpFil) +
                              ' and pro.i_seq_pro = mov.i_seq_pro ' );
  if not aux.Eof then
  begin
    SeqProAImprimir := Aux.fieldByName('i_seq_pro').AsInteger;
    EcodPro.Text := Aux.fieldByName(varia.CodigoProduto).AsString;
    Label1.Caption := Aux.fieldByName('C_nom_pro').AsString;
  end;
  result := not Aux.eof;
end;

{*******************  Valida o produto ************************************** }
procedure TFImprimeCodigoBarra.ValidaProduto;
begin
  if EcodPro.Text <> '' then
    if not AtualizaProduto(EcodPro.Text) then // valida o campo codigo caso esteja vazio
      AbreLocalizacao;
end;

{*********************** Abre a localizacao do produto ********************** }
procedure TFImprimeCodigoBarra.AbreLocalizacao;
var
  SeqPro :integer;
  codPro : string;
  Ok : boolean;
  EstoqueAtual : Double;
begin
  FLocalizaProduto := TFLocalizaProduto.CriarSDI(application,'',true);
  ok := FLocalizaProduto.LocalizaProduto( OK, seqProAImprimir, CodPro, EstoqueAtual,0);
  if ok then
    AtualizaProduto(codPro)
  else
    EcodPro.SetFocus;
end;

{*************** no exit do Codigo do produto valida  o produto ************* }
procedure TFImprimeCodigoBarra.EcodProExit(Sender: TObject);
begin
  ValidaProduto;
end;

{*************** chama a abertura da localizacao pelo botao **************** }
procedure TFImprimeCodigoBarra.SpeedButton5Click(Sender: TObject);
begin
  AbreLocalizacao;
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                   configura a tela de etiquetas
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

function TFImprimeCodigoBarra.SomaQdade : Double;
var
  Laco : Integer;
begin
  result := 0;
  for laco := 0 to GradePro.Items.Count -1 do
    result := result + TDadoPro(GradePro.Items.Objects[Laco]).Qdade;
end;

procedure TFImprimeCodigoBarra.SomaTotais(SeqPro, qdade : TStringList );
var
  Laco : Integer;
begin
  SeqPro.clear;
  qdade.clear;
  for laco := 0 to GradePro.Items.Count -1 do
  begin
    SeqPro.add(inttostr(TDadoPro(GradePro.Items.Objects[Laco]).SeqPro));
    qdade.add(inttostr(TDadoPro(GradePro.Items.Objects[Laco]).Qdade));
  end;
end;

{************** Monta as etiquetas ****************************************** }
procedure TFImprimeCodigoBarra.MontaPosicao( QtdaLinha, QtdColuna : Integer );
var
  laco, lacoCol, SomaLinha, SomaColuna, conta : integer;
  larguraEti, AlturaEti : Integer;
begin

  for laco := 1 to 400 do
   if Etiquetas[laco] <> nil then
     Etiquetas[laco].free
   else
     break;

  for laco := 1 to 400 do
    Etiquetas[laco] := nil;


  AlturaEti  := trunc((205 /  QtdaLinha) -1);
  larguraEti := trunc((172 /  QtdColuna) - 2);

  SomaColuna := 10;
  conta := 0;
  for lacoCol := 1 to QtdColuna do
  begin
    SomaLinha := 10;
    for laco := 1 to QtdaLinha do
    begin
     inc(conta);
     Etiquetas[conta] := TShape.Create(fundo);
     Etiquetas[conta].parent := Fundo.Parent;
     Etiquetas[conta].Height := AlturaEti;
     Etiquetas[conta].Width := LarguraEti;
     Etiquetas[conta].Top := SomaLinha;
     SomaLinha := SomaLinha + AlturaEti + 1;
     Etiquetas[conta].Left := somacoluna;
     Etiquetas[conta].Shape := stRoundRect;
     Etiquetas[conta].Tag := conta;
     Etiquetas[conta].OnMouseUp := MarcaSelecaoAImprimir;
    end;
    SomaColuna := SomaColuna + larguraEti + 1
  end;
  PainelFundo.Height := SomaLinha + 10 ;
  PainelFundo.Width := SomaColuna + 8 ;
  LPosicao.Top := PainelFundo.Height + PainelFundo.top + 4;
end;

{************************* Marca o inicio de impressao ********************* }
procedure TFImprimeCodigoBarra.MarcaSelecaoAImprimir(Sender: TObject;
          Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  laco : Integer;
begin
  if (Sender is TShape) then
    MarcaEtiqueta((Sender as TShape).Tag)
end;

{****************configura as etiquetas a imprimir e as impressas *********** }
procedure TFImprimeCodigoBarra.MarcaEtiqueta( Posicao : Integer );
var
  laco, conta : integer;
begin
  conta := 1;

  for laco := 1 to 400 do
    if Etiquetas[laco] <> nil then
      Etiquetas[laco].Brush.Color := clsilver;

  if posicao = 0 then
    posicao := 1;

  for laco := posicao to 400  do
    if Etiquetas[laco] <> nil then
    begin
      if conta > SomaQdade then
        Etiquetas[laco].Brush.Color := clwhite
      else
        Etiquetas[laco].Brush.Color := clBlue;
      inc(conta);
    end
    else
       break;
  LPosicao.Caption := 'Posiçao : ' + IntToStr(Posicao);
  PosicaoImpressao := Posicao;
end;

{*************** acerta a posicao de impressao apos imprimir *****************}
procedure TFImprimeCodigoBarra.AcertaRetorno;
var
  QdadeRestante : double;
begin
  QdadeRestante := (Linhas * Colunas) -  PosicaoImpressao;

  if ( QdadeRestante - SomaQdade ) >= 0 then
    PosicaoImpressao := PosicaoImpressao + trunc(SomaQdade)
  else
  begin
    QdadeRestante := SomaQdade - QdadeRestante;
    while QdadeRestante >= (Linhas * Colunas) do
      QdadeRestante := QdadeRestante - (Linhas * Colunas);
    PosicaoImpressao := Trunc(QdadeRestante);
  end;

  numerico1.AValor := 0;
  EcodPro.Text := '';
  label1.Caption := '';
  GradePro.Clear;

  MarcaEtiqueta(PosicaoImpressao);
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                         Diveros
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{**************** fecha o formulario **************************************** }
procedure TFImprimeCodigoBarra.BFecharClick(Sender: TObject);
begin
  self.close;
end;

{************************* Marca a qdade de produto *************************}
procedure TFImprimeCodigoBarra.numerico1Exit(Sender: TObject);
begin
  MarcaEtiqueta(PosicaoImpressao);
end;

{ ********************************* Botao Ajuda ***************************** }
procedure TFImprimeCodigoBarra.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FImprimeCodigoBarra.HelpContext);
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                      Gera impressao de codigo de barra
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{**************** apos o scroll da tabela ********************************** }
procedure TFImprimeCodigoBarra.CAD_DOCAfterScroll(DataSet: TDataSet);
begin
  if Paginas.ActivePage = TabSheet2 then
  begin
    numerico1.AValor := 0;
    Colunas := CAD_DOCN_COL_ETI.AsInteger;
    Linhas := CAD_DOCN_LIN_ETI.AsInteger;
    MontaPosicao(Linhas, Colunas );
    MarcaEtiqueta(1);
    if CAD_DOCC_COD_BAR.AsString  <> '' then
      ComboBoxColor1.ItemIndex := StrToInt(CAD_DOCC_COD_BAR.AsString[1]);
  end;
end;

{****************** imprime o codigo de barra do produto ********************* }
procedure TFImprimeCodigoBarra.BitBtn1Click(Sender: TObject);
begin
  SomaTotais(SeqProdutos,QdadeProdutos);
  IMP.AdicionaItemsTemporaria( PosicaoImpressao, SeqProdutos,QdadeProdutos);
  if Paginas.ActivePage = TabSheet2 then
  begin
    FImprimeEtiquetaBarra := TFImprimeEtiquetaBarra.CriarSDI(application, '', true);
    FImprimeEtiquetaBarra.ImprimeBarra( CAD_DOCI_NRO_DOC.AsInteger,ComboBoxColor1.ItemIndex);
    FImprimeEtiquetaBarra.Pagina.Preview;
    FImprimeEtiquetaBarra.close;
    AcertaRetorno;
    EcodPro.SetFocus;
  end
  else
  begin
    if Arquivos.FileName <> '' then
    begin
      if rel <> nil then
        rel.free;
      rel := TCrpe.Create(self);
      rel.ReportName := Arquivos.FileName;
      rel.ParamFields.Retrieve;
      rel.ParamFields [0].Value := inttostr(varia.CodigoEmpFil);
      rel.ParamFields [1].Value := inttostr(varia.CodigoEmpresa);
      If Uppercase(Varia.CodigoProduto) = 'C_COD_PRO' then
        rel.ParamFields [2].Value := '1'
      else
        rel.ParamFields [2].Value := '0';
      rel.ParamFields [3].Value := inttostr(varia.TabelaPreco);
      rel.WindowState := wsMaximized;
      rel.execute;
      AcertaRetorno;
    end
    else
      aviso('Escolha um tipo de etiqueta');
  end;
end;


procedure TFImprimeCodigoBarra.BitBtn2Click(Sender: TObject);
begin
  if (EcodPro.Text <> '') and (numerico1.AValor <> 0) then
    Adiciona(SeqProAImprimir,trunc(numerico1.AValor),label1.caption)
  else
    aviso('Valores inválidos');
   MarcaEtiqueta(PosicaoImpressao);
end;


procedure  TFImprimeCodigoBarra.Adiciona( SeqPro, Qdade : integer; NomeProduto : string);
var
  Dados : TDadoPro;
begin
  Dados := TDadoPro.Create;
  Dados.SeqPro := SeqPro;
  Dados.Qdade := Qdade;
  GradePro.Items.AddObject(NomeProduto +
                          ' - Qdade : ' + Inttostr(Qdade),dados);
end;

procedure TFImprimeCodigoBarra.BitBtn3Click(Sender: TObject);
begin
  GradePro.Items.Delete(GradePro.ItemIndex);
  MarcaEtiqueta(PosicaoImpressao);
end;

procedure TFImprimeCodigoBarra.ArquivosClick(Sender: TObject);
begin
  if Arquivos.ItemIndex <> -1 then
  begin
    numerico1.AValor := 0;
    linhas :=  strtoInt(copy(arquivos.Items.strings[arquivos.itemindex],10,2));
    Colunas := strtoInt(copy(arquivos.Items.strings[arquivos.itemindex],15,2));
    MontaPosicao(Linhas, Colunas );
    MarcaEtiqueta(1);
  end;
end;

procedure TFImprimeCodigoBarra.PaginasChange(Sender: TObject);
begin
  if paginas.ActivePage = TabSheet1 then
    ArquivosClick(nil)
  else
    CAD_DOCAfterScroll(nil);
end;

procedure TFImprimeCodigoBarra.CarregaDados(CodigoProduto : string; Qdade : Integer);
begin
  Paginas.ActivePage := TabSheet2;
  numerico1.AValor := Qdade;
  EcodPro.Text := CodigoProduto;
  EcodProExit(EcodPro);
  BitBtn2.Click;
  numerico1.AValor := 0;
  EcodPro.text := '';
  label1.Caption := '';
  Self.ShowModal;
end;

procedure TFImprimeCodigoBarra.EditLocaliza1Select(Sender: TObject);
begin
   EditLocaliza1.ASelectValida.Clear;
   EditLocaliza1.ASelectValida.add( 'Select * from dba.CadClassificacao'+
                                    ' where I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                                    ' and c_Cod_Cla = ''@''' +
                                    ' and c_tip_cla = ''P''' +
                                    ' and c_Con_cla = ''S'' ' );
   EditLocaliza1.ASelectLocaliza.Clear;
   EditLocaliza1.ASelectLocaliza.add( 'Select * from dba.cadClassificacao'+
                                      ' where I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                                      ' and c_nom_Cla like ''@%'' ' +
                                      ' and c_Con_cla = ''S'' ' +
                                      ' and c_tip_cla = ''P''' +
                                      ' order by c_cod_Cla asc');
end;

procedure TFImprimeCodigoBarra.BitBtn4Click(Sender: TObject);
begin
  if (EditLocaliza1.Text <> '') and (numerico1.AValor <> 0) then
  begin
    AdicionaSQLAbreTabela(Aux,' Select * from cadprodutos ' +
                              ' where i_cod_emp = ' + Inttostr(varia.CodigoEmpresa) +
                              ' and c_cod_cla like ''' +  EditLocaliza1.text + '%''' );
    while not aux.eof do
    begin
      Adiciona(aux.fieldByName('i_seq_pro').AsInteger,
               trunc(numerico1.AValor),
               aux.fieldByName('c_nom_pro').AsString);
      Aux.next;
    end;
  end
  else
    aviso('Valores inválidos');
   aux.close;
   MarcaEtiqueta(PosicaoImpressao);
end;

Initialization
 RegisterClasses([TFImprimeCodigoBarra]);
end.
