object FUnload: TFUnload
  Left = 376
  Top = 180
  Width = 391
  Height = 129
  Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093
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
  object LabelEditDate1: TLabelEditDate
    Left = 9
    Top = 2
    Width = 128
    Height = 39
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1076#1072#1090#1091' '#1089' '#1076#1083#1103' '#1092#1080#1083#1100#1090#1088#1072
    CaptionID = 0
    Caption = #1044#1072#1090#1072' '#1089
    DateFormat = 'yyyy-mm-dd'
    Text = '  .  .    '
    ParentColor = False
    ReadOnly = False
    MaxLength = 10
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
  end
  object LabelEditDate2: TLabelEditDate
    Left = 153
    Top = 1
    Width = 129
    Height = 39
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1076#1072#1090#1091' '#1087#1086' '#1076#1083#1103' '#1092#1080#1083#1100#1090#1088#1072
    CaptionID = 0
    Caption = #1044#1072#1090#1072' '#1087#1086
    DateFormat = 'yyyy-mm-dd'
    Text = '  .  .    '
    ParentColor = False
    ReadOnly = False
    MaxLength = 10
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object btPrint: TBMPBtn
    Left = 8
    Top = 58
    Width = 121
    Height = 25
    Hint = #1055#1077#1095#1072#1090#1100' '#1082#1074#1080#1090#1072#1085#1094#1080#1080
    Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
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
  object eExit: TToolbarButton
    Left = 137
    Top = 58
    Width = 100
    Height = 25
    Hint = #1042#1099#1093#1086#1076' '#1080#1079' '#1082#1072#1088#1090#1086#1090#1077#1082#1080
    Caption = #1042#1099#1093#1086#1076
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = eExitClick
    ToolBarButton = True
  end
end
