object FormAcceptor: TFormAcceptor
  Left = 274
  Top = 180
  Width = 417
  Height = 411
  Hint = #1042#1074#1077#1076#1080#1090#1077' '#1072#1076#1088#1077#1089' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
  Caption = #1050#1072#1088#1090#1086#1095#1082#1072' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
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
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 16
  object HeaderControl1: THeaderControl
    Left = 0
    Top = 0
    Width = 401
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
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    OnClick = btOkClick
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
    TabOrder = 8
    OnClick = btCanselClick
    ToolBarButton = True
  end
  object eName: TLabeledEdit
    Left = 8
    Top = 112
    Width = 329
    Height = 24
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1087#1086#1083#1085#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
    EditLabel.Width = 147
    EditLabel.Height = 16
    EditLabel.Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
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
    MaxLength = 60
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
  end
  object eAddress: TLabeledEdit
    Left = 8
    Top = 168
    Width = 329
    Height = 24
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1072#1076#1088#1077#1089' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
    EditLabel.Width = 121
    EditLabel.Height = 16
    EditLabel.Caption = #1040#1076#1088#1077#1089' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
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
    MaxLength = 80
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
  object eRegime: TLabeledEdit
    Left = 8
    Top = 216
    Width = 329
    Height = 24
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1088#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
    EditLabel.Width = 94
    EditLabel.Height = 16
    EditLabel.Caption = #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099
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
    MaxLength = 30
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
  end
  object ePhone: TLabeledEdit
    Left = 8
    Top = 264
    Width = 161
    Height = 24
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1090#1077#1083#1077#1092#1086#1085' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
    EditLabel.Width = 60
    EditLabel.Height = 16
    EditLabel.Caption = #1058#1077#1083#1077#1092#1086#1085
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
    MaxLength = 20
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
  end
  object cbCity: TLabelSQLComboBox
    Left = 8
    Top = 48
    Width = 225
    Height = 40
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1075#1086#1088#1086#1076' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
    CaptionID = 0
    Caption = #1043#1086#1088#1086#1076
    Table = 'City'
    DatabaseName = 'SeverTrans'
    IDField = 'Ident'
    InfoField = 'Name'
    ParentColor = False
    NotNull = False
    NewItemFlag = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
  end
  object BitBtn2: TBitBtn
    Left = 235
    Top = 62
    Width = 25
    Height = 25
    Hint = 
      #1055#1088#1080' '#1085#1072#1078#1072#1090#1080#1080' '#1087#1088#1077#1076#1086#1089#1090#1072#1074#1083#1103#1077#1090#1089#1103' '#1074#1086#1079#1084#1086#1078#1085#1086#1089#1090#1100' '#1076#1086#1073#1072#1074#1080#1090#1100' '#1085#1077#1076#1086#1089#1090#1072#1102#1097#1077#1075#1086' '#1075#1086 +
      #1088#1086#1076#1072
    Caption = '+'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = BitBtn2Click
  end
  object eComent: TLabeledEdit
    Left = 8
    Top = 312
    Width = 329
    Height = 24
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1087#1088#1080#1084#1077#1095#1072#1085#1080#1077#1080#1077' '
    EditLabel.Width = 83
    EditLabel.Height = 16
    EditLabel.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
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
    MaxLength = 30
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
  end
end
