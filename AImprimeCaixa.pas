unit AImprimeCaixa;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  ExtCtrls, quickrpt, Db, DBTables, Qrctrls, ConfigImpressora, printers,
  StdCtrls, Buttons, Geradores, constantes;

type
  TFImprimeCaixa = class(TFormularioPermissao)
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
    TotalPeso: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabel13: TQRLabel;
    QRLabel14: TQRLabel;
    QRLabel15: TQRLabel;
    QRLabel16: TQRLabel;
    TotalPeca: TQRLabel;
    QRShape1: TQRShape;
    QRLabel1: TQRLabel;
    QRDBText4: TQRDBText;
    QRLabel2: TQRLabel;
    QRDBText8: TQRDBText;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
  procedure carregaImpressao(ComandoSQL : String;  NomeEmpresa, NomeFilial, TotalPeso, TotalPeca, textoFiltro, NomeRel : string);  end;

var
  FImprimeCaixa: TFImprimeCaixa;

implementation


{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFImprimeCaixa.FormCreate(Sender: TObject);
begin
  {  abre tabelas }
  { chamar a rotina de atualização de menus }
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFImprimeCaixa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 { fecha tabelas }
 { chamar a rotina de atualização de menus }
 Action := CaFree;
end;


procedure TFImprimeCaixa.carregaImpressao(ComandoSQL : String;  NomeEmpresa, NomeFilial, TotalPeso, TotalPeca, textoFiltro, NomeRel : string);
begin
    Aux.sql.clear;
    Aux.sql.Add(ComandoSQL);
    Aux.open;

    if (Aux.FieldByName('i_pes_cai') is TFloatField) then
     (Aux.FieldByName('i_pes_cai') as TFloatField).DisplayFormat := varia.MascaraQtd + ' kg';

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

    self.totalpeso.caption := TotalPeso;
    self.totalpeca.Caption := TotalPeca;
    cla.Caption := textoFiltro;
    QRLabel9.Caption :=  'Relatório de ' + NomeRel;
    QuickRep1.Preview;
    self.Close;
end;

Initialization
 RegisterClasses([TFImprimeCaixa]);
end.
