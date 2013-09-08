object FormTrain: TFormTrain
  Left = 103
  Top = 88
  Width = 851
  Height = 480
  Caption = #1055#1086#1077#1079#1076#1072
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
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 16
  object HeaderControl1: THeaderControl
    Left = 0
    Top = 0
    Width = 843
    Height = 41
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
    TabOrder = 1
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
    TabOrder = 2
    OnClick = btCanselClick
    ToolBarButton = True
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 89
    Width = 843
    Height = 361
    Hint = #1056#1072#1089#1087#1080#1089#1072#1085#1080#1077' '#1076#1074#1080#1078#1077#1085#1080#1103' '#1087#1086#1077#1079#1076#1086#1074
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
        FieldName = 'Number'
        Title.Alignment = taCenter
        Title.Caption = #1053#1086#1084#1077#1088' '#1087#1086#1077#1079#1076#1072
        Width = 163
        Visible = True
      end
      item
        ButtonStyle = cbsNone
        Expanded = False
        FieldName = 'Way'
        Title.Alignment = taCenter
        Title.Caption = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
        Width = 362
        Visible = True
      end
      item
        ButtonStyle = cbsNone
        Expanded = False
        FieldName = 'Count'
        Title.Alignment = taCenter
        Title.Caption = #1050#1083
        Width = 48
        Visible = True
      end
      item
        ButtonStyle = cbsNone
        Expanded = False
        FieldName = 'Times'
        Title.Alignment = taCenter
        Title.Caption = #1042#1088#1077#1084#1103
        Visible = True
      end
      item
        ButtonStyle = cbsNone
        Expanded = False
        FieldName = 'Day'
        Title.Alignment = taCenter
        Title.Caption = #1044#1085#1080
        Width = 172
        Visible = True
      end>
  end
  object btPrint: TBMPBtn
    Left = 248
    Top = 6
    Width = 120
    Height = 25
    Hint = #1056#1072#1089#1087#1077#1095#1072#1090#1072#1090#1100' '#1090#1077#1093#1085#1086#1083#1086#1075#1080#1102' '#1085#1072' '#1089#1077#1075#1086#1076#1085#1103
    Caption = #1055#1077#1095#1072#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = btPrintClick
    ToolBarButton = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 41
    Width = 843
    Height = 48
    Align = alTop
    TabOrder = 5
    object cbxList: TLabelComboBox
      Left = 1
      Top = 1
      Width = 321
      Height = 39
      CaptionID = 0
      Caption = #1057#1087#1080#1089#1086#1082
      OnChange = cbxListChange
      Align = alLeft
      TabOrder = 0
    end
  end
  object BMPBtn1: TBMPBtn
    Left = 368
    Top = 6
    Width = 107
    Height = 25
    Caption = #1042' '#1072#1088#1093#1080#1074
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = BMPBtn1Click
    ToolBarButton = True
  end
  object BMPBtn2: TBMPBtn
    Left = 480
    Top = 6
    Width = 107
    Height = 25
    Caption = #1048#1079' '#1072#1088#1093#1080#1074#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    OnClick = BMPBtn2Click
    ToolBarButton = True
  end
  object Query1: TQuery
    CachedUpdates = True
    DatabaseName = 'Severtrans'
    RequestLive = True
    SQL.Strings = (
      'select * from Train')
    UpdateMode = upWhereChanged
    UpdateObject = UpdateSQL1
    Left = 648
    object Query1Number: TStringField
      DisplayWidth = 40
      FieldName = 'Number'
      KeyFields = 'Number'
      Origin = 'SEVERTRANS.Train.Number'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Size = 40
    end
    object Query1Way: TStringField
      FieldName = 'Way'
      KeyFields = 'Way'
      Origin = 'SEVERTRANS.Train.Way'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Size = 100
    end
    object Query1Count: TIntegerField
      FieldName = 'Count'
      KeyFields = 'Count'
      Origin = 'SEVERTRANS.Train.Count'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object Query1Ident: TIntegerField
      FieldName = 'Ident'
      KeyFields = 'Ident'
      Origin = 'SEVERTRANS.Train.Ident'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey, pfHidden]
    end
    object Query1Day: TStringField
      FieldName = 'Day'
      KeyFields = 'Day'
      Origin = 'SEVERTRANS.Train.Day'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Size = 60
    end
    object Query1Times: TStringField
      FieldName = 'Times'
      Size = 10
    end
  end
  object UpdateSQL1: TUpdateSQL
    ModifySQL.Strings = (
      'update Train'
      'set'
      '  Ident = :Ident,'
      '  Number = :Number,'
      '  Way = :Way,'
      '  Count = :Count,'
      '  Times = :Times,'
      '  Day = :Day'
      'where'
      '  Ident = :OLD_Ident')
    InsertSQL.Strings = (
      'insert into Train'
      '  (Ident, Number, Way, Count, Times, Day,Arch)'
      'values'
      '  (:Ident, :Number, :Way, :Count, :Times, :Day,0)')
    DeleteSQL.Strings = (
      'delete from Train'
      'where'
      '  Ident = :OLD_Ident')
    Left = 680
  end
  object DataSource1: TDataSource
    DataSet = Query1
    Left = 728
  end
  object WordApplication1: TWordApplication
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    AutoQuit = False
    Left = 768
  end
  object PopupMenu1: TPopupMenu
    Left = 808
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
