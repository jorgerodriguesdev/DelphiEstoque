unit AMovOP;
//Autor: Jorge Eduardo Rodrigues
//Utilidade:Alterar Composição do Produto
//Data: 10 de abril de 2001
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  ExtCtrls, Componentes1, Grids, DBGrids, Tabela, Buttons, StdCtrls,
  DBCtrls, BotaoCadastro, Localizacao, Db, DBTables, PainelGradiente, Mask,
  DBKeyViolation;

type
  TFMovOP = class(TFormularioPermissao)
    PanelColor1: TPanelColor;
    Shape2: TShape;
    Shape1: TShape;
    label1: TLabel;
    label2: TLabel;
    label3: TLabel;
    label6: TLabel;
    PainelGradiente1: TPainelGradiente;
    Label4: TLabel;
    EQtdProduto: TDBEditNumerico;
    ECodigoUni: TDBEditColor;
    EProduto: TDBEditLocaliza;
    SPEEDPRODUTO: TSpeedButton;
    BotaoGravar1: TBotaoGravar;
    BotaoCancelar1: TBotaoCancelar;
    AlteraOP: TSQL;
    DataAlteraOP: TDataSource;
    AlteraOPI_EMP_FIL: TIntegerField;
    AlteraOPI_NRO_ORP: TIntegerField;
    AlteraOPI_SEQ_PRO: TIntegerField;
    AlteraOPC_COD_UNI: TStringField;
    AlteraOPN_QTD_PRO: TFloatField;
    AlteraOPD_ULT_ALT: TDateField;
    AlteraOPC_UNI_PAI: TStringField;
    AlteraOPC_COD_PRO: TStringField;
    ConsultaPadrao1: TConsultaPadrao;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ALteraOPBeforePost(DataSet: TDataSet);
    procedure EProdutoSelect(Sender: TObject);
    procedure EProdutoChange(Sender: TObject);
    procedure EProdutoRetorno(Retorno1, Retorno2: String);
  private

  public
    procedure Carrega( NroOrP, SeqPro : Integer );
  end;

var
  FMovOP: TFMovOP;

implementation

uses APrincipal,Constantes,funsql,funobjeto,AOrdemProducao;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFMovOP.FormCreate(Sender: TObject);
begin
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFMovOP.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  AlteraOP.close;
  Action := CaFree;
end;

{******* CARREGA D_ULT_ALT_ QUE IDENTIFICA A ULTIMA ALTERACÃO NOS DADOS DO SISTEMA *********}
procedure TFMovOP.ALteraOPBeforePost(DataSet: TDataSet);
begin
  ALteraOPD_ULT_ALT.AsDateTime := date;
end;


{ *********** PROCEDURE QUE PASSA I_SEQ _PRO DENTRO DE UMA SELECT *********************}
procedure TFMovOP.Carrega( NroOrP, SeqPro : Integer );
begin
  AdicionaSQLAbreTabela(AlteraOP,' select * from movordemproducao '  +
                                   ' where i_nro_orp = ' + inttostr(NroOrP) +
                                   ' and I_Seq_pro = ' + Inttostr(SeqPro) +
                                   ' and i_emp_fil = ' + Inttostr(varia.CodigoEmpFil) );
  AlteraOP.edit;
  EProduto.Atualiza;
end;


{ ************ SELECT PARA O EDIT  DE PRODUTOS  ***************************************}
procedure TFMovOP.EProdutoSelect(Sender: TObject);
begin
  Eproduto.ASelectValida.Clear;
  Eproduto.ASelectValida.add(' Select Pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
                               ' pro.I_SEQ_PRO, mov.C_COD_BAR ' +
                               ' From cadprodutos as pro, ' +
                               ' MovQdadeProduto as mov ' +
                               ' Where pro.I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                               ' and ' + varia.CodigoProduto + ' = ''@''' +
                               ' and pro.C_KIT_PRO = ''P'' ' +
                               ' and pro.I_seq_pro = Mov.I_seq_pro ' +
                               ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil) );
  Eproduto.ASelectLocaliza.Clear;
  Eproduto.ASelectLocaliza.add(' Select pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
                               ' pro.I_SEQ_PRO, mov.C_COD_BAR ' +
                               ' from cadprodutos as pro, ' +
                               ' MovQdadeProduto as mov ' +
                               ' Where pro.I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                               ' and pro.c_nom_pro like ''@%''' +
                               ' and pro.C_KIT_PRO = ''P'' ' +
                               ' and pro.I_seq_pro = Mov.I_seq_pro ' +
                               ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil) );
end;

procedure TFMovOP.EProdutoChange(Sender: TObject);
begin
  BotaoGravar1.Enabled := EProduto.Text <> ''
end;

procedure TFMovOP.EProdutoRetorno(Retorno1, Retorno2: String);
begin
  if Retorno1 <> '' then
    AlteraOPI_SEQ_PRO.AsInteger := strtoint(Retorno1);
end;

Initialization
 RegisterClasses([TFMovOP]);
end.
 