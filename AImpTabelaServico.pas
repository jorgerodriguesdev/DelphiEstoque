unit AImpTabelaServico;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  ExtCtrls, QuickRpt, Geradores, Qrctrls, Db, DBTables;

type
  TFImpTabelaServico = class(TFormularioPermissao)
    QuickRepNovo1: TQuickRepNovo;
    Tabela: TQuery;
    DetailBand1: TQRBand;
    ColumnHeaderBand1: TQRBand;
    QRDBText1: TQRDBText;
    QRDBText4: TQRDBText;
    QRLabel2: TQRLabel;
    QRLabel5: TQRLabel;
    QRShape1: TQRShape;
    QRLabel1: TQRLabel;
    QRShape4: TQRShape;
    QRShape7: TQRShape;
    QRShape8: TQRShape;
    QRDBText5: TQRDBText;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    PageFooterBand1: TQRBand;
    QRSysData1: TQRSysData;
    QRSysData2: TQRSysData;
    QRShape5: TQRShape;
    QRDBText2: TQRDBText;
    QRLabel3: TQRLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure ConfiguraRel(Altura, FonteCorpo : Integer; ImprimirLinha :Boolean;
                           NomeFonte, titulo : string);
  public
    procedure AbreRelatorio(SQL : TStrings; classificacao : String; Altura, FonteCorpo : Integer; ImprimirLinha :Boolean; NomeFonte : string;
                            titulo : string);
  end;

var
  FImpTabelaServico: TFImpTabelaServico;

implementation

uses APrincipal, funsql, funobjeto, funstring;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFImpTabelaServico.FormCreate(Sender: TObject);
begin
  {  abre tabelas }
  { chamar a rotina de atualização de menus }
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFImpTabelaServico.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 { fecha tabelas }
 { chamar a rotina de atualização de menus }
 Action := CaFree;
end;

procedure TFImpTabelaServico.ConfiguraRel(Altura, FonteCorpo : Integer; ImprimirLinha :Boolean;
                                       NomeFonte, Titulo : string);

  procedure mudaHeight( comp : array of TWincontrol; Height : integer );
    var
     laco : integer;
  begin
     for laco := low(comp) to high(comp) do
       comp[laco].Height := height;
  end;

  procedure mudaFonte( comp : array of TWincontrol; Nomefonte : string; TamanhoFonte : integer );
  var
    laco : integer;
  begin
     for laco := low(comp) to high(comp) do
     begin
       if (comp[laco] is TQRLabel) then
       begin
         (comp[laco] as TQRLabel).Font.Name := Nomefonte;
         (comp[laco] as TQRLabel).Font.Size := TamanhoFonte;
        end;
       if (comp[laco] is TQRDBText) then
       begin
         (comp[laco] as TQRDBText).Font.Name := Nomefonte;
         (comp[laco] as TQRDBText).Font.Size := TamanhoFonte;
       end;
     end;
  end;

begin

  QRLabel1.Caption := titulo; // titulo do relátorio

  mudaHeight([DetailBand1,QRShape4,QRShape7], altura); //muda altura

  mudaFonte( [QRLabel2,QRLabel3,QRLabel5, QRDBText1,QRDBText2,QRDBText4],
             nomeFonte, FonteCorpo);  // muda fonte

  canvas.Font.Name := NomeFonte;  // fonte
  Canvas.Font.Size := FonteCorpo; // tamanho fonte

  QRDBText1.top := trunc((altura - Canvas.TextHeight('AA')) / 2);  // posicao do texto
  QRDBText2.top := trunc((altura - Canvas.TextHeight('AA')) / 2);  // posicao do texto
  QRDBText4.top := trunc((altura - Canvas.TextHeight('AA')) / 2);  // posicao do texto

  QRShape1.Top := altura - 5; // linha inferir do detail

  if not ImprimirLinha then // mostra ou nao as linhas
    AlterarEnabledDet([QRShape1,QRShape4,QRShape7], false);
end;


procedure TFImpTabelaServico.AbreRelatorio(SQL : TStrings; classificacao : String; Altura, FonteCorpo : Integer; ImprimirLinha :Boolean; NomeFonte : string;
                                        titulo : string );
begin
  ConfiguraRel(Altura,FonteCorpo,ImprimirLinha,NomeFonte, titulo);
  if DeletaEspaco(classificacao) = '' then
    QRLabel8.Caption := 'Todas'
  else
    QRLabel8.Caption := classificacao;
  FechaTabela(tabela);
  tabela.sql := SQL;
  AbreTabela(tabela);
  QuickRepNovo1.Preview;
  self.close;
end;

{ *************** Registra a classe para evitar duplicidade ****************** }
Initialization
 RegisterClasses([TFImpTabelaServico]);
end.
