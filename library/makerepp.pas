unit MakeRepP;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Gauge95, StdCtrls, MakeRep, DdeMan, IniFiles, tadjform;

Var
   ActiveState : boolean = false;
   CallWW      : boolean = false;
   PrintR      : boolean = false;

type
  TReportMakerWP = class(TForm)
    Label1  : TLabel;
    LCurWork: TLabel;
    BtCancel: TButton;
    Label2  : TLabel;
    Label3  : TLabel;
    TNumb   : TLabel;
    RNumb   : TLabel;
    BtPrint : TButton;
    BtExit  : TButton;
    procedure FormActivate(Sender: TObject);
    procedure BtCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtExitClick(Sender: TObject);
    procedure BtPrintClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    MakeRep    : TReportMaker;
    DTNumb     : integer;
    DRNumb     : integer;
    ReportName : string;
    procedure ProgressEvent(Sender:TObject;
                  const CurWork:LitString;CurTable,
                  CurRecords,ProgressMax,ProgressPos:longint);
    procedure SetProgressButtonCaption(s:string);
    procedure MenuActivate;
    procedure CloseProgress;
    procedure DoCallWinWord;
    procedure CallWinWord;
{    procedure DoPrintReport;}
  public
    WordPath   : string;
    PrintCount : integer;
    AppType    : string;
    { Public declarations }
    constructor Create(AOwner: TComponent);
    destructor  Destroy;
    procedure   AddParam(const s:string);
    procedure   ClearParam;
    function    DoMakeReport(RTFFileName,INIFileName,OutRepFile:string):integer;
  end;

implementation

{$R *.DFM}
//var Gauge951: TGauge95;

constructor TReportMakerWP.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);
 // WordPath:= 'C:\Program Files\Microsoft Office\OFFICE11\WINWORD.EXE';
  //'e:\Program Files\Microsoft Office\Office\';
 AppType:='WINWORD';
 // WordPath:='C:\WrrrORDVIEW\';
  //AppType:='WORDVIEW';
  MakeRep:=TReportMaker.Create;
  PrintCount:=0;
end;

destructor TReportMakerWP.Destroy;
begin
  MakeRep.free;
  Inherited Free;
end;

procedure TReportMakerWP.ProgressEvent(Sender:TObject;
                  const CurWork:LitString;CurTable,
                  CurRecords,ProgressMax,ProgressPos:longint);
 begin
  if not ActiveState then exit;
  if LCurWork.Caption<>CurWork then
    begin LCurWork.Caption:=CurWork;application.processmessages; end;
  if StrToInt(TNumb.Caption)<>CurTable then
    begin TNumb.Caption:=IntToStr(CurTable);TNumb.refresh;{application.processmessages;} end;
  if StrToInt(RNumb.Caption)<>CurRecords then
    begin RNumb.Caption:=IntToStr(CurRecords);RNumb.refresh; end;
 { with gauge951 do
    begin
     if MaxValue<>ProgressMax then MaxValue:=ProgressMax;
     if  Progress<>ProgressPos then Progress:=ProgressPos;
    end;   }
end;

procedure TReportMakerWP.SetProgressButtonCaption(s:string);
begin
  if not ActiveState then exit;
  BtCancel.caption:=s;
  BtPrint.Visible:=true;
  BtExit.Visible:=true;
  BtCancel.SetFocus;
end;
procedure TReportMakerWP.CallWinWord;
var
  s:string;
  DdeClientConv1: TDdeClientConv;
begin
//  DdeClientConv1:=TDdeClientConv.Create(application);
//  DDEClientConv1.ConnectMode:=ddeManual;
//  DdeClientConv1.ServiceApplication:=WordPath+AppType+' /t'{+' '+ReportName};
//  b:=DdeClientConv1.SetLink(AppType,'');   {времено закрываем}
//  b:=DdeClientConv1.OpenLink;

//  s:='[FileOpen.Name="'+ReportName+'"]'+#0;
//  b:=DdeClientConv1.ExecuteMacro(@s[1],FALSE);

end;
procedure TReportMakerWP.DoCallWinWord;
var
  s:string;
  DdeClientConv1: TDdeClientConv;
  wnd:HWnd;
  b:boolean;
  i:integer;
begin
  DdeClientConv1:=TDdeClientConv.Create(application);
  DDEClientConv1.ConnectMode:=ddeManual;
  DdeClientConv1.ServiceApplication:=WordPath+AppType+' /t'{+' '+ReportName};
  b:=DdeClientConv1.SetLink(AppType,'');   {времено закрываем}
  b:=DdeClientConv1.OpenLink;

  s:='[FileOpen.Name="'+ReportName+'"]'+#0;
  b:=DdeClientConv1.ExecuteMacro(@s[1],FALSE);
  if PrintCount>0 then
    begin
      s:='[FilePrint.BackGround=0,.NumCopies='+IntToStr(PrintCount)+',.FileName="'+ReportName+'"]'+#0;
      b:=DdeClientConv1.ExecuteMacro(@s[1],FALSE);
    end;
 {if UpperCase(AppType)='WINWORD' then
    begin
      wnd:=FindWindow('WINWORD',pchar(0));
      if wnd=0 then messagebox(self.Handle,'Microsoft word не найден.','Ошибка',0);
      if IsIconic(wnd) then ShowWindow(wnd,SW_RESTORE)
        else BringWindowToTop(wnd);
    end;     }
  if UpperCase(AppType)='WORDVIEW' then
    begin
      wnd:=FindWindow('WORDVIEW',pchar(0));
      if wnd=0 then messagebox(self.Handle,'Microsoft word view не найден.','Ошибка',0);
      if IsIconic(wnd) then ShowWindow(wnd,SW_RESTORE)
        else BringWindowToTop(wnd);
    end;
  if PrintCount>0 then
    begin
      s:='[FileExit 2]'+#0;
      b:=DdeClientConv1.ExecuteMacro(@s[1],FALSE);
    end;
  DdeClientConv1.free;
end;
{------------------------------------------------------------------------}
(*procedure TReportMakerWP.DoPrintReport;
var
  s:string;
  DdeClientConv1: TDdeClientConv;
  wnd:HWnd;
  b:boolean;
begin
  DdeClientConv1:=TDdeClientConv.Create(application);
  DDEClientConv1.ConnectMode:=ddeManual;
  DdeClientConv1.ServiceApplication:='c:\msoffice\winword\winword.exe';
  b:=DdeClientConv1.SetLink('winword','');
  b:=DdeClientConv1.OpenLink;

  s:='[FileOpen.Name="'+ReportName+'"]'+#0;
  DdeClientConv1.ExecuteMacro(@s[1],TRUE);
  s:='[FilePrint.Name="'+ReportName+'"]'+#0;
  DdeClientConv1.ExecuteMacro(@s[1],TRUE);
  DdeClientConv1.free;
  wnd:=FindWindow('Opusapp',pchar(0));
  if wnd=0 then messagebox(self.Handle,'Microsoft word не найден.','Ошибка',0);
  if IsIconic(wnd) then ShowWindow(wnd,SW_RESTORE)
    else BringWindowToTop(wnd);
end;*)
{------------------------------------------------------------------------}

procedure TReportMakerWP.CloseProgress;
begin
  if not ActiveState then exit;
 ActiveState:=false;
  DoCancel:=true;
end;

procedure TReportMakerWP.MenuActivate;
begin
  SetProgressButtonCaption('Вызов Winword');
  close;
  ShowModal;
  CloseProgress;
  if CallWW then DoCallWinWord;
{  if PrintR then DoPrintReport;}
end;

procedure TReportMakerWP.FormActivate(Sender: TObject);
begin
  DoCancel:=false;
  ActiveState:=true;
  DTNumb:=0;
  DRNumb:=0;
  CallWW:=false;
  PrintR:=false;
end;

procedure TReportMakerWP.BtCancelClick(Sender: TObject);
begin
  DoCancel:=true;
  ActiveState:=false;
  if BtCancel.Caption<>'Cancel' then CallWW:=true;
  close;
end;
procedure TReportMakerWP.BtExitClick(Sender: TObject);
begin
  DoCancel:=true;
  ActiveState:=false;
  close;
end;
procedure TReportMakerWP.BtPrintClick(Sender: TObject);
begin
  DoCancel:=true;
  ActiveState:=false;
  PrintR:=true;
  close;
end;


procedure TReportMakerWP.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DoCancel:=true;
  ActiveState:=false;
end;

procedure TReportMakerWP.AddParam(const s:string);
begin
  MakeRep.Parameters.add(s);
end;
procedure TReportMakerWP.ClearParam;
begin
  MakeRep.Parameters.clear;
end;

function TReportMakerWP.DoMakeReport(RTFFileName,INIFileName,OutRepFile:string):integer;
begin
  ReportName:=OutRepFile;
  //Gauge951.Progress:=0;
  show;
  application.processmessages;
  LCurWork.Left:=Label1.Left+Label1.Width+10;
  TNumb.Left:=Label3.Left+Label3.Width+10;
  RNumb.Left:=Label2.Left+Label2.Width+10;
  //ClientWidth:=Gauge951.Left+Gauge951.Width+20;
  ClientHeight:=BtCancel.Top+BtCancel.Height{+StatusBar.Height}+10;
  if ClientWidth<LCurWork.Left+LCurWork.Width+50 then
        ClientWidth:=LCurWork.Left+LCurWork.Width+50;
  Result:=MakeRep.DoMakeReport(self.Handle,RTFFileName,INIFileName,OutRepFile,
                       ProgressEvent);
  close;
  application.processmessages;
  if Result=0 then DoCallWinWord;{MenuActivate;}
end;

procedure TReportMakerWP.FormResize(Sender: TObject);
begin
  ClientHeight:=btExit.Top+btExit.Height*2;
  ClientWidth:=btPrint.Left+btPrint.Width+btExit.Left;
end;

end.
