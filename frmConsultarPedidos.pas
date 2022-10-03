unit frmConsultarPedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,

  System.Math, System.Generics.Collections, frmDados, frmUtils, frmConsts,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask, System.StrUtils;

type
  TfConsultarPedidos = class(TForm)
    gdListaPedidos: TStringGrid;
    queryPedidos: TFDQuery;
    queryClientes: TFDQuery;
    queryBairros: TFDQuery;
    queryCidades: TFDQuery;
    queryPaises: TFDQuery;
    queryFormaPagto: TFDQuery;
    queryOperacoes: TFDQuery;
    pnMenu: TPanel;
    btSair: TPanel;
    btFinalizar: TPanel;
    btAlterar: TPanel;
    btNovo: TPanel;
    btExcluir: TPanel;
    pnFiltros: TPanel;
    edFiltroDataInicial: TMaskEdit;
    edFiltroDataFinal: TMaskEdit;
    lbFiltroDataInicial: TLabel;
    lbFiltroDataFinal: TLabel;
    lbFiltroCliente: TLabel;
    cbFiltroCliente: TComboBox;
    lbFiltroSituacao: TLabel;
    cbFiltroSituacao: TComboBox;
    lbFiltroTipo: TLabel;
    cbFiltroTipo: TComboBox;
    btFiltroFiltrar: TButton;
    cbHabilitarFiltros: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Sair(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Finalizar(Sender: TObject);
    procedure Excluir(Sender: TObject);
    procedure Novo(Sender: TObject);
    procedure Alterar(Sender: TObject);
    procedure checkAtivarFiltrosClick(Sender: TObject);
    procedure btFiltroFiltrarClick(Sender: TObject);
    procedure cbHabilitarFiltrosClick(Sender: TObject);
  private
    VetorPedidos: TList<TPedido>;

    procedure AtualizarInformacoesDaGradeDePedidos;
    procedure AdicionarLinhaNaGradeDePedidos(pSequencial: Integer; pPedido: TPedido);
    procedure BuscarPedidos;
    procedure FinalizarPedido(pPedido: TPedido);
    procedure ExcluirPedido(pPedido: TPedido);
    procedure CarregaCampoCliente(pCodigoCliente: Integer);
    procedure CarregaCampoTipo(pTipo: String);
    procedure CarregaCampoSituacao(pSituacao: Integer);

    function BuscarCliente(pCodCliente: Integer): TCliente;
    function BuscarOperacao(pCodOperacao: Integer): TOperacao;
    function BuscarFormaPagamento(pCodFormaPagamento: Integer): TFormaPagamento;
    function BuscarBairro(pCodBairro: Integer): TBairro;
    function BuscarCidade(pCodCidade: Integer): TCidade;
    function BuscarPais(pCodPais: Integer): TPais;
    function StringValor(pTexto: String): String;
    function StringData(pTexto: String): String;
    function RetornaFiltrosDeBusca: String;
    function RetornaCodCliente: String;
    function RetornaTipoPedido: String;
    function RetornaSituacao: String;

  public
    NomeUsuario: String;
  end;

var
  fConsultarPedidos: TfConsultarPedidos;

implementation

{$R *.dfm}

uses frmManutencaoPedidos;

procedure TfConsultarPedidos.FormCreate(Sender: TObject);
begin
  Height := 360;
  Width  := 640;

  edFiltroDataInicial.Text   := FormatDateTime('DD/MM/YYYY', Now());
  edFiltroDataFinal.Text     := FormatDateTime('DD/MM/YYYY', Now());
  CarregaCampoCliente(1);
  CarregaCampoTipo('V');
  CarregaCampoSituacao(1);
end;

procedure TfConsultarPedidos.CarregaCampoCliente(pCodigoCliente: Integer);
var
  wCodigo: Integer;
  wDescricao: String;
  wIndex: Integer;
begin
  cbFiltroCliente.Clear;

  queryClientes.Close;
  queryClientes.SQL.Text := 'SELECT * FROM CLIENTES';
  queryClientes.Open;

  wIndex := -1;

  while not queryClientes.Eof do
  begin
    wCodigo    := queryClientes.FieldByName('CODCLIENTE').AsInteger;
    wDescricao := queryClientes.FieldByName('NOME').AsString;

    cbFiltroCliente.Items.Add(wCodigo.ToString + '. ' + wDescricao);

    if pCodigoCliente = wCodigo then
      wIndex := cbFiltroCliente.Items.Count-1;

    queryClientes.Next;
  end;

  queryClientes.Close;
  cbFiltroCliente.Update;
  cbFiltroCliente.ItemIndex := wIndex;
end;

procedure TfConsultarPedidos.CarregaCampoTipo(pTipo: String);
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

  cbFiltroTipo.ItemIndex := wItem;
end;

procedure TfConsultarPedidos.cbHabilitarFiltrosClick(Sender: TObject);
begin
  pnFiltros.Enabled := cbHabilitarFiltros.Checked;
end;

procedure TfConsultarPedidos.checkAtivarFiltrosClick(Sender: TObject);
begin
  BuscarPedidos;
  AtualizarInformacoesDaGradeDePedidos;
end;

procedure TfConsultarPedidos.CarregaCampoSituacao(pSituacao: Integer);
var
  wItem: Integer;
begin
  if pSituacao = 1 then
    wItem := 0
  else if pSituacao = 2 then
    wItem := 1
  else
    wItem := -1;

  cbFiltroSituacao.ItemIndex := wItem;
end;

procedure TfConsultarPedidos.FormShow(Sender: TObject);
begin
  BuscarPedidos;
  AtualizarInformacoesDaGradeDePedidos;
end;

procedure TfConsultarPedidos.BuscarPedidos;
var
  wPedido: TPedido;
  wNumero: Integer;
  wData: TDate;
  wCliente: TCliente;
  wSituacao: Integer;
  wDataEntrega: TDate;
  wCodCPagto: TOperacao;
  wFormaPagamento: TFormaPagamento;
  wQuantidadeItens: Double;
  wValorTotalItens: Double;
  wTipo: String;
  wObservacao: String;
  wFiltros: String;
begin
  if cbHabilitarFiltros.Checked then
    wFiltros := RetornaFiltrosDeBusca
  else
    wFiltros := '';

  queryPedidos.Close;
  queryPedidos.SQL.Text := 'SELECT * FROM PEDIDOS ' + wFiltros;
  queryPedidos.Open;

  if not Assigned(VetorPedidos) then
    VetorPedidos := TList<TPedido>.Create;

  VetorPedidos.Clear;

  while not queryPedidos.Eof do
  begin
    wNumero          := queryPedidos.FieldByName('NROPEDIDO').asInteger;
    wData            := queryPedidos.FieldByName('DATA').AsDateTime;
    wCliente         := BuscarCliente(queryPedidos.FieldByName('CODCLIENTE').AsInteger);
    wSituacao        := queryPedidos.FieldByName('SITUACAO').AsInteger;
    wDataEntrega     := queryPedidos.FieldByName('DATAENTREGA').AsDateTime;
    wCodCPagto       := BuscarOperacao(queryPedidos.FieldByName('CODCPAGTO').AsInteger);
    wFormaPagamento  := BuscarFormaPagamento(queryPedidos.FieldByName('CODFORMAPAGTO').AsInteger);
    wQuantidadeItens := queryPedidos.FieldByName('QTDETOTAL').AsFloat;
    wValorTotalItens := queryPedidos.FieldByName('VALTOTAL').AsFloat;
    wTipo            := queryPedidos.FieldByName('TIPO').AsString;
    wObservacao      := queryPedidos.FieldByName('OBS').AsString;

    wPedido := TPedido.Create(wNumero,
                              wData,
                              wCliente,
                              wSituacao,
                              wDataEntrega,
                              wCodCPagto,
                              wFormaPagamento,
                              wQuantidadeItens,
                              wValorTotalItens,
                              wTipo,
                              wObservacao);

    VetorPedidos.Add(wPedido);

    queryPedidos.Next;
  end;
end;

procedure TfConsultarPedidos.btFiltroFiltrarClick(Sender: TObject);
begin
  BuscarPedidos;
  AtualizarInformacoesDaGradeDePedidos;
end;

function TfConsultarPedidos.RetornaFiltrosDeBusca: String;
var
  wFiltroData: String;
  wFiltroCliente: String;
  wFiltroSituacao: String;
  wFiltroTipo: String;
begin
  wFiltroData      := '(DATA BETWEEN ''' + StringData(edFiltroDataInicial.Text) + ''' AND ' +
                      '''' + StringData(edFiltroDataFinal.Text) + ''') ';
  wFiltroCliente   := 'CODCLIENTE = ' + RetornaCodCliente;
  wFiltroSituacao  := 'SITUACAO = ' + RetornaSituacao;
  wFiltroTipo      := 'TIPO = ''' + RetornaTipoPedido + '''';

  Result := 'WHERE ' + wFiltroData +
            ' AND ' + wFiltroCliente +
            ' AND ' + wFiltroSituacao +
            ' AND ' + wFiltroTipo;
end;

procedure TfConsultarPedidos.Alterar(Sender: TObject);
var
  wLinhaClicada: Integer;
  wPedido: TPedido;
begin
  wLinhaClicada := gdListaPedidos.Row;

  if wLinhaClicada < 1 then Exit;

  wPedido := VetorPedidos[gdListaPedidos.Row - 1];

  if not Assigned(fCadastrarPedidos) then
    Application.CreateForm(TfCadastrarPedidos, fCadastrarPedidos);

  fCadastrarPedidos.CarregarPedido(wPedido);
  fCadastrarPedidos.ShowModal;

  BuscarPedidos;
  AtualizarInformacoesDaGradeDePedidos;
end;

procedure TfConsultarPedidos.Novo(Sender: TObject);
begin
  if not Assigned(fCadastrarPedidos) then
    Application.CreateForm(TfCadastrarPedidos, fCadastrarPedidos);

  fCadastrarPedidos.NovoPedido;
  fCadastrarPedidos.ShowModal;

  BuscarPedidos;
  AtualizarInformacoesDaGradeDePedidos;
end;

procedure TfConsultarPedidos.AtualizarInformacoesDaGradeDePedidos;
var
  i: Integer;
  wPedido: TPedido;
begin
  gdListaPedidos.RowCount := 1;

  gdListaPedidos.Cells[0, 0] := 'Seq';
  gdListaPedidos.Cells[1, 0] := 'Nº Pedido';
  gdListaPedidos.Cells[2, 0] := 'Data';
  gdListaPedidos.Cells[3, 0] := 'Cód Cliente';
  gdListaPedidos.Cells[4, 0] := 'Nome Cliente';
  gdListaPedidos.Cells[5, 0] := 'Situação';
  gdListaPedidos.Cells[6, 0] := 'Tipo';
  gdListaPedidos.Cells[7, 0] := 'Qtde Total';
  gdListaPedidos.Cells[8, 0] := 'Valor Total';

  for i := 0 to VetorPedidos.Count - 1 do
  begin
    wPedido := VetorPedidos.Items[i];

    AdicionarLinhaNaGradeDePedidos(i + 1, wPedido);
  end;

  gdListaPedidos.RowCount := Max(VetorPedidos.Count + 1, 1);
end;

procedure TfConsultarPedidos.AdicionarLinhaNaGradeDePedidos(pSequencial: Integer; pPedido: TPedido);
begin
  gdListaPedidos.Cells[GRID_PEDIDO_SEQUENCIAL, pSequencial]       := pSequencial.ToString;
  gdListaPedidos.Cells[GRID_PEDIDO_NUMERO, pSequencial]           := pPedido.Numero.ToString;
  gdListaPedidos.Cells[GRID_PEDIDO_DATA, pSequencial]             := FormatDateTime('DD/MM/YYYY', pPedido.Data);
  gdListaPedidos.Cells[GRID_PEDIDO_CODIGO_CLIENTE, pSequencial]   := pPedido.Cliente.Codigo.ToString;
  gdListaPedidos.Cells[GRID_PEDIDO_NOME_CLIENTE, pSequencial]     := pPedido.Cliente.Nome;
  gdListaPedidos.Cells[GRID_PEDIDO_SITUACAO, pSequencial]         := pPedido.TextoSituacao;
  gdListaPedidos.Cells[GRID_PEDIDO_TIPO, pSequencial]             := pPedido.TextoTipo;
  gdListaPedidos.Cells[GRID_PEDIDO_QUANTIDADE_ITENS, pSequencial] := FormatFloat('#,0.00', pPedido.QuantidadeItens);
  gdListaPedidos.Cells[GRID_PEDIDO_VALOR_TOTAL, pSequencial]      := FormatFloat('#,0.00', pPedido.ValorTotalItens);
end;

procedure TfConsultarPedidos.Sair(Sender: TObject);
begin
  ModalResult := mrCancel;
  Hide;
end;

procedure TfConsultarPedidos.Finalizar(Sender: TObject);
var
  wLinhaClicada: Integer;
  wPedido: TPedido;
  wNumeroPedido: String;
  wMsg: String;
  wTipoMsg: TMsgDlgType;
  wBotoes: TMsgDlgButtons;
  wConfirmouFinalizacaoDoPedido: Boolean;
begin
  if NomeUsuario <> 'ADMINISTRADOR' then
  begin
    ShowMessage('Somente o administrador pode realizar esta ação.');
    Exit;
  end;

  wLinhaClicada := gdListaPedidos.Row;

  if wLinhaClicada < 1 then Exit;

  wPedido       := VetorPedidos[wLinhaClicada - 1];
  wNumeroPedido := wPedido.Numero.ToString;

  if wPedido.Situacao = 2 then
  begin
    ShowMessage('O pedido nº ' + wNumeroPedido + ' já está finalizado!');
    Exit;
  end;

  wMsg     := 'Confirma que deseja finalizar do pedido nº ' + wNumeroPedido + '?';
  wTipoMsg := mtConfirmation;
  wBotoes  := [mbYes, mbNo];

  wConfirmouFinalizacaoDoPedido := MessageDlg(wMsg, wTipoMsg, wBotoes, 0, mbNo) = mrYes;

  if wConfirmouFinalizacaoDoPedido then
  begin
    FinalizarPedido(wPedido);
    AtualizarInformacoesDaGradeDePedidos;
  end;
end;

procedure TfConsultarPedidos.Excluir(Sender: TObject);
var
  wLinhaClicada: Integer;
  wPedido: TPedido;
  wNumeroPedido: String;
  wMsg: String;
  wTipoMsg: TMsgDlgType;
  wBotoes: TMsgDlgButtons;
  wConfirmouExclusaoDoPedido: Boolean;
begin
  wLinhaClicada := gdListaPedidos.Row;

  if wLinhaClicada < 1 then Exit;

  wPedido       := VetorPedidos[wLinhaClicada - 1];
  wNumeroPedido := wPedido.Numero.ToString;

  wMsg     := 'Confirma que deseja excluir o pedido nº ' + wNumeroPedido + '?';
  wTipoMsg := mtConfirmation;
  wBotoes  := [mbYes, mbNo];

  wConfirmouExclusaoDoPedido := MessageDlg(wMsg, wTipoMsg, wBotoes, 0, mbNo) = mrYes;

  if wConfirmouExclusaoDoPedido then
  begin
    ExcluirPedido(wPedido);
    AtualizarInformacoesDaGradeDePedidos;
  end;
end;

function TfConsultarPedidos.BuscarCliente(pCodCliente: Integer): TCliente;
var
  wCliente: TCliente;
  wCodigo: Integer;
  wNome: String;
  wNomeFantasia: String;
  wEndereco: String;
  wBairro: TBairro;
  wCidade: TCidade;
  wCEP: String;
  wTelefone: String;
  wCelular: String;
  wTipoDePessoa: String;
  wCNPJ: String;
  wIE: String;
  wDataNasc: TDate;
  wEmail: String;
  wDataCadastro: TDate;
begin
  queryClientes.Close;
  queryClientes.SQL.Text := 'SELECT * FROM CLIENTES WHERE CODCLIENTE = ' + IntToStr(pCodCliente);
  queryClientes.Open;

  wCodigo       := queryClientes.FieldByName('CODCLIENTE').AsInteger;
  wNome         := queryClientes.FieldByName('NOME').AsString;
  wNomeFantasia := queryClientes.FieldByName('FANTASIA').AsString;
  wEndereco     := queryClientes.FieldByName('ENDERECO').AsString;
  wBairro       := BuscarBairro(queryClientes.FieldByName('CODBAIRRO').AsInteger);
  wCidade       := BuscarCidade(queryClientes.FieldByName('CODCIDADE').AsInteger);
  wCEP          := queryClientes.FieldByName('CEP').AsString;
  wTelefone     := queryClientes.FieldByName('FONE').AsString;
  wCelular      := queryClientes.FieldByName('CELULAR').AsString;
  wTipoDePessoa := queryClientes.FieldByName('PESSOA').AsString;
  wCNPJ         := queryClientes.FieldByName('CNPJ').AsString;
  wIE           := queryClientes.FieldByName('IE').AsString;
  wDataNasc     := queryClientes.FieldByName('DATANASC').AsDateTime;
  wEmail        := queryClientes.FieldByName('EMAIL').AsString;
  wDataCadastro := queryClientes.FieldByName('DATACADASTRO').AsDateTime;

  queryClientes.Close;

  wCliente := TCliente.Create(wCodigo,
                              wNome,
                              wNomeFantasia,
                              wEndereco,
                              wBairro,
                              wCidade,
                              wCEP,
                              wTelefone,
                              wCelular,
                              wTipoDePessoa,
                              wCNPJ,
                              wIE,
                              wDataNasc,
                              wEmail,
                              wDataCadastro);

  Result := wCliente;
end;

function TfConsultarPedidos.BuscarOperacao(pCodOperacao: Integer): TOperacao;
var
  wOperacao: TOperacao;
  wCodigo: Integer;
  wDescricao: String;
  wQuantidadeParcelas: Integer;
  wDiasEntreParcelas: Integer;
  wDiasParaPrimeiraParcela: Integer;
  wSituacao: String;
begin
  queryOperacoes.Close;
  queryOperacoes.SQL.Text := 'SELECT * FROM CPAGTO WHERE CODCPAGTO = ' + IntToStr(pCodOperacao);
  queryOperacoes.Open;

  wCodigo                  := queryOperacoes.FieldByName('CODCPAGTO').AsInteger;
  wDescricao               := queryOperacoes.FieldByName('DESCRICAO').AsString;
  wQuantidadeParcelas      := queryOperacoes.FieldByName('NROPARCELAS').AsInteger;
  wDiasEntreParcelas       := queryOperacoes.FieldByName('DIASPARCELAS').AsInteger;
  wDiasParaPrimeiraParcela := queryOperacoes.FieldByName('DIASPRIMPARC').AsInteger;
  wSituacao                := queryOperacoes.FieldByName('SITUACAO').AsString;

  wOperacao := TOperacao.Create(wCodigo,
                                wDescricao,
                                wQuantidadeParcelas,
                                wDiasEntreParcelas,
                                wDiasParaPrimeiraParcela,
                                wSituacao);

  queryOperacoes.Close;

  Result := wOperacao;
end;

function TfConsultarPedidos.BuscarFormaPagamento(pCodFormaPagamento: Integer): TFormaPagamento;
var
  wFormaPagamento: TFormaPagamento;
  wCodigo: Integer;
  wDescricao: String;
  wSituacao: String;
begin
  queryFormaPagto.Close;
  queryFormaPagto.SQL.Text := 'SELECT * FROM FORMAPAGTO WHERE CODFORMAPAGTO = ' + IntToStr(pCodFormaPagamento);
  queryFormaPagto.Open;

  wCodigo    := queryFormaPagto.FieldByName('CODFORMAPAGTO').AsInteger;
  wDescricao := queryFormaPagto.FieldByName('DESCRICAO').AsString;
  wSituacao  := queryFormaPagto.FieldByName('SITUACAO').AsString;

  queryFormaPagto.Close;

  wFormaPagamento := TFormaPagamento.Create(wCodigo, wDescricao, wSituacao);

  Result := wFormaPagamento;
end;

function TfConsultarPedidos.BuscarBairro(pCodBairro: Integer): TBairro;
var
  wBairro: TBairro;
  wCodigo: Integer;
  wNome: String;
begin
  queryBairros.Close;
  queryBairros.SQL.Text := 'SELECT * FROM BAIRROS WHERE CODBAIRRO = ' + IntToStr(pCodBairro);
  queryBairros.Open;

  wCodigo := queryBairros.FieldByName('CODBAIRRO').AsInteger;
  wNome   := queryBairros.FieldByName('DESCRICAO').AsString;

  queryFormaPagto.Close;

  wBairro := TBairro.Create(wCodigo, wNome);

  Result := wBairro;
end;

function TfConsultarPedidos.BuscarCidade(pCodCidade: Integer): TCidade;
var
  wCidade: TCidade;
  wCodigo: Integer;
  wNome: String;
  wUF: String;
  wPais: TPais;
  wCodIBGE: Integer;
begin
  queryCidades.Close;
  queryCidades.SQL.Text := 'SELECT * FROM CIDADES WHERE CODCIDADE = ' + IntToStr(pCodCidade);
  queryCidades.Open;

  wCodigo  := queryCidades.FieldByName('CODCIDADE').AsInteger;
  wNome    := queryCidades.FieldByName('CIDADE').AsString;
  wUF      := queryCidades.FieldByName('UF').AsString;
  wPais    := BuscarPais(queryCidades.FieldByName('CODPAIS').AsInteger);
  wCodIBGE := queryCidades.FieldByName('CODIBGE').AsInteger;

  queryCidades.Close;

  wCidade := TCidade.Create(wCodigo, wNome, wUF, wPais, wCodIBGE);

  Result := wCidade;
end;

function TfConsultarPedidos.BuscarPais(pCodPais: Integer): TPais;
var
  wPais: TPais;
  wCodigo: Integer;
  wNome: String;
  wSigla: String;
  wCodBACEN: Integer;
begin
  queryPaises.Close;
  queryPaises.SQL.Text := 'SELECT * FROM PAISES WHERE CODPAIS = ' + IntToStr(pCodPais);
  queryPaises.Open;

  wCodigo   := queryPaises.FieldByName('CODPAIS').AsInteger;
  wNome     := queryPaises.FieldByName('DESCRICAO').AsString;
  wSigla    := queryPaises.FieldByName('SIGLA').AsString;
  wCodBACEN := queryPaises.FieldByName('CODBACEN').AsInteger;

  queryPaises.Close;

  wPais := TPais.Create(wCodigo, wNome, wSigla, wCodBACEN);

  Result := wPais;
end;

procedure TfConsultarPedidos.FinalizarPedido(pPedido: TPedido);
var
  wNumeroPedido: String;
begin
  wNumeroPedido := pPedido.Numero.ToString;

  queryPedidos.Close;
  queryPedidos.SQL.Text := 'UPDATE PEDIDOS ' +
                           'SET SITUACAO = 2 ' +
                           'WHERE NROPEDIDO  = ' + wNumeroPedido;
  queryPedidos.ExecSQL;

  pPedido.FinalizarPedido;
end;

procedure TfConsultarPedidos.ExcluirPedido(pPedido: TPedido);
var
  wNumeroPedido: String;
begin
  if pPedido.Situacao = 2 then
  begin
    ShowMessage('Não é possível excluir pedidos que já foram finalizados');
    Exit;
  end;

  wNumeroPedido := pPedido.Numero.ToString;

  queryPedidos.Close;
  queryPedidos.SQL.Text := 'DELETE FROM PED_PRODS ' +
                           'WHERE NROPEDIDO  = ' + wNumeroPedido;
  queryPedidos.ExecSQL;

  queryPedidos.Close;
  queryPedidos.SQL.Text := 'DELETE FROM PEDIDOS ' +
                           'WHERE NROPEDIDO  = ' + wNumeroPedido;
  queryPedidos.ExecSQL;

  VetorPedidos.Remove(pPedido);
end;

function TfConsultarPedidos.StringValor(pTexto: String): String;
begin
  Result := StringReplace(pTexto, ',', '.', []);
end;

function TfConsultarPedidos.StringData(pTexto: String): String;
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

function TfConsultarPedidos.RetornaCodCliente: String;
begin
  Result := SplitString(cbFiltroCliente.Text, '.')[0];
end;

function TfConsultarPedidos.RetornaTipoPedido: String;
begin
  Result := Copy(cbFiltroTipo.Text, 0, 1);
end;

function TfConsultarPedidos.RetornaSituacao: String;
begin
  if cbFiltroSituacao.Text = 'Pendente' then
    Result := '1'
  else if cbFiltroSituacao.Text = 'Finalizado' then
    Result := '2'
  else
    Result := '1';
end;

end.
