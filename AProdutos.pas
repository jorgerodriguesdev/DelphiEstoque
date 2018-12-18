unit AProdutos;
{          Autor: Sergio Luiz Censi
    Data Criação: 06/04/1999;
          Função: Cadastrar um novo
  Data Alteração: 06/04/1999;
Motivo alteração: - Adicionado os comentários e o blocos nas rotinas, e realizado
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, DBTables, Db, DBCtrls, Grids, DBGrids,
  Buttons, Menus, formularios, PainelGradiente,
  Tabela, Componentes1, LabelCorMove, Localizacao, Mask,
  EditorImagem, ImgList, numericos, UnProdutos, UnClassificacao;

type
  TFprodutos = class(TFormularioPermissao)
    Splitter1: TSplitter;
    CadClassificacao: TQuery;
    Imagens: TImageList;
    CadProdutos: TQuery;
    PainelGradiente1: TPainelGradiente;
    PanelColor2: TPanelColor;
    Arvore: TTreeView;
    PanelColor4: TPanelColor;
    BAlterar: TBitBtn;
    BExcluir: TBitBtn;
    BProdutos: TBitBtn;
    Localiza: TConsultaPadrao;
    BitBtn2: TBitBtn;
    VisualizadorImagem1: TVisualizadorImagem;
    PanelColor1: TPanelColor;
    BFechar: TBitBtn;
    BitBtn4: TBitBtn;
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
    PanelColor3: TPanelColor;
    AtiPro: TCheckBox;
    Aux: TQuery;
    PanelColor6: TPanelColor;
    Shape2: TShape;
    VerFoto: TCheckBox;
    Esticar: TCheckBox;
    Panel1: TPanel;
    Foto: TImage;
    BitBtn5: TBitBtn;
    BBAjuda: TBitBtn;
    EProdutos: TEditLocaliza;
    BitBtn1: TSpeedButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ArvoreExpanded(Sender: TObject; Node: TTreeNode);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ArvoreChange(Sender: TObject; Node: TTreeNode);
    procedure ArvoreCollapsed(Sender: TObject; Node: TTreeNode);
    procedure Alterar(Sender: TObject;Alterar : Boolean);
    Procedure Excluir(Sender : TObject);
    procedure BAlterarClick(Sender: TObject);
    procedure BExcluirClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BProdutosClick(Sender: TObject);
    procedure BFecharClick(Sender: TObject);
    procedure FotoDblClick(Sender: TObject);
    procedure EsticarClick(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure ArvoreDblClick(Sender: TObject);
    procedure VerFotoClick(Sender: TObject);
    procedure ArvoreKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ArvoreKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AtiProClick(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
    procedure EProdutosSelect(Sender: TObject);
    procedure EProdutosRetorno(Retorno1, Retorno2: String);
  private
    UnProduto : TFuncoesProduto;
    listar : boolean;
    QdadeNiveis : Byte;
    VetorMascara : array [1..6] of byte;
    VetorNo: array [0..6] of TTreeNode;
    PrimeiroNo : TTreeNode;
    CifraInicial : string;
    function DesmontaMascara(var Vetor : array of byte; mascara:string):byte;
    procedure CarregaClassificacao(VetorInfo : array of byte);
    procedure CarregaProduto(VetorInfo : array of byte; nivel : byte; Codigo : string; NoSelecao : TTreeNode);
    procedure CarregaKit(nivel : byte; SeqPro : string; NoSelecao : TTreeNode );
    procedure CarregaComposto(nivel : byte; SeqPro : string; NoSelecao : TTreeNode );
    procedure Habilita(  Node: TTreeNode );
    function  CalculaEstoque( CodigoProduto : string ) : double;
    procedure RecarregaLista;
    procedure LocalizaProduto(SeqPro, CodClassificacao : string );
  public
    { Public declarations }
  end;

var
  Fprodutos: TFprodutos;

implementation

uses APrincipal, ANovoProduto, fundata, constantes,funObjeto, constMsg, funstring,
     ANovaClassificacao;

{$R *.DFM}


{***********************No fechamento do Formulario****************************}
procedure TFprodutos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   CurrencyString := CifraInicial;
   UnProduto.Destroy;
   CadProdutos.Close;
   CadClassificacao.Close;
   Action := CaFree;
end;

{************************Quanto criado novo formulario*************************}
procedure TFprodutos.FormCreate(Sender: TObject);
begin
  CifraInicial := CurrencyString;
  Self.HelpFile := Varia.PathHelp + 'MPONTOLOJA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
  UnProduto := TFuncoesProduto.criar(self,FPrincipal.BaseDados);
  FillChar(VetorMascara, SizeOf(VetorMascara), 0);
  Listar := true;
  EProdutos.AInfo.CampoCodigo := Varia.CodigoProduto;  // caso codigo pro ou codigo de barras

  if not UnProduto.VerificaMascaraClaPro then
    PanelColor4.Enabled := false;

  CadProdutos.open;

  QdadeNiveis := DesmontaMascara(VetorMascara, varia.mascaraCLA);  // busca em constantes

  CarregaClassificacao(VetorMascara);

end;



{******Desmonata a mascara pardão para a configuração das classificações*******}
function TFprodutos.DesmontaMascara(var Vetor : array of byte; mascara:string):byte;
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
procedure TFprodutos.CarregaClassificacao(VetorInfo : array of byte);
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
  Dado.Tipo := 'CL';
  no := arvore.Items.AddObject(arvore.Selected, 'Produtos', Dado);
  PrimeiroNo := no;
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
    while length(CadClassificacao.FieldByName('C_COD_CLA').AsString)<>tamanho do
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
procedure TFprodutos.CarregaProduto(VetorInfo : array of byte; nivel : byte; Codigo : string; NoSelecao : TTreeNode );
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
                         ' pro.c_kit_pro, pro.c_pro_com ' +
                         ' from CadProdutos as pro '  +
                         ' ,MovQdadeProduto as mov, CadMoedas as moe ' +
                         ' where PRO.I_COD_EMP = ' + IntToStr(varia.CodigoEmpresa) +
                         ' and PRO.C_COD_CLA = ''' + codigo + '''');

     if AtiPro.Checked then
        CadProdutos.sql.add(' and PRO.C_ATI_PRO = ''S''');

      CadProdutos.sql.add(' and pro.I_seq_pro = mov.i_seq_pro ' +
                          ' and mov.i_emp_fil = ' + IntTostr(varia.CodigoEmpFil) +
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
       Dado.moeda := CadProdutos.FieldByName('C_CIF_MOE').AsString;

       if CadProdutos.FieldByName('C_KIT_PRO').AsString = 'K' then
         dado.Com_kit := 'K'  //kit
       else
         if CadProdutos.FieldByName('C_PRO_COM').AsString = 'S' then
           dado.Com_kit := 'C'; // composto

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


{********carregaKit : serve para carregar o TreeView com as informações
                    da base que estão na tabela Produtos.**********************}
procedure TFprodutos.CarregaKit(nivel : byte; SeqPro : string; NoSelecao : TTreeNode );
var
  no : TTreeNode;
  dado : TClassificacao;
  codigo : string;
begin

if TClassificacao(TTreeNode(NoSelecao).Data).Situacao then
begin
     CadProdutos.Close;
     CadProdutos.sql.Clear;
     CadProdutos.sql.add(' Select ' +
                         ' pro.i_seq_pro, pro.c_cod_cla, pro.c_ati_pro, ' +
                         ' pro.c_cod_pro, pro.c_pat_fot, pro.c_nom_pro, ' +
                         ' pro.c_kit_pro, pro.c_pro_com ' +
                         ' from MovKit as kit, CadProdutos as pro ,MovQdadeProduto as mov ' +
                         ' where Kit.I_PRO_KIT = ' + SeqPro +
                         ' and Kit.I_COD_EMP = ' + IntToStr(varia.CodigoEmpresa) +
                         ' and kit.I_seq_pro = pro.I_seq_pro ' +
                         ' and PRO.I_COD_EMP = ' + IntToStr(varia.CodigoEmpresa) +
                         ' and pro.I_seq_pro = mov.i_seq_pro ' +
                         ' and mov.i_emp_fil = ' + IntTostr(varia.CodigoEmpFil));
     CadProdutos.sql.add(' Order by C_COD_PRO');

     CadProdutos.open;
     CadProdutos.First;

     while not CadProdutos.EOF do
     begin
       dado:= TClassificacao.Create;
       Dado.codigo := CadProdutos.FieldByName('C_COD_PRO').AsString;
       Dado.CodigoRed := '';
       Dado.Situacao := true;
       Dado.tipo := 'K';
       Dado.PathFoto := CadProdutos.FieldByName('C_PAT_FOT').AsString;
       Dado.Sequencial := CadProdutos.FieldByName('I_SEQ_PRO').AsString;
       Dado.moeda := 'R$';
       Dado.Com_kit := 'KC';

       codigo := CadProdutos.FieldByName('C_COD_PRO').AsString;

       if config.VerCodigoProdutos then  // configura se mostra ou naum o codigo do produto..
          no := Arvore.Items.AddChildObject(NoSelecao, codigo + ' - ' +
                                            CadProdutos.FieldByName('C_NOM_PRO').AsString, Dado)
       else
          no := Arvore.Items.AddChildObject(NoSelecao,
                              CadProdutos.FieldByName('C_NOM_PRO').AsString, Dado);

       VetorNo[nivel+1] := no;
       no.ImageIndex := 4;
       no.SelectedIndex := 4;
       CadProdutos.Next;
     end;

  TClassificacao(TTreeNode(NoSelecao).Data).Situacao := false;
end;
end;

{********carregaKit : serve para carregar o TreeView com as informações
                    da base que estão na tabela Produtos.**********************}
procedure TFprodutos.CarregaComposto(nivel : byte; SeqPro : string; NoSelecao : TTreeNode );
var
  no : TTreeNode;
  dado : TClassificacao;
  codigo : string;
begin

if TClassificacao(TTreeNode(NoSelecao).Data).Situacao then
begin
     CadProdutos.Close;
     CadProdutos.sql.Clear;
     CadProdutos.sql.add(' Select ' +
                         ' pro.i_seq_pro, pro.c_cod_cla, pro.c_ati_pro, ' +
                         ' pro.c_cod_pro, pro.c_pat_fot, pro.c_nom_pro, ' +
                         ' pro.c_kit_pro, pro.c_pro_com ' +
                         ' from MovcomposicaoProduto as Com, CadProdutos as pro ,MovQdadeProduto as mov ' +
                         ' where Com.I_PRO_COM = ' + SeqPro +
                         ' and Com.I_COD_EMP = ' + IntToStr(varia.CodigoEmpresa) +
                         ' and Com.I_seq_pro = pro.I_seq_pro ' +
                         ' and PRO.I_COD_EMP = ' + IntToStr(varia.CodigoEmpresa) +
                         ' and pro.I_seq_pro = mov.i_seq_pro ' +
                         ' and mov.i_emp_fil = ' + IntTostr(varia.CodigoEmpFil));
     CadProdutos.sql.add(' Order by C_COD_PRO');

     CadProdutos.open;
     CadProdutos.First;

     while not CadProdutos.EOF do
     begin
       dado:= TClassificacao.Create;
       Dado.codigo := CadProdutos.FieldByName('C_COD_PRO').AsString;
       Dado.CodigoRed := '';
       Dado.Situacao := true;
       Dado.tipo := 'K';
       Dado.PathFoto := CadProdutos.FieldByName('C_PAT_FOT').AsString;
       Dado.Sequencial := CadProdutos.FieldByName('I_SEQ_PRO').AsString;
       Dado.moeda := 'R$';
       Dado.Com_kit := 'KC';

       codigo := CadProdutos.FieldByName('C_COD_PRO').AsString;

       if config.VerCodigoProdutos then  // configura se mostra ou naum o codigo do produto..
          no := Arvore.Items.AddChildObject(NoSelecao, codigo + ' - ' +
                                            CadProdutos.FieldByName('C_NOM_PRO').AsString, Dado)
       else
          no := Arvore.Items.AddChildObject(NoSelecao,
                              CadProdutos.FieldByName('C_NOM_PRO').AsString, Dado);

       VetorNo[nivel+1] := no;
       no.ImageIndex := 4;
       no.SelectedIndex := 4;
       CadProdutos.Next;
     end;

  TClassificacao(TTreeNode(NoSelecao).Data).Situacao := false;
end;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
         Efetua as atividade basica nas tebelas de Produtos e Classificacao
                    Inserção,  Alteração e Exclusão

)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{******************************************************************************
            Inserção de Classificação e Produtos
  ListaDblClick :  um duplo clique na lista da direita causa uma inserçao
               se estiver posicionado na primeira ou segunda posição da lista
****************************************************************************** }
procedure TFprodutos.BitBtn2Click(Sender: TObject);
var
  dado:TClassificacao;
  desc : string;
begin
  if (QdadeNiveis <= arvore.Selected.Level) then
  begin
    erro(CT_FimInclusaoClassificacao);
    abort;
  end;

    Dado := TClassificacao.Create;
    Dado.Codigo := TClassificacao(TTreeNode(arvore.Selected).Data).Codigo; // envia o codigo pai para insercao;

    FNovaClassificacao := TFNovaClassificacao.CriarSDI(application,'', Fprincipal.VerificaPermisao('FNovaClassificacao'));
    if (FNovaClassificacao.Inseri(dado,desc,VetorMascara[arvore.Selected.Level+1], 'P')) then
    begin

      Dado.tipo := 'CL';
      Dado.Situacao := true;
      Dado.PathFoto := '';
      Arvore.Items.AddChildObject( TTreeNode(arvore.Selected),dado.codigoRed +
                                  ' - ' + Desc, Dado);
      arvore.OnChange(sender,arvore.selected);
      Arvore.Update;
    end;
end;

{***************Chama a rotina para cadastrar um novo produto******************}
procedure TFprodutos.BProdutosClick(Sender: TObject);
var
  dado:TClassificacao;
  no : TTreeNode;
  desc, codigo, Path, kit, cifraoMoeda, sequencial : string;
begin
  if  (arvore.Selected.Level = 0) then
  begin
     erro(CT_ClassificacacaoProdutoInvalida);
     abort;
  end;

    if TClassificacao(TTreeNode(arvore.Selected).Data).Tipo = 'PA' then
    begin
      erro(CT_ErroInclusaoProduto);
      abort;
    end;

    Dado := TClassificacao.Create;
    codigo:= TClassificacao(TTreeNode(Arvore.selected).data).codigo;

    FNovoProduto := TFNovoProduto.CriarSDI(application,'',FPrincipal.VerificaPermisao('FNovoProduto'));
    if (FNovoProduto.EntraNovoProduto( 1, codigo, sequencial, desc, Path, kit, cifraoMoeda )) then
    begin
       Dado.Codigo := codigo;
       Dado.tipo := 'PA';
       Dado.Situacao := true;
       Dado.PathFoto := Path;
       dado.moeda := cifraoMoeda;
       dado.sequencial := sequencial;

        if config.VerCodigoProdutos then  // configura se mostra ou naum o codigo do produto..
            no:= Arvore.Items.AddChildObject( TTreeNode(arvore.Selected),Dado.codigo + ' - ' + Desc, Dado)
        else
            no:= Arvore.Items.AddChildObject( TTreeNode(arvore.Selected),Desc, Dado);

       if kit = 'P' then
       begin
          no.ImageIndex := 2;
          no.SelectedIndex := 2;
       end
       else
       begin
          no.ImageIndex := 3;
          no.SelectedIndex := 3;
       end;

       arvore.OnChange(sender,arvore.selected);
       Arvore.Update;
    end;
    Fprodutos.Arvore.SetFocus;
end;



{****************alteração de Classificação e produtos*************************}
procedure TFprodutos.Alterar(Sender: TObject; Alterar : Boolean);
var
  codigo, desc, Path, kit, cifraoMoeda, sequencial : string;
  funcao : Integer;
begin
  if (arvore.Selected.Level=0) then {não dá para alterar o primeiro item}
    abort;
   if  TClassificacao(TTreeNode(arvore.Selected).Data).Tipo = 'CL' then
   begin
          FNovaClassificacao := TFNovaClassificacao.CriarSDI(application,'',FPrincipal.VerificaPermisao('FNovaClassificacao'));
         if FNovaClassificacao.Alterar(TClassificacao(arvore.Selected.Data).Codigo, TClassificacao(Arvore.Selected.Data).CodigoRed, desc, 'P', Alterar) then
         begin
           codigo := TClassificacao(TTreeNode(Arvore.Selected).Data).CodigoRed;
           arvore.Selected.Text := codigo + ' - ' + desc;
           arvore.OnChange(sender,arvore.selected);
           arvore.Update;
         end;
   end
   else
     if TClassificacao(TTreeNode(arvore.Selected).Data).Tipo = 'PA' then
     begin
          codigo := TClassificacao(TTreeNode(arvore.Selected).Data).Sequencial;
          desc := '';
          if alterar Then
             funcao := 2
          else
             Funcao := 3;
          FNovoProduto := TFNovoProduto.CriarSDI(application, '',FPrincipal.VerificaPermisao('FNovoProduto'));
          if (FNovoProduto.EntraNovoProduto(funcao, codigo, sequencial, desc, Path, kit, cifraoMoeda )) then
          begin
             TClassificacao(arvore.Selected.Data).PathFoto := path;
             if config.VerCodigoProdutos then  // configura se mostra ou naum o codigo do produto..
                arvore.Selected.Text := codigo+ ' - '+desc
             else
                arvore.Selected.Text := desc;
             arvore.OnChange(sender,arvore.selected);
          end;
     end;
end;

{*****************Exclusão de Classificação e produtos*************************}
procedure TFprodutos.Excluir(Sender : TObject);
var
no : TTreeNode;
ContaReg : Integer;
begin
   if (arvore.Selected.Level=0) then
       abort;

   no := arvore.Selected;
   listar := false;

   if (Arvore.Selected.HasChildren) then
     begin
       erro(CT_ErroExclusaoClassificaca);
       arvore.Selected := no;
       Listar := true;
       abort;
   end;


   if confirmacao(CT_DeletarItem) then
   begin
    try
       // caso seja uma classificacao
       if TClassificacao(TTreeNode(arvore.Selected).Data).Tipo = 'CL' then
       begin
         CadClassificacao.Close;
         CadClassificacao.SQL.Clear;
         CadClassificacao.SQL.Add('DELETE FROM CADCLASSIFICACAO WHERE I_COD_EMP = ' + IntToStr(varia.CodigoEmpresa) +
                                  ' and C_COD_CLA='''+ TClassificacao(TTreeNode(arvore.Selected).Data).Codigo+''''+
                                  ' and C_Tip_Cla = ''P''');
         CadClassificacao.ExecSql;
         CadClassificacao.Close;

         TClassificacao(TTreeNode(arvore.selected).Data).Free;
         arvore.items.Delete(arvore.Selected);
       end;

       // caso seja um produto
       if TClassificacao(TTreeNode(arvore.Selected).Data).Tipo = 'PA' then
       begin

           UnProduto.LocalizaEstoqueProduto(Aux,StrToInt(TClassificacao(TTreeNode(arvore.Selected).Data).Sequencial));

           ContaReg := 0;
           while not Aux.Eof do
           begin
             Inc(ContaReg);
             Aux.Next;
             if ContaReg > 3 then
               Break;
           end;

           if ContaReg <= 1 then
           begin

             UnProduto.EstornaEstoque( Aux.fieldByName('I_LAN_EST').AsInteger, varia.CodigoEmpFil);

             CadProdutos.Close;
             CadProdutos.SQL.Clear;
             CadProdutos.SQL.Add(' DELETE FROM MOVSUMARIZAESTOQUE WHERE ' +
                                 ' I_SEQ_PRO = ' + TClassificacao(TTreeNode(arvore.Selected).Data).Sequencial +
                                 ' AND I_EMP_FIL = ' + IntToStr(Varia.CodigoEmpFil) );
             CadProdutos.ExecSql;

             CadProdutos.Close;
             CadProdutos.SQL.Clear;
             CadProdutos.SQL.Add(' DELETE FROM MOVQDADEPRODUTO WHERE ' +
                                 ' I_SEQ_PRO = ' + TClassificacao(TTreeNode(arvore.Selected).Data).Sequencial );
             CadProdutos.ExecSql;

             CadProdutos.SQL.Clear;
             CadProdutos.SQL.Add(' DELETE FROM MOVTABELAPRECO WHERE ' +
                                 ' I_SEQ_PRO = ' + TClassificacao(TTreeNode(arvore.Selected).Data).Sequencial );
             CadProdutos.ExecSql;

             CadProdutos.Close;
             CadProdutos.SQL.Clear;
             CadProdutos.SQL.Add(' DELETE FROM CADPRODUTOS WHERE ' +
                                 ' I_SEQ_PRO = ' + TClassificacao(TTreeNode(arvore.Selected).Data).Sequencial );
             CadProdutos.ExecSql;
             CadProdutos.Close;

             TClassificacao(TTreeNode(arvore.selected).Data).Free;
             arvore.items.Delete(arvore.Selected);
           end
           else
             erro(CT_ErroDeletaRegistroPai);
       end;
      except
        erro(CT_ErroDeletaRegistroPai);
      end;
    end;
   listar := true;
   arvore.OnChange(sender,arvore.selected);
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                           Chamadas diversas dos Tree
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{*****cada deslocamento no TreeView causa uma mudança na lista da direita******}
procedure TFprodutos.ArvoreChange(Sender: TObject; Node: TTreeNode);
begin
habilita(node);
if listar then
begin
   if TClassificacao(TTreeNode(node).Data).tipo = 'CL' then
   begin
      carregaProduto(VetorMascara,node.Level,TClassificacao(TTreeNode(node).Data).Codigo,node);
      Foto.Picture := nil;
   end
   else
   if (TClassificacao(TTreeNode(node).Data).tipo = 'PA') Then //and (paginas.ActivePage = caracteristica) then
   begin
      try
         if (VerFoto.Checked) and (TClassificacao(TTreeNode(node).Data).PathFoto <> '') then
            Foto.Picture.LoadFromFile(varia.DriveFoto + TClassificacao(TTreeNode(node).Data).PathFoto)
         else
            Foto.Picture := nil;

         if TClassificacao(TTreeNode(node).Data).Com_kit = 'K' then
           CarregaKit(node.Level,TClassificacao(TTreeNode(node).Data).Sequencial,node)
         else
           if TClassificacao(TTreeNode(node).Data).Com_kit = 'C' then
             CarregaComposto(node.Level,TClassificacao(TTreeNode(node).Data).Sequencial,node);
      except
      end;
   end;
 arvore.Update;
end;
end;

{ *******************Cada vez que expandir um no*******************************}
procedure TFprodutos.ArvoreExpanded(Sender: TObject; Node: TTreeNode);
begin
   carregaProduto(VetorMascara,node.Level,TClassificacao(TTreeNode(node).Data).Codigo,node);
   if TClassificacao(TTreeNode(node).Data).tipo = 'CL' then
   begin
      node.SelectedIndex:=1;
      node.ImageIndex:=1;
   end;
end;

{********************Cada vez que voltar a expanção de um no*******************}
procedure TFprodutos.ArvoreCollapsed(Sender: TObject; Node: TTreeNode);
begin
   if TClassificacao(TTreeNode(node).Data).tipo = 'CL' then
   begin
     node.SelectedIndex:=0;
     node.ImageIndex:=0;
   end;
end;

{*************Chamada de alteração de produtos ou classificações***************}
procedure TFprodutos.BAlterarClick(Sender: TObject);
begin
   alterar(sender,true);  // chamnada de alteração
end;

{************Chamada de Exclusão de produtos ou classificações*****************}
procedure TFprodutos.BExcluirClick(Sender: TObject);
begin
   Excluir(sender);
end;

{ **************** se presionar a setas naum atualiza movimentos ************ }
procedure TFprodutos.ArvoreKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key in[37..40]  then
   listar := false;
end;

{ ************ apos soltar setas atualiza movimentos ************************ }
procedure TFprodutos.ArvoreKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
listar := true;
ArvoreChange(sender,arvore.Selected);
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
              Chamadas diversas para visualizar dados dos produtos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{ ************* calcula o estoque dos kits ******************************** }
function TFprodutos.CalculaEstoque( CodigoProduto : string ) : double;
begin
  aux.close;
  aux.sql.Clear;
  aux.SQL.Add(' select  Min((pro.n_qtd_pro / kit.n_qtd_pro)) as valor ' +
              ' from MovQdadeProduto as pro, Movkit as Kit ' +
              ' where pro.i_seq_pro = kit.i_seq_pro ' +
              ' and kit.i_pro_kit = ' + CodigoProduto );
  aux.open;
  result := aux.fieldByname('valor').AsCurrency;
end;



procedure TFprodutos.Habilita(  Node: TTreeNode );
begin

if TClassificacao(node.Data).tipo = 'CL' then
begin
   BAlterar.Enabled := true;
   BExcluir.Enabled := true;
   BitBtn4.Enabled := true;
end;

if TClassificacao(node.Data).tipo = 'PA' then
begin
   BAlterar.Enabled := true;
   BExcluir.Enabled := true;
   BitBtn4.enabled := true;
end;

if (TClassificacao(node.Data).Com_kit = 'KC') or (config.PermiteAlterarProduto) then
begin
   BAlterar.Enabled := false;
   BExcluir.Enabled := false;
   BitBtn4.enabled := false;
end;

if config.PermiteAlterarProduto then
begin
   BProdutos.Enabled := false;
   BitBtn2.Enabled := false;
end;

end;

{******************** localiza o produto na arvore *************************** }
procedure  TFprodutos.LocalizaProduto(SeqPro, CodClassificacao : string );
var
  codigo, select : string;
  somaNivel,nivelSelecao, laco : integer;
begin
   SomaNivel := 1;
   NivelSelecao := 1;
   listar := false;
   arvore.Selected := PrimeiroNo;
   arvore.Selected.Collapse(true);

   while SomaNivel <= Length(CodClassificacao) do
   begin
      codigo := copy(CodClassificacao, SomaNivel, VetorMascara[nivelSelecao]);
      SomaNivel := SomaNivel + VetorMascara[nivelSelecao];

      arvore.Selected := arvore.Selected.GetNext;
      while TClassificacao(arvore.Selected.Data).CodigoRed <> Codigo  do
        arvore.Selected := arvore.Selected.GetNextChild(arvore.selected);
      inc(NivelSelecao);
   end;

   carregaProduto(VetorMascara,arvore.selected.Level,TClassificacao(arvore.selected.Data).Codigo,arvore.selected);

   for laco := 0 to arvore.Selected.Count - 1 do
    if TClassificacao(arvore.Selected.Item[laco].Data).Sequencial = SeqPro then
    begin
      arvore.Selected := arvore.Selected.Item[laco];
      break;
    end;

   listar := true;
   ArvoreChange(nil,arvore.Selected);
   self.ActiveControl := arvore;
end;
{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************************Fecha o Formulario corrente***********************}
procedure TFprodutos.BFecharClick(Sender: TObject);
begin
   close;
end;

procedure TFprodutos.FotoDblClick(Sender: TObject);
begin
   VisualizadorImagem1.execute(varia.DriveFoto + TClassificacao(arvore.Selected.Data).PathFoto);
end;

procedure TFprodutos.EsticarClick(Sender: TObject);
begin
 Foto.Stretch := esticar.Checked;
end;

procedure TFprodutos.BitBtn4Click(Sender: TObject);
begin
   Alterar(sender,false);
end;

procedure TFprodutos.ArvoreDblClick(Sender: TObject);
begin
   if TClassificacao(TTreeNode(arvore.Selected).Data).Tipo = 'PA'then
      BAlterar.Click;
end;


procedure TFprodutos.VerFotoClick(Sender: TObject);
begin
if VerFoto.Checked then
  ArvoreChange(arvore,arvore.Selected)
else
  Foto.Picture.Bitmap := nil;
end;

{ ***************** altera a mostra entre produtos em atividades ou naum ******}
procedure TFprodutos.AtiProClick(Sender: TObject);
begin
  RecarregaLista;
  EProdutosSelect(nil);
end;


procedure TFprodutos.RecarregaLista;
begin
listar := false;
arvore.Items.Clear;
listar := true;
CarregaClassificacao(VetorMascara);
end;


procedure TFprodutos.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,Fprodutos.HelpContext);
end;

procedure TFprodutos.EProdutosSelect(Sender: TObject);
begin
  EProdutos.ASelectValida.clear;
  EProdutos.ASelectValida.add(' Select * from cadProdutos as pro ' +
                              ' ,MovQdadeProduto as mov ' +
                              ' where ' + varia.CodigoProduto + ' = ''@''');
  EProdutos.ASelectLocaliza.clear;
  EProdutos.ASelectLocaliza.add(' Select * from cadProdutos as pro ' +
                                ' ,MovQdadeProduto as mov ' +
                                ' where c_nom_pro like ''@%''');

  if AtiPro.Checked then
  begin
    EProdutos.ASelectLocaliza.add(' and C_ATI_PRO = ''S''');
    EProdutos.ASelectValida.add(' and C_ATI_PRO = ''S''');
  end;

  EProdutos.ASelectLocaliza.add(' and pro.I_seq_pro = mov.i_seq_pro ' +
                                ' and mov.i_emp_fil = ' + IntTostr(varia.CodigoEmpFil) +
                                ' order by c_nom_pro asc' );
    EProdutos.ASelectValida.add(' and pro.I_seq_pro = mov.i_seq_pro ' +
                                ' and mov.i_emp_fil = ' + IntTostr(varia.CodigoEmpFil));

end;

procedure TFprodutos.EProdutosRetorno(Retorno1, Retorno2: String);
begin
 if Retorno1 <> '' then
   LocalizaProduto(Retorno1,Retorno2);
end;

end.
