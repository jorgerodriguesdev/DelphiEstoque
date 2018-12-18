unit AServicos;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, DBTables, Db, DBCtrls, Grids, DBGrids,
  Buttons, Menus, formularios, PainelGradiente,
  Tabela, Componentes1, LabelCorMove, Localizacao, Mask,
  EditorImagem, ImgList, numericos, UnClassificacao;

type
  TFServicos = class(TFormularioPermissao)
    Splitter1: TSplitter;
    CadClassificacao: TQuery;
    Imagens: TImageList;
    CadServicos: TQuery;
    PainelGradiente1: TPainelGradiente;
    PanelColor2: TPanelColor;
    Arvore: TTreeView;
    PanelColor4: TPanelColor;
    BAlterar: TBitBtn;
    BExcluir: TBitBtn;
    BServicos: TBitBtn;
    BitBtn1: TBitBtn;
    Localiza: TConsultaPadrao;
    BClasssificao: TBitBtn;
    BFechar: TBitBtn;
    BConsulta: TBitBtn;
    PopupMenu1: TPopupMenu;
    NovaClassificao1: TMenuItem;
    NovoProduto1: TMenuItem;
    N1: TMenuItem;
    Alterar1: TMenuItem;
    Excluir1: TMenuItem;
    Consultar1: TMenuItem;
    Localizar1: TMenuItem;
    N2: TMenuItem;
    ImageList1: TImageList;
    Aux: TQuery;
    EditColor1: TEditColor;
    CAtiPro: TCheckBox;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure ArvoreExpanded(Sender: TObject; Node: TTreeNode);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ArvoreChange(Sender: TObject; Node: TTreeNode);
    procedure ArvoreCollapsed(Sender: TObject; Node: TTreeNode);
    Procedure Excluir(Sender : TObject);
    procedure BAlterarClick(Sender: TObject);
    procedure BExcluirClick(Sender: TObject);
    procedure BClasssificaoClick(Sender: TObject);
    procedure BServicosClick(Sender: TObject);
    procedure BFecharClick(Sender: TObject);
    procedure BConsultaClick(Sender: TObject);
    procedure ArvoreDblClick(Sender: TObject);
    procedure ArvoreKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ArvoreKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AtiProClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
  private
    Listar : boolean;
    QtdNiveis : Byte;
    VetorMascara : array [1..6] of byte;
    VetorNo: array [0..6] of TTreeNode;
    VprPrimeiroNo : TTreeNode;
    function DesmontaMascara(var Vetor : array of byte; mascara:string):byte;
    procedure CadastraClassificacao;
    function LimpaArvore : TTreeNode;
    procedure CarregaClassificacao(VpaVetorInfo : array of byte);
    procedure CarregaServico(VetorInfo : array of byte; nivel : byte; Codigo : string; NoSelecao : TTreeNode);
    procedure Habilita(  Node: TTreeNode );
    procedure RecarregaLista;
    procedure CadatraServico;
    procedure Alterar(Sender: TObject;Alterar : Boolean);
  public
    { Public declarations }
  end;

var
  FServicos: TFServicos;

implementation

uses APrincipal, Fundata, constantes, funObjeto, FunSql,
  constMsg, funstring, ANovaClassificacao, ANovoServico;

{$R *.DFM}
{***********************No fechamento do Formulario****************************}
procedure TFServicos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   CadServicos.Close;
   CadClassificacao.Close;
   Action := CaFree;
end;

{************************Quanto criado novo formulario*************************}
procedure TFServicos.FormCreate(Sender: TObject);
begin
  FillChar(VetorMascara, SizeOf(VetorMascara), 0);
  Self.HelpFile := Varia.PathHelp + 'MPONTOLOJA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
  Listar := true;
  CadServicos.open;
  QtdNiveis := DesmontaMascara(VetorMascara, varia.MascaraClaSer);  // busca em constantes
  CarregaClassificacao(VetorMascara);
  Arvore.Color := EditColor1.Color;
  Arvore.Font := EditColor1.font;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                           Chamadas diversas dos Tree
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{*****cada deslocamento no TreeView causa uma mudança na lista da direita******}
procedure TFServicos.ArvoreChange(Sender: TObject; Node: TTreeNode);
begin
  habilita(node);
  if listar then
  begin
     if TClassificacao(TTreeNode(node).Data).tipo = 'CL' then
     begin
        CarregaServico(VetorMascara,node.Level,TClassificacao(TTreeNode(node).Data).Codigo, node);
     end;
   arvore.Update;
  end;
end;

{ *******************Cada vez que expandir um no*******************************}
procedure TFServicos.ArvoreExpanded(Sender: TObject; Node: TTreeNode);
begin
  CarregaServico(VetorMascara,node.Level,TClassificacao(TTreeNode(node).Data).Codigo,node);
  if TClassificacao(TTreeNode(node).Data).tipo = 'CL' then
  begin
    Node.SelectedIndex:=1;
    Node.ImageIndex:=1;
  end;
end;

{********************Cada vez que voltar a expanção de um no*******************}
procedure TFServicos.ArvoreCollapsed(Sender: TObject; Node: TTreeNode);
begin
  if TClassificacao(TTreeNode(node).Data).tipo = 'CL' then
  begin
    Node.SelectedIndex:=0;
    Node.ImageIndex:=0;
  end;
end;

{ **************** se presionar a setas naum atualiza movimentos ************ }
procedure TFServicos.ArvoreKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key in[37..40]  then
    Listar := False;
end;

{ ************ apos soltar setas atualiza movimentos ************************ }
procedure TFServicos.ArvoreKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Listar := true;
  ArvoreChange(sender,arvore.Selected);
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações de localizacao do servico
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{************************ localiza o servico **********************************}
procedure TFServicos.BitBtn1Click(Sender: TObject);
var
  codigo, select : string;
  somaNivel,nivelSelecao : integer;
begin
  select :=' Select * from cadservico '   +
           ' where c_nom_ser like ''@%''' +
           ' order by c_nom_ser ';
   Localiza.info.DataBase := Fprincipal.BaseDados;
   Localiza.info.ComandoSQL := select;
   Localiza.info.caracterProcura := '@';
   Localiza.info.ValorInicializacao := '';
   Localiza.info.CamposMostrados[0] := 'I_cod_SER';
   Localiza.info.CamposMostrados[1] := 'c_nom_SER';
   Localiza.info.CamposMostrados[2] := '';
   Localiza.info.DescricaoCampos[0] := 'Código';
   Localiza.info.DescricaoCampos[1] := 'Nome Serviço';
   Localiza.info.DescricaoCampos[2] := '';
   Localiza.info.TamanhoCampos[0] := 8;
   Localiza.info.TamanhoCampos[1] := 40;
   Localiza.info.TamanhoCampos[2] := 0;
   Localiza.info.CamposRetorno[0] := 'I_cod_ser';
   Localiza.info.CamposRetorno[1] := 'C_cod_cla';
   Localiza.info.SomenteNumeros := false;
   Localiza.info.CorFoco := FPrincipal.CorFoco;
   Localiza.info.CorForm := FPrincipal.CorForm;
   Localiza.info.CorPainelGra := FPrincipal.CorPainelGra;
   Localiza.info.TituloForm := '  Localizar Serviços  ';
   if Localiza.execute then
   if localiza.retorno[0] <> '' Then
   begin
       SomaNivel := 1;
       NivelSelecao := 1;
       listar := false;
       arvore.Selected := VprPrimeiroNo;
       while SomaNivel <= Length(localiza.retorno[1]) do
       begin
          codigo := copy(localiza.retorno[1], SomaNivel, VetorMascara[nivelSelecao]);
          SomaNivel := SomaNivel + VetorMascara[nivelSelecao];
          arvore.Selected := arvore.Selected.GetNext;
          while TClassificacao(arvore.Selected.Data).CodigoRed <> Codigo  do
            arvore.Selected := arvore.Selected.GetNextChild(arvore.selected);
          inc(NivelSelecao);
       end;
       CarregaServico(VetorMascara,arvore.selected.Level,TClassificacao(arvore.selected.Data).Codigo,arvore.selected);
       arvore.Selected := arvore.Selected.GetNext;
       while TClassificacao(arvore.Selected.Data).Sequencial <> localiza.retorno[0]  do
         arvore.Selected := arvore.Selected.GetNextChild(arvore.selected);
   end;
   listar := true;
   ArvoreChange(sender,arvore.Selected);
   self.ActiveControl := arvore;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                             eventos da classificacao
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{******Desmonata a mascara pardão para a configuração das classificações*******}
function TFServicos.DesmontaMascara(var Vetor : array of byte; mascara:string):byte;
var
  x, posicao:byte;
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

{********************* cadastra uma nova classificacao ************************}
procedure TFServicos.CadastraClassificacao;
var
  VpfDado : TClassificacao;
  VpfDescricao : string;
begin
  if (QtdNiveis <= Arvore.Selected.Level) then  //acabou os niveis para incluir a nova classificacao
  begin
    Erro(CT_FimInclusaoClassificacao);
    abort;
  end;

  VpfDado := TClassificacao.Create;
  VpfDado.Codigo := TClassificacao(TTreeNode(arvore.Selected).Data).Codigo; // envia o codigo pai para insercao;
  FNovaClassificacao := TFNovaClassificacao.CriarSDI(application,'', Fprincipal.VerificaPermisao('FNovaClassificacao'));

  if FNovaClassificacao.Inseri(VpfDado, VpfDescricao, VetorMascara[Arvore.Selected.Level+1], 'S') then
  begin
    VpfDado.tipo := 'CL';
    VpfDado.PathFoto := '';
    Arvore.Items.AddChildObject( TTreeNode(arvore.Selected),Vpfdado.codigoRed + ' - ' + VpfDescricao, VpfDado);
    arvore.OnChange(self,arvore.selected);
    Arvore.Update;
  end
  else
    Vpfdado.free;
end;

{****************** limpa a arvore e cria o no inicial ************************}
function TFServicos.LimpaArvore : TTreeNode;
var
  VpfDado : TClassificacao;
begin
  Arvore.Items.Clear;
  VpfDado:= TClassificacao.Create;
  VpfDado.codigo:='';
  VpfDado.CodigoRed:='';
  VpfDado.Tipo := 'CL';
  result := arvore.Items.AddObject(arvore.Selected, 'Serviços', VpfDado);
  result.ImageIndex:=0;
  result.SelectedIndex:=0;
end;

{************************carrega Classificacao*********************************}
procedure TFServicos.CarregaClassificacao(VpaVetorInfo : array of byte);
var
  VpfNo : TTreeNode;
  Vpfdado : TClassificacao;
  VpfTamanho, nivel : word;
  Vpfcodigo :string;
begin
  VpfNo := LimpaArvore;  // limpa a arvore e retorna o no inicial;
  VprPrimeiroNo := VpfNo;
  VetorNo[0]:= VpfNo;
  Arvore.Update;

  AdicionaSQLAbreTabela(CadClassificacao,'SELECT * FROM CADCLASSIFICACAO '+
                          'WHERE I_COD_EMP = ' + IntToStr(varia.CodigoEmpresa) +
                          ' and c_tip_cla = ''S''' +
                          ' ORDER BY C_COD_CLA ');

  while not(CadClassificacao.EOF) do
  begin
    VpfTamanho := VpaVetorInfo[0];
    nivel := 0;
    while length(CadClassificacao.FieldByName('C_COD_CLA').AsString)<>VpfTamanho do
    begin
      inc(nivel);
      Vpftamanho:= VpfTamanho+VpaVetorInfo[nivel];
    end;

    Vpfcodigo :=CadClassificacao.FieldByName('C_COD_CLA').AsString;

    Vpfdado:= TClassificacao.Create;
    VpfDado.codigo:= CadClassificacao.FieldByName('C_COD_CLA').AsString;
    VpfDado.CodigoRed := copy(Vpfcodigo, (length(Vpfcodigo)-VpaVetorInfo[nivel])+1, VpaVetorInfo[nivel]);
    VpfDado.tipo := 'CL';
    VpfDado.Situacao := true;

    VpfNo :=Arvore.Items.AddChildObject(VetorNo[nivel],VpfDado.CodigoRed+ ' - '+
                                                        CadClassificacao.FieldByName('C_NOM_CLA').AsString, VpfDado);
    VetorNo[nivel+1]:=VpfNo;

    CadClassificacao.Next;
  end;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                         eventos dos servicos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{********************* cadastra um novo servico *******************************}
procedure TFServicos.CadatraServico;
var
  Vpfdado:TClassificacao;
  VpfNo : TTreeNode;
  VpfDescricao, VpfCodServico, VpfCodClassificacao : string;
begin
  if  (arvore.Selected.Level = 0) then  // se estiver no no inicial nao cadastra
  begin
     erro(CT_ClassificacacaoServicoInvalida);
     abort;
  end;
  if TClassificacao(TTreeNode(arvore.Selected).Data).Tipo = 'PA' then  // se estiver selecionado um servico nao cadastra pois nao pode cadastrar um servico dentro de outro
  begin
    erro(CT_ErroInclusaoServico);
    abort;
  end;

  VpfDado := TClassificacao.Create;
  VpfCodClassificacao:= TClassificacao(TTreeNode(Arvore.selected).data).codigo;
  FNovoServico := TFNovoServico.CriarSDI(application,'',FPrincipal.VerificaPermisao('FNovoServico'));

  if FNovoServico.InsereNovoServico(VpfCodClassificacao, VpfCodServico,VpfDescricao, False) then
  begin
     VpfDado.Codigo := VpfCodClassificacao;
     VpfDado.tipo := 'SE';
     VpfDado.Situacao := true;
     Vpfdado.sequencial := VpfCodServico;
     Vpfno:= Arvore.Items.AddChildObject( TTreeNode(arvore.Selected),VpfDado.Sequencial + ' - ' + VpfDescricao, VpfDado);
     Vpfno.ImageIndex := 2;
     Vpfno.SelectedIndex := 2;
     arvore.OnChange(Self,arvore.selected);
     Arvore.Update;
  end;
end;


{**************alteração de Classificação ou o servico*************************}
procedure TFServicos.Alterar(Sender: TObject; Alterar : Boolean);
var
  Vpfcodigo, VpfDescricao : string;
begin
  if (arvore.Selected.Level=0) then {não é possível alterar o primeiro item}
    abort;

  if  TClassificacao(TTreeNode(arvore.Selected).Data).Tipo = 'CL' then
  begin
    FNovaClassificacao := TFNovaClassificacao.CriarSDI(application,'',FPrincipal.VerificaPermisao('FNovaClassificacao'));
    if FNovaClassificacao.Alterar(TClassificacao(arvore.Selected.Data).Codigo, TClassificacao(Arvore.Selected.Data).CodigoRed, VpfDescricao, 'S', Alterar) then
    begin
      VpfCodigo := TClassificacao(TTreeNode(Arvore.Selected).Data).CodigoRed;
      arvore.Selected.Text := VpfCodigo + ' - ' + VpfDescricao;
      arvore.OnChange(sender,arvore.selected);
      arvore.Update;
    end;
  end
  else
    if TClassificacao(TTreeNode(arvore.Selected).Data).Tipo = 'SE' then
    begin
      Vpfcodigo := TClassificacao(TTreeNode(arvore.Selected).Data).Sequencial ;
      Vpfdescricao := '';
      FNovoServico := TFNovoServico.CriarSDI(application, '',FPrincipal.VerificaPermisao('FNovoServico'));
      if FNovoServico.AlteraServico(TClassificacao(TTreeNode(arvore.Selected).Data).Codigo, VpfCodigo,VpfDescricao, Alterar) then
        arvore.Selected.Text := VpfCodigo + ' - ' + VpfDescricao;
    end;
end;

{****************** carrega os servicos na arvore *****************************}
procedure TFServicos.CarregaServico(VetorInfo : array of byte; nivel : byte; Codigo : string; NoSelecao : TTreeNode );
var
  No : TTreeNode;
  Dado : TClassificacao;
  VpfAtividade : String;
begin

  if TClassificacao(TTreeNode(NoSelecao).Data).Situacao then
  begin
    if CAtiPro.Checked Then
      VpfAtividade := ' and C_Ati_Ser = ''S'''
    else
      VpfAtividade := '';
    AdicionaSQLAbreTabela(CadServicos,
      ' Select * from CadServico '  +
      ' Where I_COD_EMP = ' + IntToStr(varia.CodigoEmpresa) +
      ' and C_COD_CLA = ''' + codigo + '''' +
       VpfAtividade +
      ' Order by I_Cod_Ser');
    while not CadServicos.EOF do
    begin
      dado:= TClassificacao.Create;
      Dado.Codigo := Codigo;
      Dado.Sequencial := CadServicos.FieldByName('I_COD_SER').AsString;
      Dado.Situacao := true;
      Dado.tipo := 'SE';
      No := Arvore.Items.AddChildObject(NoSelecao, Dado.Sequencial + ' - ' + CadServicos.FieldByName('C_NOM_SER').AsString, Dado);
      VetorNo[nivel+1] := no;
      No.ImageIndex := 2;
      No.SelectedIndex := 2;
      CadServicos.Next;
    end;
    TClassificacao(TTreeNode(NoSelecao).Data).Situacao := False;
  end;
end;

{*****************Exclusão de Classificação e produtos*************************}
procedure TFServicos.Excluir(Sender : TObject);
var
  no : TTreeNode;
begin
  if (arvore.Selected.Level=0) then
      abort;
  no := arvore.Selected;
  listar := false;
  if (Arvore.Selected.HasChildren) then// Nao permite excluir se possui filhos
  begin
    erro(CT_ErroExclusaoClassificaca);
    arvore.Selected := no;
    Listar := true;
    abort;
  end;

  if confirmacao(CT_DeletarItem) then  // verifica se deseja excluir
  begin
    if TClassificacao(TTreeNode(arvore.Selected).Data).Tipo = 'CL' then
    try
      // caso seja uma classificacao
        ExecutaComandoSql(Aux,'DELETE FROM CADCLASSIFICACAO'+
                                 ' WHERE I_COD_EMP = ' + IntToStr(varia.CodigoEmpresa) +
                                 ' and C_COD_CLA='''+ TClassificacao(TTreeNode(arvore.Selected).Data).Codigo+ ''''+
                                 ' and C_Tip_CLA = ''S''');
      TClassificacao(TTreeNode(arvore.selected).Data).Free;
      arvore.items.Delete(arvore.Selected);
    except
      erro(CT_ErroDeletaRegistroPai);
    end;
    // caso seja um serviço
    if TClassificacao(TTreeNode(arvore.Selected).Data).Tipo = 'SE' then
    begin
      try
        ExecutaComandoSql(Aux,' DELETE FROM CADSERVICO WHERE I_COD_EMP = ' + IntToStr(varia.CodigoEmpresa) +
                                 ' and I_COD_SER ='+ TClassificacao(TTreeNode(arvore.Selected).Data).Sequencial);

        TClassificacao(TTreeNode(arvore.selected).Data).Free;
        arvore.items.Delete(arvore.Selected);
      except
        erro(CT_ErroDeletaRegistroPai);
      end;
    end;
    listar := true;
    arvore.OnChange(sender,arvore.selected);
  end;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                             eventos dos botoes
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***************** cadastra uma nova classificacao ****************************}
procedure TFServicos.BClasssificaoClick(Sender: TObject);
begin
  CadastraClassificacao;
end;

{ ***************** altera a mostra entre produtos em atividades ou naum ******}
procedure TFServicos.AtiProClick(Sender: TObject);
begin
  RecarregaLista;
end;

{*************Chamada de alteração de produtos ou classificações***************}
procedure TFServicos.BConsultaClick(Sender: TObject);
begin
  Alterar(sender,false); // Consulta o servico ou a classificacao
end;

{*************Chamada de alteração de produtos ou classificações***************}
procedure TFServicos.BAlterarClick(Sender: TObject);
begin
  Alterar(sender,true);  // chamada de alteração
end;

{***************Chama a rotina para cadastrar um novo produto******************}
procedure TFServicos.BServicosClick(Sender: TObject);
begin
  CadatraServico;
end;

{****************************Fecha o Formulario corrente***********************}
procedure TFServicos.BFecharClick(Sender: TObject);
begin
  Close;
end;

{************Chamada de Exclusão de produtos ou classificações*****************}
procedure TFServicos.BExcluirClick(Sender: TObject);
begin
  Excluir(sender);
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{*********************** recarrega a lista ************************************}
procedure TFServicos.RecarregaLista;
begin
  Listar := false;
  Arvore.Items.Clear;
  Listar := true;
  CarregaClassificacao(VetorMascara);
end;

{************** quando se da um duplo clique na arvore ************************}
procedure TFServicos.ArvoreDblClick(Sender: TObject);
begin
  if TClassificacao(TTreeNode(arvore.Selected).Data).Tipo = 'SE' then
    BAlterar.Click;
end;

{****************** habilita ou nao os botoes ********************************}
procedure TFServicos.Habilita(  Node: TTreeNode );
begin
  if TClassificacao(node.Data).tipo = 'CL' then
  begin
     BAlterar.Enabled := true;
     BExcluir.Enabled := true;
     BConsulta.Enabled := true;
  end;
  if TClassificacao(node.Data).tipo = 'SE' then
  begin
     BAlterar.Enabled := true;
     BExcluir.Enabled := true;
     BConsulta.enabled := true;
  end;
end;


procedure TFServicos.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FServicos.HelpContext);
end;

end.
