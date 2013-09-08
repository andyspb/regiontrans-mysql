unit ClientCard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,Tadjform, StdCtrls, Buttons, BMPBtn;

type
  TFCard = class(Tadjustform)
    BMPBtn1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BMPBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FCard: TFCard;

implementation

{$R *.dfm}

procedure TFCard.FormCreate(Sender: TObject);
begin
 fsection:='FCard';
end;

procedure TFCard.BMPBtn1Click(Sender: TObject);
begin
close;
end;

end.
