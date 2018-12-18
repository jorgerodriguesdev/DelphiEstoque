unit AComprosicaoProduto;
{          Autor: Sergio Luiz Censi
    Data Criação: 06/04/1999;
  Data Alteração: 06/04/1999;
Motivo alteração: - Adicionado os comentários e o blocos nas rotinas, e realizado
                    um teste - 06/04/199
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Db, DBTables, Grids, DBGrids, Tabela, PainelGradiente, StdCtrls, Buttons,
  ExtCtrls, Componentes1, DBKeyViolation, Localizacao, UnNotafiscal, Mask,
  numericos, Unprodutos;

type
  TFComposicaoProduto = class(TFormularioPermissao)
    PanelColor1: TPanelColor;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    PainelGradiente1: TPainelGradiente;
    DBGridColor1: TDBGridColor;
    DBGridColor2: TDBGridColor;
    CadProdutos: TQuery;
    DataCadProdutos: TDataSource;
    MovComposicao: TQuery;
    Produtos: TQuery;
    MovComposicaoNomeProduto: TStringField;
    BitBtn1: TBitBtn;
    EClassificacao: TEditColor;
    Label3: TLabel;
    SpeedButton3: TSpeedButton;
    LNomClassificacao: TLabel;
    Label5: TLabel;
    ENomProduto: TEditColor;
    Aux: TQuery;
    BBAjuda: TBitBtn;
    ConsultaPadrao1: TConsultaPadrao;
    MovComposicaoI_PRO_COM: TIntegerField;
    MovComposicaoI_SEQ_PRO: TIntegerField;
    MovComposicaoC_COD_UNI: TStringField;
    MovComposicaoI_COD_EMP: TIntegerField;
    MovComposicaoD_ULT_ALT: TDateField;
    DataComposicaoProduto: TDataSource;
    Qdade: Tnumerico;
    Label4: TLabel;
    MovComposicaoC_UNI_PAI: TStringField;
    MovComposicaoN_QTD_PRO: TFloatField;
    BitBtn2: TBitBtn;
    EditLocaliza1: TEditLocaliza;
    SpeedButton5: TSpeedButton;
    Label6: TLabel;
    Adiciona: TQuery;
    ComboBoxColor1: TComboBoxColor;
    CadProdutosCom: TQuery;
    DataProdutoCom: TDataSource;
    Label8: TLabel;
    EditColor1: TEditColor;
    Label9: TLabel;
    EClassificacaoCom: TEditColor;
    SpeedButton6: TSpeedButton;
    Label10: TLabel;
    Label11: TLabel;
    EditColor3: TEditColor;
    Label13: TLabel;
    EnomProdutoCom: TEditColor;
    DBGridColor3: TDBGridColor;
    CadProdutosComI_SEQ_PRO: TIntegerField;
    CadProdutosComC_COD_PRO: TStringField;
    CadProdutosComC_NOM_PRO: TStringField;
    CadProdutosI_SEQ_PRO: TIntegerField;
    CadProdutosC_COD_PRO: TStringField;
    CadProdutosC_NOM_PRO: TStringField;
    CadProdutosC_COD_BAR: TStringField;
    CadProdutosComC_COD_BAR: TStringField;
    Label7: TLabel;
    CadProdutosC_COD_UNI: TStringField;
    CadProdutosC_PRO_COM: TStringField;
    CheckBox4: TCheckBox;
    CheckBox1: TCheckBox;
    MovComposicaoN_QTD_COM: TFloatField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure EClassificacaoExit(Sender: TObject);
    procedure EClassificacaoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ENomProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ENomProdutoExit(Sender: TObject);
    procedure MovComposicaoBeforePost(DataSet: TDataSet);
    procedure BBAjudaClick(Sender: TObject);
    procedure MovComposicaoBeforeEdit(DataSet: TDataSet);
    procedure MovComposicaoAfterPost(DataSet: TDataSet);
    procedure QdadeExit(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure DBGridColor2KeyPress(Sender: TObject; var Key: Char);
    procedure DBGridColor2Exit(Sender: TObject);
    procedure EcodProExit(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure EditLocaliza1Select(Sender: TObject);
    procedure EditLocaliza1Retorno(Retorno1, Retorno2: String);
    procedure EditLocaliza1Change(Sender: TObject);
    procedure EditColor3Exit(Sender: TObject);
    procedure EClassificacaoComExit(Sender: TObject);
    procedure EditColor3Enter(Sender: TObject);
    procedure CadProdutosComBeforeScroll(DataSet: TDataSet);
    procedure CadProdutosComAfterScroll(DataSet: TDataSet);
    procedure CheckBox4Click(Sender: TObject);
  private
    SeqPro : integer;
    NF : TFuncoesNotaFiscal;
    unPro : TFuncoesProduto;
    procedure CarregaMovComposicao;
    function ValidaClassificacao(Classificacao : String) : Boolean;
    Function LocalizaClassificacao( Tipo : integer ) : Boolean;
    procedure AtualizaConsulta;
    procedure AdicionaFiltros(VpaSelect : TStrings);
    procedure MudaFlagComposicao;
    function ValidaUnidade( CodUnidade : string ) : Boolean;
    function SelectValida : string;
    function SelectLocaliza : string;
    function LocalizaQdadeCada(SeqPro : Integer; var Unidade, UnidadeCom : string) : Double;
    procedure AlteraQdadeCada( SeqPro : Integer; Qdade : Double; unidade : String);
    function ValidaGravar : Boolean;
    procedure AtualizaConsultaComposicao;
    procedure AdicionaFiltrosComposicao(VpaSelect : TStrings);
  public
    procedure CarregaComposicao(CodigoProduto : string);
  end;

var
  FComposicaoProduto: TFComposicaoProduto;

implementation

uses APrincipal, constantes, constmsg, ALocalizaClassificacao, FunSql, funstring;

{$R *.DFM}

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              formulario
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}


{ ****************** Na criação do Formulário ******************************** }
procedure TFComposicaoProduto.FormCreate(Sender: TObject);
begin
   NF := TFuncoesNotaFiscal.criar(self,fprincipal.BaseDados);
   UnPro := TFuncoesProduto.criar(self,fprincipal.BaseDados);
   Self.HelpFile := Varia.PathHelp + 'MPONTOLOJA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
   DBGridColor1.Columns[0].FieldName := varia.CodigoProduto;
   DBGridColor3.Columns[0].FieldName := varia.CodigoProduto;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFComposicaoProduto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  NF.free;
  UnPro.free;
  BitBtn1.Click;
  CadProdutos.close;
  aux.close;
  adiciona.close;
  Produtos.close;
  MovComposicao.close;
  Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações de Inicalização
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{**********************Carrega a  tela na inicialização************************}
procedure TFComposicaoProduto.CarregaComposicao(CodigoProduto : string);
begin
   EditColor3.text := CodigoProduto;
   AtualizaConsultaComposicao;
   FComposicaoProduto.ShowModal;
end;

{**************************Carrega o Movimento do kit**************************}
procedure TFComposicaoProduto.CarregaMovComposicao;
begin
  produtos.close;
  produtos.sql.clear;
  produtos.sql.add(' Select * from CadProdutos '+
                   ' Where i_seq_pro in (select i_seq_pro from MovComposicaoProduto ' +
                   ' where I_COD_EMP = ' +  IntToStr(varia.CodigoEmpresa) +
                   ' and i_pro_com = ' + IntTostr(CadProdutosComI_SEQ_PRO.AsInteger) +  ' )');
  MovComposicao.close;
  MovComposicao.sql.clear;
  MovComposicao.SQL.Add(' Select * from MovComposicaoProduto ' +
                        ' where I_COD_EMP = ' +  IntToStr(varia.CodigoEmpresa) +
                        ' and i_pro_com = ' + IntTostr(CadProdutosComI_SEQ_PRO.AsInteger)  );
  MovComposicao.open;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                          eventos dos filtros
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{*************** valida se a classificacao Existe *****************************}
function TFComposicaoProduto.ValidaClassificacao(Classificacao : String) : Boolean;
begin
  AdicionaSQLAbreTabela(Aux,' Select * from CadClassificacao' +
                            ' Where C_Cod_Cla = ''' + Classificacao + '''' +
                            ' and c_Tip_Cla = ''P''');
  result := not Aux.Eof;
  LNomClassificacao.Caption := Aux.FieldByName('C_Nom_Cla').Asstring;
  aux.close;
end;

{######################## filtros da materia prima ###########################}

{****************** localiza a classificacao do produto ***********************}
Function TFComposicaoProduto.LocalizaClassificacao( Tipo : integer ) : Boolean;
Var
  VpfCodClassificacao,VpfNomClassificacao : String;
begin
  FLocalizaClassificacao := TFLocalizaClassificacao.criarSDI(Application,'',FPrincipal.VerificaPermisao('FLocalizaClassificacao'));
  result := FLocalizaClassificacao.LocalizaClassificacao(VpfCodClassificacao,VpfNomClassificacao,'P');
  if result Then
  begin
    if tipo = 1 then
    begin
      EClassificacao.Text := VpfCodClassificacao;
      LNomClassificacao.Caption := VpfNomClassificacao;
    end
    else
    begin
      EClassificacaoCom.Text := VpfCodClassificacao;
      Label10.Caption := VpfNomClassificacao;
    end
  end;
end;

{************************ atualiza a consulta *********************************}
procedure TFComposicaoProduto.AtualizaConsulta;
begin
  CadProdutos.Sql.Clear;
  CadProdutos.Sql.Add(' Select pro.i_seq_pro, pro.c_cod_pro, pro.c_nom_pro, mov.c_cod_bar, pro.c_cod_uni, pro.c_pro_com ' +
                      ' from CadProdutos pro, MovQdadeProduto mov '+
                      ' where pro.i_cod_emp = ' + IntToStr(varia.CodigoEmpresa ) +
                      ' and pro.C_KIT_PRO = ''P''' +
                      ' and pro.c_ATI_PRO = ''S''' +
                      ' and pro.I_COD_MOE = ' + IntTostr(varia.MoedaBase) +
                      ' and pro.i_seq_pro not in (select i_seq_pro from MovComposicaoProduto ' +
                                                 ' where I_COD_EMP = ' +  IntToStr(varia.CodigoEmpresa) +
                                                 ' and i_pro_com = ' + IntTostr(CadProdutosComI_SEQ_PRO.AsInteger) +  ' )');
  AdicionaFiltros(CadProdutos.Sql);
  CadProdutos.Sql.Add(' and pro.i_seq_pro = mov.i_seq_pro ' +
                      ' and mov.i_emp_fil = ' + Inttostr(varia.CodigoEmpFil));
  CadProdutos.Sql.Add('order by pro.C_Nom_pro');
  CadProdutos.Open;
end;

{******************** adiciona os filtros da consulta *************************}
procedure TFComposicaoProduto.AdicionaFiltros(VpaSelect : TStrings);
begin
  if EClassificacao.Text <>'' then
    VpaSelect.Add(' and C_Cod_Cla like  '''+ EClassificacao.Text + '%''');
  if ENomProduto.Text <> '' then
    VpaSelect.add(' and C_Nom_Pro like ''' + ENomProduto.Text + '%''');
  if EditColor1.text <> '' then
    VpaSelect.add(' and ' + varia.CodigoProduto + ' = ''' + Editcolor1.Text + '''' );
end;

{*************** quando precionado o botao de localiza classificação *********}
procedure TFComposicaoProduto.SpeedButton3Click(Sender: TObject);
begin
  LocalizaClassificacao((sender as TComponent).Tag);
  if (sender as TComponent).Tag = 1 then AtualizaConsulta else AtualizaConsultaComposicao;
end;

{********************** quando sai do codigo da classificacao *****************}
procedure TFComposicaoProduto.EClassificacaoExit(Sender: TObject);
begin
  if EClassificacao.text <> '' then
  begin
    if  ValidaClassificacao(EClassificacao.text) then
      AtualizaConsulta
    else
      if not LocalizaClassificacao((sender as TComponent).Tag) Then
        EClassificacao.SetFocus
      else
        AtualizaConsulta;
  end;
end;

{********************** filtra as teclas pressionadas *************************}
procedure TFComposicaoProduto.EClassificacaoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    Vk_F3 : LocalizaClassificacao((sender as TComponent).Tag);
 {      13 : if ValidaClassificacao then
              AtualizaConsulta
            else
              if LocalizaClassificacao((sender as TComponent).Tag) Then
                AtualizaConsulta;}
  end
end;


{************************ atualiza a consulta *********************************}
procedure TFComposicaoProduto.AtualizaConsultaComposicao;
begin
  CadProdutosCom.Sql.Clear;
  CadProdutosCom.Sql.Add(' Select pro.i_seq_pro, pro.c_cod_pro, pro.c_nom_pro, mov.c_cod_bar, pro.c_cod_uni '  +
                         ' from CadProdutos pro, movqdadeproduto mov ' +
                         ' where pro.i_cod_emp = ' + IntToStr(varia.CodigoEmpresa ) +
                         ' and pro.C_KIT_PRO = ''P''' +
                         ' and pro.c_ATI_PRO = ''S''' +
                         ' and pro.I_COD_MOE = ' + IntTostr(varia.MoedaBase) );
  AdicionaFiltrosComposicao(CadProdutosCom.Sql);
 CadProdutosCom.Sql.Add(' and pro.i_seq_pro = mov.i_seq_pro ' +
                        ' and mov.i_emp_fil = ' + Inttostr(varia.CodigoEmpFil));
  CadProdutosCom.Sql.Add('order by pro.C_Nom_pro');
  CadProdutosCom.Open;
end;

{******************** adiciona os filtros da consulta *************************}
procedure TFComposicaoProduto.AdicionaFiltrosComposicao(VpaSelect : TStrings);
begin
  if EClassificacaoCom.Text <>'' then
    VpaSelect.Add(' and C_Cod_Cla like  '''+ EClassificacaoCom.Text + '%''');
  if ENomProdutoCom.Text <> '' then
    VpaSelect.add(' and C_Nom_Pro like ''' + ENomProdutoCom.Text + '%''');
  if EditColor3.text <> '' then
    VpaSelect.add(' and ' + varia.CodigoProduto + ' = ''' + Editcolor3.Text + '''' );
  if CheckBox4.Checked then
      VpaSelect.add(' and pro.i_seq_pro not in ( select i_pro_com from movcomposicaoproduto ) ') ;
  if CheckBox1.Checked then
      VpaSelect.add(' and pro.i_seq_pro in ( select i_pro_com from movcomposicaoproduto ) ') ;
end;

{ ************************* Localiza codigo Produto ************************** }
procedure TFComposicaoProduto.EditColor3Exit(Sender: TObject);
begin
  AtualizaConsultaComposicao;
end;

{****************** Na saida da Classificacao ********************************}
procedure TFComposicaoProduto.EClassificacaoComExit(Sender: TObject);
begin
  if EClassificacaoCom.text <> '' then
  begin
    if  ValidaClassificacao(EClassificacaoCom.text) then
      AtualizaConsultaComposicao
    else
      if not LocalizaClassificacao((sender as TComponent).Tag) Then
        EClassificacaoCom.SetFocus
      else
        AtualizaConsultaComposicao;
  end;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{*******************Move item de um list box para outro************************}
procedure TFComposicaoProduto.SpeedButton1Click(Sender: TObject);
begin
   if not CadProdutos.eof then
   begin
     MovComposicao.Insert;
     MovComposicaoI_COD_EMP.Value := varia.CodigoEmpresa;
     MovComposicaoI_PRO_COM.Value := CadProdutosComI_SEQ_PRO.AsInteger;
     MovComposicaoI_SEQ_PRO.Value := CadProdutos.fieldbyName('I_SEQ_PRO').AsInteger;
     MovComposicaoC_COD_UNI.AsString := CadProdutos.fieldbyName('C_COD_UNI').AsString;
     MovComposicaoC_UNI_PAI.AsString := CadProdutos.fieldbyName('C_COD_UNI').AsString;
     MovComposicaoD_ULT_ALT.AsDateTime := date;
     MovComposicao.Post;
     CarregaMovComposicao;
     AtualizaConsulta;
   end;
end;

{*******************Move item de um list box para outro************************}
procedure TFComposicaoProduto.SpeedButton2Click(Sender: TObject);
begin
   if not MovComposicao.eof then
   begin
     MovComposicao.Delete;
     CarregaMovComposicao;
     AtualizaConsulta;
   end;
end;

{***************************** Valida Gravacao ****************************** }
function TFComposicaoProduto.ValidaGravar : Boolean;
begin
   result := true;
   if not MovComposicao.eof then
   begin
     MovComposicao.DisableControls;
     MovComposicao.First;
     while not MovComposicao.eof do
     begin
       if MovComposicaoN_QTD_PRO.AsFloat = 0 then
       begin
         aviso('Existe composição com quantidade nula!');
         result := false;
         break;
       end;
       MovComposicao.Next;
     end;
   end;
   MovComposicao.EnableControls;

   if not MovComposicao.IsEmpty then
     if (qdade.Text = '') or (ComboBoxColor1.Text = '') or (qdade.AValor = 0) then
     begin
       result := false;
       aviso('Quantidade pora cada ou unidade estão vazios')
     end;
end;

{****************************Fecha o Formulario corrente***********************}
procedure TFComposicaoProduto.BitBtn1Click(Sender: TObject);
begin
   if ValidaGravar then
     self.close
   else
     abort;
end;

{************************ atualiza a consulta ********************************}
procedure TFComposicaoProduto.ENomProdutoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    13: if (sender as TComponent).Tag = 1 then AtualizaConsulta else AtualizaConsultaComposicao;
  end;
end;

{************************ Atualiza a Consulta *********************************}
procedure TFComposicaoProduto.ENomProdutoExit(Sender: TObject);
begin
  AtualizaConsulta;
end;

{******************* antes de gravar o registro *******************************}
procedure TFComposicaoProduto.MovComposicaoBeforePost(DataSet: TDataSet);
begin
  //atualiza a data de alteracao para poder exportar
  MovComposicaoD_ULT_ALT.AsDateTime := Date;

  if not NF.ValidaUnidade( MovComposicaoC_COD_UNI.AsString, MovComposicaoC_UNI_PAI.AsString) then
  begin
    DBGridColor2.setfocus;
    abort;
  end;

  MovComposicaoN_QTD_COM.AsFloat := unpro.CalculaQdadePadrao( MovComposicaoC_COD_UNI.AsString, MovComposicaoC_UNI_PAI.AsString,
                                     MovComposicaoN_QTD_PRO.AsFloat, MovComposicaoI_SEQ_PRO.AsString);
end;

function TFComposicaoProduto.ValidaUnidade( CodUnidade : string ) : Boolean;
begin
   AdicionaSQLAbreTabela(Aux,'Select * from cadunidade where c_cod_uni = ''' + CodUnidade + '''');
   result := aux.eof;
end;

procedure TFComposicaoProduto.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FComposicaoProduto.HelpContext);
end;


function TFComposicaoProduto.LocalizaQdadeCada(SeqPro : Integer; var Unidade, UnidadeCom : string) : Double;
begin
   AdicionaSQLAbreTabela(Aux, ' Select c_cod_uni, n_qtd_com, c_uni_com from cadprodutos ' +
                              ' where i_seq_pro = ' + inttostr(SeqPro) +
                              ' and i_cod_emp = ' + IntToStr(varia.CodigoEmpresa));
   result := aux.fieldByName('n_qtd_com').AsFloat;
   unidade := aux.fieldByName('c_cod_uni').AsString;
   UnidadeCom := aux.fieldByName('c_uni_com').AsString;
   aux.close;
end;


procedure TFComposicaoProduto.MovComposicaoBeforeEdit(DataSet: TDataSet);
begin
  DBGridColor2.Columns[2].PickList := NF.UnidadesParentes(CadProdutos.FieldByname('c_cod_uni').AsString);
end;

procedure TFComposicaoProduto.MudaFlagComposicao;
begin
  if not MovComposicao.eof then
  begin
    if CadProdutos.FieldByName('c_pro_com').AsString <> 'S' then
    begin
      AdicionaSQLTabela(aux, ' update cadprodutos set c_pro_com = ''S'', ' +
                             ' d_ult_alt = ' + SQLTextoDataAAAAMMMDD(date) +
                             ' where i_seq_pro = ' + CadProdutosComI_SEQ_PRO.AsString +
                             ' and i_cod_emp = ' + IntToStr(varia.CodigoEmpresa));
      aux.ExecSQL;
    end;
  end
  else
  if CadProdutos.FieldByName('c_pro_com').AsString <> 'N' then
    begin
      AdicionaSQLTabela(aux, ' update cadprodutos set c_pro_com = ''N'', ' +
                             ' d_ult_alt = ' + SQLTextoDataAAAAMMMDD(date) +
                             ' where i_seq_pro = ' + CadProdutosComI_SEQ_PRO.AsString +
                             ' and i_cod_emp = ' + IntToStr(varia.CodigoEmpresa));
      aux.ExecSQL;
    end;
end;

procedure TFComposicaoProduto.MovComposicaoAfterPost(DataSet: TDataSet);
begin
  MudaFlagComposicao;
end;

procedure TFComposicaoProduto.AlteraQdadeCada( SeqPro : Integer; Qdade : Double; unidade : String);
begin
  ExecutaComandoSql(aux, ' update cadprodutos set n_qtd_com = ' +
                         SubstituiStr(FloatToStr(qdade),',','.') +
                         ', c_uni_com = ''' +  unidade + ''',' +
                         ' d_ult_alt = ' + SQLTextoDataAAAAMMMDD(date) +
                         ' where i_seq_pro = ' + IntToStr(SeqPro) +
                         ' and i_cod_emp = ' + IntToStr(varia.CodigoEmpresa));
end;

procedure TFComposicaoProduto.QdadeExit(Sender: TObject);
begin
  if (CadProdutosComI_SEQ_PRO.AsInteger <> 0) and (ComboBoxColor1.Text <> '') then
     AlteraQdadeCada(CadProdutosComI_SEQ_PRO.AsInteger, qdade.AValor,ComboBoxColor1.text);
end;


procedure TFComposicaoProduto.DBGridColor2KeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = '.' then  //se for pressinado ponto substitui por vírgula
     key := ',';
end;

procedure TFComposicaoProduto.DBGridColor2Exit(Sender: TObject);
begin
  if MovComposicao.State in [ DsInsert, DsEdit ] then
    MovComposicao.post;
end;

procedure TFComposicaoProduto.EcodProExit(Sender: TObject);
begin
  AtualizaConsulta;
end;

procedure TFComposicaoProduto.BitBtn2Click(Sender: TObject);
var
  uni, UniCom : string;
begin
    ExecutaComandoSql(Aux,' delete movcomposicaoproduto ' +
                          ' where i_pro_com = ' + CadProdutosComI_SEQ_PRO.AsString +
                          ' and i_cod_emp = ' + Inttostr(varia.CodigoEmpresa));

  adiciona.close;
  AdicionaSQLAbreTabela(adiciona,  ' select * from movcomposicaoproduto');

  AdicionaSQLAbreTabela(aux,' select i_seq_pro, c_cod_uni, n_qtd_pro, i_cod_emp, now(*), c_uni_pai ' +
                            ' from movcomposicaoproduto where ' +
                            ' i_pro_com = ' + inttostr(SeqPro) +
                            ' and i_cod_emp = ' + Inttostr(varia.CodigoEmpresa) );
  while not aux.eof do
  begin
    adiciona.insert;
    adiciona.fieldByname('i_pro_com').AsInteger := CadProdutosComI_SEQ_PRO.AsInteger;
    adiciona.fieldByname('i_seq_pro').AsInteger := aux.fieldByname('i_seq_pro').AsInteger;
    adiciona.fieldByname('c_cod_uni').AsString := aux.fieldByname('c_cod_uni').AsString;
    adiciona.fieldByname('n_qtd_pro').AsFloat := aux.fieldByname('n_qtd_pro').AsFloat;
    adiciona.fieldByname('i_cod_emp').AsInteger := aux.fieldByname('i_cod_emp').AsInteger;
    adiciona.fieldByname('d_ult_alt').AsDateTime := date;
    adiciona.fieldByname('c_uni_pai').AsString := aux.fieldByname('c_uni_pai').AsString;
    adiciona.post;
    aux.next;
  end;
  qdade.AValor := LocalizaQdadeCada(SeqPro,uni, UniCom);
  AlteraQdadeCada(CadProdutosComI_SEQ_PRO.AsInteger, qdade.avalor,UniCom);
  aux.close;
  CarregaMovComposicao;
  AtualizaConsulta;
end;

function  TFComposicaoProduto.SelectValida : string;
begin
 result := ' Select Pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
           ' pro.I_SEQ_PRO, mov.C_COD_BAR ' +
           ' From cadprodutos as pro, ' +
           ' MovQdadeProduto as mov ' +
           ' Where pro.I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
           ' and ' + varia.CodigoProduto + ' = ''@''' +
           ' and pro.C_KIT_PRO = ''P'' ' +
           ' and pro.I_seq_pro = Mov.I_seq_pro ' +
           ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil);
end;

function  TFComposicaoProduto.SelectLocaliza : string;
begin
  result := ' Select pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
            ' pro.I_SEQ_PRO, mov.C_COD_BAR ' +
            ' from cadprodutos as pro, ' +
            ' MovQdadeProduto as mov ' +
            ' Where pro.I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
            ' and pro.c_nom_pro like ''@%''' +
            ' and pro.C_KIT_PRO = ''P'' ' +
            ' and pro.I_seq_pro = Mov.I_seq_pro ' +
            ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil);
end;


procedure TFComposicaoProduto.EditLocaliza1Select(Sender: TObject);
begin
  EditLocaliza1.ASelectValida.Clear;
  EditLocaliza1.ASelectValida.add( SelectValida );
  EditLocaliza1.ASelectLocaliza.Clear;
  EditLocaliza1.ASelectLocaliza.add( SelectLocaliza );
end;

procedure TFComposicaoProduto.EditLocaliza1Retorno(Retorno1,
  Retorno2: String);
begin
  if Retorno1 <> '' then
    SeqPro := strtoint(Retorno1)
  else
    if EditLocaliza1.text <> '' then
      SeqPro := 0;
end;

procedure TFComposicaoProduto.EditLocaliza1Change(Sender: TObject);
begin
  BitBtn2.Enabled := EditLocaliza1.text <> '';
end;


procedure TFComposicaoProduto.EditColor3Enter(Sender: TObject);
begin
  if not ValidaGravar then
    abort;
end;

procedure TFComposicaoProduto.CadProdutosComBeforeScroll(
  DataSet: TDataSet);
begin
  if not ValidaGravar then
    abort;
end;

procedure TFComposicaoProduto.CadProdutosComAfterScroll(DataSet: TDataSet);
var
  uni, uniCom : string;
begin

  if not CadProdutosCom.IsEmpty then
  begin
    CarregaMovComposicao;
    AtualizaConsulta;
    qdade.AValor := LocalizaQdadeCada(CadProdutosComI_SEQ_PRO.AsInteger,uni, uniCom);
    ComboBoxColor1.Items := NF.UnidadesParentes(uni);
    if uniCom <> '' then
      ComboBoxColor1.ItemIndex := ComboBoxColor1.Items.IndexOf(uniCom)
    else
      ComboBoxColor1.ItemIndex := ComboBoxColor1.Items.IndexOf(uni);
    aux.close;
  end;
end;

procedure TFComposicaoProduto.CheckBox4Click(Sender: TObject);
begin
  AtualizaConsultaComposicao;
end;

Initialization
 RegisterClasses([TFComposicaoProduto]);
end.
