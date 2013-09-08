Unit DDEFUNS;

Interface

Uses TAdjForm,ExtCtrls,DDEMan,FileFuns,WinTypes,forms;

Type
   TDDEString=string[128];

   TDDEForm = class(TAdjustForm)
      Timer:TTimer;
      Procedure OnShow(Sender:TObject);
      Procedure OnUserCreate(Sender:TObject);
      Procedure TimerOnTimer(Sender:TObject);
   Private

   Public

   End;

Procedure CreateDDE(ResultServer,ResultTopic:TDDEString);
Procedure SendDDECmd(ResultServer,ResultTopic,Cmd:TDDEString;FormFlag:boolean);
Procedure FreeDDE(Cmd:TDDEString;FormFlag:boolean);

{$R *.DFM}

var DDEFrm:TDDEForm;
    DDEClient:TDDEClientConv;
    DDECmd:PChar;
    DDEApp:word;
    TimeOutCount:integer;


Implementation

PROCEDURE TDDEForm.OnShow(Sender:TObject);
begin
  Timer.Enabled:=TRUE
end;

PROCEDURE TDDEForm.OnUserCreate(Sender:TObject);
begin
  TimeOutCount:=-1;
end;

PROCEDURE TDDEForm.TimerOnTimer(Sender:TObject);
begin
  if TimeOutCount=-1 then
    begin
      TimeOutCount:=0;
      Timer.Interval:=1000;
      if DDECmd<>NIL then
        DDEClient.ExecuteMacro(DDECmd,TRUE)
    end;

  if DDEClient.RequestData('ServerName')=NIL then
    begin
      inc(TimeOutCount);
{      if TimeOutCount>25 then Close}
    end
  else
    TimeOutCount:=0
end;

Procedure FreeDDE(Cmd:TDDEString;FormFlag:boolean);
begin
  Cmd:=Cmd+#0;
  DDECmd:=@Cmd[1];
  if FormFlag then
    begin
      DDEFrm:=TDDEForm.Create(Application);
      DDEFrm.ShowModal;
      DDEFrm.Free;
      DDEFrm:=NIL
    end
  else
    DDEClient.ExecuteMacro(@Cmd[1],TRUE);
  DDEClient.Free
end;

Procedure SendDDECmd(ResultServer,ResultTopic,Cmd:TDDEString;FormFlag:boolean);
begin
  CreateDDE(ResultServer,ResultTopic);
  DDEApp:=0;
  FreeDDE(Cmd,FormFlag);
end;

Procedure CreateDDE(ResultServer,ResultTopic:TDDEString);
begin
  DDEClient:=TDDEClientConv.Create(Application);
  DDEClient.ConnectMode:=ddeManual;
  DDEClient.SetLink(ResultServer,ResultTopic);
  DDEClient.OpenLink;
end;

End.
