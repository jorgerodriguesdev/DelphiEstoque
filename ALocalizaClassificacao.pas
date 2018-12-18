unit ALocalizaClassificacao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, DBTables, Db, DBCtrls, Grids, DBGrids,
  Buttons, Menus, formularios, PainelGradiente,
  Tabela, Componentes1, ImgList;

type
  TFLocalizaClassificacao = class(TFormularioPermissao)
    CadClassificacao: TQuery;
    PainelGradiente: TPainelGradiente;
    PanelColor4: TPanelColor;
    BFechar: TBitBtn;
    ImageList1: TImageList;
    Imagens: TImageList;
    BitBtn1: TBitBtn;
    PanelColor1: TPanelColor;
    Arvore: TTreeView;
    EditColor1: TEditColor;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure ArvoreExpanded(Sender: TObject; Node: TTreeNode);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ArvoreCollapsed(Sender: TObject; Node: TTreeNode);
    procedure BFecharClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
  private
    acao : Boolean;
    VetorMascara : array [1..6] of byte;
    VetorNo: array [0..6] of TTreeNode;
    function DesmontaMascara(var Vetor : array of byte; mascara:string):byte;
    procedure CarregaClassificacao(VetorInfo : array of byte; TipoCla : string);
  public
    function LocalizaClassificacao( var codClassificacao, NomeClassificacao : string; TipoCla : string ) : Boolean;
  end;

type
  TClassificacao = class
    Codigo    : string;
    CodigoRed : string;
    Tipo : string;
    Situacao : boolean;
    Nome : string;
    Sequencial : string;
end;

var
  FLocalizaClassificacao : TFLocalizaClassificacao;

implementation

uses APrincipal, fundata, constantes,funObjeto, constMsg;

{$R *.DFM}

{***********************No fechamento do Formulario****************************}
procedure TFLocalizaClassificacao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   CadClassificacao.Close;
   Action := CaFree;
end;

{************************Quanto criado novo formulario*************************}
procedure TFLocalizaClassificacao.FormCreate(Sender: TObject);
begin
  Arvore.color := EditColor1.Color;
  Self.HelpFile := Varia.PathHelp + 'MPONTOLOJA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
  Arvore.Font.Size := EditColor1.Font.size;
  Arvore.Font.Color := EditColor1.Font.Color;
end;

{ ***** Desmonata a mascara padrão para a configuração das classificações ****** }
function TFLocalizaClassificacao.DesmontaMascara(var Vetor : array of byte; mascara:string):byte;
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
procedure TFLocalizaClassificacao.CarregaClassificacao(VetorInfo : array of byte; TipoCla : string);
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
  if TipoCla = 'P' then
  begin
    No := Arvore.Items.AddObject(Arvore.Selected, 'Produtos', Dado);
    PainelGradiente.Caption := '  Produtos  ';
  end
  else
  begin
    No := Arvore.Items.AddObject(Arvore.Selected, 'Serviços', Dado);
    PainelGradiente.Caption := '  Serviços  ';    
  end;
  VetorNo[0]:=No;
  No.ImageIndex:=0;
  No.SelectedIndex:=0;
  Arvore.Update;

  CadClassificacao.SQL.Clear;
  CadClassificacao.SQL.Add('SELECT * FROM CADCLASSIFICACAO WHERE I_COD_EMP = ' + IntToStr(Varia.CodigoEmpresa) +
                           ' AND C_TIP_CLA = ''' + TipoCla + '''' +
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
    Dado.Nome := CadClassificacao.FieldByName('C_NOM_CLA').AsString;

    no:=Arvore.Items.AddChildObject(VetorNo[nivel], codigo+ ' - '+
                                                        CadClassificacao.FieldByName('C_NOM_CLA').AsString, Dado);
    VetorNo[nivel+1]:=no;
    CadClassificacao.Next;
  end;
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                           Chamadas diversas dos Tree
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}


{ *******************Cada vez que expandir um no*******************************}
procedure TFLocalizaClassificacao.ArvoreExpanded(Sender: TObject; Node: TTreeNode);
begin
  node.SelectedIndex:=1;
  node.ImageIndex:=1;
end;

{********************Cada vez que voltar a expanção de um no*******************}
procedure TFLocalizaClassificacao.ArvoreCollapsed(Sender: TObject; Node: TTreeNode);
begin
  node.SelectedIndex:=0;
  node.ImageIndex:=0;
end;



{****************************Fecha e Ok no Formulario corrente ****************}
procedure TFLocalizaClassificacao.BFecharClick(Sender: TObject);
begin
   acao := true;
   close;
end;

{****************************Fecha e cancela o Formulario corrente ************}
procedure TFLocalizaClassificacao.BitBtn1Click(Sender: TObject);
begin
  acao := false;
  self.close;
end;


function TFLocalizaClassificacao.LocalizaClassificacao( var codClassificacao, NomeClassificacao : string; TipoCla : string ) : Boolean;
begin
  FillChar(VetorMascara, SizeOf(VetorMascara), 0);   // Incializa o array com 0.

  if TipoCla = 'P' then  // produto
    DesmontaMascara(VetorMascara, Varia.MascaraCLA)
  else
    if TipoCla = 'S' then  // SERVICO
      DesmontaMascara(VetorMascara, Varia.MascaraCLAser);
  CarregaClassificacao(VetorMascara, TipoCla);

  self.ShowModal;
  result := acao;

  if TClassificacao(TTreeNode(arvore.Selected).Data).Codigo = '' then
    result := false;

  if acao then
  begin
    codClassificacao := TClassificacao(TTreeNode(arvore.Selected).Data).Codigo;
    NomeClassificacao := TClassificacao(TTreeNode(arvore.Selected).Data).nome;
  end;
end;



procedure TFLocalizaClassificacao.FormShow(Sender: TObject);
begin
  Arvore.SetFocus;
end;

procedure TFLocalizaClassificacao.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FLocalizaClassificacao.HelpContext);
end;

end.
