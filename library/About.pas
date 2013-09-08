unit About;

interface
{$D-}

uses
  SysUtils, WinTypes, WinProcs, Messages,
  Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, Spin,
  StdCtrls, Buttons;

type
  TAboutForm = class(TForm)
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    Label3: TLabel;
    procedure BitBtn1Click(Sender: TObject);
  private
     cur : Word;
     Symb:string;
     ext:String[4];
  public
  end;

var
  AboutForm: TAboutForm;

implementation
{$R *.DFM}

procedure TAboutForm.BitBtn1Click(Sender: TObject);
begin
  Close
end;

{procedure TAboutForm.Image1DblClick(Sender: TObject);
begin
  cur:= (cur+1) mod 3;
  Symb[5]:=char(ord('0')+cur);
  Image1.Picture.BitMap.Handle:=LoadBitMap(Hinstance,@Symb[1])
end;}

end.
