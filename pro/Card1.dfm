object Formcard1: TFormcard1
  Left = 526
  Top = 240
  Width = 696
  Height = 480
  Caption = 'Test'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SQLGrid1: TSQLGrid
    Left = 40
    Top = 80
    Width = 553
    Height = 281
    ShowPrompt = False
    QueryEnabled = False
    DatabaseName = 'SeverTrans'
    Section = 'Clients'
    IniFile = 'Gridfld.ini'
    ParentColor = False
    ReadOnly = False
    FullTextFlag = False
  end
end
