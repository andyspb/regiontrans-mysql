object FormAccountTekBox: TFormAccountTekBox
  Left = 150
  Top = 194
  Width = 696
  Height = 480
  Caption = #1057#1095#1077#1090#1072'-'#1058#1069#1050
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
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 16
  object SQLGrid1: TSQLGrid
    Left = 0
    Top = 0
    Width = 680
    Height = 442
    ShowPrompt = False
    QueryEnabled = True
    DatabaseName = 'SeverTrans'
    Section = 'Ident'
    IniFile = 'Gridfld.ini'
    ParentColor = False
    ReadOnly = False
    SortField = 'Dat'
    FullTextFlag = False
    Align = alClient
    OnDblClick = BEditClick
    OnRowChange = SQLGrid1RowChange
  end
  object BEdit: TBMPBtn
    Left = 2
    Top = 4
    Width = 100
    Height = 25
    Hint = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1074#1099#1076#1077#1083#1077#1085#1085#1086#1081'  '#1079#1072#1087#1080#1089#1080' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
    Caption = #1050#1072#1088#1090#1086#1095#1082#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = BEditClick
    NumGlyphs = 3
    ToolBarButton = True
    FileName = 
      'EDIT_BMP'#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0 +
      #0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0
  end
  object BAdd: TBMPBtn
    Left = 108
    Top = 4
    Width = 100
    Height = 25
    Hint = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1085#1086#1074#1086#1081' '#1079#1072#1087#1080#1089#1080' '#1074' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082
    Caption = 'C'#1086#1079#1076#1072#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = BAddClick
    NumGlyphs = 3
    ToolBarButton = True
    FileName = 
      'ADD_BMP'#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0 +
      #0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0
  end
  object BDel: TBMPBtn
    Left = 209
    Top = 4
    Width = 100
    Height = 25
    Hint = #1059#1076#1072#1083#1077#1085#1080#1077' '#1074#1099#1076#1077#1083#1077#1085#1085#1086#1081' '#1079#1072#1087#1080#1089#1080' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
    Caption = #1059#1076#1072#1083#1080#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = BDelClick
    NumGlyphs = 3
    ToolBarButton = True
    FileName = 
      'DEL_BMP'#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0 +
      #0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0
  end
  object BExit: TBMPBtn
    Left = 312
    Top = 4
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
    OnClick = BExitClick
    NumGlyphs = 3
    ToolBarButton = True
    FileName = 
      'EXIT_BMP'#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0 +
      #0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0
  end
end
