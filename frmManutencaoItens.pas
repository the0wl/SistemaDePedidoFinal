unit frmManutencaoItens;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,

  frmDados, frmUtils, System.StrUtils;

type
  TfManutencaoItens = class(TForm)
    pnMenu: TPanel;
    btCancelar: TPanel;
    btGravar: TPanel;
    lbPedProd: TLabel;
    pnPedProd: TPanel;
    edPedProd: TEdit;
    pnNumeroPedido: TPanel;
    lbNumeroPedido: TLabel;
    edNumeroPedido: TEdit;
    pnNumeroItem: TPanel;
    lbNumeroItem: TLabel;
    edNumeroItem: TEdit;
    pnProduto: TPanel;
    lbProduto: TLabel;
    pnEsquerdo: TPanel;
    pnDireito: TPanel;
    pnQuantidade: TPanel;
    lbQuantidade: TLabel;
    edQuantidade: TEdit;
    pnUnidade: TPanel;
    lbUnidade: TLabel;
    edUnidade: TEdit;
    pnValorDesconto: TPanel;
    lbValDesconto: TLabel;
    pnPreco: TPanel;
    lbPreco: TLabel;
    cbProduto: TComboBox;
    pnPercDesc: TPanel;
    lbPercDesc: TLabel;
    pnValorTotal: TPanel;
    lbValorTotal: TLabel;
    queryProdutos: TFDQuery;
    queryPedProds: TFDQuery;
    edPercDesc: TEdit;
    edPreco: TEdit;
    edValorDesconto: TEdit;
    edValorTotal: TEdit;
    procedure Gravar(Sender: TObject);
    procedure Cancelar(Sender: TObject);
    procedure edQuantidadeKeyPress(Sender: TObject; var Key: Char);
    procedure edPercDescKeyPress(Sender: TObject; var Key: Char);
    procedure edPrecoKeyPress(Sender: TObject; var Key: Char);
    procedure edValorDescontoKeyPress(Sender: TObject; var Key: Char);
    procedure edValorTotalKeyPress(Sender: TObject; var Key: Char);
    procedure edPercDescExit(Sender: TObject);
    procedure edPrecoExit(Sender: TObject);
    procedure edValorDescontoExit(Sender: TObject);
    procedure edQuantidadeExit(Sender: TObject);
    procedure edPrecoEnter(Sender: TObject);
    procedure edValorDescontoEnter(Sender: TObject);
    procedure edValorTotalEnter(Sender: TObject);
    procedure edPercDescEnter(Sender: TObject);
    procedure edQuantidadeEnter(Sender: TObject);
    procedure edValorTotalExit(Sender: TObject);
    procedure edValorDescontoChange(Sender: TObject);
    procedure edQuantidadeChange(Sender: TObject);
    procedure edPrecoChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbProdutoChange(Sender: TObject);
  private
    CarregandoTela: Boolean;
    InsercaoDeItem: Boolean;

    procedure CarregaCampoProdutos(pCodProduto: Integer);
    procedure CalcularValorTotal;
    procedure CalcularDesconto(pCampoEditado: TEdit);
    procedure PreencherCampoProduto(pProduto: TProduto);
    procedure PreencheItem;

    function RetornaProximoNumero: Integer;
    function RetornaCodProduto: String;
    function BuscaProduto(pCodProduto: String): TProduto;
    function ValidarQuantidade(pExibirMensagem: Boolean = False): Boolean;
    function ValidarDesconto(pExibirMensagem: Boolean = False): Boolean;
    function ValidarPercDesc(pExibirMensagem: Boolean = False): Boolean;
    function ValidarPreco(pExibirMensagem: Boolean = False): Boolean;
    function ValidarValorTotal(pExibirMensagem: Boolean = False): Boolean;
    function BuscaUnidadeDoProduto: String;
    function BuscaPrecoVendaDoProduto: Double;
  public
    Item: TItem;

    procedure NovoItem(pNumeroPedido, pNumeroItem: Integer);
    procedure CarregarItem(pNumeroPedido, pNumeroItem: Integer; pItem: TItem);
  end;

var
  fManutencaoItens: TfManutencaoItens;

implementation

{$R *.dfm}

procedure TfManutencaoItens.Cancelar(Sender: TObject);
begin
  cbProduto.SetFocus;
  Application.ProcessMessages;
  Item := nil;
  ModalResult := mrCancel;
  Hide;
end;

procedure TfManutencaoItens.Gravar(Sender: TObject);
begin
  Application.ProcessMessages;

  if cbProduto.ItemIndex < 0 then
  begin
    ShowMessage('Escolha o produto que será adicionado ao pedido.');
    Exit;
  end;

  if edUnidade.Text = '' then
  begin
    ShowMessage('Defina a unidade de medida dos produtos que serão adicionados ao pedido.');
    Exit;
  end;

  if not ValidarQuantidade(True) then Exit;
  if not ValidarPreco(True) then Exit;
  if not ValidarValorTotal(True) then Exit;

  CalcularDesconto(nil);
  Application.ProcessMessages;

  PreencheItem;
  cbProduto.SetFocus;
  Application.ProcessMessages;
  ModalResult := mrOk;
  Hide;
end;

procedure TfManutencaoItens.PreencheItem;
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
begin
  wNumeroPedProduto   := StrToInt(edPedProd.Text);
  wNumeroPedido       := StrToInt(edNumeroPedido.Text);
  wNumeroItem         := StrToInt(edNumeroItem.Text);
  wProduto            := BuscaProduto(RetornaCodProduto);
  wQuantidade         := StrToFloat(edQuantidade.Text);
  wUnidade            := edUnidade.Text;
  wPreco              := StrToFloat(edPreco.Text);
  wPercentualDesconto := StrToFloat(edPercDesc.Text);
  wValDesconto        := StrToFloat(edValorDesconto.Text);
  wValTotal           := StrToFloat(edValorTotal.Text);

  Item := TItem.Create(wNumeroPedProduto,
                       wNumeroPedido,
                       wNumeroItem,
                       wProduto,
                       wQuantidade,
                       wUnidade,
                       wPreco,
                       wPercentualDesconto,
                       wValDesconto,
                       wValTotal,
                       not InsercaoDeItem);
end;

procedure TfManutencaoItens.NovoItem(pNumeroPedido, pNumeroItem: Integer);
begin
  CarregandoTela := True;
  InsercaoDeItem := True;

  edPedProd.Text       := RetornaProximoNumero.ToString;
  edNumeroPedido.Text  := pNumeroPedido.ToString;
  edNumeroItem.Text    := pNumeroItem.ToString;
  edPercDesc.Text      := '0,00';
  edQuantidade.Text    := '1,00';
  edUnidade.Text       := '';
  edPreco.Text         := '0,00';
  edValorDesconto.Text := '0,00';
  edValorTotal.Text    := '0,00';

  CarregaCampoProdutos(-1);
  CarregandoTela := False;
end;

procedure TfManutencaoItens.edValorTotalEnter(Sender: TObject);
begin
  if edValorTotal.Text = '0,00' then
    edValorTotal.Text := '';
end;

procedure TfManutencaoItens.edValorTotalExit(Sender: TObject);
begin
  if (edValorTotal.Text = '') or (not ValidarValorTotal(True)) then
  begin
    edValorTotal.Text := '0,00';
    Exit;
  end;
end;

procedure TfManutencaoItens.edValorTotalKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

  if not (Key in ['0'..'9', Chr(44), Chr(8)]) then
    Key:= #0;
end;

procedure TfManutencaoItens.FormCreate(Sender: TObject);
begin
  Height := 386;
  Width  := 386;
  Item   := nil;
end;

procedure TfManutencaoItens.edPercDescEnter(Sender: TObject);
begin
  if edPercDesc.Text = '0,00' then
    edPercDesc.Text := '';
end;

procedure TfManutencaoItens.edPercDescExit(Sender: TObject);
begin
  if (edPercDesc.Text = '') or (not ValidarPercDesc(True)) then
  begin
    edPercDesc.Text := '0,00';
    Exit;
  end;

  CalcularDesconto(edPercDesc);
end;

procedure TfManutencaoItens.edPercDescKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

  if not (Key in ['0'..'9', Chr(44), Chr(8)]) then
    Key:= #0;
end;

procedure TfManutencaoItens.edPrecoChange(Sender: TObject);
begin
  CalcularValorTotal;
end;

procedure TfManutencaoItens.edPrecoEnter(Sender: TObject);
begin
  if edPreco.Text = '0,00' then
    edPreco.Text := '';
end;

procedure TfManutencaoItens.edPrecoExit(Sender: TObject);
begin
  if (edPreco.Text = '') or (not ValidarPreco(True)) then
  begin
    edPreco.Text := '0,00';
    Exit;
  end;

  CalcularDesconto(edPreco);
end;

procedure TfManutencaoItens.edPrecoKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

  if not (Key in ['0'..'9', Chr(44), Chr(8)]) then
    Key:= #0;
end;

procedure TfManutencaoItens.edQuantidadeChange(Sender: TObject);
begin
  CalcularValorTotal;
end;

procedure TfManutencaoItens.edQuantidadeEnter(Sender: TObject);
begin
  if edQuantidade.Text = '0,00' then
    edQuantidade.Text := '';
end;

procedure TfManutencaoItens.edQuantidadeExit(Sender: TObject);
begin
  if (edQuantidade.Text = '') or (not ValidarQuantidade(True)) then
  begin
    edQuantidade.Text := '0,00';
    Exit;
  end;

  CalcularDesconto(edQuantidade);
end;

procedure TfManutencaoItens.edQuantidadeKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

  if not (Key in ['0'..'9', Chr(44), Chr(8)]) then
    Key:= #0;
end;

procedure TfManutencaoItens.edValorDescontoChange(Sender: TObject);
begin
  CalcularValorTotal;
end;

procedure TfManutencaoItens.edValorDescontoEnter(Sender: TObject);
begin
  if edValorDesconto.Text = '0,00' then
    edValorDesconto.Text := '';
end;

procedure TfManutencaoItens.edValorDescontoExit(Sender: TObject);
begin
  if edValorDesconto.Text = '' then
  begin
    edValorDesconto.Text := '0,00';
    Exit;
  end;

  if not ValidarDesconto(True) then
  begin
    edValorDesconto.Text := '0,00';
    Exit;
  end;

  CalcularDesconto(edValorDesconto);
end;

procedure TfManutencaoItens.edValorDescontoKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

  if not (Key in ['0'..'9', Chr(44), Chr(8)]) then
    Key:= #0;
end;

procedure TfManutencaoItens.CarregaCampoProdutos(pCodProduto: Integer);
var
  wCodigo: Integer;
  wDescricao: String;
  wIndex: Integer;
begin
  cbProduto.Clear;

  queryProdutos.Close;
  queryProdutos.SQL.Text := 'SELECT * FROM PRODUTOS WHERE SITUACAO = ''A''';
  queryProdutos.Open;

  wIndex := -1;

  while not queryProdutos.Eof do
  begin
    wCodigo    := queryProdutos.FieldByName('CODPRODUTO').AsInteger;
    wDescricao := queryProdutos.FieldByName('PRODUTO').AsString;

    cbProduto.Items.Add(wCodigo.ToString + '. ' + wDescricao);

    if pCodProduto = wCodigo then
      wIndex := cbProduto.Items.Count-1;

    queryProdutos.Next;
  end;

  queryProdutos.Close;
  cbProduto.Update;
  cbProduto.ItemIndex := wIndex;
end;

function TfManutencaoItens.RetornaProximoNumero: Integer;
begin
  queryPedProds.Close;
  queryPedProds.SQL.Text := 'SELECT GEN_ID(gen_ped_prods_id, 0) AS NUM_ATUAL FROM PED_PRODS';
  queryPedProds.Open;

  Result := queryPedProds.FieldByName('NUM_ATUAL').AsInteger + 1;
end;

function TfManutencaoItens.ValidarQuantidade(pExibirMensagem: Boolean = False): Boolean;
var
  wValor: Double;
  wMsgErro: String;
begin
  Result := False;

  try
    wValor := StrToFloatDef(edQuantidade.Text, 0);

    if wValor < 0 then
      wMsgErro := 'Não é permitido informar quantidades negativas.'
    else if wValor = 0 then
      wMsgErro := 'É necessário informar a quantidade de produtos a serem adicionados.';
  except
    wMsgErro := 'É necessário informar um valor de quantidade';
  end;

  if (wMsgErro <> '') and pExibirMensagem then
  begin
    ShowMessage(wMsgErro);
    Exit;
  end;

  Result := True;
end;

function TfManutencaoItens.ValidarDesconto(pExibirMensagem: Boolean = False): Boolean;
var
  wValor: Double;
  wValorMaximo: Double;
  wMsgErro: String;
begin
  Result := False;
  wMsgErro := '';

  try
    wValor := StrToFloatDef(edValorDesconto.Text, 0);
    wValorMaximo := StrToFloatDef(edPreco.Text, 0);

    if wValor >= wValorMaximo then
      wMsgErro := 'Não é permitido informar um percentual de desconto maior ou igual à 100%.';
  except
    wMsgErro := '';
  end;

  if (wMsgErro <> '') and pExibirMensagem then
  begin
    ShowMessage(wMsgErro);
    Exit;
  end;

  Result := True;
end;

function TfManutencaoItens.ValidarPercDesc(pExibirMensagem: Boolean = False): Boolean;
var
  wValor: Double;
  wMsgErro: String;
begin
  Result := False;
  wMsgErro := '';

  try
    wValor := StrToFloatDef(edPercDesc.Text, 0);

    if wValor < 0 then
      wMsgErro := 'Não é permitido informar um percentual de desconto negativo.'
    else if wValor >= 100 then
      wMsgErro := 'Não é permitido informar um percentual de desconto maior ou igual à 100%.';
  except
    //
  end;

  if (wMsgErro <> '') and pExibirMensagem then
  begin
    ShowMessage(wMsgErro);
    Exit;
  end;

  Result := True;
end;

function TfManutencaoItens.ValidarPreco(pExibirMensagem: Boolean = False): Boolean;
var
  wValor: Double;
  wMsgErro: String;
begin
  Result := False;
  wMsgErro := '';

  try
    wValor := StrToFloatDef(edPreco.Text, 0);

    if wValor = 0 then
      wMsgErro := 'É necessário informar o preço do produto.';
  except
    wMsgErro := 'É necessário informar o preço do produto.';
  end;

  if (wMsgErro <> '') and pExibirMensagem then
  begin
    ShowMessage(wMsgErro);
    Exit;
  end;

  Result := True;
end;

function TfManutencaoItens.ValidarValorTotal(pExibirMensagem: Boolean = False): Boolean;
var
  wValor: Double;
  wMsgErro: String;
begin
  Result := False;
  wMsgErro := '';

  try
    wValor := StrToFloatDef(edValorTotal.Text, 0);

    if wValor = 0 then
      wMsgErro := 'É necessário informar o valor total do produto.';
  except
    wMsgErro := 'É necessário informar o valor total do produto.';
  end;

  if (wMsgErro <> '') and pExibirMensagem then
  begin
    ShowMessage(wMsgErro);
    Exit;
  end;

  Result := True;
end;

procedure TfManutencaoItens.CarregarItem(pNumeroPedido, pNumeroItem: Integer; pItem: TItem);
begin
  CarregandoTela := True;
  InsercaoDeItem := False;

  edPedProd.Text       := pItem.NumeroPedProduto.ToString;
  edNumeroPedido.Text  := pItem.NumeroPedido.ToString;
  edNumeroItem.Text    := pItem.NumeroItem.ToString;
  edPercDesc.Text      := FormatFloat('#,0.00', pItem.PercentualDesconto);
  edQuantidade.Text    := FormatFloat('#,0.00', pItem.Quantidade);
  edUnidade.Text       := pItem.Produto.Unidade;
  edPreco.Text         := FormatFloat('#,0.00', pItem.Preco);
  edValorDesconto.Text := FormatFloat('#,0.00', pItem.ValDesconto);
  edValorTotal.Text    := FormatFloat('#,0.00', pItem.ValTotal);

  CarregaCampoProdutos(-1);
  PreencherCampoProduto(pItem.FProduto);
  CarregandoTela := False;
end;

procedure TfManutencaoItens.cbProdutoChange(Sender: TObject);
begin
  edUnidade.Text := BuscaUnidadeDoProduto;
  edPreco.Text   := FormatFloat('#,0.00', BuscaPrecoVendaDoProduto);
end;

procedure TfManutencaoItens.CalcularValorTotal;
var
  wQuantidade: Double;
  wPreco: Double;
  wDesconto: Double;
  wValor: Double;
begin
  if CarregandoTela then Exit;

  if not ValidarDesconto then Exit;
  if not ValidarQuantidade then Exit;
  if not ValidarPreco then Exit;

  wQuantidade := StrToFloatDef(edQuantidade.Text, 0);
  wPreco      := StrToFloatDef(edPreco.Text, 0);
  wDesconto   := StrToFloatDef(edValorDesconto.Text, 0);

  wValor := (wQuantidade * wPreco) - wDesconto;
  edValorTotal.Text := FormatFloat('#,0.00', wValor);
end;

procedure TfManutencaoItens.CalcularDesconto(pCampoEditado: TEdit);
var
  wPercDesconto: Double;
  wValDescontoAtual: Double;
  wPreco: Double;
  wValor: Double;
  wNovoPercDesc: Double;
  wQuantidade: Double;
begin
  wPercDesconto     := StrToFloatDef(edPercDesc.Text, 0) / 100;
  wValDescontoAtual := StrToFloatDef(edValorDesconto.Text, 0);
  wPreco            := StrToFloatDef(edPreco.Text, 0);
  wQuantidade       := StrToFloatDef(edQuantidade.Text, 0);
  wValor            := (wPreco * wQuantidade) * wPercDesconto;

  if pCampoEditado = edPercDesc then
  begin
    edValorDesconto.Text := FormatFloat('#,0.00', wValor);
  end
  else if pCampoEditado = edValorDesconto then
  begin
    wNovoPercDesc := (100 * wValDescontoAtual) / (wPreco * wQuantidade);

    edPercDesc.Text := FormatFloat('#,0.00', wNovoPercDesc);
  end
  else
  begin
    if wPercDesconto > 0 then
    begin
      edValorDesconto.Text := FormatFloat('#,0.00', wValor);
    end
    else
    begin
      wNovoPercDesc := (100 * wValDescontoAtual) / (wPreco * wQuantidade);

      edPercDesc.Text := FormatFloat('#,0.00', wNovoPercDesc);
    end;
  end;
end;

procedure TfManutencaoItens.PreencherCampoProduto(pProduto: TProduto);
begin
  cbProduto.ItemIndex := cbProduto.Items.IndexOf(pProduto.CodProduto + '. ' + pProduto.Produto);
end;

function TfManutencaoItens.RetornaCodProduto: String;
begin
  Result := SplitString(cbProduto.Text, '.')[0];
end;

function TfManutencaoItens.BuscaProduto(pCodProduto: String): TProduto;
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

function TfManutencaoItens.BuscaUnidadeDoProduto: String;
begin
  queryProdutos.Close;
  queryProdutos.SQL.Text := 'SELECT UN ' +
                            'FROM PRODUTOS ' +
                            'WHERE CODPRODUTO = ''' + RetornaCodProduto + '''';
  queryProdutos.Open;

  Result := queryProdutos.FieldByName('UN').AsString;
end;

function TfManutencaoItens.BuscaPrecoVendaDoProduto: Double;
begin
  queryProdutos.Close;
  queryProdutos.SQL.Text := 'SELECT PRECOVENDA ' +
                            'FROM PRODUTOS ' +
                            'WHERE CODPRODUTO = ''' + RetornaCodProduto + '''';
  queryProdutos.Open;

  Result := queryProdutos.FieldByName('PRECOVENDA').AsFloat;
end;

end.
