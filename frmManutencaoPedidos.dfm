object fCadastrarPedidos: TfCadastrarPedidos
  Left = 0
  Top = 0
  Caption = 'Cadastro de pedidos'
  ClientHeight = 353
  ClientWidth = 727
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnMenu: TPanel
    Left = 0
    Top = 0
    Width = 727
    Height = 68
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Panel3: TPanel
      Left = 659
      Top = 0
      Width = 68
      Height = 68
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Sair'
      Color = clRed
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      OnClick = Sair
    end
    object Panel6: TPanel
      Left = 591
      Top = 0
      Width = 68
      Height = 68
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Gravar'
      Color = clBlue
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
      OnClick = Gravar
    end
  end
  object pnDadosBase: TPanel
    Left = 0
    Top = 68
    Width = 727
    Height = 174
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lbNumeroPedido: TLabel
      Left = 14
      Top = 6
      Width = 91
      Height = 13
      Caption = 'N'#250'mero do pedido:'
    end
    object lbDataPedido: TLabel
      Left = 14
      Top = 49
      Width = 77
      Height = 13
      Caption = 'Data do pedido:'
    end
    object lbCliente: TLabel
      Left = 14
      Top = 92
      Width = 37
      Height = 13
      Caption = 'Cliente:'
    end
    object lbTextoSituacao: TLabel
      Left = 37
      Top = 153
      Width = 3
      Height = 13
    end
    object lbSituacao: TLabel
      Left = 16
      Top = 135
      Width = 45
      Height = 13
      Caption = 'Situa'#231#227'o:'
    end
    object lbDataEntrega: TLabel
      Left = 189
      Top = 6
      Width = 83
      Height = 13
      Caption = 'Data de entrega:'
    end
    object lbOperacao: TLabel
      Left = 187
      Top = 49
      Width = 51
      Height = 13
      Caption = 'Opera'#231#227'o:'
    end
    object lbFormaPagto: TLabel
      Left = 187
      Top = 92
      Width = 106
      Height = 13
      Caption = 'Forma de pagamento:'
    end
    object lbTipoPedido: TLabel
      Left = 189
      Top = 135
      Width = 74
      Height = 13
      Caption = 'Tipo de pedido:'
    end
    object lbQtdeTotal: TLabel
      Left = 362
      Top = 6
      Width = 85
      Height = 13
      Caption = 'Quantidade total:'
    end
    object lbValorTotal: TLabel
      Left = 362
      Top = 49
      Width = 53
      Height = 13
      Caption = 'Valor total:'
    end
    object lbObservacao: TLabel
      Left = 362
      Top = 92
      Width = 62
      Height = 13
      Caption = 'Observa'#231#227'o:'
    end
    object edData: TMaskEdit
      Left = 13
      Top = 64
      Width = 65
      Height = 21
      Enabled = False
      EditMask = '!99/99/0000;1;_'
      MaxLength = 10
      ReadOnly = True
      TabOrder = 9
      Text = '  /  /    '
    end
    object edNumeroPedido: TEdit
      Left = 12
      Top = 21
      Width = 121
      Height = 21
      Enabled = False
      MaxLength = 11
      NumbersOnly = True
      ReadOnly = True
      TabOrder = 1
      TextHint = 'Ex: 1234'
    end
    object cbCliente: TComboBox
      Left = 14
      Top = 107
      Width = 145
      Height = 21
      TabOrder = 2
      TextHint = 'Cliente'
    end
    object edSituacao: TEdit
      Left = 14
      Top = 150
      Width = 17
      Height = 21
      Enabled = False
      MaxLength = 1
      NumbersOnly = True
      ReadOnly = True
      TabOrder = 3
      Text = '2'
    end
    object edDataEntrega: TMaskEdit
      Left = 187
      Top = 21
      Width = 65
      Height = 21
      EditMask = '!99/99/0000;1;_'
      MaxLength = 10
      TabOrder = 4
      Text = '  /  /    '
    end
    object cbOperacao: TComboBox
      Left = 187
      Top = 64
      Width = 145
      Height = 21
      TabOrder = 5
      TextHint = 'Opera'#231#227'o'
    end
    object cbFormaPagto: TComboBox
      Left = 187
      Top = 107
      Width = 145
      Height = 21
      TabOrder = 6
      TextHint = 'Forma de pagamento'
    end
    object cbTipo: TComboBox
      Left = 187
      Top = 150
      Width = 145
      Height = 21
      TabOrder = 7
      TextHint = 'Tipo de pedido'
      Items.Strings = (
        'Venda'
        'Bonifica'#231#227'o'
        'Troca')
    end
    object edObservacao: TMemo
      Left = 362
      Top = 107
      Width = 247
      Height = 64
      TabOrder = 8
    end
    object edQuantidadeItens: TEdit
      AlignWithMargins = True
      Left = 362
      Top = 21
      Width = 121
      Height = 21
      Margins.Left = 14
      Margins.Bottom = 6
      TabOrder = 0
    end
    object edValorTotalItens: TEdit
      AlignWithMargins = True
      Left = 362
      Top = 64
      Width = 121
      Height = 21
      Margins.Left = 14
      Margins.Bottom = 6
      TabOrder = 10
    end
  end
  object pnMenuItens: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 248
    Width = 727
    Height = 30
    Margins.Left = 0
    Margins.Top = 6
    Margins.Right = 0
    Margins.Bottom = 6
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object btExcluirItem: TPanel
      Left = 632
      Top = 0
      Width = 95
      Height = 30
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Excluir'
      Color = clRed
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      OnClick = Excluir
    end
    object btNovoItem: TPanel
      Left = 442
      Top = 0
      Width = 95
      Height = 30
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Novo'
      Color = clGreen
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
      OnClick = Novo
    end
    object btAlterarItem: TPanel
      Left = 537
      Top = 0
      Width = 95
      Height = 30
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Alterar'
      Color = clBlue
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 2
      OnClick = Alterar
    end
  end
  object gdListaItens: TStringGrid
    Left = 0
    Top = 284
    Width = 727
    Height = 69
    Align = alClient
    ColCount = 7
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    TabOrder = 3
  end
  object queryOperacoes: TFDQuery
    Connection = fDados.FDConnection1
    Left = 528
    Top = 11
  end
  object queryClientes: TFDQuery
    Connection = fDados.FDConnection1
    Left = 608
    Top = 11
  end
  object queryFormaPagto: TFDQuery
    Connection = fDados.FDConnection1
    Left = 528
    Top = 67
  end
  object queryPedProds: TFDQuery
    Connection = fDados.FDConnection1
    Left = 608
    Top = 67
  end
  object queryProdutos: TFDQuery
    Connection = fDados.FDConnection1
    Left = 608
    Top = 123
  end
  object queryPedidos: TFDQuery
    Connection = fDados.FDConnection1
    Left = 528
    Top = 123
  end
end
