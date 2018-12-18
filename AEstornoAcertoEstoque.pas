unit AEstornoAcertoEstoque;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  ComCtrls, Componentes1, Grids, DBGrids, Tabela, ExtCtrls, PainelGradiente,
  Db, DBTables, Buttons, StdCtrls, Localizacao, DBKeyViolation;

type
  TFEstornoAcertoEstoque = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    PanelColor3: TPanelColor;
    data1: TCalendario;
    data2: TCalendario;
    Estoque: TQuery;
    DataEstoque: TDataSource;
    EditLocaliza2: TEditLocaliza;
    Label14: TLabel;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    Localiza: TConsultaPadrao;
    EstoqueI_EMP_FIL: TIntegerField;
    EstoqueI_LAN_EST: TIntegerField;
    EstoqueI_COD_OPE: TIntegerField;
    EstoqueD_DAT_MOV: TDateField;
    EstoqueN_QTD_MOV: TFloatField;
    EstoqueC_TIP_MOV: TStringField;
    EstoqueN_VLR_MOV: TFloatField;
    EstoqueI_NOT_SAI: TIntegerField;
    EstoqueI_NOT_ENT: TIntegerField;
    EstoqueI_NRO_NOT: TIntegerField;
    EstoqueC_COD_UNI: TStringField;
    EstoqueC_NOM_OPE: TStringField;
    EstoqueC_TIP_OPE: TStringField;
    GridIndice1: TGridIndice;
    BitBtn1: TBitBtn;
    EstoqueI_SEQ_PRO: TIntegerField;
    BotaoFechar2: TBitBtn;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure data1CloseUp(Sender: TObject);
    procedure EditLocaliza2Retorno(Retorno1, Retorno2: String);
    procedure BitBtn1Click(Sender: TObject);
    procedure BotaoFechar2Click(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure GeraFiltro;
  public
    { Public declarations }
  end;

var
  FEstornoAcertoEstoque: TFEstornoAcertoEstoque;

implementation

uses APrincipal, funsql, fundata, UnProdutos, constantes;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFEstornoAcertoEstoque.FormCreate(Sender: TObject);
begin
 data1.DateTime := date;
 data2.DateTime := date;
 GeraFiltro;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFEstornoAcertoEstoque.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action := CaFree;
end;

{*************** gera filtro do estoque a ser estornado ********************* }
procedure TFEstornoAcertoEstoque.GeraFiltro;
begin
LimpaSQLTabela(estoque);
InseriLinhaSQL(estoque, 0, 'select * from MovEstoqueProdutos as mov, CadOperacaoEstoque as Ope where ' +
                           SQLTextoDataEntreAAAAMMDD( 'D_DAT_MOV', data1.DateTime, data2.DateTime, false) +
                           ' and mov.I_EMP_FIL = ' + IntTostr(varia.codigoEmpFil) +
                           ' and isnull(I_nro_not,0) = 0');

if EditLocaliza2.Text <>  '' then
  InseriLinhaSQL(estoque, 1, ' and mov.i_cod_ope = ' + EditLocaliza2.text )
else
  InseriLinhaSQL(estoque, 1, '   ');


  InseriLinhaSQL(estoque, 2, ' and mov.i_cod_ope = ope.i_cod_ope ');

  InseriLinhaSQL(estoque, 3,' order by d_dat_mov ');

AbreTabela(estoque);
end;

{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFEstornoAcertoEstoque.data1CloseUp(Sender: TObject);
begin
GeraFiltro;
end;

procedure TFEstornoAcertoEstoque.EditLocaliza2Retorno(Retorno1,
  Retorno2: String);
begin
  GeraFiltro;
end;

procedure TFEstornoAcertoEstoque.BitBtn1Click(Sender: TObject);
var
 unProduto : TFuncoesProduto;
begin
  unProduto := TFuncoesProduto.criar(self, FPrincipal.BaseDados);
  unProduto.EstornaEstoque(EstoqueI_LAN_EST.AsInteger, varia.CodigoEmpFil);
  GeraFiltro;
end;

procedure TFEstornoAcertoEstoque.BotaoFechar2Click(Sender: TObject);
begin
  self.close;
end;

procedure TFEstornoAcertoEstoque.BBAjudaClick(Sender: TObject);
begin
    Application.HelpCommand(HELP_CONTEXT,FEstornoAcertoEstoque.HelpContext);
end;

procedure TFEstornoAcertoEstoque.FormShow(Sender: TObject);
begin
   Self.HelpFile := Varia.PathHelp + 'MEstoqueCusto.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
end;

Initialization
  RegisterClasses([TFEstornoAcertoEstoque]);
end.
