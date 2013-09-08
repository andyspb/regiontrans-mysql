unit toolbar;

interface

uses
  WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,ToolBtn;

type
  TLDToolBar = class(TPanel)
  private
    fWidthButton,
    fHeightButton:integer;
    fCaptionPresent:boolean;
  protected
    procedure WriteWidthButton(i:integer);
    procedure WriteHeightButton(i:integer);
    procedure WriteCaptionPresent(i:boolean);
  public
    procedure WMSize(var Msg:TMessage); message WM_SIZE;
    constructor Create(ac:TComponent); override;
    procedure Resize;
  published
    property HeightButton:integer read fHeightButton write WriteHeightButton default 100;
    property WidthButton:integer read fWidthButton write WriteWidthButton default 25;
    property CaptionPresent:boolean read fCaptionPresent write WriteCaptionPresent default FALSE;

  end;

procedure Register;

implementation

uses BmpBtn;

constructor TLDToolBar.Create(ac:TComponent);
begin
  fWidthButton:=50;
  fHeightButton:=25;
  fCaptionPresent:=TRUE;
  inherited Create(ac);
  Align:=alTop;
end;

procedure TLDToolBar.WriteWidthButton(i:integer);
begin
  fWidthButton:=i;
  Resize
end;

procedure TLDToolBar.WriteHeightButton(i:integer);
begin
  fHeightButton:=i;
  Resize
end;

procedure TLDToolBar.WriteCaptionPresent(i:boolean);
begin
  fCaptionPresent:=i;
  Resize
end;

procedure TLDToolBar.Resize;
var i:integer;
    x,y,dx:integer;
    tb:TBmpBtn;
    c:integer;
begin
  if CaptionPresent then dx:=WidthButton else dx:=HeightButton;
  x:=2;  y:=2; c:=0;
  for i:=0 to ControlCount-1 do
    if Controls[i] is TBmpBtn then
      begin
	tb:=TBmpBtn(Controls[i]);
	if tb.Visible then
	  begin
	    if (c<>0) and (x+dx>=Width) then
	      begin
		y:=y+HeightButton+2;
                x:=0;
		c:=0;
	      end;
	    tb.Left:=x;
	    tb.Top:=y;
	    tb.Height:=HeightButton;
	    tb.Width:=dx;
	    x:=x+dx+2;
	    inc(c);
	  end;
      end;
  Height:=y+HeightButton+2;
end;

procedure TLDToolBar.WMSize(var Msg:TMessage);
begin
  Resize;
end;

procedure Register;
begin
  RegisterComponents('Tehno', [TLDToolBar]);
end;

end.
