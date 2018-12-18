unit AImprimeReqMaterial;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Db, DBTables, Tabela, QuickRpt, ExtCtrls, Geradores, UnImpressao,
  Qrctrls,StdCtrls, Buttons, UnRequisicaoMaterial;

type
  TFImprimeReqMaterial = class(TFormularioPermissao)
    Pagina: TQuickRepNovo;
    Cadreq: TQuery;
    DetailBand1: TQRBand;
    PageHeaderBand1: TQRBand;
    Filial: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel1: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel5: TQRLabel;
    QRShape1: TQRShape;
    Movreq: TQuery;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    CadreqI_Emp_Fil: TIntegerField;
    CadreqI_Cod_Req: TIntegerField;
    CadreqI_Cod_Usu: TIntegerField;
    CadreqNomeReq: TStringField;
    CadreqI_Usu_Req: TIntegerField;
    CadreqNomeUsu: TStringField;
    CadreqD_Dat_Req: TDateField;
    QRSysData1: TQRSysData;
    MovreqI_Emp_Fil: TIntegerField;
    MovreqI_Seq_Pro: TIntegerField;
    MovreqN_Qtd_Pro: TFloatField;
    MovreqI_cod_emp: TIntegerField;
    MovreqC_Nom_pro: TStringField;
    MovreqC_Cod_Uni: TStringField;
    MovreqC_Cod_Pro: TStringField;
    MovreqI_Cod_Req: TIntegerField;
    Movreqc_cod_bar: TStringField;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText8: TQRDBText;
    SummaryBand1: TQRBand;
    QRLabel12: TQRLabel;
    QRDBText9: TQRDBText;
    QRLabel7: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel9: TQRLabel;
    QRShape2: TQRShape;
    QRShape3: TQRShape;
    CadreqL_obs_req: TMemoField;
    QRDBRichText1: TQRDBRichText;
    TextoNro: TQRLabel;
    Nro: TQRLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    UnReqMat : TFuncoesReqMaterial;
  public
    procedure CarregaReqmateria( codRequisicao, CodFilial, NroDoc : integer; NomeFilial, TextoDocum : string);
  end;

var
  FImprimeReqMaterial: TFImprimeReqMaterial;

implementation

uses APrincipal, funsql, constantes, funstring, constmsg;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFImprimeReqMaterial.FormCreate(Sender: TObject);
begin
  UnReqMat := TFuncoesReqMaterial.Criar(self, fprincipal.BaseDados);
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFImprimeReqMaterial.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UnReqMat.free;
  Action := CaFree;
end;

procedure TFImprimeReqMaterial.CarregaReqmateria( codRequisicao, CodFilial, NroDoc : integer; NomeFilial, TextoDocum : string);
begin
  UnReqMat.LocalizaConsultaCadReqImpressao(Cadreq,codRequisicao,CodFilial);
  UnReqMat.LocalizaConsultaMovReqImpressao(Movreq,codRequisicao,CodFilial);
  TextoNro.Caption := TextoDocum;
  if NroDoc = 0 then
    Self.Nro.Caption := ''
  else
    self.Nro.Caption := inttostr(NroDoc);
  Filial.Caption := NomeFilial;
//  pagina.Preview;
  Pagina.Print;
  self.close;
end;

Initialization
 RegisterClasses([TFImprimeReqMaterial]);
end.
