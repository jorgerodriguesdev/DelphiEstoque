unit AImprimeEstoqueClassificacao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  ExtCtrls, quickrpt, Db, DBTables, Qrctrls, ConfigImpressora, printers,
  StdCtrls, Buttons, Geradores;

type
  TFImprimeEstoqueClassificacao = class(TFormularioPermissao)
    Aux: TQuery;
    QuickRep1: TQuickRepNovo;
    DetailBand1: TQRBand;
    PageHeaderBand1: TQRBand;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRLabel9: TQRLabel;
    QRSysData1: TQRSysData;
    QRShape2: TQRShape;
    Sit: TQRBand;
    QRShape3: TQRShape;
    QRSysData2: TQRSysData;
    EmpFil: TQRLabel;
    Cla: TQRLabel;
    QRBand1: TQRBand;
    Estoque: TQRLabel;
    valorEstoque: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabel14: TQRLabel;
    QRLabel15: TQRLabel;
    QRLabel16: TQRLabel;
    AuxN_QTD_PRO: TFloatField;
    AuxN_QTD_RES: TFloatField;
    AuxQdadeReal: TFloatField;
    ValorReservado: TQRLabel;
    ValorTotal: TQRLabel;
    QRShape1: TQRShape;
    Auxcodcla: TStringField;
    AuxC_NOM_CLA: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
  procedure carregaImpressao(ComandoSQL : String;  NomeEmpresa, NomeFilial, Estoque, Reservado, TotalEstoque, Classificacao : string; TamanhoCod : Integer);  end;

var
  FImprimeEstoqueClassificacao: TFImprimeEstoqueClassificacao;

implementation

  uses constantes;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFImprimeEstoqueClassificacao.FormCreate(Sender: TObject);
begin
  QRLabel15.Enabled := Config.MostrarReservado;
  QRDBText6.Enabled := Config.MostrarReservado;
  ValorReservado.Enabled := Config.MostrarReservado;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFImprimeEstoqueClassificacao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  aux.close;
  Action := CaFree;
end;


procedure TFImprimeEstoqueClassificacao.carregaImpressao(ComandoSQL : String;  NomeEmpresa, NomeFilial, Estoque, Reservado, TotalEstoque, Classificacao : string; TamanhoCod : Integer);
begin
  Auxcodcla.Size := TamanhoCod;
  Aux.sql.clear;
  Aux.sql.Add(ComandoSQL);
  Aux.open;

  EmpFil.Caption := 'Empresa : ';
  if NomeEmpresa <> '' then
     EmpFil.Caption := EmpFil.Caption + NomeEmpresa
  else
     EmpFil.Caption := EmpFil.Caption + 'Todas';

  EmpFil.Caption := EmpFil.Caption + '  -  Filial : ';
  if NomeFilial <> '' then
     EmpFil.Caption := EmpFil.Caption + NomeFilial
  else
     EmpFil.Caption := EmpFil.Caption + 'Todas';

  if Classificacao <> '' then
    Cla.Caption := 'Classificação : ' +  Classificacao
  else
    Cla.Caption := 'Classificação : Todas ';

  valorEstoque.caption := Estoque;
  ValorReservado.Caption := Reservado;
  ValorTotal.Caption := TotalEstoque;
  QuickRep1.Preview;
  self.Close;
end;

Initialization
 RegisterClasses([TFImprimeEstoqueClassificacao]);
end.
