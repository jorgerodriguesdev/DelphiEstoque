unit AMovInventario;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Componentes1, ExtCtrls, PainelGradiente, StdCtrls, Buttons, Localizacao,
  Mask, numericos, Grids, DBGrids, Tabela, Db, DBTables, UnProdutos;

type
  TFMovInventario = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    MovInv: TQuery;
    DataMovCaixa: TDataSource;
    DBGridColor1: TDBGridColor;
    PanelColor3: TPanelColor;
    Label12: TLabel;
    EditLocaliza1: TEditLocaliza;
    SpeedButton4: TSpeedButton;
    Label11: TLabel;
    Label2: TLabel;
    EQdade: Tnumerico;
    BFechar: TBitBtn;
    BitBtn1: TBitBtn;
    ConsultaPadrao1: TConsultaPadrao;
    Aux: TQuery;
    MovInvI_PRO_FIL: TIntegerField;
    MovInvI_QTD_DIG: TIntegerField;
    MovInvC_COD_UNI: TStringField;
    MovInvC_NOM_PRO: TStringField;
    Label1: TLabel;
    Label3: TLabel;
    NroInventario: TEditLocaliza;
    SpeedButton1: TSpeedButton;
    Label4: TLabel;
    ComboBoxColor1: TComboBoxColor;
    BitBtn2: TBitBtn;
    Aux2: TQuery;
    Automatico: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure EditLocaliza1Select(Sender: TObject);
    procedure EditLocaliza1Retorno(Retorno1, Retorno2: String);
    procedure NroInventarioSelect(Sender: TObject);
    procedure NroInventarioRetorno(Retorno1, Retorno2: String);
    procedure BitBtn2Click(Sender: TObject);
    procedure EditLocaliza1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    SeqProAtual : string;
    UnPro : TFuncoesProduto;
    procedure CarregaMovCaixa;
  public
    { Public declarations }
  end;

var
  FMovInventario: TFMovInventario;

implementation

uses APrincipal, funsql, constantes, constmsg, funnumeros;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFMovInventario.FormCreate(Sender: TObject);
begin
  UnPro := TFuncoesProduto.criar(self,FPrincipal.BaseDados);
  EditLocaliza1.AInfo.CampoCodigo := Varia.CodigoProduto;  // caso codigo pro ou codigo de barras
  AdicionaSQLAbreTabela(Aux, ' select * from movInventario ' );
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFMovInventario.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UnPro.free;
  Action := CaFree;
end;

procedure TFMovInventario.BFecharClick(Sender: TObject);
begin
  self.close;
end;

procedure TFMovInventario.CarregaMovCaixa;
begin
  LimpaSQLTabela(MovInv);
  AdicionaSQLTabela(MovInv, ' select * from movInventario mov, cadprodutos as pro ' +
                            ' where mov.i_emp_fil = ' + IntToStr(varia.CodigoEmpFil)  +
                            ' and i_nro_ive = ' + NroInventario.Text +
                            ' and mov.i_pro_fil = pro.i_seq_pro ' +
                            ' and pro.i_cod_emp = ' + Inttostr(varia.CodigoEmpresa) );
  AbreTabela(MovInv);
end;

procedure TFMovInventario.BitBtn1Click(Sender: TObject);
var
  PesoBal : string;
begin
  if (EditLocaliza1.Text <> '') and ( NroInventario.Text <>'') and ( eqdade.AValor <> 0) then
  begin
    AdicionaSQLAbreTabela(Aux2, ' select * from movInventario  ' +
                                ' where i_emp_fil = ' + IntToStr(varia.CodigoEmpFil)  +
                                ' and i_nro_ive = ' + NroInventario.Text +
                                ' and i_pro_fil = ' + SeqProAtual );
    if Aux2.Eof then
    begin
      Aux.Insert;
      Aux.FieldByName('I_EMP_FIL').AsInteger := varia.CodigoEmpFil;
      Aux.FieldByName('I_NRO_IVE').AsInteger := StrToInt(NroInventario.text);
      Aux.FieldByName('I_PRO_FIL').AsInteger := StrToint(SeqProAtual);
      Aux.FieldByName('C_COD_PRO').AsString := EditLocaliza1.text;
      Aux.FieldByName('D_DAT_IVE').AsDateTime := date;
      Aux.FieldByName('I_QTD_DIG').AsFloat := EQdade.AValor;
      Aux.FieldByName('C_cod_uni').AsString := ComboBoxColor1.text;
      Aux.FieldByName('D_ULT_ALT').AsDateTime:= date;
      Aux.post;
    end
    else
    begin
      Aux2.Edit;
      Aux2.FieldByName('I_QTD_DIG').AsFloat := Aux2.FieldByName('I_QTD_DIG').AsFloat + EQdade.AValor;
      Aux2.post;
   end;
//    ENroCaixa.AValor := ProximoCodigoFilial('movcaixaestoque','i_nro_cai','i_emp_fil',varia.CodigoEmpFil, FPrincipal.BaseDados);
    eqdade.AValor := 1;
    EditLocaliza1.Text := '';
    EditLocaliza1.Atualiza;
    beep;
  end
  else
  begin
    aviso('Valor inválido');
    Eqdade.SetFocus;
  end;
end;

procedure TFMovInventario.EditLocaliza1Select(Sender: TObject);
begin
  EditLocaliza1.ASelectValida.Clear;
  EditLocaliza1.ASelectValida.add(  ' Select Pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
                                    ' pro.I_SEQ_PRO, mov.C_COD_BAR, ' +
                                    ' From cadprodutos as pro, ' +
                                    ' MovQdadeProduto as mov ' +
                                    ' Where pro.I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                                    ' and ' + varia.CodigoProduto + ' = ''@''' +
                                    ' and pro.C_KIT_PRO = ''P'' ' +
                                    ' and pro.I_seq_pro = Mov.I_seq_pro ' +
                                    ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil) );
  EditLocaliza1.Clear;
  EditLocaliza1.ASelectLocaliza.add(' Select pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
                                    ' pro.I_SEQ_PRO, mov.C_COD_BAR ' +
                                    ' from cadprodutos as pro, ' +
                                    ' MovQdadeProduto as mov ' +
                                    ' Where pro.I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                                    ' and pro.c_nom_pro like ''@%''' +
                                    ' and pro.C_KIT_PRO = ''P'' ' +
                                    ' and pro.I_seq_pro = Mov.I_seq_pro ' +
                                    ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil) +
                                    ' order by c_nom_pro asc');
end;

procedure TFMovInventario.EditLocaliza1Retorno(Retorno1, Retorno2: String);
begin
  SeqProAtual := Retorno1;
  if Retorno2 <> '' then
  begin
    ComboBoxColor1.Items := UnPro.ValidaUnidade.UnidadesParentes(Retorno2);
    ComboBoxColor1.ItemIndex := ComboBoxColor1.Items.IndexOf(Retorno2);
  end;
  if Automatico.Checked then
    if EditLocaliza1.Text <> '' then
    begin
      EditLocaliza1.SetFocus;
      BitBtn1.click;
  end;
end;

procedure TFMovInventario.NroInventarioSelect(Sender: TObject);
begin
  NroInventario.ASelectValida.Clear;
  NroInventario.ASelectValida.add(  ' Select * From cadInventario ' +
                                    ' Where I_Emp_Fil = ' + IntToStr(varia.CodigoEmpFil) +
                                    ' and i_nro_ive = @' );
  NroInventario.ASelectLocaliza.Clear;
  NroInventario.ASelectLocaliza.add(' Select * From cadInventario ' +
                                    ' Where I_Emp_Fil = ' + IntToStr(varia.CodigoEmpFil) +
                                    ' and c_nom_ive like ''@%''  ' );
end;

procedure TFMovInventario.NroInventarioRetorno(Retorno1, Retorno2: String);
begin
  if Retorno1 <> '' then
      CarregaMovCaixa;
end;

procedure TFMovInventario.BitBtn2Click(Sender: TObject);
begin
  CarregaMovCaixa;
end;

procedure TFMovInventario.EditLocaliza1KeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if key = 13 then
    ComboBoxColor1.SetFocus;
end;

Initialization
 RegisterClasses([TFMovInventario]);
end.
