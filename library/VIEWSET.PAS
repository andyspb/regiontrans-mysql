unit Viewset;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, BMPBtn, Spin, ExtCtrls;

type
  TViewSetupForm = class(TForm)
    BMPBtn1: TBMPBtn;
    BMPBtn2: TBMPBtn;
    Panel1: TPanel;
    SpinEdit1: TSpinEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    ZoomIncrement: Word;
  end;

implementation

{$R *.DFM}

procedure TViewSetupForm.FormCreate(Sender: TObject);
begin
  SpinEdit1.Value:=ZoomIncrement
end;

procedure TViewSetupForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    ZoomIncrement:=SpinEdit1.Value
end;


end.
