unit Messform;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls;

type
  TMessageForm = class(TForm)
    OKBtn: TBitBtn;
    Memo1: TMemo;
  private
    { Private declarations }
  public
    Procedure AddMessage(ss:TStrings);
  end;

var
  MessageForm: TMessageForm;

implementation

{$R *.DFM}

Procedure TMessageForm.AddMessage(ss:TStrings);
begin
  memo1.Lines.Clear;
  memo1.Lines:=ss
end;

end.
