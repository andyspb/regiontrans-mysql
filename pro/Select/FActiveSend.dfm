object FormActiveSend: TFormActiveSend
  Left = 200
  Top = 136
  Width = 913
  Height = 480
  Caption = #1040#1082#1090#1080#1074#1085#1099#1077' '#1086#1090#1087#1088#1072#1074#1082#1080
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
    Width = 897
    Height = 33
    DragReorder = False
    Sections = <>
  end
  object btPrint: TBMPBtn
    Left = 8
    Top = 2
    Width = 120
    Height = 25
    Hint = #1056#1072#1089#1087#1077#1095#1072#1090#1072#1090#1100' '#1089#1087#1080#1089#1086#1082
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
  object btCansel: TBMPBtn
    Left = 131
    Top = 2
    Width = 120
    Height = 25
    Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1074#1085#1077#1089#1077#1085#1085#1099#1077' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
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
    OnClick = btCanselClick
    ToolBarButton = True
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 74
    Width = 897
    Height = 368
    Hint = #1055#1077#1088#1077#1095#1077#1085#1100' '#1072#1082#1090#1080#1074#1085#1099#1093' '#1086#1090#1087#1088#1072#1074#1086#1082
    Align = alClient
    DataSource = DataSource1
    ParentShowHint = False
    PopupMenu = PopupMenu1
    ShowHint = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        DropDownRows = 2
        Expanded = False
        FieldName = 'Sel'
        PickList.Strings = (
          '-'
          '+')
        PopupMenu = PopupMenu1
        Title.Caption = #1042#1099#1073#1086#1088
        Visible = True
      end
      item
        ButtonStyle = cbsNone
        Expanded = False
        FieldName = 'CityName'
        ReadOnly = True
        Title.Caption = #1043#1086#1088#1086#1076
        Width = 68
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Namber'
        Title.Caption = #1053#1086#1084#1077#1088
        Width = 74
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ClientAcr'
        ReadOnly = True
        Title.Caption = #1047#1072#1082#1072#1079#1095#1080#1082
        Width = 89
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ClientSenderAcr'
        ReadOnly = True
        Title.Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1077#1083#1100
        Visible = True
      end
      item
        ButtonStyle = cbsNone
        Expanded = False
        FieldName = 'AcceptorName'
        ReadOnly = True
        Title.Alignment = taCenter
        Title.Caption = #1055#1086#1083#1091#1095#1072#1090#1077#1083#1100
        Width = 144
        Visible = True
      end
      item
        ButtonStyle = cbsNone
        Expanded = False
        FieldName = 'Number'
        ReadOnly = True
        Title.Caption = #8470' '#1087#1086#1077#1079#1076#1072
        Width = 58
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PlaceC'
        ReadOnly = True
        Title.Caption = #1050#1083'. '#1084#1077#1089#1090
        Width = 40
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Weight'
        ReadOnly = True
        Title.Caption = #1042#1077#1089
        Width = 34
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Volume'
        ReadOnly = True
        Title.Caption = #1054#1073#1098#1077#1084
        Width = 41
        Visible = True
      end
      item
        ButtonStyle = cbsNone
        Expanded = False
        FieldName = 'AcceptorAddress'
        ReadOnly = True
        Title.Alignment = taCenter
        Title.Caption = #1040#1076#1088#1077#1089
        Width = 114
        Visible = True
      end
      item
        ButtonStyle = cbsNone
        Expanded = False
        FieldName = 'AcceptorPhone'
        ReadOnly = True
        Title.Alignment = taCenter
        Title.Caption = #1058#1077#1083#1077#1092#1086#1085
        Width = 89
        Visible = True
      end
      item
        ButtonStyle = cbsNone
        Expanded = False
        FieldName = 'AcceptorRegime'
        ReadOnly = True
        Title.Alignment = taCenter
        Title.Caption = #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099
        Width = 99
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PackCount'
        ReadOnly = True
        Title.Caption = #1059#1087#1072#1082#1086#1074#1082#1072
        Width = 131
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TypeGood'
        ReadOnly = True
        Title.Caption = #1061#1072#1088#1072#1082#1090#1077#1088#1080#1089#1090#1080#1082#1072' '#1075#1088#1091#1079#1072
        Width = 161
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'RollOutName'
        ReadOnly = True
        Title.Caption = #1042#1099#1075#1088#1091#1079#1082#1072
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PayTypeName'
        ReadOnly = True
        Title.Caption = #1054#1087#1083#1072#1090#1072
        Width = 54
        Visible = True
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 33
    Width = 897
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object cbTrain: TLabelSQLComboBox
      Left = 368
      Top = 0
      Width = 296
      Height = 41
      Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1085#1086#1084#1077#1088' '#1087#1086#1077#1079#1076#1072
      Visible = False
      CaptionID = 0
      Caption = #1053#1086#1084#1077#1088' '#1087#1086#1077#1079#1076#1072
      Table = 'Train'
      DatabaseName = 'SeverTrans'
      IDField = 'Ident'
      InfoField = 'Number'
      ParentColor = False
      NotNull = False
      NewItemFlag = False
      Align = alLeft
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object cbPynkt: TLabelSQLComboBox
      Left = 0
      Top = 0
      Width = 368
      Height = 41
      Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1075#1086#1088#1086#1076' '#1082#1091#1076#1072' '#1086#1090#1087#1088#1072#1074#1083#1103#1077#1090#1089#1103' '#1075#1088#1091#1079
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
      TabOrder = 0
    end
    object eFiltr: TToolbarButton
      Left = 668
      Top = 16
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
      TabOrder = 2
      OnClick = cbTrainChange
      ToolBarButton = False
    end
    object ToolbarButton1: TToolbarButton
      Left = 756
      Top = 16
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
      TabOrder = 3
      OnClick = ToolbarButton1Click
      ToolBarButton = False
    end
  end
  object Query1: TQuery
    CachedUpdates = True
    DatabaseName = 'Severtrans'
    Constrained = True
    RequestLive = True
    SQL.Strings = (
      
        'select * from Sends where DateSupp is NULL and ContractType_Iden' +
        't=2 order by AcceptorName')
    UpdateMode = upWhereChanged
    Left = 448
    object Query1AcceptorName: TStringField
      FieldName = 'AcceptorName'
      Origin = 'SEVERTRANS.sends.AcceptorName'
      Size = 60
    end
    object Query1AcceptorAddress: TStringField
      FieldName = 'AcceptorAddress'
      Origin = 'SEVERTRANS.sends.AcceptorAddress'
      Size = 35
    end
    object Query1AcceptorRegime: TStringField
      FieldName = 'AcceptorRegime'
      Origin = 'SEVERTRANS.sends.AcceptorRegime'
      Size = 30
    end
    object Query1AcceptorPhone: TStringField
      FieldName = 'AcceptorPhone'
      Origin = 'SEVERTRANS.sends.AcceptorPhone'
    end
    object Query1Sel: TStringField
      FieldName = 'Sel'
      Size = 3
    end
    object Query1RollOutName: TStringField
      FieldName = 'RollOutName'
      Origin = 'SEVERTRANS.sends.RollOutName'
      Size = 11
    end
    object Query1Weight: TIntegerField
      FieldName = 'Weight'
      Origin = 'SEVERTRANS.sends.Weight'
    end
    object Query1Volume: TStringField
      FieldName = 'Volume'
      Origin = 'SEVERTRANS.sends.Volume'
      Size = 6
    end
    object Query1PackCount: TStringField
      FieldName = 'PackCount'
      Origin = 'SEVERTRANS.sends.PackCount'
      Size = 60
    end
    object Query1PlaceC: TIntegerField
      FieldName = 'PlaceC'
      Origin = 'SEVERTRANS.sends.PlaceC'
    end
    object Query1ClientAcr: TStringField
      FieldName = 'ClientAcr'
      Origin = 'SEVERTRANS.sends.ClientAcr'
      Size = 25
    end
    object Query1PayTypeName: TStringField
      FieldName = 'PayTypeName'
      Origin = 'SEVERTRANS.sends.PayTypeName'
      Size = 10
    end
    object Query1TypeGood: TStringField
      FieldName = 'TypeGood'
      Origin = 'SEVERTRANS.sends.TypeGood'
      Size = 27
    end
    object Query1Ident: TIntegerField
      FieldName = 'Ident'
      Origin = 'SEVERTRANS.sends.Ident'
    end
    object Query1CityName: TStringField
      FieldName = 'CityName'
      Origin = 'SEVERTRANS.sends.CityName'
      Size = 25
    end
    object Query1Number: TStringField
      FieldName = 'Number'
      Origin = 'SEVERTRANS.sends.Number'
      Size = 40
    end
    object Query1SendTypeName: TStringField
      FieldName = 'SendTypeName'
      Origin = 'SEVERTRANS.sends.SendTypeName'
      Size = 15
    end
    object Query1Train_Ident: TIntegerField
      FieldName = 'Train_Ident'
      Origin = 'SEVERTRANS.sends.Train_Ident'
    end
    object Query1Namber: TStringField
      FieldName = 'Namber'
    end
    object Query1ClientSenderAcr: TStringField
      FieldName = 'ClientSenderAcr'
      Origin = 'SEVERTRANS.sends.ClientSenderAcr'
      Size = 25
    end
  end
  object DataSource1: TDataSource
    DataSet = Query1
    Left = 480
  end
  object PopupMenu1: TPopupMenu
    Left = 512
    object N1: TMenuItem
      Caption = #1042#1099#1073#1086#1088
      ShortCut = 16474
      OnClick = N1Click
    end
  end
  object WordApplication1: TWordApplication
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    AutoQuit = False
    Left = 552
  end
end
