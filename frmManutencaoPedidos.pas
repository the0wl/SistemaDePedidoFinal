unit frmManutencaoPedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Mask, Vcl.StdCtrls,

  frmUtils, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,

  System.Math, System.Generics.Collections, frmDados, frmConsts, Vcl.ExtCtrls, Vcl.Grids,
  frmManutencaoItens, System.StrUtils;

type
  TfCadastrarPedidos = class(TForm)
    edNumeroPedido: TEdit;
    edData: TMaskEdit;
    cbCliente: TComboBox;
    queryOperacoes: TFDQuery;
    queryClientes: TFDQuery;
    queryFormaPagto: TFDQuery;
    edObservacao: TMemo;
    pnMenu: TPanel;
    Panel3: TPanel;
    Panel6: TPanel;
    pnDadosBase: TPanel;
    lbNumeroPedido: TLabel;
    lbDataPedido: TLabel;
    lbCliente: TLabel;
    edSituacao: TEdit;
    lbTextoSituacao: TLabel;
    lbSituacao: TLabel;
    edDataEntrega: TMaskEdit;
    lbDataEntrega: TLabel;
    lbOperacao: TLabel;
    cbOperacao: TComboBox;
    cbFormaPagto: TComboBox;
    lbFormaPagto: TLabel;
    lbTipoPedido: TLabel;
    cbTipo: TComboBox;
    lbQtdeTotal: TLabel;
    lbValorTotal: TLabel;
    lbObservacao: TLabel;
    pnMenuItens: TPanel;
    gdListaItens: TStringGrid;
    queryPedProds: TFDQuery;
    queryProdutos: TFDQuery;
    btExcluirItem: TPanel;
    btNovoItem: TPanel;
    btAlterarItem: TPanel;
    queryPedidos: TFDQuery;
    edQuantidadeItens: TEdit;
    edValorTotalItens: TEdit;
    procedure Sair(Sender: TObject);
    procedure Gravar(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Novo(Sender: TObject);
    procedure Alterar(Sender: TObject);
    procedure Excluir(Sender: TObject);
  private
    Pedido: TPedido;
    VetorItens: TList<TItem>;
    PedidoNovo: Boolean;

    procedure CarregaCampoOperacoes(pCodCPagto: Integer);
    procedure CarregaCampoFormaPagamento(pFormaPagamento: Integer);
    procedure CarregaCampoCliente(pCodigoCliente: Integer);
    procedure CarregaCampoTipo(pTipo: String);
    procedure BuscarItens;
    procedure ExcluirItem(pItem: TItem);
    procedure SalvarPedido;
    procedure AtualizarInformacoesDaGradeDeItens;
    procedure AdicionarLinhaNaGradeDeItens(pSequencial: Integer; pItem: TItem);
    procedure AtualizaItemNoVetor(pItemAtual, pNovoItem: TItem);
    procedure AtualizarValoresEQuantidades;
    procedure InserirPedido;
    procedure AlterarPedido;
    procedure InserirItens;
    procedure AlterarItens;

    function RetornaProximoNumero: Integer;
    function BuscaProduto(pCodProduto: String): TProduto;
    function RetornaCodCliente: String;
    function RetornaCodOperacao: String;
    function RetornaCodFormaPagamento: String;
    function RetornaTipoPedido: String;
    function StringValor(pTexto: String): String;
    function StringData(pTexto: String): String;
  public
    procedure CarregarPedido(pPedido: TPedido);
    procedure NovoPedido;
  end;

var
  fCadastrarPedidos: TfCadastrarPedidos;

implementation

{$R *.dfm}

procedure TfCadastrarPedidos.NovoPedido;
begin
  PedidoNovo := True;
  VetorItens.Clear;

  edNumeroPedido.Text      := RetornaProximoNumero.ToString;
  edData.Text              := DateToStr(Now());
  edSituacao.Text          := '1';
  lbTextoSituacao.Caption  := 'Pendente';
  edDataEntrega.Text       := DateToStr(Now() + 7);
  edQuantidadeItens.Text   := '0,00';
  edValorTotalItens.Text   := '0,00';
  edObservacao.Text        := '';

  CarregaCampoOperacoes(-1);
  CarregaCampoFormaPagamento(-1);
  CarregaCampoCliente(-1);
  CarregaCampoTipo('');

  BuscarItens;
  AtualizarInformacoesDaGradeDeItens;

  pnDadosBase.Enabled  := True;
  gdListaItens.Enabled := True;
end;

procedure TfCadastrarPedidos.Sair(Sender: TObject);
begin
  Pedido := nil;
  ModalResult := mrCancel;
  Hide;
end;

procedure TfCadastrarPedidos.Gravar(Sender: TObject);
begin
  if Assigned(Pedido) then
  begin
    if Pedido.Situacao = 2 then
    begin
      ShowMessage('Não é possível alterar pedidos que já foram finalizados.');
      Exit;
    end;
  end;

  if VetorItens.Count < 1 then
  begin
    ShowMessage('Não é possível gravar um pedido sem informar itens.');
    Exit;
  end;

  if cbCliente.ItemIndex < 0 then
  begin
    ShowMessage('Não é possível gravar um pedido sem um cliente.');
    Exit;
  end;

  if edDataEntrega.Text = '  /  /   ' then
  begin
    ShowMessage('Não é possível gravar um pedido sem uma data de entrega.');
    Exit;
  end;

  if cbOperacao.ItemIndex < 0 then
  begin
    ShowMessage('Não é possível gravar um pedido sem informar uma operação.');
    Exit;
  end;

  if cbTipo.ItemIndex < 0 then
  begin
    ShowMessage('Não é possível gravar um pedido sem informar o seu tipo.');
    Exit;
  end;

  SalvarPedido;
  cbCliente.SetFocus;
  Application.ProcessMessages;
  ModalResult := mrOk;
  Hide;
end;

procedure TfCadastrarPedidos.CarregarPedido(pPedido: TPedido);
var
  wHabilitarCampos: Boolean;
begin
  PedidoNovo := False;
  VetorItens.Clear;
  Pedido     := pPedido;

  edNumeroPedido.Text      := Pedido.Numero.ToString;
  edData.Text              := DateToStr(Pedido.Data);
  edSituacao.Text          := Pedido.Situacao.ToString;
  lbTextoSituacao.Caption  := Pedido.TextoSituacao;
  edDataEntrega.Text       := DateToStr(Pedido.DataEntrega);
  edQuantidadeItens.Text   := FormatFloat('#,0.00', Pedido.QuantidadeItens);
  edValorTotalItens.Text   := FormatFloat('#,0.00', Pedido.ValorTotalItens);
  edObservacao.Text        := Pedido.Observacao;

  CarregaCampoOperacoes(Pedido.CodCPagto.Codigo);
  CarregaCampoFormaPagamento(Pedido.FormaPagamento.Codigo);
  CarregaCampoCliente(Pedido.Cliente.Codigo);
  CarregaCampoTipo(Pedido.Tipo);

  BuscarItens;
  AtualizarInformacoesDaGradeDeItens;

  wHabilitarCampos     := Pedido.Situacao = 1;
  pnDadosBase.Enabled  := wHabilitarCampos;
  gdListaItens.Enabled := wHabilitarCampos;
end;

procedure TfCadastrarPedidos.FormCreate(Sender: TObject);
begin
  Height     := 560;
  Width      := 640;
  VetorItens := TList<TItem>.Create;
end;

procedure TfCadastrarPedidos.CarregaCampoOperacoes(pCodCPagto: Integer);
var
  wCodigo: Integer;
  wDescricao: String;
  wIndex: Integer;
begin
  cbOperacao.Clear;

  queryOperacoes.Close;
  queryOperacoes.SQL.Text := 'SELECT * FROM CPAGTO WHERE SITUACAO = ''A''';
  queryOperacoes.Open;

  wIndex := -1;

  while not queryOperacoes.Eof do
  begin
    wCodigo    := queryOperacoes.FieldByName('CODCPAGTO').AsInteger;
    wDescricao := queryOperacoes.FieldByName('DESCRICAO').AsString;

    cbOperacao.Items.Add(wCodigo.ToString + '. ' + wDescricao);

    if pCodCPagto = wCodigo then
      wIndex := cbOperacao.Items.Count-1;

    queryOperacoes.Next;
  end;

  queryOperacoes.Close;
  cbOperacao.Update;
  cbOperacao.ItemIndex := wIndex;
end;

procedure TfCadastrarPedidos.CarregaCampoFormaPagamento(pFormaPagamento: Integer);
var
  wCodigo: Integer;
  wDescricao: String;
  wIndex: Integer;
begin
  cbFormaPagto.Clear;

  queryFormaPagto.Close;
  queryFormaPagto.SQL.Text := 'SELECT * FROM FORMAPAGTO WHERE SITUACAO = ''A''';
  queryFormaPagto.Open;

  wIndex := -1;

  while not queryFormaPagto.Eof do
  begin
    wCodigo    := queryFormaPagto.FieldByName('CODFORMAPAGTO').AsInteger;
    wDescricao := queryFormaPagto.FieldByName('DESCRICAO').AsString;

    cbFormaPagto.Items.Add(wCodigo.ToString + '. ' + wDescricao);

    if pFormaPagamento = wCodigo then
      wIndex := cbFormaPagto.Items.Count-1;

    queryFormaPagto.Next;
  end;

  queryFormaPagto.Close;
  cbFormaPagto.Update;
  cbFormaPagto.ItemIndex := wIndex;
end;

procedure TfCadastrarPedidos.CarregaCampoCliente(pCodigoCliente: Integer);
var
  wCodigo: Integer;
  wDescricao: String;
  wIndex: Integer;
begin
  cbCliente.Clear;

  queryClientes.Close;
  queryClientes.SQL.Text := 'SELECT * FROM CLIENTES';
  queryClientes.Open;

  wIndex := -1;

  while not queryClientes.Eof do
  begin
    wCodigo    := queryClientes.FieldByName('CODCLIENTE').AsInteger;
    wDescricao := queryClientes.FieldByName('NOME').AsString;

    cbCliente.Items.Add(wCodigo.ToString + '. ' + wDescricao);

    if pCodigoCliente = wCodigo then
      wIndex := cbCliente.Items.Count-1;

    queryClientes.Next;
  end;

  queryClientes.Close;
  cbCliente.Update;
  cbCliente.ItemIndex := wIndex;
end;

procedure TfCadastrarPedidos.CarregaCampoTipo(pTipo: String);
var
  wItem: Integer;
begin
  if pTipo = 'V' then
    wItem := 0
  else if pTipo = 'B' then
    wItem := 1
  else if pTipo = 'T' then
    wItem := 2
  else
    wItem := -1;

  cbTipo.ItemIndex := wItem;
end;

procedure TfCadastrarPedidos.AtualizarInformacoesDaGradeDeItens;
var
  i: Integer;
  wItem: TItem;
begin
  gdListaItens.RowCount := 1;

  gdListaItens.Cells[0, 0] := 'Nro Item';
  gdListaItens.Cells[1, 0] := 'Cód. Produto';
  gdListaItens.Cells[2, 0] := 'Produto';
  gdListaItens.Cells[3, 0] := 'Qtde';
  gdListaItens.Cells[4, 0] := 'Preco';
  gdListaItens.Cells[5, 0] := 'Valor Desconto';
  gdListaItens.Cells[6, 0] := 'Valor Total';

  for i := 0 to VetorItens.Count - 1 do
  begin
    wItem := VetorItens.Items[i];

    AdicionarLinhaNaGradeDeItens(i + 1, wItem);
  end;

  gdListaItens.RowCount := Max(VetorItens.Count + 1, 1);
end;

procedure TfCadastrarPedidos.AdicionarLinhaNaGradeDeItens(pSequencial: Integer; pItem: TItem);
begin
  gdListaItens.Cells[GRID_ITENS_NUMERO, pSequencial]     := pItem.NumeroItem.ToString;
  gdListaItens.Cells[GRID_ITENS_CODPRODUTO, pSequencial] := pItem.Produto.CodProduto;
  gdListaItens.Cells[GRID_ITENS_PRODUTO, pSequencial]    := pItem.Produto.Produto;
  gdListaItens.Cells[GRID_ITENS_QTDE, pSequencial]       := FormatFloat('#,0.00', pItem.Quantidade);
  gdListaItens.Cells[GRID_ITENS_PRECO, pSequencial]      := FormatFloat('#,0.00', pItem.Preco);
  gdListaItens.Cells[GRID_ITENS_VALORDESC, pSequencial]  := FormatFloat('#,0.00', pItem.ValDesconto);
  gdListaItens.Cells[GRID_ITENS_VALORTOTAL, pSequencial] := FormatFloat('#,0.00', pItem.ValTotal);
end;

procedure TfCadastrarPedidos.Excluir(Sender: TObject);
var
  wLinhaClicada: Integer;
  wItem: TItem;
  wNumeroItem: String;
  wMsg: String;
  wTipoMsg: TMsgDlgType;
  wBotoes: TMsgDlgButtons;
  wConfirmouExclusaoDoItem: Boolean;
begin
  if Assigned(Pedido) then
  begin
    if Pedido.Situacao = 2 then
    begin
      ShowMessage('Não é possível alterar os itens de um pedido finalizado.');
      Exit;
    end;
  end;

  wLinhaClicada := gdListaItens.Row;

  if wLinhaClicada < 1 then Exit;

  wItem       := VetorItens[wLinhaClicada - 1];
  wNumeroItem := wItem.FNumeroItem.ToString;

  wMsg     := 'Confirma que deseja excluir o item nº ' + wNumeroItem + '?';
  wTipoMsg := mtConfirmation;
  wBotoes  := [mbYes, mbNo];

  wConfirmouExclusaoDoItem := MessageDlg(wMsg, wTipoMsg, wBotoes, 0, mbNo) = mrYes;

  if wConfirmouExclusaoDoItem then
  begin
    ExcluirItem(wItem);
    AtualizarInformacoesDaGradeDeItens;
  end;

  AtualizarValoresEQuantidades;
end;

procedure TfCadastrarPedidos.Alterar(Sender: TObject);
var
  wLinhaClicada: Integer;
  wItem: TItem;
  wNumeroPedido: Integer;
  wNumeroItem: Integer;
begin
  if Assigned(Pedido) then
  begin
    if Pedido.Situacao = 2 then
    begin
      ShowMessage('Não é possível alterar os itens de um pedido finalizado.');
      Exit;
    end;
  end;

  wLinhaClicada := gdListaItens.Row;

  if wLinhaClicada < 1 then Exit;

  wItem := VetorItens[gdListaItens.Row - 1];

  if not Assigned(fManutencaoItens) then
    Application.CreateForm(TfManutencaoItens, fManutencaoItens);

  wNumeroPedido := StrToInt(edNumeroPedido.Text);

  if VetorItens.Count > 0 then
    wNumeroItem := VetorItens.Items[VetorItens.Count-1].NumeroItem + 1
  else
    wNumeroItem := 1;

  fManutencaoItens.CarregarItem(wNumeroPedido, wNumeroItem, wItem);
  fManutencaoItens.ShowModal;

  if fManutencaoItens.ModalResult = mrOk then
    AtualizaItemNoVetor(VetorItens[gdListaItens.Row - 1], fManutencaoItens.Item);

  AtualizarInformacoesDaGradeDeItens;
  AtualizarValoresEQuantidades;
end;

procedure TfCadastrarPedidos.Novo(Sender: TObject);
var
  wNumeroPedido: Integer;
  wNumeroItem: Integer;
begin
  if Assigned(Pedido) then
  begin
    if Pedido.Situacao = 2 then
    begin
      ShowMessage('Não é possível alterar os itens de um pedido finalizado.');
      Exit;
    end;
  end;

  if not Assigned(fManutencaoItens) then
    Application.CreateForm(TfManutencaoItens, fManutencaoItens);

  wNumeroPedido := StrToInt(edNumeroPedido.Text);

  if VetorItens.Count > 0 then
    wNumeroItem := VetorItens.Items[VetorItens.Count-1].NumeroItem + 1
  else
    wNumeroItem := 1;

  fManutencaoItens.NovoItem(wNumeroPedido, wNumeroItem);
  fManutencaoItens.ShowModal;

  if fManutencaoItens.ModalResult = mrOk then
  begin
    VetorItens.Add(fManutencaoItens.Item);
    AtualizarInformacoesDaGradeDeItens;
  end;

  AtualizarValoresEQuantidades;
end;

procedure TfCadastrarPedidos.BuscarItens;
var
  wItem: TItem;
  wNumeroPedidoStr: String;
  wNumeroPedProduto: Integer;
  wNumeroPedido: Integer;
  wNumeroItem: Integer;
  wProduto: TProduto;
  wQuantidade: Double;
  wUnidade: String;
  wPreco: Double;
  wPercentualDesconto: Double;
  wValDesconto: Double;
  wValTotal: Double;
  wExisteNoBancoDeDados: Boolean;
begin
  if not Assigned(Pedido) then Exit;

  wNumeroPedidoStr := Pedido.Numero.ToString;

  queryPedProds.Close;
  queryPedProds.SQL.Text := 'SELECT * ' +
                            'FROM PED_PRODS ' +
                            'WHERE NROPEDIDO = ' + wNumeroPedidoStr;
  queryPedProds.Open;

  VetorItens.Clear;

  while not queryPedProds.Eof do
  begin
    wNumeroPedProduto     := queryPedProds.FieldByName('NROPED_PRODS').asInteger;
    wNumeroPedido         := queryPedProds.FieldByName('NROPEDIDO').asInteger;
    wNumeroItem           := queryPedProds.FieldByName('NROITEM').asInteger;
    wProduto              := BuscaProduto(queryPedProds.FieldByName('CODPRODUTO').asString);
    wQuantidade           := queryPedProds.FieldByName('QTDE').AsFloat;
    wUnidade              := queryPedProds.FieldByName('UN').asString;
    wPreco                := queryPedProds.FieldByName('PRECO').AsFloat;
    wPercentualDesconto   := queryPedProds.FieldByName('PERCDESCONTO').AsFloat;
    wValDesconto          := queryPedProds.FieldByName('VALDESCONTO').AsFloat;
    wValTotal             := queryPedProds.FieldByName('VALTOTAL').AsFloat;
    wExisteNoBancoDeDados := True;

    wItem := TItem.Create(wNumeroPedProduto,
                          wNumeroPedido,
                          wNumeroItem,
                          wProduto,
                          wQuantidade,
                          wUnidade,
                          wPreco,
                          wPercentualDesconto,
                          wValDesconto,
                          wValTotal,
                          True);

    VetorItens.Add(wItem);

    queryPedProds.Next;
  end;
end;

function TfCadastrarPedidos.BuscaProduto(pCodProduto: String): TProduto;
var
  wProduto: TProduto;
  wCodProduto: String;
  wNomeProduto: String;
  wTipoProduto: String;
  wPrecoCusto: Double;
  wPrecoVenda: Double;
  wUnidade: String;
  wEstoqueAtual: Double;
  wSituacao: String;
  wPercICMS: Double;
begin
  queryProdutos.Close;
  queryProdutos.SQL.Text := 'SELECT * FROM PRODUTOS WHERE CODPRODUTO = ' + pCodProduto;
  queryProdutos.Open;

  wCodProduto   := queryProdutos.FieldByName('CODPRODUTO').AsString;
  wNomeProduto  := queryProdutos.FieldByName('PRODUTO').AsString;
  wTipoProduto  := queryProdutos.FieldByName('TIPOPRODUTO').AsString;
  wPrecoCusto   := queryProdutos.FieldByName('PRECOCUSTO').AsFloat;
  wPrecoVenda   := queryProdutos.FieldByName('PRECOVENDA').AsFloat;
  wUnidade      := queryProdutos.FieldByName('UN').AsString;
  wEstoqueAtual := queryProdutos.FieldByName('ESTOQUEATUAL').AsFloat;
  wSituacao     := queryProdutos.FieldByName('SITUACAO').AsString;
  wPercICMS     := queryProdutos.FieldByName('PERCICMS').AsFloat;

  queryProdutos.Close;

  wProduto := TProduto.Create(wCodProduto,
                              wNomeProduto,
                              wTipoProduto,
                              wPrecoCusto,
                              wPrecoVenda,
                              wUnidade,
                              wEstoqueAtual,
                              wSituacao,
                              wPercICMS);

  Result := wProduto;
end;

procedure TfCadastrarPedidos.ExcluirItem(pItem: TItem);
var
  wNumeroPedProduto: String;
begin
  if pItem.ExisteNoBancoDeDados then
  begin
    wNumeroPedProduto := pItem.NumeroPedProduto.ToString;

    queryPedProds.Close;
    queryPedProds.SQL.Text := 'DELETE FROM PED_PRODS ' +
                              'WHERE NROPED_PRODS = ' + wNumeroPedProduto;
    queryPedProds.ExecSQL;
  end;

  VetorItens.Remove(pItem);
end;

function TfCadastrarPedidos.RetornaProximoNumero: Integer;
begin
  queryPedidos.Close;
  queryPedidos.SQL.Text := 'SELECT GEN_ID(gen_pedidos_id, 0) AS NUM_ATUAL FROM PEDIDOS';
  queryPedidos.Open;

  Result := queryPedidos.FieldByName('NUM_ATUAL').AsInteger + 1;
end;

procedure TfCadastrarPedidos.AtualizaItemNoVetor(pItemAtual, pNovoItem: TItem);
var
  wProduto: TProduto;
  wItem: TItem;
begin
  wProduto := TProduto.Create(pNovoItem.Produto.CodProduto,
                              pNovoItem.Produto.Produto,
                              pNovoItem.Produto.TipoProduto,
                              pNovoItem.Produto.PrecoCusto,
                              pNovoItem.Produto.PrecoVenda,
                              pNovoItem.Produto.Unidade,
                              pNovoItem.Produto.EstoqueAtual,
                              pNovoItem.Produto.Situacao,
                              pNovoItem.Produto.PercICMS);

  wItem := TItem.Create(pNovoItem.NumeroPedProduto,
                        pNovoItem.NumeroPedido,
                        pNovoItem.NumeroItem,
                        wProduto,
                        pNovoItem.Quantidade,
                        pNovoItem.Unidade,
                        pNovoItem.Preco,
                        pNovoItem.PercentualDesconto,
                        pNovoItem.ValDesconto,
                        pNovoItem.ValTotal,
                        pNovoItem.ExisteNoBancoDeDados);

  VetorItens.Remove(pItemAtual);
  VetorItens.Insert(gdListaItens.Row - 1, wItem);
end;

procedure TfCadastrarPedidos.AtualizarValoresEQuantidades;
var
  item: TItem;
  wQtdTotal: Double;
  wValorTotal: Double;
begin
  for item in VetorItens do
  begin
    wQtdTotal    := wQtdTotal + item.Quantidade;
    wValorTotal  := wValorTotal + item.ValTotal;
  end;

  edQuantidadeItens.Text := FormatFloat('#,0.00', wQtdTotal);
  edValorTotalItens.Text := FormatFloat('#,0.00', wValorTotal);
end;

procedure TfCadastrarPedidos.SalvarPedido;
begin
  if PedidoNovo then
  begin
    InserirPedido;
    InserirItens;
  end
  else
  begin
    AlterarPedido;
    AlterarItens;
    InserirItens;
  end;
end;

procedure TfCadastrarPedidos.InserirPedido;
var
  wQuery: String;
begin
  wQuery := 'INSERT INTO PEDIDOS ' +
            '(DATA, CODCLIENTE, SITUACAO, DATAENTREGA, CODCPAGTO, CODFORMAPAGTO, QTDETOTAL, VALTOTAL, TIPO, OBS) ' +
            'VALUES ' +
            '(''' + StringData(edData.Text) + ''', ' +
              RetornaCodCliente + ', ' +
              '1, ' +
              '''' + StringData(edDataEntrega.Text) + ''', ' +
              RetornaCodOperacao + ', ' +
              RetornaCodFormaPagamento + ', ' +
              StringValor(edQuantidadeItens.Text) + ', ' +
              StringValor(edValorTotalItens.Text) + ', ' +
              '''' + RetornaTipoPedido + ''', ' +
              '''' + edObservacao.Text + ''')';

  queryPedidos.Close;
  queryPedidos.SQL.Text := wQuery;
  queryPedidos.ExecSQL;
end;

procedure TfCadastrarPedidos.AlterarPedido;
var
  wQuery: String;
begin
  wQuery := 'UPDATE PEDIDOS ' +
            'SET DATA = ''' + StringData(edData.Text) + ''', ' +
            'CODCLIENTE = ' + RetornaCodCliente + ', ' +
            'DATAENTREGA = ''' + StringData(edDataEntrega.Text) + ''', ' +
            'CODCPAGTO = ' + RetornaCodOperacao + ', ' +
            'CODFORMAPAGTO = ' + RetornaCodFormaPagamento + ', ' +
            'QTDETOTAL = ' + StringValor(edQuantidadeItens.Text) + ', ' +
            'VALTOTAL = ' + StringValor(edValorTotalItens.Text) + ', ' +
            'TIPO = ''' + RetornaTipoPedido + ''', ' +
            'OBS = ''' + edObservacao.Text + ''' ' +
            'WHERE NROPEDIDO = ' + edNumeroPedido.Text;

  queryPedidos.Close;
  queryPedidos.SQL.Text := wQuery;
  queryPedidos.ExecSQL;
end;

procedure TfCadastrarPedidos.InserirItens;
var
  wQuery: String;
  wItem: TItem;
begin
  for wItem in VetorItens do
  begin
    if wItem.ExisteNoBancoDeDados then Continue;

    wQuery := 'INSERT INTO PED_PRODS ' +
              '(NROPEDIDO, NROITEM, CODPRODUTO, QTDE, UN, PRECO, PERCDESCONTO, VALDESCONTO, VALTOTAL) ' +
              'VALUES ' +
              '(' + IntToStr(wItem.NumeroPedido) + ', ' +
              IntToStr(wItem.NumeroItem) + ', ' +
              '''' + wItem.Produto.CodProduto + ''', ' +
              StringValor(wItem.Quantidade.ToString) + ', ' +
              '''' + wItem.Unidade + ''', ' +
              StringValor(wItem.Preco.ToString) + ', ' +
              StringValor(wItem.PercentualDesconto.ToString) + ', ' +
              StringValor(wItem.ValDesconto.ToString) + ', ' +
              StringValor(wItem.ValTotal.ToString) + ')';

    queryPedProds.Close;
    queryPedProds.SQL.Text := wQuery;
    queryPedProds.ExecSQL;
  end;
end;

procedure TfCadastrarPedidos.AlterarItens;
var
  wQuery: String;
  wItem: TItem;
begin
  for wItem in VetorItens do
  begin
    if not wItem.ExisteNoBancoDeDados then Continue;

    wQuery := 'UPDATE PED_PRODS ' +
              'SET CODPRODUTO = ''' + wItem.Produto.CodProduto + ''', ' +
              'QTDE = ' + StringValor(wItem.Quantidade.ToString) + ', ' +
              'UN = ''' + wItem.Unidade + ''', ' +
              'PRECO = ' + StringValor(wItem.Preco.ToString) + ', ' +
              'PERCDESCONTO = ' + StringValor(wItem.PercentualDesconto.ToString) + ', ' +
              'VALDESCONTO = ' + StringValor(wItem.ValDesconto.ToString) + ', ' +
              'VALTOTAL = ' + StringValor(wItem.ValTotal.ToString) + ' ' +
              'WHERE NROPED_PRODS = ' + wItem.NumeroPedProduto.ToString;

    queryPedProds.Close;
    queryPedProds.SQL.Text := wQuery;
    queryPedProds.ExecSQL;
  end;
end;

function TfCadastrarPedidos.RetornaCodCliente: String;
begin
  Result := SplitString(cbCliente.Text, '.')[0];
end;

function TfCadastrarPedidos.RetornaCodOperacao: String;
begin
  Result := SplitString(cbOperacao.Text, '.')[0];
end;

function TfCadastrarPedidos.RetornaCodFormaPagamento: String;
begin
  Result := SplitString(cbFormaPagto.Text, '.')[0];
end;

function TfCadastrarPedidos.RetornaTipoPedido: String;
begin
  Result := Copy(cbTipo.Text, 0, 1);
end;

function TfCadastrarPedidos.StringValor(pTexto: String): String;
begin
  Result := StringReplace(pTexto, ',', '.', []);
end;

function TfCadastrarPedidos.StringData(pTexto: String): String;
var
  wDia: String;
  wMes: String;
  wAno: String;
begin
  wDia := Copy(pTexto, 0, 2);
  wMes := Copy(pTexto, 4, 2);
  wAno := Copy(pTexto, 7, 4);

  Result := wAno + '-' + wMes + '-' + wDia;
end;

end.
