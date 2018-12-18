unit AProdutosFornecedores;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Grids, DBGrids, Tabela, BotaoCadastro, StdCtrls, Buttons, Componentes1,
  ExtCtrls, PainelGradiente, Localizacao, Db, DBTables, ComCtrls,
  DBKeyViolation;

type
  TFProdutosFornecedores = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    BFechar: TBitBtn;
    Localiza: TConsultaPadrao;
    PanelColor3: TPanelColor;
    Grade: TGridIndice;
    data1: TCalendario;
    Data2: TCalendario;
    RadioGroup1: TRadioGroup;
    PanelColor4: TPanelColor;
    Label1: TLabel;
    ELProduto: TEditLocaliza;
    SpeedButton1: TSpeedButton;
    Label2: TLabel;
    PFornecedor: TPanelColor;
    Label4: TLabel;
    SpeedButton2: TSpeedButton;
    Label5: TLabel;
    EFornecedor: TEditLocaliza;
    Label6: TLabel;
    MovForPro: TQuery;
    DataMovForPro: TDataSource;
    BitBtn1: TBitBtn;
    CUltCompra: TCheckBox;
    CValorQdade: TCheckBox;
    Label24: TLabel;
    EditLocaliza5: TEditLocaliza;
    SpeedButton5: TSpeedButton;
    Label25: TLabel;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure ELProdutoSelect(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure EFornecedorRetorno(Retorno1, Retorno2: String);
    procedure GradeOrdem(Ordem: String);
    procedure BitBtn1Click(Sender: TObject);
    procedure CUltCompraClick(Sender: TObject);
    procedure EditLocaliza5Select(Sender: TObject);
    procedure EditLocaliza5Retorno(Retorno1, Retorno2: String);
    procedure BBAjudaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    OrderBy : string;
    ProdutoAtual, FornecedorAtual : string;
    procedure PosicionaFornecedor(SequencialProduto, CodigoFornecedor : String);
    { Private declarations }
  public
    Procedure CarregaProduto( SequencialProduto : String );
  end;

var
  FProdutosFornecedores: TFProdutosFornecedores;

implementation

uses APrincipal, Constantes, FunSql, ConstMsg, ANovoCliente, fundata,
  APontoPedido, FunSistema, Funobjeto;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFProdutosFornecedores.FormCreate(Sender: TObject);
begin
  EditLocaliza5.Text := IntToStr(varia.CodigoEmpFil);
  EditLocaliza5.atualiza;
  data1.DateTime := DecMes(date,3);
  Data2.DateTime := date;
  ELProduto.AInfo.CampoCodigo := Varia.CodigoProduto;  // caso codigo pro ou codigo de barras
  OrderBy := ' Order by mov.d_dat_com ';
  grade.Columns[1].Visible := false;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFProdutosFornecedores.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações do Localiza
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{*************Carrega a Select para localizar e Validar o produto**************}
procedure TFProdutosFornecedores.ELProdutoSelect(Sender: TObject);
begin
  ELProduto.ASelectValida.add(' Select Pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
                              ' pro.I_SEQ_PRO, mov.C_COD_BAR ' +
                              ' From cadprodutos as pro, ' +
                              ' MovQdadeProduto as mov ' +
                              ' Where I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                              ' and ' + varia.CodigoProduto + ' = ''@''' +
                              ' and C_KIT_PRO = ''P'' ' +
                              ' and pro.I_seq_pro = Mov.I_seq_pro ' +
                              ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil));

  ELProduto.ASelectLocaliza.add(' Select pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
                                ' pro.I_SEQ_PRO, mov.C_COD_BAR ' +
                                ' from cadprodutos as pro, ' +
                                ' MovQdadeProduto as mov ' +
                                ' Where I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                                ' and c_nom_pro like ''@%''' +
                                ' and C_KIT_PRO = ''P'' ' +
                                ' and pro.I_seq_pro = Mov.I_seq_pro ' +
                                ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil) +
                                ' order by c_nom_pro asc');

end;



{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Acoes do Fornecedor
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{******************Posicona o fornecedor conforme o produto********************}
procedure TFProdutosFornecedores.PosicionaFornecedor(SequencialProduto, CodigoFornecedor : String);
var
  laco : integer;
  VpaCampos, VpaTabela, VpaJoin, VpaTodosCampos, VpaGrupo, VpaFilial : string;
begin

  if EditLocaliza5.Text <> '' then
    VpaFilial := ' and mov.i_emp_fil = ' + EditLocaliza5.Text;

  VpaGrupo := '';
  if CValorQdade.Checked then  // caso sumarize o valor sim ou naum
    VpaTodosCampos := ' sum( mov.n_vlr_com) n_vlr_com, sum(mov.n_qtd_com) n_qtd_com, '
  else
  begin
    OrderBy := ' Order by mov.d_dat_com ';
    Grade.ALterarIndice(2);
    VpaTodosCampos := ' mov.d_dat_com, mov.n_vlr_com, mov.n_qtd_com, mov.c_con_com, ' +
                      ' mov.i_pra_dia, mov.c_cod_uni,  ';
  end;

  if RadioGroup1.ItemIndex = 0 then     // caso produto ou fornecedor
  begin
     MudaVisibleDetColunasGrid(grade ,[0,2,3,4,5,6,7,8], true);
     Grade.Columns[1].Visible := false;

     VpaCampos := ' Cli.C_NOM_CLI ';
     VpaTabela := ' CadClientes as Cli ';
     VpaJoin := ' where mov.i_seq_pro = ' +  SequencialProduto  + VpaFilial +
                ' and mov.i_cod_cli = Cli.i_cod_cli ';
     MudaVisibleDetColunasGrid(grade ,[8], false);
       if CValorQdade.Checked then    // caso sumarize o valor sim ou naum
       begin
         VpaGrupo := ' group by mov.i_cod_cli, cli.c_nom_cli ';
         OrderBy := ' Order by cli.c_nom_cli ';
         Grade.ALterarIndice(0);
         MudaVisibleDetColunasGrid(grade ,[2,3,6,7,8], false);
       end;
  end
  else
  begin
     MudaVisibleDetColunasGrid(grade ,[1,2,3,4,5,6,7,8], true);
     Grade.Columns[0].Visible := false;

     VpaTabela := ' CadProdutos as Pro, cadnotafiscaisfor as NF ';
     VpaJoin := ' where mov.i_cod_cli = ' +  CodigoFornecedor +
                ' and mov.I_seq_pro = pro.i_seq_pro ' +  VpaFilial +
                ' and pro.i_cod_emp = ' + IntToStr(varia.CodigoEmpresa) +
                ' and mov.i_emp_fil = NF.i_emp_fil ' +
                ' and mov.i_seq_not = NF.i_seq_not '  ;
     if CValorQdade.Checked then     // caso sumarize o valor sim ou naum
     begin
       VpaGrupo := ' group by mov.i_seq_pro, pro.c_nom_pro ';
       OrderBy := ' Order by pro.c_nom_pro ';
       VpaCampos := ' Pro.C_NOM_PRO ';
       Grade.ALterarIndice(1);
       MudaVisibleDetColunasGrid(grade ,[2,3,6,7,8], false);
     end
     else
        VpaCampos := ' Pro.C_NOM_PRO, NF.I_NRO_NOT ';
   end;

  // monta a select..........
  LimpaSQLTabela(MovForPro);
  AdicionaSQLTabela(MovForPro, ' select ' + VpaTodosCampos +
                               VpaCampos +
                               ' from movfornecprodutos as mov, ' + VpaTabela + VpaJoin );

  if CUltCompra.Checked then  // caso ultimas compras sim ou naum
  begin
    if RadioGroup1.ItemIndex = 0 then
      AdicionaSQLTabela(MovForPro, ' and mov.i_seq_com = ( select max(i_seq_com) from MovFornecProdutos mov2 where mov2.i_cod_cli = mov.i_cod_cli)')
    else
      AdicionaSQLTabela(MovForPro,' and mov.i_seq_com = ( select max(i_seq_com) from MovFornecProdutos mov2 where mov2.i_seq_pro = mov.i_seq_pro) ');
  end
  else
    AdicionaSQLTabela(MovForPro,SQLTextoDataEntreAAAAMMDD('Mov.d_dat_com',data1.DateTime,data2.DateTime, true));

    AdicionaSQLTabela(MovForPro,VpaGrupo );

    AdicionaSQLTabela(MovForPro, OrderBy);

  AbreTabela(MovForPro);
  if ( MovForPro.FieldByName('n_vlr_com') is TFloatField) then
    (MovForPro.FieldByName('n_vlr_com') as TFloatField).DisplayFormat :=  Varia.MascaraMoeda;
  if ( MovForPro.FieldByName('n_qtd_com') is TFloatField) then
    (MovForPro.FieldByName('n_qtd_com') as TFloatField).DisplayFormat :=  Varia.MascaraValor;
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************************Fecha o Formulario corrente***********************}
procedure TFProdutosFornecedores.BFecharClick(Sender: TObject);
begin
   Close;
end;

{************* quando altera entre produto ou fornecedor no radioGroup ******* }
procedure TFProdutosFornecedores.RadioGroup1Click(Sender: TObject);
var
  VpaFornec, VpaProduto : string;
begin
  VpaFornec := '0';
  VpaProduto := '0';
  if RadioGroup1.ItemIndex = 0 then
  begin
   PFornecedor.Visible := false;
   if ProdutoAtual <> '' then
     VpaProduto := ProdutoAtual;
  end
  else
  begin
   PFornecedor.Visible := true;
   EFornecedor.SetFocus;
   EFornecedor.Atualiza;
   if FornecedorAtual <> '' then
     VpaFornec := FornecedorAtual;
  end;
  PosicionaFornecedor(VpaProduto, VpaFornec);
end;

{ ************* no retorno da escolha de um fornecedor ********************** }
procedure TFProdutosFornecedores.EFornecedorRetorno(Retorno1,
  Retorno2: String);
begin
  if Retorno1 <> '' then
  begin
    if PFornecedor.Visible then
    begin
      PosicionaFornecedor('0', retorno1);
      FornecedorAtual := Retorno1;
    end
    else
    begin
      PosicionaFornecedor(retorno1, '0');
      ProdutoAtual := Retorno1;
    end;
  end;
end;


{ ************* retorno do order by escolhido no grid ************************ }
procedure TFProdutosFornecedores.GradeOrdem(Ordem: String);
begin
  OrderBy := Ordem
end;

{ ************ chamada externa para carregar o produto *********************** }
Procedure TFProdutosFornecedores.CarregaProduto( SequencialProduto : String );
begin
  RadioGroup1.ItemIndex := 0;
  ELProduto.Text := '';
  PosicionaFornecedor(SequencialProduto, '0');
end;

{************* chamada da tela de Ponto de Pedido ************************** }
procedure TFProdutosFornecedores.BitBtn1Click(Sender: TObject);
begin
  if not VerificaFormCriado( 'TFPontoPedido') then
      FPontoPedido := TFPontoPedido.criarMDI(application, varia.CT_AreaX, varia.CT_AreaY, FPrincipal.VerificaPermisao('FPontoPedido'));
    FPontoPedido.BringToFront;
end;

{ * Modifica o enabled dos checkBox, apenas pode escolher uma das opcoes ***** }
procedure TFProdutosFornecedores.CUltCompraClick(Sender: TObject);
begin
if CValorQdade.Focused then
  CUltCompra.Enabled := not CValorQdade.Checked;
if CUltCompra.Focused then
  CValorQdade.Enabled := not CUltCompra.Checked;
RadioGroup1Click(sender);
end;


procedure TFProdutosFornecedores.EditLocaliza5Select(Sender: TObject);
begin
  EditLocaliza5.ASelectLocaliza.Text := ' Select * from CadFiliais ' +
                                        ' where I_COD_EMP = ' +  IntToStr(varia.CodigoEmpresa) +
                                        ' and c_nom_fan like ''@%''';

  EditLocaliza5.ASelectValida.Text := 'Select * from CadFiliais where I_EMP_FIL = @% '
end;

procedure TFProdutosFornecedores.EditLocaliza5Retorno(Retorno1,
  Retorno2: String);
begin
  RadioGroup1Click(nil);
end;

procedure TFProdutosFornecedores.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FProdutosFornecedores.HelpContext);
end;

procedure TFProdutosFornecedores.FormShow(Sender: TObject);
begin
   Self.HelpFile := Varia.PathHelp + 'MEstoqueCusto.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
end;

Initialization
{ *************** Registra a classe para evitar duplicidade ****************** }
 RegisterClasses([TFProdutosFornecedores]);
end.
