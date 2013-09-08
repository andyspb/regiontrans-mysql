unit Pictboot;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls;

type
  TPictBootForm = class(TForm)
    Panel: TPanel;
    ImageBoot: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var PictBootDir:TFileName;
implementation
{$R *.DFM}

procedure TPictBootForm.FormCreate(Sender: TObject);
begin
  try
    ImageBoot.Picture.LoadFromFile(PictBootDir+'pictboot.bmp');
  except
  end
end;

begin
  PictBootDir:='';
end.
