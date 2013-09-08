unit StatDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, BMPBtn;

type
  TFindAppsDlg = class(TForm)
    lFindApps: TLabel;
    btCancel: TBMPBtn;
    procedure btCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
  	StopFlag:integer;
    { Public declarations }
  end;

var
  FindAppsDlg: TFindAppsDlg;

implementation

{$R *.DFM}

procedure TFindAppsDlg.btCancelClick(Sender: TObject);
begin
	StopFlag:=1;
end;

procedure TFindAppsDlg.FormCreate(Sender: TObject);
begin
	StopFlag:=0;
end;

end.
