unit un;
interface

uses SysUtils,WinProcs;

procedure UpdateDir(Inp,Outp:string);

implementation
Procedure CopyFile(f1,f2:string;ftime:longint); forward;

procedure UpdateDir(Inp,Outp:string);
var
  sr1,sr2: TSearchRec;
  r:integer;
  sp,spar:string;
begin
  r:=FindFirst(Inp+'*.*', faAnyFile xor faDirectory, sr1);
  while r=0 do
    begin
      FindFirst(Outp+sr1.Name, faAnyFile xor faDirectory, sr2);
      if (sr2.name<>sr1.name) or (sr1.time<>sr2.time)
	then CopyFile(Inp+sr1.name,Outp+sr1.Name,
			 sr1.time);
      r:=FindNext(sr1);
    end;
end;

Procedure CopyFile(f1,f2:string;ftime:longint);
var
  a:array[0..1024] of byte;
  fi,fo:integer;
  cnt:longint;
begin
  FileMode:=0;
  fi:=FileOpen(f1,fmShareDenyNone);
  fo:=FileCreate(f2);
  repeat
    cnt:=FileRead(fi,a,1024);
    FileWrite(fo,a,cnt);
  until cnt<1024;
  FileSetDate(fo,ftime);
  FileClose(fi);
  FileClose(fo);
end;

begin
  if true then ;
end.
