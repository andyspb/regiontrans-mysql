object CityForm: TCityForm
  Left = 343
  Top = 134
  Width = 419
  Height = 509
  Caption = #1050#1072#1088#1090#1086#1095#1082#1072' '#1075#1086#1088#1086#1076#1072'.'
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
    888CCC888888888888CCCC888888888888CCCCC88888888888CCCCC888888888
    88CCCCC8888888888CCC88CC888888888CCC88CCC8888888CCC8888CC888888C
    CCC8888CCC8888CCCC888888CCC88CCCCC8888888CCCCCCCC88888888CCCCCCC
    8888888888CCCCC8888888888888CC88888888888888CC888888888888880000
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
    Width = 441
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
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 13
    OnClick = btOkClick
    NumGlyphs = 2
    ToolBarButton = True
  end
  object btCansel: TBMPBtn
    Left = 136
    Top = 6
    Width = 120
    Height = 25
    Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1074#1085#1077#1089#1077#1085#1085#1099#1077' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 14
    OnClick = btCanselClick
    ToolBarButton = True
  end
  object eFullName: TLabeledEdit
    Left = 14
    Top = 72
    Width = 251
    Height = 24
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1075#1086#1088#1086#1076#1072
    EditLabel.Width = 66
    EditLabel.Height = 16
    EditLabel.Caption = #1053#1072#1079#1074#1072#1085#1080#1077
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -13
    EditLabel.Font.Name = 'MS Sans Serif'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    LabelPosition = lpAbove
    LabelSpacing = 3
    MaxLength = 25
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnChange = eFullNameChange
  end
  object eTariff1: TLblEditMoney
    Left = 13
    Top = 144
    Width = 161
    Height = 39
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1090#1072#1088#1080#1092' '#1085#1072' '#1087#1077#1088#1077#1074#1086#1079#1082#1091' '#1076#1086' 200 '#1082#1075'.'
    FieldName = 'Tariff200'
    CaptionID = 0
    Alignment = taRightJustify
    Caption = 'c'
    Text = '0.00'
    ParentColor = False
    ReadOnly = False
    MaxLength = 10
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
  end
  object eTariff2: TLblEditMoney
    Left = 189
    Top = 144
    Width = 161
    Height = 39
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1090#1072#1088#1080#1092' '#1085#1072' '#1087#1077#1088#1077#1074#1086#1079#1082#1091' '#1086#1090' 200 '#1076#1086' 500 '#1082#1075'.'
    FieldName = 'Tariff500'
    CaptionID = 0
    Alignment = taRightJustify
    Caption = #1058#1072#1088#1080#1092' '#1090#1086' 200 '#1076#1086' 500 '#1082#1075
    Text = '0.00'
    ParentColor = False
    ReadOnly = False
    MaxLength = 10
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
  object eTariff3: TLblEditMoney
    Left = 13
    Top = 184
    Width = 161
    Height = 39
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1090#1072#1088#1080#1092' '#1085#1072' '#1087#1077#1088#1077#1074#1086#1079#1082#1091' '#1086#1090' 500 '#1076#1086' 1000 '#1082#1075'.'
    FieldName = 'Tariff1000'
    CaptionID = 0
    Alignment = taRightJustify
    Caption = #1058#1072#1088#1080#1092' '#1086#1090' 500 '#1076#1086' 1000 '#1082#1075
    Text = '0.00'
    ParentColor = False
    ReadOnly = False
    MaxLength = 10
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
  end
  object eTariff4: TLblEditMoney
    Left = 189
    Top = 184
    Width = 161
    Height = 39
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1090#1072#1088#1080#1092' '#1085#1072' '#1087#1077#1088#1077#1074#1086#1079#1082#1091' '#1086#1090' 1000 '#1076#1086' 2000 '#1082#1075'.'
    FieldName = 'Tariff2000'
    CaptionID = 0
    Alignment = taRightJustify
    Caption = #1058#1072#1088#1080#1092' '#1086#1090' 1000 '#1076#1086' 2000 '#1082#1075
    Text = '0.00'
    ParentColor = False
    ReadOnly = False
    MaxLength = 10
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
  end
  object eTariff5: TLblEditMoney
    Left = 13
    Top = 232
    Width = 161
    Height = 39
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1090#1072#1088#1080#1092' '#1085#1072' '#1087#1077#1088#1077#1074#1086#1079#1082#1091' '#1086#1090' '#1089#1074#1099#1096#1077' 2000 '#1082#1075'.'
    FieldName = 'TariffMore2000'
    CaptionID = 0
    Alignment = taRightJustify
    Caption = #1058#1072#1088#1080#1092' '#1089#1074#1099#1096#1077' 2000 '#1082#1075
    Text = '0.00'
    ParentColor = False
    ReadOnly = False
    MaxLength = 10
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
  end
  object eSending: TLabeledEdit
    Left = 190
    Top = 244
    Width = 158
    Height = 24
    Hint = 
      #1042#1074#1077#1076#1080#1090#1077' '#1089#1086#1082#1088#1072#1097#1077#1085#1080#1103' '#1076#1085#1077#1081' '#1085#1077#1076#1077#1083#1080' ('#1095#1077#1088#1077#1079' '#1079#1072#1087#1103#1090#1091#1102') '#1087#1086' '#1082#1072#1090#1086#1088#1099#1084' '#1086#1090#1087#1088#1072#1074 +
      #1083#1103#1077#1090#1089#1103' '#1084#1072#1096#1080#1085#1072' '#1074' '#1076#1072#1085#1085#1099#1081' '#1075#1086#1088#1086#1076
    EditLabel.Width = 28
    EditLabel.Height = 16
    EditLabel.Caption = #1044#1085#1080' '
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -13
    EditLabel.Font.Name = 'MS Sans Serif'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    LabelPosition = lpAbove
    LabelSpacing = 3
    MaxLength = 10
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    OnChange = eFullNameChange
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 288
    Width = 209
    Height = 137
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1074#1089#1077' '#1085#1086#1084#1077#1088#1072' '#1087#1086#1077#1079#1076#1086#1074' '#1087#1088#1086#1093#1086#1076#1103#1097#1080#1093' '#1095#1077#1088#1077#1079' '#1075#1086#1088#1086#1076
    DataSource = DataSource1
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    PopupMenu = PopupMenu1
    ShowHint = True
    TabOrder = 8
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Visible = False
    Columns = <
      item
        DropDownRows = 30
        Expanded = False
        FieldName = 'Number'
        PickList.Strings = (
          '7')
        Title.Alignment = taCenter
        Title.Caption = #1053#1086#1084#1077#1088' '#1087#1086#1077#1079#1076#1072
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -13
        Title.Font.Name = 'MS Sans Serif'
        Title.Font.Style = [fsBold]
        Width = 183
        Visible = True
      end>
  end
  object BMPBtn1: TBMPBtn
    Left = 240
    Top = 294
    Width = 97
    Height = 25
    Hint = #1055#1086#1089#1084#1086#1090#1088#1077#1090#1100' '#1080' '#1076#1086#1073#1072#1074#1080#1090#1100' '#1085#1077#1076#1086#1089#1090#1086#1102#1097#1077#1075#1086' '#1087#1086#1077#1079#1076#1072
    Caption = #1055#1086#1077#1079#1076#1072
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    Visible = False
    OnClick = BMPBtn1Click
    ToolBarButton = False
  end
  object edistance: TLblEditMoney
    Left = 240
    Top = 320
    Width = 118
    Height = 39
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1088#1072#1089#1089#1090#1086#1103#1085#1080#1077' '#1074' '#1082#1077#1083#1086#1084#1077#1090#1088#1072#1093' '#1076#1086' '#1075#1086#1088#1086#1076#1072
    Enabled = False
    Visible = False
    FieldName = 'distance'
    CaptionID = 0
    Alignment = taRightJustify
    Caption = #1056#1072#1089#1089#1090#1086#1103#1085#1080#1077
    Text = '0.00'
    ParentColor = False
    ReadOnly = False
    MaxLength = 10
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
  end
  object CheckBox1: TCheckBox
    Left = 240
    Top = 402
    Width = 113
    Height = 17
    Hint = #1054#1090#1084#1077#1090#1090#1077' '#1077#1089#1083#1080' '#1087#1077#1088#1077#1074#1086#1079#1082#1072' '#1076#1086' '#1087#1091#1085#1082#1090#1072' '#1087#1088#1086#1093#1086#1076#1080#1090' '#1095#1077#1088#1077#1079' '#1052#1086#1089#1082#1074#1091
    Caption = #1095'/'#1079' '#1052#1086#1089#1082#1074#1091
    Enabled = False
    ParentShowHint = False
    PopupMenu = PopupMenu2
    ShowHint = True
    TabOrder = 12
    Visible = False
  end
  object egdstrah: TLblEditMoney
    Left = 240
    Top = 360
    Width = 118
    Height = 39
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1089#1091#1084#1084#1091' '#1089#1090#1088#1072#1093#1086#1074#1082#1080' '#1085#1072' '#1078'/'#1076' '#1076#1086' '#1075#1086#1088#1086#1076#1072'.'
    Enabled = False
    Visible = False
    FieldName = 'GDStrah'
    CaptionID = 0
    Alignment = taRightJustify
    Caption = #1046'/'#1076' '#1089#1090#1088#1072#1093#1086#1074#1082#1072
    Text = '0.00'
    ParentColor = False
    ReadOnly = False
    MaxLength = 10
    ParentShowHint = False
    ShowHint = True
    TabOrder = 11
  end
  object MaskEdit1: TMaskEdit
    Left = 320
    Top = 472
    Width = 121
    Height = 24
    TabOrder = 16
    Text = 'MaskEdit1'
  end
  object LabelInteger1: TLabelInteger
    Left = 16
    Top = 104
    Width = 100
    Height = 39
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1076#1085#1080' '#1076#1083#1103' '#1076#1086#1089#1090#1072#1074#1082#1080' '#1074' '#1101#1090#1086#1090' '#1075#1086#1088#1086#1076'.'
    FieldName = 'DaysDel'
    CaptionID = 0
    Caption = #1044#1085#1080' '#1076#1086#1089#1090#1072#1074#1082#1080
    Text = '0'
    ParentColor = False
    ReadOnly = False
    MaxLength = 5
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object Query1: TQuery
    CachedUpdates = True
    DatabaseName = 'Severtrans'
    RequestLive = True
    SQL.Strings = (
      
        'select City_Ident,Train_Ident,Number from CityTrain join Train o' +
        'n(Train.Ident=Train_Ident) ')
    UpdateMode = upWhereChanged
    UpdateObject = UpdateSQL1
    Left = 264
    Top = 8
    object Query1City_Ident: TIntegerField
      FieldName = 'City_Ident'
      KeyFields = 'City_Ident'
      Origin = 'SEVERTRANS.CityTrainView.City_Ident'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object Query1Train_Ident: TIntegerField
      FieldName = 'Train_Ident'
      KeyFields = 'Train_Ident'
      Origin = 'SEVERTRANS.CityTrainView.Train_Ident'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object Query1Number: TStringField
      FieldName = 'Number'
      KeyFields = 'Number'
      Origin = 'SEVERTRANS.Train.Number'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Size = 40
    end
  end
  object UpdateSQL1: TUpdateSQL
    ModifySQL.Strings = (
      'update CityTrain'
      'set'
      '  City_Ident = :City_Ident,'
      '  Train_Ident = :Train_Ident'
      'where'
      '  City_Ident = :OLD_City_Ident and'
      '  Train_Ident = :OLD_Train_Ident')
    InsertSQL.Strings = (
      'insert into CityTrain'
      '  (City_Ident, Train_Ident)'
      'values'
      '  (:City_Ident, :Train_Ident)')
    DeleteSQL.Strings = (
      'delete from CityTrain'
      'where'
      '  City_Ident = :OLD_City_Ident and'
      '  Train_Ident = :OLD_Train_Ident')
    Left = 304
    Top = 8
  end
  object DataSource1: TDataSource
    DataSet = Query1
    Left = 272
    Top = 40
  end
  object PopupMenu1: TPopupMenu
    Left = 304
    Top = 40
    object N1: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      ShortCut = 8238
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #1055#1077#1088#1077#1093#1086#1076' '#1074#1087#1077#1088#1077#1076
      ShortCut = 16474
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = #1055#1077#1088#1077#1093#1086#1076' '#1085#1072#1079#1072#1076
      ShortCut = 49242
      OnClick = N3Click
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 312
    Top = 72
    object N4: TMenuItem
      Caption = #1054#1090#1084#1077#1090#1080#1090#1100
      ShortCut = 45
      OnClick = N4Click
    end
  end
end
