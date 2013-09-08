object FormSendBox: TFormSendBox
  Left = 158
  Top = 106
  Width = 1070
  Height = 603
  Caption = #1050#1072#1088#1090#1086#1090#1077#1082#1072' '#1086#1090#1087#1088#1072#1074#1086#1082
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
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 1054
    Height = 29
    ButtonHeight = 25
    Caption = 'ToolBar1'
    TabOrder = 0
    object eCard: TToolbarButton
      Left = 0
      Top = 2
      Width = 100
      Height = 25
      Hint = #1042#1085#1077#1089#1090#1080' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1074' '#1082#1072#1088#1090#1086#1095#1082#1091
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
      FileName = 
        'F:\SeverTrans\Icon\IconSelekt_ico'#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0 +
        #0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0
    end
    object eADD: TToolbarButton
      Left = 100
      Top = 2
      Width = 100
      Height = 25
      Hint = #1057#1086#1079#1076#1072#1090#1100' '#1082#1072#1088#1090#1086#1095#1082#1091
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
    object btPrint: TBMPBtn
      Left = 200
      Top = 2
      Width = 120
      Height = 25
      Hint = #1055#1077#1095#1072#1090#1100' '#1082#1074#1080#1090#1072#1085#1094#1080#1080
      Caption = #1055#1077#1095#1072#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btPrintClick
      NumGlyphs = 2
      ToolBarButton = True
    end
    object eDelete: TToolbarButton
      Left = 320
      Top = 2
      Width = 100
      Height = 25
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1082#1072#1088#1090#1086#1095#1082#1091' '
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = eDeleteClick
      ToolBarButton = True
    end
    object eExit: TToolbarButton
      Left = 420
      Top = 2
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
      TabOrder = 4
      OnClick = eExitClick
      ToolBarButton = True
    end
  end
  object SQLGrid1: TSQLGrid
    Left = 0
    Top = 81
    Width = 1054
    Height = 484
    Hint = #1050#1072#1088#1090#1086#1090#1077#1082#1072' '#1086#1090#1087#1088#1072#1074#1086#1082
    ShowPrompt = False
    QueryEnabled = False
    DatabaseName = 'SeverTrans'
    Section = 'Send'
    IniFile = 'Gridfld.ini'
    ParentColor = False
    ReadOnly = False
    SortField = 'Ident'
    FullTextFlag = False
    Align = alClient
    OnDblClick = eCardClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 29
    Width = 1054
    Height = 52
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object cbPynkt: TLabelSQLComboBox
      Left = 225
      Top = 1
      Width = 224
      Height = 36
      Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1091#1085#1082#1090' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103' '#1076#1083#1103' '#1092#1080#1083#1100#1090#1088#1072
      CaptionID = 0
      Caption = #1055#1091#1085#1082#1090' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      Table = 'City'
      DatabaseName = 'SeverTrans'
      IDField = 'Ident'
      InfoField = 'Name'
      ParentColor = False
      NotNull = False
      NewItemFlag = False
      Align = alLeft
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object cbZak: TLabelSQLComboBox
      Left = 1
      Top = 1
      Width = 224
      Height = 36
      Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1079#1072#1082#1072#1079#1095#1080#1082#1072' '#1076#1083#1103' '#1092#1080#1083#1100#1090#1088#1072
      CaptionID = 0
      Caption = #1047#1072#1082#1072#1079#1095#1080#1082
      Table = 'Clients'
      DatabaseName = 'SeverTrans'
      IDField = 'Ident'
      InfoField = 'Acronym'
      ParentColor = False
      NotNull = False
      NewItemFlag = False
      Align = alLeft
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object LabelEditDate1: TLabelEditDate
      Left = 449
      Top = 1
      Width = 129
      Height = 35
      Hint = #1042#1074#1077#1076#1080#1090#1077' '#1076#1072#1090#1091' '#1089' '#1076#1083#1103' '#1092#1080#1083#1100#1090#1088#1072
      CaptionID = 0
      Caption = #1044#1072#1090#1072' '#1089
      DateFormat = 'yyyy-mm-dd'
      Text = '  .  .    '
      ParentColor = False
      ReadOnly = False
      MaxLength = 10
      Align = alLeft
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object LabelEditDate2: TLabelEditDate
      Left = 578
      Top = 1
      Width = 129
      Height = 35
      Hint = #1042#1074#1077#1076#1080#1090#1077' '#1076#1072#1090#1091' '#1087#1086' '#1076#1083#1103' '#1092#1080#1083#1100#1090#1088#1072
      CaptionID = 0
      Caption = #1044#1072#1090#1072' '#1087#1086
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
    object eFiltr: TToolbarButton
      Left = 708
      Top = 18
      Width = 85
      Height = 25
      Hint = #1057#1086#1079#1076#1072#1090#1100' '#1082#1072#1088#1090#1086#1095#1082#1091
      Caption = #1060#1080#1083#1100#1090#1088
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = eFiltrClick
      ToolBarButton = False
    end
    object ToolbarButton1: TToolbarButton
      Left = 796
      Top = 18
      Width = 85
      Height = 25
      Hint = #1057#1086#1079#1076#1072#1090#1100' '#1082#1072#1088#1090#1086#1095#1082#1091
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
      OnClick = ToolbarButton1Click
      ToolBarButton = False
    end
  end
  object WordApplication1: TWordApplication
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    AutoQuit = False
    Left = 616
  end
end
