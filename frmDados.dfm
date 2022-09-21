object fDados: TfDados
  OldCreateOrder = False
  Height = 491
  Width = 630
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=C:\Users\kelvi\OneDrive\Documentos\TESTE\BANCODADOS.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Server=127.0.0.1'
      'Port=3050'
      'DriverID=FB')
    LoginPrompt = False
    Left = 40
    Top = 16
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    VendorLib = 'C:\Program Files (x86)\Firebird\Firebird_2_5\bin\fbclient.dll'
    Left = 40
    Top = 80
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 40
    Top = 136
  end
end
