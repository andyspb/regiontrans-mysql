{ Windows 95 style progress bar                  }
{ Vitaly Monastirsky  vitaly@vdl.t.u-tokyo.ac.jp }

unit Gauge95;

interface

uses
  WinTypes, WinProcs, Messages, Classes, Graphics, Controls, ExtCtrls,
  Forms;

type
  TBevelStyle = (bsNone, bsLowered, bsRaised);

  TGauge95 = class(TGraphicControl)
  private
    FMinValue  : Longint;
    FMaxValue  : Longint;
    FCurValue  : Longint;
    FBevelStyle: TBevelStyle;
    FBoxColor  : TColor;
    FBoxCount  : Integer;
    FBoxWidth  : Integer;
    procedure SetMinValue(Value: Longint);
    procedure SetMaxValue(Value: Longint);
    procedure SetBevelStyle(Value: TBevelStyle);
    procedure SetBoxColor(Value: TColor);
    procedure SetBoxCount(Value: Integer);
    procedure SetBoxWidth(Value: Integer);
    procedure SetProgress(Value: Longint);
    function GetPercentDone: Double;
    procedure AdjustSize (var W: Integer; var H: Integer);
  protected
    LastPercent : integer;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddProgress(Value: Longint);
    property PercentDone: Double read GetPercentDone;
    function GetFMax : Longint;
  published
    property Align;
    property BevelStyle: TBevelStyle read FBevelStyle write SetBevelStyle default bsLowered;
    property BoxColor : TColor read FBoxColor write SetBoxColor default clHighlight;
    property BoxCount : Integer read FBoxCount write SetBoxCount default 20;
    property BoxWidth : Integer read FBoxWidth write SetBoxWidth default 12;
    property Color;
    property Enabled;
    property MinValue: Longint read FMinValue write SetMinValue default 0;
    property MaxValue: Longint read FMaxValue write SetMaxValue default 100;
    property ParentColor;
    property ParentShowHint;
    property Progress: Longint read FCurValue write SetProgress;
    property ShowHint;
    property Visible;
  end;

procedure Register;

implementation

const
  MinBoxSize = 3;
  DeltaSize: array[TBevelStyle] of Integer = (1,3,3);

{--------------------------------------------------}
  constructor TGauge95.Create(AOwner: TComponent);
{--------------------------------------------------}
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csFramed, csOpaque];
  FMinValue := 0;
  FMaxValue := 100;
  FCurValue := 0;
  FBevelStyle := bsLowered;
  FBoxColor := clHighlight;
  FBoxCount := 20;
  FBoxWidth := 12;
  Width  := (FBoxWidth * FBoxCount) + 3;
  Height := 24;
  LastPercent:=0;
end;

{-------------------------------------------------}
  procedure TGauge95.SetMinValue(Value: Longint);
{-------------------------------------------------}
begin
  if Value <> FMinValue then
  begin
    FMinValue := Value;
    Refresh;
  end;
end;

{-------------------------------------------------}
  procedure TGauge95.SetMaxValue(Value: Longint);
{-------------------------------------------------}
begin
  if Value <> FMaxValue then
  begin
    FMaxValue := Value;
    Refresh;
  end;
end;

{-------------------------------------------------------}
  procedure TGauge95.SetBevelStyle(Value: TBevelStyle);
{-------------------------------------------------------}
var
  W, H : Integer;
begin
  if Value <> FBevelStyle then
    begin
      W := Width;
      H := Height;
      if FBevelStyle = bsNone then
        begin
          Inc(W, 2);
          Inc(H, 2);
        end
      else if Value = bsNone then
        begin
          Dec(W, 2);
          Dec(H, 2);
        end;
      FBevelStyle := Value;
      inherited SetBounds(Left, Top, W, H);
      Invalidate;
    end;
end;

{------------------------------------------------}
  procedure TGauge95.SetBoxCount(Value: Integer);
{------------------------------------------------}
var
  W: Integer;
begin
  if FBoxCount <> Value then
    begin
      if Value < 1 then Value := 1;
      FBoxCount := Value;
      W := FBoxWidth * FBoxCount + 1;
      if FBevelStyle <> bsNone then Inc(W, 2);
      SetBounds(Left, Top, W, Height);
      Invalidate;
    end;
end;

{-----------------------------------------------}
  procedure TGauge95.SetBoxColor(Value: TColor);
{-----------------------------------------------}
begin
  if FBoxColor <> Value then
    begin
      FBoxColor := Value;
      Invalidate;
    end;
end;

{------------------------------------------------}
  procedure TGauge95.SetBoxWidth(Value: Integer);
{------------------------------------------------}
var
  W: Integer;
begin
  if FBoxWidth <> Value then
    begin
      if Value < MinBoxSize then
        Value := MinBoxSize;
      FBoxWidth := Value;
      W := FBoxWidth * FBoxCount + 1;
      if FBevelStyle <> bsNone then
        Inc(W, 2);
      SetBounds(Left, Top, W, Height);
      Invalidate;
    end;
end;

{-------------------------------------------------}
  procedure TGauge95.SetProgress(Value: Longint);
{-------------------------------------------------}
var
  p2:longint;
begin
  p2:=round((Value - FMinValue) / (FMaxValue - FMinValue) * 50);
  if (FCurValue <> Value) and (Value >= FMinValue) and (Value <= FMaxValue) then
    begin
      FCurValue := Value;
      if (LastPercent<>p2) then Refresh;
      LastPercent := p2;
    end;
end;

{-------------------------------------------}
  function TGauge95.GetPercentDone: Double;
{-------------------------------------------}
begin
  if FMaxValue = FMinValue then
    Result := 0
  else
    Result := (FCurValue - FMinValue) /
              (FMaxValue - FMinValue) * 100;
end;

{-----------------------------------------------------------------}
  procedure TGauge95.AdjustSize (var W: Integer; var H: Integer);
{-----------------------------------------------------------------}
var
  TempW, TempH: Integer;
begin
  if csLoading in ComponentState then
    Exit;

  TempW := W - DeltaSize[FBevelStyle];
  TempH := H - DeltaSize[FBevelStyle] - 1;

  if TempW < FBoxWidth then
    TempW := FBoxWidth;

  if TempH < MinBoxSize then
    TempH := MinBoxSize;

  FBoxCount := TempW div FBoxWidth;

  if Align = alNone then
    TempW := FBoxCount * FBoxWidth;

  W := TempW + DeltaSize[FBevelStyle];
  H := TempH + DeltaSize[FBevelStyle] + 1;

end;

{----------------------------------------------------------------------}
  procedure TGauge95.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
{----------------------------------------------------------------------}
var
  W, H: Integer;
begin
  W := AWidth;
  H := AHeight;
  AdjustSize (W, H);
  inherited SetBounds (ALeft, ATop, W, H);
end;

{---------------------------}
  procedure TGauge95.Paint;
{---------------------------}
var
  I, PaintBoxes: integer;
  BoxRect, BoundRect, TheRect : TRect;
  GaugeImage: TBitmap;
begin
  GaugeImage := TBitmap.Create;
  try
    GaugeImage.Height := Height;
    GaugeImage.Width := Width;

    BoundRect := ClientRect;
    TheRect   := BoundRect;

    if FBevelStyle = bsLowered then
      Frame3D(GaugeImage.Canvas, TheRect, clBtnShadow, clBtnHighlight, 1)
    else if  FBevelStyle = bsRaised then
      Frame3D(GaugeImage.Canvas, TheRect, clBtnHighlight, clBtnShadow, 1);

    with GaugeImage.Canvas do
      begin
        if ParentColor then
          Brush.Color := Parent.Brush.Color
        else
          Brush.Color := Color;
        FillRect(TheRect);
        if Enabled then
          Brush.Color := FBoxColor
        else
          Brush.Color := clInactiveCaption;
        PaintBoxes := Round(PercentDone * FBoxCount * 0.01);
        if PaintBoxes > FBoxCount then
          PaintBoxes := FBoxCount;
        BoxRect := Bounds(TheRect.Left + 1, TheRect.Top + 1,
                          FBoxWidth - 2 , Height - DeltaSize[FBevelStyle] - 1);
        for I := 1 to PaintBoxes do
          begin
            FillRect(BoxRect);
            OffsetRect(BoxRect, FBoxWidth, 0);
          end;
      end;
      Canvas.CopyRect(BoundRect, GaugeImage.Canvas, BoundRect);
  finally
    GaugeImage.Free;
  end;
end;

{-------------------------------------------------}
  procedure TGauge95.AddProgress(Value: Longint);
{-------------------------------------------------}
var
  NewValue:longint;
begin
  NewValue:=FCurValue + Value;
  if (NewValue >= FMinValue) and (NewValue <= FMaxValue) then
      Progress := NewValue;
end;
{-------------------------------------------------}
function TGauge95.GetFMax : Longint;
{-------------------------------------------------}
begin
 GetFMax:=FMaxValue;
end;

{---------------------}
  procedure Register;
{---------------------}
begin
  RegisterComponents('Samples', [TGauge95]);
end;

end.

