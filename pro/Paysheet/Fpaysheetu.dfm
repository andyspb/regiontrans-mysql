object FormPaySheet: TFormPaySheet
  Left = 261
  Top = 142
  Width = 344
  Height = 270
  Caption = #1055#1083#1072#1090#1077#1078#1082#1080
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
    Width = 328
    Height = 41
    DragReorder = False
    Sections = <>
  end
  object btSave: TBMPBtn
    Left = 0
    Top = 2
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
    TabOrder = 4
    OnClick = btSaveClick
    NumGlyphs = 2
    ToolBarButton = True
  end
  object btCansel: TBMPBtn
    Left = 123
    Top = 2
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
    TabOrder = 5
    OnClick = btCanselClick
    ToolBarButton = True
  end
  object cbClient: TLabelSQLComboBox
    Left = 0
    Top = 41
    Width = 328
    Height = 41
    Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1047#1072#1082#1072#1079#1095#1080#1082#1072
    FieldName = 'Client_Ident'
    CaptionID = 0
    Caption = #1050#1083#1080#1077#1085#1090
    Table = 'Clients'
    DatabaseName = 'SeverTrans'
    IDField = 'Ident'
    InfoField = 'Acronym'
    ParentColor = False
    NotNull = False
    NewItemFlag = False
    Align = alTop
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
  end
  object eNumber: TLabelEdit
    Left = 0
    Top = 121
    Width = 328
    Height = 39
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1085#1086#1084#1077#1088' '#1087#1083#1072#1090#1077#1078#1082#1080
    FieldName = 'Number'
    CaptionID = 0
    Caption = #1053#1086#1084#1077#1088
    ParentColor = False
    ReadOnly = False
    MaxLength = 0
    Align = alTop
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
  end
  object LabelEditDate1: TLabelEditDate
    Left = 0
    Top = 160
    Width = 201
    Height = 39
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1076#1072#1090#1091' '#1086#1087#1083#1072#1090#1099
    FieldName = 'Dat'
    CaptionID = 0
    Caption = #1044#1072#1090#1072' '
    DateFormat = 'yyyy-mm-dd'
    Text = '  .  .    '
    ParentColor = False
    ReadOnly = False
    MaxLength = 10
    Align = alLeft
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
  object eSum: TLabelEdit
    Left = 0
    Top = 82
    Width = 328
    Height = 39
    Hint = #1057#1091#1084#1084#1072' '
    FieldName = 'Sum'
    CaptionID = 0
    Caption = #1057#1091#1084#1084#1072
    ParentColor = False
    ReadOnly = False
    MaxLength = 0
    Align = alTop
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
end
