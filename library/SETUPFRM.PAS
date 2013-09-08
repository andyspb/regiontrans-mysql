unit Setupfrm;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, BMPBtn, Spin, ExtCtrls;

type
  TSetUpForm = class(TForm)
    BMPBtn1: TBMPBtn;
    BMPBtn2: TBMPBtn;
    Panel1: TPanel;
    SpinEdit1: TSpinEdit;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    ZoomIncrement: Word;
  end;

implementation

{$R *.DFM}

procedure TSetUpForm.FormShow(Sender: TObject);
begin
  SpinEdit1.Value:=ZoomIncrement
end;

procedure TSetUpForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    ZoomIncrement:=SpinEdit1.Value
end;

end.
