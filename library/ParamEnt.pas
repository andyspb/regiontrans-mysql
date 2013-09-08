unit ParamEnt;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Tadjform, Forms, Dialogs, StdCtrls, Sqlctrls, LblCombo, Buttons, BMPBtn;

type
  TParamsEnter = class(TAdjustForm)
    btOk: TBMPBtn;
    BMPBtn1: TBMPBtn;
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    LWidth,LHeight : integer;
    procedure OnCBKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  end;

implementation

{$R *.DFM}
procedure TParamsEnter.FormActivate(Sender: TObject);
var
  i:integer;
begin
  for i := 0 to Client.ComponentCount -1 do
     if Client.Components[i] is TLabelComboBox then
      begin
         TLabelComboBox(Client.Components[i]).ComboBox.SetFocus;
         break;
      end;
end;

procedure TParamsEnter.FormResize(Sender: TObject);
var
  i:integer;
  c:TLabelComboBox;
  c1:TLabelComboBox;
begin
  c:=NIL;
  for i := 0 to Client.ComponentCount -1 do
     if Client.Components[i] is TLabelComboBox then
       begin
         c1:=c;
         c:=TLabelComboBox(Client.Components[i]);
         if c1=NIL then
           c.SetBoundsEx(DeltaX,DeltaY,Client.ClientWidth-2*DeltaX,-1)
         else
           c.SetDown(c1,-1,-1);
       end;
  if c<>NIL then
    ClientHeight:=StatusBar.Height+ToolBar.Height+DeltaY+c.Height+c.Top;
end;

procedure TParamsEnter.OnCBKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=13 then ModalResult:=mrOk;
end;

end.
