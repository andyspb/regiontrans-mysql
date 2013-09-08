unit Debugfrm;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

type
  TDebugForm = class(TForm)
    msg: TEdit;
    Label1: TLabel;
    mText: TMemo;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}

end.
