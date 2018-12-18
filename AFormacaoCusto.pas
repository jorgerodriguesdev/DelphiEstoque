unit AFormacaoCusto;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Grids, DBGrids, Tabela, Db, DBTables, Componentes1, ExtCtrls,
  PainelGradiente, StdCtrls, Localizacao, Buttons, Mask, DBCtrls, numericos,
  ComCtrls, unProdutos, UCrpe32;

type
  TFFormacaoCusto = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor2: TPanelColor;
    CadProdutos: TQuery;
    DataCadProdutos: TDataSource;
    Grade: TDBGridColor;
    MovItensCusto: TQuery;
    DataCustoItens: TDataSource;
    Localiza: TConsultaPadrao;
    PanelColor1: TPanelColor;
    PanelColor4: TPanelColor;
    aux: TQuery;
    Label8: TLabel;
    EditLocaliza1: TEditLocaliza;
    SpeedButton1: TSpeedButton;
    Label4: TLabel;
    Label15: TLabel;
    CodPro: TEditColor;
    LocalizaEdit1: TLocalizaEdit;
    Label16: TLabel;
    MovItensCustoI_COD_EMP: TIntegerField;
    MovItensCustoI_SEQ_PRO: TIntegerField;
    MovItensCustoI_COD_ITE: TIntegerField;
    MovItensCustoN_VLR_CUS: TFloatField;
    MovItensCustoN_PER_CUS: TFloatField;
    MovItensCustoD_DAT_ATU: TDateField;
    MovItensCustoC_NOM_ITE: TStringField;
    DataFichaTec: TDataSource;
    FichaTec: TQuery;
    FichaTecI_PRO_COM: TIntegerField;
    FichaTecI_SEQ_PRO: TIntegerField;
    FichaTecC_COD_UNI: TStringField;
    FichaTecN_QTD_PRO: TFloatField;
    FichaTecI_COD_EMP: TIntegerField;
    FichaTecD_ULT_ALT: TDateField;
    FichaTecC_NOM_PRO: TStringField;
    FichaTecN_CUS_COM: TFloatField;
    FichaTecTotalCusto: TCurrencyField;
    FichaTecC_UNI_PAI: TStringField;
    PageControl1: TPageControl;
    TabSheet4: TTabSheet;
    DBGridColor1: TDBGridColor;
    TabSheet5: TTabSheet;
    DBGridColor2: TDBGridColor;
    TabSheet6: TTabSheet;
    DBGridColor5: TDBGridColor;
    PanelColor5: TPanelColor;
    Custo: Tnumerico;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Label11: TLabel;
    TotalMatBasica: Tnumerico;
    Label7: TLabel;
    TotalValor: Tnumerico;
    TotalPerc: Tnumerico;
    Label5: TLabel;
    numerico1: Tnumerico;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    numerico2: Tnumerico;
    DataMovItensCustoImp: TDataSource;
    MovItensCustoImp: TQuery;
    IntegerField1: TIntegerField;
    IntegerField2: TIntegerField;
    IntegerField3: TIntegerField;
    DateField1: TDateField;
    StringField1: TStringField;
    Label6: TLabel;
    numerico3: Tnumerico;
    MovItensCustoImpN_PER_CUS: TFloatField;
    Label9: TLabel;
    EditLocaliza4: TEditLocaliza;
    SpeedButton3: TSpeedButton;
    Label10: TLabel;
    MovItensCustoImpN_VLR_CUS: TFloatField;
    Label12: TLabel;
    numerico4: Tnumerico;
    EditColor1: TEditColor;
    EditColor2: TEditColor;
    BitBtn1: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn6: TBitBtn;
    PanelColor3: TPanelColor;
    Atipro: TCheckBox;
    CheckBox1: TCheckBox;
    BitBtn8: TBitBtn;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    BitBtn7: TBitBtn;
    Rel: TCrpe;
    FichaTecN_QTD_COM: TFloatField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LocalizaEdit1Select(Sender: TObject);
    procedure AtiProClick(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure GradeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GradeKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditLocaliza1Select(Sender: TObject);
    procedure EditLocaliza1Retorno(Retorno1, Retorno2: String);
    procedure PaginasChange(Sender: TObject);
    procedure CadProdutosAfterScroll(DataSet: TDataSet);
    procedure FichaTecCalcFields(DataSet: TDataSet);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure TotalMatBasicaChange(Sender: TObject);
    procedure TotalValorChange(Sender: TObject);
    procedure CustoChange(Sender: TObject);
    procedure EditLocaliza4Select(Sender: TObject);
    procedure numerico3Change(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    TeclaPressionada : boolean;
    UnPro : TFuncoesProduto;
    procedure AtualizaSelectProdutos;
    procedure CarregaMovimento( SeqPro : integer );  // no custo, caso seja produto
    procedure SomaVariaveiscusto;
  public
    { Public declarations }
  end;

var
  FFormacaoCusto: TFFormacaoCusto;

implementation

uses APrincipal, constantes, ConstMsg, AItensCusto, funsql,
  AConfigItensCusto, AComprosicaoProduto, funobjeto;

{$R *.DFM}


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                 acoes de inicializacoes e gerais
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{ ****************** Na criação do Formulário ******************************** }
procedure TFFormacaoCusto.FormCreate(Sender: TObject);
begin
  rel.ReportName := varia.PathRel + '\diverso\CustoProduto.rpt';
  MudaMacaraDisplay([MovItensCustoN_VLR_CUS,FichaTecN_CUS_COM,FichaTecTotalCusto],varia.cifraoMoeda + varia.MascaraCusto);
  MudaMacaraDisplay([MovItensCustoN_PER_CUS,MovItensCustoImpN_PER_CUS], varia.mascaraCusto + ' %');
  MudaMacaraEdicao([MovItensCustoN_VLR_CUS,FichaTecN_CUS_COM,FichaTecTotalCusto],varia.MascaraCusto);
  MudaMacaraEdicao([MovItensCustoN_PER_CUS,MovItensCustoImpN_PER_CUS], varia.mascaraCusto);
  MudaMacaraNumericos([TotalMatBasica,Custo,TotalValor,numerico3], varia.cifraoMoeda + Varia.MascaraCusto, varia.DecimaisCusto);
  MudaMacaraNumericos([numerico1,TotalPerc,numerico2], Varia.MascaraCusto + ' %', varia.DecimaisCusto);
  UnPro := TFuncoesProduto.criar(self,fprincipal.BaseDados);
  grade.Columns[0].FieldName := varia.CodigoProduto;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFFormacaoCusto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 MovItensCusto.close;
 MovItensCustoImp.close;
 FichaTec.close;
 CadProdutos.close;
 Aux.close;
 UnPro.free;
 Action := CaFree;
end;

{****************** fecha o formulario ************************************** }
procedure TFFormacaoCusto.BitBtn8Click(Sender: TObject);
begin
close;
end;

procedure TFFormacaoCusto.FormShow(Sender: TObject);
begin
  EditLocaliza4Select(nil);
  EditLocaliza4.Text := IntToStr(varia.TabelaPreco);
  EditLocaliza4.Atualiza;
  AtualizaSelectProdutos;
  TeclaPressionada := false;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                 Localizacao e atualizacao dos produtos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{ **************************** Select Tabela Preco ************************** }
procedure TFFormacaoCusto.EditLocaliza4Select(Sender: TObject);
begin
  EditLocaliza4.ASelectValida.Clear;
  EditLocaliza4.ASelectValida.Add(' select * from cadTabelaPreco ' +
                                  ' where  i_cod_tab =  @ ' +
                                  ' and i_cod_emp = ' + InttoStr( Varia.CodigoEmpresa));
  EditLocaliza4.ASelectLocaliza.Clear;
  EditLocaliza4.ASelectLocaliza.Add(' select * from cadTabelaPreco ' +
                                    ' where  c_nom_tab like ''@%'' ' +
                                    ' and i_cod_emp = ' + InttoStr( Varia.CodigoEmpresa));
end;

{************************ localiza classificacoes *************************}
procedure TFFormacaoCusto.EditLocaliza1Select(Sender: TObject);
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

{***********  select que localiza os nomes padrao ************************** }
procedure TFFormacaoCusto.LocalizaEdit1Select(Sender: TObject);
begin
  LocalizaEdit1.ASelect.Clear;
  LocalizaEdit1.ASelect.Add(' select ' + varia.CodigoProduto + ', ' +
                            ' Tab.I_SEQ_PRO, Tab.I_COD_EMP, Pro.C_COD_CLA, Pro.C_COD_UNI, ' +
                            ' Tab.I_COD_MOE, Pro.C_NOM_PRO, Pro.C_ATI_PRO, Pro.C_KIT_PRO, ' +
                            ' Tab.I_COD_TAB, Pro.N_PER_MAK, Mov.I_EMP_FIL, ' +
                            ' Tab.N_PER_MAX, Pro.N_IND_MUL, tab.n_vlr_mar, pro.c_uni_com, ' +
                            CampoNumeroFormatodecimalMoeda('Tab.N_VLR_VEN','Venda','Tab.C_CIF_MOE', true,CurrencyDecimals) +
                            CampoNumeroFormatodecimalMoeda('Mov.N_VLR_COM','compra','Pro.C_CIF_MOE',true, varia.DecimaisCusto) +
                            CampoNumeroFormatodecimalMoeda('Tab.N_VLR_MAR','markup','Tab.C_CIF_MOE',true, varia.DecimaisCusto) +
                            CampoNumeroFormatodecimalMoeda('Mov.N_CUS_COM','CustoCompra','Pro.C_CIF_MOE',true, varia.DecimaisCusto) +
                            CampoNumeroFormatodecimalMoeda('Tab.N_VLR_CUS','custo','Tab.C_CIF_MOE',true, varia.DecimaisCusto) +
                            CampoNumeroFormatodecimalMoeda('pro.n_vlr_max','maximo','Pro.C_CIF_MOE',true,CurrencyDecimals) +
                            ' Tab.N_VLR_VEN, Mov.N_VLR_COM, Tab.N_VLR_CUS, mov.n_cus_com, pro.n_vlr_max  ' +
                            ' from CadProdutos as pro, MovTabelaPreco as tab,' +
                            ' MovQdadeProduto as mov ' +
                            ' where pro.i_cod_emp = ' + IntTostr(varia.CodigoEmpresa) +
                            ' and pro.i_cod_emp = tab.i_cod_emp ' +
                            ' and pro.i_seq_pro = tab.i_seq_pro ' +
                            ' and pro.i_seq_pro = mov.i_seq_pro ' +
                            ' and mov.i_emp_fil = ' + IntTostr(varia.CodigoEmpFil) +
                            ' and pro.c_nom_pro like ''@%''' );

end;

{ ************  Atualiza a select dos produtos ****************************** }
procedure TFFormacaoCusto.AtualizaSelectProdutos;
begin
  LocalizaEdit1.AOrdem := '';

  if EditLocaliza4.text <> '' then
    LocalizaEdit1.AOrdem := ' and tab.i_cod_tab = ' + EditLocaliza4.text;

  if AtiPro.Checked then
    LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem + ' and pro.c_ati_pro = ''S''';

  if EditLocaliza1.Text <> '' then
    LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem +
                            ' and pro.c_cod_cla like ''' + EditLocaliza1.Text + '%''' ;

  if CheckBox1.Checked then
     LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem + ' and isnull(n_cus_com,0) = 0 ' ;

  LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem + ' and tab.I_COD_MOE = ' + inttostr(varia.MoedaBase);

  if codpro.Text <> '' then
     LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem + ' and ' + Varia.CodigoProduto + ' =  ''' + codpro.text + '''';

  if CheckBox2.Checked then
     LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem + ' and pro.i_seq_pro not in ( select i_seq_pro from movitenscusto where i_cod_emp = ' +
                                                                                 inttostr(varia.CodigoEmpresa)  + ' and i_cod_tab = ' + EditLocaliza4.Text + '  ) ' ;

  if CheckBox3.Checked then
     LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem + ' and pro.i_seq_pro in ( select i_seq_pro from movitenscusto where i_cod_emp = ' +
                                                                            inttostr(varia.CodigoEmpresa)  + ' and i_cod_tab = ' + EditLocaliza4.Text + '  ) ' ;

  if CheckBox4.Checked then
     LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem + ' and pro.i_seq_pro not in ( select i_pro_com from movcomposicaoproduto ) ' ;

  LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem + ' order by pro.c_nom_pro';

  LocalizaEdit1.AtualizaTabela;

end;

{ ************** altera  os produtos em atividade ************************** }
procedure TFFormacaoCusto.AtiProClick(Sender: TObject);
begin
  AtualizaSelectProdutos;
end;

{*************** atualiza no retorno *****************************************}
procedure TFFormacaoCusto.EditLocaliza1Retorno(Retorno1, Retorno2: String);
begin
  AtualizaSelectProdutos;
end;


{******************** atualiza o movimentos de iten de custo *****************}
procedure TFFormacaoCusto.CadProdutosAfterScroll(DataSet: TDataSet);
begin
  if not TeclaPressionada then
  begin
    EditColor2.text := CadProdutos.fieldByname('c_cod_uni').AsString;
    if CadProdutos.fieldByname('c_uni_com').AsString <> '' then
      EditColor1.text := CadProdutos.fieldByname('c_uni_com').AsString
    else
      EditColor1.text := CadProdutos.fieldByname('c_cod_uni').AsString;
    CarregaMovimento(CadProdutos.fieldByname('I_Seq_pro').AsInteger);
    TabSheet4.TabVisible := not FichaTec.eof;
  end;
end;

{*************** Quando muda a pagina ***************************************}
procedure TFFormacaoCusto.PaginasChange(Sender: TObject);
begin
  CadProdutosAfterScroll(nil);
end;

{ **************** para ganhar velocidade na ovimentacaodo grid*************** }
procedure TFFormacaoCusto.GradeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  TeclaPressionada := true;
end;

{ **************** para ganhar velocidade na ovimentacaodo grid*************** }
procedure TFFormacaoCusto.GradeKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  TeclaPressionada := false;
  if key in [ 38,40 ] then
    CadProdutosAfterScroll(nil);
end;

procedure TFFormacaoCusto.FichaTecCalcFields(DataSet: TDataSet);
begin
  FichaTecTotalCusto.AsFloat := FichaTecN_QTD_COM.AsFloat * FichaTecN_CUS_COM.AsFloat;
end;

procedure TFFormacaoCusto.BitBtn2Click(Sender: TObject);
var
  ponto : TBookmark;
begin
  if Confirmacao('Deseja realmente alterar o valor de venda do produto selecionado contido na tabela ' + Label10.Caption) then
  begin
    ponto := Cadprodutos.GetBookmark;
    UnPro.AdicionaValorCusto( CadProdutos.fieldByname('i_seq_pro').AsInteger, strtoint(EditLocaliza4.Text),
                              custo.AValor, numerico2.avalor, totalvalor.avalor, numerico4.avalor, numerico3.avalor);
    AtualizaSQLTabela(CadProdutos);
    Cadprodutos.GotoBookmark(ponto);
    Cadprodutos.FreeBookmark(ponto);
  end;
end;

procedure TFFormacaoCusto.BitBtn3Click(Sender: TObject);
begin
  if Confirmacao('Deseja realmente cálcular e alterar o valor de venda para todos os produtos da seleção contidos na tabela ' + Label10.Caption) then
  begin
    CadProdutos.First;
    while not CadProdutos.Eof do
    begin
      UnPro.AdicionaValorCusto( CadProdutos.fieldByname('i_seq_pro').AsInteger, strtoint(EditLocaliza4.Text),
                                custo.AValor, numerico2.avalor, totalvalor.avalor, numerico4.avalor, numerico3.avalor);
      CadProdutos.next;
    end;
    AtualizaSQLTabela(CadProdutos);
  end;
end;

procedure TFFormacaoCusto.BitBtn1Click(Sender: TObject);
begin
  FConfigItensCusto := TFConfigItensCusto.CriarSDI(application,'', FPrincipal.VerificaPermisao('FConfigItensCusto'));
  FConfigItensCusto.CarregaItem(CadProdutos.fieldByname(varia.CodigoProduto).AsString, EditLocaliza4.Text);
  AtualizaSelectProdutos;
end;



{ ************ Carrega o movimento dos Itens caso seja produto ************** }
procedure TFFormacaoCusto.CarregaMovimento( SeqPro : integer );
begin
  unpro.LocalizaItensCusto(MovItensCusto, seqpro,2, StrtoInt(EditLocaliza4. text));
  unpro.LocalizaItensCustoImpostos(MovItensCustoImp, seqpro,StrtoInt(EditLocaliza4. text));
  unpro.LocalizaComposicaoProCusto(FichaTec,SeqPro);
  SomaVariaveiscusto;
end;

{ ************************** soma varia variaveis de custo ******************}
procedure  TFFormacaoCusto.SomaVariaveiscusto;
var
  Valor, Percentual : Double;
begin

  TotalMatBasica.AValor := UnPro.SomaTotalMatBasica(CadProdutos.fieldByname('I_Seq_pro').AsInteger);

  // despesas
  UnPro.SomaVariaveisCusto(MovItensCusto, Valor, Percentual);
  TotalValor.AValor := Valor;
  TotalPerc.AValor := Percentual;

  // Impostos
  UnPro.SomaVariaveisCusto(MovItensCustoImp, Valor, Percentual);
  numerico1.AValor :=  Percentual;
end;


procedure TFFormacaoCusto.TotalMatBasicaChange(Sender: TObject);
begin
  custo.AValor := TotalMatBasica.AValor;
end;

procedure TFFormacaoCusto.TotalValorChange(Sender: TObject);
begin
  numerico2.AValor := TotalPerc.AValor + numerico1.AValor;
end;



procedure TFFormacaoCusto.CustoChange(Sender: TObject);
begin
  if Config.SomaAntesMarkup then
    numerico3.AValor := (custo.AValor + Totalvalor.AValor) * (100/(100-numerico2.AValor))
  else
    numerico3.AValor := (custo.AValor * (100/(100-numerico2.AValor))) + Totalvalor.AValor;
end;


procedure TFFormacaoCusto.numerico3Change(Sender: TObject);
begin
  if (EditColor1.text <> '') and (EditColor2.text <> '') then
    numerico4.AValor := UnPro.CalculaValorPadrao( EditColor2.text, EditColor1.text,
                                                  numerico3.avalor, CadProdutos.fieldByname('I_Seq_pro').AsString);
end;

procedure TFFormacaoCusto.BitBtn4Click(Sender: TObject);
begin
  FComposicaoProduto := TFComposicaoProduto.CriarSDI(application,'',FPrincipal.VerificaPermisao('FComposicaoProduto'));
  FComposicaoProduto.CarregaComposicao(CadProdutos.fieldByname(varia.CodigoProduto).AsString);
  AtualizaSelectProdutos;
end;

procedure TFFormacaoCusto.BitBtn6Click(Sender: TObject);
var
  Valor : string;
begin
  valor := FichaTecN_CUS_COM.AsString;
  if EntradaNumero( 'Valor', 'Digite o valor de Custo de Compra', valor, false, FPrincipal.CorFoco.AFundoComponentes, fprincipal.CorForm.ACorPainel, true, varia.DecimaisCusto) then
  begin
    UnPro.AtualizaCustoCompra(FichaTecI_SEQ_PRO.asinteger,StrToFloat(Valor));
    AtualizaSelectProdutos;
  end;
end;

procedure TFFormacaoCusto.BitBtn7Click(Sender: TObject);
begin
 rel.ParamFields.Retrieve;
 rel.ParamFields[0].Value := Inttostr(varia.CodigoEmpFil);
 rel.ParamFields[1].Value := Inttostr(varia.CodigoEmpresa);
 rel.ParamFields[2].Value := CadProdutos.fieldByName('i_seq_pro').AsString;
 rel.ParamFields[3].Value := EditLocaliza4.text;
 rel.ParamFields[4].Value := Inttostr(varia.CodigoEmpFil);
 rel.ParamFields[5].Value := Inttostr(varia.CodigoEmpresa);
 rel.ReportTitle  := 'Planilha de custo do produto ' + UpperCase(CadProdutos.fieldByName('c_nom_pro').AsString);
 rel.execute;
end;



Initialization
 RegisterClasses([TFFormacaoCusto]);
end.
