unit AEstoqueClassificacaoAtual;
{          Autor: Sergio Luiz Censi
    Data Criação: 06/04/1999;
          Função: Cadastrar um novo
  Data Alteração: 06/04/1999;
    Alterado por: Rafael Budag
Motivo alteração: - Adicionado os comentários e o blocos nas rotinas, e realizado
                    um teste - 06/04/199 / Rafael Budag
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, DBTables, Db, DBCtrls, Grids, DBGrids,
  Buttons, Menus, formularios, PainelGradiente,
  Tabela, Componentes1, LabelCorMove, Localizacao, Mask,
  numericos, DBKeyViolation, ImgList;

type
  TFEstoqueClassificacaoAtual = class(TFormularioPermissao)
    CadClassificacao: TQuery;
    Imagens: TImageList;
    PainelGradiente1: TPainelGradiente;
    PanelColor4: TPanelColor;
    Localiza: TConsultaPadrao;
    BFechar: TBitBtn;
    PanelColor5: TPanelColor;
    PanelColor6: TPanelColor;
    Splitter1: TSplitter;
    PanelColor1: TPanelColor;
    Empresa: TTreeView;
    PanelColor2: TPanelColor;
    Arvore: TTreeView;
    Aux: TQuery;
    AtiPro: TCheckBox;
    CadProdutos: TQuery;
    CadProdutosN_QTD_PRO: TFloatField;
    CadProdutosN_QTD_RES: TFloatField;
    CadProdutosQdadeReal: TFloatField;
    DataCadProdutos: TDataSource;
    GProdutos: TGridIndice;
    CadProdutosc_nom_cla: TStringField;
    CadProdutosCodcla: TStringField;
    numerico1: Tnumerico;
    numerico2: Tnumerico;
    numerico3: Tnumerico;
    Soma: TQuery;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    CZerada: TCheckBox;
    BitBtn1: TBitBtn;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure ArvoreExpanded(Sender: TObject; Node: TTreeNode);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ArvoreChange(Sender: TObject; Node: TTreeNode);
    procedure ArvoreCollapsed(Sender: TObject; Node: TTreeNode);
    procedure BFecharClick(Sender: TObject);
    procedure ArvoreKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ArvoreKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AtiProClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
  private
    QdadeNiveis : Byte;
    VetorMascara : array [1..6] of byte;
    VetorNo: array [0..6] of TTreeNode;
    CifraInicial : string;
    AtualizarConsulta  : Boolean;
    procedure CarregaEmpresa;
    function DesmontaMascara(var Vetor : array of byte; mascara:string):byte;
    procedure CarregaClassificacao(VetorInfo : array of byte);
    procedure RecarregaListaProdutos;
    procedure AdicionaFiltrosProduto(VpaSelect : TStrings);
    procedure AtualizaConsulta;
  public
    { Public declarations }
  end;

type
  TClassificacao = class
    Codigo    : string;
    CodigoRed : string;
    TamanhoMascara : string;
end;

type TEmpresa = class
  CodigoFilial : integer;
end;

var
  FEstoqueClassificacaoAtual: TFEstoqueClassificacaoAtual;

implementation

uses APrincipal, fundata, constantes, funObjeto, constMsg, funstring, funsql,
  AImprimeEstoqueClassificacao;


{$R *.DFM}

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                         Formulario
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***********************No fechamento do Formulario****************************}
procedure TFEstoqueClassificacaoAtual.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   FechaTabela(CadClassificacao);
   FechaTabela(Aux);
   Action := CaFree;
end;

{************************Quanto criado novo formulario*************************}
procedure TFEstoqueClassificacaoAtual.FormCreate(Sender: TObject);
begin
  GProdutos.Columns[3].Visible := Config.MostrarReservado;
  AtualizarConsulta := false;
  FillChar(VetorMascara, SizeOf(VetorMascara), 0);

  QdadeNiveis := DesmontaMascara(VetorMascara, varia.mascaraCLA);  // busca em constantes

  CarregaClassificacao(VetorMascara);
  CarregaEmpresa;
end;

{****************** quando inicia o formulario set a arvore ****************** }
procedure TFEstoqueClassificacaoAtual.FormShow(Sender: TObject);
begin
  arvore.Selected := arvore.TopItem;
  arvore.SetFocus;
  AtualizarConsulta := true;
  AtualizaConsulta;
  Self.HelpFile := Varia.PathHelp + 'MEstoqueCusto.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                   Monta a arvore de Empresa/Filial
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***************** carrega empresa filial *********************************** }
procedure  TFEstoqueClassificacaoAtual.CarregaEmpresa;
var
  no : TTreeNode;
  NoInicial : TTreeNode;
  NoFilial : TTreeNode;
  filial : integer;
  dado : TEmpresa;
begin

  empresa.Items.Clear;
  Dado:= TEmpresa.create;
  dado.CodigoFilial := Varia.CodigoEmpresa;
  no := empresa.Items.AddObject(empresa.Selected, varia.NomeEmpresa, Dado);
  NoInicial := no;
  no.ImageIndex:=4;
  no.SelectedIndex:=4;
  empresa.Update;

  AdicionaSQLAbreTabela(aux, ' select * from cadfiliais where i_cod_emp = ' + IntToStr(varia.CodigoEmpresa));

  while not(Aux.EOF) do
  begin

    dado := TEmpresa.Create;
    Dado.CodigoFilial := Aux.FieldByName('I_EMP_FIL').AsInteger;

    no := empresa.Items.AddChildObject( noInicial, IntToStr(Dado.CodigoFilial) + ' - ' +
                                       Aux.FieldByName('C_NOM_FIL').AsString, Dado);
    no.ImageIndex:=5;
    no.SelectedIndex:=5;

    if Aux.FieldByName('I_EMP_FIL').AsInteger = varia.CodigoEmpFil then
       NoFilial := no;
    aux.Next;
  end;

   empresa.FullExpand;
   empresa.Selected := noFilial;
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                   Monta a arvore de classificacao e produtos
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{******Desmonata a mascara pardão para a configuração das classificações*******}
function TFEstoqueClassificacaoAtual.DesmontaMascara(var Vetor : array of byte; mascara:string):byte;
var x:byte;
    posicao:byte;
begin
  posicao:=0;
  x:=0;
  while Pos('.', mascara) > 0 do
  begin
    vetor[x]:=(Pos('.', mascara)-posicao)-1;
    inc(x);
    posicao:=Pos('.', mascara);
    mascara[Pos('.', mascara)] := '*';
  end;
  vetor[x]:=length(mascara)-posicao;
  vetor[x+1] := 1;
  DesmontaMascara:=x+1;
end;

{************************carrega Classificacao*********************************}
procedure TFEstoqueClassificacaoAtual.CarregaClassificacao(VetorInfo : array of byte);
var
  no : TTreeNode;
  dado : TClassificacao;
  tamanho, nivel : word;
  codigo :string;
begin
  Arvore.Items.Clear;
  Dado:= TClassificacao.Create;
  Dado.codigo:='';
  Dado.CodigoRed:='';
  Dado.TamanhoMascara := IntToStr(VetorInfo[0]);
  no := arvore.Items.AddObject(arvore.Selected, 'Produtos', Dado);
  VetorNo[0]:=no;
  no.ImageIndex:=0;
  no.SelectedIndex:=0;
  Arvore.Update;

  CadClassificacao.SQL.Clear;
  CadClassificacao.SQL.Add('SELECT * FROM CADCLASSIFICACAO WHERE I_COD_EMP = ' + IntToStr(varia.CodigoEmpresa) +
                           ' and c_tip_cla = ''P''' +
                           ' ORDER BY C_COD_CLA ');
  CadClassificacao.Open;

  while not(CadClassificacao.EOF) do
  begin
    tamanho := VetorInfo[0];
    nivel := 0;
    while length(CadClassificacao.FieldByName('C_COD_CLA').AsString) <> tamanho do
    begin
      inc(nivel);
      tamanho := tamanho + VetorInfo[nivel];
    end;

    codigo :=CadClassificacao.FieldByName('C_COD_CLA').AsString;
    codigo:=copy(codigo, (length(codigo)-VetorInfo[nivel])+1, VetorInfo[nivel]);

    dado:= TClassificacao.Create;
    Dado.codigo:= CadClassificacao.FieldByName('C_COD_CLA').AsString;
    Dado.CodigoRed := codigo;

    if VetorInfo[nivel + 1] <> 0 then
      Dado.TamanhoMascara := IntTostr(tamanho + VetorInfo[nivel + 1])
    else
      Dado.TamanhoMascara := IntTostr(tamanho + VetorInfo[nivel] + 4);

    no:=Arvore.Items.AddChildObject(VetorNo[nivel], codigo+ ' - '+
                                                        CadClassificacao.FieldByName('C_NOM_CLA').AsString, Dado);
    VetorNo[nivel+1]:=no;

    CadClassificacao.Next;
  end;
end;


{*****cada deslocamento no TreeView causa uma mudança na lista da direita******}
procedure TFEstoqueClassificacaoAtual.ArvoreChange(Sender: TObject; Node: TTreeNode);
begin
  if AtualizarConsulta then
   AtualizaConsulta;
end;

{ *******************Cada vez que expandir um no*******************************}
procedure TFEstoqueClassificacaoAtual.ArvoreExpanded(Sender: TObject; Node: TTreeNode);
begin
   node.SelectedIndex:=1;
   node.ImageIndex:=1;
end;

{********************Cada vez que voltar a expanção de um no*******************}
procedure TFEstoqueClassificacaoAtual.ArvoreCollapsed(Sender: TObject; Node: TTreeNode);
begin
   node.SelectedIndex:=0;
   node.ImageIndex:=0;
end;

{ **************** se presionar a setas naum atualiza movimentos ************ }
procedure TFEstoqueClassificacaoAtual.ArvoreKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key in[37..40]  then
end;

{ ************ apos soltar setas atualiza movimentos ************************ }
procedure TFEstoqueClassificacaoAtual.ArvoreKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  ArvoreChange(sender,arvore.Selected);
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                 Filtro de produto / empresa / filial
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}


{************************** Recarrega lista ********************************* }
procedure TFEstoqueClassificacaoAtual.RecarregaListaProdutos;
begin
  arvore.Selected := Arvore.Items.GetFirstNode;
  arvore.Selected.Collapse(true);
  arvore.Items.Clear;
  CarregaClassificacao(VetorMascara);
  arvore.Selected := arvore.TopItem;
end;

{ ***************** altera a mostra entre produtos em atividades ou naum ******}
procedure TFEstoqueClassificacaoAtual.AtiProClick(Sender: TObject);
begin
  RecarregaListaProdutos;
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************************Fecha o Formulario corrente***********************}
procedure TFEstoqueClassificacaoAtual.BFecharClick(Sender: TObject);
begin
  close;
end;

{********************** select do estoque *********************************** }
procedure TFEstoqueClassificacaoAtual.AtualizaConsulta;
var
  Tamanho : string;
begin
  tamanho := TClassificacao(arvore.Selected.Data).TamanhoMascara;

  CadProdutos.sql.clear;
  CadProdutosCodcla.Size := StrToInt(tamanho);;
  InseriLinhaSQL(CadProdutos, 0, 'Select ');
  InseriLinhaSQL(CadProdutos, 1, ' left(pro.c_cod_cla,' + tamanho + ') as Codcla ,'+
                                 ' cla.c_nom_cla, isnull(sum(qtd.n_qtd_pro),0) n_qtd_pro, ' +
                                 ' isnull(sum(QTD.N_QTD_RES),0) N_QTD_RES, ' +
                                 ' sum(isnull(QTD.N_QTD_PRO,0) - isnull(QTD.N_QTD_RES,0)) QdadeReal ' );
   InseriLinhaSQL(CadProdutos, 2,' from CadProdutos pro, MovQdadeProduto Qtd, cadClassificacao cla ');
   CadProdutos.sql.add(' where Qtd.I_Seq_Pro = Pro.I_Seq_Pro ' );
  AdicionaFiltrosProduto(Cadprodutos.Sql);
  CadProdutos.sql.add(' and pro.i_cod_emp = cla.i_cod_emp ' +
                      ' and cla.c_cod_cla = CodCla ' +
                      ' and cla.i_cod_emp = ' + IntTostr(varia.CodigoEmpresa )  +
                      ' and cla.c_tip_cla = ''P'' ' );
  CadProdutos.sql.add(' group by left(pro.c_cod_cla,' + tamanho +  '), cla.c_nom_cla'  +
                      ' order by left(pro.c_cod_cla,' + tamanho +  ') ' );
  CadProdutos.Open;

  // soma total estoque
  Soma.sql.clear;
  InseriLinhaSQL(Soma, 0, 'Select ');
  InseriLinhaSQL(Soma, 1, ' isnull(sum(qtd.n_qtd_pro),0) qdade, ' +
                          ' isnull(sum(QTD.N_QTD_RES),0) qdaderes, ' +
                          ' sum(isnull(QTD.N_QTD_PRO,0) - isnull(QTD.N_QTD_RES,0)) QdadeReal ' );
  InseriLinhaSQL(Soma, 2,' from CadProdutos pro, MovQdadeProduto Qtd, cadClassificacao cla ');
  Soma.sql.add(' where Qtd.I_Seq_Pro = Pro.I_Seq_Pro ' );
  AdicionaFiltrosProduto(Soma.Sql);
  Soma.sql.add(' and pro.i_cod_emp = cla.i_cod_emp ' +
               ' and cla.c_cod_cla =  pro.c_cod_cla ' +
               ' and cla.i_cod_emp = ' + IntTostr(varia.CodigoEmpresa )  +
               ' and cla.c_tip_cla = ''P'' ' );
  Soma.Open;
  numerico1.AValor := Soma.fieldByName('qdade').AsCurrency;
  numerico2.AValor := Soma.fieldByName('qdadeRes').AsCurrency;
  numerico3.AValor := Soma.fieldByName('qdadeReal').AsCurrency;
end;

{******************* adiciona os filtros da consulta **************************}
procedure TFEstoqueClassificacaoAtual.AdicionaFiltrosProduto(VpaSelect : TStrings);
begin
  if TEmpresa(Empresa.Selected.Data).CodigoFilial <> varia.CodigoEmpresa then
    VpaSelect.add('and Qtd.I_Emp_Fil = ' + IntToStr(TEmpresa(Empresa.Selected.Data).CodigoFilial));

  VpaSelect.add(' and Pro.C_Cod_Cla like '''+ TClassificacao(arvore.Selected.Data).Codigo + '%''');

  if AtiPro.Checked then
    VpaSelect.add(' and Pro.C_Ati_Pro = ''S''');
  if CZerada.Checked then
    VpaSelect.add(' and isnull(Qtd.n_qtd_pro,0) <> 0 ' );
end;



procedure TFEstoqueClassificacaoAtual.BitBtn1Click(Sender: TObject);
begin
  FImprimeEstoqueClassificacao := TFImprimeEstoqueClassificacao.CriarSDI(application, '', true);
  FImprimeEstoqueClassificacao.carregaImpressao( CadProdutos.SQL.Text, Varia.NomeEmpresa, Empresa.Selected.Text,
                                           FormatFloat(varia.MascaraValor, numerico1.avalor),
                                           FormatFloat(varia.MascaraValor, numerico2.avalor),
                                           FormatFloat(varia.MascaraValor, numerico3.avalor),
                                           arvore.Selected.Text,
                                           StrToInt(TClassificacao(arvore.Selected.Data).TamanhoMascara));
end;

procedure TFEstoqueClassificacaoAtual.BBAjudaClick(Sender: TObject);
begin
    Application.HelpCommand(HELP_CONTEXT,FEstoqueClassificacaoAtual.HelpContext);
end;

end.
