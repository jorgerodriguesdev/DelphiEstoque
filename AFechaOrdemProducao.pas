unit AFechaOrdemProducao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Componentes1, ExtCtrls, PainelGradiente, Buttons, StdCtrls, Mask,
  DBCtrls, Tabela, Localizacao, Db, DBTables, numericos, unordemproducao;

type
  TFFechaOrdemProducao = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    BitBtn1: TBitBtn;
    Shape4: TShape;
    Shape1: TShape;
    Label23: TLabel;
    Label11: TLabel;
    ConsultaPadrao1: TConsultaPadrao;
    FechaOP: TQuery;
    DataFechaOP: TDataSource;
    FechaOPI_COD_MAQ: TIntegerField;
    FechaOPD_DAT_ENT: TDateField;
    FechaOPD_DAT_PRO: TDateField;
    FechaOPC_TIP_ORP: TStringField;
    FechaOPD_DAT_FEC: TDateField;
    FechaOPD_DAT_INI: TDateField;
    FechaOPD_DAT_FIM: TDateField;
    Label15: TLabel;
    SpeedButton1: TSpeedButton;
    Label16: TLabel;
    Label1: TLabel;
    DBEditColor2: TMaskEditColor;
    Label2: TLabel;
    DBEditColor3: TMaskEditColor;
    Label3: TLabel;
    DBEditColor1: TMaskEditColor;
    Label4: TLabel;
    DBEditColor4: TMaskEditColor;
    BitBtn2: TBitBtn;
    numerico1: Tnumerico;
    CodMaquina: TEditLocaliza;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure numerico1Exit(Sender: TObject);
    procedure AtualizaDados;
    procedure BitBtn2Click(Sender: TObject);
  private
    fecharAopos : Boolean;
    SeqProdutoOP : Integer;
    QdadeBaixa : Double;
    unOP : TFuncoesOrdemProducao;
  public
    procedure CarregaAlteracao( CodOrp, SeqProdutoOP : integer; QdadeBiaxa : Double);
  end;

var
  FFechaOrdemProducao: TFFechaOrdemProducao;

implementation

uses APrincipal, constantes, funsql, constmsg, funobjeto;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFFechaOrdemProducao.FormCreate(Sender: TObject);
begin
  unOP := TFuncoesOrdemProducao.Criar(self, FPrincipal.BaseDados);
  fecharAopos := false;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFFechaOrdemProducao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  unOP.Free;
  Action := CaFree;
end;


{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFFechaOrdemProducao.BitBtn1Click(Sender: TObject);
begin
  self.close;
end;


procedure TFFechaOrdemProducao.CarregaAlteracao( CodOrp, SeqProdutoOP : integer; QdadeBiaxa : Double);
begin
  numerico1.AValor := codorp;
  self.SeqProdutoOP := SeqProdutoOP;
  self.QdadeBaixa := QdadeBaixa;
  AdicionaSQLAbreTabela(FechaOP, ' select * from cadOrdemProducao '  +
                                 ' where i_nro_orp = ' + inttostr(codOrp) +
                                 ' and i_emp_fil = ' + Inttostr(varia.CodigoEmpFil) );
  AtualizaDados;     ///
  fecharAopos := true;
end;

procedure TFFechaOrdemProducao.AtualizaDados;
begin
  CodMaquina.text := FechaOPI_COD_MAQ.AsString;
  CodMaquina.Atualiza;
  DBEditColor2.text := FechaOPD_DAT_ENT.AsString;
  DBEditColor3.text := FechaOPD_DAT_PRO.AsString;
  DBEditColor1.text := FechaOPD_DAT_INI.AsString;
  DBEditColor4.text := FechaOPD_DAT_FIM.AsString;
end;

procedure TFFechaOrdemProducao.numerico1Exit(Sender: TObject);
begin
  if numerico1.AValor <> 0 then
  begin
    AdicionaSQLAbreTabela(FechaOP, ' select * from cadordemproducao ' +
                                   ' where i_nro_orp =  ' + inttostr(trunc(numerico1.AValor)) +
                                   ' and i_emp_fil = ' + Inttostr(varia.CodigoEmpFil) +
                                   ' and c_tip_orp = ''A''' );
    if FechaOP.eof then
    begin
      aviso(' Ordem de produção inesistente ou fechada ');
      numerico1.setfocus;
    end
    else
      AtualizaDados;
  end;
end;

procedure TFFechaOrdemProducao.BitBtn2Click(Sender: TObject);
var
  dataPro, DataEnt, dataFim, dataIni : TDateTime;
  CodMaq : Integer;
begin
  dataPro := strtodate('01/01/01');
  dataent := strtodate('01/01/01');
  datafim := strtodate('01/01/01');
  dataini := strtodate('01/01/01');
  if DBEditColor3.text[1] <> ' ' then dataPro := strtodate(DBEditColor3.text);
  if DBEditColor2.text[1] <> ' ' then dataent := strtodate(DBEditColor2.text);
  if DBEditColor4.text[1] <> ' ' then datafim := strtodate(DBEditColor4.text);
  if DBEditColor1.text[1] <> ' ' then dataini := strtodate(DBEditColor1.text);
  if CodMaquina.text <> '' then CodMaq := strtoint(CodMaquina.Text) else CodMaq := 0;
  unOP.FechaOP(dataPro,DataEnt,dataIni, dataFim, trunc(numerico1.AValor),CodMaq);
  unop.AdicionaEstoqueComposicao(trunc(numerico1.AValor), SeqProdutoOP,QdadeBaixa);
  if fecharAopos then
    self.close
  else
  begin
   LimpaEdits(PanelColor1);
   Label16.Caption := '';
   numerico1.SetFocus;
  end;
end;


Initialization
 RegisterClasses([TFFechaOrdemProducao]);
end.
