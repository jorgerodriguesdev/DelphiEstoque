unit ARequisicaoDeMaterial;
{                   Autor: Leonardo Emanuel Pretti
          Data da Criação: 27/03/2001
                   Função: Controle de Material no Almoxarifado                  object Label3: TLabel
             Alterado por: Sergio
        Data da Alteração:
      Motivo da Alteração:
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  ExtCtrls, PainelGradiente, ConstMsg, StdCtrls, Buttons, BotaoCadastro, Componentes1,
  Db, DBTables, Grids, DBGrids, Tabela, DBKeyViolation, Mask, DBCtrls,
  Localizacao, ComCtrls, UnRequisicaoMaterial, unProdutos, UCrpe32;

type
  TFRequisicaoDeMaterial = class(TFormularioPermissao)
    PanelColor1: TPanelColor;
    Grade: TGridIndice;
    CadReqMaterial: TSQL;
    Procura: TConsultaPadrao;
    DataCadReqMaterial: TDataSource;
    CadReqMaterialI_EMP_FIL: TIntegerField;
    CadReqMaterialI_COD_REQ: TIntegerField;
    CadReqMaterialI_COD_USU: TIntegerField;
    CadReqMaterialI_USU_REQ: TIntegerField;
    CadReqMaterialL_OBS_REQ: TMemoField;
    CadReqMaterialD_DAT_REQ: TDateField;
    CadReqMaterialD_ULT_ALT: TDateField;
    CadReqMaterialC_SIT_REQ: TStringField;
    MovReqMaterial: TQuery;
    DataMovReqMaterial: TDataSource;
    MovReqMaterialI_EMP_FIL2: TIntegerField;
    MovReqMaterialI_COD_REQ2: TIntegerField;
    MovReqMaterialI_SEQ_PRO2: TIntegerField;
    MovReqMaterialC_COD_UNI2: TStringField;
    MovReqMaterialN_QTD_PRO2: TFloatField;
    Aux: TQuery;
    MovReqMaterialC_COD_PRO: TStringField;
    CadProdutos: TQuery;
    Produtos: TQuery;
    MovReqMaterialNomeProduto: TStringField;
    ELocalizaProduto: TDBEditLocaliza;
    Label1: TLabel;
    LocalizaRequerente: TDBEditLocaliza;
    SpeedLocaliza: TSpeedButton;
    Label3: TLabel;
    EditDatRequsicao: TDBEditColor;
    Label4: TLabel;
    DBMemoOBS: TDBMemoColor;
    Shape1: TShape;
    Shape2: TShape;
    Label5: TLabel;
    Label2: TLabel;
    DBText1: TDBText;
    Shape3: TShape;
    Label6: TLabel;
    Label7: TLabel;
    ValidaGravacao1: TValidaGravacao;
    Tempo: TPainelTempo;
    PanelColor3: TPanelColor;
    BotaoFechar1: TBotaoFechar;
    BotaoCancelar1: TBotaoCancelar;
    BotaoGravar1: TBotaoGravar;
    BTCadastrar: TBitBtn;
    BBImprimir: TBitBtn;
    Label14: TLabel;
    EditLocaliza2: TEditLocaliza;
    SpeedButton2: TSpeedButton;
    Label9: TLabel;
    CadReqMaterialI_NRO_ORS: TIntegerField;
    CadReqMaterialI_NRO_ORP: TIntegerField;
    CadReqMaterialI_NRO_NOF: TIntegerField;
    CadReqMaterialI_NRO_PED: TIntegerField;
    Label11: TLabel;
    Label12: TLabel;
    DBEditColor4: TDBEditColor;
    Label8: TLabel;
    LocPedido: TDBEditLocaliza;
    Label10: TLabel;
    DBEditColor2: TDBEditColor;
    Label13: TLabel;
    DBEditColor3: TDBEditColor;
    MovReqMaterialD_ULT_ALT: TDateField;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BotaoFechar1Click(Sender: TObject);
    procedure CadReqMaterialBeforePost(DataSet: TDataSet);
    procedure GradeEnter(Sender: TObject);
    procedure BTCadastrarClick(Sender: TObject);
    procedure MovReqMaterialAfterInsert(DataSet: TDataSet);
    procedure GradeColExit(Sender: TObject);
    procedure ELocalizaProdutoSelect(Sender: TObject);
    procedure ELocalizaProdutoRetorno(Retorno1, Retorno2: String);
    procedure GradeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GradeKeyPress(Sender: TObject; var Key: Char);
    procedure MovReqMaterialAfterPost(DataSet: TDataSet);
    procedure MovReqMaterialBeforePost(DataSet: TDataSet);
    procedure ELocalizaProdutoEnter(Sender: TObject);
    procedure MovReqMaterialBeforeInsert(DataSet: TDataSet);
    procedure GradeExit(Sender: TObject);
    procedure BotaoCancelar1Atividade(Sender: TObject);
    procedure BotaoCancelar1DepoisAtividade(Sender: TObject);
    procedure LocalizaRequerenteChange(Sender: TObject);
    procedure MovReqMaterialAfterDelete(DataSet: TDataSet);
    procedure MovReqMaterialBeforeEdit(DataSet: TDataSet);
    procedure GradeCellClick(Column: TColumn);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BotaoGravar1DepoisAtividade(Sender: TObject);
    procedure BBImprimirClick(Sender: TObject);
    procedure LocPedidoSelect(Sender: TObject);
  private
    rel : TCrpe;
    UnReqMat : TFuncoesReqMaterial;
    UnProduto : TFuncoesProduto;
    function verificaProduto(var CodPro, CodUni : string) : Boolean;
    procedure Movimentacoes;
  public
    procedure NovaRequiciaoDeMaterial;
  end;

var
  FRequisicaoDeMaterial: TFRequisicaoDeMaterial;

implementation
   uses APrincipal, Constantes, funsql, ALocalizaProdutos,
  AImprimeReqMaterial;
{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFRequisicaoDeMaterial.FormCreate(Sender: TObject);
begin
  UnReqMat := TFuncoesReqMaterial.Criar(self, FPrincipal.BaseDados);
  UnProduto := TFuncoesProduto.Criar(self, FPrincipal.BaseDados);
  Self.HelpFile := Varia.PathHelp + 'MAGeal.HLP>janela';{ chamar a rotina de atualização de menus }
  EditLocaliza2.text := IntToStr(varia.CodOpeReqMaterial);
  EditLocaliza2.Atualiza;
  label13.Visible := ConfigModulos.PCP;
  DBEditColor3.Visible := ConfigModulos.PCP;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFRequisicaoDeMaterial.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 CadReqMaterial.Close;{ fecha tabelas }
 MovReqMaterial.Close;
 UnReqMat.free;
 UnProduto.free;
 rel.free;
 Action := CaFree;{ chamar a rotina de atualização de menus }
end;

{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFRequisicaoDeMaterial.BotaoFechar1Click(Sender: TObject);
begin
  self.close;
end;

{************************ verifica se pode ou nao fechar o formulario ********}
procedure TFRequisicaoDeMaterial.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    CanClose := BTCadastrar.Enabled;
end;

{((((((((((((((((((((((((( (((((((((((((((((((((((((((((((((((((((((((((((((((
                        Acoes da Tabela
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{ ************************** Grava o dia da alteração ************************ }
procedure TFRequisicaoDeMaterial.CadReqMaterialBeforePost(DataSet: TDataSet);
begin
  CadReqMaterialD_ULT_ALT.AsDateTime := date;
end;

{ ****** Passa os dados I_EMP_FIL e I_COD_REQ da Tabela Cad para a Mov ******* }
procedure TFRequisicaoDeMaterial.MovReqMaterialAfterInsert(
  DataSet: TDataSet);
begin
  MovReqMaterialI_EMP_FIL2.AsInteger:=CadReqMaterialI_EMP_FIL.AsInteger;
  MovReqMaterialI_COD_REQ2.AsInteger:=CadReqMaterialI_COD_REQ.AsInteger;
end;

{******************* Antes do Insert ***************************************}
procedure TFRequisicaoDeMaterial.MovReqMaterialBeforeInsert(
  DataSet: TDataSet);
begin
  if grade.Focused then
    grade.SelectedIndex := 0;
end;

{ ******** Adiciona uma nova linha de registros no grid para gravacao ******** }
procedure TFRequisicaoDeMaterial.MovReqMaterialAfterPost(
  DataSet: TDataSet);
begin
  AtualizaSQLTabela(MovReqMaterial); //Limpa tabela
  MovReqMaterial.Last;               //Passa para uma nova linha
  LocalizaRequerenteChange(nil);
end;

{ ********* Evita que uma linha fique sem o C_COD_PRO e o I_SEQ_PRO ********** }
procedure TFRequisicaoDeMaterial.MovReqMaterialBeforePost(
  DataSet: TDataSet);
begin
  MovReqMaterialD_ULT_ALT.AsDateTime := date;
  if MovReqMaterialC_COD_PRO.IsNull or MovReqMaterialN_QTD_PRO2.IsNull then
    abort;
  if not UnProduto.ValidaUnidade.ValidaUnidade(UnProduto.UnidadePadrao(MovReqMaterialI_SEQ_PRO2.AsInteger),MovReqMaterialC_COD_UNI2.AsString) then
  begin
    Grade.SetFocus;
    abort;
  end;
end;

{************************ Depois do delete ***********************************}
procedure TFRequisicaoDeMaterial.MovReqMaterialAfterDelete(
  DataSet: TDataSet);
begin
  LocalizaRequerenteChange(nil);
end;

{************************************* antes do edit *************************}
procedure TFRequisicaoDeMaterial.MovReqMaterialBeforeEdit(
  DataSet: TDataSet);
begin
  Grade.Columns[3].PickList := UnProduto.ValidaUnidade.UnidadesParentes(MovReqMaterialC_COD_UNI2.AsString);
end;

{((((((((((((((((((((((((( (((((((((((((((((((((((((((((((((((((((((((((((((((
                        Acoes do Grid
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{ ********************* Ao descer para a Grade ******************************* }
procedure TFRequisicaoDeMaterial.GradeEnter(Sender: TObject);
begin
  if CadReqMaterial.State in [dsEdit, dsInsert ] then
  begin
     If (CadReqMaterialI_COD_REQ.IsNull) or (LocalizaRequerente.Field.IsNull) then
      begin                                  //Verifica se os Campos estão preenchidos
        aviso('Faltam dados na Requisição'); //Msg de erro de algum dado estiver nulo
        if LocalizaRequerente.Enabled then
          LocalizaRequerente.SetFocus;
      end
      else
      if not (MovReqMaterial.Active) then
      begin
        LimpaSQLTabela(MovReqMaterial);
        UnReqMat.LocalizaMovRequisicao( MovReqMaterial,CadReqMaterialI_EMP_FIL.AsInteger,CadReqMaterialI_COD_REQ.AsInteger);
        MovReqMaterial.open;
      end;
  end;
end;

{ Criar uma seleção para verificar se o C_COD_PRO, fornecido existe e é válido }
procedure TFRequisicaoDeMaterial.GradeColExit(Sender: TObject);
  var  CodProduto, CodUnidade : string;
begin
  if MovReqMaterial.State in [dsInsert, dsEdit] then
  begin
    CodProduto := MovReqMaterialC_COD_PRO.AsString;
    case grade.SelectedIndex of
        0 : begin                      //"0" porque é primeira coluna da Grade
             if verificaProduto (CodProduto, CodUnidade) then
             begin
                 ELocalizaProdutoSelect(nil);
                 ELocalizaProduto.AAbreLocalizacao;
             end
             else
             begin
                 MovReqMaterialI_SEQ_PRO2.AsInteger := strtoint(CodProduto);
                 MovReqMaterialC_COD_UNI2.AsString := CodUnidade;
             end;
             Grade.Columns[3].PickList := UnProduto.ValidaUnidade.UnidadesParentes(MovReqMaterialC_COD_UNI2.AsString);
          end;
     end;
  end;
end;

{ *************** Chama a consulta pressionando F3 (key 114) ******************}
procedure TFRequisicaoDeMaterial.GradeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if (Key = 114)  and (grade.SelectedIndex = 0) then  // localiza produtos pressionado F3
     begin
       if not (MovReqMaterial.State in [ DsEdit, dsInsert ]) then
         MovReqMaterial.Insert;
       ELocalizaProdutoSelect(nil);
       ELocalizaProduto.AAbreLocalizacao;
     end;
  if ( not MovReqMaterial.IsEmpty) and (key = 46) then
    if Confirmacao(CT_DeletaRegistro) then
      MovReqMaterial.delete;

  if key = 45 then
  begin
    MovReqMaterial.Append;
    key := 0;
  end;
end;

{ ********************* Subtitui o ponto por vírgula ************************* }
procedure TFRequisicaoDeMaterial.GradeKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = '.' then
     key := ',';   //substitui o ponto pela vírgula, para poder ser usada no grid
end;

{ ********************* na saida do gride ************************************ }
procedure TFRequisicaoDeMaterial.GradeExit(Sender: TObject);
begin
   if MovReqMaterial.State in [dsInsert, dsEdit ] then
     if (MovReqMaterialC_COD_PRO.IsNull or MovReqMaterialN_QTD_PRO2.IsNull) and (not BotaoCancelar1.Focused) then
       grade.SetFocus
     else
       if MovReqMaterial.State in [dsEdit, dsInsert] then
         MovReqMaterial.post;
end;

{********************** No click de uma coluna *******************************}
procedure TFRequisicaoDeMaterial.GradeCellClick(Column: TColumn);
begin
  if Grade.SelectedIndex = 3 then
    if ( not (MovReqMaterial.State in [dsEdit, dsinsert])) and (MovReqMaterialC_COD_UNI2.AsString <> '') then
      MovReqMaterial.edit;
end;

{((((((((((((((((((((((((( (((((((((((((((((((((((((((((((((((((((((((((((((((
                        Acoes do Grid
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{ **************** Fornece os dados necessários aos ítens ******************** }
procedure TFRequisicaoDeMaterial.BTCadastrarClick(Sender: TObject);
begin
  MovReqMaterial.close;
  NovaRequiciaoDeMaterial;
  LocalizaRequerente.SetFocus;
end;

{************************* Antes do click cancelar *************************}
procedure TFRequisicaoDeMaterial.BotaoCancelar1Atividade(Sender: TObject);
begin
  UnReqMat.ExcluirRequisicao(CadReqMaterialI_EMP_FIL.AsInteger,CadReqMaterialI_COD_REQ.AsInteger);
end;

{*************************  Depois do click cancelar *************************}
procedure TFRequisicaoDeMaterial.BotaoCancelar1DepoisAtividade(
  Sender: TObject);
begin
  CadReqMaterial.close;
  MovReqMaterial.close;
  BotaoGravar1.Enabled := false;
  Label7.Caption := '';
end;




{ ***************** Grava o intem I_COD_REQ e reedita a tabela *************** }
procedure TFRequisicaoDeMaterial.NovaRequiciaoDeMaterial;
  var CodigoReq : Integer;
begin
  if varia.CodOpeReqMaterial = 0 then
  begin
    aviso('Config. dados do Sistema');
    PanelColor1.Enabled := false;
  end;
  Label7.Caption := '';
  AdicionaSQLAbreTabela (CadReqMaterial, ' select * from Cadrequisicaomaterial ');
  CadReqMaterial.Insert;
  CadReqMaterialD_DAT_REQ.AsDateTime := date;              //D_DAT_REQ recebe a data do dia
  CadReqMaterialI_EMP_FIL.AsInteger := Varia.CodigoEmpFil;
  CadReqMaterialI_COD_REQ.AsInteger := ProximoCodigoFilial('CadRequisicaoMaterial','i_cod_req','i_emp_fil',varia.CodigoEmpFil,FPrincipal.BaseDados);
  CadReqMaterialI_COD_USU.AsInteger := Varia.CodigoUsuario;
  CadReqMaterialC_SIT_REQ.AsString := 'E';
  CodigoReq := CadReqMaterialI_COD_REQ.AsInteger;
  CadReqMaterial.Post;
  UnReqMat.LocalizaCadRequisicao(CadReqMaterial,CadReqMaterialI_EMP_FIL.AsInteger, CadReqMaterialI_COD_REQ.AsInteger);
  CadReqMaterial.Edit;
  BotaoGravar1.Enabled := false;
end;

{ ******** Função para saber se o nº fornecido no C_COD_PRO é válido ********* }
function  TFRequisicaoDeMaterial.verificaProduto(var CodPro, CodUni : string) : Boolean;
begin
  AdicionaSQLAbreTabela(aux, ' select * from cadprodutos ' +
                             ' where c_cod_pro = ''' + CodPro  + '''' +
                             ' and i_cod_emp = ' + Inttostr(varia.CodigoEmpresa));
  result := Aux.Eof;                               //retorna com um dado que é "V" ou "F"
  CodPro := Aux.fieldByname('i_seq_pro').AsString;
  CodUni := Aux.fieldByname('c_cod_uni').AsString;
  aux.close;
end;

{ *********** Faz a select para abrir a localização de produtos ************** }
procedure TFRequisicaoDeMaterial.ELocalizaProdutoSelect(Sender: TObject);
begin
  ELocalizaProduto.ASelectValida.Clear;
  ELocalizaProduto.ASelectValida.add(  ' Select Pro.C_COD_PRO, Pro.C_NOM_PRO, Pro.C_COD_UNI, ' +
                                       ' Pro.I_SEQ_PRO ' +
                                       ' From CadProdutos as Pro ' +
                                       ' Where Pro.I_COD_EMP = ' + IntToStr(Varia.CodigoEmpresa) +
                                       ' and ' + Varia.CodigoProduto + ' = ''@''' +
                                       ' and Pro.C_KIT_PRO = ''p'' ' );
  ELocalizaProduto.ASelectLocaliza.Clear;
  ELocalizaProduto.ASelectLocaliza.add( ' Select Pro.C_COD_PRO, Pro.C_NOM_PRO, Pro.C_COD_UNI, ' +
                                       ' Pro.I_SEQ_PRO ' +
                                       ' From CadProdutos as Pro ' +
                                       ' where Pro.I_COD_EMP = ' + IntToStr(varia.CodigoEmpresa) +
                                       ' and Pro.C_NOM_PRO like ''@%''' +
                                       ' and Pro.C_KIT_PRO = ''P'' ' );
end;

{ ****** A tabela Mov recebe o I_SEQ_PRO e o C_COD_UNI automaticamente ******* }
procedure TFRequisicaoDeMaterial.ELocalizaProdutoRetorno(Retorno1,
  Retorno2: String);
begin
  if MovReqMaterial.State in [ dsEdit, dsInsert ] then
    if Retorno2 <> '' then
    begin
      MovReqMaterialI_SEQ_PRO2.AsInteger := strtoint(Retorno2);
      MovReqMaterialC_COD_UNI2.AsString := Retorno1;
    end;
end;

procedure TFRequisicaoDeMaterial.ELocalizaProdutoEnter(Sender: TObject);
begin
  Grade.SetFocus;
end;

procedure TFRequisicaoDeMaterial.LocalizaRequerenteChange(Sender: TObject);
begin
 if CadReqMaterial.State in [dsInsert, dsEdit] then
   ValidaGravacao1.execute;
 BotaoGravar1.Enabled := not MovReqMaterial.IsEmpty;
end;

procedure TFRequisicaoDeMaterial.Movimentacoes;
var
  Unidade:String;
begin
  MovReqMaterial.DisableControls;
  begin
    Tempo.execute('Movimentando Estoque...');
    MovReqMaterial.First;
    while not MovReqMaterial.Eof do
    begin
      Unidade := UnProduto.UnidadePadrao(MovReqMaterialI_SEQ_PRO2.AsInteger);
      UnProduto.BaixaProdutoEstoque( MovReqMaterialI_SEQ_PRO2.AsInteger,
                                     strtoint(EditLocaliza2.text),
                                     0, 0, Varia.MoedaBase,0,date,
                                     MovReqMaterialN_QTD_PRO2.AsFloat,
                                     0, MovReqMaterialC_COD_UNI2.AsString,Unidade);
      MovReqMaterial.Next;
    end;
    Tempo.fecha;
  end;
  MovReqMaterial.EnableControls;
end;

procedure TFRequisicaoDeMaterial.BotaoGravar1DepoisAtividade(
  Sender: TObject);
begin
  Movimentacoes;
end;


procedure TFRequisicaoDeMaterial.BBImprimirClick(Sender: TObject);
var
  TextoDoc : string;
  NroDoc : integer;
begin
  if CadReqMaterialI_NRO_ORS.AsInteger <> 0 then
  begin
    TextoDoc := 'Nro OS :';
    NroDoc := CadReqMaterialI_NRO_ORS.AsInteger;
  end
  else
    if CadReqMaterialI_NRO_ORP.AsInteger <> 0 then
    begin
      TextoDoc := 'Nro OP :';
      NroDoc := CadReqMaterialI_NRO_ORP.AsInteger;
    end
    else
      if CadReqMaterialI_NRO_PED.AsInteger <> 0 then
      begin
        TextoDoc := 'Nro Pedido :';
        NroDoc := CadReqMaterialI_NRO_PED.AsInteger;
      end
      else
        if CadReqMaterialI_NRO_NOF.AsInteger <> 0 then
        begin
          TextoDoc := 'Nro NF :';
          NroDoc := CadReqMaterialI_NRO_NOF.AsInteger;
        end;

  case varia.TipoImpGra_matReqMat of
    1 : UnReqMat.ImprimeRequisicoes(CadReqMaterialI_Cod_Req.AsInteger, varia.CodigoEmpFil);
    2 : begin
         FImprimeReqMaterial := TFImprimeReqMaterial.CriarSDI(application,'',FPrincipal.VerificaPermisao('FImprimeReqMaterial'));
         FImprimeReqMaterial.CarregaReqmateria(CadReqMaterialI_Cod_Req.AsInteger,CadReqMaterialI_Emp_Fil.AsInteger,NroDoc, varia.NomeFilial,TextoDoc );
        end;
    3 : Begin
            if rel <> nil then
              rel.free;

            rel := TCrpe.Create(self);
            rel.ReportName := varia.PathRel + 'Diverso\RequisicaoMaterial.rpt';
            rel.Connect.Retrieve;
            rel.Connect.DatabaseName := varia.AliasBAseDados;
            rel.Connect.ServerName := varia.AliasRelatorio;
            rel.WindowState := wsMaximized;
            rel.ParamFields.Retrieve;
            rel.ParamFields[0].Value := CadReqMaterialI_COD_REQ.AsString;
            rel.ParamFields[1].Value := CadReqMaterialI_EMP_FIL.AsString;
            rel.ParamFields[2].value := varia.NomeFilial;
            rel.execute;
         end;
    end;
end;

procedure TFRequisicaoDeMaterial.LocPedidoSelect(Sender: TObject);
begin
  LocPedido.ASelectLocaliza.clear;
  LocPedido.ASelectValida.Clear;
  LocPedido.ASelectLocaliza.add(' Select * from cadorcamentos ped, cadClientes cli ' +
                                ' where ped.i_emp_fil = ' + inttostr(varia.CodigoEmpFil) +
                                ' and ped.i_cod_cli = cli.i_cod_cli ' +
                                ' and cli.c_nom_cli like ''@%'' ' +
                                ' and ped.c_fla_sit = ''A'' ' +
                                ' and ped.c_tip_cad = ''P'' ' );
  LocPedido.ASelectValida.add(' Select * from cadorcamentos ped, cadClientes cli ' +
                                ' where ped.i_emp_fil = ' + inttostr(varia.CodigoEmpFil) +
                                ' and ped.i_cod_cli = cli.i_cod_cli ' +
                                ' and ped.i_nro_ped = @ '+
                                ' and ped.c_fla_sit = ''A'' '  +
                                ' and ped.c_tip_cad = ''P'' ' );
end;

Initialization
  RegisterClasses([TFRequisicaoDeMaterial]);
end.

