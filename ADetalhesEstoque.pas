unit ADetalhesEstoque;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Componentes1, ExtCtrls, PainelGradiente, Grids, DBGrids, Tabela,
  DBKeyViolation, StdCtrls, Localizacao, Buttons, Db, DBTables, ComCtrls,
  Mask, numericos;

type
  TFDetalhesEstoque = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    PanelColor3: TPanelColor;
    Label11: TLabel;
    SpeedButton1: TSpeedButton;
    Label12: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    RData: TRadioButton;
    RDataUnidade: TRadioButton;
    RMes: TRadioButton;
    RMesUnidade: TRadioButton;
    ROperacao: TRadioButton;
    ROperacaoUnidade: TRadioButton;
    RNenhum: TRadioButton;
    EditLocaliza1: TEditLocaliza;
    Grade: TGridIndice;
    Estoque: TQuery;
    DataEstoque: TDataSource;
    AtiPro: TCheckBox;
    Data1: TCalendario;
    Data2: TCalendario;
    Localiza: TConsultaPadrao;
    BFechar: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    BNota: TBitBtn;
    BBAjuda: TBitBtn;
    BitBtn1: TBitBtn;
    numerico1: Tnumerico;
    Label3: TLabel;
    RSetor: TRadioButton;
    RSetorUnidade: TRadioButton;
    Label5: TLabel;
    EditLocaliza3: TEditLocaliza;
    SpeedButton2: TSpeedButton;
    Label6: TLabel;
    Label4: TLabel;
    EditLocaliza2: TEditLocaliza;
    SpeedButton4: TSpeedButton;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RNenhumClick(Sender: TObject);
    procedure BFecharClick(Sender: TObject);
    procedure EditLocaliza1Retorno(Retorno1, Retorno2: String);
    procedure BNotaClick(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure EditLocaliza2Select(Sender: TObject);
    procedure EditLocaliza2Retorno(Retorno1, Retorno2: String);
    procedure EditLocaliza3Retorno(Retorno1, Retorno2: String);
  private
    CodigoProduto, CodigoFilial, TipoItem : string;
    TipoMov : char;
    seqpro : integer;
    procedure GeraEstoqueProduto( CodigoProduto, CodigoFilial, TipoItem : string; TipoMovimento : char );
  public
    procedure MostraDetalhes( CodigoProduto, CodigoFilial, TipoItem : string; TipoMovimento : char );
  end;

var
  FDetalhesEstoque: TFDetalhesEstoque;

implementation

uses APrincipal, fundata, constantes, funObjeto, constMsg, funstring, funsql,
  ACadNotaFiscaisFor, AImprimeMovimentoProduto;


{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFDetalhesEstoque.FormCreate(Sender: TObject);
begin
  data1.date := PrimeiroDiaMes(date);
  data2.date := UltimoDiaMes(date);
  seqpro := 0;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFDetalhesEstoque.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Estoque.close;
 Action := CaFree;
end;

{************* gera estoque dos produtos ************************************ }
procedure TFDetalhesEstoque.GeraEstoqueProduto( CodigoProduto, CodigoFilial, TipoItem : string;  TipoMovimento : char );
var
  VpaCampos, VpaGrupo : string;
begin
  MudaVisibleTodasColunasGrid( Grade, true );
  if RNenhum.Checked then
  begin
    VpaCampos := ' mov.i_lan_est, ' + Varia.CodigoProduto + ' ||  '' -  '' || pro.c_nom_pro c_nom_pro, mov.c_cod_uni, mov.n_qtd_mov, mov.n_vlr_mov, ' +
                 ' op.c_nom_ope, mov.d_dat_mov, mov.c_tip_mov, mov.i_nro_not, mov.i_not_sai, mov.i_not_ent, ' +
                 ' IFnull(mov.n_qtd_mov,0, mov.n_vlr_mov / mov.n_qtd_mov)  ValorMedio, ' +
                 ' mov.n_vlr_mov / n_qtd_mov qdade, setor.c_nom_set ';
    VpaGrupo := ' order by mov.i_lan_est';
  end
  else
    if RData.Checked then
    begin
      VpaCampos := ' mov.d_dat_mov, sum(mov.n_vlr_mov) n_vlr_mov, ' +
                   ' sum(n_qtd_mov) n_qtd_mov, '+
                   ' IFnull(n_qtd_mov,0, n_vlr_mov / n_qtd_mov) ValorMedio ';
      VpaGrupo := 'group by mov.d_dat_mov order by mov.d_dat_mov';
      MudaVisibleDetColunasGrid(Grade, [0,1,2,4,8,9,10], false);
    end
    else
      if RDataUnidade.Checked then
      begin
        VpaCampos := ' mov.d_dat_mov, sum(mov.n_vlr_mov) n_vlr_mov, sum(n_qtd_mov) n_qtd_mov,  pro.c_cod_uni, ' +
                     ' IFnull(n_qtd_mov,0, n_vlr_mov / n_qtd_mov) ValorMedio ';
        VpaGrupo := ' group by mov.d_dat_mov, pro.c_cod_uni order by mov.d_dat_mov';
        MudaVisibleDetColunasGrid(Grade, [0,1,2,8,9,10], false);
      end
      else
        if RMes.Checked then
        begin
          VpaCampos := ' month(mov.d_dat_mov) d_dat_mov, sum(mov.n_vlr_mov) n_vlr_mov, sum(n_qtd_mov) n_qtd_mov, ' +
                       ' IFnull(n_qtd_mov,0, n_vlr_mov / n_qtd_mov) ValorMedio';
          VpaGrupo := ' group by month(mov.d_dat_mov) order by month(mov.d_dat_mov)';
          MudaVisibleDetColunasGrid(Grade, [0,1,2,4,8,9,10], false);
        end
        else
          if RMesUnidade.Checked then
          begin
            VpaCampos := ' month(mov.d_dat_mov) d_dat_mov, sum(mov.n_vlr_mov) n_vlr_mov, sum(n_qtd_mov) n_qtd_mov, pro.c_cod_uni, ' +
                         ' IFnull(n_qtd_mov,0, n_vlr_mov / n_qtd_mov) ValorMedio ';
            VpaGrupo := ' group by month(mov.d_dat_mov), pro.c_cod_uni order by month(mov.d_dat_mov)';
            MudaVisibleDetColunasGrid(Grade, [0,1,2,8,9,10], false);
          end
          else
            if ROperacao.Checked then
            begin
              VpaCampos := ' mov.i_cod_ope,  op.c_nom_ope, mov.c_tip_mov, sum(mov.n_vlr_mov) n_vlr_mov, sum(n_qtd_mov) n_qtd_mov, ' +
                           ' IFnull(n_qtd_mov,0, n_vlr_mov / n_qtd_mov) ValorMedio ';
              VpaGrupo := ' group by mov.i_cod_ope, op.c_nom_ope, mov.c_tip_mov order by (op.c_nom_ope)';
              MudaVisibleDetColunasGrid(Grade, [0,1,3,4,9,10], false);
            end
            else
              if ROperacaoUnidade.Checked then
              begin
                VpaCampos := ' mov.i_cod_ope,  op.c_nom_ope, mov.c_tip_mov, sum(mov.n_vlr_mov) n_vlr_mov, sum(n_qtd_mov) n_qtd_mov, pro.c_cod_uni, ' +
                             ' IFnull(n_qtd_mov,0, n_vlr_mov / n_qtd_mov) ValorMedio ';
                VpaGrupo := ' group by mov.i_cod_ope, op.c_nom_ope, mov.c_tip_mov, pro.c_cod_uni order by (op.c_nom_ope)';
                MudaVisibleDetColunasGrid(Grade, [0,1,3,9,10], false);
               end
               else
                if RSetor.Checked then
                begin
                  VpaCampos := ' setor.c_nom_set, mov.c_tip_mov, sum(mov.n_vlr_mov) n_vlr_mov, sum(n_qtd_mov) n_qtd_mov, ' +
                               ' IFnull(n_qtd_mov,0, n_vlr_mov / n_qtd_mov) ValorMedio ';
                  VpaGrupo := ' group by setor.i_cod_set, setor.c_nom_set, mov.c_tip_mov order by (setor.c_nom_set)';
                  MudaVisibleDetColunasGrid(Grade, [0,1,2,3,4,9], false);
                end
                else
                  if RSetorUnidade.Checked then
                  begin
                    VpaCampos := ' setor.c_nom_set,  mov.c_tip_mov, sum(mov.n_vlr_mov) n_vlr_mov, sum(n_qtd_mov) n_qtd_mov, pro.c_cod_uni, ' +
                                 ' IFnull(n_qtd_mov,0, n_vlr_mov / n_qtd_mov) ValorMedio ';
                    VpaGrupo := ' group by setor.i_cod_set, setor.c_nom_set, mov.c_tip_mov , pro.c_cod_uni order by (setor.c_nom_set)';
                    MudaVisibleDetColunasGrid(Grade, [0,1,2,3,9], false);
                   end;



  LimpaSQLTabela(estoque);
  AdicionaSQLTabela(Estoque,'select ');
  AdicionaSQLTabela(Estoque,VpaCampos);
  AdicionaSQLTabela(Estoque,' from MovEstoqueProdutos  as MOV, cadOperacaoEstoque as OP, ' +
                            ' CadProdutos as PRO, movqdadeproduto  movQdade, cadSetoresEstoque setor ' +
                            ' where MOV.I_COD_OPE = OP.I_COD_OPE ' +
                            ' and PRO.I_SEQ_PRO = MOV.I_SEQ_PRO ' +
                            ' and movQdade.i_seq_pro = pro.i_seq_pro' +
                            ' and movQdade.I_emp_fil = ' + Inttostr(varia.CodigoEmpFil)+
                            ' and mov.i_cod_set *= setor.i_cod_set ');

  if (StrToInt(CodigoFilial) > 10 ) then
    AdicionaSQLTabela(Estoque,' and MOV.I_EMP_FIL = ' + CodigoFilial );


  if (TipoItem = 'PA') and (CodigoProduto <> '') then
     AdicionaSQLTabela(Estoque,' and MOV.I_SEQ_PRO = ' + CodigoProduto )
  else
    if TipoItem = 'CL' then
      AdicionaSQLTabela(Estoque,' and PRO.C_COD_CLA like ''' + CodigoProduto + '%''');

    if AtiPro.Checked then
       estoque.sql.add(' and PRO.C_ATI_PRO = ''S''');

  case TipoMovimento of
   'S' : estoque.sql.add(' and MOV.C_TIP_MOV = ''S'' ');
   'E' : estoque.sql.add(' and MOV.C_TIP_MOV = ''E'' ');
   'T' : estoque.sql.add(' and MOV.C_TIP_MOV = ''T'' ');
   'N' : estoque.sql.add(' ');
  end;

  if EditLocaliza1.Text <> '' then
    estoque.sql.add(' and MOV.I_COD_OPE = ' + EditLocaliza1.Text);

  Estoque.sql.add(' and MOV.D_DAT_MOV between ''' + DataToStrFormato(AAAAMMDD,Data1.Date,'/') + '''' +
                  ' and ''' + DataToStrFormato(AAAAMMDD,Data2.Date,'/') + ''''  );

  if numerico1.AValor <> 0 then
     Estoque.sql.add(' and mov.i_lan_est > ' + IntToStr(trunc(numerico1.AValor)));

  if EditLocaliza3.text <> '' then
   estoque.sql.add(' and MOV.I_COD_SET = ' + EditLocaliza3.Text);

  if EditLocaliza2.text <> '' then
   estoque.sql.add(' and MOV.I_SEQ_PRO = ' + inttostr(seqpro));

  Estoque.sql.add(VpaGrupo);

  estoque.open;

  if ( estoque.FieldByName('n_vlr_mov') is TFloatField) then
    (estoque.FieldByName('n_vlr_mov') as TFloatField).DisplayFormat :=  Varia.MascaraMoeda;
  if ( estoque.FieldByName('n_qtd_mov') is TFloatField) then
      (estoque.FieldByName('n_qtd_mov') as TFloatField).DisplayFormat :=  Varia.Mascaraqtd;
  if ( estoque.FieldByName('ValorMedio') is TFloatField) then
    (estoque.FieldByName('ValorMedio') as TFloatField).DisplayFormat :=  Varia.MascaraMoeda;
end;

procedure TFDetalhesEstoque.MostraDetalhes( CodigoProduto, CodigoFilial, TipoItem : string; TipoMovimento : char );
begin
  GeraEstoqueProduto( CodigoProduto, CodigoFilial, TipoItem, TipoMovimento);
  self.CodigoProduto := CodigoProduto;
  self.CodigoFilial := CodigoFilial;
  self.TipoItem := TipoItem;
  self.TipoMov := TipoMovimento;
  self.ShowModal;
end;


{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFDetalhesEstoque.RNenhumClick(Sender: TObject);
begin
  BNota.Enabled := RNenhum.Checked;
  GeraEstoqueProduto( CodigoProduto, CodigoFilial, TipoItem, TipoMov );
  BitBtn1.Enabled := RNenhum.Checked;
end;

procedure TFDetalhesEstoque.BFecharClick(Sender: TObject);
begin
self.close;
end;

procedure TFDetalhesEstoque.EditLocaliza1Retorno(Retorno1,
  Retorno2: String);
begin
  if Retorno1 <> '' then
    GeraEstoqueProduto( CodigoProduto, CodigoFilial, TipoItem, retorno1[1] )
  else
    GeraEstoqueProduto( CodigoProduto, CodigoFilial, TipoItem, 'N' )
end;

{************************ mostra a nota fiscal de entrada e saida *********** }
procedure TFDetalhesEstoque.BNotaClick(Sender: TObject);
begin
{  if Estoque.fieldByName('i_not_sai').AsInteger <> 0 then
  begin
    FNovaNotaFiscal := TFNovaNotaFiscal.CriarSDI(application, '', true);
    FNovaNotaFiscal.ConsultaNotafiscal(Estoque.fieldByName('i_not_sai').AsInteger);
  end
  else
    if Estoque.fieldByName('i_not_ent').AsInteger <> 0 then
    begin
      FCadNotaFiscaisFor := TFCadNotaFiscaisFor.CriarSDI(application, '', true);
      FCadNotaFiscaisFor.ConsultaNotaFiscal(Estoque.fieldByName('i_not_ent').AsInteger);
    end}
end;

procedure TFDetalhesEstoque.BBAjudaClick(Sender: TObject);
begin
    Application.HelpCommand(HELP_CONTEXT,FDetalhesEstoque.HelpContext);
end;

procedure TFDetalhesEstoque.FormShow(Sender: TObject);
begin
    Self.HelpFile := Varia.PathHelp + 'MEstoqueCusto.hlp>janela';  // Indica o Paph e o nome do arquivo de Help
end;

procedure TFDetalhesEstoque.BitBtn1Click(Sender: TObject);
begin
  FImprimeMovimentoProduto := TFImprimeMovimentoProduto.CriarSDI(application, '', true);
  FImprimeMovimentoProduto.carregaImpressao( Estoque.sql.Text, varia.NomeEmpresa, Varia.NomeFilial);

end;

procedure TFDetalhesEstoque.EditLocaliza2Select(Sender: TObject);
begin
  EditLocaliza2.ASelectValida.Clear;
  EditLocaliza2.ASelectValida.add(  ' Select Pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
                                    ' pro.I_SEQ_PRO, mov.C_COD_BAR ' +
                                    ' From cadprodutos as pro, ' +
                                    ' MovQdadeProduto as mov ' +
                                    ' Where pro.I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                                    ' and ' + varia.CodigoProduto + ' = ''@''' +
                                    ' and pro.C_KIT_PRO = ''P'' ' +
                                    ' and pro.I_seq_pro = Mov.I_seq_pro ' +
                                    ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil) );
  EditLocaliza2.ASelectLocaliza.Clear;
  EditLocaliza2.ASelectLocaliza.add(' Select pro.C_Cod_Pro, pro.C_Nom_Pro, pro.C_Cod_Uni, ' +
                                    ' pro.I_SEQ_PRO, mov.C_COD_BAR ' +
                                    ' from cadprodutos as pro, ' +
                                    ' MovQdadeProduto as mov ' +
                                    ' Where pro.I_Cod_Emp = ' + IntToStr(varia.CodigoEmpresa) +
                                    ' and pro.c_nom_pro like ''@%''' +
                                    ' and pro.C_KIT_PRO = ''P'' ' +
                                    ' and pro.I_seq_pro = Mov.I_seq_pro ' +
                                    ' and mov.I_Emp_Fil = ' + IntTostr(varia.CodigoEmpFil) +
                                    ' order by c_nom_pro asc');
end;

procedure TFDetalhesEstoque.EditLocaliza2Retorno(Retorno1,
  Retorno2: String);
begin
  if Retorno1 <> '' then
    SeqPro := strtoInt(Retorno1)
  else
    if EditLocaliza2.Text = '' then
      seqpro := 0;
  GeraEstoqueProduto( CodigoProduto, CodigoFilial, TipoItem, 'N' );
end;

procedure TFDetalhesEstoque.EditLocaliza3Retorno(Retorno1,
  Retorno2: String);
begin
  GeraEstoqueProduto( CodigoProduto, CodigoFilial, TipoItem, 'N' );
end;

Initialization
 RegisterClasses([TFDetalhesEstoque]);
end.
