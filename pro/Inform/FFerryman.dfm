object FormFerryman: TFormFerryman
  Left = 396
  Top = 113
  Width = 613
  Height = 579
  Caption = #1050#1072#1088#1090#1086#1095#1082#1072' '#1087#1077#1088#1077#1074#1086#1079#1095#1080#1082#1072
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
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 16
  object HeaderControl1: THeaderControl
    Left = 0
    Top = 0
    Width = 597
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
    TabOrder = 10
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
    TabOrder = 11
    OnClick = btCanselClick
    ToolBarButton = True
  end
  object LabeledEdit1: TLabeledEdit
    Left = 8
    Top = 64
    Width = 313
    Height = 24
    Hint = 
      #1042#1074#1077#1076#1080#1090#1077' '#1089#1086#1082#1088#1072#1097#1077#1085#1085#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1087#1077#1088#1077#1074#1086#1079#1095#1080#1082#1072' ('#1085#1077' '#1076#1086#1083#1078#1077#1085#1086' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 3' +
      '5 '#1089#1080#1084#1074#1086#1083#1086#1074')'
    EditLabel.Width = 246
    EditLabel.Height = 16
    EditLabel.Caption = #1057#1086#1082#1088#1072#1097#1077#1085#1085#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1087#1077#1088#1077#1074#1086#1079#1095#1080#1082#1072
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
    OnExit = LabeledEdit1Change
  end
  object eFullName: TLabeledEdit
    Left = 8
    Top = 112
    Width = 585
    Height = 24
    Hint = 
      #1042#1074#1077#1076#1080#1090#1077' '#1087#1086#1083#1085#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1087#1077#1088#1077#1074#1086#1079#1095#1080#1082#1072' ('#1085#1077' '#1076#1086#1083#1078#1077#1085#1086' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 70 '#1089#1080#1084 +
      #1074#1086#1083#1086#1074')'
    EditLabel.Width = 207
    EditLabel.Height = 16
    EditLabel.Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1087#1077#1088#1077#1074#1086#1079#1095#1080#1082#1072
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
    Top = 160
    Width = 473
    Height = 24
    Hint = 
      #1042#1074#1077#1076#1080#1090#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1081' '#1072#1076#1088#1077#1089#1089' '#1087#1077#1088#1077#1074#1086#1079#1095#1080#1082#1072' ('#1085#1077' '#1076#1086#1083#1078#1077#1085' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 30 '#1089 +
      #1080#1084#1074#1086#1083#1086#1074')'
    EditLabel.Width = 394
    EditLabel.Height = 16
    EditLabel.Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1081' '#1072#1076#1088#1077#1089#1089' '#1087#1077#1088#1077#1074#1086#1079#1095#1080#1082#1072' ('#1080#1085#1076#1077#1082#1089','#1075#1086#1088#1086#1076','#1091#1083'.,'#1076#1086#1084','#1082#1074')'
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
    TabOrder = 2
  end
  object LabeledEdit6: TLabeledEdit
    Left = 8
    Top = 205
    Width = 121
    Height = 24
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1090#1077#1083#1077#1092#1086#1085' '#1087#1077#1088#1077#1074#1086#1079#1095#1080#1082#1072' ('#1085#1077' '#1076#1086#1083#1078#1077#1085' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 15 '#1089#1080#1084#1074#1086#1083#1086#1074')'
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
    TabOrder = 3
  end
  object LabeledEdit9: TLabeledEdit
    Left = 56
    Top = 485
    Width = 209
    Height = 24
    Hint = 
      #1042#1074#1077#1076#1080#1090#1077' '#1088#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090' '#1087#1077#1088#1077#1074#1086#1079#1095#1080#1082#1072' ('#1085#1077' '#1076#1086#1083#1078#1077#1085' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 20 '#1089#1080#1084#1074#1086 +
      #1083#1086#1074')'
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
    TabOrder = 13
    Visible = False
  end
  object LabelSQLComboBox4: TLabelSQLComboBox
    Left = 8
    Top = 513
    Width = 593
    Height = 40
    Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1073#1072#1085#1082' '#1087#1077#1088#1077#1074#1086#1079#1095#1080#1082#1072
    Visible = False
    CaptionID = 0
    Caption = #1041#1072#1085#1082' '#1087#1077#1088#1077#1074#1086#1079#1095#1080#1082#1072
    Table = 'Bank'
    DatabaseName = 'SeverTrans'
    IDField = 'Ident'
    InfoField = 'Name'
    ParentColor = False
    NotNull = False
    NewItemFlag = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 14
  end
  object LabeledEdit15: TLabeledEdit
    Left = 8
    Top = 256
    Width = 473
    Height = 24
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1060#1048#1054' '#1042#1086#1076#1080#1090#1077#1083#1103' ('#1085#1077' '#1076#1086#1083#1078#1077#1085' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 50 '#1089#1080#1084#1074#1086#1083#1086#1074')'
    EditLabel.Width = 162
    EditLabel.Height = 16
    EditLabel.Caption = #1042#1086#1076#1080#1090#1077#1083#1100' ('#1092#1072#1084#1080#1083#1080#1103' '#1048'.'#1054'.)'
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
    MaxLength = 50
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
  end
  object LabeledEdit2: TLabeledEdit
    Left = 8
    Top = 304
    Width = 193
    Height = 24
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1085#1086#1084#1077#1088' '#1087#1088#1072#1074' '#1074#1086#1076#1080#1090#1077#1083#1103' ('#1085#1077' '#1076#1086#1083#1078#1077#1085' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 20 '#1089#1080#1084#1074#1086#1083#1086#1074')'
    EditLabel.Width = 42
    EditLabel.Height = 16
    EditLabel.Caption = #1055#1088#1072#1074#1072
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
    TabOrder = 7
  end
  object LabeledEdit3: TLabeledEdit
    Left = 8
    Top = 352
    Width = 265
    Height = 24
    Hint = 
      #1042#1074#1077#1076#1080#1090#1077' '#1085#1086#1084#1077#1088#1085#1086#1081' '#1079#1085#1072#1082' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103' ('#1085#1077' '#1076#1086#1083#1078#1077#1085' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 20 '#1089#1080#1084#1074#1086#1083#1086 +
      #1074')'
    EditLabel.Width = 181
    EditLabel.Height = 16
    EditLabel.Caption = #1043#1086#1089#1091#1076#1072#1088#1089#1090#1074'. '#1085#1086#1084#1077#1088#1085#1086#1081' '#1079#1085#1072#1082
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
    TabOrder = 9
  end
  object LabeledEdit5: TLabeledEdit
    Left = 256
    Top = 304
    Width = 201
    Height = 24
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1084#1072#1088#1082#1091' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103' ('#1085#1077' '#1076#1086#1083#1078#1077#1085' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 20 '#1089#1080#1084#1074#1086#1083#1086#1074')'
    EditLabel.Width = 131
    EditLabel.Height = 16
    EditLabel.Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100' ('#1084#1072#1088#1082#1072')'
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
    TabOrder = 8
  end
  object LabeledEdit7: TLabeledEdit
    Left = 160
    Top = 205
    Width = 193
    Height = 24
    Hint = 
      #1042#1074#1077#1076#1080#1090#1077' '#1085#1086#1084#1077#1088' '#1083#1080#1094#1077#1085#1079#1080#1080' '#1087#1077#1088#1077#1074#1086#1079#1095#1080#1082#1072' ('#1085#1077' '#1076#1086#1083#1078#1077#1085' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 20 '#1089#1080#1084#1074#1086 +
      #1083#1086#1074')'
    EditLabel.Width = 81
    EditLabel.Height = 16
    EditLabel.Caption = #8470' '#1083#1080#1094#1077#1085#1079#1080#1080
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
    TabOrder = 4
  end
  object LabeledEdit8: TLabeledEdit
    Left = 376
    Top = 205
    Width = 193
    Height = 24
    Hint = 
      #1042#1074#1077#1076#1080#1090#1077' '#1089#1077#1088#1080#1102' '#1083#1080#1094#1077#1085#1079#1080#1080' '#1087#1077#1088#1077#1074#1086#1079#1095#1080#1082#1072' ('#1085#1077' '#1076#1086#1083#1078#1077#1085' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 20 '#1089#1080#1084#1074#1086 +
      #1083#1086#1074')'
    EditLabel.Width = 107
    EditLabel.Height = 16
    EditLabel.Caption = #1057#1077#1088#1080#1103' '#1083#1080#1094#1077#1085#1079#1080#1080
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
end
