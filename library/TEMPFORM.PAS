unit Tempform;

interface
{$D-}

uses
  SysUtils, WinTypes, WinProcs, Messages,
  Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, Spin, VBXCtrl,
  Pict, StdCtrls, Buttons;

type
  TTmpForm = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
  end;

var
  TmpForm: TTmpForm;

implementation
{$R *.DFM}
end.
