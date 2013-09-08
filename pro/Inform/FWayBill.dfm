object FormWayBill: TFormWayBill
  Left = 260
  Top = 130
  Width = 582
  Height = 307
  Caption = #1058#1086#1074#1072#1088#1085#1086'-'#1058#1088#1072#1085#1089#1087#1086#1088#1090#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
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
  object Panel2: TPanel
    Left = 0
    Top = 29
    Width = 566
    Height = 48
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object LabelEditDate1: TLabelEditDate
      Left = 9
      Top = 2
      Width = 128
      Height = 39
      Hint = #1042#1074#1077#1076#1080#1090#1077' '#1076#1072#1090#1091'  '#1076#1083#1103' '#1092#1080#1083#1100#1090#1088#1072
      CaptionID = 0
      Caption = #1044#1072#1090#1072' '#1086#1090#1087#1088#1072#1074#1082#1080
      DateFormat = 'yyyy-mm-dd'
      Text = '  .  .    '
      ParentColor = False
      ReadOnly = False
      MaxLength = 10
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnEnter = LabelEditDate1Enter
      OnExit = LabelEditDate1Exit
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 125
    Width = 566
    Height = 48
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object cbCity: TLabelSQLComboBox
      Left = 0
      Top = 0
      Width = 281
      Height = 40
      Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1075#1086#1088#1086#1076' '#1076#1083#1103' '#1092#1080#1083#1100#1090#1088#1072
      CaptionID = 0
      Caption = #1043#1086#1088#1086#1076
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
      TabOrder = 0
    end
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 566
    Height = 29
    ButtonHeight = 25
    Caption = 'ToolBar1'
    TabOrder = 3
    object btPrint: TBMPBtn
      Left = 0
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
      TabOrder = 0
      OnClick = btPrintClick
      NumGlyphs = 2
      ToolBarButton = True
    end
    object eExit: TToolbarButton
      Left = 120
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
      TabOrder = 1
      OnClick = eExitClick
      ToolBarButton = True
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 77
    Width = 566
    Height = 48
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object cbZak: TLabelSQLComboBox
      Left = 0
      Top = 0
      Width = 280
      Height = 40
      Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1077#1088#1077#1074#1086#1079#1095#1080#1082#1072' '#1076#1083#1103' '#1092#1080#1083#1100#1090#1088#1072
      CaptionID = 0
      Caption = #1055#1077#1088#1077#1074#1086#1079#1095#1080#1082
      Table = 'FerryMan'
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
    object BitBtn7: TBitBtn
      Left = 288
      Top = 15
      Width = 25
      Height = 25
      Hint = 
        #1055#1088#1080' '#1085#1072#1078#1072#1090#1080#1080' '#1087#1088#1077#1076#1086#1089#1090#1072#1074#1083#1103#1077#1090#1089#1103' '#1074#1086#1079#1084#1086#1078#1085#1086#1089#1090#1100' '#1080#1079#1084#1077#1085#1080#1090#1100' '#1082#1072#1088#1090#1086#1095#1082#1091' '#1086#1090#1087#1088#1072#1074 +
        #1080#1090#1077#1083#1103
      Caption = 'P'
      Font.Charset = SYMBOL_CHARSET
      Font.Color = clBlue
      Font.Height = -24
      Font.Name = 'Wingdings 3'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = BitBtn7Click
    end
    object BitBtn3: TBitBtn
      Left = 320
      Top = 15
      Width = 25
      Height = 25
      Hint = 
        #1055#1088#1080' '#1085#1072#1078#1072#1090#1080#1080' '#1087#1088#1077#1076#1086#1089#1090#1072#1074#1083#1103#1077#1090#1089#1103' '#1074#1086#1079#1084#1086#1078#1085#1086#1089#1090#1100' '#1076#1086#1073#1072#1074#1080#1090#1100' '#1085#1077#1076#1086#1089#1090#1072#1102#1097#1077#1075#1086' '#1086#1090 +
        #1087#1088#1072#1074#1080#1090#1077#1083#1103
      Caption = '+'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -24
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = BitBtn3Click
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 173
    Width = 566
    Height = 48
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    object cbxList: TLabelComboBox
      Left = 0
      Top = 1
      Width = 281
      Height = 39
      CaptionID = 0
      Caption = #1060#1080#1083#1100#1090#1088' '#1087#1086' '#1089#1090#1088#1072#1093#1086#1074#1082#1077
      TabOrder = 0
    end
  end
  object WordApplication1: TWordApplication
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    AutoQuit = False
    Left = 248
  end
end
