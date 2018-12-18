unit AImprimeEstoqueProduto;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  ExtCtrls, quickrpt, Db, DBTables, Qrctrls, ConfigImpressora, printers,
  StdCtrls, Buttons, Geradores, constantes;

type
  TFImprimeEstoqueProduto = class(TFormularioPermissao)
    Aux: TQuery;
    QuickRep1: TQuickRepNovo;
    DetailBand1: TQRBand;
    PageHeaderBand1: TQRBand;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
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
    QRLabel13: TQRLabel;
    QRLabel14: TQRLabel;
    QRLabel15: TQRLabel;
    QRLabel16: TQRLabel;
    AuxI_SEQ_PRO: TIntegerField;
    AuxC_COD_PRO: TStringField;
    AuxC_COD_UNI: TStringField;
    AuxC_NOM_PRO: TStringField;
    AuxC_KIT_PRO: TStringField;
    AuxC_COD_BAR: TStringField;
    AuxN_QTD_PRO: TFloatField;
    AuxN_QTD_RES: TFloatField;
    AuxQdadeReal: TFloatField;
    ValorReservado: TQRLabel;
    ValorTotal: TQRLabel;
    QRShape1: TQRShape;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
  procedure carregaImpressao(ComandoSQL : String;  NomeEmpresa, NomeFilial, Estoque, Reservado, TotalEstoque, Classificacao : string);  end;

var
  FImprimeEstoqueProduto: TFImprimeEstoqueProduto;

implementation


{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFImprimeEstoqueProduto.FormCreate(Sender: TObject);
begin
  QRLabel15.Enabled := Config.MostrarReservado;
  QRDBText6.Enabled := Config.MostrarReservado;
  ValorReservado.Enabled := Config.MostrarReservado;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFImprimeEstoqueProduto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Aux.close;
 Action := CaFree;
end;


procedure TFImprimeEstoqueProduto.carregaImpressao(ComandoSQL : String;  NomeEmpresa, NomeFilial, Estoque, Reservado, TotalEstoque, Classificacao : string);
begin
    Aux.sql.clear;
    Aux.sql.Add(ComandoSQL);
    Aux.open;

    if not config.CodigoBarras then
      QRDBText1.DataField := 'c_cod_pro';

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
 RegisterClasses([TFImprimeEstoqueProduto]);
end.
