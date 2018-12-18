unit APrincipal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, DBTables, ComCtrls, ExtCtrls, StdCtrls, Buttons,  formulariosFundo, Formularios,
  ToolWin, ExtDlgs, Inifiles, constMsg, FunObjeto, Db, DBCtrls, Grids,
  DBGrids, PainelGradiente, Tabela, Localizacao,
  Mask, Spin, UnPrincipal, Componentes1;

const
  CampoPermissaoModulo = 'C_MOD_EST';
  CampoFormModulos ='C_MOD_EST';
  NomeModulo = 'Estoque/Custo';

type
  TFPrincipal = class(TFormularioFundo)
    Menu: TMainMenu;
    MFAlteraSenha: TMenuItem;
    MAjuda: TMenuItem;
    BaseDados: TDatabase;
    BarraStatus: TStatusBar;
    MArquivo: TMenuItem;
    MSair: TMenuItem;
    N1: TMenuItem;
    MSobre: TMenuItem;
    MFAlterarFilialUso: TMenuItem;
    CorFoco: TCorFoco;
    CorForm: TCorForm;
    CorPainelGra: TCorPainelGra;
    MFAbertura: TMenuItem;
    N6: TMenuItem;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    Produtos1: TMenuItem;
    MFFormacaoPreco: TMenuItem;
    MFAcertoEstoque: TMenuItem;
    MFExtornoEntrada: TMenuItem;
    MFCadNotaFiscaisFor: TMenuItem;
    MProdutos: TMenuItem;
    MFUnidades: TMenuItem;
    MFOperacoesEstoques: TMenuItem;
    MFItensCusto: TMenuItem;
    MFprodutos: TMenuItem;
    MCusto: TMenuItem;
    N2: TMenuItem;
    MFCadPaises: TMenuItem;
    MFCadEstados: TMenuItem;
    MFCidades: TMenuItem;
    N3: TMenuItem;
    MFEventos: TMenuItem;
    MFProfissoes: TMenuItem;
    MFSituacoesClientes: TMenuItem;
    MFClientes: TMenuItem;
    N4: TMenuItem;
    MFTransportadoras: TMenuItem;
    MFNaturezas: TMenuItem;
    MFAdicionaProdFilial: TMenuItem;
    MFEstornoAcertoEstoque: TMenuItem;
    MFTabelaPreco: TMenuItem;
    MFCadIcmsEstado: TMenuItem;
    MFEstoqueProdutos: TMenuItem;
    MFProdutosFornecedores: TMenuItem;
    MFPontoPedido: TMenuItem;
    MFUsuarioMenu: TMenuItem;
    MEstoque: TMenuItem;
    BSaida: TSpeedButton;
    BaseEndereco: TDatabase;
    MFImprimeCodigoBarra: TMenuItem;
    MAvaliaodeEstoque: TMenuItem;
    MFEstoqueClassificacaoAtual: TMenuItem;
    MFDetalhesEstoque: TMenuItem;
    MFAtividadeProduto: TMenuItem;
    BMFProdutos: TSpeedButton;
    BMFClientes: TSpeedButton;
    BMFConsultaProduto: TSpeedButton;
    MFLocalizaProduto: TMenuItem;
    BMFEntradaMercadoria: TSpeedButton;
    BMFEstornoEntrada: TSpeedButton;
    BMFEstoqueAtual: TSpeedButton;
    BMFMovimentosEstoque: TSpeedButton;
    BMFEstoqueProdutos: TSpeedButton;
    MFEstoqueProdutosPreco: TMenuItem;
    MFFechamentoEstoque: TMenuItem;
    MForcaNovoUsuario: TMenuItem;
    MFBackup: TMenuItem;
    N5: TMenuItem;
    N7: TMenuItem;
    Constexto1: TMenuItem;
    ndice1: TMenuItem;
    MFEstoqueProdutosAtual: TMenuItem;
    MFNovoProduto: TMenuItem;
    Invetrio1: TMenuItem;
    MFInventario: TMenuItem;
    MFMovInventario: TMenuItem;
    MFFormacaoCusto: TMenuItem;
    MFSituacoes: TMenuItem;
    MFRequisicaoDeMaterial: TMenuItem;
    ConfiguraodosItensdeCusto1: TMenuItem;
    MRelatorios: TMenuItem;
    Cadastros1: TMenuItem;
    Clientes1: TMenuItem;
    MProdutosRel: TMenuItem;
    MEstoqueRel: TMenuItem;
    MInventrioRel: TMenuItem;
    MCustoRel: TMenuItem;
    MFConsultaRequisicoes: TMenuItem;
    N8: TMenuItem;
    MFImprimeTag: TMenuItem;
    MFSetoresEstoque: TMenuItem;
    procedure MostraHint(Sender : TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure MenuClick(Sender: TObject);
    procedure Constexto1Click(Sender: TObject);
    procedure ndice1Click(Sender: TObject);
    procedure MRelatoriosClick(Sender: TObject);
  private
    TipoSistema : string;
    UnPri : TFuncoesPrincipal;
    procedure VerificaTransacaoPendente;
  public
     function AbreBaseDados( Alias : string ) : Boolean;
     procedure AlteraNomeEmpresa;
     Function  VerificaPermisao( nome : string ) : Boolean;
     procedure erro(Sender: TObject; E: Exception);
     procedure abre(var Msg: TMsg; var Handled: Boolean);
     procedure VerificaMoeda;
     procedure ValidaBotoesGrupos( botoes : array of TComponent);
     procedure TeclaPressionada(var Msg: TWMKey; var Handled: Boolean);
     procedure ConfiguracaoModulos;
     procedure OrganizaBotoes;
     procedure CriaRelatorio(Sender: TObject);
     procedure CriaRelatorioGeral(Sender: TObject);
  end;



var
  FPrincipal: TFPrincipal;
  Ini : TInifile;

implementation

uses funstring,Constantes, UnRegistro, funsql, funsistema, unNotasFiscaisFor,
     Abertura, AAlterarSenha, ASobre, FunIni, AAlterarFilialUso,
     AUnidade, AOperacoesEstoques, AProfissoes, ASituacoesClientes,
     AClientes, ACadPaises, ACadEstados, ACadCidades,
     AEventos, AProdutos, AExtornoEntrada, ACadNotaFiscaisFor,
     ATransportadoras, ANaturezas, AAcertoEstoque, AEstornoAcertoEstoque,
     AAdicionaProdFilial, AFormacaoPreco, ATabelaPreco, ACadIcmsEstado,
  AEstoqueProdutos, AProdutosFornecedores, APontoPedido,
  UsuarioMenu,  AImprimeCodigoBarra,
  AEstoqueClassificacaoAtual, AEstoqueProdutosAtual,
  ADetalhesEstoque, AAtividadeProduto, ALocalizaProdutos,
  AEstoqueProdutosPreco, AFechamentoEstoque, ABackup, ANovoProduto,
  AInventario, AMovInventario,
  AItensCusto,AInicio,
  ASituacoes, ARequisicaoDeMaterial,
  ARelatoriosFaturamento,
  ARelatoriosGeral, AConsultaRequisicoes, AImprimeTag, AMostraMensages,
  ACadSetoresEstoque, AFundoPrincipal;

{$R *.DFM}


// ----- Verifica a permissão do formulários conforme tabela MovGrupoForm -------- //
Function TFPrincipal.VerificaPermisao( nome : string ) : Boolean;
begin
  result := UnPri.VerificaPermisao(nome);
  if not result then
  abort;
end;

// ------------------ Mostra os comentarios ma barra de Status ---------------- }
procedure TFPrincipal.MostraHint(Sender : TObject);
begin
  BarraStatus.Panels[3].Text := Application.Hint;
end;

// ------------------ Na criação do Formulário -------------------------------- }
procedure TFPrincipal.FormCreate(Sender: TObject);
begin
 UnPri := TFuncoesPrincipal.criar(self, BaseDados, NomeModulo);
 Varia := TVariaveis.Create;   // classe das variaveis principais
 Config := TConfig.Create;     // Classe das variaveis Booleanas
 ConfigModulos := TConfigModulo.create; // classe das variaveis de configuracao do modulo.
 Application.OnHint := MostraHint;
 Application.HintColor := $00EDEB9E;        // cor padrão dos hints
 Application.Title := NomeModulo ;  // nome a ser mostrado na barra de tarefa do Windows
 Application.OnException := Erro;
 Application.OnMessage := Abre;
 Application.OnShortCut := TeclaPressionada;
end;

{************ abre base de dados ********************************************* }
function TFPrincipal.AbreBaseDados( Alias : string ) : Boolean;
begin
  result := AbreBancoDadosAlias(BaseDados,Alias);
end;

procedure TFPrincipal.erro(Sender: TObject; E: Exception);
begin
  FMostraMensagens := TFMostraMensagens.CriarSDI(application,'',true);
  FMostraMensagens.MostraErro(E.Message);
end;

// ------------------- Quando o formulario e fechado -------------------------- }
procedure TFPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  BaseDados.Close;
  Varia.Free;
  Config.Free;
  UnPri.free;
  Action := CaFree;
end;

// -------------------- Quando o Formulario é Iniciado ------------------------ }
procedure TFPrincipal.FormShow(Sender: TObject);
begin
 // configuracoes do usuario
 UnPri.ConfigUsu( varia.CodigoUsuario, CorFoco, CorForm, CorPainelGra, Self );
 // configura modulos
 ConfiguracaoModulos;
 AlteraNomeEmpresa;
 FPrincipal.WindowState := wsMaximized;  // coloca a janela maximizada;
 // conforme usuario, configura menu
 UnPri.EliminaItemsMenu(self, Menu);
 OrganizaBotoes;
 Self.HelpFile := Varia.PathHelp + 'MESTOQUECUSTO.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
 VerificaTransacaoPendente;
 VerificaVersaoSistema(CampoPermissaoModulo);
 if VerificaFormCriado('TFInicio') then
 begin
   finicio.close;
   finicio.free;
 end;
end;

{****************** organiza os botoes do formulario ************************ }
procedure TFPrincipal.OrganizaBotoes;
begin
  UnPri.OrganizaBotoes(0, [ BMFClientes, BMFProdutos, BMFConsultaProduto,
                            BMFEntradaMercadoria, BMFEstornoEntrada, BMFEstoqueAtual, BMFEstoqueProdutos,
                            BMFMovimentosEstoque, bsaida]);
end;

// -------------------- Altera o Caption da Jabela Proncipal ------------------ }
procedure TFPrincipal.AlteraNomeEmpresa;
begin
  UnPri.AlteraNomeEmpresa(self, BarraStatus, NomeModulo, TipoSistema );
end;


// -------------Quando é enviada a menssagem de criação de um formulario------------- //
procedure TFPrincipal.abre(var Msg: TMsg; var Handled: Boolean);
begin
  if (Msg.message = CT_CRIAFORM) or (Msg.message = CT_DESTROIFORM) then
  begin
    UnPri.ConfiguraMenus(screen.FormCount,[],[MFAbertura,MFAlterarFilialUso,MForcaNovoUsuario]);
    if (Msg.message = CT_CRIAFORM) and (config.AtualizaPermissao) then
      UnPri.CarregaNomeForms(Screen.ActiveForm.Name, Screen.ActiveForm.Hint,CampoFormModulos, Screen.ActiveForm.Tag);
    if (Msg.message = CT_CRIAFORM) then
       Screen.ActiveForm.Caption := Screen.ActiveForm.Caption + ' [ ' + varia.NomeFilial + ' ] ';
  end;
end;

// --------- Verifica moeda --------------------------------------------------- }
procedure TFPrincipal.VerificaMoeda;
begin
  if (varia.DataDaMoeda <> date) and (Config.AvisaDataAtualInvalida)  then
    aviso(CT_DataMoedaDifAtual)
  else
    if (varia.MoedasVazias <> '') and (Config.AvisaIndMoeda) then
    avisoFormato(CT_MoedasVazias, [ varia.MoedasVazias]);
end;


// -------------  Valida ou naum Botoes para ususario master ou naum ------------- }
procedure TFPrincipal.ValidaBotoesGrupos( botoes : array of TComponent);
begin
  if Varia.GrupoUsuarioMaster <> Varia.GrupoUsuario then
    AlterarEnabledDet(botoes,false);
end;

procedure TFPrincipal.TeclaPressionada(var Msg: TWMKey; var Handled: Boolean);
begin
    case Msg.CharCode  of
      123 :
       if not VerificaFormCriado('FLocalizaProduto') then
       begin
          FLocalizaProduto := TFLocalizaProduto.criarSDI(Application,'',VerificaPermisao('FLocalizaProduto'));
          FLocalizaProduto.ShowModal;
          FLocalizaProduto.free;
       end;
      121 :
       if not VerificaFormCriado('FClientes') then
       begin
          FClientes := TFClientes.criarMDI(Application,0,0 ,VerificaPermisao('FClientes'));
          FClientes.FormStyle := fsNormal;
          FClientes.Visible := false;
          FClientes.Showmodal;
          FClientes.free;
        end;
    end;
end;

{************************  M E N U   D O   S I S T E M A  ********************* }
procedure TFPrincipal.MenuClick(Sender: TObject);
begin
 if  ValidaDataFormulario(date) then
  if Sender is TComponent  then
  case ((Sender as TComponent).Tag) of
    0001 : Close;
    1100 : begin
             FAlterarFilialUso := TFAlterarFilialUso.CriarSDI(application,'', VerificaPermisao('FAlterarFilialUso'));
             FAlterarFilialUso.ShowModal;
           end;
    1200, 1210 : begin
             // ----- Formulario para alterar o usuario atual ----- //
             FAbertura := TFAbertura.Create(Application);
             FAbertura.ShowModal;
             if Varia.StatusAbertura = 'OK' then
             begin
               AlteraNomeEmpresa;
               ResetaMenu(Menu, ToolBar1);
               UnPri.EliminaItemsMenu(self, menu);
               UnPri.ConfigUsu(varia.CodigoUsuario, CorFoco, CorForm, CorPainelGra, Self );
               ConfiguracaoModulos;
               OrganizaBotoes;
             end
             else
               if  ((Sender as TComponent).Tag) = 1210 then
                 FPrincipal.close;
           end;
    1250 : begin
             FUsuarioMenu := TFUsuarioMenu.CriarSDI(application,'',VerificaPermisao('FUsuarioMenu'));
             FUsuarioMenu.AbreFormulario(4);
           end;
    1270 : begin
             FBackup := TFBackup.CriarSDI(application,'',VerificaPermisao('FBackup'));
             FBackup.ShowModal;
           end;
           // ----- Sair do Sistema ----- //
    1300 : Close;
    2100 : begin
             // ------ Cadastra as Unidades ------ //
             FUnidades := TFUnidades.CriarSDI(application,'',VerificaPermisao('FUnidades'));
             FUnidades.ShowModal;
           end;
    2150 :begin
             // ------ Cadastra os Setores Estoque ------ //
             FSetoresEstoque := TFSetoresEstoque.CriarSDI(application,'',VerificaPermisao('FSetoresEstoque'));
             FSetoresEstoque.ShowModal;
           end;
    2300 : begin
             // ----- Cadastra Operações de Estoque ----- //
             FOperacoesEstoques := TFOperacoesEstoques.criarSDI(application,'',VerificaPermisao('FOperacoesEstoques'));
             FOperacoesEstoques.ShowModal;
           end;
    2450 : begin
             // ------ O Cadastro de Naturezas ------ //
             FNaturezas := TFNaturezas.CriarMDI(Application,0,0,VerificaPermisao('FNaturezas'));
           end;
    2475 : begin
             FCadIcmsEstado := TFCadIcmsEstado.CriarSDI(application, '', VerificaPermisao('FCadIcmsEstado'));
             FCadIcmsEstado.ShowModal;
           end;
    2480 : begin
             FSituacoes := TFSituacoes.CriarSDI(application, '', VerificaPermisao('FSituacoes'));
             FSituacoes.ShowModal;
           end;
    2500 : begin
             FEventos := TFEventos.CriarSDI(application, '', VerificaPermisao('FEventos'));
             FEventos.ShowModal;
           end;
    2600 : begin
             // ------- As profissões do Cliente ------- //
             FProfissoes := TFProfissoes.CriarSDI(application,'',VerificaPermisao('FProfissoes'));
             FProfissoes.ShowModal;
           end;
    2700 : begin
             // ------ As Situções do Cliente ------- //
             FSituacoesClientes := TFSituacoesClientes.CriarSDI(Application,'',VerificaPermisao('FSituacoesClientes'));
             FSituacoesClientes.ShowModal;
           end;
           // ------- Cadastro de Clientes ------- //
    2750 : FClientes := TFClientes.criarMDI(application, varia.CT_AreaX, varia.CT_AreaY,VerificaPermisao('FClientes'));
           // ------ Cadastro de Transportadora ------- //
    2775 : FTransportadoras := TFTransportadoras.criarMDI(Application,Varia.CT_AreaX,Varia.CT_AreaY,VerificaPermisao('FTransportadoras'));
    2900 : begin
             // ------ Cadastro de Paises ------ //
             FCadPaises := TFCadPaises.CriarSDI(Application,'',VerificaPermisao('FCadPaises'));
             FCadPaises.ShowModal;
           end;
    2910 : begin
             // ------ Cadastro de Estados ------ //
             FCadEstados := TFCadEstados.CriarSDI(Application,'',VerificaPermisao('FCadEstados'));
             FCadEstados.ShowModal;
           end;
    2920 : begin
             // ------ Cadastro de Cidades ------ //
             FCidades := TFCidades.CriarSDI(Application,'',VerificaPermisao('FCidades'));
             FCidades.ShowModal;
           end;
           // ------- produtos
    3100 : FProdutos := TFProdutos.criarMDI(application,varia.CT_areaX, varia.CT_areaY, FPrincipal.VerificaPermisao('FProdutos'));
    3150 : begin
             FNovoProduto := TFNovoProduto.CriarSDI(application, '', VerificaPermisao('FNovoProduto'));
             FNovoProduto.InsereNovoProduto(false);
           end;
    3200 : begin
             FAdicionaProdFilial := TFAdicionaProdFilial.criarMDI(Application, Varia.CT_areaX, Varia.CT_areaY, VerificaPermisao('FAdicionaProdFilial'));
           end;
    3300 : begin
             FTabelaPreco := TFTabelaPreco.CriarSDI(application, '',VerificaPermisao('FTabelaPreco'));
             FTabelaPreco.ShowModal;
           end;
    3400 : begin
            FFormacaoPreco := TFFormacaoPreco.CriarSDI(application, '',VerificaPermisao('FFormacaoPreco'));
            FFormacaoPreco.ShowModal;
           end;
    3450 : Begin
             FImprimeCodigoBarra := TFImprimeCodigoBarra.CriarSDI(application, '',VerificaPermisao('FImprimeCodigoBarra'));
             FImprimeCodigoBarra.showModal;
           end;
    3455 : Begin
             FImprimeTag := TFImprimeTag.CriarSDI(application, '',VerificaPermisao('FImprimeTag'));
             FImprimeTag.showModal;
           end;
    3480 : Begin
             FLocalizaProduto := TFLocalizaProduto.criarSDI(Application,'',VerificaPermisao('FLocalizaProduto'));
             FLocalizaProduto.ShowModal;
           end;
    3475 : Begin
             FAtividadeProduto := TFAtividadeProduto.criarSDI(Application,'',VerificaPermisao('FAtividadeProduto'));
             FAtividadeProduto.ShowModal;
           end;
    4200 : begin
             // ------ Movimento de entrada de produtos ------ //
             FCadNotaFiscaisFor := TFCadNotaFiscaisFor.CriarSDI(Application,'',VerificaPermisao('FCadNotaFiscaisFor'));
             FCadNotaFiscaisFor.BotaoCadastrar1.Click;
             FCadNotaFiscaisFor.ShowModal;
           end;
    4300 : begin
             // ------ extorno de entrada de produtos ------ //
             FExtornoEntrada := TFExtornoEntrada.CriarSDI(Application,'',VerificaPermisao('FExtornoEntrada'));
             FExtornoEntrada.ShowModal;
           end;
    4500 : begin
             FAcertoEstoque := TFAcertoEstoque.CriarSDI(Application,'',VerificaPermisao('FAcertoEstoque'));
             FAcertoEstoque.ShowModal;
           end;
    4750 : begin
             FEstornoAcertoEstoque := TFEstornoAcertoEstoque.CriarSDI(Application,'',VerificaPermisao('FEstornoAcertoEstoque'));
             FEstornoAcertoEstoque.ShowModal;
           end;
    4900 : FProdutosFornecedores := TFProdutosFornecedores.CriarMDI( Application, varia.CT_AreaX, varia.CT_AreaY ,VerificaPermisao('FProdutosFornecedores'));
    4910 : FPontoPedido := TFPontoPedido.CriarMDI( Application, varia.CT_AreaX, varia.CT_AreaY ,VerificaPermisao('FPontoPedido'));
    4920 : Begin
             FFechamentoEstoque := TFFechamentoEstoque.CriarSDI(Application,'',VerificaPermisao('FFechamentoEstoque'));
             FFechamentoEstoque.ShowModal;
           end;
    4940 : Begin
             FRequisicaoDeMaterial := TFRequisicaoDeMaterial.CriarSDI(Application,'',VerificaPermisao('FRequisicaoDeMaterial'));
             FRequisicaoDeMaterial.NovaRequiciaoDeMaterial;
             FRequisicaoDeMaterial.ShowModal;
           end;
    4950 : FConsultaRequisicoes := TFConsultaRequisicoes.CriarMDI(Application, varia.CT_AreaX, varia.CT_AreaY ,VerificaPermisao('FConsultaRequisicoes'));
    5100 : begin
             FEstoqueProdutos := TFEstoqueProdutos.CriarSDI(Application,'',VerificaPermisao('FEstoqueProdutos'));
             FEstoqueProdutos.ShowModal;
           end;
    5200 : begin
             FEstoqueClassificacaoAtual := TFEstoqueClassificacaoAtual.CriarSDI(Application,'',VerificaPermisao('FEstoqueClassificacaoAtual'));
             FEstoqueClassificacaoAtual.ShowModal;
           end;
    5300 : begin
             FEstoqueProdutosAtual := TFEstoqueProdutosAtual.CriarSDI(Application,'',VerificaPermisao('FEstoqueProdutosAtual'));
             FEstoqueProdutosAtual.ShowModal;
           end;
    5400 : begin
             FDetalhesEstoque := TFDetalhesEstoque.CriarSDI(Application,'',VerificaPermisao('FDetalhesEstoque'));
             FDetalhesEstoque.MostraDetalhes('',IntToStr(varia. CodigoEmpFil),'PA', 'X');
           end;
    5500 : begin
             FEstoqueProdutosPreco := TFEstoqueProdutosPreco.CriarSDI(Application,'',VerificaPermisao('FEstoqueProdutosPreco'));
             FEstoqueProdutosPreco.ShowModal;
           end;

    6100 : begin
             FAlteraSenha := TFAlteraSenha.CriarSDI(Application,'',VerificaPermisao('FAlteraSenha'));
             FAlteraSenha.ShowModal;
           end;
    10100 : begin
             FInventario := TFInventario.CriarSDI(Application,'',VerificaPermisao('FInventario'));
             FInventario.ShowModal;
           end;
    10200 : begin
             FMovInventario := TFMovInventario.CriarSDI(Application,'',VerificaPermisao('FMovInventario'));
             FMovInventario.ShowModal;
           end;
    11100 : begin
             FItensCusto := TFItensCusto.CriarSDI(Application,'',VerificaPermisao('FItensCusto'));
             FItensCusto.ShowModal;
           end;
{    11200 : begin
             FFormacaoCusto := TFFormacaoCusto.CriarSDI(Application,'',VerificaPermisao('FFormacaoCusto'));
             FFormacaoCusto.ShowModal;
           end;
    11300 : begin
             FConfigItensCusto := TFConfigItensCusto.CriarSDI(Application,'',VerificaPermisao('FConfigItensCusto'));
             FConfigItensCusto.ShowModal;
           end;  }

    9100 : begin
             FSobre := TFSobre.CriarSDI(application,'', VerificaPermisao('FSobre'));
             FSobre.ShowModal;
           end;
  end;
end;

{******************* configura os modulos do sistema ************************* }
procedure TFPrincipal.ConfiguracaoModulos;
var
  Reg : TRegistro;
begin
  Reg := TRegistro.create;
  reg.ValidaModulo( TipoSistema, [MProdutos,MCusto, MEstoque] );
  reg.ConfiguraModulo(CT_ESTOQUE, [ Mestoque, MAvaliaodeEstoque, BMFEntradaMercadoria,
                                   BMFEstornoEntrada, BMFEstoqueAtual, BMFEstoqueProdutos, BMFMovimentosEstoque ] );
  reg.ConfiguraModulo(CT_CUSTO, [ MCusto ] );
  reg.ConfiguraModulo(CT_SENHAGRUPO, [ MFUsuarioMenu ]  );
  reg.ConfiguraModulo(CT_PRODUTO, [ MProdutos, BMFProdutos, BMFConsultaProduto ]);
  MFImprimeTag.Visible := config.CodigoBarras;
  reg.Free;
end;

{**************** verifica e exclui alguma transacao pendente ************** }
procedure TFPrincipal.VerificaTransacaoPendente;
var
  Sequencial, Filial : integer;
  NFFor : TFuncoesNFFor;
begin
  if VerificaTransacao(4, Sequencial, Filial) then
  begin
     NFFor := TFuncoesNFFor.criar(self, BaseDados);
     NFFor.Exclui_cancelaNotaFiscalDireto(Sequencial, Filial);
     NFFor.free;
     DesmarcaTransacao(4);
  end;
end;

procedure TFPrincipal.Constexto1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_FINDER,0);
end;

procedure TFPrincipal.ndice1Click(Sender: TObject);
begin
   Application.HelpCommand(HELP_KEY,0);
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Relatorios
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{**************************** Gera os menus de relatorios ********************}
procedure TFPrincipal.MRelatoriosClick(Sender: TObject);
begin
 if  ValidaDataFormulario(date) then
  if (sender is TMenuItem) then
    if MRelatorios.Tag <> 1 then
    begin
      UnPri.GeraMenuRelatorios(Menu,CriaRelatorioGeral,'Cadastro\Geral',(sender as TMenuItem).MenuIndex,0,99);
      UnPri.GeraMenuRelatorios(Menu,CriaRelatorioGeral,'Cadastro\Estoque',(sender as TMenuItem).MenuIndex,0,99);
      UnPri.GeraMenuRelatorios(Menu,CriaRelatorioGeral,'Cliente',(sender as TMenuItem).MenuIndex,1,99);
      if ConfigModulos.Produto then
       UnPri.GeraMenuRelatorios(Menu,CriaRelatorio,'Produto',(sender as TMenuItem).MenuIndex,2,99);
      if ConfigModulos.Estoque then
        UnPri.GeraMenuRelatorios(Menu,CriaRelatorio,'Estoque',(sender as TMenuItem).MenuIndex,3,99);
      if ConfigModulos.Inventario then
        UnPri.GeraMenuRelatorios(Menu,CriaRelatorio,'Inventario',(sender as TMenuItem).MenuIndex,4,99);
      if ConfigModulos.Custo then
        UnPri.GeraMenuRelatorios(Menu,CriaRelatorio,'Custo',(sender as TMenuItem).MenuIndex,5,99);
      MRelatorios.Tag := 1;
    end;
end;

{******************* chama um relatorio **************************************}
procedure TFPrincipal.CriaRelatorio(Sender: TObject);
begin
  if VerificaPermisao((sender as TMenuItem).Name) then
  begin
    UnPri.SalvaFormularioEspecial((sender as TMenuItem).Name, DeletaChars((sender as TMenuItem).Caption,'&'),'c_mod_fat',(sender as TMenuItem).Name);
    FRelatoriosFaturamento := TFRelatoriosFaturamento.CriarSDI(application,'',true);
    FRelatoriosFaturamento.CarregaConfig((sender as TMenuItem).Hint, (sender as TMenuItem).Caption);
    FRelatoriosFaturamento.ShowModal;
  end;
end;

{******************* chama um relatorio **************************************}
procedure TFPrincipal.CriaRelatorioGeral(Sender: TObject);
begin
  if VerificaPermisao((sender as TMenuItem).Name) then
  begin
    UnPri.SalvaFormularioEspecial((sender as TMenuItem).Name, DeletaChars((sender as TMenuItem).Caption,'&'),'c_mod_fat',(sender as TMenuItem).Name);
    FRelatoriosGeral := TFRelatoriosGeral.CriarSDI(application,'',true);
    FRelatoriosGeral.CarregaConfig((sender as TMenuItem).Hint, (sender as TMenuItem).Caption);
    FRelatoriosGeral.ShowModal;
  end;
end;

end.
