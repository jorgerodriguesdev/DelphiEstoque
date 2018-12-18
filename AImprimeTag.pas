unit AImprimeTag;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Mask, numericos, Componentes1, ExtCtrls, PainelGradiente,
  Localizacao, Buttons, Shellapi, Registry;

type
  TFImprimeTag = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    EqdadePro: Tnumerico;
    EditLocaliza1: TEditLocaliza;
    SpeedButton5: TSpeedButton;
    Label6: TLabel;
    ConsultaPadrao1: TConsultaPadrao;
    Label11: TLabel;
    BotaoFechar2: TBitBtn;
    Label1: TLabel;
    BImprime1: TBitBtn;
    BImprime2: TBitBtn;
    numerico1: Tnumerico;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditLocaliza1Select(Sender: TObject);
    procedure BotaoFechar2Click(Sender: TObject);
    procedure BImprime1Click(Sender: TObject);
    procedure EditLocaliza1Retorno(Retorno1, Retorno2: String);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure numerico1Exit(Sender: TObject);
  private
    SeqPro : Integer;
    FecharAposImprimir : Boolean;
    procedure LeArquivo;
  public
    procedure CarregaDados(CodigoPro : string; Qdade : Integer);
  end;

var
  FImprimeTag: TFImprimeTag;

implementation

uses APrincipal, constantes, funstring, constmsg;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFImprimeTag.FormCreate(Sender: TObject);
var
  ini : TRegIniFile;
begin
  ini := TRegIniFile.Create('Software\Systec\Sistema');
  numerico1.AValor := ini.ReadInteger('IMPRESSORA', 'TempTag',15);
  ini.free;

   EditLocaliza1.AInfo.CampoCodigo := Varia.CodigoProduto;
   SeqPro := 0;
   FecharAposImprimir := false;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFImprimeTag.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action := CaFree;
end;


{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFImprimeTag.EditLocaliza1Select(Sender: TObject);
begin
  EditLocaliza1.ASelectValida.Clear;
  EditLocaliza1.ASelectValida.add(  ' Select Pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
                                    ' pro.I_SEQ_PRO, mov.C_COD_BAR, ' +
                                    ' (tab.n_vlr_ven * moe.n_vlr_dia) as n_vlr_ven ' +
                                    ' From cadprodutos as pro, ' +
                                    ' MovQdadeProduto as mov, MovTabelaPreco as Tab, CadMoedas as Moe ' +
                                    ' Where pro.I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                                    ' and ' + varia.CodigoProduto + ' = ''@''' +
                                    ' and pro.C_KIT_PRO = ''P'' ' +
                                    ' and pro.I_seq_pro = Mov.I_seq_pro ' +
                                    ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil) +
                                    ' and tab.i_cod_tab = ' + IntTostr(varia.TabelaPreco) +
                                    ' and tab.i_cod_emp = ' + IntTostr(varia.CodigoEmpresa) +
                                    ' and pro.i_seq_pro = tab.i_seq_pro ' +
                                    ' and tab.i_cod_moe = moe.i_cod_moe' );
  EditLocaliza1.ASelectLocaliza.Clear;
  EditLocaliza1.ASelectLocaliza.add(' Select pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
                                    ' (tab.n_vlr_ven * moe.n_vlr_dia) as n_vlr_ven, ' +
                                    ' pro.I_SEQ_PRO, mov.C_COD_BAR ' +
                                    ' from cadprodutos as pro, ' +
                                    ' MovQdadeProduto as mov, MovTabelaPreco as Tab, CadMoedas as Moe ' +
                                    ' Where pro.I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                                    ' and pro.c_nom_pro like ''@%''' +
                                    ' and pro.C_KIT_PRO = ''P'' ' +
                                    ' and pro.I_seq_pro = Mov.I_seq_pro ' +
                                    ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil) +
                                    ' and tab.i_cod_tab = ' + IntTostr(varia.TabelaPreco) +
                                    ' and tab.i_cod_emp = ' + IntTostr(varia.CodigoEmpresa) +
                                    ' and pro.i_seq_pro = tab.i_seq_pro ' +
                                    ' and tab.i_cod_moe = moe.i_cod_moe' +
                                    ' order by c_nom_pro asc');

end;

procedure TFImprimeTag.BotaoFechar2Click(Sender: TObject);
begin
  self.close;
end;

procedure TFImprimeTag.BImprime1Click(Sender: TObject);
var
  Arquivo : TStringList;
begin
  if (EditLocaliza1.Text <> '') and (EqdadePro. AValor <> 0 ) then
  begin
    Arquivo := TStringList.create;
    Arquivo.Clear;
    Arquivo.add(Inttostr(Varia.CodigoEmpresa));
    Arquivo.add(IntToStr(varia.CodigoEmpFil));
    Arquivo.add(IntToStr(Varia.TabelaPreco));
    Arquivo.add(IntToStr(SeqPro));
    Arquivo.add(Inttostr(Trunc(EQdadePro.avalor)));
    Arquivo.add(varia.MascaraCla);
    Arquivo.add(inttostr(trunc(numerico1.avalor)));
    Arquivo.SaveToFile('ConfigBarra.mod');
    shellExecute( Handle,'open', StrToPChar((sender as TBitBtn).Hint),
                  nil, nil ,SW_NORMAL );
    Arquivo.free;
  end
  else
    aviso('Dados Incompletos');
  if FecharAposImprimir then
    self.close;
end;

procedure TFImprimeTag.LeArquivo;
var
  Arquivo : TStringList;
begin
 if FileExists('Tag.mod') then
 begin
   Arquivo := TStringList.create;
   Arquivo.LoadFromFile('tag.mod');
   if Arquivo.Count >= 2 then
   begin
     BImprime1.Visible := true;
     BImprime1.Caption := Arquivo.Strings[0] + ' F4';
     BImprime1.Hint := Arquivo.Strings[1];
   end;

   if Arquivo.Count >= 4 then
   begin
     BImprime2.Visible := true;
     BImprime2.Caption := Arquivo.Strings[2] + ' F5';
     BImprime2.Hint := Arquivo.Strings[3];
   end;
   Arquivo.free;
 end;
end;


procedure TFImprimeTag.EditLocaliza1Retorno(Retorno1, Retorno2: String);
begin
  if Retorno1 <> '' then
    SeqPro := StrToInt(Retorno1)
  else
    if EditLocaliza1.Text = '' then
      SeqPro := 0;
end;

procedure TFImprimeTag.FormShow(Sender: TObject);
begin
  LeArquivo;
end;

procedure  TFImprimeTag.CarregaDados(CodigoPro : string; Qdade : Integer);
begin
  EditLocaliza1.Text := CodigoPro;
  EditLocaliza1Select(nil);
  EditLocaliza1.Atualiza;
  EqdadePro.AValor := Qdade;
  FecharAposImprimir := true;
  self.ShowModal;
end;

procedure TFImprimeTag.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if ( key = vk_f4 ) and (BImprime1.Visible) then
     BImprime1.Click;
   if ( key = vk_f5 ) and (BImprime2.Visible) then
     BImprime2.Click;

end;

procedure TFImprimeTag.numerico1Exit(Sender: TObject);
var
  ini : TRegIniFile;
begin
  ini := TRegIniFile.Create('Software\Systec\Sistema');
  ini.WriteInteger('IMPRESSORA', 'TempTag',Trunc(numerico1.AValor));
  ini.free;
end;

initialization
 RegisterClasses([TFImprimeTag]);
end.
