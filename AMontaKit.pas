unit AMontaKit;
{          Autor: Sergio Luiz Censi
    Data Criação: 06/04/1999;
          Função: Montar um novo Kit
  Data Alteração: 06/04/1999;
    Alterado por: Rafael Budag
Motivo alteração: - Adicionado os comentários e o blocos nas rotinas, e realizado
                    um teste - 06/04/199 / Rafael Budag
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Db, DBTables, Grids, DBGrids, Tabela, PainelGradiente, StdCtrls, Buttons,
  ExtCtrls, Componentes1, DBKeyViolation;

type
  TFMontaKit = class(TFormularioPermissao)
    PanelColor1: TPanelColor;
    Bevel1: TBevel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    PainelGradiente1: TPainelGradiente;
    DBGridColor1: TDBGridColor;
    DBGridColor2: TDBGridColor;
    CadProdutos: TQuery;
    DataCadProdutos: TDataSource;
    MovKit: TQuery;
    DataMovKit: TDataSource;
    Produtos: TQuery;
    MovKitNomeProduto: TStringField;
    BitBtn1: TBitBtn;
    MovKitI_PRO_KIT: TIntegerField;
    MovKitI_SEQ_PRO: TIntegerField;
    MovKitN_QTD_PRO: TFloatField;
    MovKitI_COD_EMP: TIntegerField;
    Label4: TLabel;
    EClassificacao: TEditColor;
    Label3: TLabel;
    SpeedButton3: TSpeedButton;
    LNomClassificacao: TLabel;
    Label5: TLabel;
    ENomProduto: TEditColor;
    Aux: TQuery;
    MovKitD_ULT_ALT: TDateField;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure EClassificacaoExit(Sender: TObject);
    procedure EClassificacaoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ENomProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ENomProdutoExit(Sender: TObject);
    procedure MovKitBeforePost(DataSet: TDataSet);
    procedure BBAjudaClick(Sender: TObject);
  private
    CodigoProduto : integer;
    procedure CarregaMovKit;
    function ValidaClassificacao : Boolean;
    Function LocalizaClassificacao : Boolean;
    procedure AtualizaConsulta;
    procedure AdicionaFiltros(VpaSelect : TStrings);
  public
    procedure CarregaTela( codigoPro : integer);
  end;

var
  FMontaKit: TFMontaKit;

implementation

uses APrincipal, constantes, constmsg, ALocalizaClassificacao, FunSql;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFMontaKit.FormCreate(Sender: TObject);
begin
   MovKitN_QTD_PRO.EditFormat := Varia.MascaraQtd;
   Self.HelpFile := Varia.PathHelp + 'MPONTOLOJA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
   MovKitN_QTD_PRO.DisplayFormat := Varia.MascaraQtd;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFMontaKit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  BitBtn1.Click;
  CadProdutos.close;
  Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações de Inicalização
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{**********************Carrega a  tela na inicialização************************}
procedure TFMontaKit.CarregaTela( codigoPro : integer);
begin
   self.CodigoProduto := CodigoPro;
   AtualizaConsulta;
   CarregaMovKit;
   FMontaKit.ShowModal;
end;

{**************************Carrega o Movimento do kit**************************}
procedure TFMontaKit.CarregaMovKit;
begin
  AdicionaSQLAbreTabela(Produtos,'Select * from CadProdutos '+
                    ' Where i_seq_pro in (select i_seq_pro from MovKit ' +
                                            ' where I_COD_EMP = ' +  IntToStr(varia.CodigoEmpresa) +
                                            ' and i_pro_kit = ' + IntTostr(CodigoProduto) +  ' )');
  MovKit.close;
  MovKit.sql.clear;
  MovKit.SQL.Add('Select * from MovKit where I_COD_EMP = ' +  IntToStr(varia.CodigoEmpresa) +
                 ' and i_pro_kit = ' + IntTostr(CodigoProduto)  );
  MovKit.open;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                          eventos dos filtros
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{*************** valida se a classificacao Existe *****************************}
function TFMontaKit.ValidaClassificacao : Boolean;
begin
  AdicionaSQLAbreTabela(Aux,'Select * from CadClassificacao' +
                            ' Where C_Cod_Cla = ''' + EClassificacao.text + '''' +
                            ' and c_Tip_Cla = ''P''');
  result := not Aux.Eof;
  LNomClassificacao.Caption := Aux.FieldByName('C_Nom_Cla').Asstring;
end;

{****************** localiza a classificacao do produto ***********************}
Function TFMontaKit.LocalizaClassificacao: Boolean;
Var
  VpfCodClassificacao,VpfNomClassificacao : String;
begin
  FLocalizaClassificacao := TFLocalizaClassificacao.criarSDI(Application,'',FPrincipal.VerificaPermisao('FLocalizaClassificacao'));
  result := FLocalizaClassificacao.LocalizaClassificacao(VpfCodClassificacao,VpfNomClassificacao,'P');
  if result Then
  begin
    EClassificacao.Text := VpfCodClassificacao;
    LNomClassificacao.Caption := VpfNomClassificacao;
  end;
end;

{************************ atualiza a consulta *********************************}
procedure TFMontaKit.AtualizaConsulta;
begin
  CadProdutos.Sql.Clear;
  CadProdutos.Sql.Add('Select * from CadProdutos '+
                       ' where i_cod_emp = ' + IntToStr(varia.CodigoEmpresa ) +
                       ' and C_KIT_PRO = ''P''' +
                       ' and c_ATI_PRO = ''S''' +
                       ' and I_COD_MOE = ' + IntTostr(varia.MoedaBase) +
                       ' and i_seq_pro not in (select i_seq_pro from MovKit ' +
                                              ' where I_COD_EMP = ' +  IntToStr(varia.CodigoEmpresa) +
                                              ' and i_pro_kit = ' + IntTostr(CodigoProduto) +  ' )');
  AdicionaFiltros(CadProdutos.Sql);
  CadProdutos.Sql.Add('order by C_Nom_pro');
  CadProdutos.Open;
end;

{******************** adiciona os filtros da consulta *************************}
procedure TFMontaKit.AdicionaFiltros(VpaSelect : TStrings);
begin
  if EClassificacao.Text <>'' then
    VpaSelect.Add(' and C_Cod_Cla like  '''+ EClassificacao.Text + '%''');
  if ENomProduto.Text <> '' then
    VpaSelect.add(' and C_Nom_Pro like ''' + ENomProduto.Text + '%''');
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{*******************Move item de um list box para outro************************}
procedure TFMontaKit.SpeedButton1Click(Sender: TObject);
begin
   MovKit.Insert;
   MovKitI_COD_EMP.Value := varia.CodigoEmpresa;
   MovKitI_PRO_KIT.Value := CodigoProduto;
   MovKitI_SEQ_PRO.Value := CadProdutos.fieldbyName('I_SEQ_PRO').AsInteger;
   MovKit.Post;
   CarregaMovKit;
   AtualizaConsulta;
end;

{*******************Move item de um list box para outro************************}
procedure TFMontaKit.SpeedButton2Click(Sender: TObject);
begin
   movKit.Delete;
   CarregaMovKit;
   AtualizaConsulta
end;

{****************************Fecha o Formulario corrente***********************}
procedure TFMontaKit.BitBtn1Click(Sender: TObject);
var
  ok : Boolean;
begin
   Ok := true;
   if not MovKit.eof then
   begin
     MovKit.DisableControls;
     MovKit.First;
     while not MovKit.eof do
     begin
       if MovKitN_QTD_PRO.AsFloat = 0 then
       begin
         aviso(CT_KitQdadeNula);
         ok := false;
         break;
       end;
       MovKit.Next;
     end;
   end;
   MovKit.EnableControls;
   if ok then
     self.close
   else
     abort;
end;

{********************** quando sai do codigo da classificacao *****************}
procedure TFMontaKit.EClassificacaoExit(Sender: TObject);
begin
  if EClassificacao.text <> '' then
  begin
    if  ValidaClassificacao then
      AtualizaConsulta
    else
      if not LocalizaClassificacao Then
        EClassificacao.SetFocus
      else
        AtualizaConsulta;
  end;
end;

{********************** filtra as teclas pressionadas *************************}
procedure TFMontaKit.EClassificacaoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    Vk_F3 : LocalizaClassificacao;
       13 : if ValidaClassificacao then
              AtualizaConsulta
            else
              if LocalizaClassificacao Then
                AtualizaConsulta;
  end
end;

{************************ atualiza a consulta ********************************}
procedure TFMontaKit.ENomProdutoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    13: AtualizaConsulta;
  end;
end;

{************************ Atualiza a Consulta *********************************}
procedure TFMontaKit.ENomProdutoExit(Sender: TObject);
begin
  AtualizaConsulta
end;

{******************* antes de gravar o registro *******************************}
procedure TFMontaKit.MovKitBeforePost(DataSet: TDataSet);
begin
  //atualiza a data de alteracao para poder exportar
  MovKitD_ULT_ALT.AsDateTime := Date;
end;

procedure TFMontaKit.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FMontaKit.HelpContext);
end;

Initialization
 RegisterClasses([TFMontaKit]);
end.
