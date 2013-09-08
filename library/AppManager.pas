unit AppManager;

interface
uses
  Classes, syncobjs,
  RunApp;

type
  AM_TString = AnsiString;

  TApplicationManager = class
  private
    RunAppList : TList;
    CriticalSection : TCriticalSection;
    procedure DeleteAppFromList(Sender : TObject);
    function GetEditAppCount : integer;
    procedure Lock;
    procedure UnLock;
  public
    constructor Create;
    destructor Destroy;
    procedure RunApplication(CmdLine,FileName : AM_TString; DocID,VerID : integer;
                             EditMode,SaveMode : boolean);
    property EditAppCount: integer read GetEditAppCount;
  end;

implementation
uses
  Dialogs;

constructor TApplicationManager.Create;
begin
  inherited Create;
  RunAppList:= TList.Create;
end;

destructor TApplicationManager.Destroy;
begin
  RunAppList.free;
  inherited Destroy;
end;

procedure TApplicationManager.RunApplication(CmdLine,FileName : AM_TString;
                                             DocID,VerID : integer;
                                             EditMode,SaveMode : boolean);
var
  RunApp : TRunApplication;
  i      : integer;
begin
  // search for identical application
  for i:= 0 to RunAppList.Count-1 do
    if (TRunApplication(RunAppList.Items[i]).FileName = FileName) and
       (TRunApplication(RunAppList.Items[i]).EditMode = EditMode) then
          begin
            MessageDlg('Приложение уже открыто',mtInformation,[mbOk],0);
            exit;
          end;
  RunApp:= TRunApplication.Create(CmdLine,FileName,DocID,VerID,EditMode,SaveMode);
  RunAppList.Add(RunApp);
  RunApp.OnTerminate:= DeleteAppFromList;
end;

procedure TApplicationManager.DeleteAppFromList(Sender : TObject);
var
  i : integer;
begin
//  Lock;
  for i:= 0 to RunAppList.Count-1 do
    if RunAppList.Items[i] = Sender then
      RunAppList.Delete(i);
//  UnLock;
end;

function TApplicationManager.GetEditAppCount : integer;
var
  i : integer;
begin
  Result:= 0;
  for i:= 0 to RunAppList.Count-1 do
    if TRunApplication(RunAppList.Items[i]).EditMode then
      inc(Result);
end;

procedure TApplicationManager.Lock;
begin
  {$ifdef WIN32}
  CriticalSection.Enter;
  {$endif}
end;

procedure TApplicationManager.UnLock;
begin
  {$ifdef WIN32}
  CriticalSection.Leave;
  {$endif}
end;

end.
