unit Logger;

interface
uses
  Windows, Messages, SysUtils;

  procedure LogError(s:string);
  procedure LogInfo(s:string);

implementation
// logs
procedure LogError(s:string);
var f:text;
  curr_date: string;
  curr_time: string;
begin
  begin
    system.assign(f,'c:\regiontrans.log');
    {$I-}
    system.append(f);
    if IOresult<>0 then system.rewrite(f);
    curr_date := DateToStr(Now);
    curr_time := TimeToStr(Now);
    writeln(f,'[' +  curr_date +'] [' + curr_time + '] [Error] ' + s);
    system.close(f);
  end;
end;

procedure LogInfo(s:string);
var f:text;
  curr_date: string;
  curr_time: string;
begin
  begin
    system.assign(f,'c:\regiontrans.log');
    {$I-}
    system.append(f);
    if IOresult<>0 then system.rewrite(f);
    curr_date :=DateToStr(Now);
    curr_time := TimeToStr(Now);
    writeln(f,'[' +  curr_date +'] [' + curr_time +'] [Info] ' + s);
    system.close(f);
  end;
end;

end.
