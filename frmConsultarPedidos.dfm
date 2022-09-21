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
    Top = 209
    Width = 595
    Height = 167
    Align = alClient
    BorderStyle = bsNone
    Color = clBtnFace
    ColCount = 9
    FixedColor = clWhite
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goFixedRowDefAlign]
    ScrollBars = ssVertical
    TabOrder = 0
    ExplicitTop = 68
    ExplicitHeight = 241
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
      ExplicitLeft = 526
      ExplicitTop = 1
      ExplicitHeight = 66
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
      ExplicitLeft = 390
      ExplicitTop = 1
      ExplicitHeight = 66
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
      ExplicitLeft = 322
      ExplicitTop = 1
      ExplicitHeight = 66
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
      ExplicitLeft = 254
      ExplicitTop = 1
      ExplicitHeight = 66
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
      ExplicitLeft = 458
      ExplicitTop = 1
      ExplicitHeight = 66
    end
  end
  object pnFiltros: TPanel
    Left = 0
    Top = 68
    Width = 595
    Height = 141
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 62
    object lbFiltroDataInicial: TLabel
      Left = 14
      Top = 33
      Width = 55
      Height = 13
      Caption = 'Data inicial:'
    end
    object lbFiltroDataFinal: TLabel
      Left = 14
      Top = 73
      Width = 50
      Height = 13
      Caption = 'Data final:'
    end
    object lbFiltroCliente: TLabel
      Left = 126
      Top = 33
      Width = 37
      Height = 13
      Caption = 'Cliente:'
    end
    object lbFiltroSituacao: TLabel
      Left = 126
      Top = 73
      Width = 45
      Height = 13
      Caption = 'Situa'#231#227'o:'
    end
    object lbFiltroTipo: TLabel
      Left = 314
      Top = 33
      Width = 24
      Height = 13
      Caption = 'Tipo:'
    end
    object checkAtivarFiltros: TCheckBox
      Left = 14
      Top = 6
      Width = 97
      Height = 17
      Caption = 'Ativar filtros'
      TabOrder = 0
      OnClick = checkAtivarFiltrosClick
    end
    object edFiltroDataInicial: TMaskEdit
      Left = 14
      Top = 48
      Width = 65
      Height = 21
      EditMask = '!99/99/0000;1;_'
      MaxLength = 10
      TabOrder = 1
      Text = '  /  /    '
    end
    object edFiltroDataFinal: TMaskEdit
      Left = 14
      Top = 88
      Width = 65
      Height = 21
      EditMask = '!99/99/0000;1;_'
      MaxLength = 10
      TabOrder = 2
      Text = '  /  /    '
    end
    object cbFiltroCliente: TComboBox
      Left = 126
      Top = 48
      Width = 145
      Height = 21
      TabOrder = 3
    end
    object cbFiltroSituacao: TComboBox
      Left = 126
      Top = 88
      Width = 145
      Height = 21
      TabOrder = 4
      TextHint = 'Cliente'
      Items.Strings = (
        'Pendente'
        'Finalizado')
    end
    object cbFiltroTipo: TComboBox
      Left = 314
      Top = 48
      Width = 145
      Height = 21
      TabOrder = 5
      TextHint = 'Cliente'
      Items.Strings = (
        'Venda'
        'Bonifica'#231#227'o'
        'Troca')
    end
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
