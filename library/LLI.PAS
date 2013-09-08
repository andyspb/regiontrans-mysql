{******************************************************************************}
{*                                                                            *}
{*                   DFL Software's Light Lib Images Unit                     *}
{*                  (C) Copyright DFL Software, Inc. 1996                     *}
{*                                                                            *}
{******************************************************************************}

unit lli;

{******************************************************************************}
   interface
{******************************************************************************}

{ comment this out to compile component as NON data aware }
{$define DataAware}

{ comment this out to compile component as NON SDE( SuccessWare Database Engine ) }
{ $define SDE} {//\\}

uses Classes, Controls, Messages,
{$ifdef Win32}
     Windows,
{$else}
     WinTypes, WinProcs,
{$endif}
     Forms, Graphics, StdCtrls,
     SysUtils, DsgnIntf, Dialogs, Gauges, ExtCtrls, Buttons, Clipbrd,
     {$ifdef DataAware}
     dbtables, db,
         {$ifdef SDE}
         dbiprocs,
         {$endif}
     {$endif}
     Printers,
     Menus, Mask,
     llo,      { Light Lib Objects }
     iSaveAs,  { Save As Dialog Class }
     iAbout,   { About Dialog Class }
     iPrint,   { Image Print Dialog Class }
     iTlbrSrc, { Image Toolbar configuration }
     iCompres, { TCompressionDlg }
     iQuality, { TQualityDlg }
     iFilter,
     llTwain;

{ include Light Lib Images defines }
{$I LLI.INC}


{ declaration of external DLL functions }

    function  iGet( liLLObject, liDevice, liFormat: LongInt;
                    iX1, iY1, iX2, iY2: Integer;
                    liParam1, liParam2, liParam3, liParam4, liParam5,
                    liUserParam: LongInt ): LongInt; {$ifdef Win32}stdcall;{$endif}

    function  iPut( liLLObject: LongInt;
                    iX1, iY1, iX2, iY2: Integer;
                    liDevice, liFormat: LongInt;
                    iXr, iYr: Integer;
                    liParam1, liParam2, liParam3, liParam4, liParam5,
                    liUserParam: LongInt ): LongInt; {$ifdef Win32}stdcall;{$endif}

    function  iCopy( liLLObject: LongInt;
                     iX1, iY1, iX2, iY2: Integer;
                     liTransform,
                     liParam1, liParam2, liParam3, liParam4, liParam5,
                     liUserParam: LongInt ): LongInt; {$ifdef Win32}stdcall;{$endif}

    function  iDLLLoad : Longint; {$ifdef Win32}stdcall;{$endif}

{$ifdef DataAware}
    { streaming functions }
    function streamCreate( lpImage: Longint; lpszName: Longint;
                           fnAttribut: Integer ): Longint; export; {$ifdef Win32}stdcall;{$endif}
    function streamDelete( lpImage: Longint; lpszName: Longint ): Integer; export; {$ifdef Win32}stdcall;{$endif}
    function streamOpen  ( lpImage: Longint; lpszName: Longint;
                           fnAttribut: Integer ): Longint; export; {$ifdef Win32}stdcall;{$endif}
    function streamClose ( lpImage: Longint; hf: Longint ): Longint; export; {$ifdef Win32}stdcall;{$endif}
    function streamRead  ( lpImage: Longint; hf: Longint; hpvbuffer: Longint;
                           cbBuffer: Longint ): Longint; export; {$ifdef Win32}stdcall;{$endif}
    function streamWrite ( lpImage: Longint; hf: Longint; hpvbuffer: Longint;
                           cbBuffer: Longint ): Longint; export; {$ifdef Win32}stdcall;{$endif}
    function streamSeek  ( lpImage: Longint; hf: Longint; lOffset: Longint;
                           nOrigin: Integer ): Longint; export; {$ifdef Win32}stdcall;{$endif}
{$endif}

{******************************************************************************}

type
    TImageDimension = record
        Top, Left, Height, Width: LongInt;
    end;

TFitStyle = ( fsNone, fsWidth, fsHeight, fsWindow, fsBest  );

{******************************************************************************
  TImageToolBar class:
       This class is responsable for toolbar buttons, events, etc...
 ******************************************************************************}

 TImageToolBar = class( TLLToolBar )
     private
     protected
     public
         procedure BtnClick( Index: TLLToolBtns ); override;
     published
end;

{******************************************************************************
  TImageInWindow class:
       This class is the owner of an ImageInWindow class instance
 ******************************************************************************}

TImageInWindow = class( TWinControl )
    private
        FitMode          : LongInt;
    protected
        liOriImage       : LongInt;
        liDisImage       : LongInt;
        lFirstDisplay    : Boolean;
        iAngle           : Integer;
        iFlip            : LongInt;
        lGaugeVisible    : Boolean;
        FDrawPen         : TPen;
        FDrawBrush       : TBrush;
        FDrawFont        : TFont;
        FCurrentPalette  : HPalette;
{$ifdef SDE}
    {Added for SDE support by DJA}
    {$ifdef DataAware}
        fpSxSelect       : function (iBaseArea : Integer) : Integer;
    {$endif}
{$endif}

        procedure IdleOn( liTimes: LongInt );
        procedure IdleOff;
{$ifdef DataAware}
        procedure SaveAsBlob( ABlobField : TBlobField );
        procedure LoadAsBlob( AField : TField );

        procedure SaveToStream( ABlobField : TBlobField; liFormat, liCompress: Longint );
        procedure LoadFromStream( AField : TField );
        function CheckFieldForBlob( AField: TField ): Boolean;
    {$ifdef SDE}
        procedure SaveAsMemo( AMemoField : TMemoField );
        procedure LoadAsMemo;
    {$endif}
{$endif}
        function GetLZWLicensed : Boolean;
        function GetPixel( x, y : Longint ): TColor;
        procedure SetPixel( x, y : Longint; AColor : TColor );
        function GetBackGroundColor : TColor;
        procedure SetBackGroundColor( AColor : TColor );
        function GetInternalImage : Longint; { !! only for internal use !!}
        function GetDefaultImageSize : Integer;

        function GetDrawPen: TPen;
        procedure SetDrawPen( Value: TPen );
        function GetDrawBrush: TBrush;
        procedure SetDrawBrush( Value: TBrush );
        function GetDrawFont: TFont;
        procedure SetDrawFont( Value: TFont );
    public
        iCurrentX        : Integer;
        iCurrentY        : Integer;
        lOriLoaded       : Boolean;
        lDisLoaded       : Boolean;
        fScaleX          : Real;  { Export because this should be }
        fScaleY          : Real;  { used in the ImageIdle function }

        lPaletteShared   : Boolean;

        function GetAsBitmap : HBitmap;
        procedure SetAsBitmap( BitmapHandle: HBitmap);
        procedure PasteBitmapAt( Position: TPoint; BitmapHandle: HBitmap );
        procedure PasteAt( Position: TPoint; pImage: Longint );
        function CopyAsBitmapAt( Rect: TRect ): HBitmap;
        function CopyAt( Rect: TRect ): Longint;
        function Bits    : Integer;
        procedure SwapSharedExclusive;
        procedure Clear;
        procedure ColorOperations( liColors : Longint; ADithering, GrayScale : Boolean );
        procedure SaveAs( FileName: String; liFileFormat, liCompress: LongInt );
        procedure PrintByDialog( oStart, oEnd : TPoint );
        procedure Print( SourceRect, DestRect : TRect; pHandle : HDC; AFitStyle: TFitStyle );
        procedure Resize( NewWidth, NewHeight : Longint ); 
        procedure Crop( oStart, oEnd : TPoint );
        procedure Grab( liScreenGrabMode : LongInt );
        function OriWidth   : LongInt;
        function OriHeight  : LongInt;
        function DisWidth   : LongInt;
        function DisHeight  : LongInt;
        function Colors     : LongInt;
        function Density    : LongInt;
        procedure Display( EraseGround : Boolean );
        constructor Create( AOwner: TComponent ); override;
        destructor Destroy; override;
        procedure Scan( cFileName : TFileName );
        function ScanSilent( cFileName : TFileName ): Boolean;
        procedure Fit( iFitMode: Integer );
        procedure FitInWindow;
        procedure FitBest;
        procedure FitRelease;
        procedure FitRescale;
        procedure FitToHeight;
        procedure FitToWidth;
        procedure Flip( bHorz : Boolean );
        procedure LoadFile( FileName: TFileName;
                        Format: LongInt;{$ifdef DataAware} AField : TField; {$endif}
                        ExtraParam: Longint );
        procedure MemoryImage( liWidth, liHeight, liColor, liMemoryModel: LongInt );
        procedure MemoryImage16( iWidth, iHeight, liColor:LongInt);
        procedure MemoryImage16M( iWidth, iHeight, liColor: LongInt);
        procedure MemoryImage256( iWidth, iHeight, liColor: LongInt );
        procedure MemoryImageBW( iWidth, iHeight, liColor: LongInt );
        procedure Rotate( iTurnAngle: Integer; ClipCorner : Boolean );
        procedure Zoom( fZoomFactorX, fZoomFactorY: Real );
        procedure CopyToClipboard( oStart, oEnd : TPoint );
        procedure PasteFromClipboardNew;
        procedure MakeStamp( AWidth, AHeight : Longint; var liStamp : Longint );
        procedure LoadFromStamp( liStamp : Longint );
        procedure Filter( AFilter, Factor1, Factor2, Factor3 : Longint;
                          Red, Green, Blue : Boolean );
        function GetInternalZoomX: Double;
        function GetInternalZoomY: Double;

        procedure DrawRectangle( x1, y1, x2, y2: Integer );
        procedure DrawRoundRect( X1, Y1, X2, Y2, X3, Y3: Integer );
        procedure DrawLine( x1, y1, x2, y2: Integer );
        procedure DrawArc(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);
        procedure DrawEllipse( x1, y1, x2, y2: Integer ); 
        procedure DrawTextOut(X, Y: Integer; const Text: string);
        property GaugeVisible: Boolean read lGaugeVisible write lGaugeVisible;
        property LZWLicensed : Boolean read GetLZWLicensed;
        property Pixels[X, Y: Longint]: TColor read GetPixel write SetPixel;
        property BackGroundColor : TColor read GetBackGroundColor write SetBackGroundColor;
        property InternalImage : Longint read GetInternalImage ;
        property DefaultImageSize : Integer read GetDefaultImageSize;
        property AsBitmap : HBitmap read GetAsBitmap write SetAsBitmap;
        property DrawPen: TPen read GetDrawPen write SetDrawPen;
        property DrawBrush: TBrush read GetDrawBrush write SetDrawBrush;
        property DrawFont: TFont read GetDrawFont write SetDrawFont;
    published
end;

{******************************************************************************
  TImageWindow class:
       This class is the owner of an ImageInWindow class instance
 ******************************************************************************}

TImageType = ( itAuto, itBitmap, itGif, itJpeg, itPcx, itPing, itTarga, itTiff );
TDatabaseEngineType = ( detSDE, detBDE );

{$ifdef DataAware}
TBlobCompression = (
                     bcNone,      { storing uncompressed blob }
                     bcSize,      { storing size optimized compressed blob }
                     bcSpeed,     { storing speed optimized compressed blob }
                     bcStream     { No blobbing, but native image format streaming }
                   );
{$endif}
const
    crMagnifyPlus  = 5;
    crMagnifyMinus = 6;
    crScroll       = 7;

type
TImageWindow = Class;

TPostLoadEvent = procedure( AImageWindow : TImageWindow ) of Object;
TSaveStreamEvent = procedure( AImageWindow : TImageWindow; var Format, Compression: Longint ) of Object;


TImageWindow = class( TLightLibBase )
    private
        FTwain            : TLLTwain;
        FZoomFactor       : Double;
        FFitStyle         : TFitStyle;
        FPostLoadEvent    : TPostLoadEvent;
        FSaveStreamEvent  : TSaveStreamEvent;
        FDefaultImageSize : Integer;
        FCurrentImageOperation : String;
        FBackGroundColor : TColor;
        FImageType       : TImageType;
        FToolBarHints    : TStringList;
        FToolBarShowHint : Boolean;
        FZoomIncrement   : integer; { percentage }
        FSelectionColor  : TColor;
        FSelectionStyle  : TPenStyle;
        FSelectionWidth  : Byte;
        FSelectionEnabled: Boolean;
{$ifdef DataAware}
        FBlobCompression : TBlobCompression;
        FDatabaseEngineType : TDatabaseEngineType;
{$endif}
        FFileFormat      : Longint;
        OldX, OldY       : Integer; { used for selection with left mbutton }
        FMouseOldX       : Integer; { used for scrolling with right mbutton }
        FMouseOldY       : Integer; { used for scrolling with right mbutton }
        FScrollOldX      : Integer; { used for scrolling with right mbutton }
        FScrollOldY      : Integer; { used for scrolling with right mbutton }
{$ifdef DataAware}
        FDataLink        : TFieldDataLink;
{$endif}
        FImageName       : TImageName;
        FImagePath       : TFileName;
        FVertScroll      : Boolean;
        FHorzScroll      : Boolean;
        FGauge           : Boolean;
        FToolBar         : Boolean;
        FCanvasArea      : TImageDimension;
        FAcceptUpdate    : Boolean;
        FLButtonDown     : Boolean;
        FRButtonDown     : Boolean;
        FCaptureRect     : TRect;
        FCaptureIsVisible : Boolean;
        FVisibleInfo     : TButtonInfo;
        FImageInWindow   : TImageInWindow;
        procedure SetVisible( Value: TButtonInfo );
        function GetVisible : TButtonInfo;
        procedure SetToolBarHints(Value: TStringList);
        procedure SetZoomIncrement( Value : integer );
{$ifdef DataAware}
        procedure DataChange(Sender: TObject);
{$endif}
    protected
        FoLeftBtn,
        FoRightBtn       : TSpeedButton; { toolbar shifter }
        FoGauge          : TGauge;
        FoToolBar        : TImageToolBar;
        FoHorzScroll     : TScrollBar;
        FoVertScroll     : TScrollBar;
        destructor Destroy; override;
        constructor Create( AOwner: TComponent ); override;
        procedure CreateToolbar;
        procedure DestroyToolbar;
        procedure Loaded; override;
        procedure SetImageName( Value: TImageName );
        procedure SetImagePath( Value: TFileName );
        procedure SetToolbar( Value: Boolean );
        procedure SetGauge( Value: Boolean );
        procedure SetVScroll( Value: Boolean );
        procedure SetHScroll( Value: Boolean );
        procedure MouseDown( mButton :TMouseButton; Shift:TShiftState; X, Y:Integer ); override;
        procedure MouseMove( Shift:TShiftState; X, Y:Integer ); override;
        procedure MouseUp( tButton :TMouseButton; Shift:TShiftState; X, Y:Integer ); override;
{$ifdef DataAware}
        function  GetDataSource: TDataSource;
        procedure SetDataSource( Value: TDataSource );
        procedure SetDataField(const Value: string);
        function  GetDataField: String;
{$endif}
        procedure WMSize( var Message: TWMSize ); message WM_SIZE;
        procedure ScrollRefresh( Sender : TObject );
        procedure ScrollToolBarLeft( Sender : TObject );
        procedure ScrollToolBarRight( Sender : TObject );
        procedure SetToolbarShowHint( Value : Boolean );
        procedure SetCaptureRect( ARect : TRect );
        function GetBackGroundColor : TColor;
        procedure SetBackGroundColor( AColor : TColor );
        function GetDefaultImageSize : Integer;
        procedure SetDefaultImageSize( Value : Integer );
        function GetFitStyle: TFitStyle;
        procedure SetFitStyle( Value: TFitStyle );
        function GetZoomFactor: Double;
        procedure SetZoomFactor( Value: Double );
        function GetTiffPageIndex( ImgName: String ): Longint;
        function GetTwain: TLLTwain;
    public
        procedure LoadFile( FileName: TFileName; Format: Longint; ExtraParam: Longint );
        procedure ImageOperations;
        procedure SaveAs;
        procedure Information;
        procedure Print;
        procedure Crop;
        procedure GrabClientArea;
        procedure GrabWindow;
        procedure GrabDeskTop;
        procedure Paint; override;
        procedure Scan;
        function ScanSilent: Boolean;
        procedure ScanAndSave;
        procedure Open;
        procedure FlipHorizontal;
        procedure FlipVertical;
        procedure FitBest;
        procedure FitInWindow;
        procedure FitRelease;
        procedure FitToHeight;
        procedure FitToWidth;
        procedure RotateLeft;
        procedure RotateRight;
        procedure RotateInvert;
        procedure ZoomInByIncrement;
        procedure ZoomOutByIncrement;
        procedure Zoom10In;
        procedure Zoom10Out;
        procedure Zoom25In;
        procedure Zoom25Out;
        procedure SwapSharedExclusive;
        procedure CopyToClipboard;
        procedure PasteFromClipboardNew;

        property AcceptUpdate : Boolean read FAcceptUpdate write FAcceptUpdate;
        property ImageInWindow : TImageInWindow read FImageInWindow;
        property Canvas;
        property MouseCapture;
        property CaptureRect : TRect read FCaptureRect write SetCaptureRect;
        property HorzScroll: TScrollBar read FoHorzScroll;
        property VertScroll: TScrollBar read FoVertScroll;
        property Twain: TLLTwain read GetTwain;
        property CaptureIsVisible : Boolean read FCaptureIsVisible;
   published
        property Align;
        property PopupMenu;
        property Visible;
        property OnClick;
        property OnDblClick;
        property OnDragDrop;
        property OnDragOver;
        property OnEndDrag;
        property OnMouseDown;
        property OnMouseMove;
        property OnMouseUp;
        property ImageType : TImageType read FImageType write FImageType;
{$ifdef DataAware}
        property BlobCompression : TBlobCompression read FBlobCompression write FBlobCompression;
        property DatabaseEngineType : TDatabaseEngineType read FDatabaseEngineType write FDatabaseEngineType;
        property DataField: string read GetDataField write SetDataField;
        property DataSource: TDataSource read GetDataSource write SetDataSource;
{$endif}
        property ImageName: TImageName read FImageName write SetImageName;
        property ImagePath: TFileName read FImagePath write SetImagePath;
        property ShowHorzScroll: Boolean read FHorzScroll write SetHScroll default True;
        property ShowVertScroll: Boolean read FVertScroll write SetVScroll default True;
        property ShowGauge: Boolean read FGauge write SetGauge default True;
        property ShowToolbar: Boolean read FToolbar write SetToolBar default True;
        property ToolBarSetup : TButtonInfo read GetVisible write SetVisible default $FFFFFFFF;
        property ToolBarHints : TStringList read FToolBarHints write SetToolBarHints;
        property ToolBarShowHint : Boolean read FToolBarShowHint write SetToolBarShowHint;
        property ZoomIncrement : Integer read FZoomIncrement write SetZoomIncrement;
        property SelectionColor : TColor read FSelectionColor write FSelectionColor;
        property SelectionWidth : Byte read FSelectionWidth write FSelectionWidth;
        property SelectionStyle : TPenStyle read FSelectionStyle write FSelectionStyle;
        property SelectionEnabled : Boolean read FSelectionEnabled write FSelectionEnabled;
        property BackGroundColor : TColor read GetBackGroundColor write SetBackGroundColor;
        property DefaultImageSize : Integer read GetDefaultImageSize write SetDefaultImageSize;
        property OnPostLoad: TPostLoadEvent read FPostLoadEvent write FPostLoadEvent;
        property OnSaveStream: TSaveStreamEvent read FSaveStreamEvent write FSaveStreamEvent;
        property FitStyle: TFitStyle read GetFitStyle write SetFitStyle;
        property ZoomFactor: Double read GetZoomFactor write SetZoomFactor;
    end;

{******************************************************************************}

procedure Register;
function LLGetCanvasArea( LLWindow: TImageWindow ): TImageDimension;
function LLSetCanvasArea( LLWindow: TImageWindow ): TImageDimension;
function LLSetControlSizes( LLWindow: TImageWindow ): TImageDimension;
function lImgOperationComplex( liLLImage, liCaller, liDevice, liFormat: LongInt ): Boolean;

{$ifdef Win32}
    function ImageIdle( liState, liValue, liLLImage, liCaller, liDevice,
                        liFormat, liUserParam: LongInt ): LongInt; export; stdcall;
{$else}
    function ImageIdle( liState, liValue, liLLImage, liCaller, liDevice,
                        liFormat, liUserParam: LongInt ): LongInt; export;
{$endif}



{******************************************************************************}
implementation
{******************************************************************************}

uses
    iImgOp,{ Image Operations Dialog Class }
    iMultTif;

{ include resource files
  depending on system }

{$ifdef Win32}
    {$R LLI.R32}
    function  iGet;     stdcall; external 'LLI32.DLL';
    function  iPut;     stdcall; external 'LLI32.DLL';
    function  iCopy;    stdcall; external 'LLI32.DLL';
    function  iDLLLoad; stdcall; external 'LLI32.DLL';
{$else}
    {$R LLI.R16}
    function  iGet;     external 'LLI16';
    function  iPut;     external 'LLI16';
    function  iCopy;    external 'LLI16';
    function  iDLLLoad; external 'LLI16';
{$endif}


{ variables and constants (local to this LLI.PAS unit) }
var
    IdleParent  : TImageWindow;
    IdleChild   : TImageInWindow;
    lFirstCycle : Boolean;
    lNeedGauge  : Boolean;
    liMaxCall   : LongInt;

    BlobStreamCount: Byte;
    BlobStreamTable: Array[0..255] of Longint;

{******************************************************************************}
{*                    TImageWindow class implementation                       *}
{******************************************************************************}


procedure TImageWindow.SetVisible( Value: TButtonInfo );
begin
    FVisibleInfo := Value;
    if FToolbar then
    begin
        FoToolBar.SetVisible( FVisibleInfo );
        FoToolBar.SetButtonHints( FToolBarHints );
    end;
end;

{******************************************************************************}

function TImageWindow.GetVisible : TButtonInfo ;
begin
    if FToolbar then
        FVisibleInfo := FoToolBar.GetVisible ;
    Result := FVisibleInfo;
end;

{******************************************************************************}

procedure TImageWindow.SetToolBarHints(Value: TStringList);
begin
    FToolBarHints.Assign( Value );
end;

{******************************************************************************}

constructor TImageWindow.Create( AOwner: TComponent );
Var
    i       : TLLToolBtns;
begin
    inherited Create( AOwner );

    FDefaultImageSize := 0;
    FZoomFactor       := 1.0;
    FFitStyle         := fsNone;

    FCurrentImageOperation := 'Information';

    ControlStyle := ControlStyle + [csFramed];

    FBackGroundColor := clBtnFace;

    Width   := 150;
    Height  := 130;

    FToolBarHints  := TStringList.Create;
    for i := low( BtnHintText ) to high( BtnHintText ) do
        FToolBarHints.Add( BtnHintText[i] );
    FToolBarHints.Add( 'No Function' );

    FToolBarShowHint := True;
    FZoomIncrement   := 10; { percent }

    FSelectionWidth  := 1;
    FSelectionStyle  := psSolid;
    FSelectionColor  := clBlack;
    FSelectionEnabled:= True;

    FAcceptUpdate  := True;
    FFileFormat    := LLI_DISK_AUTO;

    { Create an ImageInWindow object and load/scan an image }

    FTwain := Nil;

    FImageInWindow := TImageInWindow.Create( Self );

    FHorzScroll    := True;
    FVertScroll    := True;
    FGauge         := True;
    FToolbar       := True;

    FoHorzScroll             := TScrollBar.Create(Self);
    FoHorzScroll.Parent      := Self;
    FoHorzScroll.Position    := 0;
    FoHorzScroll.Kind        := sbHorizontal;
    FoHorzScroll.Min         := 0;
    FoHorzScroll.Max         := 100;
    FoHorzScroll.LargeChange := 10;
    FoHorzScroll.SmallChange := 1;
    FoHorzScroll.Visible     := FHorzScroll;
    FoHorzScroll.OnChange    := ScrollRefresh;
    FoHorzScroll.Ctl3d       := False;

    FoVertScroll             := TScrollBar.Create(Self);
    FoVertScroll.Parent      := Self;
    FoVertScroll.Position    := 0;
    FoVertScroll.Kind        := sbVertical;
    FoVertScroll.Min         := 0;
    FoVertScroll.Max         := 100;
    FoVertScroll.LargeChange := 10;
    FoVertScroll.SmallChange := 1;
    FoVertScroll.Visible     := FVertScroll;
    FoVertScroll.OnChange    := ScrollRefresh;
    FoVertScroll.Ctl3d       := False;

    FoRightBtn := nil;
    FoLeftBtn  := nil;
    FoToolbar  := nil;

    CreateToolbar;

    FoGauge                  := TGauge.Create(Self);
    FoGauge.Parent           := Self;
    FoGauge.Progress         := 0;
    FoGauge.Kind             := gkVerticalBar;
    FoGauge.ForeColor        := clRed;
    FoGauge.Visible          := FGauge;
    FoGauge.ShowText         := False;
    FoGauge.Width            := FoVertScroll.Width;

    ImageInWindow.GaugeVisible := FGauge;

{$ifdef DataAware}
    FDataLink                := TFieldDataLink.Create;
    FDataLink.Control        := Self;
    FDataLink.OnDataChange   := DataChange;

    FDatabaseEngineType      := detBDE;
{$endif}

    Screen.Cursors[crMagnifyPlus]  := LoadCursor(HInstance, 'CR_MAGNIFY_PLUS');
    Screen.Cursors[crMagnifyMinus] := LoadCursor(HInstance, 'CR_MAGNIFY_MINUS');
    Screen.Cursors[crScroll]       := LoadCursor(HInstance, 'CR_SCROLL');
end;

{******************************************************************************}

destructor TImageWindow.Destroy;
begin
{$ifdef DataAware}
    fDataLink.Free;
{$endif}
    ImageInWindow.Clear;

    DestroyToolbar;

    if ( FTwain <> Nil ) then
        FTwain.Free;

    inherited Destroy;
end;

{******************************************************************************}

procedure TImageWindow.CreateToolbar;
Var
    ResName : Array[0..40] of char;
begin

    if FoToolbar = nil  then
    begin

        FoToolbar                := TImageToolBar.Create(Self) ;
        FoToolbar.Parent         := Self;
        FoToolbar.Visible        := FToolbar;
        FoToolbar.ParentCtl3d    := False;
        FoToolbar.Ctl3d          := False;
        FoToolbar.Width          := Self.Width - 38;

    end;

    if FoLeftBtn = nil  then
    begin
        FoLeftBtn := TSpeedButton.Create( Self );
        with FoLeftBtn do
        begin
            Visible      := True;
            Enabled      := True;
            Glyph.Handle := LoadBitmap( HInstance, StrPCopy( ResName, 'IB_LEFTBTN' ) );
            NumGlyphs    := 1;
            ShowHint     := FToolBarShowHint;
            Hint         := '';
            Top          := 1;
            Left         := 1;
            Height       := 28;
            Width        := 18;
            OnClick      := ScrollToolBarLeft;
            Parent       := Self;
        end;
    end;

    if FoRightBtn = nil  then
    begin
        FoRightBtn := TSpeedButton.Create( Self );
        with FoRightBtn do
        begin
            Visible      := True;
            Enabled      := True;
            Glyph.Handle := LoadBitmap( HInstance, StrPCopy( ResName, 'IB_RIGHTBTN' ) );
            NumGlyphs    := 1;
            ShowHint     := FToolBarShowHint;
            Hint         := '';
            Top          := 1;
            Left         := Self.Width-19;
            Height       := 28;
            Width        := 18;
            OnClick      := ScrollToolBarRight;
            Parent       := Self;
        end;
    end;

    if ( FoToolBar.Width >= FoToolBar.GetButtonLength ) then
    begin
        FoToolBar.SetFiller( True );
        FoLeftBtn.Enabled := False;
        FoRightBtn.Enabled := False;
    end;

end;

{******************************************************************************}

procedure TImageWindow.DestroyToolbar;
begin

    if Assigned( FoRightBtn ) then
    begin
        FoRightBtn.Destroy;
        FoRightBtn := nil;
    end;

    if Assigned( FoLeftBtn ) then
    begin
        FoLeftBtn.Destroy;
        FoLeftBtn := nil;
    end;

    if Assigned( FoToolbar ) then
    begin
        FVisibleInfo := FoToolBar.GetVisible;
        FoToolbar.Destroy;
        FoToolbar := nil;
    end;

end;

{******************************************************************************}

procedure TImageWindow.ScrollToolBarLeft( Sender : TObject );
begin
    if not FToolbar then exit;

    if ( FoToolBar.Scroll( 28 ) ) then
        FoRightBtn.Enabled := True
    else
        FoLeftBtn.Enabled := False;
end;

{******************************************************************************}

procedure TImageWindow.ScrollToolBarRight( Sender : TObject );
begin
    if not FToolbar then exit;

    if ( FoToolBar.Scroll( -28 ) ) then
        FoLeftBtn.Enabled := True
    else
        FoRightBtn.Enabled := False;
end;

{******************************************************************************}

procedure TImageWindow.SetToolbarShowHint( Value : Boolean );
begin
    if not FToolbar then exit;

    FToolBarShowHint    := Value;
    FoToolBar.SetShowHints( Value );
    FoRightBtn.ShowHint := Value;
    FoLeftBtn.ShowHint  := Value;
end;

{******************************************************************************}

procedure TImageWindow.SetCaptureRect( ARect : TRect );
begin

    if ( not SelectionEnabled ) then
    begin
        FCaptureIsVisible := True;
        FCaptureRect     := ARect;
    end;

end;

{******************************************************************************}

function TImageWindow.GetBackGroundColor : TColor;
begin
    Result := FBackGroundColor;
end;

{******************************************************************************}

procedure TImageWindow.SetBackGroundColor( AColor : TColor );
begin
    FBackGroundColor := AColor;
    ImageInWindow.SetBackGroundColor( AColor );
    Invalidate;
end;

{******************************************************************************}

function TImageWindow.GetDefaultImageSize : Integer;
begin
    Result := FDefaultImageSize;
end;

{******************************************************************************}

procedure TImageWindow.SetDefaultImageSize( Value : Integer );
begin
    Value := Abs( Value );
    if ( Value > 1000 ) then Value := 1000;
    FDefaultImageSize := Value;

    if ( ImageInWindow <> nil ) then with ImageInWindow do
    begin
        Clear;
        MemoryImage( 0, 0, 0, 0 );
        Display( True );
    end;
end;

{******************************************************************************}

function TImageWindow.GetFitStyle: TFitStyle;
begin
    Result := FFitStyle;
end;

{******************************************************************************}

procedure TImageWindow.SetFitStyle( Value: TFitStyle );
begin
    FFitStyle := Value;
    ImageInWindow.Display( True );
    FZoomFactor := ImageInWindow.GetInternalZoomX;
end;

{******************************************************************************}

function TImageWindow.GetZoomFactor: Double;
begin
    Result := FZoomFactor;
end;

{******************************************************************************}

procedure TImageWindow.SetZoomFactor( Value: Double );
begin
    FFitStyle := fsNone;

    if ( Value > -0.001 )and
       ( Value < 0.001 ) then
        FZoomFactor := 0.001
    else
        FZoomFactor := Value;

    ImageInWindow.Display( True );
end;

{******************************************************************************}

procedure TImageWindow.SetZoomIncrement( Value : integer );
begin
    { only accept values from 0 to 99 }
    FZoomIncrement := Max( Min( 99, Value ), 0 );
end;

{******************************************************************************}

procedure TImageWindow.FlipHorizontal;
begin
    ImageInWindow.Flip( True );
    ImageInWindow.Display( True );
end;

{******************************************************************************}

procedure TImageWindow.FlipVertical;
begin
    ImageInWindow.Flip( False );
    ImageInWindow.Display( True );
end;

{******************************************************************************}


procedure TImageWindow.WMSize( var Message: TWMSize );
begin
    inherited;
    if ( Width < 60 ) then Width := 60;
    if ( Height < 60 ) then Height := 60;

    FCanvasArea := LLSetControlSizes( Self );

    if FToolbar then
    begin

        FoToolBar.SetFiller( True );

        if ( FoToolBar.Width > FoToolBar.GetButtonLength ) then
        begin
            FoLeftBtn.Enabled := False;
            FoRightBtn.Enabled := False;
        end
        else
        begin
            FoLeftBtn.Enabled := True;
            FoRightBtn.Enabled := True;
        end;
    end;
end;

{******************************************************************************}

{$ifdef DataAware}

function TImageWindow.GetDataSource: TDataSource;
begin
    Result := FDataLink.DataSource;
end;

{******************************************************************************}

procedure TImageWindow.SetDataSource( Value: TDataSource );
begin
    FDataLink.DataSource := Value;
end;

{******************************************************************************}

procedure TImageWindow.DataChange( Sender: TObject );
var
    sImageName: String;
begin

    if not ( AcceptUpdate ) then exit;

    if ( DataSource <> nil ) then
        if ( DataSource.DataSet <> nil ) then
            if ( DataSource.DataSet.Active ) then
                if ( DataField <> '' ) then
                begin

{$ifdef Win32}
                    if ( DataSource.Dataset.FieldByName( GetDataField ).DataType in [ftBlob..ftTypedBinary] ) then
{$else}
                    if ( DataSource.Dataset.FieldByName( GetDataField ).DataType in [ftBlob] ) then
{$endif}
                    begin

                        { try to load the image from a TBlobField }
                        ImageInWindow.LoadFile( '', 0, TBlobField( DataSource.Dataset.FieldByName( DataField ) ),0 );
                        if Assigned( FPostLoadEvent ) then FPostLoadEvent( Self );
                        ImageInWindow.Display( True );
                    end
                    else if ( DataSource.Dataset.FieldByName( GetDataField ).DataType in [ftMemo] ) then
                    begin

{$ifdef SDE}
                        { try to load the image from a TMemoField  with SDE }
                        ImageInWindow.LoadFile( '', 0, TMemoField( DataSource.Dataset.FieldByName( DataField ) ),0 );
                        if Assigned( FPostLoadEvent ) then FPostLoadEvent( Self );
                        ImageInWindow.Display( True );
{$endif}

                    end
                    else
                    begin

                        sImageName := DataSource.Dataset.FieldByName( DataField ).AsString;

                        if ( FImagePath <> '' ) then
                            if FileExists( FImagePath + '\' + sImageName ) then
                                ImageName := sImageName
                        else

                            if FileExists( sImageName ) then
                                ImageName := sImageName;
                    end;

                end;

end;

{******************************************************************************}

function TImageWindow.GetDataField: string;
begin
    Result := FDataLink.FieldName;
end;

{******************************************************************************}

procedure TImageWindow.SetDataField(const Value: string);
begin
    FDataLink.FieldName := Value;
end;

{$endif}

{******************************************************************************}

procedure TImageWindow.Loaded;
begin
    inherited Loaded;

{    ImageName := FImageName;}

    if FToolbar then
        FoToolBar.SetButtonHints( FToolBarHints )
    else
        DestroyToolbar;

end;

{******************************************************************************}

procedure TImageWindow.ImageOperations;
Var
   DlgImageOperations : TDlgImageOperations;
begin

    DlgImageOperations := TDlgImageOperations.Create( Self );
    try
        DlgImageOperations.Init( ImageInWindow );
        DlgImageOperations.Page := FCurrentImageOperation;

        DlgImageOperations.ShowModal;

        FCurrentImageOperation := DlgImageOperations.Page;

    finally
        DlgImageOperations.Free;
    end;

end;

{******************************************************************************}

procedure TImageWindow.SaveAs;
var
    oDialog  : TSaveDialog;
    FileName : TFileName;
    iBitsInImage : Longint;
    FCompression : Longint;
    Extension    : String[5];

    function AskForQuality : Longint;
    Var
        QualityDlg : TQualityDlg;
    begin
        Result := 65;
        QualityDlg := TQualityDlg.Create( Application );
        try
            if ( QualityDlg.ShowModal = 1 ) then
                Result := QualityDlg.SpinEdit1.Value;
        finally
            QualityDlg.Free;
        end;
    end;

    function AskForCompression : Longint;
    Var
        CompressionDlg : TCompressionDlg;
    const
        Compr : Array[0..5] of Longint = ( LLI_DISK_COMPRESS_NIL,
                                           LLI_DISK_COMPRESS_LZW,
                                           LLI_DISK_COMPRESS_PCKBIT,
                                           LLI_DISK_COMPRESS_CCITT1D,
                                           LLI_DISK_COMPRESS_CCITTG3,
                                           LLI_DISK_COMPRESS_CCITTG4
                                          );
    begin
        Result := 0;
        CompressionDlg := TCompressionDlg.Create( Application );
        try
            CompressionDlg.cbCompression.Items.Add('TIFF UnCompressed');
            CompressionDlg.cbCompression.Items.Add('TIFF LZW');
            CompressionDlg.cbCompression.Items.Add('TIFF Packed');

            CompressionDlg.cbCompression.ItemIndex := 0;

            if ( iBitsInImage = 1 ) then
            begin
                CompressionDlg.cbCompression.Items.Add('TIFF CCITT 1D Huffmman');
                CompressionDlg.cbCompression.Items.Add('TIFF CCITT 3G');
                CompressionDlg.cbCompression.Items.Add('TIFF CCITT 4G');
                if ( ImageInWindow.LZWLicensed ) then
                    CompressionDlg.cbCompression.ItemIndex := 5
                else
                    CompressionDlg.cbCompression.ItemIndex := 4;
            end;

            if ( CompressionDlg.ShowModal = 1 ) then
            begin
                if ( CompressionDlg.cbCompression.ItemIndex <> -1) then
                    Result := Compr[CompressionDlg.cbCompression.ItemIndex];
            end;
        finally
            CompressionDlg.Free;
        end;
    end;

begin
    iBitsInImage := ImageInWindow.Bits;

{$ifdef DataAware}

    if ( DataSource <> nil ) then
    begin
        if ( DataSource.Dataset <> nil ) then
            if ( DataField <> '' ) then
                if ( DataSource.Dataset.FieldByName( DataField ) is TBlobField ) then
                begin
                    { save to a database ( either native image formats or blobs ) }
                    FFileFormat  := LLI_DISK_BMP;
                    FCompression := LLI_DISK_COMPRESS_AUTO;
                    if Assigned( FSaveStreamEvent ) then FSaveStreamEvent( Self, FFileFormat, FCompression );
                    ImageInWindow.SaveAs( '', FFileFormat, FCompression );
                    exit;
                end;
    end;

{$endif}

    oDialog := TSaveDialog.Create( self );

    if ( ImageType in [itAuto] ) then
    begin
        if ( iBitsInImage = 1 ) then
        begin
            oDialog.Filter := 'Bitmap פאיכû (*.BMP)|*.BMP|' +
                              'GIF  פאיכû (*.GIF)|*.GIF|' +
                              'PCX  פאיכû (*.PCX)|*.PCX|' +
                              'Ping  פאיכû (*.PNG)|*.PNG|' +
                              'Targa  פאיכû (*.TGA)|*.TGA|' +
                              'Tiff  פאיכû (*.TIF)|*.TIF|';
        end
        else if ( iBitsInImage = 4 ) then with oDialog do
        begin
            oDialog.Filter := 'Bitmap  פאיכû (*.BMP)|*.BMP|' +
                              'GIF  פאיכû (*.GIF)|*.GIF|' +
                              'JPEG  פאיכû (*.JPG)|*.JPG|' +
                              'PCX  פאיכû (*.PCX)|*.PCX|' +
                              'Ping  פאיכû (*.PNG)|*.PNG|' +
                              'Targa  פאיכû (*.TGA)|*.TGA|' +
                              'Tiff  פאיכû (*.TIF)|*.TIF|';
        end
        else if ( iBitsInImage = 8 ) then with oDialog do
        begin
            oDialog.Filter := 'Bitmap  פאיכû (*.BMP)|*.BMP|' +
                              'GIF  פאיכû (*.GIF)|*.GIF|' +
                              'JPEG  פאיכû (*.JPG)|*.JPG|' +
                              'PCX  פאיכû (*.PCX)|*.PCX|' +
                              'Ping  פאיכû (*.PNG)|*.PNG|' +
                              'Targa  פאיכû (*.TGA)|*.TGA|' +
                              'Tiff  פאיכû (*.TIF)|*.TIF|';
        end
        else if ( iBitsInImage = 24 ) then with oDialog do
        begin
            oDialog.Filter := 'Bitmap  פאיכû (*.BMP)|*.BMP|' +
                              'JPEG  פאיכû (*.JPG)|*.JPG|' +
                              'Ping  פאיכû (*.PNG)|*.PNG|' +
                              'Targa  פאיכû (*.TGA)|*.TGA|' +
                              'Tiff  פאיכû (*.TIF)|*.TIF|';
        end;

        if oDialog.Execute then
        begin
            FCompression := LLI_DISK_COMPRESS_AUTO;
            Extension := UpperCase( Copy( oDialog.FileName, Length(oDialog.FileName)-3, 4 ) );

            if ( Extension = '.BMP' ) then
            begin
                FFileFormat    := LLI_DISK_BMP;
                FCompression   := LLI_DISK_COMPRESS_AUTO;
            end
            else if ( Extension = '.GIF' ) then
            begin
                FFileFormat    := LLI_DISK_GIF;
                FCompression   := LLI_DISK_COMPRESS_AUTO;
            end
            else if ( Extension = '.JPG' ) then
            begin
                FFileFormat    := LLI_DISK_JPG;
                FCompression   := AskForQuality;
            end
            else if ( Extension = '.PCX' ) then
            begin
                FFileFormat    := LLI_DISK_PCX;
                FCompression   := LLI_DISK_COMPRESS_AUTO;
            end
            else if ( Extension = '.PNG' ) then
            begin
                FFileFormat    := LLI_DISK_PNG;
                FCompression   := LLI_DISK_COMPRESS_AUTO;
            end
            else if ( Extension = '.TGA' ) then
            begin
                FFileFormat    := LLI_DISK_TGA;
                FCompression   := LLI_DISK_COMPRESS_AUTO;
            end
            else if ( Extension = '.TIF' ) then
            begin
                FFileFormat    := LLI_DISK_TIF;
                FCompression   := AskForCompression;
            end;

            if ( ImagePath <> '' ) then
                ImagePath := '';
            ImageInWindow.SaveAs( oDialog.FileName, FFileFormat, FCompression );
            FImagePath := '';
            FImageName := oDialog.FileName;
        end;

    end
    else
    begin

        if ( ImageType in [itBitmap] ) then
        begin
            FFileFormat    := LLI_DISK_BMP;
            FCompression   := LLI_DISK_COMPRESS_AUTO;
            oDialog.Filter := 'Bitmap  פאיכû (*.BMP)|*.BMP|';
        end
        else if ( ImageType in [itGif] ) then
        begin
            FFileFormat    := LLI_DISK_GIF;
            FCompression   := LLI_DISK_COMPRESS_AUTO;
            oDialog.Filter := 'GIF  פאיכû (*.GIF)|*.GIF|';
        end
        else if ( ImageType in [itJpeg] ) then
        begin
            FFileFormat    := LLI_DISK_JPG;
            FCompression   := LLI_DISK_COMPRESS_AUTO;
            oDialog.Filter := 'JPEG  פאיכû (*.JPG)|*.JPG|';
        end
        else if ( ImageType in [itPcx] ) then
        begin
            FFileFormat    := LLI_DISK_PCX;
            FCompression   := LLI_DISK_COMPRESS_AUTO;
            oDialog.Filter := 'PCX  פאיכû (*.PCX)|*.PCX|';
        end
        else if ( ImageType in [itPing] ) then
        begin
            FFileFormat    := LLI_DISK_PNG;
            FCompression   := LLI_DISK_COMPRESS_AUTO;
            oDialog.Filter := 'Ping  פאיכû (*.PNG)|*.PNG|';
        end
        else if ( ImageType in [itTarga] ) then
        begin
            FFileFormat        := LLI_DISK_TGA;
            FCompression   := LLI_DISK_COMPRESS_AUTO;
            oDialog.Filter := 'Targa  פאיכû (*.TGA)|*.TGA|';
        end
        else if ( ImageType in [itTiff] ) then
        begin
            FFileFormat    := LLI_DISK_TIF;
            FCompression   := LLI_DISK_COMPRESS_AUTO;
            oDialog.Filter := 'Tiff  פאיכû (*.TIF)|*.TIF|';
        end;

        if oDialog.Execute then
        begin

            if ( ImagePath <> '' ) then
                ImagePath := '';

            if ( FFileFormat = LLI_DISK_TIF ) then
                FCompression := AskForCompression
            else if ( FFileFormat = LLI_DISK_JPG ) then
                FCompression := AskForQuality;

            ImageInWindow.SaveAs( oDialog.FileName, FFileFormat, FCompression );
            FImagePath := '';
            FImageName := oDialog.FileName;
        end;
    end;

    oDialog.Free;

end;

{******************************************************************************}

procedure TImageWindow.Information;
Var
   DlgImageOperations : TDlgImageOperations;
begin
    DlgImageOperations := TDlgImageOperations.Create( Self );
    try
        DlgImageOperations.Init( ImageInWindow );
        DlgImageOperations.Page := 'Information';

        DlgImageOperations.ShowModal;

    finally
        DlgImageOperations.Free;
    end;
end;

{******************************************************************************}

procedure TImageWindow.Print;
Var
    CropRect : TRect;
    TmpRect  : TRect;
    tiDim    : TImageDimension;

begin
    tiDim := LLGetCanvasArea( Self );

    if ( CaptureIsVisible ) then
    begin

        { beware of offset due to toolbar and gauge }
        TmpRect.Left   :=  FCaptureRect.Left - tiDim.Left;
        TmpRect.Top    :=  FCaptureRect.Top - tiDim.Top;
        TmpRect.Right  :=  FCaptureRect.Right - tiDim.Left;
        TmpRect.Bottom :=  FCaptureRect.Bottom - tiDim.Top;

        { take care that rectangle is ready to use for printer calculations }
        CropRect.Left   := min( TmpRect.Left, TmpRect.Right );
        CropRect.Top    := min( TmpRect.Top,  TmpRect.Bottom );
        CropRect.Right  := max( TmpRect.Left, TmpRect.Right );
        CropRect.Bottom := max( TmpRect.Top,  TmpRect.Bottom );

        ImageInWindow.PrintByDialog( CropRect.TopLeft,
                                     CropRect.BottomRight );
    end
    else
    begin
        CropRect.Left   := 0;
        CropRect.Top    := 0;
        CropRect.Right  := 0;
        CropRect.Bottom := 0;
        ImageInWindow.PrintByDialog( CropRect.TopLeft,
                                     CropRect.BottomRight );
    end;
end;

{******************************************************************************}

procedure TImageWindow.CopyToClipboard;
Var
    CropRect : TRect;
    TmpRect  : TRect;
    tiDim    : TImageDimension;

begin
    tiDim := LLGetCanvasArea( Self );

    if ( CaptureIsVisible ) then
    begin

        { beware of offset due to toolbar and gauge }
        TmpRect.Left   :=  FCaptureRect.Left - tiDim.Left;
        TmpRect.Top    :=  FCaptureRect.Top - tiDim.Top;
        TmpRect.Right  :=  FCaptureRect.Right - tiDim.Left;
        TmpRect.Bottom :=  FCaptureRect.Bottom - tiDim.Top;

        { take care that rectangle is ready to use for CopyToClipBoard calculations }
        CropRect.Left   := min( TmpRect.Left, TmpRect.Right );
        CropRect.Top    := min( TmpRect.Top,  TmpRect.Bottom );
        CropRect.Right  := max( TmpRect.Left, TmpRect.Right );
        CropRect.Bottom := max( TmpRect.Top,  TmpRect.Bottom );

        ImageInWindow.CopyToClipBoard( CropRect.TopLeft,
                                       CropRect.BottomRight );
    end
    else
    begin
        CropRect.Left   := 0;
        CropRect.Top    := 0;
        CropRect.Right  := 0;
        CropRect.Bottom := 0;
        ImageInWindow.CopyToClipBoard( CropRect.TopLeft,
                                       CropRect.BottomRight );
    end;
end;

{******************************************************************************}

procedure TImageWindow.PasteFromClipboardNew;
begin
    ImageInWindow.PasteFromClipboardNew;
    ImageInWindow.Display( True );
end;

{******************************************************************************}

procedure TImageWindow.Crop;
Var
    CropRect : TRect;
    tiDim    : TImageDimension;

begin
    tiDim := LLGetCanvasArea( Self );

    { beware of offset due to toolbar and gauge }
    CropRect.Left   :=  FCaptureRect.Left - tiDim.Left;
    CropRect.Top    :=  FCaptureRect.Top - tiDim.Top;
    CropRect.Right  :=  FCaptureRect.Right - tiDim.Left;
    CropRect.Bottom :=  FCaptureRect.Bottom - tiDim.Top;

    ImageInWindow.Crop( CropRect.TopLeft,
                        CropRect.BottomRight );

    ImageInWindow.Display( True );
end;

{******************************************************************************}

procedure TImageWindow.GrabClientArea;
begin
    ImageInWindow.Grab( LLI_SCREEN_CLIENT_AREA );

    ImageInWindow.Display( True );
end;

{******************************************************************************}

procedure TImageWindow.GrabWindow;
begin
    ImageInWindow.Grab( LLI_SCREEN_WINDOW );

    ImageInWindow.Display( True );
end;

{******************************************************************************}

procedure TImageWindow.GrabDeskTop;
begin
    ImageInWindow.Grab( LLI_SCREEN_DESKTOP );

    ImageInWindow.Display( True );
end;

{******************************************************************************}

procedure TImageWindow.Scan;
begin
    ImageInWindow.Scan( '' );

    ImageInWindow.Display( True );
end;

{******************************************************************************}

function TImageWindow.ScanSilent: Boolean;
begin
    { Check if paper is present in the feeder when FeederEnabled and AutoFeed }
    if ( ( Twain.FeederEnabled.Value ) and
         ( Twain.FeederAutoFeed.Value ) and
         ( not Twain.FeederLoaded.Value ) ) then { -> no paper! }
    begin
        MessageDlg( 'Îרטבךא: Íוע (במכüרו) בףלאדט ג סךאםונו. '#13#10 +
                    'Ïנמגונüעו םאכטקטו סךאםטנףולמדמ לאעונטאכא ג סךאםונו'#13#10 +
                    'ט חאןףסעטעו מןונאצט‏ סםמגא.', mtInformation, [mbOk], 0);
        Result := False;
    end
    else
    begin
        Result := ImageInWindow.ScanSilent( '' );
        ImageInWindow.Display( True );
    end;
end;

{******************************************************************************}

function TImageWindow.GetTwain: TLLTwain;
begin
    if ( FTwain = nil ) then
        FTwain := TLLTwain.Create( Self );
    Result := FTwain;
end;

{******************************************************************************}

procedure TImageWindow.ScanAndSave;
var
    oDialog  : TSaveDialog;
    FileName : TFileName;
begin

    oDialog := TSaveDialog.Create( self );
    oDialog.Filter := 'Âסו פאיכû (*.*)|*.*';

    if oDialog.Execute then
    begin
        ImageInWindow.Scan( oDialog.FileName );
    end;
    oDialog.Free;
end;

{******************************************************************************}

procedure TImageWindow.LoadFile( FileName: TFileName; Format: Longint; ExtraParam: Longint );
var
    OpenDialog  : TOpenDialog;
begin
    if ( FileName = '' ) then
    begin
        OpenDialog := TOpenDialog.Create( self );
        try

            case ( Format ) of
                LLI_DISK_BMP:
                    begin
                        OpenDialog.Filter := 'Bitmap פאיכû (*.BMP)|*.BMP|' +
                                          'Âסו פאיכû (*.*)|*.*';
                    end;
                LLI_DISK_GIF:
                    begin
                        OpenDialog.Filter := 'GIF פאיכû  (*.GIF)|*.GIF|' +
                                          'Âסו פאיכû (*.*)|*.*';
                    end;
                LLI_DISK_JPG:
                    begin
                        OpenDialog.Filter := 'JPEG פאיכû  (*.JPG)|*.JPG|' +
                                          'Âסו פאיכû (*.*)|*.*';
                    end;
                LLI_DISK_PCX:
                    begin
                        OpenDialog.Filter := 'PCX פאיכû  (*.PCX)|*.PCX|' +
                                          'Âסו פאיכû  (*.*)|*.*';
                    end;
                LLI_DISK_PNG:
                    begin
                        OpenDialog.Filter := 'Ping פאיכû  (*.PNG)|*.PNG|' +
                                          'Âסו פאיכû  (*.*)|*.*';
                    end;
                LLI_DISK_TGA:
                    begin
                        OpenDialog.Filter := 'Targa פאיכû  (*.TGA)|*.TGA|' +
                                          'Âסו פאיכû (*.*)|*.*';
                    end;
                LLI_DISK_TIF:
                    begin
                        OpenDialog.Filter := 'Tiff פאיכû  (*.TIF)|*.TIF|' +
                                          'Âסו פאיכû (*.*)|*.*';
                    end;

                else
                begin { LLI_DISK_AUTO or any other }
                    OpenDialog.Filter := 'Ôאיכû טחמבנאזוםטÿ |*.BMP;*.GIF;*.JPG;*.PCX;*.PNG;*.TGA;*.TIF|' +
                          'Bitmap פאיכû (*.BMP)|*.BMP|' +
                          'GIF פאיכû (*.GIF)|*.GIF|' +
                          'JPEG פאיכû (*.JPG)|*.JPG|' +
                          'PCX פאיכû (*.PCX)|*.PCX|' +
                          'Ping פאיכû (*.PNG)|*.PNG|' +
                          'Targa פאיכû (*.TGA)|*.TGA|' +
                          'Tiff פאיכû (*.TIF)|*.TIF|' +
                          'Âסו פאיכû (*.*)|*.*';
                end;
            end; { case }

            if OpenDialog.Execute then
            begin
                FileName := OpenDialog.FileName;
            end
            else exit; { cancel was pressed, do not load }

        finally
            OpenDialog.Free;
        end;
    end;

    if (ExtraParam = 0 ) then
    begin
        ExtraParam := GetTiffPageIndex( FileName ); { Check if it's a multiple Tiff file }
        if ExtraParam = -1 then exit; { tiff dialog was canceled }
    end;

    FImagePath := '';
    FImageName := FileName;

    ImageInWindow.LoadFile( FImageName,
                        Format{$ifdef DataAware}, nil {$endif},
                        ExtraParam ); { Tiff page index }

    if Assigned( FPostLoadEvent ) then FPostLoadEvent( Self );
    ImageInWindow.Display( True );

end;

{******************************************************************************}

procedure TImageWindow.Open;
var
    oDialog  : TOpenDialog;
    FileName : TFileName;
begin

    oDialog := TOpenDialog.Create( self );

    if ( ImageType in [itAuto] ) then
    begin
        FFileFormat := LLI_DISK_AUTO;
        oDialog.Filter := 'Ôאיכû טחמבנאזוםטÿ |*.BMP;*.GIF;*.JPG;*.PCX;*.PNG;*.TGA;*.TIF|' +
                          'Bitmap פאיכû (*.BMP)|*.BMP|' +
                          'GIF פאיכû (*.GIF)|*.GIF|' +
                          'JPEG פאיכû (*.JPG)|*.JPG|' +
                          'PCX פאיכû (*.PCX)|*.PCX|' +
                          'Ping פאיכû (*.PNG)|*.PNG|' +
                          'Targa פאיכû (*.TGA)|*.TGA|' +
                          'Tiff פאיכû (*.TIF)|*.TIF|' +
                          'Âסו פאיכû (*.*)|*.*';
    end
    else
    begin
        case ( ImageType ) of
            itAuto:
                begin
                    FFileFormat := LLI_DISK_AUTO;
                    oDialog.Filter :='Ôאיכû טחמבנאזוםטÿ |*.BMP;*.GIF;*.JPG;*.PCX;*.PNG;*.TGA;*.TIF|' +
                          'Bitmap פאיכû (*.BMP)|*.BMP|' +
                          'GIF פאיכû (*.GIF)|*.GIF|' +
                          'JPEG פאיכû (*.JPG)|*.JPG|' +
                          'PCX פאיכû (*.PCX)|*.PCX|' +
                          'Ping פאיכû (*.PNG)|*.PNG|' +
                          'Targa פאיכû (*.TGA)|*.TGA|' +
                          'Tiff פאיכû (*.TIF)|*.TIF|' +
                          'Âסו פאיכû (*.*)|*.*';
                end;
            itBitmap:
                begin
                    FFileFormat := LLI_DISK_BMP;
                    oDialog.Filter := 'Bitmap פאיכû (*.BMP)|*.BMP|' +
                                      'Âסו פאיכû (*.*)|*.*';
                end;
            itGif:
                begin
                    FFileFormat := LLI_DISK_GIF;
                    oDialog.Filter := 'GIF פאיכû (*.GIF)|*.GIF|' +
                                      'All פאיכû (*.*)|*.*';
                end;
            itJpeg:
                begin
                    FFileFormat := LLI_DISK_JPG;
                    oDialog.Filter := 'JPEG פאיכû (*.JPG)|*.JPG|' +
                                      'All פאיכû (*.*)|*.*';
                end;
            itPcx:
                begin
                    FFileFormat := LLI_DISK_PCX;
                    oDialog.Filter := 'PCX פאיכû (*.PCX)|*.PCX|' +
                                      'All פאיכû (*.*)|*.*';
                end;
            itPing:
                begin
                    FFileFormat := LLI_DISK_PNG;
                    oDialog.Filter := 'Ping פאיכû (*.PNG)|*.PNG|' +
                                      'Âסו פאיכû (*.*)|*.*';
                end;
            itTarga:
                begin
                    FFileFormat := LLI_DISK_TGA;
                    oDialog.Filter := 'Targa פאיכû (*.TGA)|*.TGA|' +
                                      'Âסו פאיכû (*.*)|*.*';
                end;
            itTiff:
                begin
                    FFileFormat := LLI_DISK_TIF;
                    oDialog.Filter := 'Tiff פאיכû (*.TIF)|*.TIF|' +
                                      'Âסו פאיכû (*.*)|*.*';
                end;

            else
            begin
                FFileFormat := LLI_DISK_AUTO;
                oDialog.Filter :='Ôאיכû טחמבנאזוםטÿ |*.BMP;*.GIF;*.JPG;*.PCX;*.PNG;*.TGA;*.TIF|' +
                          'Bitmap פאיכû (*.BMP)|*.BMP|' +
                          'GIF פאיכû (*.GIF)|*.GIF|' +
                          'JPEG פאיכû (*.JPG)|*.JPG|' +
                          'PCX פאיכû (*.PCX)|*.PCX|' +
                          'Ping פאיכû (*.PNG)|*.PNG|' +
                          'Targa פאיכû (*.TGA)|*.TGA|' +
                          'Tiff פאיכû (*.TIF)|*.TIF|' +
                          'Âסו פאיכû (*.*)|*.*';

            end;
        end; { case }
    end;


    if oDialog.Execute then
    begin
        if ( ImagePath <> '' ) then
            ImagePath := '';

        ImageName := oDialog.FileName;
    end;

    oDialog.Free;
end;

{******************************************************************************}

procedure TImageWindow.Paint;
begin

    inherited Paint;
    ImageInWindow.Display( True );

end;

{******************************************************************************}

procedure TImageWindow.SetGauge( Value: Boolean );
begin
    FGauge          := Value;
    FoGauge.Visible := Value;
    ImageInWindow.lGaugeVisible := Value;

    FCanvasArea := LLSetControlSizes( Self );

    Invalidate;
end;

{******************************************************************************}

procedure TImageWindow.SetToolbar( Value: Boolean );
begin

    FToolBar := Value;

    if Value then
    begin
        CreateToolbar;
        FoToolBar.SetVisible( FVisibleInfo );
        FoToolBar.SetButtonHints( FToolBarHints );
        if ( FoToolBar.Width > FoToolBar.GetButtonLength ) then
        begin
            FoToolBar.SetFiller( True );
            FoLeftBtn.Enabled := False;
            FoRightBtn.Enabled := False;
        end;
    end
    else
    begin
        DestroyToolbar;
    end;

    FCanvasArea := LLSetControlSizes( Self );

    Invalidate;
end;

{******************************************************************************}

procedure TImageWindow.SetHScroll( Value: Boolean );
begin
    FHorzScroll          := Value;
    FoHorzScroll.Visible := Value;

    FCanvasArea := LLSetControlSizes( Self );

    if Value then
        FoHorzScroll.Show
    else
        FoHorzScroll.Hide;

    Invalidate;
end;

{******************************************************************************}

procedure TImageWindow.SetVScroll( Value: Boolean );
begin

    FVertScroll          := Value;
    FoVertScroll.Visible := Value;

    FCanvasArea := LLSetControlSizes( Self );

    if Value then
        FoVertScroll.Show
    else
        FoVertScroll.Hide;


    Invalidate;
end;

{******************************************************************************}

function TImageWindow.GetTiffPageIndex( ImgName: String ): Longint;
var
    ImageIndex       : Longint;
    iGetRet          : Longint;
    MultiImageDialog : TMultiImageDialog;
    Extension        : String;
    szTmp            : Array[0..255] of char;
begin

    Result := 0;

    Extension := UpperCase( Copy( ImgName, Length(ImgName)-3, 4 ) );

    if ( Extension = '.TIF' ) then
    begin
         iGetRet    := 1;
         ImageIndex := 0;

         StrPCopy( PChar(@szTmp), ImgName );

         iGetRet := iGet( liLightLibApp,
                          LLI_DISK,
                          0,
                          0,
                          0,
                          1,
                          1,
                          LongInt( @szTmp ),
                          0,
                          LLI_VOID_PARAM,
                          LLI_VOID_PARAM,
                          LLI_VOID_PARAM,
                          LLI_VOID_PARAM );

         { if iGet was successful, then retreive number of pages }
         if ( iGetRet <> 0 ) then
             ImageIndex := oAccess( iGetRet, LLI_IMAGE_FILE_PAGE_COUNT, 0 );

         if ( ImageIndex > 1 ) then
         begin
              MultiImageDialog := TMultiImageDialog.Create(Self);
              try
                  MultiImageDialog.Init( ImgName, ImageIndex);

                  if ( MultiImageDialog.ShowModal = mrOk ) then
                      Result := MultiImageDialog.cbImages.ItemIndex
                  else
                      Result := -1;
              finally
                  MultiImageDialog.Free;
              end;
         end
         else Result := 0;
    end; { Tiff }
end;

{******************************************************************************}

procedure TImageWindow.SetImageName( Value: TImageName );
Var
    ImageIndex : Longint;
begin

    ImageIndex := GetTiffPageIndex( Value ); { Check if it's}
    if ImageIndex = -1 then exit; { tiff dialog was canceled }

    FImageName := Value;

    if ( FImagePath = '' ) then
        ImageInWindow.LoadFile( FImageName, FFileFormat{$ifdef DataAware}, nil {$endif}, ImageIndex)
    else
        ImageInWindow.LoadFile( FImagePath + '\' + FImageName, FFileFormat{$ifdef DataAware}, nil {$endif}, ImageIndex);

    if Assigned( FPostLoadEvent ) then FPostLoadEvent( Self );
    ImageInWindow.Display( True );
end;

{******************************************************************************}


procedure TImageWindow.SetImagePath( Value: TFileName );
Var
    ImageIndex : Longint;
begin

    ImageIndex := GetTiffPageIndex( Value );
    if ImageIndex = -1 then exit; { tiff dialog was canceled }

    FImagePath := Value;

    if ( FImagePath = '' ) then
        ImageInWindow.LoadFile( FImageName, FFileFormat{$ifdef DataAware}, nil {$endif}, ImageIndex)
    else
        ImageInWindow.LoadFile( FImagePath + '\' + FImageName, FFileFormat{$ifdef DataAware}, nil {$endif}, ImageIndex);

    if Assigned( FPostLoadEvent ) then FPostLoadEvent( Self );
    ImageInWindow.Display( True );
end;


{******************************************************************************}

procedure TImageWindow.ScrollRefresh( Sender : TObject );
begin
    { react to scroll bar movements }
    ImageInWindow.Display( False );
end;


{******************************************************************************}

procedure TImageWindow.FitBest;
begin
    FitStyle := fsBest;
end;

{******************************************************************************}

procedure TImageWindow.FitInWindow;
begin
    FitStyle := fsWindow;
end;

{******************************************************************************}

procedure TImageWindow.FitRelease;
begin
    FZoomFactor := 1.0;
    FitStyle := fsNone;
end;

{******************************************************************************}

procedure TImageWindow.FitToHeight;
begin
    FitStyle := fsHeight;
end;

{******************************************************************************}

procedure TImageWindow.FitToWidth;
begin
    FitStyle := fsWidth;
end;

{******************************************************************************}

procedure TImageWindow.RotateLeft;
begin
    ImageInWindow.Rotate( 270, False );
    ImageInWindow.Display( True );
end;

{******************************************************************************}

procedure TImageWindow.RotateRight;
begin
    ImageInWindow.Rotate( 90, False );
    ImageInWindow.Display( True );
end;

{******************************************************************************}

procedure TImageWindow.RotateInvert;
begin
    ImageInWindow.Rotate( 180, False );
    ImageInWindow.Display( True );
end;

{******************************************************************************}

procedure TImageWindow.ZoomInByIncrement;
begin
    if FitStyle <> fsNone then
        ZoomFactor  := ImageInWindow.GetInternalZoomX + ( (ImageInWindow.GetInternalZoomX * ZoomIncrement) / 100 )
    else
        ZoomFactor := ZoomFactor + ( (ZoomFactor * ZoomIncrement) / 100 );
end;

{******************************************************************************}

procedure TImageWindow.ZoomOutByIncrement;
begin
    if FitStyle <> fsNone then
        ZoomFactor  := ImageInWindow.GetInternalZoomX - ( (ImageInWindow.GetInternalZoomX * ZoomIncrement) / 100 )
    else
        ZoomFactor := ZoomFactor - ( (ZoomFactor * ZoomIncrement) / 100 );
end;

{******************************************************************************}

procedure TImageWindow.Zoom10In;
begin
    if FitStyle <> fsNone then
        ZoomFactor  := ImageInWindow.GetInternalZoomX + 0.10
    else
        ZoomFactor := ZoomFactor + 0.10;
end;

{******************************************************************************}

procedure TImageWindow.Zoom10Out;
begin
    if FitStyle <> fsNone then
        ZoomFactor  := ImageInWindow.GetInternalZoomX - 0.10
    else
        ZoomFactor := ZoomFactor - 0.10;
end;

{******************************************************************************}

procedure TImageWindow.Zoom25In;
begin
    if FitStyle <> fsNone then
        ZoomFactor  := ImageInWindow.GetInternalZoomX + 0.25
    else
        ZoomFactor := ZoomFactor + 0.25;
end;

{******************************************************************************}

procedure TImageWindow.Zoom25Out;
begin
    if FitStyle <> fsNone then
        ZoomFactor  := ImageInWindow.GetInternalZoomX - 0.25
    else
        ZoomFactor := ZoomFactor - 0.25;
end;

{******************************************************************************}

procedure TImageWindow.SwapSharedExclusive;
begin
    ImageInWindow.SwapSharedExclusive;
    ImageInWindow.Display( True );
end;

{******************************************************************************}

procedure Register;
begin

    RegisterComponents( 'LightLib', [TImageWindow] );

    { register our own property editor to configure the toolBar at design time }
    RegisterPropertyEditor( TypeInfo( TButtonInfo ),  { Property Type }
                            TImageWindow,    { Component type to which editor applies }
                            'ToolBarSetup',  { Property name (apearing in Object Inspector) }
                            TToolBarProperty { PrpertyEditor to be used for property type}
                           );

    { register our own property editor for file names at design time }
    RegisterPropertyEditor( TypeInfo( TImageName ),  { Property Type }
                            TImageWindow,    { Component type to which editor applies }
                            'ImageName',  { Property name (apearing in Object Inspector) }
                            TImageNameProperty { PrpertyEditor to be used for property type}
                           );
end;

{******************************************************************************}

procedure TImageWindow.MouseDown( mButton :TMouseButton; Shift:TShiftState; X, Y:Integer );
Var
    DrawRect : TRect;
    tiDim    : TImageDimension;

begin
    inherited MouseDown( mButton, Shift, X, Y );

    if ( not SelectionEnabled ) then exit;

    MouseCapture := True;

    if ( ssCtrl in Shift ) then
    begin
        if ( mButton = mbLeft ) then { Zoom in }
        begin
            Screen.Cursor  := crMagnifyPlus;
            ZoomInByIncrement;
        end
        else { Zoom Out }
        begin
            Screen.Cursor  := crMagnifyMinus;
            ZoomOutByIncrement;
        end;
    end
    else { No Ctrl in Shift }
    begin
        if ( mButton = mbLeft ) then { Selection }
        begin
            if ( SelectionEnabled ) then
            begin
                Screen.Cursor  := crCross;
                tiDim := LLGetCanvasArea( self );

                {ensure to stay inside the drawable area}
                tiDim.width  := min( Round( ImageInWindow.DisWidth * ImageInWindow.GetInternalZoomX ),
                                     tiDim.width ); { image width }
                tiDim.height := min( Round( ImageInWindow.DisHeight * ImageInWindow.GetInternalZoomY ),
                                     tiDim.height ); { image height }

                {ensure to stay inside the imagearea}
                if ( ( X < tiDim.left ) or
                     ( X > (tiDim.left + tiDim.width) ) or
                     ( Y < tiDim.top ) or
                     ( Y > (tiDim.top + tiDim.height) ) ) then
                begin
                    { leave the function because click was not within the image }
                    exit;
                end;

                Canvas.Brush.Style := bsClear;
                Canvas.Pen.Width   := SelectionWidth;
                Canvas.Pen.Style   := SelectionStyle;
                Canvas.Pen.Color   := SelectionColor;
                Canvas.Pen.Mode    := pmNotXor;
                if ( CaptureIsVisible and SelectionEnabled ) then
                begin
                    { draw the old rectangle to erase old frame }
                    Drawrect.left   := min( FCaptureRect.left, FCaptureRect.right );
                    Drawrect.right  := max( FCaptureRect.left, FCaptureRect.right );
                    Drawrect.top    := min( FCaptureRect.top, FCaptureRect.bottom );
                    Drawrect.bottom := max( FCaptureRect.top, FCaptureRect.bottom );

                    Canvas.Rectangle(  Drawrect.left,  Drawrect.top,
                                       Drawrect.right, Drawrect.bottom);
                end;
                Canvas.Pen.Mode    := pmCopy;

                FLButtonDown := TRUE;
                FCaptureRect.Left    := X;
                FCaptureRect.Top     := Y;
                FCaptureRect.Right   := X;
                FCaptureRect.Bottom  := Y;
            end;
        end
        else { Scroll the image around }
        begin
            FRButtonDown := True;
            FMouseOldX     := X;
            FMouseOldY     := Y;
            FScrollOldX    := FoHorzScroll.Position;
            FScrollOldY    := FoVertScroll.Position;
            Screen.Cursor  := crScroll;
        end;
    end;
end;

{******************************************************************************}

procedure TImageWindow.MouseMove( Shift:TShiftState; X, Y:Integer );
Var
    DrawRect : TRect;
    tiDim    : TImageDimension;
    xx, yy   : Integer;
begin

    Inherited MouseMove( Shift, X, Y );

    if ( not SelectionEnabled ) then exit;

    if ( FLButtonDown ) then { Selection }
    begin
        if ( SelectionEnabled ) and
           ( OldX <> X ) or ( OldY <> Y )  then
        begin
            tiDim := LLGetCanvasArea( self );

            OldX := X;
            OldY := Y;
            FCaptureIsVisible   := True;

            Canvas.Brush.Style := bsClear;
            Canvas.Pen.Width   := SelectionWidth;
            Canvas.Pen.Style   := SelectionStyle;
            Canvas.Pen.Color   := SelectionColor;
            Canvas.Pen.Mode    := pmNotXor;

            { draw the old rectangle to erase old frame }
            Drawrect.left      := min( FCaptureRect.left, FCaptureRect.right );
            Drawrect.right     := max( FCaptureRect.left, FCaptureRect.right );
            Drawrect.top       := min( FCaptureRect.top, FCaptureRect.bottom );
            Drawrect.bottom    := max( FCaptureRect.top, FCaptureRect.bottom );

            { update the coordinates of rectangle }
            Canvas.Rectangle(  Drawrect.left,  Drawrect.top,
                               Drawrect.right, Drawrect.bottom);

            {ensure to stay inside the drawable area}
            tiDim.width  := min( Round( ImageInWindow.DisWidth * ImageInWindow.GetInternalZoomX ),
                                 tiDim.width ); { image width }
            tiDim.height := min( Round( ImageInWindow.DisHeight * ImageInWindow.GetInternalZoomY ),
                                 tiDim.height ); { image height }

            {ensure to stay inside the imagearea}
            X := max( tiDim.left, X );
            X := min( (tiDim.left + tiDim.width) , X );
            Y := max( tiDim.top, Y );
            Y := min( (tiDim.top + tiDim.height), Y );


            FCaptureRect.right  := X;
            FCaptureRect.bottom := Y;

            { draw the new rectangle }
            Drawrect.left   := min( FCaptureRect.left, FCaptureRect.right );
            Drawrect.right  := max( FCaptureRect.left, FCaptureRect.right );
            Drawrect.top    := min( FCaptureRect.top, FCaptureRect.bottom );
            Drawrect.bottom := max( FCaptureRect.top, FCaptureRect.bottom );

            Canvas.Rectangle(  Drawrect.left,  Drawrect.top,
                               Drawrect.right, Drawrect.bottom);

            Canvas.Pen.Mode    := pmCopy;
        end;
    end
    else if ( FRButtonDown ) then { Scroll the image around }
    begin
        xx := FScrollOldX + Round( (FMouseOldX - X) / ImageInWindow.GetInternalZoomX );
        yy := FScrollOldY + Round( (FMouseOldY - Y) / ImageInWindow.GetInternalZoomY );

        if ( xx <> FoHorzScroll.Position ) then
            FoHorzScroll.Position := xx;
        if ( yy <> FoVertScroll.Position ) then
            FoVertScroll.Position := yy;
    end;

end;

{******************************************************************************}

procedure TImageWindow.MouseUp( tButton :TMouseButton; Shift:TShiftState; X, Y:Integer );
begin
    Inherited MouseUp( tButton, Shift, X, Y );
    if ( not SelectionEnabled ) then exit;

    if ( tButton = mbLeft ) then
    begin
        FLButtonDown := False;
    end;
    if ( tButton = mbRight ) then
    begin
        FRButtonDown := False;
    end;

    Screen.Cursor := crDefault;
    MouseCapture := False;
end;



{******************************************************************************}
{*                   TImageInWindow class implementation                      *}
{******************************************************************************}


constructor TImageInWindow.Create( AOwner: TComponent );
Var
    lLZWLicence : Boolean;

begin
    inherited Create( AOwner );

    { In order to respect Unisys copyright on LZW for TIFF and GIF, Light Lib Image
      requires a special key code to use these algorithms. Please call DFL Tech Support
      to obtain this key code as soon as you obtained UNISYS agreement
      The number used here ( 3356659493 = $C8128F25 hex ) is not suitable for
      your DLL Serial Number
      Since the Longint type does not support values greater than 2147483647
      you have to code your number in hex }

{
    oAssign( TImageWindow(Owner).liLightLibApp, LLI_APPLICATION_LZW_UNISYS, LongInt($C8128F25), LLO_VOID_PARAM );
    lLZWLicence := Boolean( oAccess( TImageWindow(Owner).liLightLibApp, LLI_APPLICATION_LZW_UNISYS, LLO_VOID_PARAM ) );
}

    { lLZWLicence value is True if you are using the right Key code.
      You can delete those lines if you don't plan to use LZW in TIF and GIF }

    iCurrentX := 0; { horizontal scrollposition to zero }
    iCurrentY := 0; { vertical scrollposition to zero }

    liDisImage := 0;
    liOriImage := 0;
    lFirstDisplay := TRUE;

    MemoryImage( 0, 0, 0, 0 );

    FDrawBrush := TBrush.Create;
    FDrawPen   := TPen.Create;
    FDrawFont  := TFont.Create;

    FCurrentPalette := 0;

    FitMode  := LLI_FIT_NONE;
{$ifdef SDE}
    {$ifdef DataAware}
        {Added for SDE support by DJA}
        fpSxSelect := Nil;
    {$endif}
{$endif}

    lPaletteShared := FALSE;

{$ifdef DataAware}
    { stream functions for native image handling with databases }
    oAssign ( TImageWindow(Owner).liLightLibApp, LLI_APPLICATION_USER_STREAM_CREATE, Longint( @streamCreate ), 0 );
    oAssign ( TImageWindow(Owner).liLightLibApp, LLI_APPLICATION_USER_STREAM_DELETE, Longint( @streamDelete ), 0 );
    oAssign ( TImageWindow(Owner).liLightLibApp, LLI_APPLICATION_USER_STREAM_OPEN,   Longint( @streamOpen ),   0 );
    oAssign ( TImageWindow(Owner).liLightLibApp, LLI_APPLICATION_USER_STREAM_CLOSE,  Longint( @streamClose ),  0 );
    oAssign ( TImageWindow(Owner).liLightLibApp, LLI_APPLICATION_USER_STREAM_READ,   Longint( @streamRead ),   0 );
    oAssign ( TImageWindow(Owner).liLightLibApp, LLI_APPLICATION_USER_STREAM_WRITE,  Longint( @streamWrite ),  0 );
    oAssign ( TImageWindow(Owner).liLightLibApp, LLI_APPLICATION_USER_STREAM_SEEK,   Longint( @streamSeek ),   0 );
{$endif}

end;

{******************************************************************************}

destructor TImageInWindow.Destroy;
begin
    FDrawBrush.Free;
    FDrawPen.Free;
    FDrawFont.Free;
    inherited Destroy;
end;

{******************************************************************************}

function TImageInWindow.GetLZWLicensed : Boolean;
begin
    Result := Boolean( oAccess( TImageWindow(Owner).liLightLibApp, LLI_APPLICATION_LZW_UNISYS, LLO_VOID_PARAM ) );
end;

{******************************************************************************}

function TImageInWindow.GetBackGroundColor : TColor;
begin
    Result := TColor( LongInt( oAccess( liDisImage, LLI_IMAGE_COLOR_BACKGROUND, 0 ) ) );
end;

{******************************************************************************}

procedure TImageInWindow.SetBackGroundColor( AColor : TColor );
Var
    liColor : Longint;
begin
    liColor := ColorToRGB( AColor );
    oAssign( liDisImage, LLI_IMAGE_COLOR_BACKGROUND, liColor, LLO_VOID_VALUE );
end;

{******************************************************************************}

function TImageInWindow.GetInternalImage : Longint; { !! only for internal use !!}
begin
    Result := liDisImage;
end;

{******************************************************************************}

function TImageInWindow.GetDefaultImageSize : Integer;
begin
    Result := TImageWindow(Owner).DefaultImageSize;
end;

{******************************************************************************}

function TImageInWindow.GetAsBitmap : HBitmap;
begin
    Result := oCopy( TImageWindow(Owner).liLightLibApp,
                     liDisImage,
                     LLO_COPY_TO_HANDLE,
                     LLO_FORMAT_BITMAP,
                     LongInt( TImageWindow(Owner).Handle ),
                     0 );
end;

{******************************************************************************}

procedure TImageInWindow.SetAsBitmap( BitmapHandle: HBitmap);
begin
    Clear;
    liDisImage := oCopy( TImageWindow(Owner).liLightLibApp,
                     0,
                     LLO_COPY_FROM_HANDLE,
                     LLO_FORMAT_BITMAP,
                     BitmapHandle,
                     FCurrentPalette );

    if liDisImage <> 0 then
    begin
        BackGroundColor := TImageWindow(Owner).BackGroundColor;
    end;

end;

{******************************************************************************}

procedure TImageInWindow.PasteBitmapAt( Position: TPoint; BitmapHandle: HBitmap );
var
    TmpImage: Longint;
begin
    { convert the Bitmap to an internal Light Lib image
      and then paste it into the current image }
    TmpImage := oCopy( TImageWindow(Owner).liLightLibApp,
                     0,
                     LLO_COPY_FROM_HANDLE,
                     LLO_FORMAT_BITMAP,
                     BitmapHandle,
                     FCurrentPalette );

    if TmpImage <> 0 then
    begin
        PasteAt( Position, TmpImage );
        oDel( TmpImage );
    end;
end;

{******************************************************************************}

procedure TImageInWindow.PasteAt( Position: TPoint; pImage: Longint );
begin
    { paste the image pointed by pImage into the current image }
    if ( pImage <> 0 ) and ( liDisImage <> 0 )then
    begin
            iPut( pImage,
                  LLI_FULL_SIZE,
                  LLI_FULL_SIZE,
                  LLI_FULL_SIZE,
                  LLI_FULL_SIZE,
                  LLI_MEMORY,
                  LLI_MEMORY_BW,
                  Position.x,
                  Position.y,
                  liDisImage,
                  LLI_VOID_PARAM,
                  LLI_VOID_PARAM,
                  LLI_VOID_PARAM,
                  LLI_VOID_PARAM,
                  LLI_VOID_PARAM );
    end;
end;

{******************************************************************************}

function TImageInWindow.CopyAsBitmapAt( Rect: TRect ): HBitmap;
var
    TmpImage: Longint;
begin
    Result := 0; { just in case }

    TmpImage := CopyAt( Rect );

    if TmpImage <> 0 then
    begin
        Result := oCopy( TImageWindow(Owner).liLightLibApp,
                         TmpImage,
                         LLO_COPY_TO_HANDLE,
                         LLO_FORMAT_BITMAP,
                         LongInt( TImageWindow(Owner).Handle ),
                         0 );

        FCurrentPalette := oAccess( TmpImage, LLI_IMAGE_PALETTE, 0 );

        oDel( TmpImage );
    end;
end;

{******************************************************************************}

function TImageInWindow.CopyAt( Rect: TRect ): Longint;
begin
    Result := 0;


    if liDisImage <> 0 then
        Result := iCopy( liDisImage,
                         Rect.Left,
                         Rect.Top,
                         Rect.Right,
                         Rect.Bottom,
                         LLI_COPY_CLONE,
                         LLI_VOID_PARAM,
                         LLI_VOID_PARAM,
                         LLI_VOID_PARAM,
                         LLI_VOID_PARAM,
                         LLI_VOID_PARAM,
                         LLI_VOID_PARAM );
end;

{******************************************************************************}

procedure TImageInWindow.MakeStamp( AWidth, AHeight : Longint; var liStamp : Longint );
begin
    liStamp := iCopy( InternalImage,
                      LLI_FULL_SIZE,
                      LLI_FULL_SIZE,
                      LLI_FULL_SIZE,
                      LLI_FULL_SIZE,
                      LLI_COPY_ZOOM,
                      AWidth,
                      AHeight,
                      LLI_VOID_PARAM,
                      LLI_VOID_PARAM,
                      LLI_VOID_PARAM,
                      LLI_VOID_PARAM );
end;

{******************************************************************************}

procedure TImageInWindow.LoadFromStamp( liStamp : Longint );
Var
    liNewImage : Longint;
begin

    if ( liStamp <> 0 ) then
    begin
        { make displayed be the same as stamp }
        liNewImage := iCopy( liStamp,
                             LLI_FULL_SIZE,
                             LLI_FULL_SIZE,
                             LLI_FULL_SIZE,
                             LLI_FULL_SIZE,
                             LLI_COPY_CLONE,
                             LLI_VOID_PARAM,
                             LLI_VOID_PARAM,
                             LLI_VOID_PARAM,
                             LLI_VOID_PARAM,
                             LLI_VOID_PARAM,
                             LLI_VOID_PARAM );
        if liNewImage <> 0 then
        begin
            Clear;
            liDisImage := liNewImage;
            BackGroundColor := TImageWindow(Owner).BackGroundColor;
        end;
    end;

end;

{******************************************************************************}

procedure TImageInWindow.Filter( AFilter, Factor1, Factor2, Factor3 : Longint;
                                 Red, Green, Blue : Boolean );
Var
    RGBFilter : Longint;
begin
    liOriImage := liDisImage;

    RGBFilter := $00000000;
    if Red then RGBFilter   := RGBFilter or LLI_FILTER_RED;
    if Green then RGBFilter := RGBFilter or LLI_FILTER_GREEN;
    if Blue then RGBFilter  := RGBFilter or LLI_FILTER_BLUE;

    IdleOn( 20 );
    liDisImage := iCopy( liOriImage,
                         LLI_FULL_SIZE,
                         LLI_FULL_SIZE,
                         LLI_FULL_SIZE,
                         LLI_FULL_SIZE,
                         LLI_COPY_FILTER,
                         AFilter,
                         RGBFilter,
                         Factor1,
                         LLI_VOID_PARAM,
                         LLI_VOID_PARAM,
                         LLI_VOID_PARAM
                        );
    IdleOff;

    if ( liDisImage <> 0 ) then
    begin
        liOriImage := oDel( liOriImage );
    end
    else
    begin
        liDisImage := liOriImage;
        liOriImage := 0;
    end;
    BackGroundColor := TImageWindow(Owner).BackGroundColor;
end;
{******************************************************************************}

function TImageInWindow.GetInternalZoomX: Double; 
begin
    Result := Double( Pointer( oAccess( liDisImage, LLI_IMAGE_X_ZOOM_FACTOR, LLO_VOID_PARAM ) )^ );
end;

{******************************************************************************}

function TImageInWindow.GetInternalZoomY: Double;
begin
    Result := Double( Pointer( oAccess( liDisImage, LLI_IMAGE_Y_ZOOM_FACTOR, LLO_VOID_PARAM ) )^ );
end;

{******************************************************************************}
function TImageInWindow.GetDrawPen: TPen;
begin
    Result := FDrawPen;
end;

{******************************************************************************}

procedure TImageInWindow.SetDrawPen( Value: TPen );
begin
    FDrawPen := Value;
end;

{******************************************************************************}

function TImageInWindow.GetDrawBrush: TBrush;
begin
    Result := FDrawBrush;
end;

{******************************************************************************}

procedure TImageInWindow.SetDrawBrush( Value: TBrush );
begin
    FDrawBrush := Value;
end;

{******************************************************************************}

function TImageInWindow.GetDrawFont: TFont;
begin
    Result := FDrawFont;
end;

{******************************************************************************}

procedure TImageInWindow.SetDrawFont( Value: TFont );
begin
    FDrawFont.Assign( Value );
end;

{******************************************************************************}

procedure TImageInWindow.DrawLine( x1, y1, x2, y2: Integer );
Var
    ABitmap: TBitmap;
    Rect: TRect;
    CorrX, CorrY: Integer;
    r: TRect;
begin
    Rect.Left := min(x1,x2);
    Rect.Top := min(y1,y2);
    Rect.Right := max(x2,x1);
    Rect.Bottom := max(y2,y1);

    if Rect.Right = Rect.Left then inc(Rect.Right);
    if Rect.Bottom = Rect.Top then inc(Rect.Bottom);

    Dec( Rect.Left, DrawPen.Width div 2 );
    Dec( Rect.Top, DrawPen.Width div 2 );
    Inc( Rect.Right, DrawPen.Width div 2 );
    Inc( Rect.Bottom, DrawPen.Width div 2 );

    if ( (Rect.Right - Rect.Left + 1 ) mod 4 > 0 ) then
        Rect.Right :=  Rect.Right + (4 - ( (Rect.Right - Rect.Left + 1 ) mod 4 ) );

    r.Left   := 0;
    r.Top    := 0;
    r.Right  := DisWidth;
    r.Bottom := DisHeight;
    if not Boolean( IntersectRect( r, Rect, r ) ) then exit;

    ABitmap := TBitmap.Create;

    ABitmap.Canvas.Brush := DrawBrush;
    ABitmap.Canvas.Pen := DrawPen;
    ABitmap.Handle := Self.CopyAsBitmapAt( Rect );

    if ( ABitmap.Handle <> 0 ) then
    begin
        if (Rect.Left < 0) then
            CorrX := 0
        else
            CorrX := Rect.Left;
        if (Rect.Top < 0) then
            CorrY := 0
        else
            CorrY := Rect.Top;

        ABitmap.Canvas.MoveTo( x1 - CorrX, y1 - CorrY );
        ABitmap.Canvas.LineTo( x2 - CorrX, y2 - CorrY );

        PasteBitmapAt( Rect.TopLeft, ABitmap.Handle );
    end;

    ABitmap.Free;
    Display( False );
end;

{******************************************************************************}

procedure TImageInWindow.DrawRectangle( x1, y1, x2, y2: Integer );
Var
    ABitmap: TBitmap;
    Rect: TRect;
    CorrX, CorrY: Integer;
    r: TRect;
begin
    Rect.Left := min(x1,x2);
    Rect.Top := min(y1,y2);
    Rect.Right := max(x2,x1);
    Rect.Bottom := max(y2,y1);

    if Rect.Right = Rect.Left then inc(Rect.Right);
    if Rect.Bottom = Rect.Top then inc(Rect.Bottom);

    Dec( Rect.Left, DrawPen.Width div 2 );
    Dec( Rect.Top, DrawPen.Width div 2 );
    Inc( Rect.Right, DrawPen.Width div 2 );
    Inc( Rect.Bottom, DrawPen.Width div 2 );

    if ( (Rect.Right - Rect.Left + 1 ) mod 4 > 0 ) then
        Rect.Right :=  Rect.Right + (4 - ( (Rect.Right - Rect.Left + 1 ) mod 4 ) );

    r.Left   := 0;
    r.Top    := 0;
    r.Right  := DisWidth;
    r.Bottom := DisHeight;
    if not Boolean( IntersectRect( r, Rect, r ) ) then exit;

    ABitmap := TBitmap.Create;

    ABitmap.Canvas.Brush := DrawBrush;
    ABitmap.Canvas.Pen := DrawPen;
    ABitmap.Handle := Self.CopyAsBitmapAt( Rect );

    if ( ABitmap.Handle <> 0 ) then
    begin
        if (Rect.Left < 0) then
            CorrX := 0
        else
            CorrX := Rect.Left;
        if (Rect.Top < 0) then
            CorrY := 0
        else
            CorrY := Rect.Top;
        ABitmap.Canvas.Rectangle( x1 - CorrX, y1 - CorrY, x2 - CorrX, y2 - CorrY );

        PasteBitmapAt( Rect.TopLeft, ABitmap.Handle );
    end;

    ABitmap.Free;
    Display( False );
end;

{******************************************************************************}

procedure TImageInWindow.DrawRoundRect( X1, Y1, X2, Y2, X3, Y3: Integer );
Var
    ABitmap: TBitmap;
    Rect: TRect;
    CorrX, CorrY: Integer;
    r: TRect;
begin
    Rect.Left := min(x1,x2);
    Rect.Top := min(y1,y2);
    Rect.Right := max(x2,x1);
    Rect.Bottom := max(y2,y1);

    if Rect.Right = Rect.Left then inc(Rect.Right);
    if Rect.Bottom = Rect.Top then inc(Rect.Bottom);

    Dec( Rect.Left, DrawPen.Width div 2 );
    Dec( Rect.Top, DrawPen.Width div 2 );
    Inc( Rect.Right, DrawPen.Width div 2 );
    Inc( Rect.Bottom, DrawPen.Width div 2 );

    if ( (Rect.Right - Rect.Left + 1 ) mod 4 > 0 ) then
        Rect.Right :=  Rect.Right + (4 - ( (Rect.Right - Rect.Left + 1 ) mod 4 ) );

    r.Left   := 0;
    r.Top    := 0;
    r.Right  := DisWidth;
    r.Bottom := DisHeight;
    if not Boolean( IntersectRect( r, Rect, r ) ) then exit;

    ABitmap := TBitmap.Create;

    ABitmap.Canvas.Brush := DrawBrush;
    ABitmap.Canvas.Pen := DrawPen;
    ABitmap.Handle := Self.CopyAsBitmapAt( Rect );

    if ( ABitmap.Handle <> 0 ) then
    begin
        if (Rect.Left < 0) then
            CorrX := 0
        else
            CorrX := Rect.Left;
        if (Rect.Top < 0) then
            CorrY := 0
        else
            CorrY := Rect.Top;
        ABitmap.Canvas.RoundRect( x1 - CorrX, y1 - CorrY, x2 - CorrX, y2 - CorrY, X3, Y3 );

        PasteBitmapAt( Rect.TopLeft, ABitmap.Handle );
    end;

    ABitmap.Free;
    Display( False );
end;

{******************************************************************************}

procedure TImageInWindow.DrawArc(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);
Var
    ABitmap: TBitmap;
    Rect: TRect;
    CorrX, CorrY: Integer;
    r: TRect;
begin
    Rect.Left := min(x1,x2);
    Rect.Top := min(y1,y2);
    Rect.Right := max(x2,x1);
    Rect.Bottom := max(y2,y1);

    if Rect.Right = Rect.Left then inc(Rect.Right);
    if Rect.Bottom = Rect.Top then inc(Rect.Bottom);

    Dec( Rect.Left, DrawPen.Width div 2 );
    Dec( Rect.Top, DrawPen.Width div 2 );
    Inc( Rect.Right, DrawPen.Width div 2 );
    Inc( Rect.Bottom, DrawPen.Width div 2 );

    if ( (Rect.Right - Rect.Left + 1 ) mod 4 > 0 ) then
        Rect.Right :=  Rect.Right + (4 - ( (Rect.Right - Rect.Left + 1 ) mod 4 ) );

    r.Left   := 0;
    r.Top    := 0;
    r.Right  := DisWidth;
    r.Bottom := DisHeight;
    if not Boolean( IntersectRect( r, Rect, r ) ) then exit;

    ABitmap := TBitmap.Create;

    ABitmap.Canvas.Brush := DrawBrush;
    ABitmap.Canvas.Pen := DrawPen;
    ABitmap.Handle := Self.CopyAsBitmapAt( Rect );

    if ( ABitmap.Handle <> 0 ) then
    begin
        if (Rect.Left < 0) then
            CorrX := 0
        else
            CorrX := Rect.Left;
        if (Rect.Top < 0) then
            CorrY := 0
        else
            CorrY := Rect.Top;

        ABitmap.Canvas.Arc( x1 - CorrX, y1 - CorrY, x2 - CorrX, y2 - CorrY,
                            X3 - CorrX, Y3 - CorrY, X4 - CorrX, Y4 - CorrY );

        PasteBitmapAt( Rect.TopLeft, ABitmap.Handle );
    end;

    ABitmap.Free;
    Display( False );
end;

{******************************************************************************}

procedure TImageInWindow.DrawEllipse( x1, y1, x2, y2: Integer );
Var
    ABitmap: TBitmap;
    Rect: TRect;
    CorrX, CorrY: Integer;
    r: TRect;
begin
    Rect.Left := min(x1,x2);
    Rect.Top := min(y1,y2);
    Rect.Right := max(x2,x1);
    Rect.Bottom := max(y2,y1);

    if Rect.Right = Rect.Left then inc(Rect.Right);
    if Rect.Bottom = Rect.Top then inc(Rect.Bottom);

    Dec( Rect.Left, DrawPen.Width div 2 );
    Dec( Rect.Top, DrawPen.Width div 2 );
    Inc( Rect.Right, DrawPen.Width div 2 );
    Inc( Rect.Bottom, DrawPen.Width div 2 );

    if ( (Rect.Right - Rect.Left + 1 ) mod 4 > 0 ) then
        Rect.Right :=  Rect.Right + (4 - ( (Rect.Right - Rect.Left + 1 ) mod 4 ) );

    r.Left   := 0;
    r.Top    := 0;
    r.Right  := DisWidth;
    r.Bottom := DisHeight;
    if not Boolean( IntersectRect( r, Rect, r ) ) then exit;

    ABitmap := TBitmap.Create;

    ABitmap.Canvas.Brush := DrawBrush;
    ABitmap.Canvas.Pen := DrawPen;
    ABitmap.Handle := Self.CopyAsBitmapAt( Rect );

    if ( ABitmap.Handle <> 0 ) then
    begin
        if (Rect.Left < 0) then
            CorrX := 0
        else
            CorrX := Rect.Left;
        if (Rect.Top < 0) then
            CorrY := 0
        else
            CorrY := Rect.Top;

        ABitmap.Canvas.Ellipse( x1 - CorrX, y1 - CorrY, x2 - CorrX, y2 - CorrY );

        PasteBitmapAt( Rect.TopLeft, ABitmap.Handle );
    end;

    ABitmap.Free;
    Display( False );
end;

{******************************************************************************}

procedure TImageInWindow.DrawTextOut(X, Y: Integer; const Text: string);
Var
    ABitmap: TBitmap;
    Rect: TRect;
    CorrX, CorrY: Integer;
    r: TRect;
begin

    ABitmap := TBitmap.Create;

    ABitmap.Canvas.Brush := DrawBrush;
    ABitmap.Canvas.Pen := DrawPen;
    ABitmap.Canvas.Font := DrawFont;

    Rect.Left := x;
    Rect.Top := y;
    Rect.Right := x + ABitmap.Canvas.TextWidth(Text);
    Rect.Bottom := y + ABitmap.Canvas.TextHeight(Text);

    if Rect.Right = Rect.Left then inc(Rect.Right);
    if Rect.Bottom = Rect.Top then inc(Rect.Bottom);

    r.Left   := 0;
    r.Top    := 0;
    r.Right  := DisWidth;
    r.Bottom := DisHeight;
    if ( Boolean( IntersectRect( r, Rect, r ) ) ) then
    begin

        ABitmap.Handle := Self.CopyAsBitmapAt( Rect );

        if ( ABitmap.Handle <> 0 ) then
        begin
            if (Rect.Left < 0) then
                CorrX := 0
            else
                CorrX := Rect.Left;
            if (Rect.Top < 0) then
                CorrY := 0
            else
                CorrY := Rect.Top;
            ABitmap.Canvas.TextOut( x - CorrX, y - CorrY, Text );

            PasteBitmapAt( Rect.TopLeft, ABitmap.Handle );
        end;

    end;
    ABitmap.Free;
    Display( False );
end;

{******************************************************************************}

function TImageInWindow.GetPixel( x, y : Longint ): TColor;
Var
    Xc, Yc : Longint;
begin
    Xc := iCurrentX + Round( x / GetInternalZoomX );
    Yc := iCurrentY + Round( y / GetInternalZoomY );

    oAssign( liDisimage, LLI_IMAGE_CURRENT_POSITION, Xc, Yc );

    Result := TColor( LongInt( oAccess( liDisimage, LLI_IMAGE_CURRENT_COLOR, 0 ) ) );
end;

{******************************************************************************}

procedure TImageInWindow.SetPixel( x, y : Longint; AColor : TColor );
var
    liColor    : Longint;
    Xc, Yc     : Longint;
    liBigPixel : Longint;
    bi : Longint;
begin

    liColor := ColorToRGB( AColor );
    Xc := iCurrentX + Round( x / GetInternalZoomX ) ;
    Yc := iCurrentY + Round( y / GetInternalZoomY );

    oAssign( liDisImage, LLI_IMAGE_CURRENT_POSITION, Xc, Yc );
    oAssign( liDisImage, LLI_IMAGE_CURRENT_COLOR, liColor, 0 );

end;

{******************************************************************************}

procedure TImageInWindow.CopyToClipboard( oStart, oEnd : TPoint );
Var
    oAreaStart : TPoint;
    oAreaEnd   : TPoint;
    liWidth,
    liHeight   : LongInt;
    liImage    : Longint;
begin


    if  (( oStart.X = oEnd.X ) and ( oStart.Y = oEnd.Y )) then
    begin
        oAreaStart.X := LLI_FULL_SIZE;
        oAreaStart.Y := LLI_FULL_SIZE;
        oAreaEnd.X   := LLI_FULL_SIZE;
        oAreaEnd.Y   := LLI_FULL_SIZE;
    end
    else
    begin
        oAreaStart.X := iCurrentX + Round( oStart.X  / GetInternalZoomX );
        oAreaStart.Y := iCurrentY + Round( oStart.Y  / GetInternalZoomY );
        oAreaEnd.X   := iCurrentX + Round( oEnd.X / GetInternalZoomX );
        oAreaEnd.Y   := iCurrentY + Round( oEnd.Y / GetInternalZoomY );
    end;

    IdleOn(20);
    liImage := iCopy( liDisImage,
                      LongInt( oAreaStart.X ),
                      LongInt( oAreaStart.Y ),
                      LongInt( oAreaEnd.X ),
                      LongInt( oAreaEnd.Y ),
                      LLI_COPY_CLONE,
                      LLI_VOID_PARAM,
                      LLI_VOID_PARAM,
                      LLI_VOID_PARAM,
                      LLI_VOID_PARAM,
                      LLI_VOID_PARAM,
                      LLI_VOID_PARAM );
    IdleOff;

    if ( liImage <> 0 ) then
    begin
        oCopy( TImageWindow(Owner).liLightLibApp,            { Light Lib Application  }
               liImage,                  { Light Lib Object Image }
               LLO_COPY_TO_CLIPBOARD,    { copy to the clipboard  }
               LLO_FORMAT_DIB,           { LLO_FORMAT_DIB }
               LongInt( TImageWindow(Owner).Handle ),
               0 );

        liImage := oDel( liImage );
    end;

end;

{******************************************************************************}

procedure TImageInWindow.PasteFromClipboardNew;
Var
    liImage : Longint;
begin
    liImage := oCopy( TImageWindow(Owner).liLightLibApp,            { Light Lib Application  }
                      0,                        { Light Lib Object Image }
                      LLO_COPY_FROM_CLIPBOARD,  { paste from clipboard  }
                      LLO_FORMAT_DIB,           { or DIB, LLO_FORMAT_DIB }
                      LongInt( TImageWindow(Owner).Handle ),
                      0 );

    if ( liImage <> 0 ) then
    begin
        Clear;
        liDisImage := liImage;
    end;
    BackGroundColor := TImageWindow(Owner).BackGroundColor;
end;

{******************************************************************************}

function TImageInWindow.Bits: Integer;
begin
    { Get the number of bits in an image }

    if ( liDisImage <> 0 ) then
        Result := oAccess( liDisImage, LLI_IMAGE_BITS, LLI_VOID_PARAM )
    else
        Result := 0;
end;

{******************************************************************************}

procedure TImageInWindow.SwapSharedExclusive;
begin
    lPaletteShared := not( lPaletteShared );
end;

{******************************************************************************}

procedure TImageInWindow.Clear;
begin

    { Clear all variables and remove images from memory }
    if ( liDisImage <> 0 ) then
        liDisImage := oDel( liDisImage );

end;

{******************************************************************************}


procedure TImageInWindow.ColorOperations( liColors : Longint; ADithering, GrayScale : Boolean );
    {Perform some colors operations like dithering/quantisation }
var
    liFullImage   : LongInt;
    cFilename     : String;
    liWidth,
    liHeight      : LongInt;
    liDithering,
    liScale       : Longint;
begin

    if ADithering then
        liDithering := LLI_DITHER_ON
    else
        liDithering := LLI_DITHER_OFF;

    if GrayScale then
        liScale := LLI_SCALE_GRAY
    else
        liScale := LLI_SCALE_COLOR;

    if ( Bits = 1 ) then  { no grayscale on B&W images }
        liScale := LLI_SCALE_COLOR;


    if lOriLoaded then
        liFullImage := liOriImage
    else
        liFullImage := liDisImage;


    liOriImage := liDisImage;

    IdleOn(20);

    { Clone a part of the original image }
    liDisImage := iCopy( liOriImage,
                         LLI_FULL_SIZE,
                         LLI_FULL_SIZE,
                         LLI_FULL_SIZE,
                         LLI_FULL_SIZE,
                         LLI_COPY_QUANTIZE,
                         liDithering,
                         liScale,
                         liColors,
                         LLI_VOID_PARAM,
                         LLI_VOID_PARAM,
                         LLI_VOID_PARAM );
    IdleOff;

    if ( liDisImage = 0 ) then
    begin
        liDisImage := liOriImage;
    end;
    liOriImage := 0;
    BackGroundColor := TImageWindow(Owner).BackGroundColor;
end;

{******************************************************************************}

procedure TImageInWindow.SaveAs( FileName: String; liFileFormat, liCompress: LongInt );
  {Save an image in a certain format}
var
    iBitsInImage : Integer;
    szTmp        : Array[0..255] of char;
    Ownr         : TImageWindow;
begin

    Ownr := TImageWindow( Owner );

{$ifdef DataAware}

    if ( liFileFormat = LLI_DISK_AUTO ) then
        liFileFormat := LLI_DISK_BMP;

    if ( ( Ownr.DataSource <> nil ) and
         ( Ownr.DataSource.DataSet <> nil ) and
         ( Ownr.DataField <> '' ) ) then
    begin
        { saving the image to a TBlobfield in the attached DataLink }
        Ownr.AcceptUpdate := False;

        if ( Ownr.DatabaseEngineType = detSDE ) and
           ( Ownr.DataSource.Dataset.FieldByName( Ownr.DataField ) is TMemoField ) then { SuccessWare Database Engine }
        begin
{$ifdef SDE}
            { doing no "Edit" here, because SDE circumvents the system }
            SaveAsMemo( TMemoField( Ownr.DataSource.Dataset.FieldByName( Ownr.DataField ) ) );
            {  doing no "Post" here, because SDE circumvents the system }
{$endif}
        end
        else
        if ( Ownr.DatabaseEngineType = detBDE ) and
           ( Ownr.DataSource.Dataset.FieldByName( Ownr.DataField ) is TBlobField ) then { Borland Database Engine }
        begin
            Ownr.FDataLink.Edit;

            if ( Ownr.BlobCompression = bcStream ) then
                SaveToStream( TBlobField( Ownr.DataSource.Dataset.FieldByName( Ownr.DataField ) ), liFileFormat, liCompress )
            else
                SaveAsBlob( TBlobField( Ownr.DataSource.Dataset.FieldByName( Ownr.DataField ) ) );

            Ownr.DataSource.DataSet.Post;
        end;

        Ownr.AcceptUpdate := True;
        exit;
    end;

{$endif}

    { saving the image to a file }
    if ( FileName <> '' ) then
    begin

        StrPCopy( PChar(@szTmp), FileName );

        iPut( liDisImage,
              LLI_FULL_SIZE,
              LLI_FULL_SIZE,
              LLI_FULL_SIZE,
              LLI_FULL_SIZE,
              LLI_DISK,
              liFileFormat,
              0,
              0,
              Longint( @szTmp ),
              LongInt( liCompress ),
              LLI_VOID_PARAM,
              LLI_VOID_PARAM,
              LLI_VOID_PARAM,
              LLI_VOID_PARAM );

    end;

end;
{******************************************************************************}

{$ifdef DataAware}

procedure TImageInWindow.SaveAsBlob( ABlobField : TBlobField );
  {Save an image in a certain format}
var
    liFullImage  : LongInt;
    cFilename    : TFileName;
    szTmp        : Array[0..255] of char;

    pBlob          : Longint;
    pBuff          : Longint;
    pStrip         : Longint;
    sCount         : Integer;
    BlobSize       : Longint;
    StripSize      : Longint;
    NumberOfStrips : Integer;
    Ownr           : TImageWindow;
    BlobStream     : TBlobStream;
    Buffer         : Array[0..TLightLibStripSize] of byte;
    sWritten       : Longint;
    xtmp           : String;
    liBlobCompress : Longint;
begin

    liFullImage := liDisImage;
    Ownr := TImageWindow( Owner );

{$ifdef Win32}
    if ( ABlobField.DataType in [ftBlob..ftTypedBinary] ) then
{$else}
    if ( ABlobField.DataType in [ftBlob] ) then
{$endif}
    begin

        case ( TImageWindow( Owner ).BlobCompression ) of
            bcNone:
                liBlobCompress := LLO_COMPRESSION_NONE;
            bcSpeed:
                liBlobCompress := LLO_COMPRESSION_SPEED;
            else
                begin
                    liBlobCompress := LLO_COMPRESSION_SIZE;
                    if ( Bits = 1 ) then  liBlobCompress := liBlobCompress + LLO_GENERIC_COMPRESSION_SIZE;
                end;
        end;

        pBlob := oCopy( TImageWindow(Owner).liLightLibApp,            { Light Lib Application  }
                        liFullImage,              { Light Lib Object Image }
                        LLO_COPY_BLOB,            { make a blob            }
                        liBlobCompress,
                        Longint(TLightLibStripSize), { StripSize = 2048    }
                        0 );

        if ( pBlob <> 0 ) then
        begin
            { set the base to zero }
            oAssign ( TImageWindow(Owner).liLightLibApp, LLO_APPLICATION_OPTION_BASE, 0, 0 );

            { get the size of the blob }
            NumberOfStrips := oAccess( pBlob, LLO_BLOB_STRIP_COUNT, 0 );
            BlobSize       := oAccess( pBlob, LLO_BLOB_SIZE, 0 );

            BlobStream     := TBlobStream.Create( ABlobField, bmWrite );

            { write each strip to the container }
            for sCount := 0 to NumberOfStrips -1 do
            begin
                pStrip    := oAccess( pBlob, LLO_BLOB_STRIP_PTR, sCount );
                sWritten := BlobStream.Write( Pointer( pStrip )^, TLightLibStripSize );
            end;

            BlobStream.Free;
            pBlob := oDel( pBlob );
        end;

    end; { if TBlobfield }

end;

{$endif}

{******************************************************************************}

{$ifdef DataAware}

procedure TImageInWindow.SaveToStream( ABlobField : TBlobField; liFormat, liCompress: Longint );
  {Save an image in a certain format}
var
    Ownr       : TImageWindow;
    BlobStream : TBlobStream;
begin

    Ownr := TImageWindow( Owner );

{$ifdef Win32}
    if ( ABlobField.DataType in [ftBlob..ftTypedBinary] ) then
{$else}
    if ( ABlobField.DataType in [ftBlob] ) then
{$endif}
    begin

        IdleOn( 20 );

        BlobStream := TBlobStream.Create( ABlobField, bmWrite );

        iPut( liDisImage,
              LLI_FULL_SIZE,
              LLI_FULL_SIZE,
              LLI_FULL_SIZE,
              LLI_FULL_SIZE,
              LLI_USER_STREAM,
              liFormat,
              0,
              0,
              Longint( BlobStream ),
              LongInt( liCompress ),
              LLI_VOID_PARAM,
              LLI_VOID_PARAM,
              LLI_VOID_PARAM,
              LLI_VOID_PARAM );

        BlobStream.Free;

        IdleOff;

    end; { if TBlobfield }

end;

{$endif}

{******************************************************************************}

{$ifdef SDE}
    {$ifdef DataAware}

procedure TImageInWindow.SaveAsMemo( AMemoField : TMemoField );
var
    liFullImage  : LongInt;
    szTmp        : Array[0..255] of char;
    Ownr         : TImageWindow;
    liFileFormat : Longint;
    oMark        : TBookMark;
begin

    liFullImage := liDisImage;
    Ownr := TImageWindow( Owner );

    if ( Ownr.ImageType in [itAuto] ) then
        liFileFormat    := LLI_DISK_BMP
    else if ( Ownr.ImageType in [itBitmap] ) then
        liFileFormat    := LLI_DISK_BMP
    else if ( Ownr.ImageType in [itGif] ) then
        liFileFormat    := LLI_DISK_GIF
    else if ( Ownr.ImageType in [itJpeg] ) then
        liFileFormat    := LLI_DISK_JPG
    else if ( Ownr.ImageType in [itPcx] ) then
        liFileFormat    := LLI_DISK_PCX
    else if ( Ownr.ImageType in [itPing] ) then
        liFileFormat    := LLI_DISK_PNG
    else if ( Ownr.ImageType in [itTarga] ) then
        liFileFormat    := LLI_DISK_TGA
    else if ( Ownr.ImageType in [itTiff] ) then
        liFileFormat    := LLI_DISK_TIF;


    if ( Assigned( AMemoField ) ) and
       ( AMemoField.DataType in [ftMemo] ) then
    begin

        with Ownr.DataSource do
        begin
            if ((State = dsEdit) or (State = dsInsert)) then
                DataSet.Post;

            oMark := DataSet.GetBookMark;
            if (oMark <> Nil) then
            begin
                DbiSetToBookMark(DataSet.Handle, oMark);
                DataSet.FreeBookMark(oMark);
            end;

            if (@fpSxSelect = Nil) then
            {$ifdef Win32}
                @fpSxSelect:=GetProcAddress(GetModuleHandle('SDE2532'), 'sx_Select');
            {$else}
                @fpSxSelect:=GetProcAddress(GetModuleHandle('SDE2016'), 'sx_Select');
            {$endif}


            if ( @fpSxSelect <> Nil ) then
                fpSxSelect(word(DataSet.Handle));
        end;

        StrPCopy( PChar(@szTmp), Ownr.DataField );

        IdleOn( 20 );

        TImageWindow(Owner).ErrorDialogEnabled := False;

        iPut( liFullImage,
              LLI_FULL_SIZE,
              LLI_FULL_SIZE,
              LLI_FULL_SIZE,
              LLI_FULL_SIZE,
              LLI_STREAM_SDE,
              liFileFormat,
              0,
              0,
              Longint( @szTmp ),
              LLI_DISK_COMPRESS_AUTO,
              LLI_VOID_PARAM,
              LLI_VOID_PARAM,
              LLI_VOID_PARAM,
              LLI_VOID_PARAM );

        TImageWindow(Owner).ErrorDialogEnabled := True;

        IdleOff;

        Ownr.DataSource.DataSet.Refresh;


    end; { if TMemoField }

end;

    {$endif} {DataAware}
{$endif} {SDE}

{******************************************************************************}

procedure TImageInWindow.PrintByDialog( oStart, oEnd : TPoint );
var
    oDialog                   : TDlgPrintImage;

    liFullImage               : LongInt;
    liPrintImage              : LongInt;
    liTmpImage                : LongInt;

    lClearFull                : Boolean;
    lClearPrint               : Boolean;
    lAll                      : Boolean;
    iPrintAvaiSizeHoriPixels  : LongInt;
    iPrintAvaiSizeVertPixels  : LongInt;
    iPrintRequSizeHoriPixels  : LongInt;
    iPrintRequSizeVertPixels  : LongInt;
    iPrintGoodSizeHoriPixels  : LongInt;
    iPrintGoodSizeVertPixels  : LongInt;
    iOffSetHoriPixels         : LongInt;
    iOffSetVertPixels         : LongInt;
    iMarginLeftPixels         : LongInt;
    iMarginRightPixels        : LongInt;
    iMarginTopPixels          : LongInt;
    iMarginBottomPixels       : LongInt;
    iImageDpiHori             : LongInt;
    iImageDpiVert             : LongInt;
    iPrinterDpiHori           : LongInt;
    iPrinterDpiVert           : LongInt;
    iImageSizeHori            : LongInt;
    iImageSizeVert            : LongInt;
    iWidth                    : LongInt;
    iHeight                   : LongInt;
    oAreaStart                : TPoint;
    oAreaEnd                  : TPoint;
    iWinWidth                 : LongInt;
    iWinHeight                : LongInt;
    oCanvasArea               : TImageDimension;
    iTbLocation               : Integer;
    oOrigin                   : TPoint;
    iToolBarOffSetStartX      : LongInt;
    iToolBarOffSetStartY      : LongInt;
    iToolBarOffSetEndX        : LongInt;
    iToolBarOffSetEndY        : LongInt;
    oResult                   : Integer;
    iResize                   : Integer;
    pHandle                   : HDC;
    liHeight,
    liWidth                   : LongInt;

begin
    oDialog := TDlgPrintImage.Create(Self);

    { Init of control fields }

    if  (( oStart.X = oEnd.X ) and ( oStart.Y = oEnd.Y ))       then
        lAll := True
    else
        lAll := False;
{
    oDialog.SleMarginTop.Text      := '1' + DecimalSeparator + '5';
    oDialog.SleMarginBottom.Text   := '1' + DecimalSeparator + '5';
    oDialog.SleMarginLeft.Text     := '1' + DecimalSeparator + '0';
    oDialog.SleMarginRight.Text    := '1' + DecimalSeparator + '0';
}
    oDialog.SleMarginTop.Text      := '0';
    oDialog.SleMarginBottom.Text   := '0';
    oDialog.SleMarginLeft.Text     := '0';
    oDialog.SleMarginRight.Text    := '0';

    oDialog.RbAll.Checked          := lAll;
    oDialog.RbCropped.Checked      := not( lAll );
    oDialog.RbCropped.Enabled      := not( lAll );

    oDialog.SleResize.Text         := '100';

    oDialog.CbVertically.Checked   := True;
    oDialog.CbHorizontally.Checked := True;

    { calculate the selected area with actual zoom }
    oAreaStart.X := iCurrentX + Round( oStart.X / GetInternalZoomX );
    oAreaStart.Y := iCurrentY + Round( oStart.Y / GetInternalZoomY );
    oAreaEnd.X   := iCurrentX + Round( oEnd.X / GetInternalZoomX );
    oAreaEnd.Y   := iCurrentY + Round( oEnd.Y / GetInternalZoomY );

    { now do the dialog }
    oResult := oDialog.ShowModal;

    if ( oResult = 1 ) then { print button was pressed }
    begin
        iImageDpiHori := Density;
        iImageDpiVert := Density;

        if iImageDpiHori = 0 then iImageDpiHori := 300;
        if iImageDpiVert = 0 then iImageDpiVert := 300;

        if ( oDialog.RbAll.Checked ) then
        begin
            { Need to print the whole image }
            liFullImage    := liDisImage;
            iImageSizeHori := DisWidth;
            iImageSizeVert := DisHeight;
            lClearFull     := False;
        end
        else { oDialog.RbAll.Checked }
        begin
            { Just print the selected area }
            IdleOn(20);
             { Clone a part of the original image }
            liFullImage := iCopy( liDisImage,
                                  LongInt( oAreaStart.X ),
                                  LongInt( oAreaStart.Y ),
                                  LongInt( oAreaEnd.X ),
                                  LongInt( oAreaEnd.Y ),
                                  LLI_COPY_CLONE,
                                  LLI_VOID_PARAM,
                                  LLI_VOID_PARAM,
                                  LLI_VOID_PARAM,
                                  LLI_VOID_PARAM,
                                  LLI_VOID_PARAM,
                                  LLI_VOID_PARAM );
            IdleOff;

            if ( liFullImage = 0 ) then
            begin
                liFullImage := liDisImage;
                lClearFull     := False;
            end
            else
                lClearFull     := True;

            iImageSizeHori := LongInt( oAreaEnd.X ) - LongInt( oAreaStart.X );
            iImageSizeVert := LongInt( oAreaEnd.Y ) - LongInt( oAreaStart.Y );

        end; { oDialog.RbAll.Checked }

        { get resolutions of printer }
        iPrinterDpiHori     := oDialog.ResHoriDpi;
        iPrinterDpiVert     := oDialog.ResVertDpi;

        { calculate margins in pixels in response to printer resolution }
        iMarginTopPixels    := Round( oDialog.fMarginTop * iPrinterDpiVert );
        iMarginBottomPixels := Round( oDialog.fMarginBottom * iPrinterDpiVert );
        iMarginLeftPixels   := Round( oDialog.fMarginLeft * iPrinterDpiHori );
        iMarginRightPixels  := Round( oDialog.fMarginRight * iPrinterDpiHori );

        { the available size is total size minus margins }
        iPrintAvaiSizeHoriPixels := oDialog.SizeHoriPixel - iMarginLeftPixels - iMarginRightPixels;
        iPrintAvaiSizeVertPixels := oDialog.SizeVertPixel - iMarginTopPixels - iMarginBottomPixels;

        { calculate the required horizontal and vertical size }

        iResize := oDialog.iResize; { get desired percentage }

        iPrintRequSizeHoriPixels :=  Round( iImageSizeHori * iPrinterDpiHori / iImageDpiHori * iResize / 100 );
        iPrintRequSizeVertPixels :=  Round( iImageSizeVert * iPrinterDpiVert / iImageDpiVert * iResize / 100 );

        { take care of the horizontal sizes }
        if ( iPrintRequSizeHoriPixels <= iPrintAvaiSizeHoriPixels ) then
        begin
            { The size of the image to be printed is smaller than available size }
            if ( oDialog.CbHorizontally.Checked ) then
                { Offset is equal to left margin + extra size / 2 }
                iOffSetHoriPixels := iMarginLeftPixels + Round((iPrintAvaiSizeHoriPixels-iPrintRequSizeHoriPixels)/2)
            else
                { Offset is equal to left margin }
                iOffSetHoriPixels := iMarginLeftPixels;

            iPrintGoodSizeHoriPixels := iPrintRequSizeHoriPixels;
        end
        else
        begin
            { The size of the image to be printed is larger than available size }
            iOffSetHoriPixels        := iMarginLeftPixels;
            iPrintGoodSizeHoriPixels := iPrintAvaiSizeHoriPixels;
        end;

        { take care of the vertical sizes }
        if ( iPrintRequSizeVertPixels <= iPrintAvaiSizeVertPixels ) then
        begin
            { The size for the image to be printed is smaller than available size }
            if ( oDialog.CbVertically.Checked ) then
                { Offset is equal to Top margin + extra size / 2 }
                iOffSetVertPixels := iMarginTopPixels + Round((iPrintAvaiSizeVertPixels-iPrintRequSizeVertPixels)/2)
            else
                { Offset is equal to Top margin }
                iOffSetVertPixels := iMarginTopPixels;

            iPrintGoodSizeVertPixels := iPrintRequSizeVertPixels;
        end
        else
        begin
            { The size of the image to be printed is larger than available size }
            iOffSetVertPixels := iMarginTopPixels;
            iPrintGoodSizeVertPixels := iPrintAvaiSizeVertPixels;
        end;

        IdleOn( 20 );

        { Zoom the original image }
        liPrintImage := iCopy( liFullImage,
                               LLI_FULL_SIZE,
                               LLI_FULL_SIZE,
                               LLI_FULL_SIZE,
                               LLI_FULL_SIZE,
                               LLI_COPY_ZOOM,
                               iPrintRequSizeHoriPixels,
                               iPrintRequSizeVertPixels,
                               LLI_VOID_PARAM,
                               LLI_VOID_PARAM,
                               LLI_VOID_PARAM,
                               LLI_VOID_PARAM );

        if ( liPrintImage = 0 ) then
        begin
            liPrintImage := liFullImage;
            lClearPrint  := False;
        end
        else
            lClearPrint  := True;

        pHandle := oDialog.PrinterHandle;

        iPut( liPrintImage,
              0,
              0,
              iPrintGoodSizeHoriPixels,
              iPrintGoodSizeVertPixels,
              LLI_PRINTER,
              pHandle,
              iOffSetHoriPixels,
              iOffSetVertPixels,
              LLI_VOID_PARAM,
              LLI_VOID_PARAM,
              LLI_VOID_PARAM,
              LLI_VOID_PARAM,
              LLI_VOID_PARAM,
              LLI_VOID_PARAM );

        IdleOff;

        if ( lClearFull ) then
            liFullImage := oDel( liFullImage );

        if ( lClearPrint ) then
            liPrintImage := oDel( liPrintImage );

        oDialog.Hide;

    end; { oResult = 1 }

    oDialog.Free;
    Display( True );
end;

{******************************************************************************}

procedure TImageInWindow.Print( SourceRect, DestRect : TRect; pHandle : HDC; AFitStyle: TFitStyle );
Var
    liFitStyle    : Longint;
    OldBackColor  : TColor;
begin

    case ( AFitStyle ) of
        fsNone:   liFitStyle := 0;
        fsWidth:  liFitStyle := 1;
        fsHeight: liFitStyle := 2;
        fsWindow: liFitStyle := 3;
        fsBest:   liFitStyle := 4;
    end;

    OldBackColor  := BackGroundColor;
    BackGroundColor := clWhite;

    iPut( liDisImage,
          SourceRect.Left,
          SourceRect.Top,
          SourceRect.Right,
          SourceRect.Bottom,
          LLI_PRINTER,
          pHandle,
          DestRect.Left,
          DestRect.Top,
          LLI_PRINT_NOTHING,
          LLI_PRINT_NOTHING,
          DestRect.Right,
          DestRect.Bottom,
          liFitStyle,
          LLI_VOID_PARAM );
          
    BackGroundColor := OldBackColor;

end;

{******************************************************************************}

procedure TImageInWindow.Resize( NewWidth, NewHeight : Longint );
Var
    TmpImage: Longint;
begin
    { Resize the image to NewWidth and NewHeight.
      This affects the actual size of the image in memory! }
    TmpImage := iCopy( liDisImage,
                       LLI_FULL_SIZE,
                       LLI_FULL_SIZE,
                       LLI_FULL_SIZE,
                       LLI_FULL_SIZE,
                       LLI_COPY_ZOOM,
                       NewWidth,
                       NewHeight,
                       LLI_VOID_PARAM,
                       LLI_VOID_PARAM,
                       LLI_VOID_PARAM,
                       LLI_VOID_PARAM );
    if ( TmpImage <> 0 ) then
    begin
        liDisImage := oDel( liDisImage );
        liDisImage := TmpImage;
        BackGroundColor := TImageWindow(Owner).BackGroundColor;
    end;
end;

{******************************************************************************}

procedure TImageInWindow.Crop( oStart, oEnd : TPoint );
Var
    oAreaStart : TPoint;
    oAreaEnd   : TPoint;
    liWidth,
    liHeight   : LongInt;
begin

    oAreaStart.X := iCurrentX + Round(oStart.X / GetInternalZoomX );
    oAreaStart.Y := iCurrentY + Round(oStart.Y / GetInternalZoomY );

    oAreaEnd.X := iCurrentX + Round(oEnd.X / GetInternalZoomX);
    oAreaEnd.Y := iCurrentY + Round(oEnd.Y / GetInternalZoomY);

    liOriImage := liDisImage;
    IdleOn(20);

    { Clone a part of the original image }

    liDisImage := iCopy( liOriImage,
                         LongInt( oAreaStart.X ),
                         LongInt( oAreaStart.Y ),
                         LongInt( oAreaEnd.X ),
                         LongInt( oAreaEnd.Y ),
                         LLI_COPY_CLONE,
                         LLI_VOID_PARAM,
                         LLI_VOID_PARAM,
                         LLI_VOID_PARAM,
                         LLI_VOID_PARAM,
                         LLI_VOID_PARAM,
                         LLI_VOID_PARAM );

    IdleOff;
    if ( liDisImage = 0 ) then
    begin
        liDisImage := liOriImage;
        liOriImage := 0;
    end
    else
    begin
        liOriImage := oDel( liOriImage )
    end;
    BackGroundColor := TImageWindow(Owner).BackGroundColor;
end;

{******************************************************************************}

procedure TImageInWindow.Grab( liScreenGrabMode : LongInt );
Var
    liNewImage : LongInt;
    liHandle   : LongInt;
begin
    { Get an image from the screen }

    liHandle :=  LongInt( TImageWindow(Owner).Handle );

    liNewImage := iGet( TImageWindow(Owner).liLightLibApp,
                        LLI_SCREEN,
                        LLI_SCREEN_WINDOW_HANDLE,
                        0,
                        0,
                        LLI_FULL_SIZE,
                        LLI_FULL_SIZE,
                        liScreenGrabMode,
                        liHandle,
                        LLI_VOID_PARAM,
                        LLI_VOID_PARAM,
                        LLI_VOID_PARAM,
                        LLI_VOID_PARAM
                      );

    if ( liNewImage <> 0 ) then
    begin
        Clear;
        liDisImage := liNewImage;
        BackGroundColor := TImageWindow(Owner).BackGroundColor;
    end;

end;

{******************************************************************************}

function TImageInWindow.Colors: LongInt;
begin
    { Get the number of colors in an image  }
    Result := ( Longint(1) shl Bits );
end;

{******************************************************************************}

function TImageInWindow.Density: LongInt;
begin
    { Get the density of an image  }
    if ( liDisImage <> 0 ) then
        Result := oAccess( liDisImage,LLI_IMAGE_DENSITY,LLI_VOID_PARAM)
    else
        Result := 0;
end;
{******************************************************************************}

function TImageInWindow.DisHeight: LongInt;
begin
    { Get the height of the displayable image   }
    if ( liDisImage <> 0 ) then
        Result := oAccess( liDisImage, LLI_IMAGE_HEIGHT, LLI_VOID_PARAM )
    else
        Result := 0
end;

{******************************************************************************}

function TImageInWindow.DisWidth: LongInt;
begin
    { Get the width of the displayable image   }
    if ( liDisImage <> 0 ) then
        Result := oAccess( liDisImage, LLI_IMAGE_WIDTH, LLI_VOID_PARAM )
    else
        Result := 0
end;

{******************************************************************************}

function TImageInWindow.OriHeight: LongInt;
begin
    { Get the height of the original image   }
    if ( liOriImage <> 0 ) then
        Result := oAccess( liOriImage, LLI_IMAGE_HEIGHT, LLI_VOID_PARAM )
    else
        Result := 0
end;

{******************************************************************************}

function TImageInWindow.OriWidth: LongInt;
begin
    { Get the width of the original image   }
    if ( liOriImage <> 0 ) then
        Result := oAccess( liOriImage, LLI_IMAGE_WIDTH, LLI_VOID_PARAM )
    else
        Result := 0
end;

{******************************************************************************}

procedure TImageInWindow.Display( EraseGround : Boolean );
    { Display the image inside the windows
      if hDc is not equal to 0, the method assumes the use of the
      window handle, else it will use the Device Context }
var
    oCanvas    : TImageDimension;
    iOriX      : LongInt;
    iOriY      : LongInt;
    iWinWidth  : LongInt;
    iWinHeight : LongInt;
    oScrollVer : TScrollBar;
    oScrollHor : TScrollBar;
    iHeight    : LongInt;
    iWidth     : LongInt;
    liPalette  : LongInt;
    hTest      : THandle;
    OwnerWin   : TImageWindow;
    DrawRect   : TRect;
    tiDim      : TImageDimension;
    FitStyle   : TFitStyle;
    liFitStyle : Longint;
    tmpZoom    : Double;

    FrameRatio : Double;
    ImageRatio : Double;

    DestX, DestY : Longint;
begin

    if ( liDisImage <> 0 ) then
    begin

        OwnerWin := TImageWindow( Owner );
        oCanvas    := LLGetCanvasArea( TImageWindow( Owner ) );
        iWinWidth  := oCanvas.Width - 1;
        iWinHeight := oCanvas.Height - 1;
        iOriX      := oCanvas.Left;
        iOriY      := oCanvas.Top;

        iWidth     := DisWidth;
        iHeight    := DisHeight;

        if (iWidth = 0 ) then iWidth := 1;
        if (iHeight = 0 ) then iHeight := 1;

        FitStyle := TImageWindow(owner).FitStyle;
        case ( FitStyle ) of
            fsNone:
                begin
                    liFitStyle := 0;
                    tmpZoom := TImageWindow(owner).ZoomFactor;
                end;
            fsWidth:
                begin
                    liFitStyle := 1;
                    tmpZoom := iWinWidth / iWidth;
                end;
            fsHeight:
                begin
                    liFitStyle := 2;
                    tmpZoom := iWinHeight / iHeight;
                end;
            fsWindow:
                begin
                    liFitStyle := 3;
                    tmpZoom := 1.0;
                end;
            fsBest:
                begin
                    liFitStyle := 4;
                    { determine which is the best fit (Width or Height) }
                    if ( iHeight <> 0 ) then
                        ImageRatio := iWidth / iHeight
                    else
                        ImageRatio := 0;
                    if ( iWinHeight <> 0 ) then
                        FrameRatio := iWinWidth / iWinHeight
                    else
                        FrameRatio := 0;

                    if ( ImageRatio > FrameRatio ) then
                        tmpZoom := iWinWidth / iWidth
                    else
                        tmpZoom := iWinHeight / iHeight;

                end;
        end;

        if ( tmpZoom > -0.001 )and
           ( tmpZoom < 0.001 ) then tmpZoom := 0.001;

        if ( FitStyle <> fsWindow ) then
        begin
            iWidth  := Round( iWidth * tmpZoom );
            iHeight := Round( iHeight * tmpZoom );
        end
        else
        begin
            iWidth  := iWinWidth;
            iHeight := iWinHeight;
        end;

        { calculate the size of the visible image }

        if ( EraseGround ) then
        begin
            if ( iWidth < iWinWidth ) or
               ( iHeight < iWinHeight ) then
            begin
                tiDim := LLGetCanvasArea( OwnerWin );

                if ( OwnerWin.SelectionEnabled ) then OwnerWin.FCaptureIsVisible := FALSE;

                OwnerWin.Canvas.Pen.Color   := clBlack;
                OwnerWin.Canvas.Brush.Color := OwnerWin.BackGroundColor;

                if ( iHeight < iWinHeight ) then
                begin
                    DrawRect.Left      := tiDim.Left;
                    DrawRect.Top       := tiDim.Top + iHeight;
                    DrawRect.right     := ( tiDim.Left + tiDim.Width );
                    DrawRect.bottom    := ( tiDim.Top + tiDim.Height );
                    OwnerWin.Canvas.FillRect( DrawRect );
                end;

                if ( iWidth < iWinWidth ) then
                begin
                    DrawRect.Left      := tiDim.Left + iWidth;
                    DrawRect.Top       := tiDim.Top;
                    DrawRect.right     := ( tiDim.Left + tiDim.Width );
                    DrawRect.bottom    := ( tiDim.Top + tiDim.Height);
                    OwnerWin.Canvas.FillRect( DrawRect );
                end;

            end;

        end;

        { Manage horizontal scrollbar}
        oScrollHor := TScrollBar( TImageWindow( owner ).FoHorzScroll );
        iCurrentX  := 0;

        if ( oScrollHor <> nil ) then
        begin
            if lFirstDisplay then
            begin
                oScrollHor.Position := 0;
            end;

            if ( iWidth <= iWinWidth ) then
                oScrollHor.Position := 0
            else
                iCurrentX := Round( ( ( oScrollHor.Position * (iWidth - iWinWidth) ) / 100 ) / tmpZoom );
        end;

        { Manage vertical scrollbar }
        iCurrentY  := 0;
        oScrollVer := TScrollBar( TImageWindow(owner).FoVertScroll );

        if ( oScrollVer <> nil ) then
        begin
            if lFirstDisplay then
            begin
                oScrollVer.Position := 0;
                lFirstDisplay := False;
            end;

            if ( iHeight <= iWinHeight ) then
                oScrollVer.Position := 0
            else
            begin
                iCurrentY := Round( ( ( oScrollVer.Position * (iHeight - iWinHeight) ) / 100 ) / tmpZoom );
            end;
        end;

        { choose palette style }
        if lPaletteShared then
            liPalette := LongInt( LLI_PALETTE_SHARED )
        else
            liPalette := LongInt( LLI_PALETTE_EXCLUSIVE );


        hTest := TImageWindow(owner).handle;

        { display the image }
        if ( FitStyle = fsNone ) then { in this case we can zoom }
        begin
            iPut( liDisImage,
                  iCurrentX,
                  iCurrentY,
                  iCurrentX + Round( iWinWidth / tmpZoom ),
                  iCurrentY + Round( iWinHeight / tmpZoom ),
                  LLI_SCREEN,
                  LLI_SCREEN_WINDOW_HANDLE,
                  iOriX,
                  iOriY,
                  Longint( hTest ),
                  liPalette,
                  iOriX + min( iWinWidth, iWidth),
                  iOriY + min( iWinHeight, iHeight),
                  2, { height fit }
                  LLI_VOID_PARAM );
            end
        else  { there is a fit style, so wa can not zoom }
        begin
            iPut( liDisImage,
                  iCurrentX,
                  iCurrentY,
                  -1,
                  -1,
                  LLI_SCREEN,
                  LLI_SCREEN_WINDOW_HANDLE,
                  iOriX,
                  iOriY,
                  Longint( hTest ),
                  liPalette,
                  iOriX + iWinWidth,
                  iOriY + iWinHeight,
                  liFitStyle,
                  LLI_VOID_PARAM );
        end;

        { redraw the capture rectangle if it was visible before }
        if ( OwnerWin.CaptureIsVisible and OwnerWin.SelectionEnabled ) then
        begin
            OwnerWin.Canvas.Brush.Style := bsClear;
            OwnerWin.Canvas.Pen.Width   := OwnerWin.SelectionWidth;
            OwnerWin.Canvas.Pen.Style   := OwnerWin.SelectionStyle;
            OwnerWin.Canvas.Pen.Color   := OwnerWin.SelectionColor;
            OwnerWin.Canvas.Pen.Mode    := pmNotXor;

            { draw the old rectangle to erase old frame }
            Drawrect.left   := min( OwnerWin.CaptureRect.left, OwnerWin.CaptureRect.right );
            Drawrect.right  := max( OwnerWin.CaptureRect.left, OwnerWin.CaptureRect.right );
            Drawrect.top    := min( OwnerWin.CaptureRect.top, OwnerWin.CaptureRect.bottom );
            Drawrect.bottom := max( OwnerWin.CaptureRect.top, OwnerWin.CaptureRect.bottom );

            OwnerWin.Canvas.Rectangle(  Drawrect.left,  Drawrect.top,
                                        Drawrect.right, Drawrect.bottom);

            OwnerWin.Canvas.Pen.Mode    := pmCopy;
        end;

    end;

end;


{******************************************************************************}

procedure TImageInWindow.Scan( cFileName : TFileName );
Var
    liNewImage : LongInt;
    szTmp      : Array[0..255] of char;
begin

    { Aquire an image from a scanner and store it to cFileName }

    IdleOn(20);

    { Scan the image and store it in liNewImage }
    liNewImage := iGet( TImageWindow(Owner).liLightLibApp,
                        LLI_SCANNER,
                        LLI_SCANNER_TWAIN,
                        0,
                        0,
                        LLI_FULL_SIZE,
                        LLI_FULL_SIZE,
                        LLI_VOID_PARAM,
                        LLI_VOID_PARAM,
                        LLI_VOID_PARAM,
                        LLI_VOID_PARAM,
                        LLI_VOID_PARAM,
                        LLI_VOID_PARAM );

    IdleOff;

    If ( liNewImage <> 0 ) then
    begin

        Clear;
	liDisImage := liNewImage;
        BackGroundColor := TImageWindow(Owner).BackGroundColor;

        if not( cFileName = '' ) then
        begin
        { Save the scanned image into the choosen file }

            StrPCopy( PChar(@szTmp), cFileName );

 	    iPut( liDisImage,
                  LLI_FULL_SIZE,
                  LLI_FULL_SIZE,
                  LLI_FULL_SIZE,
                  LLI_FULL_SIZE,
                  LLI_DISK,
                  LLI_DISK_AUTO,
                  0,
                  0,
                  LongInt( @szTmp ),
                  LLI_VOID_PARAM,
                  LLI_VOID_PARAM,
                  LLI_VOID_PARAM,
                  LLI_VOID_PARAM,
                  LLI_VOID_PARAM );

        end; { cFileName = '' }
    end
    else
    begin

        If ( liDisImage = 0 ) then
        begin
            { If no image was previously loaded,
              default with a "from memory" black image }
            MemoryImage(0,0,0,0);

        end;

    end;

end;

{******************************************************************************}

function TImageInWindow.ScanSilent( cFileName : TFileName ): Boolean;
Var
    liNewImage : LongInt;
    szTmp      : Array[0..255] of char;
begin
    Result := False;
    { Aquire an image from a scanner and store it to cFileName }

    IdleOn(20);
    {
      Scan the image and store it in liNewImage
      without showind a scan dialog
    }

    liNewImage := iGet( TImageWindow(Owner).liLightLibApp,
                        LLI_SCANNER,
                        LLI_SCANNER_TWAIN,
                        0,
                        0,
                        LLI_FULL_SIZE,
                        LLI_FULL_SIZE,
                        LLI_VOID_PARAM,
                        TImageWindow(Owner).Twain.LLTwainObject,
                        LLI_VOID_PARAM,
                        LLI_VOID_PARAM,
                        LLI_VOID_PARAM,
                        LLI_VOID_PARAM );

    IdleOff;

    if ( liNewImage <> 0 ) then
    begin
        Result := True;

        Clear;
	liDisImage := liNewImage;
        BackGroundColor := TImageWindow(Owner).BackGroundColor;

        if not( cFileName = '' ) then
        begin
        { Save the scanned image into the choosen file }

            StrPCopy( PChar(@szTmp), cFileName );

 	    iPut( liDisImage,
                  LLI_FULL_SIZE,
                  LLI_FULL_SIZE,
                  LLI_FULL_SIZE,
                  LLI_FULL_SIZE,
                  LLI_DISK,
                  LLI_DISK_AUTO,
                  0,
                  0,
                  LongInt( @szTmp ),
                  LLI_VOID_PARAM,
                  LLI_VOID_PARAM,
                  LLI_VOID_PARAM,
                  LLI_VOID_PARAM,
                  LLI_VOID_PARAM );

        end; { cFileName = '' }
    end
    else
    begin

        If ( liDisImage = 0 ) then
        begin
            { If no image was previously loaded,
              default with a "from memory" black image }
            MemoryImage(0,0,0,0);

        end;

    end;

end;

{******************************************************************************}

procedure TImageInWindow.Fit( iFitMode: Integer );
begin
end;

{******************************************************************************}

procedure TImageInWindow.FitInWindow;
begin
end;

{******************************************************************************}

procedure TImageInWindow.FitRelease;
begin
end;

{******************************************************************************}

procedure TImageInWindow.FitRescale;
begin
end;

{******************************************************************************}

procedure TImageInWindow.FitBest;
begin
end;

{******************************************************************************}

procedure TImageInWindow.FitToHeight;
begin
end;

{******************************************************************************}

procedure TImageInWindow.FitToWidth;
begin
end;

{******************************************************************************}

procedure TImageInWindow.Flip( bHorz : Boolean );
begin
    { flip the image either horizontal or vertical,
    where: bHorz = TRUE  -> HORIZONTAL
           bHorz = FALSE -> VERTICAL }

    liOriImage := liDisImage;

    if ( bHorz ) then { horizontal }
    begin
        IdleOn( 20 );
        liDisImage := iCopy( liOriImage,
                             LLI_FULL_SIZE,
                             LLI_FULL_SIZE,
                             LLI_FULL_SIZE,
                             LLI_FULL_SIZE,
                             LLI_COPY_FLIP,
                             LLI_FLIP_HORIZONTAL,
                             LLI_VOID_PARAM,
                             LLI_VOID_PARAM,
                             LLI_VOID_PARAM,
                             LLI_VOID_PARAM,
                             LLI_VOID_PARAM
                           );
        IdleOff;

    end
    else  { vertical }
    begin
        IdleOn( 20 );
        liDisImage := iCopy( liOriImage,
                             LLI_FULL_SIZE,
                             LLI_FULL_SIZE,
                             LLI_FULL_SIZE,
                             LLI_FULL_SIZE,
                             LLI_COPY_FLIP,
                             LLI_FLIP_VERTICAL,
                             LLI_VOID_PARAM,
                             LLI_VOID_PARAM,
                             LLI_VOID_PARAM,
                             LLI_VOID_PARAM,
                             LLI_VOID_PARAM
                            );
        IdleOff;
    end;

    if ( liDisImage <> 0 ) then
    begin
        liOriImage := oDel( liOriImage );
    end
    else
    begin
        liDisImage := liOriImage;
        liOriImage := 0;
    end;
    BackGroundColor := TImageWindow(Owner).BackGroundColor;
end;

{******************************************************************************}

{$ifdef DataAware}
    {$ifdef SDE}

procedure TImageInWindow.LoadAsMemo;
Var
    liNewImage     : LongInt;
    szTmp          : Array[0..255] of char;
    BlobStream     : TBlobStream;
    oMark          : TBookMark;
    Ownr           : TImageWindow;
begin
    Ownr := TImageWindow( Owner );

    StrPCopy( szTmp, Ownr.DataField );

    with Ownr.DataSource.DataSet do
    begin
        oMark := GetBookMark;
        if (oMark <> Nil) then
        begin
            DbiSetToBookMark(Handle, oMark);
            FreeBookMark(oMark);
        end;

        if (@fpSxSelect = Nil) then
        {$ifdef Win32}
            @fpSxSelect:=GetProcAddress(GetModuleHandle('SDE2532'), 'sx_Select');
        {$else}
            @fpSxSelect:=GetProcAddress(GetModuleHandle('SDE2016'), 'sx_Select');
        {$endif}

        if (@fpSxSelect <> Nil) then
           fpSxSelect(word(Handle));
    end;

    IdleOn( 20 );

    {Disable the errorbox}
    TImageWindow(Owner).ErrorDialogEnabled := False;
    liNewImage := iGet( TImageWindow(Owner).liLightLibApp,
                    LLI_STREAM_SDE,
                    LLI_DISK_AUTO,
                    0,
                    0,
                    LLI_FULL_SIZE,
                    LLI_FULL_SIZE,
                    LongInt( @szTmp ),
                    LLI_VOID_PARAM,
                    LLI_VOID_PARAM,
                    LLI_VOID_PARAM,
                    LLI_VOID_PARAM,
                    LLI_VOID_PARAM );

    TImageWindow(Owner).ErrorDialogEnabled := True;
    IdleOff;

    Clear;

    if ( liNewImage <> 0 ) then
    begin
        liDisImage := liNewImage;
        BackGroundColor := TImageWindow(Owner).BackGroundColor;
    end
    else
    begin
        { if no image in current Database
          record then show a black square }
        MemoryImage( 0, 0, 0, 0 );
    end;
end;
    {$endif}
{$endif}

{******************************************************************************}
{$ifdef DataAware}

procedure TImageInWindow.LoadAsBlob( AField : TField );
Var
    liNewImage     : LongInt;
    szTmp          : Array[0..255] of char;
    pBlob          : Longint;
    pBuff          : Longint;
    pStrip         : Longint;
    sCount         : Integer;
    NumberOfStrips : Integer;
    BlobStream     : TBlobStream;
    BlobSize       : Longint;
    buff           : byte;
    Ownr           : TImageWindow;
begin
    { load an image from a blob coming out of a TBlobField }

    pBlob := oNew( LLO_CLASS_BLOB,           { make a new blob        }
                   TImageWindow(Owner).liLightLibApp,            { Light Lib Application  }
                   -1,
                   Longint( TLightLibStripSize ), { StripSize = 2048    }
                   0 );

    if ( pBlob <> 0 ) then
    begin

        { create the stream where to read from }
        BlobStream := TBlobStream.Create( TBlobField( AField ), bmRead );
        { get the size of the delphi blob }
        BlobSize := BlobStream.Seek( 0, 2 );

        if ( BlobSize > 0 ) then
        begin
             BlobStream.Seek( 0, 0 );

             { set the base to zero }
             oAssign ( TImageWindow(Owner).liLightLibApp, LLO_APPLICATION_OPTION_BASE, 0, 0 );

             { set the size of the blob }
             oAssign( pBlob, LLO_BLOB_SIZE, BlobSize, 0 );

             NumberOfStrips := ( BlobSize div TLightLibStripSize ) + 1 ;

             { write each strip to the container }

             for sCount := 0 to NumberOfStrips do
             begin
                 pStrip := oAccess( pBlob, LLO_BLOB_STRIP_PTR, sCount );
                 BlobStream.Read( Pointer( pStrip )^, TLightLibStripSize )
             end;

             IdleOn( 20 );
             liNewImage := oCopy( TImageWindow(Owner).liLightLibApp, pBlob, LLO_COPY_UNBLOB, 0, 0, 0 );
             IdleOff;
        end;

        BlobStream.Free;

        pBlob := oDel( pBlob );

    end;

    Clear;

    if ( liNewImage <> 0 ) then
    begin
        liDisImage := liNewImage;
        BackGroundColor := TImageWindow(Owner).BackGroundColor;
    end
    else
    begin
        { if no image in current Database
          record then show a black square }
        MemoryImage( 0, 0, 0, 0 );
    end;
end;
{$endif}

{******************************************************************************}

{$ifdef DataAware}

procedure TImageInWindow.LoadFromStream( AField : TField );
Var
    BlobStream: TBlobStream;
    liNewImage: Longint;
begin
    { create the stream where to read from }
    BlobStream := TBlobStream.Create( TBlobField( AField ), bmRead );

    liNewImage := iGet( TImageWindow(Owner).liLightLibApp,
                        LLI_USER_STREAM,
                        LLI_DISK_AUTO,
                        0,
                        0,
                        LLI_FULL_SIZE,
                        LLI_FULL_SIZE,
                        LongInt( BlobStream ),
                        LLI_VOID_PARAM,
                        LLI_VOID_PARAM,
                        LLI_VOID_PARAM,
                        LLI_VOID_PARAM,
                        LLI_VOID_PARAM );

    BlobStream.Free;

    Clear;

    if ( liNewImage <> 0 ) then
    begin
        liDisImage := liNewImage;
        BackGroundColor := TImageWindow(Owner).BackGroundColor;
    end
    else
    begin
        { if no image in current Database
          record then show a black square }
        MemoryImage( 0, 0, 0, 0 );
    end;
end;

{$endif}

{******************************************************************************}

{$ifdef DataAware}

function TImageInWindow.CheckFieldForBlob( AField: TField ): Boolean;
Var
    BlobStream: TBlobStream;
    Signature:  Array[0..11] of byte;
    nRead: Longint;
    i: Integer;
const
    ImgBlobSigature: Array[0..11] of byte = ( ord('B'), ord('L'), ord('O'), ord('B'), ord('0'), ord('1'),
                                              ord('0'), ord('1'), ord('0'), ord('0'), ord('0'), ord('0') );
begin
    { create the stream where to read from }
    BlobStream := TBlobStream.Create( TBlobField( AField ), bmRead );
    try
        nRead := BlobStream.Read( Signature, 12 );
    finally
        BlobStream.Free;
    end;

    if ( nRead = 12 ) then
    begin
        i      := 0;
        Result := True;

        while ( i < 12 ) and ( Result = True ) do
        begin
            if ( Signature[i] <> ImgBlobSigature[i] ) then
                Result := False;
            inc(i);
        end;
    end
    else
        Result := False;
end;

{$endif}

{******************************************************************************}

procedure TImageInWindow.LoadFile( FileName: TFileName;
                               Format: LongInt;{$ifdef DataAware} AField : TField; {$endif}
                               ExtraParam: Longint );
var
    liNewImage     : LongInt;
    szTmp          : Array[0..255] of char;
    Ownr           : TImageWindow;
begin

    Ownr := TImageWindow( Owner );
    liNewImage := 0;

{$ifdef DataAware}

    if Assigned( AField ) then
    begin

        if ( Ownr.DatabaseEngineType = detSDE ) and
           ( AField is TMemoField ) then { SuccessWare Database Engine }
        begin
            {$ifdef SDE}
            LoadAsMemo;
            {$endif}
        end
        else if ( Ownr.DatabaseEngineType = detBDE ) then { Borland Database Engine }
        begin
             if CheckFieldForBlob( AField ) then
                LoadAsBlob( AField )
             else
                LoadFromStream( AField );
        end;
        exit;
    end; { Assigned(AField) }

{$endif}

    { load an image from file }

    if ( Format = 0 ) then
        Format := LLI_DISK_AUTO;

    if FileExists(FileName) then
    begin

        StrPCopy( PChar(@szTmp), FileName );

        IdleOn( 20 );

        { Load the image and store it in liNewImage }
        liNewImage := iGet( TImageWindow(Owner).liLightLibApp,
                       LLI_DISK,
                       Format,
                       0,
                       0,
                       LLI_FULL_SIZE,
                       LLI_FULL_SIZE,
                       LongInt( @szTmp ),
                       ExtraParam,
                       LLI_VOID_PARAM,
                       LLI_VOID_PARAM,
                       LLI_VOID_PARAM,
                       LLI_VOID_PARAM );

        IdleOff;

        Clear;

        if (liNewImage <> 0 ) then
        begin
            liDisImage := liNewImage;
        end
        else
        begin
            if ( liDisImage = 0 ) then
            begin
                { If no image was previously loaded,
                  default with a "from memory" black image }
                MemoryImage( 0, 0, 0, 0 );
            end;
        end;

    end
    else
        MemoryImage( 0, 0, 0, 0 );

    BackGroundColor := TImageWindow(Owner).BackGroundColor;
end;

{******************************************************************************}

procedure TImageInWindow.MemoryImage(liWidth,liHeight,liColor,liMemoryModel: LongInt );
begin

    { create an image from memory

      Two kinds of use:

      this is very usefull when loading/scanning errors occur.
      Just replace the non valid load/scan image with the result of this operation.
      This ensures that all the next operations (zoom/turn/fit ....) the user will
      apply to the image will not end with an error

      Also you can use this to create a new image and then apply cut and paste
      from other images to this one
    }


    if ( DefaultImageSize = 0 ) then
    begin
        if ( liWidth = 0 ) then
            liWidth  := LLI_FULL_SIZE;

        if ( liHeight = 0 ) then
            liHeight := LLI_FULL_SIZE;

        if ( liColor = 0 ) then
            liColor := 0;

        if ( liMemoryModel = 0 ) then
            liMemoryModel := LLI_MEMORY_IMAGE_DEFAULT;
    end
    else
    begin
        if ( liWidth = 0 ) then
            liWidth := DefaultImageSize;

        if ( liHeight = 0 ) then
            liHeight := DefaultImageSize;

        if ( liColor = 0 ) then
            liColor := 0;

        if ( liMemoryModel = 0 ) then
            liMemoryModel := LLI_MEMORY_BW;
    end;

    Clear;

    { Load the image and store it in liNewImage}
    liDisImage := iGet( TImageWindow(Owner).liLightLibApp,
                        LLI_MEMORY,
                        liMemoryModel,
                        0,
                        0,
                        liWidth,
                        liHeight,
                        liColor,
                        LLI_VOID_PARAM,
                        LLI_VOID_PARAM,
                        LLI_VOID_PARAM,
                        LLI_VOID_PARAM,
                        LLI_VOID_PARAM );

    BackGroundColor := TImageWindow(Owner).BackGroundColor;

end;

{******************************************************************************}

procedure TImageInWindow.MemoryImage16( iWidth, iHeight, liColor: LongInt);
begin
    { create a 16 colors image from memory }
    MemoryImage( iWidth, iHeight, liColor, LLI_MEMORY_16 );
end;

{******************************************************************************}

procedure TImageInWindow.MemoryImage16M( iWidth, iHeight, liColor: LongInt);
begin

    { create a 16M colors images from memory }
    MemoryImage( iWidth, iHeight, liColor, LLI_MEMORY_16M );

end;

{******************************************************************************}

procedure TImageInWindow.MemoryImage256( iWidth, iHeight, liColor: LongInt );
begin
    { create a 256 colors images from memory }
    MemoryImage( iWidth, iHeight, liColor, LLI_MEMORY_256 );
end;

{******************************************************************************}

procedure TImageInWindow.MemoryImageBW( iWidth, iHeight, liColor: LongInt);
begin
    { create a black and white image from memory }
    MemoryImage( iWidth, iHeight, liColor, LLI_MEMORY_BW );
end;

{******************************************************************************}

procedure TImageInWindow.Rotate( iTurnAngle: Integer; ClipCorner : Boolean );
var
    { Rotate an image }
    fScaleSwap      : Real;
    liWidth,
    liHeight        : LongInt;
begin

    liOriImage := liDisImage;

    IdleOn(20);

        { rotate arbitrary }
    liDisImage := iCopy( liOriImage,
                         LLI_FULL_SIZE,
                         LLI_FULL_SIZE,
                         LLI_FULL_SIZE,
                         LLI_FULL_SIZE,
                         LLI_COPY_TURN,
                         iTurnAngle,
                         Longint( ClipCorner ),
                         LLI_VOID_PARAM,
                         LLI_VOID_PARAM,
                         LLI_VOID_PARAM,
                         LLI_VOID_PARAM );
    IdleOff;

    if ( liDisImage = 0 ) then
    begin
        liDisImage := liOriImage;
        liOriImage := 0;
    end
    else
    begin
        liOriImage := oDel( liOriImage );
    end;
    BackGroundColor := TImageWindow(Owner).BackGroundColor;
end;

{******************************************************************************}

procedure TImageInWindow.Zoom( fZoomFactorX, fZoomFactorY: Real );
begin
end;

{******************************************************************************}

procedure TImageInWindow.IdleOn( liTimes: LongInt );
begin
    IdleParent := TimageWindow(Owner);
    IdleChild  := TImageInWindow(Self);
    IdleParent.FoGauge.MaxValue := liTimes - 2;
    oAssign( TImageWindow(Owner).liLightLibApp, LLI_APPLICATION_IDLE, LongInt( @ImageIdle ), liTimes )
end;

{******************************************************************************}

procedure TImageInWindow.IdleOff;
begin
    oAssign( TImageWindow(Owner).liLightLibApp, LLI_APPLICATION_IDLE, LLI_VOID_PARAM, LLI_VOID_PARAM );
    IdleParent := nil;
    IdleChild  := nil;
end;




{******************************************************************************}
{*                   TImageToolBar class implementation                       *}
{******************************************************************************}

procedure TImageToolbar.BtnClick( Index: TLLToolBtns );
var
    DlgAbout   : TDlgAbout;

begin
    Case Index of
        Scan:
            begin
                TImageWindow( Parent ).Scan;
            end;

        Open:
            begin
                TImageWindow( Parent ).LoadFile('', LLI_DISK_AUTO, 0 );
            end;

        Save:
            begin
                TImageWindow( Parent ).SaveAs;
            end;

        cCopy:
            begin
                TImageWindow( Parent ).CopyToClipboard;
            end;

        Paste:
            begin
                TImageWindow( Parent ).PasteFromClipboardNew;
            end;

        Print:
            begin
                TImageWindow( Parent ).Print;
            end;

        FitBest:
            begin
                TImageWindow( Parent ).FitBest;
            end;

        FitToWidth:
            begin
                TImageWindow( Parent ).FitToWidth;
            end;

        FitToHeight:
            begin
                TImageWindow( Parent ).FitToHeight;
            end;

        FitInWindow:
            begin
                TImageWindow( Parent ).FitInWindow;
            end;

        FitRelease:
            begin
                TImageWindow( Parent ).FitRelease;
            end;

        Rotate90:
            begin
                TImageWindow( Parent ).RotateRight;
            end;

        Rotate270:
            begin
                TImageWindow( Parent ).RotateLeft;
            end;

        Rotate180:
            begin
                TImageWindow( Parent ).RotateInvert;
            end;

        FlipHorz:
            begin
                TImageWindow( Parent ).FlipHorizontal;
            end;

        FlipVert:
            begin
                TImageWindow( Parent ).FlipVertical;
            end;

        Crop:
            begin
                with TImageWindow( Parent ) do
                begin
                    if ( CaptureIsVisible ) then
                    begin
                        Crop;
                    end;
                end;
            end;

        ZoomIn:
            begin
                TImageWindow( Parent ).ZoomInByIncrement;
            end;

        ZoomOut:
            begin
                TImageWindow( Parent ).ZoomOutByIncrement;
            end;

        Palette:
            begin
                TImageWindow( Parent ).SwapSharedExclusive;
            end;

        ImageOp:
            begin
                TImageWindow( Parent ).ImageOperations;
            end;

        Info:
            begin
                TImageWindow( Parent ).Information;
            end;

        About:
            begin
       {===}     
                DlgAbout := TDlgAbout.Create( self );
                Try
                    DlgAbout.ShowModal;
                finally
                    DlgAbout.Free;
                end;
            end;

    end; { case }

end;

{******************************************************************************}
{*              Miscelanous non class functions and utilities                 *}
{******************************************************************************}

function lImgOperationComplex( liLLImage, liCaller, liDevice, liFormat: LongInt  ): Boolean;
var
    iWidth         : LongInt;
    iHeight        : LongInt;
    iBits          : LongInt;
    r4Complexity   : Real;
    r4MemorySize   : Real;
    r4SpeedFactor  : Real;
begin
  { This function abitrary determine if an operation is to be considered
    as complex or non complex. This is based on the image size and
    on the operation (iGet/iPut/iCopy) complexity.


    Decrease this number on slow machines}
    r4Complexity  := 300000;

    { Compute the size of the image in the memory, in bytes }
    iWidth        := oAccess(liLLImage,LLI_IMAGE_WIDTH ,LLI_VOID_PARAM);
    iHeight       := oAccess(liLLImage,LLI_IMAGE_HEIGHT,LLI_VOID_PARAM);
    iBits         := oAccess(liLLImage,LLI_IMAGE_BITS  ,LLI_VOID_PARAM);

    r4MemorySize  := ( ( iWidth * iHeight * iBits) div 8 );
    r4SpeedFactor := 0;


    { if the calling function is a Get operation }
    if ( liCaller = LLI_CALLER_GET ) then
    begin
        if ( liDevice = LLI_DISK ) then
            if ( liFormat = LLI_DISK_BMP ) then
                r4SpeedFactor := 1
            else if ( liFormat = LLI_DISK_PCX ) then
                r4SpeedFactor := 1.2
            else if ( liFormat = LLI_DISK_TIF ) then
                r4SpeedFactor := 1.5
            else if ( liFormat = LLI_DISK_GIF ) then
                r4SpeedFactor := 1.5
            else if ( liFormat = LLI_DISK_JPG ) then
                r4SpeedFactor := 3
            else if ( liFormat = LLI_DISK_TGA ) then
                r4SpeedFactor := 3
            else if ( liFormat = LLI_DISK_PNG ) then
                r4SpeedFactor := 3
            else
                r4SpeedFactor := 3; { COPY UNBLOB }
    end
    else if ( liCaller = LLI_CALLER_PUT ) then
    begin
        if ( liDevice = LLI_DISK ) then
        begin
            if ( liFormat = LLI_DISK_BMP ) then
                r4SpeedFactor := 1
            else if ( liFormat = LLI_DISK_PCX ) then
                r4SpeedFactor := 1
            else if ( liFormat = LLI_DISK_TIF ) then
                r4SpeedFactor := 1.5
            else if ( liFormat = LLI_DISK_GIF ) then
                r4SpeedFactor := 1.5
            else if ( liFormat = LLI_DISK_JPG ) then
                r4SpeedFactor := 3
            else if ( liFormat = LLI_DISK_TGA ) then
                r4SpeedFactor := 3
            else if ( liFormat = LLI_DISK_PNG ) then
                r4SpeedFactor := 3
            else
                r4SpeedFactor := 3; { COPY BLOB }
        end
        else if ( liDevice = LLI_PRINTER ) then
            r4SpeedFactor := 100;
    end
    else if ( liCaller = LLI_CALLER_COPY ) then
    begin
        if ( liDevice = LLI_COPY_CLONE ) then
            r4SpeedFactor := 1

        else if ( liDevice = LLI_COPY_ZOOM ) then
        begin
            r4SpeedFactor := 2 * IdleChild.fScaleX * IdleChild.fScaleY ;

            {  Zoom on smaller than byte images are slower}
            if ( iBits = 1 ) or ( iBits = 4 ) then
                r4SpeedFactor := ( r4SpeedFactor * 4 );
        end

        else if ( liDevice = LLI_COPY_TURN ) then
        begin
            r4SpeedFactor := 3 ;

            {  Turn on smaller than byte images are slower}
            if ( iBits = 1 ) or ( iBits = 4 ) then
                r4SpeedFactor := ( r4SpeedFactor * 8 );

            {  Turns 90 and 270 are slower than 180 turns}
            if ( liFormat = LLI_TURN_90 ) or ( liFormat = LLI_TURN_270 ) then
                r4Speedfactor := ( r4SpeedFactor * 2 )
            else if ( liFormat = LLI_TURN_180 ) then
                r4Speedfactor := ( r4SpeedFactor * 1 )
            else
                { in this case it is an aritrary turn }
                r4Speedfactor := ( r4SpeedFactor * 10 );
        end

        else if ( liDevice = LLI_COPY_FLIP ) then
        begin
            r4SpeedFactor := 3 ;

            if ( liFormat = LLI_FLIP_HORIZONTAL ) then
                r4Speedfactor := ( r4SpeedFactor * 2 );
        end

        else if ( liDevice = LLI_COPY_QUANTIZE ) or
                ( liDevice = LLI_COPY_FILTER ) then
            r4SpeedFactor := 10;
    end;

    {  Up to a certain size, decide if the operation is complex}
    if (r4MemorySize * r4SpeedFactor >= r4Complexity) then
        Result := True
    else
        Result := False;
end;

{******************************************************************************}

function ImageIdle( liState, liValue, liLLImage, liCaller, liDevice,
                    liFormat, liUserParam: LongInt ): LongInt;
var
    { This function is called back by the LLI.DLL during each
      iGet/iPut/iCopy operation. The harder part is to determine
      when the operation is long enough to display a gauge, and short
      enougth to not display a gauge and loose more time displaying
      the gauge than doing the asked iGet/iPut/iCopy }

    liStatusMessage : LongInt;
    iProgressHeight : LongInt;
    iProgressValue  : LongInt;
begin

    { By default, continu the process }
    liStatusMessage := LLI_IDLE_CONT;

    if ( liState = LLI_IDLE_INIT ) then
    begin

        { Warning : donot try to calculate image size at this level. When LLI_IDLE_INIT
          is called in an iGet() from disk (for example), the disk file is not open. So there
          is noy way to be able to know, at this level, infos about the image size. }

        lFirstCycle := True;
        liMaxCall := liValue;
    end

    else if ( liState = LLI_IDLE_IDLE ) then
    begin
        { determine the size of the image in the memory. All process times
          varies upon this size. }
        if lFirstCycle then
        begin
            lFirstCycle := False;

            if lImgOperationComplex( liLLImage, liCaller, liDevice, liFormat ) then
                lNeedGauge := True
            else
                lNeedGauge := False;

            Screen.Cursor := crHourglass;
        end;
        {   if the gauge is needed, update it }
        if lNeedGauge then
            IdleParent.FoGauge.Progress := liValue;
    end
    else if ( liState = LLI_IDLE_EXIT ) then
    begin
        { if a gauge was displayed, clear it }
        if lNeedGauge then
        begin
            IdleParent.FoGauge.Progress := 0;
        end;

        Screen.Cursor := crDefault;
    end;

    { Return a status message (LLI_IDLE_CONT / LLI_IDLE_ABORT) }
    Result :=  liStatusMessage;

end;

{******************************************************************************}

function LLGetCanvasArea( LLWindow: TImageWindow ): TImageDimension;
begin
    Result := LLWindow.FCanvasArea;
end;

{******************************************************************************}

function LLSetCanvasArea( LLWindow: TImageWindow ): TImageDimension;
var
    tiDim: TImageDimension;
    ToolHeight : Integer;
begin
    if ( LLWindow.ShowToolbar ) then
        ToolHeight := llWindow.FoToolbar.Height
    else
        ToolHeight := 0;

    tiDim.Top    := ( integer(llWindow.ShowToolBar) * ToolHeight + 1);
    tiDim.Left   := ( integer(llWindow.ShowGauge) * llWindow.FoGauge.Width );

    tiDim.Width  := (llWindow.Width-1) - (( integer(llWindow.ShowGauge) * llWindow.FoGauge.Width ) +
                                      ( integer(llWindow.ShowVertScroll) * llWindow.FoVertScroll.Width ));
    tiDim.Height := (llWindow.Height-1) - 1 - (( integer(llWindow.ShowToolBar) * ToolHeight ) +
                                      ( integer(llWindow.ShowHorzScroll) * llWindow.FoHorzScroll.Height ));
    result := tiDim;
end;

{******************************************************************************}

function LLSetControlSizes( LLWindow: TImageWindow ): TImageDimension;
var
    tiDim: TImageDimension;
begin

    tiDim := LLSetCanvasArea( llWindow );

    if ( LLWindow.ShowToolbar ) then
    begin
        llWindow.FoToolBar.Top       := 0;
        llWindow.FoToolBar.Left      := 18;
        llWindow.FoToolBar.Width     := llWindow.Width - 37;

        llWindow.FoLeftBtn.Top       := 0;
        llWindow.FoLeftBtn.Left      := 0;
        llWindow.FoRightBtn.Top      := 0;
        llWindow.FoRightBtn.Left     := ( llWindow.Width - 1) - llWindow.FoRightBtn.Width;
    end;

    llWindow.FoGauge.Top         := tiDim.Top;
    llWindow.FoGauge.Left        := 0;
    llWindow.FoGauge.Height      := tiDim.Height;

    llWindow.FoVertScroll.Top    := tiDim.Top+1;
    llWindow.FoVertScroll.Left   := ( llWindow.Width ) - llWindow.FoVertScroll.Width;
    llWindow.FoVertScroll.Height := tiDim.Height;

    llWindow.FoHorzScroll.Width  := tiDim.Width;
    llWindow.FoHorzScroll.Left   := tiDim.Left+1;
    llWindow.FoHorzScroll.Top    := ( llWindow.Height ) - llWindow.FoHorzScroll.Height;

    if not( llWindow.FoGauge.Visible ) then
    begin
        llWindow.FoGauge.top := llWindow.Height + 10;
    end;

    if not( llWindow.FoVertScroll.Visible ) then
    begin
        llWindow.FoVertScroll.Top := llWindow.Height + 10;
    end;

    if not( llWindow.FoHorzScroll.Visible ) then
    begin
        llWindow.FoHorzScroll.Top := llWindow.Height + 10;
    end;

    Result := tiDim;

end;


{$ifdef DataAware}
{******************************************************************************}
{ Streaming functions for native image handling with databases }
{******************************************************************************}

function streamCreate( lpImage: Longint; lpszName: Longint; fnAttribut: Integer ): Longint;
Var
    pStream : TBlobStream;
begin
    pStream := TBlobStream( lpszName );
    Result := Longint( pStream );
end;

{******************************************************************************}

function streamDelete( lpImage: Longint; lpszName: Longint ): Integer;
begin
    Result := 0;
end;

{******************************************************************************}

function streamOpen( lpImage: Longint; lpszName: Longint; fnAttribut: Integer ): Longint;
Var
    pStream : TBlobStream;
begin
    pStream := TBlobStream( lpszName );
    Result := Longint( pStream );
end;

{******************************************************************************}

function streamClose( lpImage: Longint; hf: Longint ): Longint;
begin
    Result := 0;
end;

{******************************************************************************}

function streamRead( lpImage: Longint; hf: Longint; hpvbuffer: Longint; cbBuffer: Longint ): Longint;
Var
    pStream           : TBlobStream;
    NumberOfBytesRead : Longint;
    nRead             : Longint;
    nCount, BuffCount : Longint;
    pTemp             : Longint;
begin
    pStream := TBlobStream( hf );

    NumberOfBytesRead  := 0;
    nRead              := 0;
    BuffCount          := cbBuffer;
    pTemp              := hpvbuffer;
    nCount             := 0;

    while ( BuffCount > 0 ) and ( nRead = nCount ) do
    begin
        nCount := min( 32767, BuffCount );

        nRead := pStream.Read( Pointer( pTemp )^, nCount );
        Inc( NumberOfBytesRead, nRead );
        Dec( BuffCount, nRead );
        pTemp := pTemp + nRead;

    end;

    Result := NumberOfBytesRead;
end;

{******************************************************************************}

function streamWrite( lpImage: Longint; hf: Longint; hpvbuffer: Longint; cbBuffer: Longint ): Longint;
Var
    pStream : TBlobStream;
    NumberOfBytesWritten : Longint;
    Written              : Longint;
    nCount, BuffCount    : Longint;
    pTemp      : Longint;
    StreamSize,
    OldPosition : Longint;
    ByteBuff : Byte;
begin
    pStream := TBlobStream( hf );

    NumberOfBytesWritten := 0;
    Written              := 0;
    BuffCount            := cbBuffer;
    pTemp                := hpvbuffer;
    nCount               := 0;

    OldPosition          := 0;
    ByteBuff             := 0;

    while ( BuffCount > 0 ) and ( Written = nCount )do
    begin
        nCount := min( 32767, BuffCount );

        Written := pStream.Write( Pointer( pTemp )^, nCount );

        Inc( NumberOfBytesWritten, Written );
        Dec( BuffCount, Written );
        pTemp := pTemp + Written;

    end;

    Result := NumberOfBytesWritten;
end;

{******************************************************************************}

function streamSeek( lpImage: Longint; hf: Longint; lOffset: Longint; nOrigin: Integer ): Longint;
Var
    pStream : TBlobStream;
begin
    pStream := TBlobStream( hf );

    Result := pStream.Seek( lOffset, nOrigin );
end;

{******************************************************************************}
{$endif}

{******************************************************************************}

begin

    { Do this to ensure correct loadind of DLL }
    if ( iDLLLoad = 1 ) then begin end;

    BlobStreamCount := 0;

end. { of unit LLI }

