unit AFechamentoEstoque;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Componentes1, ExtCtrls, PainelGradiente, StdCtrls, Buttons, UnSumarizaEstoque,
  Grids, DBGrids, Tabela, Db, DBTables, ComCtrls, Spin, Mask, DBCtrls,
  Gauges;

type
  TFFechamentoEstoque = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    BFechar: TBitBtn;
    Sumariza: TQuery;
    DataSumariza: TDataSource;
    PainelTempo: TPainelTempo;
    PanelColor3: TPanelColor;
    Smes: TSpinEditColor;
    SAno: TSpinEditColor;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    CFG: TQuery;
    DataCFG: TDataSource;
    CFGI_MES_EST: TIntegerField;
    CFGI_ANO_EST: TIntegerField;
    DBEditColor1: TDBEditColor;
    DBEditColor2: TDBEditColor;
    Label3: TLabel;
    SAno1: TSpinEditColor;
    Smes1: TSpinEditColor;
    Barra: TProgressBar;
    Label4: TLabel;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    UnSum : UnSumarizaEstoque.TFuncoesSumarizaEstoque;
  public
    { Public declarations }
  end;

var
  FFechamentoEstoque: TFFechamentoEstoque;

implementation

uses APrincipal, fundata, AQdadeProdutosInconsistente, constmsg, Constantes;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFFechamentoEstoque.FormCreate(Sender: TObject);
begin
  UnSum := UnSumarizaEstoque.TFuncoesSumarizaEstoque.criar(self,FPrincipal.BaseDados);
  SMes.Value := mes(date);
  SAno.Value := ano(date);
  SMes1.Value := mes(date);
  SAno1.Value := ano(date);
  cfg.open;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFFechamentoEstoque.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UnSum.Free;
  cfg.close;
  Action := CaFree;
end;

{******************* fecha o formulario ************************************* }
procedure TFFechamentoEstoque.BFecharClick(Sender: TObject);
begin
  self.close;
end;

procedure TFFechamentoEstoque.BitBtn1Click(Sender: TObject);
var
  ExecutaFechamento : Boolean;
  DataFim, DataUltFechamento : TdateTime;
begin
  ExecutaFechamento := true;
  if cfg.fieldByname('i_mes_est').AsInteger = 0 then
  begin
    DataUltFechamento := PrimeiroDiaMes(UnSum.PrimeiroMovEstoque);
    DataUltFechamento := UltimoDiaMes(DataUltFechamento);
  end  
  else
  begin
    DataUltFechamento := MontaData(01, cfg.fieldByname('i_mes_est').AsInteger, cfg.fieldByname('i_ano_est').AsInteger);
    DataUltFechamento := MontaData(Dia(UltimoDiaMes(DataUltFechamento)),cfg.fieldByname('i_mes_est').AsInteger, cfg.fieldByname('i_ano_est').AsInteger);
  end;
  DataFim := MontaData(01,Smes1.Value, SAno1.Value);
  DataFim := MontaData(Dia(UltimoDiaMes(DataFim)), Smes1.Value, SAno1.Value);

  if DataFim > IncMes(DataUltFechamento,1) then
  begin
    ExecutaFechamento := false;
    aviso(CT_DataMaiorFechamento);
  end;

  if (DataFim < DataUltFechamento)  and ExecutaFechamento then
  begin
    ExecutaFechamento := false;
    aviso(CT_DataMenorFechamento);
  end;

  if (MontaData(15,Smes.Value, SAno.Value) < PrimeiroDiaMes(UnSum.PrimeiroMovEstoque)) and ExecutaFechamento then
  begin
    ExecutaFechamento := false;
    AvisoFormato(CT_MesSemMovimento, [ datetostr(unSum.PrimeiroMovEstoque)] );
  end;

 if ExecutaFechamento  then
 begin
   if not UnSum.VerificaSumaVazio then
     UnSum.FechaMesGeral(Smes.Value, SAno.Value, Smes1.Value, SAno1.Value, Barra)
   else
     UnSum.FechaMesGeral(Mes(UnSum.PrimeiroMovEstoque), Ano(UnSum.PrimeiroMovEstoque), Smes1.Value, SAno1.Value, Barra)
 end;

end;

procedure TFFechamentoEstoque.BitBtn3Click(Sender: TObject);
begin
  FQdadeProdutosInconsistente := TFQdadeProdutosInconsistente.CriarSDI(application, '', FPrincipal.VerificaPermisao('FQdadeProdutosInconsistente'));
  FQdadeProdutosInconsistente.ShowModal;
end;

procedure TFFechamentoEstoque.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FFechamentoEstoque.HelpContext);
end;

procedure TFFechamentoEstoque.FormShow(Sender: TObject);
begin
   Self.HelpFile := Varia.PathHelp + 'MEstoqueCusto.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
end;

Initialization
 RegisterClasses([TFFechamentoEstoque]);
end.
