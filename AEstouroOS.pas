unit AEstouroOS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Componentes1, ExtCtrls, PainelGradiente, Localizacao, Buttons, StdCtrls,
  Mask, DBCtrls, Tabela, UnOrdemServico, Db, DBTables, Grids, DBGrids, UnProdutos,
  DBKeyViolation, numericos;

type
  TFEstouroOS = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    Label1: TLabel;
    DBEditLocaliza1: TEditLocaliza;
    SpeedButton2: TSpeedButton;
    Label8: TLabel;
    Label2: TLabel;
    DBEditLocaliza2: TEditLocaliza;
    SpeedButton3: TSpeedButton;
    Label9: TLabel;
    Label4: TLabel;
    DBEditLocaliza3: TEditLocaliza;
    SpeedButton4: TSpeedButton;
    Label10: TLabel;
    Localiza: TConsultaPadrao;
    BFechar: TBitBtn;
    BBAjuda: TBitBtn;
    MovEstouro: TQuery;
    DataMovEstouro: TDataSource;
    PanelColor3: TPanelColor;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    Label5: TLabel;
    Label12: TLabel;
    EServico: TEditLocaliza;
    numerico2: Tnumerico;
    GroupBox1: TGroupBox;
    Label32: TLabel;
    SpeedButton10: TSpeedButton;
    Label38: TLabel;
    Label20: TLabel;
    Label11: TLabel;
    eproduto: TEditLocaliza;
    ComboBoxColor1: TComboBoxColor;
    numerico1: Tnumerico;
    Grade: TGridIndice;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure eprodutoSelect(Sender: TObject);
    procedure EServicoSelect(Sender: TObject);
    procedure EServicoRetorno(Retorno1, Retorno2: String);
    procedure Button1Click(Sender: TObject);
    procedure BFecharClick(Sender: TObject);
    procedure DBEditLocaliza1Retorno(Retorno1, Retorno2: String);
    procedure eprodutoRetorno(Retorno1, Retorno2: String);
    procedure BitBtn2Click(Sender: TObject);
    procedure eprodutoChange(Sender: TObject);
  private
    UnOS : TFuncoesOrdemServico;
    CodEmpresa : string;
    SeqPro :  Integer;
    UnProduto : TFuncoesProduto;
    procedure AdicionaEstouro;
  public
    { Public declarations }
  end;

var
  FEstouroOS: TFEstouroOS;

implementation

uses APrincipal, constantes;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFEstouroOS.FormCreate(Sender: TObject);
begin
  UnOS := TFuncoesOrdemServico.Criar(self,FPrincipal.BaseDados);
  UnProduto := TFuncoesProduto.Criar(self,FPrincipal.BaseDados);
  CodEmpresa := '';
  Eproduto.AInfo.CampoCodigo := Varia.CodigoProduto;  // caso codigo pro ou codigo de barras
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFEstouroOS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 UnOS.Free;
 UnProduto.Free;
 Action := CaFree;
end;

procedure TFEstouroOS.AdicionaEstouro;
var
  Qdade : double;
  vpaSeqProduto : string;
begin
  if SeqPro = 0 then
    vpaSeqProduto := ''
  else
    vpaSeqProduto := IntToStr(SeqPro);

  if numerico1.AValor <> 0 then
    qdade := numerico1.AValor
  else
   qdade := numerico2.AValor;

  UnOS.AdicionaEstouro( DBEditLocaliza1.Text, DBEditLocaliza2.text,
                        DBEditLocaliza3.text,
                        vpaSeqProduto, EServico.Text,CodEmpresa, eproduto.text, ComboBoxColor1.Text,
                        qdade );

end;

procedure TFEstouroOS.eprodutoSelect(Sender: TObject);
begin
  eproduto.ASelectValida.Clear;
  eproduto.ASelectValida.add(  ' Select Pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
                                    ' pro.I_SEQ_PRO, mov.C_COD_BAR, ' +
                                    ' From cadprodutos as pro, ' +
                                    ' MovQdadeProduto as mov ' +
                                    ' Where pro.I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                                    ' and ' + varia.CodigoProduto + ' = ''@''' +
                                    ' and pro.C_KIT_PRO = ''P'' ' +
                                    ' and pro.I_seq_pro = Mov.I_seq_pro ' +
                                    ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil) +
                                    ' and pro.i_seq_pro = tab.i_seq_pro ' );
  eproduto.ASelectLocaliza.Clear;
  eproduto.ASelectLocaliza.add(' Select pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
                                    ' pro.I_SEQ_PRO, mov.C_COD_BAR ' +
                                    ' from cadprodutos as pro, ' +
                                    ' MovQdadeProduto as mov ' +
                                    ' Where pro.I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                                    ' and pro.c_nom_pro like ''@%''' +
                                    ' and pro.C_KIT_PRO = ''P'' ' +
                                    ' and pro.I_seq_pro = Mov.I_seq_pro ' +
                                    ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil) +
                                    ' and pro.i_seq_pro = tab.i_seq_pro ' +
                                    ' order by c_nom_pro asc');
end;

procedure TFEstouroOS.EServicoSelect(Sender: TObject);
begin
  EServico.ASelectValida.Clear;
  EServico.ASelectValida.Add( ' Select * from CadServico ' +
                                 ' Where i_cod_ser = @ ' +
                                 ' and I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) );
  EServico.ASelectLocaliza.Clear;
  EServico.ASelectLocaliza.Add( ' Select * from CadServico ' +
                                   ' Where c_nom_ser like ''@%'' ' +
                                   ' and I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                                   ' order by c_nom_ser' );
end;

procedure TFEstouroOS.EServicoRetorno(Retorno1, Retorno2: String);
begin
  CodEmpresa := '';
  if Retorno1 <> '' then
  begin
    CodEmpresa := Retorno1;
    eproduto.Text := '';
    Label38.Caption := '';
    ComboBoxColor1.text := '';
    numerico1.AValor := 0;
 end;
end;

procedure TFEstouroOS.Button1Click(Sender: TObject);
begin
  AdicionaEstouro;
  DBEditLocaliza1Retorno('','');
end;

procedure TFEstouroOS.BFecharClick(Sender: TObject);
begin
 self.close;
end;

procedure TFEstouroOS.DBEditLocaliza1Retorno(Retorno1, Retorno2: String);
var
  Conta : integer;
begin
  UnOS.LocalizaEstouro(MovEstouro, DBEditLocaliza1.text, DBEditLocaliza2.text,
                                   DBEditLocaliza3.text);
  Grade.Columns[1].Visible := true;
  Grade.Columns[2].Visible := not (varia.QuantidadeTipoOS < 2);
  Grade.Columns[3].Visible := not (varia.QuantidadeTipoOS < 3);

  if DBEditLocaliza1.text = '' then
    Grade.Columns[1].Visible := false;
  if DBEditLocaliza2.text = '' then
    Grade.Columns[2].Visible := false;
  if DBEditLocaliza3.text = '' then
    Grade.Columns[3].Visible := false;
end;

procedure TFEstouroOS.eprodutoRetorno(Retorno1, Retorno2: String);
begin
  if retorno1 <> '' then
  begin
    SeqPro := strToInt(retorno1);
    ComboBoxColor1.Items := UnProduto.validaUnidade.UnidadesParentes(retorno2);
    ComboBoxColor1.Text := retorno2;
    EServico.Text := '';
    Label5.Caption := '';
    numerico2.AValor := 0;
  end;
end;

procedure TFEstouroOS.BitBtn2Click(Sender: TObject);
begin
  unos.ExcluiItemEstouroOS(MovEstouro.fieldByname('i_seq_mov').AsInteger);
  DBEditLocaliza1Retorno('','');
end;

procedure TFEstouroOS.eprodutoChange(Sender: TObject);
begin
  if (DBEditLocaliza1.text <> '') and
  (( eproduto.text <> '') and (numerico1.AValor <> 0) and (ComboBoxColor1.text <> '')) or
  (( EServico.text <> '') and (numerico2.AValor <> 0) ) then
     BitBtn1.Enabled := true
  else
     BitBtn1.Enabled := false;
end;

Initialization
 RegisterClasses([TFEstouroOS]);
end.
