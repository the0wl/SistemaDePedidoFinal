object fConsultarPedidos: TfConsultarPedidos
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Consulta de pedidos'
  ClientHeight = 376
  ClientWidth = 595
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object gdListaPedidos: TStringGrid
    Left = 0
    Top = 211
    Width = 595
    Height = 165
    Align = alClient
    BorderStyle = bsNone
    Color = clBtnFace
    ColCount = 9
    FixedColor = clWhite
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goFixedRowDefAlign]
    ScrollBars = ssVertical
    TabOrder = 0
    ExplicitTop = 209
    ExplicitHeight = 167
  end
  object pnMenu: TPanel
    Left = 0
    Top = 0
    Width = 595
    Height = 68
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object btSair: TPanel
      Left = 527
      Top = 0
      Width = 68
      Height = 68
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Sair'
      Color = clTeal
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
    object btFinalizar: TPanel
      Left = 391
      Top = 0
      Width = 68
      Height = 68
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Finalizar'#13#10
      Color = clBlue
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
      OnClick = Finalizar
    end
    object btAlterar: TPanel
      Left = 323
      Top = 0
      Width = 68
      Height = 68
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Alterar'
      Color = clOlive
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 2
      OnClick = Alterar
    end
    object btNovo: TPanel
      Left = 255
      Top = 0
      Width = 68
      Height = 68
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Novo'
      Color = clGreen
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 3
      OnClick = Novo
    end
    object btExcluir: TPanel
      Left = 459
      Top = 0
      Width = 68
      Height = 68
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Excluir'
      Color = clRed
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 4
      OnClick = Excluir
    end
  end
  object pnFiltros: TPanel
    Left = 0
    Top = 90
    Width = 595
    Height = 121
    Align = alTop
    BevelOuter = bvNone
    Enabled = False
    TabOrder = 2
    ExplicitTop = 88
    DesignSize = (
      595
      121)
    object lbFiltroDataInicial: TLabel
      Left = 14
      Top = 9
      Width = 55
      Height = 13
      Caption = 'Data inicial:'
    end
    object lbFiltroDataFinal: TLabel
      Left = 14
      Top = 49
      Width = 50
      Height = 13
      Caption = 'Data final:'
    end
    object lbFiltroCliente: TLabel
      Left = 126
      Top = 9
      Width = 37
      Height = 13
      Caption = 'Cliente:'
    end
    object lbFiltroSituacao: TLabel
      Left = 126
      Top = 49
      Width = 45
      Height = 13
      Caption = 'Situa'#231#227'o:'
    end
    object lbFiltroTipo: TLabel
      Left = 314
      Top = 9
      Width = 24
      Height = 13
      Caption = 'Tipo:'
    end
    object edFiltroDataInicial: TMaskEdit
      Left = 14
      Top = 24
      Width = 65
      Height = 21
      EditMask = '!99/99/0000;1;_'
      MaxLength = 10
      TabOrder = 0
      Text = '  /  /    '
    end
    object edFiltroDataFinal: TMaskEdit
      Left = 14
      Top = 64
      Width = 65
      Height = 21
      EditMask = '!99/99/0000;1;_'
      MaxLength = 10
      TabOrder = 1
      Text = '  /  /    '
    end
    object cbFiltroCliente: TComboBox
      Left = 126
      Top = 24
      Width = 145
      Height = 21
      TabOrder = 2
    end
    object cbFiltroSituacao: TComboBox
      Left = 126
      Top = 64
      Width = 145
      Height = 21
      TabOrder = 3
      TextHint = 'Cliente'
      Items.Strings = (
        'Pendente'
        'Finalizado')
    end
    object cbFiltroTipo: TComboBox
      Left = 314
      Top = 24
      Width = 145
      Height = 21
      TabOrder = 4
      TextHint = 'Cliente'
      Items.Strings = (
        'Venda'
        'Bonifica'#231#227'o'
        'Troca')
    end
    object btFiltroFiltrar: TButton
      Left = 488
      Top = 90
      Width = 97
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Filtrar'
      TabOrder = 5
      OnClick = btFiltroFiltrarClick
      ExplicitTop = 110
    end
  end
  object cbHabilitarFiltros: TCheckBox
    AlignWithMargins = True
    Left = 15
    Top = 73
    Width = 580
    Height = 17
    Margins.Left = 15
    Margins.Top = 5
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alTop
    Caption = 'Habilitar filtros'
    TabOrder = 3
    OnClick = cbHabilitarFiltrosClick
    ExplicitLeft = 10
    ExplicitTop = 70
  end
  object queryPedidos: TFDQuery
    Connection = fDados.FDConnection1
    Left = 256
    Top = 211
  end
  object queryClientes: TFDQuery
    Connection = fDados.FDConnection1
    Left = 184
    Top = 267
  end
  object queryBairros: TFDQuery
    Connection = fDados.FDConnection1
    Left = 104
    Top = 203
  end
  object queryCidades: TFDQuery
    Connection = fDados.FDConnection1
    Left = 104
    Top = 259
  end
  object queryPaises: TFDQuery
    Connection = fDados.FDConnection1
    Left = 24
    Top = 259
  end
  object queryFormaPagto: TFDQuery
    Connection = fDados.FDConnection1
    Left = 24
    Top = 203
  end
  object queryOperacoes: TFDQuery
    Connection = fDados.FDConnection1
    Left = 184
    Top = 211
  end
end
