unit APesaCaixa;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Componentes1, ExtCtrls, PainelGradiente, StdCtrls, Buttons, Localizacao,
  Mask, numericos, Grids, DBGrids, Tabela, Db, DBTables, unprodutos;

type
  TPesaCaixa  = function : Pchar; stdcall;
  TAbrePorta = function (Porta : string) :  integer; stdcall;
  TFechaPorta = function : integer; stdcall;
  TAlteraModeloBalanca = procedure ( TipoBalanca : Integer ); stdcall;
  TAlteraModoOperacao = procedure ( TipoOperacao: Integer ); stdcall;

type
  TFPesaCaixa = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    MovCaixa: TQuery;
    DataMovCaixa: TDataSource;
    DBGridColor1: TDBGridColor;
    PanelColor3: TPanelColor;
    ENroCaixa: Tnumerico;
    Label12: TLabel;
    EditLocaliza1: TEditLocaliza;
    SpeedButton4: TSpeedButton;
    Label11: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    epeso: Tnumerico;
    BFechar: TBitBtn;
    BitBtn1: TBitBtn;
    MovCaixaI_EMP_FIL: TIntegerField;
    MovCaixaI_NRO_CAI: TIntegerField;
    MovCaixaI_SEQ_PRO: TIntegerField;
    MovCaixaI_PES_CAI: TFloatField;
    MovCaixaD_DAT_ENT: TDateField;
    MovCaixaC_COD_PRO: TStringField;
    ConsultaPadrao1: TConsultaPadrao;
    Aux: TQuery;
    MovCaixaC_NOM_PRO: TStringField;
    MovCaixaC_COD_BAR: TStringField;
    MovCaixaC_NOM_USU: TStringField;
    Image1: TImage;
    Image2: TImage;
    MovCaixaC_TIP_CAI: TStringField;
    MovCaixaI_SEQ_CAI: TIntegerField;
    Label3: TLabel;
    PPeso: TPanelColor;
    LPeso: TLabel;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Label4: TLabel;
    MovCaixaD_DAT_PRO: TDateField;
    DataPro: TMaskEditColor;
    Produto: TQuery;
    ProximoNro: TQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure EditLocaliza1Select(Sender: TObject);
    procedure EditLocaliza1Retorno(Retorno1, Retorno2: String);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure DataProExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    LibHandle : THandle;
    _LePeso : TPesaCaixa;
    _AbrePortaSerial : TAbrePorta;
    _FechaPortaSerial : TFechaPorta;
    _AlteraModeloBalanca  : TAlteraModeloBalanca;
    _AlteraModoOperacao : TAlteraModoOperacao;

    unPro : TFuncoesProduto;
    SeqProAtual, unidadePadrao : string;
    Manual : boolean;
    procedure CarregaMovCaixa;
    function LePesoBalanca : Double;
    procedure AdicionaNovaCaixa;
    function BarraCaixa : String;
    procedure InicializaCaixas;
    function ProximoNroCaixa : integer;
  public
    procedure DigitacaoManual;
    procedure ImprimirEtiqueta;
  end;

var
  FPesaCaixa: TFPesaCaixa;

implementation

uses APrincipal, funsql, constantes, constmsg, funnumeros, funstring, fundata;

{$R *.DFM}
{$H+}

{ ****************** Na criação do Formulário ******************************** }
procedure TFPesaCaixa.FormCreate(Sender: TObject);
begin
 Manual := false;
 try
    // carrega a dll dinamicamente;
    LibHandle :=  LoadLibrary (PChar (Trim ('LePeso.dll')));
    // verifica se existe a dll
    if  LibHandle <=  HINSTANCE_ERROR then
      raise Exception.Create ('Dll para leitura da balança - "LePeso.dll" - não carregada');
    @_LePeso  :=  GetProcAddress (LibHandle,'_LePeso');
    @_AbrePortaSerial  :=  GetProcAddress (LibHandle,'_AbrePortaSerial');
    @_FechaPortaSerial  :=  GetProcAddress (LibHandle,'_FechaPortaSerial');
    @_AlteraModeloBalanca  := GetProcAddress (LibHandle,'_AlteraModeloBalanca');
    @_AlteraModoOperacao := GetProcAddress (LibHandle,'_AlteraModoOperacao');
    if (@_LePeso  = nil) or (@_AbrePortaSerial = nil) or
       (@_FechaPortaSerial = nil) or (@_AlteraModeloBalanca  = nil) or (@_AlteraModoOperacao = nil) then
      raise Exception.Create('Funcao da balança não encontrado na Dll');
  except
    aviso('erro');
  end;
  _AlteraModeloBalanca(1);  // modelo antigo 0 modelos novos
  _AlteraModoOperacao(0);      //O modo de operação determina a forma de leitura do
                            //valor do peso, que pode ser por solicitação do computador (parâmetro = 0) ou pelo pressionamento da tecla de impressão presente na balança (parâmetro = 1). O timeout para o modo 0 é de 2s e para o modo 1, de 4s.
  if _AbrePortaSerial(varia.PortaBalanca) <> 1 then
  begin
    aviso('Erro Abrindo Porta Serial');
  end;

 unPro := TFuncoesProduto.criar(self,FPrincipal.BaseDados);
 EditLocaliza1.AInfo.CampoCodigo := Varia.CodigoProduto;  // caso codigo pro ou codigo de barras
 CarregaMovCaixa;
 AdicionaSQLAbreTabela(Aux, ' select * from movcaixaestoque ' );
 ENroCaixa.AValor := proximoNroCaixa;
end;

{************ inicia o formulario e nao aciona a balanca **********************}
procedure  TFPesaCaixa.DigitacaoManual;
begin
  Manual := true;
  ENroCaixa.ReadOnly := false;
  self.ShowModal;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFPesaCaixa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  _FechaPortaSerial;
  FreeLibrary (LibHandle);
  MovCaixa.close;
  aux.close;
  unpro.free;
  Action := CaFree;
end;

procedure TFPesaCaixa.BFecharClick(Sender: TObject);
begin
  self.close;
end;

procedure TFPesaCaixa.CarregaMovCaixa;
begin
  LimpaSQLTabela(MovCaixa);
  AdicionaSQLTabela(MovCaixa, ' select * from movcaixaestoque mov, cadprodutos as pro, cadusuarios usu' +
                              ' where mov.i_emp_fil = ' + IntToStr(varia.CodigoEmpFil)  +
                              ' and d_dat_ent = ' + SQLTextoDataAAAAMMMDD(date) +
                              ' and mov.i_seq_pro = pro.i_seq_pro '+
                              ' and pro.i_cod_emp = ' + Inttostr(varia.CodigoEmpresa) +
                              ' and usu.i_emp_fil = '+ IntToStr(varia.CodigoEmpFil)  +
                              ' and usu.i_cod_usu = mov.i_cod_usu' +
                              ' order by mov.i_seq_cai ' );
  AbreTabela(MovCaixa);
  MovCaixa.Last;
end;


function  TFPesaCaixa.LePesoBalanca : Double;
var
  PesoBal, Valor : String;
begin
  Image2.Visible := true;
  Image2.Refresh;
  result := 0;
  try
    PesoBal :=  _LePeso;
    PesoBal := SubstituiStr(PesoBal,'*','');
    Valor := DeletaEspacoDE(PesoBal);
    valor := copy(valor, 1, length(valor) -2 );
    PesoBal := copy(valor, 1, length(valor) -2 );
    PesoBal := PesoBal + ',' + copy(valor, length(valor) -1, 2 );
    Result := StrToFloat(pesobal);
  except
    result := 0;
  end;
  Image2.Visible := false;
  Image2.Refresh;
end;

procedure TFPesaCaixa.BitBtn1Click(Sender: TObject);
begin
  if (EditLocaliza1.Text <> '') and ( ENroCaixa.AValor <> 0) and (DataPro.Text[1] <> ' ') then
  begin
    if not Manual then
    begin
      epeso.AValor := LePesoBalanca;
      LPeso.Caption := 'Peso = ' +  FormatFloat(varia.MascaraQtd,epeso.avalor) + 'Kg';
      PanelColor1.Enabled := false;
      PanelColor2.Enabled := false;
      PPeso.Visible := true;
    end
    else
      if ( epeso.AValor <> 0) then
      begin
        AdicionaNovaCaixa;
        InicializaCaixas;
        ENroCaixa.SetFocus;
      end
      else
        aviso('Peso inválido');
  end
  else
  begin
    aviso('Valor inválido');
    Epeso.SetFocus;
  end;
end;

procedure TFPesaCaixa.AdicionaNovaCaixa;
begin
  Aux.Insert;
  Aux.FieldByName('I_EMP_FIL').AsInteger := varia.CodigoEmpFil;
  Aux.FieldByName('I_NRO_CAI').AsInteger := trunc(ENroCaixa.AValor);
  Aux.FieldByName('I_SEQ_CAI').AsInteger := trunc(ENroCaixa.AValor);
  Aux.FieldByName('C_TIP_CAI').AsString := 'N';  // N nova, C cancelada, D devolvida
  Aux.FieldByName('I_SEQ_PRO').AsInteger := StrToint(SeqProAtual);
  Aux.FieldByName('C_COD_PRO').AsString := EditLocaliza1.text;
  Aux.FieldByName('I_PES_CAI').AsFloat := epeso.AValor;
  Aux.FieldByName('D_DAT_ENT').AsDateTime := date;
  Aux.FieldByName('D_DAT_PRO').AsDateTime := strtodate(DataPro.text);
  Aux.FieldByName('C_SIT_CAI').AsString := 'A';
  Aux.FieldByName('I_COD_USU').AsInteger:= varia.CodigoUsuario;
  aux.FieldByName('C_COD_BAR').AsString := BarraCaixa;
  Aux.FieldByName('D_ULT_ALT').AsDateTime := date;
  Aux.post;

  unPro.BaixaProdutoEstoque( StrToint(SeqProAtual), varia.OperacaoEstoqueInicial,
                             0,0,varia.MoedaBase, 0, date,epeso.AValor,0,'kg',unidadePadrao);

end;

procedure  TFPesaCaixa.InicializaCaixas;
begin
  CarregaMovCaixa;
  ENroCaixa.AValor := proximoNroCaixa;
  epeso.AValor := 0;
end;

procedure TFPesaCaixa.EditLocaliza1Select(Sender: TObject);
begin
  EditLocaliza1.ASelectValida.Clear;
  EditLocaliza1.ASelectValida.add(  ' Select Pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
                                    ' pro.I_SEQ_PRO, mov.C_COD_BAR ' +
                                    ' From cadprodutos as pro, ' +
                                    ' MovQdadeProduto as mov ' +
                                    ' Where pro.c_cod_uni in (''kg'',''tn'', ''gr'' ) ' +
                                    ' and pro.I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                                    ' and ' + varia.CodigoProduto + ' = ''@''' +
                                    ' and pro.C_KIT_PRO = ''P'' ' +
                                    ' and pro.c_cod_cla like ''' + Varia.ClassificacaoPadraoVenda + '%''' +
                                    ' and pro.I_seq_pro = Mov.I_seq_pro ' +
                                    ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil) );
  EditLocaliza1.ASelectLocaliza.Clear;
  EditLocaliza1.ASelectLocaliza.add(' Select pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
                                    ' pro.I_SEQ_PRO, mov.C_COD_BAR ' +
                                    ' from cadprodutos as pro, ' +
                                    ' MovQdadeProduto as mov ' +
                                    ' Where pro.c_cod_uni in (''kg'',''tn'', ''gr'' ) ' +
                                    ' and pro.I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                                    ' and pro.c_nom_pro like ''@%''' +
                                    ' and pro.C_KIT_PRO = ''P'' ' +
                                    ' and pro.c_cod_cla like ''' + Varia.ClassificacaoPadraoVenda + '%''' +
                                    ' and pro.I_seq_pro = Mov.I_seq_pro ' +
                                    ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil));
end;

procedure TFPesaCaixa.EditLocaliza1Retorno(Retorno1, Retorno2: String);
begin
  if Retorno1 <> '' then
  begin
    AdicionaSQLAbreTabela( Produto, ' Select * from cadprodutos ' +
                                    ' where i_seq_pro = ' + Retorno1 +
                                    ' and i_cod_emp = ' + Inttostr(varia.CodigoEmpresa) );
    SeqProAtual := Retorno1;
    unidadePadrao := retorno2;
    ENroCaixa.AValor := proximoNroCaixa;
    DataPro.Clear;
  end;
end;


procedure TFPesaCaixa.BitBtn2Click(Sender: TObject);
begin
  AdicionaNovaCaixa;
  ImprimirEtiqueta;
  InicializaCaixas;
  PanelColor1.Enabled := true;
  PanelColor2.Enabled := true;
  PPeso.Visible := false;
end;

procedure TFPesaCaixa.BitBtn3Click(Sender: TObject);
begin
  PanelColor1.Enabled := true;
  PanelColor2.Enabled := true;
  PPeso.Visible := false;
  epeso.AValor := 0;
end;

procedure TFPesaCaixa.DataProExit(Sender: TObject);
begin
  if DataPro.Text[1] <> ' ' then
  begin
    try
      strtodate(DataPro.text);
    except
      aviso('Data Inválida');
      DataPro.setfocus;
    end;
  end;
end;


function TFPesaCaixa.BarraCaixa : String;
begin
   result := '02' + AdicionaCharE('0',produto.fieldByname('C_CLA_FIS').AsString,14) +  // tipo barra
             '11' +  DataToStrFormato(AAMMDD,strtodate(datapro.text) ,#0) + //data producao
             '15' + DataToStrFormato(AAMMDD,IncDia(strtodate(datapro.text),produto.fieldByname('I_DAT_VAL').AsInteger),#0) + // data validade
             '37' + AdicionaCharE('0',produto.fieldByname('I_QTD_CAI').AsString,2) + //quantidade de peca caixa
             char(06) + '3102' + AdicionaCharE('0',DeletaChars(DeletaChars(FormatFloat(varia.MascaraValor, epeso.Avalor),'.' ),','),6); // peso
end;

function TFPesaCaixa.ProximoNroCaixa : integer;
begin
  result := 0;
  if SeqProAtual <> '' then
  begin
    AdicionaSQLAbreTabela(ProximoNro, ' select max(i_nro_cai) nro from movcaixaestoque  ' +
                                      ' where i_emp_fil = ' + Inttostr(Varia.CodigoEmpFil) +
                                      ' and i_seq_pro = ' + SeqProAtual );
    result :=  ProximoNro.fieldbyname('nro').AsInteger + 1;
  end;
end;


procedure TFPesaCaixa.ImprimirEtiqueta;
var
 texto : TextFile;
 laco : integer;
 Barra : string;
 texto1 : tstringList;
begin
    assignFile(texto, 'lpt1');
    Rewrite(texto);
    writeln(texto, '');
    Writeln(texto, 'FR"GERMÂNIA"');
    Writeln(texto, '?');

   barra := BarraCaixa;
//   aviso(barra);
   writeln(texto, uppercase(Produto.fieldByname('C_NOM_PRO').AsString));
   writeln(texto, AdicionaCharE('0',inttostr(trunc(ENroCaixa.AValor)),5));
   writeln(texto, datetostr(IncDia(strtodate(datapro.text),produto.fieldByname('I_DAT_VAL').AsInteger)));
   writeln(texto, datapro.text);
   writeln(texto, FormatFloat(Varia.MascaraQtd + ' KG', epeso.AValor));
   writeln(texto,AdicionaCharE('0',produto.fieldByname('I_QTD_CAI').AsString,2) );
   writeln(texto, barra);
   writeln(texto, 'P1');
   CloseFile(texto);

end;


procedure TFPesaCaixa.FormShow(Sender: TObject);
begin
  EditLocaliza1.SetFocus;
end;

Initialization
 RegisterClasses([TFPesaCaixa]);
end.
