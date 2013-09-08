unit Loading;

interface

uses
  Wait, SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls;

type
  TLoadForm = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Wait:   TWait;
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TLoadForm.FormShow(Sender: TObject);
begin
   Wait.Init;
end;

procedure TLoadForm.FormDestroy(Sender: TObject);
begin
   Wait.Done;
end;

end.
