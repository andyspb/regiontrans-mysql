object FCardBoss: TFCardBoss
  Left = 284
  Top = 79
  Width = 696
  Height = 668
  Hint = #1050#1072#1088#1090#1086#1095#1082#1072' '#1087#1088#1077#1076#1087#1088#1080#1103#1090#1080#1103
  Caption = #1050#1072#1088#1090#1086#1095#1082#1072' '#1087#1088#1077#1076#1087#1088#1080#1103#1090#1080#1103
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
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
  TextHeight = 13
  object HeaderControl1: THeaderControl
    Left = 0
    Top = 0
    Width = 680
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
    TabOrder = 16
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
    TabOrder = 17
    OnClick = btCanselClick
    ToolBarButton = True
  end
  object LabeledEdit1: TLabeledEdit
    Left = 8
    Top = 56
    Width = 313
    Height = 24
    Hint = 
      #1042#1074#1077#1076#1080#1090#1077' '#1089#1086#1082#1088#1072#1097#1077#1085#1085#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1082#1083#1080#1077#1085#1090#1072' ('#1085#1077' '#1076#1086#1083#1078#1077#1085#1086' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 35 '#1089#1080 +
      #1084#1074#1086#1083#1086#1074')'
    EditLabel.Width = 244
    EditLabel.Height = 16
    EditLabel.Caption = #1057#1086#1082#1088#1072#1097#1077#1085#1085#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1087#1088#1077#1076#1087#1088#1080#1103#1090#1080#1103
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
    MaxLength = 35
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnChange = LabeledEdit1Change
  end
  object eFullName: TLabeledEdit
    Left = 8
    Top = 112
    Width = 593
    Height = 24
    Hint = 
      #1042#1074#1077#1076#1080#1090#1077' '#1087#1086#1083#1085#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1082#1083#1080#1077#1085#1090#1072' ('#1085#1077' '#1076#1086#1083#1078#1077#1085#1086' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 70 '#1089#1080#1084#1074#1086#1083#1086 +
      #1074')'
    EditLabel.Width = 205
    EditLabel.Height = 16
    EditLabel.Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1087#1088#1077#1076#1087#1088#1080#1103#1090#1080#1103
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
    MaxLength = 70
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object LabeledEdit4: TLabeledEdit
    Left = 8
    Top = 216
    Width = 593
    Height = 24
    Hint = 
      #1042#1074#1077#1076#1080#1090#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1081' '#1072#1076#1088#1077#1089#1089' '#1082#1083#1080#1077#1085#1090#1072' ('#1085#1077' '#1076#1086#1083#1078#1077#1085' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 70 '#1089#1080#1084#1074#1086 +
      #1083#1086#1074')'
    EditLabel.Width = 392
    EditLabel.Height = 16
    EditLabel.Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1081' '#1072#1076#1088#1077#1089#1089' '#1087#1088#1077#1076#1087#1088#1080#1103#1090#1080#1103' ('#1080#1085#1076#1077#1082#1089','#1075#1086#1088#1086#1076','#1091#1083'.,'#1076#1086#1084','#1082#1074')'
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
    MaxLength = 70
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
  end
  object LabelSQLComboBox1: TLabelSQLComboBox
    Left = 312
    Top = 152
    Width = 233
    Height = 36
    Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1075#1086#1088#1086#1076
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
    TabOrder = 3
  end
  object LabelSQLComboBox2: TLabelSQLComboBox
    Left = 8
    Top = 152
    Width = 281
    Height = 36
    Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1089#1090#1088#1072#1085#1091'  '#1087#1088#1077#1073#1099#1074#1072#1085#1080#1103' '#1082#1083#1080#1077#1085#1090#1072
    CaptionID = 0
    Caption = #1057#1090#1088#1072#1085#1072
    Table = 'Country'
    DatabaseName = 'SeverTrans'
    IDField = 'Ident'
    InfoField = 'Name'
    ParentColor = False
    NotNull = False
    NewItemFlag = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
  end
  object LabeledEdit15: TLabeledEdit
    Left = 8
    Top = 272
    Width = 417
    Height = 24
    Hint = 
      #1042#1074#1077#1076#1080#1090#1077' '#1082#1086#1085#1090#1072#1082#1090#1085#1086#1077' '#1083#1080#1094#1086' ('#1086#1073#1099#1095#1085#1086' '#1086#1090#1074#1077#1095#1072#1102#1097#1077#1077' '#1087#1086' '#1091#1082#1072#1079#1072#1085#1085#1086#1084#1091' '#1090#1077#1083#1077#1092#1086#1085 +
      #1091') '#1082#1083#1080#1077#1085#1090#1072' ('#1085#1077' '#1076#1086#1083#1078#1077#1085' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 30 '#1089#1080#1084#1074#1086#1083#1086#1074')'
    EditLabel.Width = 250
    EditLabel.Height = 16
    EditLabel.Caption = #1044#1080#1088#1077#1082#1090#1086#1088' '#1087#1088#1077#1076#1087#1088#1080#1103#1090#1080#1103' ('#1092#1072#1084#1080#1083#1080#1103' '#1048'.'#1054'.)'
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
    TabOrder = 5
  end
  object LabeledEdit6: TLabeledEdit
    Left = 8
    Top = 384
    Width = 153
    Height = 24
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1090#1077#1083#1077#1092#1086#1085' '#1082#1083#1080#1077#1085#1090#1072' ('#1085#1077' '#1076#1086#1083#1078#1077#1085' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 15 '#1089#1080#1084#1074#1086#1083#1086#1074')'
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
    MaxLength = 15
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
  end
  object LabeledEdit7: TLabeledEdit
    Left = 312
    Top = 384
    Width = 209
    Height = 24
    Hint = 
      #1042#1074#1077#1076#1080#1090#1077' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1072#1076#1088#1077#1089#1089' '#1082#1083#1080#1077#1085#1090#1072' ('#1085#1077' '#1076#1086#1083#1078#1077#1085' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 25 '#1089#1080#1084#1074#1086 +
      #1083#1086#1074')'
    EditLabel.Width = 44
    EditLabel.Height = 16
    EditLabel.Caption = 'E - mail'
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
    TabOrder = 8
  end
  object LabeledEdit5: TLabeledEdit
    Left = 176
    Top = 384
    Width = 121
    Height = 24
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1092#1072#1082#1089' '#1082#1083#1080#1077#1085#1090#1072' ('#1085#1077' '#1076#1086#1083#1078#1077#1085' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 15 '#1089#1080#1084#1074#1086#1083#1086#1074')'
    EditLabel.Width = 33
    EditLabel.Height = 16
    EditLabel.Caption = #1060#1072#1082#1089
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
    MaxLength = 15
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
  end
  object LabeledEdit8: TLabeledEdit
    Left = 8
    Top = 432
    Width = 153
    Height = 24
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1048#1053#1053' '#1082#1083#1080#1077#1085#1090#1072' ('#1085#1077' '#1076#1086#1083#1078#1077#1085' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 12 '#1089#1080#1084#1074#1086#1083#1086#1074')'
    EditLabel.Width = 30
    EditLabel.Height = 16
    EditLabel.Caption = #1048#1053#1053
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
    MaxLength = 12
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
  end
  object LabeledEdit9: TLabeledEdit
    Left = 312
    Top = 432
    Width = 209
    Height = 24
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1088#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090' '#1082#1083#1080#1077#1085#1090#1072' ('#1085#1077' '#1076#1086#1083#1078#1077#1085' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 20 '#1089#1080#1084#1074#1086#1083#1086#1074')'
    EditLabel.Width = 105
    EditLabel.Height = 16
    EditLabel.Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090
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
    TabOrder = 11
  end
  object LabeledEdit10: TLabeledEdit
    Left = 8
    Top = 480
    Width = 153
    Height = 24
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1082#1086#1076' '#1087#1086' '#1054#1050#1040#1058#1054' '#1082#1083#1080#1077#1085#1090#1072' ('#1085#1077' '#1076#1086#1083#1078#1077#1085' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 11 '#1089#1080#1084#1074#1086#1083#1086#1074')'
    EditLabel.Width = 92
    EditLabel.Height = 16
    EditLabel.Caption = #1050#1086#1076' '#1087#1086' '#1054#1050#1040#1058#1054
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
    MaxLength = 11
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 12
  end
  object LabeledEdit11: TLabeledEdit
    Left = 176
    Top = 480
    Width = 121
    Height = 24
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1082#1086#1076' '#1087#1086' '#1054#1050#1055#1054' '#1082#1083#1080#1077#1085#1090#1072' ('#1085#1077' '#1076#1086#1083#1078#1077#1085' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 8 '#1089#1080#1084#1074#1086#1083#1086#1074')'
    EditLabel.Width = 84
    EditLabel.Height = 16
    EditLabel.Caption = #1050#1086#1076' '#1087#1086' '#1054#1050#1055#1054
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
    MaxLength = 8
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 13
  end
  object LabelSQLComboBox4: TLabelSQLComboBox
    Left = 8
    Top = 520
    Width = 593
    Height = 36
    Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1073#1072#1085#1082' '#1082#1083#1080#1077#1085#1090#1072
    CaptionID = 0
    Caption = #1041#1072#1085#1082' '#1087#1088#1077#1076#1087#1088#1080#1103#1090#1080#1103
    Table = 'Bank'
    DatabaseName = 'SeverTrans'
    IDField = 'Ident'
    InfoField = 'Name'
    ParentColor = False
    NotNull = False
    NewItemFlag = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 15
  end
  object LabeledEdit13: TLabeledEdit
    Left = 32
    Top = 592
    Width = 145
    Height = 24
    Hint = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103' '#1082#1072#1088#1090#1086#1095#1082#1080' '#1082#1083#1080#1077#1085#1090#1072' ('#1074' '#1088#1091#1095#1085#1091#1102' '#1085#1077' '#1080#1079#1084#1077#1085#1103#1077#1090#1089#1103')'
    EditLabel.Width = 114
    EditLabel.Height = 16
    EditLabel.Caption = #1044#1072#1090#1072' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1103
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
    MaxLength = 70
    ParentColor = True
    ParentFont = False
    TabOrder = 18
  end
  object LabeledEdit14: TLabeledEdit
    Left = 408
    Top = 592
    Width = 145
    Height = 24
    Hint = 
      #1044#1072#1090#1072' '#1074#1085#1077#1089#1077#1085#1080#1103' '#1080#1079#1084#1077#1085#1077#1085#1080#1081' '#1074' '#1082#1072#1088#1090#1086#1095#1082#1091' '#1082#1083#1080#1077#1085#1090#1072' ('#1074' '#1088#1091#1095#1085#1091#1102' '#1085#1077' '#1080#1079#1084#1077#1085#1103#1077#1090 +
      #1089#1103')'
    EditLabel.Width = 107
    EditLabel.Height = 16
    EditLabel.Caption = #1044#1072#1090#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
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
    MaxLength = 70
    ParentColor = True
    ParentFont = False
    TabOrder = 19
  end
  object LabeledEdit2: TLabeledEdit
    Left = 8
    Top = 328
    Width = 417
    Height = 24
    Hint = 
      #1042#1074#1077#1076#1080#1090#1077' '#1082#1086#1085#1090#1072#1082#1090#1085#1086#1077' '#1083#1080#1094#1086' ('#1086#1073#1099#1095#1085#1086' '#1086#1090#1074#1077#1095#1072#1102#1097#1077#1077' '#1087#1086' '#1091#1082#1072#1079#1072#1085#1085#1086#1084#1091' '#1090#1077#1083#1077#1092#1086#1085 +
      #1091') '#1082#1083#1080#1077#1085#1090#1072' ('#1085#1077' '#1076#1086#1083#1078#1077#1085' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 30 '#1089#1080#1084#1074#1086#1083#1086#1074')'
    EditLabel.Width = 313
    EditLabel.Height = 16
    EditLabel.Caption = #1043#1083#1072#1074#1085#1099#1081' '#1073#1091#1093#1075#1072#1083#1090#1077#1088' '#1087#1088#1077#1076#1087#1088#1080#1103#1090#1080#1103' ('#1092#1072#1084#1080#1083#1080#1103' '#1048'.'#1054'.)'
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
    TabOrder = 21
  end
  object LabeledEdit3: TLabeledEdit
    Left = 312
    Top = 480
    Width = 209
    Height = 24
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1082#1086#1076' '#1087#1086' '#1054#1050#1042#1069#1044' '#1082#1083#1080#1077#1085#1090#1072' ('#1085#1077' '#1076#1086#1083#1078#1077#1085' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 8 '#1089#1080#1084#1074#1086#1083#1086#1074')'
    EditLabel.Width = 92
    EditLabel.Height = 16
    EditLabel.Caption = #1050#1086#1076' '#1087#1086' '#1054#1050#1042#1069#1044
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
    MaxLength = 8
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 14
  end
  object LabeledEdit18: TLabeledEdit
    Left = 176
    Top = 432
    Width = 121
    Height = 24
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1050#1055#1055' '#1082#1083#1080#1077#1085#1090#1072' ('#1085#1077' '#1076#1086#1083#1078#1077#1085' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 9 '#1089#1080#1084#1074#1086#1083#1086#1074')'
    EditLabel.Width = 28
    EditLabel.Height = 16
    EditLabel.Caption = #1050#1055#1055
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
    MaxLength = 9
    ParentFont = False
    TabOrder = 10
    OnExit = LabeledEdit18Exit
  end
end
