unit AImprimeMovimentoProduto;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  ExtCtrls, quickrpt, Db, DBTables, Qrctrls, ConfigImpressora, printers,
  StdCtrls, Buttons, Geradores;

type
  TFImprimeMovimentoProduto = class(TFormularioPermissao)
    Aux: TQuery;
    QuickRep1: TQuickRepNovo;
    DetailBand1: TQRBand;
    PageHeaderBand1: TQRBand;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRLabel9: TQRLabel;
    QRSysData1: TQRSysData;
    QRShape2: TQRShape;
    Sit: TQRBand;
    QRShape3: TQRShape;
    QRSysData2: TQRSysData;
    EmpFil: TQRLabel;
    Cla: TQRLabel;
    QRBand1: TQRBand;
    QRLabel10: TQRLabel;
    QRLabel13: TQRLabel;
    QRLabel14: TQRLabel;
    QRLabel15: TQRLabel;
    QRShape1: TQRShape;
    Auxc_nom_pro: TStringField;
    Auxc_cod_uni: TStringField;
    Auxn_qtd_mov: TFloatField;
    Auxn_vlr_mov: TFloatField;
    Auxc_nom_ope: TStringField;
    Auxd_dat_mov: TDateField;
    Auxc_tip_mov: TStringField;
    Auxi_nro_not: TIntegerField;
    Auxi_not_sai: TIntegerField;
    Auxi_not_ent: TIntegerField;
    AuxValorMedio: TFloatField;
    Auxqdade: TFloatField;
    QRDBText1: TQRDBText;
    QRLabel1: TQRLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
  procedure carregaImpressao(ComandoSQL : String;  NomeEmpresa, NomeFilial : string);
  end;

var
  FImprimeMovimentoProduto: TFImprimeMovimentoProduto;

implementation


{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFImprimeMovimentoProduto.FormCreate(Sender: TObject);
begin
  {  abre tabelas }
  { chamar a rotina de atualização de menus }
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFImprimeMovimentoProduto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 { fecha tabelas }
 { chamar a rotina de atualização de menus }
 Action := CaFree;
end;


procedure TFImprimeMovimentoProduto.carregaImpressao(ComandoSQL : String;  NomeEmpresa, NomeFilial : string);
begin
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

    QuickRep1.Preview;
    self.Close;
end;

Initialization
 RegisterClasses([TFImprimeMovimentoProduto]);
end.
