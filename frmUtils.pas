unit frmUtils;

interface

uses System.SysUtils;

type

{$REGION 'Declaração da classe TPais'}
  TPais = class
    FCodigo: Integer;
    FNome: String;
    FSigla: String;
    FCodBACEN: Integer;

  private

  public
    constructor Create(pCodigo: Integer;
                       pNome: String;
                       pSigla: String;
                       pCodBACEN: Integer);
    destructor Destroy; override;

    property Codigo   : Integer read FCodigo;
    property Nome     : String  read FNome;
    property Sigla    : String  read FSigla;
    property CodBACEN : Integer read FCodBACEN;

  end;
{$ENDREGION}

{$REGION 'Declaração da classe TBairro'}
  TBairro = class
    FCodigo: Integer;
    FNome: String;

  private

  public
    constructor Create(pCodigo: Integer; pNome: String);
    destructor Destroy; override;

    property Codigo : Integer read FCodigo;
    property Nome   : String  read FNome;

  end;
{$ENDREGION}

{$REGION 'Declaração da classe TCidade'}
  TCidade = class
    FCodigo: Integer;
    FNome: String;
    FUF: String;
    FPais: TPais;
    FCodIBGE: Integer;
  private

  public
    constructor Create(pCodigo: Integer;
                       pNome: String;
                       pUF: String;
                       pPais: TPais;
                       pCodIBGE: Integer);
    destructor Destroy; override;

    property Codigo  : Integer read FCodigo;
    property Nome    : String  read FNome;
    property UF      : String  read FUF;
    property Pais    : TPais   read FPais;
    property CodIBGE : Integer read FCodIBGE;

  end;
{$ENDREGION}

{$REGION 'Declaração da classe TFormaPagamento'}
  TFormaPagamento = class
    FCodigo: Integer;
    FDescricao: String;
    FSituacao: String;

  private
  public
    constructor Create(pCodigo: Integer;
                       pDescricao: String;
                       pSituacao: String);
    destructor Destroy; override;

    property Codigo    : Integer read FCodigo;
    property Descricao : String read FDescricao;
    property Situacao  : String read FSituacao;
  end;
{$ENDREGION}

{$REGION 'Declaração da classe TOperacao'}
  TOperacao = class
    FCodigo: Integer;
    FDescricao: String;
    FQuantidadeParcelas: Integer;
    FDiasEntreParcelas: Integer;
    FDiasParaPrimeiraParcela: Integer;
    FSituacao: String;

  private
  public
    constructor Create(pCodigo: Integer;
                       pDescricao: String;
                       pQuantidadeParcelas: Integer;
                       pDiasEntreParcelas: Integer;
                       pDiasParaPrimeiraParcela: Integer;
                       pSituacao: String);
    destructor Destroy; override;

    property Codigo                  : Integer read FCodigo;
    property Descricao               : String read FDescricao;
    property QuantidadeParcelas       : Integer read FQuantidadeParcelas;
    property DiasEntreParcelas       : Integer read FDiasEntreParcelas;
    property DiasParaPrimeiraParcela : Integer read FDiasParaPrimeiraParcela;
    property Situacao                : String read FSituacao;
  end;
{$ENDREGION}

{$REGION 'Declaração da classe TCliente'}
  TCliente = class
    FCodigo: Integer;
    FNome: String;
    FNomeFantasia: String;
    FEndereco: String;
    FBairro: TBairro;
    FCidade: TCidade;
    FCEP: String;
    FTelefone: String;
    FCelular: String;
    FTipoDePessoa: String;
    FCNPJ: String;
    FIE: String;
    FDataNasc: TDate;
    FEmail: String;
    FDataCadastro: TDate;

  private

  public
    constructor Create(pCodigo: Integer;
                       pNome: String;
                       pNomeFantasia: String;
                       pEndereco: String;
                       pBairro: TBairro;
                       pCidade: TCidade;
                       pCEP: String;
                       pTelefone: String;
                       pCelular: String;
                       pTipoDePessoa: String;
                       pCNPJ: String;
                       pIE: String;
                       pDataNasc: TDate;
                       pEmail: String;
                       pDataCadastro: TDate);
    destructor Destroy; override;

    function getNome: String;

    property Codigo       : Integer read FCodigo;
    property Nome         : String  read FNome;
    property NomeFantasia : String  read FNomeFantasia;
    property Endereco     : String  read FEndereco;
    property Bairro       : TBairro read FBairro;
    property Cidade       : TCidade read FCidade;
    property CEP          : String  read FCEP;
    property Telefone     : String  read FTelefone;
    property Celular      : String  read FCelular;
    property TipoDePessoa : String  read FTipoDePessoa;
    property CNPJ         : String  read FCNPJ;
    property IE           : String  read FIE;
    property DataNasc     : TDate   read FDataNasc;
    property Email        : String  read FEmail;
    property DataCadastro : TDate   read FDataCadastro;

  end;
{$ENDREGION}

{$REGION 'Declaração da classe TPedido'}
  TPedido = class
    FNumero: Integer;
    FData: TDate;
    FCliente: TCliente;
    FSituacao: Integer;
    FDataEntrega: TDate;
    FCodCPagto: TOperacao;
    FFormaPagamento: TFormaPagamento;
    FQuantidadeItens: Double;
    FValorTotalItens: Double;
    FTipo: String;
    FObservacao: String;

  private
    function RetornaTextoSituacao: String;
    function RetornaTextoTipo: String;

  public
    constructor Create(pNumero: Integer;
                       pData: TDate;
                       pCliente: TCliente;
                       pSituacao: Integer;
                       pDataEntrega: TDate;
                       pCodCPagto: TOperacao;
                       pFormaPagamento: TFormaPagamento;
                       pQuantidadeItens: Double;
                       pValorTotalItens: Double;
                       pTipo: String;
                       pObservacao: String);
    destructor Destroy; override;
    procedure FinalizarPedido;

    property Numero          : Integer         read FNumero;
    property Data   	       : TDate           read FData;
    property Cliente         : TCliente        read FCliente;
    property Situacao        : Integer         read FSituacao;
    property TextoSituacao   : String          read RetornaTextoSituacao;
    property DataEntrega     : TDate           read FDataEntrega;
    property CodCPagto       : TOperacao       read FCodCPagto;
    property FormaPagamento  : TFormaPagamento read FFormaPagamento;
    property QuantidadeItens : Double          read FQuantidadeItens;
    property ValorTotalItens : Double          read FValorTotalItens;
    property Tipo            : String          read FTipo;
    property TextoTipo       : String          read RetornaTextoTipo;
    property Observacao      : String          read FObservacao;

  end;
{$ENDREGION}

{$REGION 'Métodos da classe TProduto'}
TProduto = class
    FCodProduto: String;
    FProduto: String;
    FTipoProduto: String;
    FPrecoCusto: Double;
    FPrecoVenda: Double;
    FUnidade: String;
    FEstoqueAtual: Double;
    FSituacao: String;
    FPercICMS: Double;

  private

  public
    constructor Create(pCodProduto: String;
                       pProduto: String;
                       pTipoProduto: String;
                       pPrecoCusto: Double;
                       pPrecoVenda: Double;
                       pUnidade: String;
                       pEstoqueAtual: Double;
                       pSituacao: String;
                       pPercICMS: Double);
    destructor Destroy; override;

    property CodProduto: String read FCodProduto;
    property Produto: String read FProduto;
    property TipoProduto: String read FTipoProduto;
    property PrecoCusto: Double read FPrecoCusto;
    property PrecoVenda: Double read FPrecoVenda;
    property Unidade: String read FUnidade;
    property EstoqueAtual: Double read FEstoqueAtual;
    property Situacao: String read FSituacao;
    property PercICMS: Double read FPercICMS;

  end;
{$ENDREGION}

{$REGION 'Métodos da classe TItem'}
TItem = class
    FNumeroPedProduto: Integer;
    FNumeroPedido: Integer;
    FNumeroItem: Integer;
    FProduto: TProduto;
    FQuantidade: Double;
    FUnidade: String;
    FPreco: Double;
    FPercentualDesconto: Double;
    FValDesconto: Double;
    FValTotal: Double;
    FExisteNoBancoDeDados: Boolean;

  private

  public
    constructor Create(pNumeroPedProduto: Integer;
                       pNumeroPedido: Integer;
                       pNumeroItem: Integer;
                       pProduto: TProduto;
                       pQuantidade: Double;
                       pUnidade: String;
                       pPreco: Double;
                       pPercentualDesconto: Double;
                       pValDesconto: Double;
                       pValTotal: Double;
                       pExisteNoBancoDeDados: Boolean);
    destructor Destroy; override;

    property NumeroPedProduto: Integer read FNumeroPedProduto;
    property NumeroPedido: Integer read FNumeroPedido;
    property NumeroItem: Integer read FNumeroItem;
    property Produto: TProduto read FProduto;
    property Quantidade: Double read FQuantidade;
    property Unidade: String read FUnidade;
    property Preco: Double read FPreco;
    property PercentualDesconto: Double read FPercentualDesconto;
    property ValDesconto: Double read FValDesconto;
    property ValTotal: Double read FValTotal;
    property ExisteNoBancoDeDados: Boolean read FExisteNoBancoDeDados;

  end;
{$ENDREGION}

implementation

{$REGION 'Métodos da classe TCliente'}
constructor TCliente.Create(pCodigo: Integer;
                            pNome: String;
                            pNomeFantasia: String;
                            pEndereco: String;
                            pBairro: TBairro;
                            pCidade: TCidade;
                            pCEP: String;
                            pTelefone: String;
                            pCelular: String;
                            pTipoDePessoa: String;
                            pCNPJ: String;
                            pIE: String;
                            pDataNasc: TDate;
                            pEmail: String;
                            pDataCadastro: TDate);
begin
  FCodigo := pCodigo;
  FNome := pNome;
  FNomeFantasia := pNomeFantasia;
  FEndereco := pEndereco;
  FBairro := pBairro;
  FCidade := pCidade;
  FCEP := pCEP;
  FTelefone := pTelefone;
  FCelular := pCelular;
  FTipoDePessoa := pTipoDePessoa;
  FCNPJ := pCNPJ;
  FIE := pIE;
  FDataNasc := pDataNasc;
  FEmail := pEmail;
  FDataCadastro := pDataCadastro;
end;

destructor TCliente.Destroy;
begin
  Free;
end;

function TCliente.getNome: String;
begin
  Result := Self.FNome;
end;
{$ENDREGION}

{$REGION 'Métodos da classe TPedido'}

constructor TPedido.Create(pNumero: Integer;
                           pData: TDate;
                           pCliente: TCliente;
                           pSituacao: Integer;
                           pDataEntrega: TDate;
                           pCodCPagto: TOperacao;
                           pFormaPagamento: TFormaPagamento;
                           pQuantidadeItens: Double;
                           pValorTotalItens: Double;
                           pTipo: String;
                           pObservacao: String);
begin
  FNumero := pNumero;
  FData := pData;
  FCliente := pCliente;
  FSituacao := pSituacao;
  FDataEntrega := pDataEntrega;
  FCodCPagto := pCodCPagto;
  FFormaPagamento := pFormaPagamento;
  FQuantidadeItens := pQuantidadeItens;
  FValorTotalItens := pValorTotalItens;
  FTipo := pTipo;
  FObservacao := pObservacao;
end;

destructor TPedido.Destroy;
begin
  Free;
end;

function TPedido.RetornaTextoSituacao: String;
begin
  if FSituacao = 1 then
    Result := 'Pendente'
  else if FSituacao = 2 then
    Result := 'Finalizado'
  else
    Result := IntToStr(FSituacao);
end;

function TPedido.RetornaTextoTipo: String;
begin
  if FTipo = 'V' then
    Result := 'Venda'
  else if FTipo = 'B' then
    Result := 'Bonificação'
  else if FTipo = 'T' then
    Result := 'Troca'
  else
    Result := FTipo;
end;

procedure TPedido.FinalizarPedido;
begin
  FSituacao := 2;
end;
{$ENDREGION}

{$REGION 'Métodos da classe TBairro'}
constructor TBairro.Create(pCodigo: Integer; pNome: String);
begin
  FCodigo := pCodigo;
  FNome   := pNome;
end;

destructor TBairro.Destroy;
begin
  Free;
end;
{$ENDREGION}

{$REGION 'Métodos da classe TCidade'}
constructor TCidade.Create(pCodigo: Integer;
                           pNome: String;
                           pUF: String;
                           pPais: TPais;
                           pCodIBGE: Integer);
begin
  FCodigo  := pCodigo;
  FNome    := pNome;
  FUF      := pUF;
  FPais    := pPais;
  FCodIBGE := pCodIBGE;
end;

destructor TCidade.Destroy;
begin
  Free;
end;
{$ENDREGION}

{$REGION 'Métodos da classe TPais'}
constructor TPais.Create(pCodigo: Integer;
                         pNome: String;
                         pSigla: String;
                         pCodBACEN: Integer);
begin
  FCodigo   := pCodigo;
  FNome     := pNome;
  FSigla    := pSigla;
  FCodBACEN := pCodBACEN;
end;

destructor TPais.Destroy;
begin
  Free;
end;
{$ENDREGION}

{$REGION 'Métodos da classe TOperacao'}
constructor TOperacao.Create(pCodigo: Integer;
                       pDescricao: String;
                       pQuantidadeParcelas: Integer;
                       pDiasEntreParcelas: Integer;
                       pDiasParaPrimeiraParcela: Integer;
                       pSituacao: String);
begin
  FCodigo                  := pCodigo;
  FDescricao               := pDescricao;
  FQuantidadeParcelas      := pQuantidadeParcelas;
  FDiasEntreParcelas       := pDiasEntreParcelas;
  FDiasParaPrimeiraParcela := pDiasParaPrimeiraParcela;
  FSituacao                := pSituacao;
end;

destructor TOperacao.Destroy;
begin
  Free;
end;
{$ENDREGION}

{$REGION 'Métodos da classe TFormaPagamento'}
constructor TFormaPagamento.Create(pCodigo: Integer;
                                   pDescricao: String;
                                   pSituacao: String);
begin
  FCodigo    := pCodigo;
  FDescricao := pDescricao;
  FSituacao  := pSituacao;
end;

destructor TFormaPagamento.Destroy;
begin
  Free;
end;
{$ENDREGION}

{$REGION 'Métodos da classe TProduto'}
constructor TProduto.Create(pCodProduto: String;
                            pProduto: String;
                            pTipoProduto: String;
                            pPrecoCusto: Double;
                            pPrecoVenda: Double;
                            pUnidade: String;
                            pEstoqueAtual: Double;
                            pSituacao: String;
                            pPercICMS: Double);
begin
  FCodProduto   := pCodProduto;
  FProduto      := pProduto;
  FTipoProduto  := pTipoProduto;
  FPrecoCusto   := pPrecoCusto;
  FPrecoVenda   := pPrecoVenda;
  FUnidade      := pUnidade;
  FEstoqueAtual := pEstoqueAtual;
  FSituacao     := pSituacao;
  FPercICMS     := pPercICMS;
end;

destructor TProduto.Destroy;
begin
  Free;
end;
{$ENDREGION}

{$REGION 'Métodos da classe TItem'}
constructor TItem.Create(pNumeroPedProduto: Integer;
                         pNumeroPedido: Integer;
                         pNumeroItem: Integer;
                         pProduto: TProduto;
                         pQuantidade: Double;
                         pUnidade: String;
                         pPreco: Double;
                         pPercentualDesconto: Double;
                         pValDesconto: Double;
                         pValTotal: Double;
                         pExisteNoBancoDeDados: Boolean);
begin
  FNumeroPedProduto     := pNumeroPedProduto;
  FNumeroPedido         := pNumeroPedido;
  FNumeroItem           := pNumeroItem;
  FProduto              := pProduto;
  FQuantidade           := pQuantidade;
  FUnidade              := pUnidade;
  FPreco                := pPreco;
  FPercentualDesconto   := pPercentualDesconto;
  FValDesconto          := pValDesconto;
  FValTotal             := pValTotal;
  FExisteNoBancoDeDados := pExisteNoBancoDeDados;
end;

destructor TItem.Destroy;
begin
  Free;
end;
{$ENDREGION}

end.
