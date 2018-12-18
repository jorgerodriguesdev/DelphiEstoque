unit AConsultaMatEprestado;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  ComCtrls, Componentes1, Buttons, StdCtrls, DBCtrls, Tabela, Localizacao,
  Grids, DBGrids, DBKeyViolation, PainelGradiente, ExtCtrls, Db, DBTables,
  Mask, numericos;

type
  TFConsultaMatEprestado = class(TFormularioPermissao)
    PanelColor1: TPanelColor;
    PainelGradiente1: TPainelGradiente;
    PanelColor2: TPanelColor;
    PanelColor3: TPanelColor;
    BbFechar: TBitBtn;
    Grade: TGridIndice;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Data1: TCalendario;
    Data2: TCalendario;
    LocalizaEmprest: TQuery;
    DSLocalizaEmprest: TDataSource;
    Procurador: TConsultaPadrao;
    Label6: TLabel;
    Flag: TComboBoxColor;
    Tipo: TComboBoxColor;
    LocalizaEmprestI_SEQ_PRO: TIntegerField;
    LocalizaEmprestC_COD_PRO: TStringField;
    LocalizaEmprestC_COD_UNI: TStringField;
    LocalizaEmprestC_NOM_PRO: TStringField;
    LocalizaEmprestD_DAT_CAD: TDateField;
    LocalizaEmprestI_EMP_FIL: TIntegerField;
    LocalizaEmprestI_COD_ORS: TIntegerField;
    LocalizaEmprestC_SIT_ORS: TStringField;
    LocalizaEmprestD_DAT_FEC: TDateField;
    LocalizaEmprestC_CLI_REC: TStringField;
    LocalizaEmprestC_NOM_USU: TStringField;
    LocalizaEmprestD_DAT_DEV: TDateField;
    EOS: Tnumerico;
    LocalizaEmprestC_NOM_CLI: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BbFecharClick(Sender: TObject);
    procedure FlagChange(Sender: TObject);
    procedure LocalizaOsExit(Sender: TObject);
    procedure LocalizaOsRetorno(Retorno1, Retorno2: String);
  private
    { Private declarations }
  public
    procedure AtualizaConsulta;
    procedure AdicionaFiltros(VpaSelect : TStrings);
  end;

var
  FConsultaMatEprestado: TFConsultaMatEprestado;

implementation
uses APrincipal,fundata,funsql,funnumeros,funobjeto,funstring,constantes;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFConsultaMatEprestado.FormCreate(Sender: TObject);
begin
  Flag.ItemIndex := 0;
  Tipo.ItemIndex := 0;
  Data1.Date := PrimeiroDiaMes(Date);
  Data2.Date := UltimoDiaMes(Date);
  AtualizaConsulta;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFConsultaMatEprestado.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 LocalizaEmprest.Close;
 Action := CaFree;
end;


{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFConsultaMatEprestado.BbFecharClick(Sender: TObject);
begin
  self.Close;
end;

procedure TFConsultaMatEprestado.AtualizaConsulta;
begin
  LocalizaEmprest.Close;
  LocalizaEmprest.SQL.Clear;
  LocalizaEmprest.SQL.Add(' SELECT  CAD.I_SEQ_PRO,CAD.C_COD_PRO,CAD.C_COD_UNI, ' +
                          ' CAD.C_NOM_PRO,CAD.D_DAT_CAD, CLI.C_NOM_CLI, ' +
                          ' CADOS.I_EMP_FIL,CADOS.I_COD_ORS,CADOS.C_SIT_ORS,CADOS.D_DAT_FEC, ' +
                          ' CADOS.C_CLI_REC,CADOS.C_NOM_USU,CADOS.D_DAT_CAD,CADOS.I_SEQ_PRO, ' +
                          ' CADOS.C_COD_PRO,CADOS.C_SIT_ORS,CADOS.D_DAT_DEV,CADOS.D_DAT_FEC ' +
                          ' FROM ' +
                          ' CADORDEMSERVICO AS CADOS,' +
                          ' CADPRODUTOS AS CAD, ' +
                          ' CADCLIENTES as CLI ' +
                          ' WHERE  ' +
                          ' CADOS.I_EMP_FIL = ' + IntToStr (Varia.CodigoEmpFil));
  AdicionaFiltros(LocalizaEmprest.SQL);
  LocalizaEmprest.SQL.Add(' AND  CADOS.I_SEQ_PRO  =  CAD.I_SEQ_PRO ' +
                          ' AND  CADOS.I_COD_CLI  =  CLI.I_COD_CLI '   );
  LocalizaEmprest.sql.add(' order by CADOS.I_SEQ_PRO ');
  LocalizaEmprest.open;

end;

procedure TFConsultaMatEprestado.AdicionaFiltros(VpaSelect : TStrings);
begin
     case Flag.ItemIndex of
       0 : VpaSelect.add( ' ' );
       1 : VpaSelect.add(SQLTextoDataEntreAAAAMMDD(' CADOS.D_DAT_CAD ', Data1.Date,Data2.Date, true  ));
       2 : VpaSelect.add(SQLTextoDataEntreAAAAMMDD(' CADOS.D_DAT_DEV ', Data1.Date,Data2.Date, true  ));
       3 : VpaSelect.add(SQLTextoDataEntreAAAAMMDD(' CADOS.D_DAT_FEC ', Data1.Date,Data2.Date, true  ));
     end;

     if EOs.AValor <> 0 Then
       VpaSelect.Add(' and CADOS.I_cod_Ors = ''' + EOs.text + '''')
     else
       VpaSelect.add(' ');

     case Tipo.ItemIndex of
       0 : VpaSelect.add(' and  cados.c_sit_ors = ''A''');
       1 : VpaSelect.add(' and  cados.c_sit_ors = ''F''');
       2 : VpaSelect.add(' and  cados.c_sit_ors = ''C''');
       3 : VpaSelect.add(' ');
     end;
end;



procedure TFConsultaMatEprestado.FlagChange(Sender: TObject);
begin
 AtualizaConsulta;
end;

procedure TFConsultaMatEprestado.LocalizaOsExit(Sender: TObject);
begin
  AtualizaConsulta;
end;

procedure TFConsultaMatEprestado.LocalizaOsRetorno(Retorno1,
  Retorno2: String);
begin
  AtualizaConsulta;
end;

Initialization
 RegisterClasses([TFConsultaMatEprestado]);
end.
