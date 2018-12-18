unit ATabelaPreco;

{          Autor: Douglas Thomas Jacobsen
    Data Criação: 19/10/1999;
          Função: Cadastrar um novo Caixa
  Data Alteração:
    Alterado por:
Motivo alteração:
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Componentes1, ExtCtrls, PainelGradiente, BotaoCadastro, Constantes,
  StdCtrls, Buttons, Db, DBTables, Tabela, Mask, DBCtrls, Grids, DBGrids,
  DBKeyViolation, Localizacao;

type
  TFTabelaPreco = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    MoveBasico1: TMoveBasico;
    BotaoCadastrar1: TBotaoCadastrar;
    BAlterar: TBotaoAlterar;
    BotaoGravar1: TBotaoGravar;
    BotaoCancelar1: TBotaoCancelar;
    DATATabela: TDataSource;
    Label3: TLabel;
    EEmpresa: TDBEditColor;
    Bevel1: TBevel;
    Label1: TLabel;
    EConsulta: TLocalizaEdit;
    CADTabelaPreco: TSQL;
    BFechar: TBitBtn;
    GGrid: TGridIndice;
    ValidaGravacao: TValidaGravacao;
    Label4: TLabel;
    DBEditColor1: TDBEditColor;
    CADTabelaPrecoI_COD_EMP: TIntegerField;
    CADTabelaPrecoI_COD_TAB: TIntegerField;
    CADTabelaPrecoC_NOM_TAB: TStringField;
    CADTabelaPrecoD_DAT_MOV: TDateField;
    CADTabelaPrecoC_OBS_TAB: TMemoField;
    Label2: TLabel;
    Label5: TLabel;
    DBEditColor3: TDBEditColor;
    DBMemoColor1: TDBMemoColor;
    Label6: TLabel;
    Label7: TLabel;
    EditLocaliza4: TEditLocaliza;
    SpeedButton3: TSpeedButton;
    Label8: TLabel;
    Localiza: TConsultaPadrao;
    NovaTabela: TQuery;
    Tabela: TQuery;
    BitBtn1: TBitBtn;
    PainelTempo1: TPainelTempo;
    DBFilialColor1: TDBFilialColor;
    CADTabelaPrecoD_ULT_ALT: TDateField;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CADTabelaPrecoAfterInsert(DataSet: TDataSet);
    procedure CADTabelaPrecoAfterPost(DataSet: TDataSet);
    procedure CADTabelaPrecoAfterEdit(DataSet: TDataSet);
    procedure BFecharClick(Sender: TObject);
    procedure CADTabelaPrecoAfterCancel(DataSet: TDataSet);
    procedure GGridOrdem(Ordem: String);
    procedure EConsultaSelect(Sender: TObject);
    procedure EditLocaliza4Select(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure EEmpresaChange(Sender: TObject);
    procedure CADTabelaPrecoBeforePost(DataSet: TDataSet);
    procedure BBAjudaClick(Sender: TObject);
  private
    CodNovaTabela : Integer;
    Inseriu : Boolean;
    procedure ConfiguraConsulta( acao : Boolean);
    procedure adicionatabela( codigoTabela : integer);
    procedure AdicionaTabelaServico(VpaCodTabela: integer);
  public
    { Public declarations }
  end;

var
  FTabelaPreco: TFTabelaPreco;

implementation

uses APrincipal, funsql, constMsg;

{$R *.DFM}

{ ****************** Na criação do Formulário ******************************** }
procedure TFTabelaPreco.FormCreate(Sender: TObject);
begin
   Self.HelpFile := Varia.PathHelp + 'MPONTOLOJA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
   LimpaSQLTabela( CADTabelaPreco );
   AdicionaSQLTabela( CADTabelaPreco, ' Select * from CadTabelaPreco ' +
                                      ' where i_cod_emp = ' + IntToStr(varia.CodigoEmpresa) );
   AdicionaSQLTabela( CADTabelaPreco,' Order By i_cod_tab ');
   AbreTabela(CADTabelaPreco);
   DBFilialColor1.ACodFilial := Varia.CodigoFilCadastro;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFTabelaPreco.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FechaTabela(CADTabelaPreco);
  Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações da Tabela
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***********************Gera o proximo codigo disponível***********************}
procedure TFTabelaPreco.CADTabelaPrecoAfterInsert(DataSet: TDataSet);
begin
  DBFilialColor1.ReadOnly := FALSE;
   ConfiguraConsulta(False);
   DBFilialColor1.ProximoCodigo;
   CADTabelaPrecoI_COD_EMP.AsInteger := Varia.CodigoEmpresa;
   CADTabelaPrecoD_DAT_MOV.AsDateTime := date;
   CodNovaTabela := CADTabelaPrecoI_COD_TAB.AsInteger;
   Inseriu := true;
end;

{******************************Atualiza a tabela*******************************}
procedure TFTabelaPreco.CADTabelaPrecoAfterPost(DataSet: TDataSet);
begin
  EConsulta.AtualizaTabela;
  ConfiguraConsulta(True);
  if ( Inseriu ) then
    adicionatabela( CodNovaTabela );
end;

{********************* antes de gravar o registro ****************************}
procedure TFTabelaPreco.CADTabelaPrecoBeforePost(DataSet: TDataSet);
begin
  CADTabelaPrecoD_ULT_ALT.AsDateTime := Date;
  IF CADTabelaPreco.State = dsinsert then
    DBFilialColor1.VerificaCodigoRede;
end;

{*********************Coloca o campo chave em read-only************************}
procedure TFTabelaPreco.CADTabelaPrecoAfterEdit(DataSet: TDataSet);
begin
   DBFilialColor1.ReadOnly := true;
   ConfiguraConsulta(False);
   Inseriu := false;
end;

{ ********************* quando cancela a operacao *************************** }
procedure TFTabelaPreco.CADTabelaPrecoAfterCancel(DataSet: TDataSet);
begin
  ConfiguraConsulta(True);
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************************Fecha o Formulario corrente***********************}
procedure TFTabelaPreco.BFecharClick(Sender: TObject);
begin
  Close;
end;

{****** configura a consulta, caso edit ou insert enabled = false *********** }
procedure TFTabelaPreco.ConfiguraConsulta( acao : Boolean);
begin
   Label1.Enabled := acao;
   EConsulta.Enabled := acao;
   GGrid.Enabled := acao;
end;

{ *************** retorno da order by ************************************* }
procedure TFTabelaPreco.GGridOrdem(Ordem: String);
begin
  EConsulta.AOrdem := ordem;
end;

{************** valida a gravacao da tabela ********************************* }
procedure TFTabelaPreco.EEmpresaChange(Sender: TObject);
begin
  if (CADTabelaPreco.State in [dsInsert, dsEdit]) then
  ValidaGravacao.Execute;
end;

{************** select de consulta da tabela ******************************** }
procedure TFTabelaPreco.EConsultaSelect(Sender: TObject);
begin
EConsulta.ASelect.Clear;
EConsulta.ASelect.Add( ' Select * from CadTabelaPreco ' +
                       ' where i_cod_emp = ' + IntToStr(varia.CodigoEmpresa) +
                       ' and c_nom_tab like ''@%''' );
end;

procedure TFTabelaPreco.EditLocaliza4Select(Sender: TObject);
begin
EditLocaliza4.ASelectValida.Clear;
EditLocaliza4.ASelectValida.Add( ' Select * from CadTabelaPreco ' +
                                 ' where i_cod_emp = ' + IntToStr(varia.CodigoEmpresa) +
                                 ' and i_cod_tab = @ ' );
EditLocaliza4.ASelectLocaliza.Clear;
EditLocaliza4.ASelectLocaliza.Add( ' Select * from CadTabelaPreco ' +
                                   ' where i_cod_emp = ' + IntToStr(varia.CodigoEmpresa) +
                                   ' and c_nom_tab like ''@%''' );

end;

{ ******************** cria um novo movimento de tabela ********************* }
procedure TFTabelaPreco.adicionatabela( codigoTabela : integer);
begin
  PainelTempo1.Execute('Gerando tabela de preço dos Produtos');
  LimpaSQLTabela(Tabela);
  if EditLocaliza4.text <> '' then
  begin
    AdicionaSQLTabela(Tabela, ' SELECT ' +
                              ' PRO.I_SEQ_PRO, MOV.I_COD_MOE , ' +
                              ' MOV.N_VLR_VEN, MOV.N_PER_MAX, MOV.C_CIF_MOE, ' +
                              ' MOV.N_VLR_CUS, MOV.N_VLR_PRO, MOV.N_VLR_DES, MOV.N_VLR_MAR ' +
                              ' FROM ' +
                              ' MOVTABELAPRECO AS MOV, CADPRODUTOS AS PRO ' +
                              ' WHERE ' +
                              ' MOV.I_SEQ_PRO = PRO.I_SEQ_PRO ' +
                              ' AND  PRO.I_COD_EMP =  ' + IntTostr(varia.CodigoEmpresa) +
                              ' AND MOV.I_COD_TAB = ' + EditLocaliza4.text );
  end
  else
    AdicionaSQLTabela(Tabela, ' SELECT  PRO.I_SEQ_PRO, N_PER_MAX FROM ' +
                              ' CADPRODUTOS AS PRO ' +
                              ' WHERE PRO.I_COD_EMP =  ' + IntTostr(varia.CodigoEmpresa) );

  AbreTabela(Tabela);
  AdicionaSQLAbreTabela(NovaTabela, ' Select * from MovTabelaPreco ' );
  while not Tabela.Eof do
  begin
    NovaTabela.insert;
      NovaTabela.FieldByName('I_COD_EMP').AsInteger := varia.CodigoEmpresa;
      NovaTabela.FieldByName('I_COD_TAB').AsInteger := codigoTabela;
      NovaTabela.FieldByName('I_SEQ_PRO').AsInteger := Tabela.fieldByName('I_SEQ_PRO').AsInteger;
      NovaTabela.FieldByName('I_COD_MOE').Value := Varia.MoedaBase;
      NovaTabela.FieldByName('C_CIF_MOE').Value := CurrencyString;
      NovaTabela.FieldByName('D_ULT_ALT').AsDateTime := date;

      if EditLocaliza4.Text <> '' then
      begin
        if Tabela.fieldByName('I_COD_MOE').AsInteger <> 0 then
          NovaTabela.FieldByName('I_COD_MOE').Value := Tabela.fieldByName('I_COD_MOE').Value;
        NovaTabela.FieldByName('N_VLR_VEN').Value := Tabela.fieldByName('N_VLR_VEN').Value;
        NovaTabela.FieldByName('N_PER_MAX').Value := Tabela.fieldByName('N_PER_MAX').Value;
        NovaTabela.FieldByName('C_CIF_MOE').Value := Tabela.fieldByName('C_CIF_MOE').Value;
        NovaTabela.FieldByName('N_VLR_CUS').Value := Tabela.fieldByName('N_VLR_CUS').Value;
        NovaTabela.FieldByName('N_VLR_PRO').Value := Tabela.fieldByName('N_VLR_PRO').Value;
        NovaTabela.FieldByName('N_VLR_DES').Value := Tabela.fieldByName('N_VLR_DES').Value;
        NovaTabela.FieldByName('N_VLR_MAR').Value := Tabela.fieldByName('N_VLR_MAR').Value;
      end;

    NovaTabela.post;
    tabela.next;
  end;

  tabela.close;
  if EditLocaliza4.Text <> '' then
  begin
    ExecutaComandoSql(tabela,' insert into movitenscusto(i_cod_emp, i_seq_pro, ' +
                             ' i_cod_ite, n_vlr_cus, n_per_cus, d_dat_atu, i_des_imp,' +
                             ' i_cod_tab, d_ult_alt) ' +
                             '(select i_cod_emp, i_seq_pro, i_cod_ite, n_vlr_cus, ' +
                             ' n_per_cus, d_dat_atu, i_des_imp, ' + Inttostr(codigoTabela) +
                             ' , ' + SQLTextoDataAAAAMMMDD(date) +
                             ' from movitenscusto ' +
                             ' where i_cod_tab =  ' + EditLocaliza4.text +
                             ' and i_cod_emp = ' + Inttostr(varia.CodigoEmpresa) + ') ' );
  end;
  AdicionaTabelaServico(codigoTabela);
  PainelTempo1.fecha;
end;

{******************* adiciona a tabela de servico *****************************}
procedure TFTabelaPreco.AdicionaTabelaServico(VpaCodTabela : integer);
begin
  PainelTempo1.Execute('Gerando tabela de preço dos Serviços');
  LimpaSQLTabela(Tabela);
  if EditLocaliza4.text <> '' then
  begin
    AdicionaSQLTabela(Tabela, ' SELECT ' +
                              ' Ser.I_Cod_Ser, MOV.I_COD_MOE , ' +
                              ' MOV.N_VLR_VEN, MOV.C_CIF_MOE ' +
                              ' FROM ' +
                              ' MOVTABELAPRECOSERVICO MOV, CADServico Ser ' +
                              ' WHERE ' +
                              ' MOV.I_Cod_Ser =* Ser.I_Cod_Ser ' +
                              ' AND  Ser.I_COD_EMP =  ' + IntTostr(varia.CodigoEmpresa) +
                              ' AND MOV.I_COD_TAB = ' + EditLocaliza4.text );
  end
  else
    AdicionaSQLTabela(Tabela, ' SELECT  Ser.I_COD_SER FROM ' +
                              ' CADSERVICO SER ' +
                              ' WHERE SER.I_COD_EMP =  ' + IntTostr(varia.CodigoEmpresa) );

  AbreTabela(Tabela);
  AdicionaSQLAbreTabela(NovaTabela, ' Select * from MovTabelaPrecoServico ' );
  while not Tabela.Eof do
  begin
    NovaTabela.insert;
      NovaTabela.FieldByName('I_COD_EMP').AsInteger := varia.CodigoEmpresa;
      NovaTabela.FieldByName('I_COD_TAB').AsInteger := VpaCodTabela;
      NovaTabela.FieldByName('I_COD_SER').AsInteger := Tabela.fieldByName('I_COD_SER').AsInteger;
      NovaTabela.FieldByName('I_COD_MOE').Value := Varia.MoedaBase;
      NovaTabela.FieldByName('C_CIF_MOE').Value := CurrencyString;

      if EditLocaliza4.Text <> '' then
      begin
        if Tabela.fieldByName('I_COD_MOE').AsInteger <> 0 then
        begin
          NovaTabela.FieldByName('C_CIF_MOE').Value := Tabela.fieldByName('C_CIF_MOE').Value;
          NovaTabela.FieldByName('I_COD_MOE').Value := Tabela.fieldByName('I_COD_MOE').Value;
        end;
        NovaTabela.FieldByName('N_VLR_VEN').Value := Tabela.fieldByName('N_VLR_VEN').Value;
      end;

    NovaTabela.post;
    tabela.next;
  end;
  PainelTempo1.fecha;
end;

{************* deleta um tabela de preco *********************************** }
procedure TFTabelaPreco.BitBtn1Click(Sender: TObject);
begin
  if confirmacao(CT_DeletaRegistro + CADTabelaPrecoC_NOM_TAB.AsString + '" !!!') then
  begin
    ExecutaComandoSql(Tabela,' update MOVTABELAPRECOCLIENTE ' +   //nao possui tabela servico
                             ' set i_cod_tab = null, i_cod_emp = null ' +
                             ' where i_cod_emp = ' + IntToStr(Varia.CodigoEmpresa) +
                             ' and i_cod_tab = ' + CADTabelaPrecoI_COD_TAB.AsString +
                             ' and i_tab_ser is null ; ' +

                             ' update MOVTABELAPRECOCLIENTE ' +   //nao possui tabela servico
                             ' set i_cod_tab = null ' +
                             ' where i_cod_emp = ' + IntToStr(Varia.CodigoEmpresa) +
                             ' and i_cod_tab = ' + CADTabelaPrecoI_COD_TAB.AsString +
                             ' and i_tab_ser is not null ; ' +

                             ' update MOVTABELAPRECOCLIENTE ' +   //nao possui tabela servico
                             ' set i_tab_ser = null, i_cod_emp = null ' +
                             ' where i_cod_emp = ' + IntToStr(Varia.CodigoEmpresa) +
                             ' and i_tab_ser = ' + CADTabelaPrecoI_COD_TAB.AsString +
                             ' and i_cod_tab is null ; ' +

                             ' update MOVTABELAPRECOCLIENTE '   + //nao possui tabela servico
                             ' set i_tab_ser = null ' +
                             ' where i_cod_emp = ' + IntToStr(Varia.CodigoEmpresa) +
                             ' and i_tab_ser = ' + CADTabelaPrecoI_COD_TAB.AsString +
                             ' and i_cod_tab is not null ; ' +

                             ' Delete MovItensCusto where i_cod_emp = ' + IntToStr(Varia.CodigoEmpresa) +
                             ' and i_cod_tab = ' + CADTabelaPrecoI_COD_TAB.AsString + '; ' +

                             ' Delete MovTabelaPreco where i_cod_emp = ' + IntToStr(Varia.CodigoEmpresa) +
                             ' and i_cod_tab = ' + CADTabelaPrecoI_COD_TAB.AsString + '; ' +

                             ' Delete MovTabelaPrecoServico '+
                             ' Where i_cod_emp = '+IntToStr(Varia.CodigoEmpresa) +
                             ' and i_cod_tab = ' + CADTabelaPrecoI_COD_TAB.AsString + '; ' +

                             ' Delete CadTabelaPreco where i_cod_emp = ' + IntTostr(Varia.CodigoEmpresa) +
                             ' and i_cod_tab = ' + CADTabelaPrecoI_COD_TAB.AsString );
    EConsulta.AtualizaTabela;
  end;
end;


procedure TFTabelaPreco.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FTabelaPreco.HelpContext);
end;

Initialization
 RegisterClasses([TFTabelaPreco]);
end.
