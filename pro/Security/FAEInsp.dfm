object FormAEInsp: TFormAEInsp
  Left = 264
  Top = 154
  Width = 460
  Height = 271
  Caption = #1050#1072#1088#1090#1086#1095#1082#1072' '#1086#1087#1077#1088#1072#1090#1086#1088#1072
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
  object LabelSQLComboBox1: TLabelSQLComboBox
    Left = 0
    Top = 150
    Width = 444
    Height = 41
    Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1088#1086#1083#1100' '#1086#1087#1077#1088#1072#1090#1086#1088#1072
    FieldName = 'Roles_Ident'
    CaptionID = 0
    Caption = #1056#1086#1083#1100
    Table = 'Roles'
    DatabaseName = 'Severtrans'
    IDField = 'Ident'
    InfoField = 'Name'
    ParentColor = False
    NotNull = False
    NewItemFlag = False
    Align = alTop
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
  object LabelEdit1: TLabelEdit
    Left = 0
    Top = 33
    Width = 444
    Height = 39
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1060#1048#1054' '#1086#1087#1077#1088#1072#1090#1086#1088#1072' ('#1079#1085#1072#1095#1077#1085#1080#1077' '#1085#1077' '#1076#1086#1083#1078#1085#1086' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 40 '#1089#1080#1084#1074#1086#1083#1086#1074')'
    FieldName = 'PeopleFIO'
    CaptionID = 0
    Caption = #1060#1072#1084#1080#1083#1080#1103' '#1048'.'#1054'. '#1086#1087#1077#1088#1072#1090#1086#1088#1072
    ParentColor = False
    ReadOnly = False
    MaxLength = 40
    Align = alTop
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
  end
  object HeaderControl1: THeaderControl
    Left = 0
    Top = 0
    Width = 444
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
    TabOrder = 4
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
    TabOrder = 5
    OnClick = btCanselClick
    ToolBarButton = True
  end
  object LabelEdit2: TLabelEdit
    Left = 0
    Top = 72
    Width = 444
    Height = 39
    Hint = 
      #1042#1074#1077#1076#1080#1090#1077' NIK-'#1080#1084#1103' '#1086#1087#1077#1088#1072#1090#1086#1088#1072' ('#1079#1085#1072#1095#1077#1085#1080#1077' '#1085#1077' '#1076#1086#1083#1078#1085#1086' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 10 '#1089#1080#1084#1074#1086 +
      #1083#1086#1074')'
    FieldName = 'ShortName'
    CaptionID = 0
    Caption = #1048#1084#1103
    ParentColor = False
    ReadOnly = False
    MaxLength = 10
    Align = alTop
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object LabelEdit3: TLabelEdit
    Left = 0
    Top = 111
    Width = 444
    Height = 39
    Hint = 
      #1042#1074#1077#1076#1080#1090#1077' '#1087#1072#1088#1086#1083#1100' '#1086#1087#1077#1088#1072#1090#1086#1088#1072' ('#1079#1085#1072#1095#1077#1085#1080#1077' '#1085#1077' '#1076#1086#1083#1078#1085#1086' '#1087#1088#1077#1074#1099#1096#1072#1090#1100' 10 '#1089#1080#1084#1074#1086#1083 +
      #1086#1074')'
    FieldName = 'Password'
    CaptionID = 0
    Caption = #1055#1072#1088#1086#1083#1100
    ParentColor = False
    ReadOnly = False
    MaxLength = 10
    Align = alTop
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
  end
end
