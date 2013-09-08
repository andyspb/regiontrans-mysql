object FormInsp: TFormInsp
  Left = 295
  Top = 131
  Width = 577
  Height = 511
  Caption = #1057#1087#1080#1089#1086#1082' '#1086#1087#1077#1088#1072#1090#1086#1088#1086#1074
  Color = clActiveBorder
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
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 561
    Height = 29
    Caption = 'ToolBar1'
    TabOrder = 0
    object eCard: TToolbarButton
      Left = 0
      Top = 2
      Width = 100
      Height = 22
      Hint = #1042#1085#1077#1089#1090#1080' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1074' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082
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
      OnClick = eCardClick
      NumGlyphs = 3
      ToolBarButton = True
      FileName = 'F:\SeverTrans\Icon\IconSelekt_ico'#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0
    end
    object eADD: TToolbarButton
      Left = 100
      Top = 2
      Width = 100
      Height = 22
      Hint = #1057#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1091#1102' '#1082#1072#1088#1090#1086#1095#1082#1091
      Caption = #1057#1086#1079#1076#1072#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = eADDClick
      ToolBarButton = True
    end
    object eDelete: TToolbarButton
      Left = 200
      Top = 2
      Width = 100
      Height = 22
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1085#1091#1102' '#1079#1072#1087#1080#1089#1100' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072' '
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
      OnClick = eDeleteClick
      ToolBarButton = True
    end
    object eExit: TToolbarButton
      Left = 300
      Top = 2
      Width = 100
      Height = 22
      Hint = #1042#1099#1093#1086#1076' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
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
  object SQLGrid1: TSQLGrid
    Left = 0
    Top = 29
    Width = 561
    Height = 444
    ShowPrompt = False
    QueryEnabled = False
    DatabaseName = 'SeverTrans'
    Section = 'InspectorRoles'
    IniFile = 'Gridfld.ini'
    ParentColor = False
    ReadOnly = False
    SortField = 'PeopleFIO'
    FullTextFlag = False
    Align = alClient
    OnDblClick = eCardClick
  end
end
