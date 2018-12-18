unit AExtornoEntrada;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Componentes1, ExtCtrls, PainelGradiente, StdCtrls, Localizacao, Db, Constantes,
  DBTables, Buttons, Mask, DBCtrls, Tabela, Grids, DBGrids, ConstMsg,UnNotasFiscaisFor,
  unContasAPagar, DBKeyViolation, ComCtrls, numericos;

type
  TFExtornoEntrada = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    CadNotasFiscaisFor: TQuery;
    DataCadNotasFiscaisFor: TDataSource;
    Localiza: TConsultaPadrao;
    MovNotasfiscaisFor: TQuery;
    DataMovNotasFiscaisFor: TDataSource;
    MovNotasfiscaisForI_Seq_Not: TIntegerField;
    MovNotasfiscaisForC_Cod_pro: TStringField;
    MovNotasfiscaisForN_Qtd_Pro: TFloatField;
    MovNotasfiscaisForN_Vlr_Pro: TFloatField;
    MovNotasfiscaisForN_Per_Icm: TFloatField;
    MovNotasfiscaisForN_Per_IPI: TFloatField;
    MovNotasfiscaisForN_Tot_Pro: TFloatField;
    MovNotasfiscaisForC_Cod_Cst: TStringField;
    MovNotasfiscaisForI_Seq_Mov: TIntegerField;
    MovNotasfiscaisForC_Cod_Uni: TStringField;
    MovNotasfiscaisForC_Nom_pro: TStringField;
    DBGridColor1: TDBGridColor;
    Splitter1: TSplitter;
    GridIndice1: TGridIndice;
    CadNotasFiscaisForI_Emp_Fil: TIntegerField;
    CadNotasFiscaisForI_Seq_Not: TIntegerField;
    CadNotasFiscaisForI_Nro_Not: TIntegerField;
    CadNotasFiscaisForC_Ser_Not: TStringField;
    CadNotasFiscaisForD_Dat_Emi: TDateField;
    CadNotasFiscaisForN_Tot_Not: TFloatField;
    CadNotasFiscaisForFornecedor: TStringField;
    ESerie: TEditColor;
    EFornecedor: TEditLocaliza;
    EDataInicial: TCalendario;
    EDataFinal: TCalendario;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    SpeedButton1: TSpeedButton;
    Label6: TLabel;
    ENro: TEditColor;
    MovNotasfiscaisForI_Emp_Fil: TIntegerField;
    PainelTempo1: TPainelTempo;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ENroKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ENroExit(Sender: TObject);
    procedure CadNotasFiscaisForAfterScroll(DataSet: TDataSet);
    procedure BBAjudaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    UnNotasFiscaisFor : TFuncoesNFFor;
    UnCP : TFuncoesContasAPagar;
    VprOrdem : String;
    procedure AtualizaConsulta(VpfGuardar : Boolean = false);
    procedure Adicionafiltros(VpaSelect : TSTrings);
    procedure PosicionaMovNota(VpaSeqNota : String);
  public
    { Public declarations }
  end;

var
  FExtornoEntrada: TFExtornoEntrada;

implementation

uses APrincipal,funsql, FunData;

{$R *.DFM}

{ ****************** Na criação do Formulário ******************************** }
procedure TFExtornoEntrada.FormCreate(Sender: TObject);
begin
  VprOrdem := 'order by I_Nro_Not';
  EDataInicial.DateTime := PrimeiroDiaMes(Date);
  EDataFinal.DateTime := UltimoDiaMes(Date);
  UnNotasFiscaisFor := TFuncoesNFFor.criar(self,FPrincipal.BaseDados);
  UnCP := TFuncoesContasAPagar.criar(self,FPrincipal.BaseDados);
  AtualizaConsulta;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFExtornoEntrada.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   UnNotasFiscaisFor.Free;
   UnCP.Free;
   FechaTabela(CadNotasFiscaisFor);
   FechaTabela(MovNotasfiscaisFor);
   Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos da consulta
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{************************** atualiza a consulta *******************************}
procedure TFExtornoEntrada.AtualizaConsulta(VpfGuardar : Boolean = false);
begin
  CadNotasFiscaisFor.Sql.Clear;
  CadNotasFiscaisFor.Sql.add('Select Cad.I_Emp_Fil, Cad.I_Seq_Not, Cad.I_Nro_Not, Cad.C_Ser_Not, '+
                             ' Cad.D_Dat_Emi, N_Tot_Not, '+
                             ' Cad.I_Cod_Cli ||''-''|| Cli.C_Nom_Cli Fornecedor '+
                             ' from dba.CadnotaFiscaisFor Cad, CadClientes Cli ');

  Adicionafiltros(CadNotasFiscaisFor.Sql);
  CadNotasFiscaisFor.Sql.Add(' and Cad.I_Cod_Cli = Cli.I_Cod_Cli');
  CadNotasFiscaisFor.SQL.Add(VprOrdem);
  GridIndice1.ALinhaSQLOrderBy := CadNotasFiscaisFor.SQL.Count -1;
  CadNotasFiscaisFor.open;
end;

{**************** adiciona os filtros da consulta *****************************}
procedure TFExtornoEntrada.Adicionafiltros(VpaSelect : TSTrings);
begin
  VpaSelect.Add('Where '+ SQLTextoDataEntreAAAAMMDD('D_Dat_Emi',EDataInicial.DateTime,EDataFinal.DateTime,false));

  if ENro.Text <> '' then
    VpaSelect.Add(' and I_Nro_Not = ' + ENro.Text);
  if ESerie.Text <> ''then
    VpaSelect.Add(' and C_Ser_Not = ''' + ESerie.Text+'''');
  if EFornecedor.Text <> '' then
    VpaSelect.Add(' And Cad.I_cod_Cli = ' + EFornecedor.Text);
end;

{********************* posiciona o movnotasfiscaisfor *************************}
procedure TFExtornoEntrada.PosicionaMovNota(VpaSeqNota : String);
begin
  if VpaSeqNota <> '' then
    AdicionaSQLAbreTabela(MovNotasfiscaisFor,'Select Mov.I_Emp_Fil, Mov.I_Seq_Not, Mov.C_Cod_pro, Mov.N_Qtd_Pro,' +
                         ' Mov.N_Vlr_Pro, Mov.N_Per_Icm, Mov.N_Per_IPI, ' +
                         ' Mov.N_Tot_Pro,  Mov.C_Cod_Cst, Mov.I_Seq_Mov, Mov.C_Cod_Uni, '+
                         ' Pro.C_Nom_pro '+
                         ' From dba.MovNotasFiscaisFor Mov, CadProdutos Pro '+
                         ' Where  Mov.I_Seq_pro = Pro.I_Seq_pro '+
                         ' and Mov.I_Emp_Fil = ' + InttoStr(Varia.CodigoEmpFil)+
                         ' and Mov.I_Seq_Not = '+ VpaSeqNota +
                         ' order by i_seq_Mov asc')
  else
    MovNotasfiscaisFor.close;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                             eventos dos filtros superiores
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{******************* filtra as tecla pressionadas *****************************}
procedure TFExtornoEntrada.ENroKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    13 : AtualizaConsulta;
  end;
end;

{***************** chama a rotina que atualiza a consulta *********************}
procedure TFExtornoEntrada.ENroExit(Sender: TObject);
begin
  AtualizaConsulta;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                 eventos diversos
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{*************** estorna a nota fiscal de entrada **************************** }
procedure TFExtornoEntrada.BitBtn1Click(Sender: TObject);
begin
   if ConfirmacaoFormato(CT_DeletarNota,[cadNotasFiscaisForI_Nro_Not.Asstring]) Then
   begin
     PainelTempo1.execute('Excluindo nota fiscal de entrada...');
     if UnCP.ExcluiContaNotaFiscal(  CadNotasFiscaisForI_SEQ_NOT.AsInteger, varia.CodigoEmpFil, true ) then
     begin
       UnNotasFiscaisFor.EstornaNotaEntrada( CadNotasFiscaisForI_SEQ_NOT.AsInteger,varia.CodigoEmpFil );
       AtualizaConsulta(true);
     end;
     PainelTempo1.fecha;
   end;
end;

{********************* fecha o formulario ********************************** }
procedure TFExtornoEntrada.BitBtn3Click(Sender: TObject);
begin
   close;
end;

{*************** posiciona o movimento de notas fiscais ***********************}
procedure TFExtornoEntrada.CadNotasFiscaisForAfterScroll(
  DataSet: TDataSet);
begin
  PosicionaMovNota(CadNotasFiscaisForI_Seq_Not.AsString);
end;

procedure TFExtornoEntrada.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FExtornoEntrada.HelpContext);
end;

procedure TFExtornoEntrada.FormShow(Sender: TObject);
begin
   Self.HelpFile := Varia.PathHelp + 'MEstoqueCusto.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
end;

Initialization
 RegisterClasses([TFExtornoEntrada]);
end.
