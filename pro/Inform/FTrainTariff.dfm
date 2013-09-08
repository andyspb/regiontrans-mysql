object FormTrainTariff: TFormTrainTariff
  Left = 261
  Top = 196
  Width = 577
  Height = 480
  Caption = #1058#1072#1088#1080#1092#1099' '#1085#1072' '#1078#1077#1083#1077#1079#1085#1086#1076#1086#1088#1086#1078#1085#1099#1077' '#1087#1077#1088#1077#1074#1086#1079#1082#1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF008888
    888AAA888888888888AAAA888888888888AAAAA88888888888AAAAA888888888
    88AAAAA8888888888AAA88AA888888888AAA88AAA8888888AAA8888AA888888A
    AAA8888AAA8888AAAA888888AAA88AAAAA8888888AAAAAAAA88888888AAAAAAA
    8888888888AAAAA8888888888888AA88888888888888AA888888888888880000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  KeyPreview = True
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 16
  object HeaderControl1: THeaderControl
    Left = 0
    Top = 0
    Width = 569
    Height = 33
    DragReorder = False
    Sections = <>
  end
  object btOk: TBMPBtn
    Left = 8
    Top = 6
    Width = 120
    Height = 25
    Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074#1085#1077#1089#1077#1085#1085#1099#1077' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = btOkClick
    NumGlyphs = 2
    ToolBarButton = True
  end
  object btCansel: TBMPBtn
    Left = 128
    Top = 6
    Width = 120
    Height = 25
    Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1074#1085#1077#1089#1077#1085#1085#1099#1077' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = btCanselClick
    ToolBarButton = True
  end
  object btPrint: TBMPBtn
    Left = 248
    Top = 6
    Width = 120
    Height = 25
    Hint = #1056#1072#1089#1087#1077#1095#1072#1090#1072#1090#1100' '#1090#1072#1088#1080#1092#1099' '#1085#1072' '#1089#1077#1075#1086#1076#1085#1103
    Caption = #1055#1077#1095#1072#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = btPrintClick
    ToolBarButton = True
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 33
    Width = 569
    Height = 417
    Hint = #1058#1072#1088#1080#1092#1099' '#1085#1072' '#1078#1076' '#1087#1077#1088#1077#1074#1086#1079#1082#1080
    Align = alClient
    DataSource = DataSource1
    ParentShowHint = False
    PopupMenu = PopupMenu1
    ShowHint = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        ButtonStyle = cbsNone
        Expanded = False
        FieldName = 'Distance'
        Title.Alignment = taCenter
        Title.Caption = #1056#1072#1089#1089#1090#1086#1103#1085#1080#1077', '#1076#1086
        Width = 238
        Visible = True
      end
      item
        ButtonStyle = cbsNone
        Expanded = False
        FieldName = 'Tariff'
        Title.Alignment = taCenter
        Title.Caption = #1062#1077#1085#1072' '#1079#1072' 10 '#1082#1075'., '#1088#1091#1073'.'
        Width = 195
        Visible = True
      end>
  end
  object Query1: TQuery
    CachedUpdates = True
    DatabaseName = 'Severtrans'
    RequestLive = True
    SQL.Strings = (
      'select * from TrainTariff')
    UpdateMode = upWhereChanged
    UpdateObject = UpdateSQL1
    Left = 384
    object Query1Distance: TFloatField
      FieldName = 'Distance'
      Origin = 'SEVERTRANS.TrainTariff.Distance'
    end
    object Query1Tariff: TFloatField
      FieldName = 'Tariff'
      Origin = 'SEVERTRANS.TrainTariff.Tariff'
    end
  end
  object UpdateSQL1: TUpdateSQL
    ModifySQL.Strings = (
      'update TrainTariff'
      'set'
      '  Distance = :Distance,'
      '  Tariff = :Tariff'
      'where'
      '  Distance = :OLD_Distance and'
      '  Tariff = :OLD_Tariff')
    InsertSQL.Strings = (
      'insert into TrainTariff'
      '  (Distance, Tariff)'
      'values'
      '  (:Distance, :Tariff)')
    DeleteSQL.Strings = (
      'delete from TrainTariff'
      'where'
      '  Distance = :OLD_Distance and'
      '  Tariff = :OLD_Tariff')
    Left = 424
  end
  object DataSource1: TDataSource
    DataSet = Query1
    Left = 456
  end
  object WordApplication1: TWordApplication
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    AutoQuit = False
    Left = 496
  end
  object PopupMenu1: TPopupMenu
    Left = 528
    object N1: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      ShortCut = 8238
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #1042#1099#1081#1090#1080
      ShortCut = 16474
      OnClick = N2Click
    end
  end
end
