unit AFormacaoPreco;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Grids, DBGrids, Tabela, Db, DBTables, Componentes1, ExtCtrls,
  PainelGradiente, StdCtrls, Localizacao, Buttons, Mask, DBCtrls, numericos,
  ComCtrls, UnProdutos, Spin;

type
  TFFormacaoPreco = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor2: TPanelColor;
    CadProdutos: TQuery;
    DataCadProdutos: TDataSource;
    grade: TDBGridColor;
    Localiza: TConsultaPadrao;
    PanelColor1: TPanelColor;
    PanelColor4: TPanelColor;
    Label8: TLabel;
    EditLocaliza1: TEditLocaliza;
    SpeedButton1: TSpeedButton;
    Label4: TLabel;
    SpeedButton2: TSpeedButton;
    EditLocaliza2: TEditLocaliza;
    Label6: TLabel;
    Label7: TLabel;
    LocalizaEdit1: TLocalizaEdit;
    aux: TQuery;
    Label1: TLabel;
    EditLocaliza4: TEditLocaliza;
    SpeedButton3: TSpeedButton;
    Label2: TLabel;
    PanelColor3: TPanelColor;
    Atipro: TCheckBox;
    pagecontrol1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    BitBtn1: TBitBtn;
    BitBtn9: TBitBtn;
    TabSheet3: TTabSheet;
    BitBtn13: TBitBtn;
    BitBtn14: TBitBtn;
    TabSheet4: TTabSheet;
    BitBtn15: TBitBtn;
    SpinEditColor1: TSpinEditColor;
    Label9: TLabel;
    Label10: TLabel;
    SpinEditColor2: TSpinEditColor;
    CheckBox1: TCheckBox;
    ComboBoxColor1: TComboBoxColor;
    Label11: TLabel;
    EditLocaliza3: TEditLocaliza;
    SpeedButton5: TSpeedButton;
    Label12: TLabel;
    BitBtn7: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    Label5: TLabel;
    numerico1: Tnumerico;
    RadioButton1: TRadioButton;
    Todos: TCheckBox;
    RadioButton2: TRadioButton;
    Label3: TLabel;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    BitBtn3: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    CheckBox2: TCheckBox;
    CNomeProduto: TCheckBox;
    CPK: TCheckBox;
    CUnidade: TCheckBox;
    RVenda: TRadioButton;
    RCompra: TRadioButton;
    Rcusto: TRadioButton;
    EditColor1: TEditColor;
    Label13: TLabel;
    Label14: TLabel;
    CIndice: TCheckBox;
    BitBtn16: TBitBtn;
    BitBtn17: TBitBtn;
    CKit: TCheckBox;
    BitBtn8: TBitBtn;
    BBAjuda: TBitBtn;
    CCodigoPro: TCheckBox;
    CodPro: TEditColor;
    Data: TCalendario;
    DataMaior: TCheckBox;
    Label15: TLabel;
    Label16: TLabel;
    numerico2: Tnumerico;
    numerico3: Tnumerico;
    Label17: TLabel;
    Label18: TLabel;
    TabSheet5: TTabSheet;
    BitBtn4: TBitBtn;
    BitBtn18: TBitBtn;
    BitBtn19: TBitBtn;
    BitBtn20: TBitBtn;
    BitBtn21: TBitBtn;
    EditLocaliza5: TEditLocaliza;
    RadioButton6: TRadioButton;
    PanelColor5: TPanelColor;
    Cal1: TRadioButton;
    Cal2: TRadioButton;
    CheckBox3: TCheckBox;
    Rmaximo: TRadioButton;
    CMaxCompra: TCheckBox;
    CheckBox4: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LocalizaEdit1Select(Sender: TObject);
    procedure AtiProClick(Sender: TObject);
    procedure EditLocaliza1Retorno(Retorno1, Retorno2: String);
    procedure BitBtn3Click(Sender: TObject);
    procedure EditLocaliza2Retorno(Retorno1, Retorno2: String);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure EditLocaliza1Select(Sender: TObject);
    procedure EditLocaliza4Select(Sender: TObject);
    procedure EditLocaliza4Retorno(Retorno1, Retorno2: String);
    procedure gradeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn15Click(Sender: TObject);
    procedure CIndiceClick(Sender: TObject);
    procedure BitBtn16Click(Sender: TObject);
    procedure BitBtn17Click(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
    procedure DataMaiorClick(Sender: TObject);
    procedure BitBtn21Click(Sender: TObject);
    procedure EditLocaliza5Select(Sender: TObject);
    procedure BitBtn20Click(Sender: TObject);
    procedure EditLocaliza5Retorno(Retorno1, Retorno2: String);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    cifrao, CifraoMoeda : string;
    UnProduto : TFuncoesProduto;
    procedure AtualizaSelectProdutos;
    procedure AtualizaDados( coluna : Integer );
    procedure AlteraPercPadrao( percentual : Double; Adicionar : boolean);  // altera um percentual padrao para todos os produtos
    procedure TrocaMoeda( unidade : string);
    procedure MudaMascaraNumerico( numericos : array of TNumerico );  // na mundanca de moeda
    procedure MudaVisibleTab( tabs : array of TTabSheet; estado : boolean );
    procedure MudaEstadoBotoes( estado : boolean );
    procedure AbreTansacao;
    procedure ConfirmaTransacao;
    procedure CancelaTransacao;
  public
    { Public declarations }
  end;

var
  FFormacaoPreco: TFFormacaoPreco;

implementation

uses APrincipal, constantes, ConstMsg, AMontaKit, funsql, funstring, funObjeto,
     AImprimeTabela;

{$R *.DFM}

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                 acoes de inicializacoes e gerais
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{ ****************** Na criação do Formulário ******************************** }
procedure TFFormacaoPreco.FormCreate(Sender: TObject);
begin
  data. date := date;
  grade.Columns[0].FieldName := varia.CodigoProduto;
  Self.HelpFile := Varia.PathHelp + 'MPONTOLOJA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
  EditLocaliza4.Text := IntToStr(varia.TabelaPreco);
  EditLocaliza2.Text := IntTostr(varia.MoedaBase);
  EditLocaliza5.AInfo.CampoCodigo := Varia.CodigoProduto;  // caso codigo pro ou codigo de barras
  EditLocaliza2.Atualiza;
  cifrao := CurrencyString;
  AtualizaSelectProdutos;
  FPrincipal.VerificaMoeda;
  UnProduto := TFuncoesProduto.criar(self,FPrincipal.BaseDados);
  ComboBoxColor1.Items := screen.Fonts;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFFormacaoPreco.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if FPrincipal.BaseDados.InTransaction then
   FPrincipal.BaseDados.Rollback;
 TrocaMoeda(cifrao);
 FechaTabela(CadProdutos);
 UnProduto.free;
 Action := CaFree;
end;
{*********** localiza classificacao do produto ****************************** }
procedure TFFormacaoPreco.EditLocaliza1Select(Sender: TObject);
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

{ ********* quando muda a moeda de localiza atualiza os numericos ************ }
procedure TFFormacaoPreco.MudaMascaraNumerico( numericos : array of TNumerico );
var
  laco : integer;
begin
 for laco := low(numericos) to high(numericos) do
   numericos[laco].AMascara := CurrencyString + Varia.MascaraValor + ';-' + CurrencyString + Varia.MascaraValor;
end;

{ ************* troca de moeda *********************************************}
procedure TFFormacaoPreco.TrocaMoeda( unidade : string);
begin
  CurrencyString := Unidade;
  Varia.MascaraMoeda := Unidade + ' ' + varia.MascaraValor;
end;

{****************** fecha o formulario ************************************** }
procedure TFFormacaoPreco.BitBtn8Click(Sender: TObject);
begin
  close;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                 Localizacao e atualizacao dos produtos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***********  select que localiza os nomes padrao ************************** }
procedure TFFormacaoPreco.LocalizaEdit1Select(Sender: TObject);
begin
  LocalizaEdit1.ASelect.Clear;
  LocalizaEdit1.ASelect.Add(' select ' + varia.CodigoProduto + ', ' +
                            ' Tab.I_SEQ_PRO, Tab.I_COD_EMP, Pro.C_COD_CLA, Pro.C_COD_UNI, ' +
                            ' Tab.I_COD_MOE, Pro.C_NOM_PRO, Pro.C_ATI_PRO, Pro.C_KIT_PRO, ' +
                            ' Tab.I_COD_TAB, Pro.N_PER_MAK, Mov.I_EMP_FIL, ' +
                            ' Tab.N_PER_MAX, Pro.N_IND_MUL, ' +
                            CampoNumeroFormatodecimalMoeda('Tab.N_VLR_VEN','Venda','Tab.C_CIF_MOE', true) +
                            CampoNumeroFormatodecimalMoeda('Mov.N_VLR_COM','compra','Pro.C_CIF_MOE',true) +
                            CampoNumeroFormatodecimalMoeda('Mov.N_CUS_COM','CustoCompra','Pro.C_CIF_MOE',true) +
                            CampoNumeroFormatodecimalMoeda('Tab.N_VLR_CUS','custo','tab.C_CIF_MOE',true) +
                            CampoNumeroFormatodecimalMoeda('pro.n_vlr_max','maximo','Pro.C_CIF_MOE',true) +
                            ' Tab.N_VLR_VEN, Mov.N_VLR_COM, tab.N_VLR_CUS, mov.n_cus_com, pro.n_vlr_max  ' +
                            ' from CadProdutos as pro, MovTabelaPreco as tab,' +
                            ' MovQdadeProduto as mov ' +
                            ' where pro.i_cod_emp = ' + IntTostr(varia.CodigoEmpresa) +
                            ' and pro.i_cod_emp = tab.i_cod_emp ' +
                            ' and pro.i_seq_pro = tab.i_seq_pro ' +
                            ' and pro.i_seq_pro = mov.i_seq_pro ' +
                            ' and mov.i_emp_fil = ' + IntTostr(varia.CodigoEmpFil) +
                            ' and pro.c_nom_pro like ''@%''' );
end;

{ *********** atualiza produtos apos localizar o nome padrao **************** }
procedure TFFormacaoPreco.EditLocaliza1Retorno(Retorno1, Retorno2: String);
begin
  AtualizaSelectProdutos;
end;

{ ********** permite fazer a alteracao da moeda corrente ***************** }
procedure TFFormacaoPreco.EditLocaliza2Retorno(Retorno1, Retorno2: String);
begin
  if EditLocaliza2.Text <> '' then
  begin
    TrocaMoeda(retorno1);
    CifraoMoeda := retorno1;
  end;
  AtualizaSelectProdutos;
end;

{********** select para selecionar tabela de preco ************************** }
procedure TFFormacaoPreco.EditLocaliza4Select(Sender: TObject);
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

{ ************ retorno da tabela de preco ************************************ }
procedure TFFormacaoPreco.EditLocaliza4Retorno(Retorno1, Retorno2: String);
begin
  AtualizaSelectProdutos;
end;

{ ************  Atualiza a select dos produtos ****************************** }
procedure TFFormacaoPreco.AtualizaSelectProdutos;
begin
  LocalizaEdit1.AOrdem := '';

  if EditLocaliza4.text <> '' then
    LocalizaEdit1.AOrdem := ' and tab.i_cod_tab = ' + EditLocaliza4.text;

  if AtiPro.Checked then
    LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem + ' and pro.c_ati_pro = ''S''';

  if CheckBox2.Checked then
    LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem + ' and isnull(tab.n_vlr_ven,0) = 0 ';

  if CheckBox3.Checked then
    LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem + ' and isnull(tab.n_vlr_ven,0) > 0 ';

  if CMaxCompra.Checked then
    LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem + ' and isnull(pro.n_vlr_max,0) > 0 ';

  if CheckBox4.Checked then
    LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem + ' and pro.c_kit_pro = ''K'' ';

  if not CKit.Checked then
    LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem + ' and isnull(pro.c_kit_pro,''P'') = ''P'' ';


  if EditLocaliza1.Text <> '' then
    LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem +
                            ' and pro.c_cod_cla like ''' + EditLocaliza1.Text + '%''' ;

  if EditLocaliza2.Text <> '' then
    LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem + ' and tab.I_COD_MOE = ' + EditLocaliza2.Text ;

  if codpro.Text <> '' then
     LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem + ' and ' + Varia.CodigoProduto + ' =  ''' + codpro.text + '''';

  if DataMaior.Checked then
     LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem + ' and tab.d_ult_alt >= ' + SQLTextoDataAAAAMMMDD(data.DateTime);


    LocalizaEdit1.AOrdem := LocalizaEdit1.AOrdem + ' order by pro.c_nom_pro';

  LocalizaEdit1.AtualizaTabela;
end;

{ ************** altera  os produtos em atividade ************************** }
procedure TFFormacaoPreco.AtiProClick(Sender: TObject);
begin
  AtualizaSelectProdutos;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                         pagina Geral
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{********** atualiza valores da tabela de produto, qdade e preco ************ }
procedure TFFormacaoPreco.AtualizaDados( coluna : Integer );
var
  valor : string;
  Ponto : TBookmark;
  Decimais : Integer;
begin
  ponto := CadProdutos.GetBookmark;
  if coluna in [ 3,4,5,6,7,9] then
  begin
    case coluna of
      3 : valor := CadProdutos.fieldByname('N_VLR_VEN').AsString;
      4 : valor := CadProdutos.fieldByname('N_VLR_COM').AsString;
      5 : valor := CadProdutos.fieldByname('N_CUS_COM').AsString;
      6 : valor := CadProdutos.fieldByname('N_VLR_CUS').AsString;
      7 : valor := CadProdutos.fieldByname('N_IND_MUL').AsString;
      9 : valor := CadProdutos.fieldByname('N_VLR_MAX').AsString;
    end;

    Decimais := CurrencyDecimals;
    if coluna in [4,5,6] then
      Decimais := varia.DecimaisCusto;

    if EntradaNumero('Novo Valor','Digite Novo Valor',valor,false,FPrincipal.CorFoco.ACorFundoFoco,
                     FPrincipal.CorForm.ACorPainel, true) then
    begin
      valor := SubstituiStr( valor,',','.' );

      LimpaSQLTabela(aux);
      if coluna in [3,6] then
      begin
        AdicionaSQLTabela(aux, ' update movTabelaPreco set ');
        case coluna of
          3 : AdicionaSQLTabela(aux, ' n_vlr_ven = ' );
          6 : AdicionaSQLTabela(aux, ' n_vlr_cus = ' );
        end;

        AdicionaSQLTabela(aux, valor + ',D_Ult_Alt = '+ SQLTextoDataAAAAMMMDD(Date)+
                               ' where i_cod_emp = ' + IntTostr(varia.CodigoEmpresa) +
                               ' and i_cod_tab = ' + EditLocaliza4.Text + ' and i_seq_pro = ' +
                               CadProdutos.fieldByName('I_SEQ_PRO').AsString );
      end
      else
        if coluna in [4,5] then
        begin
          AdicionaSQLTabela(aux, ' update MovQdadeProduto set ' );
          case coluna of
            4 : AdicionaSQLTabela(aux, ' n_vlr_com = ' );
            5 : AdicionaSQLTabela(aux, ' n_cus_com = ' );
          end;

          AdicionaSQLTabela(aux,  valor + ', D_Ult_Alt = '+ SQLTextoDataAAAAMMMDD(Date) +
                                 ' where i_emp_fil = ' + IntTostr(varia.CodigoEmpFil) +
                                 ' and i_seq_pro = ' +
                                 CadProdutos.fieldByName('I_SEQ_PRO').AsString );
        end
        else
        begin
          AdicionaSQLTabela(aux, ' update CadProdutos set ' );
          case coluna of
            7 : AdicionaSQLTabela(aux, ' n_ind_mul = ' );
            9 : AdicionaSQLTabela(aux, ' n_vlr_max = ' );
          end;
           AdicionaSQLTabela(aux, Valor + ' , D_Ult_Alt = '+ SQLTextoDataAAAAMMMDD(Date) +
                                 ' where i_seq_pro = ' +
                                 CadProdutos.fieldByName('I_SEQ_PRO').AsString );
        end;                         
      aux.ExecSQL;
      AtualizaSelectProdutos;
    end;
  end;
  if not CadProdutos.eof then
    CadProdutos.GotoBookmark(ponto);
  CadProdutos.FreeBookmark(ponto);
end;

{****************** atualiza Informacoes F2 ******************************** }
procedure TFFormacaoPreco.BitBtn1Click(Sender: TObject);
begin
  AbreTansacao;
  AtualizaDados(grade.SelectedIndex);
end;

{**************** altera a atividade do produto ***************************** }
procedure TFFormacaoPreco.BitBtn2Click(Sender: TObject);
begin
end;

{************* atualiza todos os dados do produto em relacao a tab de preco ** }
procedure TFFormacaoPreco.BitBtn4Click(Sender: TObject);
begin
    AbreTansacao;
    UnProduto.OrganizaTabelaPreco( StrToInt(EditLocaliza4.text),confirmacao(CT_AdicionaAtividade));
    AtualizaSelectProdutos;
end;

{******************** exclui um produto da tabela de preco *******************}
procedure TFFormacaoPreco.BitBtn21Click(Sender: TObject);
begin
  if not CadProdutos.Eof then
    if Confirmacao(' Deseja realmente exclui o produto '+ CadProdutos.fieldByName('C_NOM_PRO').AsString +
                   ' da tabela de preço selecionada ') then
    begin
      AbreTansacao;
      LimpaSQLTabela(aux);
      AdicionaSQLTabela(aux, ' delete movTabelaPreco ' +
                             ' where i_cod_emp = ' + IntTostr(varia.CodigoEmpresa) +
                             ' and i_cod_tab = ' + EditLocaliza4.Text +
                             ' and i_seq_pro = ' + CadProdutos.fieldByName('I_SEQ_PRO').AsString );
       aux.ExecSQL;
       AtualizaSelectProdutos;
    end;
end;

{******************* localiza Novo Produto ***********************************}
procedure TFFormacaoPreco.EditLocaliza5Select(Sender: TObject);
begin
  EditLocaliza5.ASelectLocaliza.clear;
  EditLocaliza5.ASelectLocaliza.add(' select mov.c_cod_bar, pro.i_seq_pro, pro.c_nom_pro, pro.c_cod_pro from cadprodutos as pro, movqdadeproduto as mov ' +
                                    ' where pro.i_seq_pro not in ( '+
                                    ' select i_seq_pro from movtabelapreco '+
                                    ' where i_cod_tab =  ' + EditLocaliza4.Text +
                                    ' and i_cod_emp = ' + Inttostr(Varia.CodigoEmpresa) + ')' +
                                    ' and c_nom_pro like ''@%''' +
                                    ' and pro.i_seq_pro = mov.i_seq_pro ' +
                                    ' and mov.i_emp_fil = ' + Inttostr(Varia.CodigoEmpFil) );
  EditLocaliza5.ASelectValida.clear;
  EditLocaliza5.ASelectValida.add(' select mov.c_cod_bar, pro.i_seq_pro, pro.c_nom_pro, pro.c_cod_pro from cadprodutos as pro, movqdadeproduto as mov ' +
                                  ' where pro.i_seq_pro not in ( '+
                                  ' select i_seq_pro from movtabelapreco '+
                                  ' where i_cod_tab =  ' + EditLocaliza4.Text +
                                  ' and i_cod_emp = ' + Inttostr(Varia.CodigoEmpresa) + ')' +
                                  ' and ' + varia.CodigoProduto + ' = ''@'' ' +
                                  ' and pro.i_seq_pro = mov.i_seq_pro ' +
                                  ' and mov.i_emp_fil = ' + Inttostr(Varia.CodigoEmpFil) );
end;

{*********************** adiciona novo produto *******************************}
procedure TFFormacaoPreco.BitBtn20Click(Sender: TObject);
begin
  EditLocaliza5.Text := '';
  EditLocaliza5Select(nil);
  EditLocaliza5.AAbreLocalizacao;
end;

{*********************** adiciona novo produto *******************************}
procedure TFFormacaoPreco.EditLocaliza5Retorno(Retorno1, Retorno2: String);
begin
   if Retorno1 <> '' then
   begin
     AbreTansacao;
     LimpaSQLTabela(aux);
     AdicionaSQLTabela(aux, ' insert into movTabelaPreco(i_cod_emp, i_cod_tab, i_seq_pro, c_cif_moe, d_ult_alt, i_cod_moe) ' +
                            ' values( ' + intTostr(varia.CodigoEmpresa) +
                            ' ,' + EditLocaliza4.Text +
                            ' ,' + Retorno1 +
                            ' ,''' + CifraoMoeda + '''' +
                            ' ,' + SQLTextoDataAAAAMMMDD(Date) +
                            ' ,' + EditLocaliza2.text + ')' );
     aux.ExecSQL;
     AtualizaSelectProdutos;
     EditLocaliza5.Text := '';
  end;
  EditLocaliza5.Text := '';
end;

{ ************** permite chamar a tela de cnfiguracao de kit **************** }
procedure TFFormacaoPreco.BitBtn9Click(Sender: TObject);
begin
  AbreTansacao;
  if Cadprodutos. fieldByName('C_KIT_PRO').AsString = 'K' then
  begin
    FMontaKit := TFMontaKit.CriarSDI(application, '', true);
    FMontaKit.CarregaTela( Cadprodutos. fieldByName('I_SEQ_PRO').AsInteger);
  end;
end;

{**************** atualiza apenas o kit selecionado **************************}
procedure TFFormacaoPreco.BitBtn16Click(Sender: TObject);
var
  Ponto : TBookmark;
begin
  if (CadProdutos.fieldByName('c_kit_pro').AsString = 'K') and (EditLocaliza4.Text <> '') then
  begin
    ponto := CadProdutos.GetBookmark;
    AbreTansacao;
    UnProduto.AtualizaValorKit(CadProdutos.fieldByName('i_seq_pro').AsInteger, StrToInt(EditLocaliza4.text));
  end;
  AtualizaSelectProdutos;
  if not CadProdutos.eof then
    CadProdutos.GotoBookmark(ponto);
  CadProdutos.FreeBookmark(ponto);
end;

{****************** atualiza todos os kit *********************************** }
procedure TFFormacaoPreco.BitBtn17Click(Sender: TObject);
var
  Ponto : TBookmark;
begin
  ponto := CadProdutos.GetBookmark;
  AbreTansacao;
  CadProdutos.DisableControls;
  CadProdutos.First;
  while not CadProdutos.Eof do
  begin
    if (CadProdutos.fieldByName('c_kit_pro').AsString = 'K') and (EditLocaliza4.Text <> '') then
      UnProduto.AtualizaValorKit(CadProdutos.fieldByName('i_seq_pro').AsInteger, StrToInt(EditLocaliza4.text));
    CadProdutos.Next;
  end;
  CadProdutos.EnableControls;
  AtualizaSelectProdutos;
  if not CadProdutos.eof then
    CadProdutos.GotoBookmark(ponto);
  CadProdutos.FreeBookmark(ponto);
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                         pagina Percentuais
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{********************* Configura caso utiliza indice multiplicador ********** }
procedure TFFormacaoPreco.CIndiceClick(Sender: TObject);
begin
  label5.Enabled := not CIndice.Checked;
  numerico1.Enabled := not CIndice.Checked;
  Cal1.Enabled := not CIndice.Checked;
  Cal2.Enabled := not CIndice.Checked;
  AtualizaSelectProdutos;
end;

///  percentual padrao para os produtos

{ ********   Adidiona Pecentual Padrao para todos os produtos ************** }
procedure TFFormacaoPreco.AlteraPercPadrao( percentual : Double; Adicionar : boolean);
var
  perc : string;
begin

  AbreTansacao;  // inicia uma nova tansacao

  perc := SubstituiStr(FloatToStr(percentual /100),',','.');

  LimpaSQLTabela(aux);
  // inicia atualizacao
  AdicionaSQLTabela(aux, ' update  movtabelapreco as tab' +
                         ' set d_ult_alt = ' + SQLTextoDataAAAAMMMDD(date)  +
                         ', tab.n_vlr_ven = ' );

  // retorna valor conforme moeda
  if RadioButton3.Checked then         // caso venda
     AdicionaSQLTabela(aux, ' tab.n_vlr_ven ' )
  else
    begin
       AdicionaSQLTabela(aux, '( select ' ) ;
       if RadioButton4.Checked then      // caso compra
          AdicionaSQLTabela(aux, ' ((mov.n_vlr_com * MoePro.n_vlr_dia) / MoeTab.n_vlr_dia) valor ')
       else
         if RadioButton5.Checked then    // caso custo
            AdicionaSQLTabela(aux, ' (( tab.n_vlr_cus * MoePro.n_vlr_dia ) / MoeTab.n_vlr_dia) valor ')
         else
           if RadioButton6.Checked then  // caso custo  compra
            AdicionaSQLTabela(aux, ' (( mov.n_cus_com * MoePro.n_vlr_dia ) / MoeTab.n_vlr_dia) valor ');

       AdicionaSQLTabela(aux, ' from MovQdadeProduto as mov key join CadProdutos as pro, ' +
                              ' CadMoedas as MoePro, cadMoedas as MoeTab' +
                              ' where mov.i_emp_fil = ' + IntTostr(Varia.CodigoEmpFil));
       if Todos.Checked then
          AdicionaSQLTabela(aux,' and mov.i_seq_pro = tab.i_seq_pro ')
       else
          AdicionaSQLTabela(aux,' and mov.i_seq_pro = ' + CadProdutos.fieldByName('I_SEQ_PRO').AsString );

       AdicionaSQLTabela(aux,' and pro.i_cod_moe = MoePro.i_cod_moe ' +
                             ' and Tab.i_cod_moe = Moetab.i_cod_moe )');
  end;

  // caso adicionar ou subtrair  para calculo de cima para baixa - de baixo para cima
  if RadioButton1.Checked then
    if Cal1.Checked then
      AdicionaSQLTabela(aux,' * ')
    else
      AdicionaSQLTabela(aux,' / ')
   else
     AdicionaSQLTabela(aux,' * ');

  // caso indice multiplicador
  if CIndice.Checked then
    AdicionaSQLTabela(aux,' ( select n_ind_mul from cadProdutos where i_seq_pro = tab.i_seq_pro )')
  else
    if Adicionar then
    begin
      if Cal1.Checked then  // tipo de calculo
        AdicionaSQLTabela(aux,' ( 1 + ' + perc + ' ) ' )
      else
        AdicionaSQLTabela(aux,' ( 1 - ' + perc + ' ) ' )
    end
    else
      AdicionaSQLTabela(aux,' ( 1 - ' + perc + ' ) ' );


  AdicionaSQLTabela(aux,' where i_cod_emp = ' + IntTostr(varia.CodigoEmpresa) +
                         ' and i_cod_tab = ' + EditLocaliza4.Text );

   if EditLocaliza2.Text <> '' then
     AdicionaSQLTabela(aux,' and i_cod_moe = ' + EditLocaliza2. Text );

   // caso mudar todos
   if Todos.Checked then
   begin
       AdicionaSQLTabela(aux, ' and i_seq_pro in ' +
                              ' ( select pro.i_seq_pro from cadprodutos as pro' +
                              ' where pro.i_cod_emp = ' + IntTostr(varia.CodigoEmpresa)  );

       if EditLocaliza1.Text <> '' then
         AdicionaSQLTabela(aux,' and pro.c_cod_cla like ''' +  EditLocaliza1.Text + '%''' );

       if AtiPro.Checked then
         AdicionaSQLTabela(aux,' and pro.c_ati_pro = ''S''' );

       AdicionaSQLTabela(aux,' )' );
   end
   else
     AdicionaSQLTabela(aux,' and i_seq_pro = ' + CadProdutos.fieldByName('I_SEQ_PRO').AsString);


  if CheckBox2.Checked then
    AdicionaSQLTabela(aux,' and isnull(tab.n_vlr_ven,0) = 0 ');

  aux.ExecSQL;
  AtualizaSelectProdutos;
end;

{ ****** chamada para alterar um perceuntual padrao para todos da select ***** }
procedure TFFormacaoPreco.BitBtn3Click(Sender: TObject);
begin
  if EditLocaliza4.Text <> '' then
    AlteraPercPadrao(Numerico1.AValor, RadioButton1.Checked);
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                         pagina Moedas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}


////   altera a moeda do produto

{ ************** calcula a alteracao da moeda Tabela ************************ }
procedure TFFormacaoPreco.BitBtn7Click(Sender: TObject);
begin
  if EditLocaliza3.text <> '' then
  begin
     AbreTansacao;
     UnProduto.ConverteMoedaTabela( StrToInt(EditLocaliza3.text),
                                   StrToInt(EditLocaliza4.text), CadProdutos.fieldByName('I_SEQ_PRO').AsInteger);
     AtualizaSelectProdutos;
  end;
end;

{ ************** calcula a alteracao da moeda Produto *********************** }
procedure TFFormacaoPreco.BitBtn10Click(Sender: TObject);
begin
  if EditLocaliza3.text <> '' then
  begin
    AbreTansacao;
    UnProduto.ConverteMoedaProduto( StrToInt(EditLocaliza3.text),
                                    StrToInt(EditLocaliza4.text), CadProdutos.fieldByName('I_SEQ_PRO').AsInteger);
    AtualizaSelectProdutos;
  end;
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                         pagina Impressao
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{************** imprime a tabela de preco *********************************** }
procedure TFFormacaoPreco.BitBtn15Click(Sender: TObject);
var
  campos : array[0..4] of integer;
begin
FillChar(campos, SizeOf(campos), 0);
if CNomeProduto.Checked then
 campos[0] := 1;
if CPK.Checked then
 campos[1] := 1;
if CUnidade.Checked then
 campos[2] := 1;

if RVenda.Checked then
  campos[3] := 1
else
  if RCompra.Checked then
    campos[3] := 2
  else
    if Rcusto.Checked then
     campos[3] := 3
      else
        if Rmaximo.Checked then
         campos[3] := 4;

if CCodigoPro.Checked then
  campos[4] := 1;

FimprimeTabela := TFimprimeTabela.CriarSDI(self,'',true);
FImprimeTabela.AbreRelatorio( CadProdutos.sql,label4.Caption,
                              SpinEditColor2.Value, SpinEditColor1.Value, CheckBox1.Checked,
                              ComboBoxColor1.text, campos, EditColor1.text, trunc(numerico2.avalor), trunc(numerico3.avalor) );
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                         diversos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{************* chamada do teclado para funcoes ****************************** }
procedure TFFormacaoPreco.gradeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 113) and (PageControl1.ActivePage = TabSheet1) then
  begin
    BitBtn1.Click;
    abort;
  end;
  if (key = 117) and (PageControl1.ActivePage = TabSheet2) then
    AlteraPercPadrao(Numerico1.AValor, RadioButton1.Checked);
end;

{************** chamada para cancelar transacao ***************************** }
procedure TFFormacaoPreco.BitBtn5Click(Sender: TObject);
begin
  CancelaTransacao;
end;

{************************** cahamada para confirmar transacao **************** }
procedure TFFormacaoPreco.BitBtn6Click(Sender: TObject);
begin
  ConfirmaTransacao;
end;

{********** configura os tab sheet ****************************************** }
procedure TFFormacaoPreco.MudaVisibleTab( tabs : array of TTabSheet; estado : boolean );
var
  laco : Integer;
begin
  for laco := low(tabs) to High(tabs) do
    tabs[laco].TabVisible := estado;
end;

{*********** configura os botoes conforme paginas *************************** }
procedure TFFormacaoPreco.MudaEstadoBotoes( estado : boolean );
begin
  if estado then
    MudaVisibleTab([TabSheet1, TabSheet2, TabSheet3, TabSheet5], estado);
  case PageControl1.ActivePage.TabIndex of
    0 : begin MudaVisibleTab([TabSheet2, TabSheet3,TabSheet5], estado); AlterarEnabled([bitbtn13,bitbtn14,bitbtn8]); end;
    1 : begin MudaVisibleTab([TabSheet1, TabSheet3,TabSheet5], estado); AlterarEnabled([bitbtn5,bitbtn6,bitbtn8]); end;
    2 : begin MudaVisibleTab([TabSheet1, TabSheet2,TabSheet5], estado); AlterarEnabled([bitbtn11,bitbtn12,bitbtn8]); end;
    4 : begin MudaVisibleTab([TabSheet2, TabSheet3,TabSheet1], estado); AlterarEnabled([bitbtn18,bitbtn19,bitbtn8]); end;
  end;
end;

{*********** abre transacao ************************************************ }
procedure TFFormacaoPreco.AbreTansacao;
begin
  if not FPrincipal.BaseDados.InTransaction then
  begin
    MudaEstadoBotoes(false);
    FPrincipal.BaseDados.StartTransaction;
  end;
end;

{************ cancela transacao ********************************************* }
procedure TFFormacaoPreco.CancelaTransacao;
begin
  if FPrincipal.BaseDados.InTransaction then
  begin
    MudaEstadoBotoes(true);
    FPrincipal.BaseDados.Rollback;
  end;
  AtualizaSelectProdutos;
end;

{************ confirma transacao ********************************************* }
procedure TFFormacaoPreco.ConfirmaTransacao;
begin
  if FPrincipal.BaseDados.InTransaction then
    if Confirmacao(CT_AlteraTabelaPreco) then
    begin
      MudaEstadoBotoes(true);
      FPrincipal.BaseDados.Commit;
    end;
  AtualizaSelectProdutos;
end;


procedure TFFormacaoPreco.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FFormacaoPreco.HelpContext);
end;

procedure TFFormacaoPreco.DataMaiorClick(Sender: TObject);
begin
  data.Enabled := DataMaior.Checked;
  AtualizaSelectProdutos;
end;



procedure TFFormacaoPreco.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := not FPrincipal.BaseDados.InTransaction;
end;

Initialization
 RegisterClasses([TFFormacaoPreco]);
end.
