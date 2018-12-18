unit AAdicionaProdFilial;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, DBTables, Db, DBCtrls, Grids, DBGrids,
  Buttons, Menus, formularios, PainelGradiente,
  Tabela, Componentes1, LabelCorMove, Localizacao, Mask,
  EditorImagem, ImgList, numericos, UnProdutos, DBKeyViolation;

type
  TFAdicionaProdFilial = class(TFormularioPermissao)
    Splitter1: TSplitter;
    CadClassificacao: TQuery;
    CadProdutos: TQuery;
    PainelGradiente1: TPainelGradiente;
    PanelColor2: TPanelColor;
    Arvore: TTreeView;
    PanelColor4: TPanelColor;
    BLocalizar: TBitBtn;
    Localiza: TConsultaPadrao;
    VisualizadorImagem1: TVisualizadorImagem;
    BFechar: TBitBtn;
    PopupMenu1: TPopupMenu;
    Localizar1: TMenuItem;
    ImageList1: TImageList;
    MostraProdutos: TQuery;
    DataMostraProdutos: TDataSource;
    PanelColor3: TPanelColor;
    AtiPro: TCheckBox;
    S: TQuery;
    Imagens: TImageList;
    Panel1: TPanel;
    ValidaGravacao: TValidaGravacao;
    LFilial: TLabel;
    TTempo: TPainelTempo;
    PanelColor8: TPanelColor;
    PanelColor1: TPanelColor;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    Label3: TLabel;
    EFilPro: TEditLocaliza;
    BTransfere: TBitBtn;
    NPerCom: Tnumerico;
    NQtdPed: Tnumerico;
    NQtdMin: Tnumerico;
    EProClass: TEditColor;
    EFilial: TEditLocaliza;
    BPais: TSpeedButton;
    Label4: TLabel;
    LProClass: TLabel;
    LblQtdMin: TLabel;
    LblQtdPed: TLabel;
    Label21: TLabel;
    Label5: TLabel;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure ArvoreExpanded(Sender: TObject; Node: TTreeNode);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ArvoreChange(Sender: TObject; Node: TTreeNode);
    procedure ArvoreCollapsed(Sender: TObject; Node: TTreeNode);
    procedure BLocalizarClick(Sender: TObject);
    procedure BFecharClick(Sender: TObject);
    procedure ArvoreKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ArvoreKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AtiProClick(Sender: TObject);
    procedure BTransfereClick(Sender: TObject);
    procedure NQtdProdChange(Sender: TObject);
    procedure EFilialSelect(Sender: TObject);
    procedure EFilialRetorno(Retorno1, Retorno2: String);
    procedure EFilProSelect(Sender: TObject);
    procedure EFilProRetorno(Retorno1, Retorno2: String);
    procedure BBAjudaClick(Sender: TObject);
  private
    UnProduto : TFuncoesProduto;
    Listar : boolean;
    QdadeNiveis : Byte;
    VetorMascara : array [1..6] of byte;
    VetorNo: array [0..6] of TTreeNode;
    NoSelecao,
    PrimeiroNo : TTreeNode;
    VprEmpFil, VprCodEmp : string;    
    function DesmontaMascara(var Vetor : array of byte; mascara:string):byte;
    procedure CarregaClassificacao(VetorInfo : array of byte);
    procedure CarregaProduto(VetorInfo : array of byte; nivel : byte; Codigo : string; NoSelecao : TTreeNode);
    procedure CarregaDetalhesProduto( CodigoProduto : string );
    procedure RecarregaLista;
  public
    { Public declarations }
  end;

type
  TClassificacao = class
    Codigo    : string;
    CodigoRed : string;
    Tipo : string;
    Situacao : boolean;
    PathFoto : string;
    Sequencial : string;
end;

var
  FAdicionaProdFilial: TFAdicionaProdFilial;

implementation

uses APrincipal, ANovoProduto, fundata, constantes,funObjeto, constMsg,
     ANovaClassificacao;

{$R *.DFM}

{***********************No fechamento do Formulario****************************}
procedure TFAdicionaProdFilial.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   UnProduto.Destroy;
   CadProdutos.Close;
   CadClassificacao.Close;
   Action := CaFree;
end;

{************************Quanto criado novo formulario*************************}
procedure TFAdicionaProdFilial.FormCreate(Sender: TObject);
begin
  UnProduto := TFuncoesProduto.criar(self,FPrincipal.BaseDados);
  Self.HelpFile := Varia.PathHelp + 'MPONTOLOJA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
  FillChar(VetorMascara, SizeOf(VetorMascara), 0);   // Incializa o array com 0.
  EFilPro.text := IntToStr(Varia.CodigoEmpFil);
  Listar := True;
  UnProduto.VerificaMascaraClaPro; // Verifica se existe máscara para a classificação;
  CadProdutos.open;
  QdadeNiveis := DesmontaMascara(VetorMascara, Varia.MascaraCLA);
  CarregaClassificacao(VetorMascara);
end;

{ ***** Desmonata a mascara padrão para a configuração das classificações ****** }
function TFAdicionaProdFilial.DesmontaMascara(var Vetor : array of byte; mascara:string):byte;
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

{ **** Carrega Classificacao **** }
procedure TFAdicionaProdFilial.CarregaClassificacao(VetorInfo : array of byte);
var
  No : TTreeNode;
  Dado : TClassificacao;
  Tamanho,
  Nivel : word;
  Codigo : string;
begin
  Arvore.Items.Clear;
  Dado:= TClassificacao.Create;
  Dado.codigo:='';
  Dado.CodigoRed:='';
  Dado.Tipo := 'CL';
  No := Arvore.Items.AddObject(Arvore.Selected, 'Produtos', Dado);
  NoSelecao := No;
  PrimeiroNo := No;
  VetorNo[0]:=No;
  No.ImageIndex:=0;
  No.SelectedIndex:=0;
  Arvore.Update;

  CadClassificacao.SQL.Clear;
  CadClassificacao.SQL.Add('SELECT * FROM CADCLASSIFICACAO WHERE I_COD_EMP = ' + IntToStr(Varia.CodigoEmpresa) +
                           ' and c_tip_cla = ''P''' +
                           ' ORDER BY C_COD_CLA ');
  CadClassificacao.Open;
  while not(CadClassificacao.EOF) do
  begin
    Tamanho := VetorInfo[0];
    Nivel := 0;
    while length(CadClassificacao.FieldByName('C_COD_CLA').AsString) <> tamanho do
    begin
      inc(nivel);
      tamanho:=tamanho+VetorInfo[nivel];
    end;

    codigo :=CadClassificacao.FieldByName('C_COD_CLA').AsString;
    codigo:=copy(codigo, (length(codigo)-VetorInfo[nivel])+1, VetorInfo[nivel]);

    dado:= TClassificacao.Create;
    Dado.codigo:= CadClassificacao.FieldByName('C_COD_CLA').AsString;
    Dado.CodigoRed := codigo;
    Dado.tipo := 'CL';
    Dado.Situacao := true;
    Dado.PathFoto := '';

    no:=Arvore.Items.AddChildObject(VetorNo[nivel], codigo+ ' - '+
                                                        CadClassificacao.FieldByName('C_NOM_CLA').AsString, Dado);
    VetorNo[nivel+1]:=no;
    CadClassificacao.Next;
  end;
end;

{********carregaProduto : serve para carregar o TreeView com as informações
                    da base que estão na tabela Produtos.**********************}
procedure TFAdicionaProdFilial.CarregaProduto(VetorInfo : array of byte; nivel : byte; Codigo : string; NoSelecao : TTreeNode );
var
  no : TTreeNode;
  dado : TClassificacao;
begin

if TClassificacao(TTreeNode(NoSelecao).Data).Situacao then
begin
     CadProdutos.Close;
     CadProdutos.sql.Clear;
     CadProdutos.sql.add(' Select ' +
                         ' pro.i_seq_pro, pro.c_cod_cla, pro.c_ati_pro, ' +
                         ' pro.c_cod_pro, pro.c_pat_fot, pro.c_nom_pro, moe.c_cif_moe, ' +
                         ' pro.c_kit_pro ' +
                         ' from CadProdutos as pro '  +
                         ' ,MovQdadeProduto as mov, CadMoedas as moe ' +
                         ' where PRO.I_COD_EMP = ' + IntToStr(varia.CodigoEmpresa) +
                         ' and PRO.C_COD_CLA = ''' + codigo + '''');

     if AtiPro.Checked then
        CadProdutos.sql.add(' and PRO.C_ATI_PRO = ''S''');

      CadProdutos.sql.add(' and pro.I_seq_pro = mov.i_seq_pro ' +
                          ' and mov.i_emp_fil = ' + EFilPro.text +
                          ' and pro.i_cod_moe = moe.i_cod_moe' );

     CadProdutos.sql.add('  Order by C_COD_PRO');

     CadProdutos.open;
     CadProdutos.First;

     while not CadProdutos.EOF do
     begin
       dado:= TClassificacao.Create;
       Dado.codigo := CadProdutos.FieldByName('C_COD_PRO').AsString;
       Dado.CodigoRed := '';
       Dado.Situacao := true;
       Dado.tipo := 'PA';
       Dado.PathFoto := CadProdutos.FieldByName('C_PAT_FOT').AsString;
       Dado.Sequencial := CadProdutos.FieldByName('I_SEQ_PRO').AsString;

       codigo := CadProdutos.FieldByName('C_COD_PRO').AsString;

       if config.VerCodigoProdutos then  // configura se mostra ou naum o codigo do produto..
          no := Arvore.Items.AddChildObject(NoSelecao, codigo + ' - ' +
                                            CadProdutos.FieldByName('C_NOM_PRO').AsString, Dado)
       else
          no := Arvore.Items.AddChildObject(NoSelecao,
                                        CadProdutos.FieldByName('C_NOM_PRO').AsString, Dado);

       VetorNo[nivel+1] := no;
       if CadProdutos.FieldByName('C_KIT_PRO').AsString = 'P' then
       begin
          no.ImageIndex := 2;
          no.SelectedIndex := 2;
       end
       else
       begin
          no.ImageIndex := 3;
          no.SelectedIndex := 3;
       end;
       CadProdutos.Next;
     end;
TClassificacao(TTreeNode(NoSelecao).Data).Situacao := false;
end;
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                           Chamadas diversas dos Tree
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{*****cada deslocamento no TreeView causa uma mudança na lista da direita******}
procedure TFAdicionaProdFilial.ArvoreChange(Sender: TObject; Node: TTreeNode);
begin
  if listar then
  begin
    MostraProdutos.Close; // fecha a tabela dos detalhes do produto
    if TClassificacao(TTreeNode(node).Data).tipo = 'CL' then
    begin
      CarregaProduto(VetorMascara,node.Level,TClassificacao(TTreeNode(node).Data).Codigo,node);
      LProClass.Caption := 'Classificação : ';
    end
    else
    if (TClassificacao(TTreeNode(node).Data).tipo = 'PA') Then
    begin
      // CarregaDetalhesProduto(TClassificacao(TTreeNode(node).Data).Sequencial);  // carrega os detalhes do produto;
      LProClass.Caption := 'Produto : ';
    end;
    Arvore.Update;
    NoSelecao := Node;
    ValidaGravacao.Execute;
    EProClass.Text := TClassificacao(NoSelecao.Data).Codigo;
  end;
end;

{ *******************Cada vez que expandir um no*******************************}
procedure TFAdicionaProdFilial.ArvoreExpanded(Sender: TObject; Node: TTreeNode);
begin
   carregaProduto(VetorMascara,node.Level,TClassificacao(TTreeNode(node).Data).Codigo,node);
   if TClassificacao(TTreeNode(node).Data).tipo = 'CL' then
   begin
      node.SelectedIndex:=1;
      node.ImageIndex:=1;
   end;
end;

{********************Cada vez que voltar a expanção de um no*******************}
procedure TFAdicionaProdFilial.ArvoreCollapsed(Sender: TObject; Node: TTreeNode);
begin
   if TClassificacao(TTreeNode(node).Data).tipo = 'CL' then
   begin
     node.SelectedIndex:=0;
     node.ImageIndex:=0;
   end;
end;

{ **************** se presionar a setas naum atualiza movimentos ************ }
procedure TFAdicionaProdFilial.ArvoreKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key in[37..40]  then
   listar := false;
end;

{ ************ apos soltar setas atualiza movimentos ************************ }
procedure TFAdicionaProdFilial.ArvoreKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  listar := true;
  ArvoreChange(sender,arvore.Selected);
end;

procedure TFAdicionaProdFilial.BLocalizarClick(Sender: TObject);
var
  codigo, select : string;
  somaNivel,nivelSelecao : integer;
begin
  select :=' Select * from cadProdutos as pro ' + ' ,MovQdadeProduto as mov ' + ' where c_nom_pro like ''@%''';
   if AtiPro.Checked then
      select := select + ' and C_ATI_PRO = ''S''';
   select := select + ' and pro.I_seq_pro = mov.i_seq_pro order by c_nom_pro asc';
   Localiza.info.DataBase := Fprincipal.BaseDados;
   Localiza.info.ComandoSQL := select;
   Localiza.info.caracterProcura := '@';
   Localiza.info.ValorInicializacao := '';
   Localiza.info.CamposMostrados[0] := 'C_cod_pro';
   Localiza.info.CamposMostrados[1] := 'c_nom_pro';
   Localiza.info.CamposMostrados[2] := '';
   Localiza.info.DescricaoCampos[0] := 'codigo';
   Localiza.info.DescricaoCampos[1] := 'nome';
   Localiza.info.DescricaoCampos[2] := '';
   Localiza.info.TamanhoCampos[0] := 8;
   Localiza.info.TamanhoCampos[1] := 40;
   Localiza.info.TamanhoCampos[2] := 0;
   Localiza.info.CamposRetorno[0] := 'I_SEQ_PRO';
   Localiza.info.CamposRetorno[1] := 'C_cod_cla';
   Localiza.info.SomenteNumeros := false;
   Localiza.info.CorFoco := FPrincipal.CorFoco;
   Localiza.info.CorForm := FPrincipal.CorForm;
   Localiza.info.CorPainelGra := FPrincipal.CorPainelGra;
   Localiza.info.TituloForm := 'Localizar Produtos';
   if Localiza.execute then
   if localiza.retorno[0] <> '' Then
   begin
       SomaNivel := 1;
       NivelSelecao := 1;
       listar := false;
       arvore.Selected := PrimeiroNo;

       while SomaNivel <= Length(localiza.retorno[1]) do
       begin
          codigo := copy(localiza.retorno[1], SomaNivel, VetorMascara[nivelSelecao]);
          SomaNivel := SomaNivel + VetorMascara[nivelSelecao];

          arvore.Selected := arvore.Selected.GetNext;
          while TClassificacao(arvore.Selected.Data).CodigoRed <> Codigo  do
            arvore.Selected := arvore.Selected.GetNextChild(arvore.selected);
          inc(NivelSelecao);
       end;

       carregaProduto(VetorMascara,arvore.selected.Level,TClassificacao(arvore.selected.Data).Codigo,arvore.selected);

       arvore.Selected := arvore.Selected.GetNext;
       while TClassificacao(arvore.Selected.Data).Sequencial <> localiza.retorno[0]  do
         arvore.Selected := arvore.Selected.GetNextChild(arvore.selected);

   end;

   listar := true;
   ArvoreChange(sender,arvore.Selected);
   self.ActiveControl := arvore;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
             Carrega detalhes dos produtos na direita
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

procedure TFAdicionaProdFilial.CarregaDetalhesProduto( CodigoProduto : string );
begin
  MostraProdutos.close;
  MostraProdutos.sql.Clear;
  MostraProdutos.sql.Add( ' Select ' +
                          ' MovPro.i_seq_pro, MovPro.d_ult_ven, MovPro.d_ult_com, ' +
                          ' MovPro.n_qtd_pro, MovPro.n_qtd_min, ' +
                          ' MovPro.n_qtd_ped, Tab.n_vlr_ven, MovPro.n_vlr_com, ' +
                          ' Pro.c_cod_uni, Pro.L_des_Tec, pro.c_kit_pro, ' +
                          ' movpro.n_vlr_cmc, movpro.n_vlr_cmv, ' +
                          ' MovPro.n_qtd_com, MovPro.n_qtd_ven, MovPro.n_vlr_cus, '+
                          ' moe.c_cif_moe + '' - '' + moe.c_nom_moe as moeda, moe.c_cif_moe ' +
                          ' from  MovQdadeProduto as MovPro, CadProdutos as Pro, ' +
                          ' MovTabelaPreco as tab, CadMoedas as moe ' +
                          ' where ' +
                          ' MovPro.I_SEQ_PRO = ' + CodigoProduto +
                          ' and MovPro.I_SEQ_PRO = Pro.I_SEQ_PRO ' );
  if EFilPro.Text <> '' then
    MostraProdutos.sql.Add( ' and MovPro.I_EMP_FIL = ' + EFilPro.text );
  MostraProdutos.sql.Add( ' and MovPro.I_SEQ_PRO *= tab.I_SEQ_PRO ' +
                          ' and Tab.I_COD_EMP = ' + intTostr(varia.CodigoEmpresa) +
                          ' and Tab.I_COD_TAB = ' + intTostr(varia.TabelaPreco) +
                          ' and Pro.I_COD_MOE = Moe.I_COD_MOE ' );
  MostraProdutos.open;
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************************Fecha o Formulario corrente***********************}
procedure TFAdicionaProdFilial.BFecharClick(Sender: TObject);
begin
   close;
end;

{ ***************** altera a mostra entre produtos em atividades ou naum ******}
procedure TFAdicionaProdFilial.AtiProClick(Sender: TObject);
begin
  RecarregaLista;
end;

{********************** Carega vetor ***************************************** }
procedure TFAdicionaProdFilial.RecarregaLista;
begin
  Listar := false;
  Arvore.Items.Clear;
  Listar := true;
  CarregaClassificacao(VetorMascara);
end;

procedure TFAdicionaProdFilial.BTransfereClick(Sender: TObject);
begin
  TTempo.Execute('Transferindo produto para filial...');
  if TClassificacao(NoSelecao.Data).tipo = 'CL' then
    UnProduto.InseriProdutoClassificacaoFilial( TClassificacao(NoSelecao.Data).Codigo,VprEmpFil,VprCodEmp,
                                                 NQtdMin.AValor, NQtdPed.AValor, NPerCom.AValor, true)
  else
    UnProduto.InseriProdutoClassificacaoFilial( TClassificacao(NoSelecao.Data).Sequencial,VprEmpFil,VprCodEmp,
                                                 NQtdMin.AValor, NQtdPed.AValor, NPerCom.AValor, false);
  TTempo.Fecha;
end;

procedure TFAdicionaProdFilial.NQtdProdChange(Sender: TObject);
begin
  ValidaGravacao.Execute;
  if EFilial.Text = '' then
    BTransfere.Enabled := false;
end;

procedure TFAdicionaProdFilial.EFilialSelect(Sender: TObject);
begin
  EFilial.ASelectLocaliza.Clear;
  EFilial.ASelectLocaliza.Add(' SELECT * FROM CADFILIAIS ' +
                              ' WHERE C_NOM_FAN LIKE ''%@'' ' +
                              ' AND I_COD_EMP = ' + IntToStr(Varia.CodigoEmpresa));
  EFilial.ASelectValida.Clear;
  EFilial.ASelectValida.Add(' SELECT * FROM CADFILIAIS ' +
                            ' WHERE I_EMP_FIL = @ ' +
                            ' AND I_COD_EMP = ' + IntToStr(Varia.CodigoEmpresa));
end;

procedure TFAdicionaProdFilial.EFilialRetorno(Retorno1, Retorno2: String);
begin
  VprEmpFil := Retorno1;
  VprCodEmp := Retorno2;
end;

procedure TFAdicionaProdFilial.EFilProSelect(Sender: TObject);
begin
  EFilPro.ASelectLocaliza.Clear;
  EFilPro.ASelectLocaliza.add( ' Select * from dba.CadFiliais ' +
                               ' where I_COD_EMP = ' +  inttostr(Varia.CodigoEmpresa) +
                               ' and c_nom_fan like ''@%''');
  EFilPro.ASelectValida.Clear;
  EFilPro.ASelectValida.add( ' Select * from CadFiliais where I_EMP_FIL = @ ' +
                             ' and I_COD_EMP = ' +  inttostr(Varia.CodigoEmpresa) );
end;

procedure TFAdicionaProdFilial.EFilProRetorno(Retorno1, Retorno2: String);
begin
 if EFilPro.Text = '' then
   EFilPro.text := IntToStr(Varia.CodigoEmpFil);
 RecarregaLista;
end;

procedure TFAdicionaProdFilial.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FAdicionaProdFilial.HelpContext);
end;

end.
