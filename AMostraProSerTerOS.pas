unit AMostraProSerTerOS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  ExtCtrls, PainelGradiente, Grids, DBGrids, Tabela, Db, DBTables,
  StdCtrls, Buttons, Componentes1, UnOrdemServico, Mask, numericos,
  LabelCorMove;

type
  TFAMostraProSerTerOS = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor2: TPanelColor;
    BFechar: TBitBtn;
    BBAjuda: TBitBtn;
    MovOs: TQuery;
    MovOscodigo: TStringField;
    MovOsc_nom_pro: TStringField;
    MovOsn_qtd_mov: TFloatField;
    MovOsc_cod_uni: TStringField;
    MovOsn_vlr_uni: TFloatField;
    MovOsn_vlr_tot: TFloatField;
    DataMovOs: TDataSource;
    DBGridColor1: TDBGridColor;
    MovTerceiros: TQuery;
    DataMovTerceiros: TDataSource;
    DBGridColor2: TDBGridColor;
    MovTerceirosD_DAT_COM: TDateField;
    MovTerceirosI_NOT_COM: TIntegerField;
    MovTerceirosI_NOT_REM: TIntegerField;
    MovTerceirosI_NOT_FOR: TIntegerField;
    MovTerceirosD_DAT_REM: TDateField;
    MovTerceirosD_DAT_RET: TDateField;
    MovTerceirosN_VLR_SER: TFloatField;
    MovTerceirosN_VLR_COB: TFloatField;
    MovTerceirosC_NOM_CLI: TStringField;
    PanelColor1: TPanelColor;
    LabelCorMove1: TLabelCorMove;
    PanelColor3: TPanelColor;
    LabelCorMove2: TLabelCorMove;
    numerico1: Tnumerico;
    Label1: TLabel;
    Label2: TLabel;
    numerico2: Tnumerico;
    Label3: TLabel;
    numerico3: Tnumerico;
    Label5: TLabel;
    numerico5: Tnumerico;
    Bevel1: TBevel;
    Bevel2: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
  private
    UnOS : TFuncoesOrdemServico;
  public
    procedure CarregaMovOS( NroOs : integer);
  end;

var
  FAMostraProSerTerOS: TFAMostraProSerTerOS;

implementation

uses APrincipal;

{$R *.DFM}

{ ****************** Na criação do Formulário ******************************** }
procedure TFAMostraProSerTerOS.FormCreate(Sender: TObject);
begin
  UnOS := TFuncoesOrdemServico.Criar(self, FPrincipal.BaseDados);
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFAMostraProSerTerOS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UnOs.Free;
  Action := CaFree;
end;

{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFAMostraProSerTerOS.BFecharClick(Sender: TObject);
begin
  self.close;
end;

procedure TFAMostraProSerTerOS.CarregaMovOS( NroOs : integer);
var
  Horas : double;
begin
  UnOS.LocalizaMovOSImpressao(MovOs,NroOs);
//  UnOS.LocalizaTerceiroOSImpressao(MovTerceiros,NroOs);
  numerico1.AValor := UnOS.CalculaTotalProdutos(NroOs);
  numerico2.AValor := UnOS.CalculaTotalServico(NroOs, horas);
  numerico3.AValor := numerico1.AValor + numerico2.AValor;
  numerico5.AValor := UnOS.CalculaTotalTerceiro(NroOs);
  Self.ShowModal;
end;


Initialization
 RegisterClasses([TFAMostraProSerTerOS]);
end.
