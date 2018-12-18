unit AConfigItensCusto;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Grids, DBGrids, Tabela, Db, DBTables, Componentes1, ExtCtrls,
  PainelGradiente, StdCtrls, Localizacao, Buttons, Mask, DBCtrls, numericos,
  ComCtrls, unProdutos;

type
  TFConfigItensCusto = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor2: TPanelColor;
    CadProdutos: TQuery;
    DataCadProdutos: TDataSource;
    Grade: TDBGridColor;
    Localiza: TConsultaPadrao;
    PanelColor1: TPanelColor;
    Paginas: TPageControl;
    TabSheet3: TTabSheet;
    PanelColor3: TPanelColor;
    Atipro: TCheckBox;
    cadItensCusto: TQuery;
    DBGridColor3: TDBGridColor;
    DBGridColor4: TDBGridColor;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    CadMovItensCusto: TQuery;
    DataCadMovItensCusto: TDataSource;
    DatacadItensCusto: TDataSource;
    CadItens: TQuery;
    CadMovItensCustoNomeItem: TStringField;
    PanelColor4: TPanelColor;
    BitBtn8: TBitBtn;
    aux: TQuery;
    Label8: TLabel;
    EditLocaliza1: TEditLocaliza;
    SpeedButton1: TSpeedButton;
    Label4: TLabel;
    Label15: TLabel;
    CodPro: TEditColor;
    LocalizaEdit1: TLocalizaEdit;
    Label16: TLabel;
    CadMovItensCustoI_COD_EMP: TIntegerField;
    CadMovItensCustoI_SEQ_PRO: TIntegerField;
    CadMovItensCustoI_COD_ITE: TIntegerField;
    CadMovItensCustoN_VLR_CUS: TFloatField;
    CadMovItensCustoN_PER_CUS: TFloatField;
    CadMovItensCustoD_DAT_ATU: TDateField;
    TabSheet2: TTabSheet;
    Label9: TLabel;
    numerico2: Tnumerico;
    Label10: TLabel;
    numerico3: Tnumerico;
    BitBtn5: TBitBtn;
    EditLocaliza2: TEditLocaliza;
    SpeedButton2: TSpeedButton;
    Label2: TLabel;
    Label3: TLabel;
    BitBtn1: TBitBtn;
    Bevel1: TBevel;
    Bevel2: TBevel;
    CheckBox1: TCheckBox;
    TabSheet1: TTabSheet;
    DBGridColor1: TDBGridColor;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    DBGridColor2: TDBGridColor;
    DataMovItensCustoImp: TDataSource;
    CadItensImp: TQuery;
    CadMovItensCustoImp: TQuery;
    StringField1: TStringField;
    IntegerField1: TIntegerField;
    IntegerField2: TIntegerField;
    IntegerField3: TIntegerField;
    FloatField1: TFloatField;
    DateField1: TDateField;
    DataCadItensCustoImp: TDataSource;
    CadItensCustoImp: TQuery;
    CadMovItensCustoI_DES_IMP: TIntegerField;
    CadMovItensCustoImpI_DES_IMP: TIntegerField;
    BitBtn2: TBitBtn;
    EditLocaliza3: TEditLocaliza;
    SpeedButton7: TSpeedButton;
    Label6: TLabel;
    Bevel3: TBevel;
    CadMovItensCustoImpN_PER_CUS: TFloatField;
    Label1: TLabel;
    EditLocaliza4: TEditLocaliza;
    SpeedButton8: TSpeedButton;
    Label5: TLabel;
    CadMovItensCustoI_COD_TAB: TIntegerField;
    CadMovItensCustoImpI_COD_TAB: TIntegerField;
    CadMovItensCustoD_ULT_ALT: TDateField;
    CadMovItensCustoImpD_ULT_ALT: TDateField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LocalizaEdit1Select(Sender: TObject);
    procedure AtiProClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure GradeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GradeKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditLocaliza1Select(Sender: TObject);
    procedure EditLocaliza1Retorno(Retorno1, Retorno2: String);
    procedure BitBtn1Click(Sender: TObject);
    procedure CadProdutosBeforeScroll(DataSet: TDataSet);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure PaginasChange(Sender: TObject);
    procedure EditLocaliza3Select(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure EditLocaliza3Retorno(Retorno1, Retorno2: String);
    procedure EditLocaliza2Retorno(Retorno1, Retorno2: String);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure EditLocaliza4Select(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGridColor3Exit(Sender: TObject);
    procedure DBGridColor1Exit(Sender: TObject);
  private
    TeclaPressionada : boolean;
    UnPro : TFuncoesProduto;
    TipoItens, SeqProdutos : Integer;
    procedure AtualizaSelectProdutos;
    procedure carregaMovimentoItens(SeqPro : integer );  // para adicionar novos itens de custo a um produto
    procedure CarregaNovoIten(Tabela : TQuery; SeqPro, CodIten, TipoIten, CodTabela : integer; Valor, Percentual : Double );
    procedure carregaMovimentoItensImp( SeqPro : integer );
  public
    procedure CarregaItem( CodProduto, CodTabela : String);
  end;

var
  FConfigItensCusto: TFConfigItensCusto;

implementation

uses APrincipal, constantes, ConstMsg, AItensCusto, funsql, funobjeto;

{$R *.DFM}


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                 acoes de inicializacoes e gerais
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{ ****************** Na criação do Formulário ******************************** }
procedure TFConfigItensCusto.FormCreate(Sender: TObject);
begin
  UnPro := TFuncoesProduto.criar(self,fprincipal.BaseDados);
  EditLocaliza4Select(nil);
  EditLocaliza4.Text := IntToStr(varia.TabelaPreco);
  EditLocaliza4.Atualiza;

  grade.Columns[0].FieldName := varia.CodigoProduto;
  CadItens.open;

  MudaMacaraDisplay([CadMovItensCustoN_VLR_CUS],varia.cifraomoeda + varia.mascaracusto);
  MudaMacaraEdicao([CadMovItensCustoN_VLR_CUS],varia.mascaracusto);
  MudaMacaraDisplay([CadMovItensCustoN_PER_CUS,CadMovItensCustoImpN_PER_CUS], varia.mascaracusto + ' %');
  MudaMacaraEdicao([CadMovItensCustoN_PER_CUS,CadMovItensCustoImpN_PER_CUS],varia.mascaracusto);
  MudaMacaraEdicaoDisplay([CadMovItensCustoN_VLR_CUS,CadMovItensCustoN_PER_CUS,CadMovItensCustoImpN_PER_CUS],varia.mascaracusto);
  MudaMacaraNumericos([numerico2], varia.cifraoMoeda + varia.mascaraCusto ,Varia.DecimaisCusto);
  MudaMacaraNumericos([numerico3], varia.mascaraCusto + ' %',Varia.DecimaisCusto);
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFConfigItensCusto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 CadProdutos.close;
 CadItens.close;
 CadMovItensCusto.close;
 cadItensCusto.close;
 CadItensImp.close;
 CadMovItensCustoImp.close;
 cadItensCustoImp.close;
 Aux.close;
 UnPro.free;
 Action := CaFree;
end;

procedure TFConfigItensCusto.FormShow(Sender: TObject);
begin
  AtualizaSelectProdutos;
  TeclaPressionada := false;
end;

{****************** fecha o formulario ************************************** }
procedure TFConfigItensCusto.BitBtn8Click(Sender: TObject);
begin
  close;
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                 Localizacao e atualizacao dos produtos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{************************ localiza classificacoes *************************}
procedure TFConfigItensCusto.EditLocaliza1Select(Sender: TObject);
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
procedure TFConfigItensCusto.LocalizaEdit1Select(Sender: TObject);
begin
  LocalizaEdit1.ASelect.Clear;
  LocalizaEdit1.ASelect.Add(' select ' + varia.CodigoProduto + ', ' +
                            ' Pro.C_COD_CLA, Pro.C_COD_UNI, Pro.I_SEQ_PRO, ' +
                            ' Pro.C_NOM_PRO, Pro.C_ATI_PRO, Pro.C_KIT_PRO, ' +
                            ' Pro.N_PER_MAK, Mov.I_EMP_FIL, ' +
                            ' Pro.N_IND_MUL,' +
                            CampoNumeroFormatodecimalMoeda('Mov.N_CUS_COM','compra','Pro.C_CIF_MOE',true, varia.DecimaisCusto) +
                            ' Mov.N_VLR_COM ' +
                            ' from CadProdutos as pro, ' +
                            ' MovQdadeProduto as mov ' +
                            ' where pro.i_cod_emp = ' + IntTostr(varia.CodigoEmpresa) +
                            ' and pro.i_seq_pro = mov.i_seq_pro ' +
                            ' and mov.i_emp_fil = ' + IntTostr(varia.CodigoEmpFil) +
                            ' and pro.c_nom_pro like ''@%''' );
end;

{ ************  Atualiza a select dos produtos ****************************** }
procedure TFConfigItensCusto.AtualizaSelectProdutos;
begin
  LocalizaEdit1.AOrdem := '';
  if AtiPro.Checked then
    LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem + ' and c_ati_pro = ''S''';

  if EditLocaliza1.Text <> '' then
    LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem +
                            ' and pro.c_cod_cla like ''' + EditLocaliza1.Text + '%''' ;

  if codpro.Text <> '' then
     LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem + ' and ' + Varia.CodigoProduto + ' =  ''' + codpro.text + '''';

  if CheckBox1.Checked then
     LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem + ' and isnull(n_cus_com,0) = 0 ' ;

  LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem + ' order by c_nom_pro';
  LocalizaEdit1.AtualizaTabela;
end;

{ ************** altera  os produtos em atividade ************************** }
procedure TFConfigItensCusto.AtiProClick(Sender: TObject);
begin
  AtualizaSelectProdutos;
end;

{*************** atualiza no retorno *****************************************}
procedure TFConfigItensCusto.EditLocaliza1Retorno(Retorno1, Retorno2: String);
begin
  AtualizaSelectProdutos;
end;

{ **************** para ganhar velocidade na ovimentacaodo grid*************** }
procedure TFConfigItensCusto.GradeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  TeclaPressionada := true;
end;

{ **************** para ganhar velocidade na ovimentacaodo grid*************** }
procedure TFConfigItensCusto.GradeKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  TeclaPressionada := false;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                   Pagina Despesa/Custo
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***************** carrega Movimento de itens******************************* }
procedure TFConfigItensCusto.carregaMovimentoItens( SeqPro : integer );
begin
  cadItensCusto.close;
  CadMovItensCusto.close;
  cadItensCusto.sql.Clear;
  cadItensCusto.sql.Add('select * from CadItensCusto ' +
                        ' where I_COD_ITE not in ' +
                        '( Select I_COD_ITE from MovItensCusto ' +
                        ' where I_COD_EMP = ' + IntToStr(varia.CodigoEmpresa) +
                        ' and I_SEQ_PRO = ' + IntToStr(SeqPro) +
                        ' and I_COD_TAB = ' + EditLocaliza4.text + ')' +
                        ' and I_DES_IMP = 2 ' );
  CadItensCusto.open;

  CadMovItensCusto.sql.clear;
  CadMovItensCusto.sql.Add('select * from MovItensCusto where I_COD_EMP = ' + IntToStr(varia.CodigoEmpresa) +
                           ' and I_SEQ_PRO = ' + IntToStr(SeqPro) +
                           ' and I_DES_IMP = 2 ' +
                           ' and I_COD_TAB = ' + EditLocaliza4.text );
  CadMovItensCusto.open;
end;

{ ******************** adiciona um item de custo **************************** }
procedure TFConfigItensCusto.SpeedButton3Click(Sender: TObject);
begin
  if not cadItensCusto.Eof then
  begin
    CarregaNovoIten( CadMovItensCusto, cadprodutos.fieldByname('I_SEQ_PRO').AsInteger,
                   cadItensCusto.fieldByName('I_COD_ITE').AsInteger,
                   cadItensCusto.fieldByName('I_DES_IMP').AsInteger,
                   StrToInt(EditLocaliza4.Text),
                   cadItensCusto.fieldByName('N_VLR_PAD').AsFloat,
                   cadItensCusto.fieldByName('N_PER_PAD').AsFloat);

    carregaMovimentoItens(cadprodutos.fieldByname('I_SEQ_PRO').AsInteger);
  end;
end;

{ ****************** deleta um item de custo ******************************** }
procedure TFConfigItensCusto.SpeedButton4Click(Sender: TObject);
begin
  if not CadMovItensCusto.Eof then
  begin
    CadMovItensCusto.Delete;
    carregaMovimentoItens(cadprodutos.fieldByname('I_SEQ_PRO').AsInteger);
  end;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                   Pagina Impostos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***************** carrega Movimento de itens******************************* }
procedure TFConfigItensCusto.carregaMovimentoItensImp( SeqPro : integer );
begin
  cadItensCustoImp.close;
  CadMovItensCustoImp.close;
  cadItensCustoImp.sql.Clear;
  cadItensCustoImp.sql.Add('select * from CadItensCusto ' +
                           ' where I_COD_ITE not in ' +
                           '( Select I_COD_ITE from MovItensCusto ' +
                           ' where I_COD_EMP = ' + IntToStr(varia.CodigoEmpresa) +
                           ' and I_SEQ_PRO = ' + IntToStr(SeqPro) +
                           ' and I_COD_TAB = ' + EditLocaliza4.text + ')' +
                           ' and (I_DES_IMP = 1 or I_DES_IMP = 3) ' );
  CadItensCustoImp.open;

  CadMovItensCustoImp.sql.clear;
  CadMovItensCustoImp.sql.Add('select * from MovItensCusto where I_COD_EMP = ' + IntToStr(varia.CodigoEmpresa) +
                              ' and I_SEQ_PRO = ' + IntToStr(SeqPro) +
                              ' and (I_DES_IMP = 1 or I_DES_IMP = 3)' +
                              ' and I_COD_TAB = ' + EditLocaliza4.text);
  CadMovItensCustoImp.open;
end;


procedure TFConfigItensCusto.SpeedButton5Click(Sender: TObject);
begin
  if not cadItensCustoimp.Eof then
  begin
    CarregaNovoIten(CadMovItensCusto,cadprodutos.fieldByname('I_SEQ_PRO').AsInteger,
                   cadItensCustoimp.fieldByName('I_COD_ITE').AsInteger,
                   cadItensCustoimp.fieldByName('I_DES_IMP').AsInteger,
                   StrToInt(EditLocaliza4.Text),
                   cadItensCustoimp.fieldByName('N_VLR_PAD').AsFloat,
                   cadItensCustoimp.fieldByName('N_PER_PAD').AsFloat);
    carregaMovimentoItensimp(cadprodutos.fieldByname('I_SEQ_PRO').AsInteger);
  end;
end;


procedure TFConfigItensCusto.SpeedButton6Click(Sender: TObject);
begin
  if not CadMovItensCustoImp.Eof then
  begin
    CadMovItensCustoimp.Delete;
    carregaMovimentoItensimp(cadprodutos.fieldByname('I_SEQ_PRO').AsInteger);
  end;
end;


{****************** Adiciona Um novo item ************************************}
procedure  TFConfigItensCusto.CarregaNovoIten(Tabela : TQuery; SeqPro, CodIten, TipoIten, CodTabela : integer; Valor, Percentual : Double);
begin
  Tabela.Insert;
  tabela.FieldByName('I_COD_EMP').AsInteger := Varia.CodigoEmpresa;
  tabela.FieldByName('I_COD_ITE').AsInteger := CodIten;
  tabela.FieldByName('I_SEQ_PRO').AsInteger := SeqPro;
  tabela.FieldByName('N_VLR_CUS').AsFloat := Valor;
  tabela.FieldByName('N_PER_CUS').AsFloat := Percentual;
  tabela.FieldByName('D_DAT_ATU').Value := Date;;
  tabela.FieldByName('I_DES_IMP').AsInteger := TipoIten;
  tabela.FieldByName('I_COD_TAB').AsInteger := CodTabela;
  tabela.FieldByName('D_ULT_ALT').AsDateTime := date;
  tabela.Post;
end;


{ ************** adiciona um item de custo para todos os produtos ********** }
procedure TFConfigItensCusto.BitBtn5Click(Sender: TObject);

  function verificaItemExiste( SeqPro, codItem, CodTabela : integer ) : Boolean;
  begin
     LimpaSQLTabela(Aux);
     AdicionaSQLAbreTabela(Aux, ' select * from MovItensCusto where I_COD_EMP = ' + IntToStr(varia.CodigoEmpresa) +
                                ' and I_SEQ_PRO = ' + inttostr(seqpro) +
                                ' and I_COD_ITE = ' + inttostr(CodItem) +
                                ' and I_COD_TAB = ' + IntToStr(CodTabela));
     result := not Aux.Eof;
     aux.close;
  end;

begin
  TeclaPressionada := true;
  if EditLocaliza2.text <> '' then
    if Confirmacao('Tem certeza que deseja adicionar o item ' + Label3.Caption + ' para todos os produtos selecionados') then
    begin
      if (numerico2.AValor <> 0) or ( numerico3.AValor <> 0)  then
      begin
        cadProdutos.First;
        while not CadProdutos.Eof do
        begin
          if not verificaItemExiste(cadprodutos.fieldByname('I_SEQ_PRO').AsInteger, strtoint(EditLocaliza2.text),StrToInt(EditLocaliza4.Text)) then
            CarregaNovoIten( CadMovItensCusto, cadprodutos.fieldByname('I_SEQ_PRO').AsInteger, strtoint(EditLocaliza2.text),
                             TipoItens, StrToInt(EditLocaliza4.Text), numerico2.AValor, numerico3.AValor);
          cadprodutos.Next;
        end;
      end
      else
        aviso('Valores Zerados');
    end;
  TeclaPressionada := false;
end;

procedure TFConfigItensCusto.BitBtn1Click(Sender: TObject);
begin
  TeclaPressionada := true;
  if Confirmacao('Tem certeza que deseja excluir o item ' + Label3.Caption + ' para todos os produtos selecionados') then
  begin
    if EditLocaliza2.text <> '' then
    begin
      cadProdutos.First;
      while not CadProdutos.Eof do
      begin
        LimpaSQLTabela(Aux);
        AdicionaSQLTabela(Aux, ' Delete MovItensCusto where I_COD_EMP = ' + IntToStr(varia.CodigoEmpresa) +
                               ' and I_SEQ_PRO = ' + cadprodutos.fieldByname('I_SEQ_PRO').Asstring +
                               ' and I_COD_ITE = ' + EditLocaliza2.text +
                               ' and I_COD_TAB = ' + EditLocaliza4.Text);
        Aux.ExecSQL;
        cadprodutos.Next;
      end;
    end;
  end;
  TeclaPressionada := false;
end;


procedure TFConfigItensCusto.CadProdutosBeforeScroll(DataSet: TDataSet);
begin
  if Paginas.ActivePage = TabSheet3 then
    carregaMovimentoItens(CadProdutos.fieldByname('i_seq_pro').AsInteger);
  if paginas.ActivePage = TabSheet1 then
    carregaMovimentoItensimp(CadProdutos.fieldByname('i_seq_pro').AsInteger);
end;

procedure TFConfigItensCusto.PaginasChange(Sender: TObject);
begin
  CadProdutosBeforeScroll(nil);
end;

procedure TFConfigItensCusto.EditLocaliza3Select(Sender: TObject);
begin
   EditLocaliza3.ASelectValida.clear;
   EditLocaliza3.ASelectValida.add(
           ' Select Pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
           ' pro.I_SEQ_PRO, mov.C_COD_BAR ' +
           ' From cadprodutos as pro, ' +
           ' MovQdadeProduto as mov ' +
           ' Where pro.I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
           ' and ' + varia.CodigoProduto + ' = ''@''' +
           ' and pro.C_KIT_PRO = ''P'' ' +
           ' and pro.I_seq_pro = Mov.I_seq_pro ' +
           ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil));
   EditLocaliza3.ASelectLocaliza.clear;
   EditLocaliza3.ASelectLocaliza.add(
            ' Select pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
            ' pro.I_SEQ_PRO, mov.C_COD_BAR ' +
            ' from cadprodutos as pro, ' +
            ' MovQdadeProduto as mov ' +
            ' Where pro.I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
            ' and pro.c_nom_pro like ''@%''' +
            ' and pro.C_KIT_PRO = ''P'' ' +
            ' and pro.I_seq_pro = Mov.I_seq_pro ' +
            ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil));
end;

procedure TFConfigItensCusto.BitBtn2Click(Sender: TObject);
begin
  if CadProdutos.fieldByname('i_seq_pro').AsInteger <> SeqProdutos then
  begin
    ExecutaComandoSql(aux, ' delete movItensCusto ' +
                           ' where i_cod_emp = ' + Inttostr(varia.CodigoEmpresa) +
                           ' and i_seq_pro = ' + CadProdutos.fieldByname('i_seq_pro').AsString +
                           ' and i_cod_tab = ' + EditLocaliza4.Text);
    aux.close;
    AdicionaSQLAbreTabela(aux, ' Select * from movItensCusto ' +
                               ' where i_cod_emp = ' + Inttostr(varia.CodigoEmpresa) +
                               ' and i_seq_pro = ' + Inttostr(SeqProdutos)  +
                               ' and i_cod_tab = ' + EditLocaliza4.Text);
    while not aux.eof do
    begin
       CarregaNovoIten( CadMovItensCusto,
                        CadProdutos.fieldByname('i_seq_pro').AsInteger,
                        aux.fieldbyName('i_cod_ite').AsInteger,
                        aux.fieldbyName('i_des_imp').AsInteger,
                        aux.fieldbyName('i_cod_tab').AsInteger,
                        aux.fieldbyName('n_vlr_cus').AsFloat,
                        aux.fieldbyName('n_per_cus').AsFloat);
       aux.next;
    end;
  end
  else
    erro('Não se pode adicionar os itens do produto selecionado para ele mesmo!');
end;

procedure TFConfigItensCusto.EditLocaliza3Retorno(Retorno1,
  Retorno2: String);
begin
  if retorno1 <> '' then
    SeqProdutos := StrToInt(retorno1)
  else
    if EditLocaliza2.Text = '' then
      SeqProdutos := 0;
end;

procedure TFConfigItensCusto.CarregaItem( CodProduto, CodTabela : String);
begin
  codpro.Text := CodProduto;
  EditLocaliza4Select(nil);
  EditLocaliza4.Text := CodTabela;
  EditLocaliza4.Atualiza;
  AtualizaSelectProdutos;
  self.ShowModal;
end;

procedure TFConfigItensCusto.EditLocaliza2Retorno(Retorno1,
  Retorno2: String);
begin
  if Retorno1 <> '' then
    TipoItens := StrToInt(Retorno1)
  else
    if EditLocaliza2.text = '' then
      TipoItens := 0;
end;

procedure TFConfigItensCusto.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if CadMovItensCusto.State in [ dsedit, dsInsert ] then
    CadMovItensCusto.post;
  if CadMovItensCustoImp.State in [ dsedit, dsInsert ] then
    CadMovItensCusto.post;
end;

procedure TFConfigItensCusto.EditLocaliza4Select(Sender: TObject);
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


procedure TFConfigItensCusto.DBGridColor3Exit(Sender: TObject);
begin
  if CadMovItensCusto.State in [dsEdit, dsinsert ] then
     CadMovItensCusto.Post;
end;

procedure TFConfigItensCusto.DBGridColor1Exit(Sender: TObject);
begin
  if CadMovItensCustoImp.State in [dsEdit, dsinsert ] then
     CadMovItensCustoImp.Post;
end;

Initialization
 RegisterClasses([TFConfigItensCusto]);
end.
