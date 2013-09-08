unit ask_ft;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, BMPBtn, toolbtn;

type
  TAsk_filterType = class(TForm)
    RadioGroup1: TRadioGroup;
    ToolbarButton1: TToolbarButton;
    ToolbarButton2: TToolbarButton;
    procedure ToolbarButton1Click(Sender: TObject);
    procedure ToolbarButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}

procedure TAsk_filterType.ToolbarButton1Click(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TAsk_filterType.ToolbarButton2Click(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

end.
