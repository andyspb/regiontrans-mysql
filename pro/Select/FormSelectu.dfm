object FormSelect: TFormSelect
  Left = 168
  Top = 121
  Width = 560
  Height = 406
  Caption = #1057#1087#1080#1089#1082#1080
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
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 544
    Height = 29
    ButtonHeight = 25
    Caption = 'ToolBar1'
    TabOrder = 0
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
    Top = 29
    Width = 544
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object cbxList: TLabelComboBox
      Left = 0
      Top = 1
      Width = 321
      Height = 39
      CaptionID = 0
      Caption = #1057#1087#1080#1089#1086#1082
      OnChange = cbxListChange
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 81
    Width = 544
    Height = 48
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object LabelEditDate1: TLabelEditDate
      Left = 9
      Top = 2
      Width = 128
      Height = 39
      Hint = #1042#1074#1077#1076#1080#1090#1077' '#1076#1072#1090#1091' '#1089' '#1076#1083#1103' '#1092#1080#1083#1100#1090#1088#1072
      Visible = False
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
      Visible = False
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
    object RadioGroup1: TRadioGroup
      Left = 296
      Top = 0
      Width = 185
      Height = 45
      Caption = #1044#1072#1090#1072
      ItemIndex = 0
      Items.Strings = (
        #1057#1086#1089#1090#1072#1074#1083#1077#1085#1080#1103
        #1054#1090#1087#1088#1072#1074#1083#1077#1085#1080#1103)
      TabOrder = 2
      Visible = False
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 129
    Width = 544
    Height = 48
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object cbZak: TLabelSQLComboBox
      Left = 0
      Top = 0
      Width = 280
      Height = 41
      Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1079#1072#1082#1072#1079#1095#1080#1082#1072' '#1076#1083#1103' '#1092#1080#1083#1100#1090#1088#1072
      Visible = False
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
    object cbCity: TLabelSQLComboBox
      Left = 280
      Top = 0
      Width = 256
      Height = 40
      Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1075#1086#1088#1086#1076' '#1076#1083#1103' '#1092#1080#1083#1100#1090#1088#1072
      Visible = False
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
      TabOrder = 1
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 177
    Width = 544
    Height = 48
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    object cbxSort: TLabelComboBox
      Left = 0
      Top = 0
      Width = 248
      Height = 39
      Visible = False
      CaptionID = 0
      Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072
      Align = alLeft
      TabOrder = 0
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 225
    Width = 544
    Height = 48
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 5
    object cbNumber: TLabelSQLComboBox
      Left = 0
      Top = 0
      Width = 280
      Height = 40
      Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1085#1086#1084#1077#1088' '#1087#1083#1072#1090#1077#1078#1085#1086#1075#1086' '#1087#1086#1088#1091#1095#1077#1085#1080#1103
      Visible = False
      CaptionID = 0
      Caption = #1053#1086#1084#1077#1088' '#1087#1083#1072#1090#1077#1078#1085#1086#1075#1086' '#1087#1086#1088#1091#1095#1077#1085#1080#1103
      Table = 'SendsPPWay'
      DatabaseName = 'SeverTrans'
      IDField = 'Ident'
      InfoField = 'Number'
      ParentColor = False
      NotNull = False
      NewItemFlag = False
      Align = alLeft
      ParentShowHint = False
      ShowHint = True
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
