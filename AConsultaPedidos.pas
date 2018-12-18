unit AConsultaPedidos;

//                Autor: Leonardo Emanuel Pretti
//      Data da Criação: 16/08/2001
//               Função: Consulta de Pedidos
//         Alterado por:
//    Data da Alteração:
//  Motivo da Alteração:

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Componentes1, Localizacao, Db, DBTables, Grids, DBGrids,
  Tabela, DBKeyViolation, Mask, DBCtrls, Buttons, BotaoCadastro, ExtCtrls,
  ComCtrls, numericos, PainelGradiente;

type
  TFConsultaPedidos = class(TFormularioPermissao)
    PanelColor3: TPanelColor;
    BotaoFechar1: TBotaoFechar;
    PanelColor1: TPanelColor;
    SpeedLocalizaCliente: TSpeedButton;
    Localiza: TConsultaPadrao;
    Label4: TLabel;
    DataCadOrcamentos: TDataSource;
    CadOrcamentos: TQuery;
    PainelGradiente1: TPainelGradiente;
    Grade: TGridIndice;
    Label8: TLabel;
    Situacao: TComboBoxColor;
    Label11: TLabel;
    Label9: TLabel;
    Datas: TComboBoxColor;
    Label10: TLabel;
    Data1: TCalendario;
    Data2: TCalendario;
    PanelColor4: TPanelColor;
    Label7: TLabel;
    CadOrcamentosI_LAN_ORC: TIntegerField;
    CadOrcamentosI_EMP_FIL: TIntegerField;
    CadOrcamentosD_DAT_ORC: TDateField;
    CadOrcamentosD_DAT_PRE: TDateField;
    CadOrcamentosI_COD_CLI: TIntegerField;
    CadOrcamentosC_FLA_SIT: TStringField;
    CadOrcamentosI_SEQ_PRO: TIntegerField;
    CadOrcamentosN_QTD_PRO: TFloatField;
    CadOrcamentosC_NOM_PRO: TStringField;
    CadOrcamentosC_NOM_CLI: TStringField;
    LocalizaCliente: TEditLocaliza;
    CadOrcamentosQdtCompra: TIntegerField;
    CadOrcamentosn_qtd_pro_1: TFloatField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DatasChange(Sender: TObject);
    procedure BotaoFechar1Click(Sender: TObject);
    procedure LocalizaClienteRetorno(Retorno1, Retorno2: String);
  private
    procedure AtualizaConsulta;
    procedure AdicionaFiltros (VpaSelect : TStrings);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FConsultaPedidos: TFConsultaPedidos;

implementation
   uses APrincipal, ConstMsg, Constantes, FunSql, FunData, FunObjeto, FunNumeros;
{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFConsultaPedidos.FormCreate(Sender: TObject);
begin
  Data1.Date := PrimeiroDiaMes(Date);
  Data2.Date := UltimoDiaMes(Date);
  LimpaEdits (PanelColor1);
  Datas.ItemIndex := 0;     // EMISSÃO
  Situacao.ItemIndex := 0;  // TODOS
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFConsultaPedidos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CadOrcamentos.Close; { fecha tabelas }
  Action := CaFree;
end;

{ ***************************** Atualiza Consulta **************************** }
procedure TFConsultaPedidos.AtualizaConsulta;
begin
  CadOrcamentos.SQL.Clear;
  CadOrcamentos.SQL.Add('Select CAD.I_LAN_ORC, CAD.I_EMP_FIL, CAD.D_DAT_ORC, ' +
                        '       CAD.D_DAT_PRE, CAD.I_COD_CLI, CAD.C_FLA_SIT, ' +
                        '       CAD.C_TIP_CAD, MOV.N_QTD_PRO, MOV.I_LAN_ORC, ' +
                        '       MOV.I_EMP_FIL, MOV.I_SEQ_PRO,                ' +
                        '       QTD.I_EMP_FIL, QTD.I_SEQ_PRO, QTD.N_QTD_PRO, ' +
                        '       PRO.I_SEQ_PRO, PRO.C_NOM_PRO,                ' +
                        '       CLI.I_COD_CLI, CLI.C_NOM_CLI                 ' +
                        ' From  CadOrcamentos   as Cad,                      ' +
                        '       MovOrcamentos   as Mov,                      ' +
                        '       CadProdutos     as Pro,                      ' +
                        '       MovQdadeProduto as Qtd,                      ' +
                        '       CadClientes     as Cli                       ');
  AdicionaFiltros(CadOrcamentos.SQL);
  CadOrcamentos.SQL.Add('        and CAD.I_EMP_FIL = MOV.I_EMP_FIL           ' +
                        '        and CAD.I_EMP_FIL = QTD.I_EMP_FIL           ' +
                        '        and CAD.I_LAN_ORC = MOV.I_LAN_ORC           ' +
                        '        and QTD.I_SEQ_PRO = PRO.I_SEQ_PRO           ' +
                        '        and MOV.I_SEQ_PRO = PRO.I_SEQ_PRO           ' +
                        '        and CLI.I_COD_CLI = CAD.I_COD_CLI           ' +
                        '        and CAD.C_TIP_CAD = ''P''                   ' +
                        '        and QTD.N_QTD_PRO <= n_qtd_ped              ' +
                        '        and QTD.I_SEQ_PRO = PRO.I_SEQ_PRO           ' +
                        '        and QTD.I_EMP_FIL = CAD.I_EMP_FIL           ');
  CadOrcamentos.SQL.Add(' Order  by  MOV.I_LAN_ORC,  MOV.I_SEQ_PRO           ');

  // Se a qdade estoque for > que a qdade necessária
  if CadOrcamentosn_qtd_pro_1.AsInteger > CadOrcamentosN_QTD_PRO.AsInteger then
     CadOrcamentosQdtCompra.AsInteger := 0 // qdade a comprar recebe "0"
  else  //Senao a qdade a comprar recebe a qdade necessária menos a qdade a comprar
     CadOrcamentosQdtCompra.AsInteger := CadOrcamentosN_QTD_PRO.AsInteger - CadOrcamentosn_qtd_pro_1.AsInteger;

  CadOrcamentos.Open;
end;

{ ***************************** Adiciona Filtros ***************************** }
procedure TFConsultaPedidos.AdicionaFiltros (VpaSelect : TStrings);
begin
  VpaSelect.Add(' Where CAD.I_EMP_FIL = ' + IntToStr (Varia.CodigoEmpFil));

  case Datas.ItemIndex of
    0 : VpaSelect.Add(SQLTextoDataEntreAAAAMMDD('CAD.D_DAT_ORC', Data1.Date, Data2.Date, true  ));
    1 : VpaSelect.Add(SQLTextoDataEntreAAAAMMDD('CAD.D_DAT_PRE', Data1.Date, Data2.Date, true  ));
  end;

  case Situacao.ItemIndex of
    0 : VpaSelect.Add('');                           //  TODOS
    1 : VpaSelect.Add(' and CAD.C_FLA_SIT = ''A'''); //  ABERTOS
    2 : VpaSelect.Add(' and CAD.C_FLA_SIT = ''C'''); //  CANCELADOS
    3 : VpaSelect.Add(' and CAD.C_FLA_SIT = ''E'''); //  ENTREGUES
  end;

  if LocalizaCliente.Text <> '' then      // FILTRA PELO CODIGO DO CLIENTE
    VpaSelect.Add(' and CLI.I_COD_CLI = '+ LocalizaCliente.Text)
  else
    VpaSelect.Add(' ');
end;

{ ***************************** Atualiza Consulta **************************** }
procedure TFConsultaPedidos.DatasChange(Sender: TObject);
begin
  AtualizaConsulta;
end;

{ ***************************** Atualiza Consulta **************************** }
procedure TFConsultaPedidos.LocalizaClienteRetorno(Retorno1,
  Retorno2: String);
begin
   AtualizaConsulta;
end;

{ ******************************** Fecha a Tela ****************************** }
procedure TFConsultaPedidos.BotaoFechar1Click(Sender: TObject);
begin
  Self.Close; // FECHA TELA
end;

Initialization
 RegisterClasses([TFConsultaPedidos]);
end.
