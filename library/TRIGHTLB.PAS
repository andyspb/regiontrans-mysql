unit TRightLB;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Right, tSqlCls;

type
  TRightListBox = class(TListBox)
  private
    Procedure FillItemsFrom(r:TRight);
  protected
    fStartID:longint;
    procedure DrawItem(Control: TWinControl; Index: Integer;
              Rect: TRect; State: TOwnerDrawState);
    procedure DblClick(Sender: TObject);
    procedure WriteStartID(l: longint);
  public
    Right : TRight;
    ChangeFlag:boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property StartID:longint read fStartID write WriteStartID;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TRightListBox]);
end;

constructor TRightListBox.Create(AOwner: TComponent);
begin
  inherited create(aOwner);
  ChangeFlag:=FALSE;
  Style:=lbOwnerDrawVariable;
  Right :=TRight.Create(nil);
  Parent:=TWinControl(AOwner);
  onDrawItem:=DrawItem;
  onDblClick:=DblClick;
end;

procedure TRightListBox.DblClick(Sender: TObject);
begin
  TRight(Items.Objects[ItemIndex]).ToggleCheck;
  ChangeFlag:=TRUE;
  RePaint
end;

procedure TRightListBox.DrawItem(Control: TWinControl; Index: Integer;
          Rect: TRect; State: TOwnerDrawState);
var
  PrevColor:TColor;
  r:TRight;
const
  xx=15;
begin
  r:=TRight(Items.Objects[Index]);
  Canvas.TextRect(Rect,Rect.Left+r.Level*xx,Rect.Top,Items[Index]);
  if r.ChildsCount=0 then
  with canvas do
  begin
    PrevColor:=Canvas.Brush.Color;
    Brush.Color:=Color;
    Pen.Width:=1;
    Rectangle(Rect.Left+3,Rect.Top+3,Rect.Left+(Rect.Bottom-Rect.Top)-2,Rect.Bottom-3);
    if r.Checked then
    begin
      Pen.Width:=2;
      MoveTo(Rect.Left+5,Rect.Top+(Rect.Bottom-Rect.Top) div 2);
      LineTo(Rect.Left+(Rect.Bottom-Rect.Top) div 2,Rect.Bottom-6);
      LineTo(Rect.Left+(Rect.Bottom-Rect.Top)-5,Rect.Top+5)
    end;
    Brush.Color:=PrevColor
  end
end;

Procedure TRightListBox.FillItemsFrom(r:TRight);
var
  i : Integer;
begin
  for i:=0 to r.ChildsCount-1 do
  begin
    Items.AddObject(r.Childs[i].GetDisplayLabel,r.Childs[i]);
    FillItemsFrom(r.Childs[i])
  end
end;

destructor TRightListBox.Destroy;
begin
  Right.Free;
  inherited Destroy;
end;

procedure TRightListBox.WriteStartID(l: longint);
begin
  fStartID:=l;
  if SQL<>nil then
    Right.BuildTree(l);
  FillItemsFrom(Right);
end;

end.
