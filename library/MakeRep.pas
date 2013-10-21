unit Makerep;
interface

uses WinTypes, WINPROCS, INIFiles, classes, SysUtils, TSQLCls, DBTables,
     StdCtrls, DB, Forms, FunChar;

Const
   dsFile = 1;
   dsMem  = 2;
 {------------------------------}
   BlockDefSize = 50000;
   RowDefSize   = 15000;
   RecEstSize   = 1000;
 {------------------------------}
 {ErrorCodes}
   EFieldNotFound        = 100;
   ETableNotFound        = 101;
   EBlockTableNotFound   = 102;
   EFormFileNotFound     = 103;
   EOutRepFileNotCreated = 104;
 {------------------------------}
Var
   DoCancel    : boolean = true;
 {------------------------------}
Type
   LitString = string[50];
   tRtable = object
                SortField    : LitString;
                PhysicalView : string[64];
                Conditions   : string;
                SortDirect   : string[10];
                StartRow     : integer;
                DBTable      : boolean;
                Distinct     : string;
             end;
   TProgressEvent=procedure(Sender:TObject;
                   const CurWork:LitString; CurTable, CurRecords,
                              ProgressMax,ProgressPos:longint) of object;

   TParameters = class(TObject)
                    Params : TStringList;
                    constructor Create;
                    destructor Destroy;override;
                    procedure Clear;
                    procedure Add(s:string);
                    function  Get(n:string):string;
                 end;

   cArr=array[0..10] of char;

   tReportMaker = class(TObject)
         Conditions   : string;
         PhysicalView : string;
         TablesCount  : integer;
         BlocksCount  : integer;
         RepINI       : TIniFile;
         fi,fo        : integer;
         InEOF        : boolean;
         DoLog        : boolean;
         Parameters   : TParameters;

         MemEnd       : pchar;
         CurMemPos    : pchar;
         DataSrc      : integer;

         EndofBlock   : boolean;
         CurTable     : integer;
         CurBlock     : char;
         MainBlock    : char;

         CurQry       : TQuery;
         CurBlockQry  : TQuery;
         CurTableQry  : TQuery;
         MainBlockQry : TQuery;

         ErrorCode    : integer;
         RTables      : array[1..50] of tRtable;

         CurProgr     : longint;
         CurRecords   : longint;
         CurTables    : longint;
         MaxProgr     : longint;
         CurRecord    : longint;
         CurWork      : LitString;
         CharSet      : CArr;
         DoCharSet    : CArr;
         Fnt          : boolean;
         SkipPicture  : boolean;

         constructor Create;
         destructor  Destroy;override;
         procedure   AddParam(const s:string);
         procedure   ClearParam;
         procedure   LoadData(INIFileName:string);
         function    ReadStringFromINI(const Sect,Ident,Def:LitString;
                                                 var spec:boolean):string;
         function    InsertVariables(const s:string;var spec:boolean):string;

         function    DoMakeReport(ParentHandle:HWnd; RTFFileName,INIFileName,
                                OutRepFile:string;
                                ProgressEvent:TProgressEvent):integer;
         procedure WriteLog(s:string);
       end;

implementation
var
 Unused:boolean;

procedure tReportMaker.WriteLog(s:string);
var f:text;
begin
// if DoLog then
   begin
     system.assign(f,'c:\report.log');
     {$I-}
     system.append(f);
     if IOresult<>0 then system.rewrite(f);
     writeln(f,s);
     system.close(f);
   end;
end;

{$IFNDEF WIN32}
function inttostr(i:integer):string;
var s:string;
begin
   str(i,s);
   inttostr:=s;
end;
{$ENDIF}

constructor TParameters.Create;
begin
  Inherited Create;
  Params:=TStringList.Create;
end;

destructor TParameters.Destroy;
begin
  Params.free;
  Inherited Destroy;
end;

function TParameters.Get(n:string):string;
var i,jpos:integer;
    cn:string;
begin
 for i:=1 to Params.Count do
   begin
     jpos:=pos('=',Params.strings[i-1]);
     cn:=copy(Params.strings[i-1],1,jpos-1);
     if cn=n then
       begin
        Get:=copy(Params.strings[i-1],jpos+1,256);
        exit;
       end;
   end;
 Get:='';
end;

procedure TParameters.Clear;
begin
  Params.Clear;
end;

procedure TParameters.Add(s:string);
begin
  Params.Add(s);
end;

constructor tReportMaker.Create;
begin
  Inherited Create;
  Parameters:=TParameters.Create;
end;

destructor tReportMaker.Destroy;
begin
  Parameters.free;
  Inherited Destroy;
end;

function tReportMaker.InsertVariables(const s:string;var spec:boolean):string;
var
  i:integer;
  r,ts,fld:string;
  ptype,pTable:LitString;
  pnum:LitString;
  funn:string;

function GetNum:LitString;
var r:LitString;
begin
  r:='';
  inc(i);
  while (i<=length(s)) and IsDigit(s[i]) do begin r:=r+s[i];inc(i); end;
  GetNum:=r;
end;

function GetStr:LitString;
var r:LitString;
begin
  r:='';
  inc(i);
  while (i<=length(s)) and (IsAlpha(s[i]) or (s[i]='"')) do begin r:=r+s[i];inc(i); end;
  GetStr:=r;
end;

var
  MyBookmark: TBookmark;
  WasEof:boolean;
  q:TQuery;
  Date1,Date2:string;

begin {InsertVariables}
  r:='';
  i:=1;
  spec:=false;
try
  while (i<=length(s)) do
   begin
    case s[i] of
      '#': if ((i+2<=length(s)) and IsDigit(s[i+1])) then
          begin
            spec:=true;
            pnum:=GetNum;
            ptype:=RepINI.ReadString('Parameters',pnum,'');
            if (pType='DATE') and (Parameters.Get(pnum)<>'')  then
             begin
              if Parameters.Get(pnum)<>'  .  .    ' then
               r:=r+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(Parameters.Get(pnum))));
             end
             else
               r:=r+Parameters.Get(pnum);
          end else r:=r+s[i];
      '@':begin
            spec:=true;
            funn:=GetStr;
            if funn='GetCurrentRecordNumber' then r:=IntToStr(CurRecord+1);
            if funn='PageBreak' then
              begin
                MyBookmark := CurBlockQry.GetBookmark;
                CurBlockQry.next;
                WasEof:=CurBlockQry.eof;
                CurBlockQry.GotoBookmark(MyBookmark);
                CurBlockQry.FreeBookmark(MyBookmark);
                if not WasEof then r:='\page' else r:='';
                break;
              end;
            if funn='VALUE' then
               begin
                  pTable:=GetStr;
                  fld:=GetStr;
                  ts:=InsertVariables(copy(s,i+1,256),Unused);
                  if PTable<>'' then
                     r:=sql.SelectString(pTable,fld,ts);
                  break;
               end;
            if funn='COUNT' then
               begin
                  pTable:=GetStr;
                  ts:=InsertVariables(copy(s,i+1,256),Unused);
                    if PTable<>'' then r:=IntToStr(sql.RecordCount(pTable,ts));
                  WriteLog(ts+'  ='+r);
                  break;
               end;
            if funn='GetDateRange' then
               begin
                  fld:=GetStr;
                  ts:=InsertVariables(copy(s,i+1,256),Unused);
                  date1:=copy(ts,1,pos(',',ts)-1);
                  date2:=copy(ts,pos(',',ts)+1,256);
                  if (date1='') and (date2='') then r:=sql.CondNull(fld)
                    else
                      if date1='' then
                        r:=sql.CondValue(fld,'<=',date2)
                    else
                      if date2='' then
                        r:=sql.CondValue(fld,'>=',date1)
                    else
                        r:=sql.CondValue(fld,'>=',date1)+' AND '+sql.CondValue(fld,'<=',date2);
                  WriteLOG('DateRange: '+fld+','+date1+','+date2+#13#10'RES:'+r);
                  break;
               end;
            dec(i);
            if funn='NOW' then r:=r+sql.CurrentDateTime;
            if funn='TODAY' then
              begin
                try
                  q:=TQuery.Create(Application);
                  q.DataBaseName:=sql.DataBaseName;
                  q.sql.add('SELECT '+sql.CurrentDate);
                  q.open;
                  r:=r+q.Fields[0].AsString;
                  q.free;
                except
                end;
              end;
          end;
      '$':if ((CurTable>0) and (i+2<=length(s)) and IsDigit(s[i+1])) then
          begin
            spec:=true;
            pnum:=GetNum;
            funn:=ReadStringFromINI('Table '+IntToStr(CurTable)+' Attributes' ,pnum,'',Unused);
            if CurTableQry.FieldByName(funn).IsNull then
              r:=r+'NULL'
            else
              r:=r+CurTableQry.FieldByName(funn).AsString;
          end else r:=r+s[i];
      '%': if ((PhysicalView<>'') and (i+2<=length(s)) and IsDigit(s[i+1])) then
          begin
            spec:=true;
            pnum:=GetNum;
            funn:=ReadStringFromINI('Attributes',pnum,'',spec);
            //WriteLog('Select '+funn+' from '+PhysicalView+' where '+Conditions+' ='+
            //     sql.Select(PhysicalView,'',Conditions,'').FieldByName(funn).AsString);
            if spec then r:=r+funn else
              r:=r+sql.Select(PhysicalView,'',Conditions,'').FieldByName(funn).AsString;
            spec:=true;
          end else r:=r+s[i];
      '~': if ((CurBlock>'0') and (i+2<=length(s)) and IsDigit(s[i+1])) then
          begin
            spec:=true;
            pnum:=GetNum;
            funn:=ReadStringFromINI('Block '+CurBlock+' Attributes' ,pnum,'',Unused);
            if (funn='') and (MainBlock>'0') then
               begin
                 funn:=ReadStringFromINI('Block '+MainBlock+' Attributes' ,pnum,'',Unused);
                 if MainBlockQry.FieldByName(funn).IsNull then
                   r:=r+'NULL'
                 else
                   r:=r+CurBlockQry.FieldByName(funn).AsString;
               end
           else
            if CurBlockQry.FieldByName(funn).IsNull then
              r:=r+'NULL'
            else
              r:=r+CurBlockQry.FieldByName(funn).AsString;
          end else r:=r+s[i];
      else r:=r+s[i];
    end;
    inc(i);
   end;
 except
  WriteLOG('Error! In: '+s+#13#10'RES:'+r);
 end;
  InsertVariables:=r;
end;

Procedure MemoToStream(q:TQuery;FieldName:string;s:TMemoryStream);
Var f:TMemoField;
    t:integer;
//  r:string;
begin
  s.Clear;
  f:=TMemoField(q.FieldByName(FieldName));
  f.SaveToStream(s);
  t:=0;
  s.Write(t,1);
end;
{------------------------------------------------------------------------}
function tReportMaker.DoMakeReport;
var
  b        : byte;
  c        : char;
  ContWord : boolean;
  CWord,LastCWord:string;
  ts,s     : string;
  i        : integer;
  ss       : TMemoryStream;
  p        : pchar;
  LW       : string;
  SkipWrite:boolean;

{------------------------------------------------------------------------}
procedure CallUP;
begin
 if pointer(@ProgressEvent)<>nil then
   ProgressEvent(self,CurWork,CurTables,CurRecords,MaxProgr,CurProgr);
end;
{------------------------------------------------------------------------}
procedure IncTableNumb;
begin
  inc(CurTables);
  CallUP;
end;
{------------------------------------------------------------------------}
procedure IncRecNumb;
begin
  inc(CurRecords);
  CurProgr:=CurProgr+RecEstSize;
  CallUP;
end;
{------------------------------------------------------------------------}
procedure AddProgress(value:longint);
begin
  CurProgr:=CurProgr+value;
  CallUp;
end;
{------------------------------------------------------------------------}
  procedure MFileRead(Handle: Integer; var Buffer; Count: Longint);
  var
    p:^char;
  begin
    if DataSrc = dsFile then
      begin
        AddProgress(Count);
        if FileRead(Handle,Buffer,Count)<>Count then
           InEOF:=true else InEOF:=false
      end
     else begin p:=@Buffer;p^:=CurMemPos^; inc(CurMemPos); InEOF:=(CurMemPos>MemEnd); end;
  end;
{------------------------------------------------------------------------}
  procedure WriteConv(fo:integer;b:byte);
  const hex:string='0123456789abcdef';
  var
    s:string;
  begin
    s:='\'''+hex[b div 16+1]+hex[b mod 16+1];
    if b<>$88 then
    FileWrite(fo,s[1],4);
  end;
{------------------------------------------------------------------------}
  procedure WriteSymb(fo:integer;b:byte);
  const
    ws:array[0..5] of char = '\par '#0;
  begin
   if not (b in [10,13]) then WriteConv(fo,b);   
   if b=10 then FileWrite(fo,ws,5);
  end;
{------------------------------------------------------------------------}
  procedure SubmitData(Qr:TQuery; const Sect,Ident,Def:LitString);
  var
    i:integer;
    fn:string;
    spec:boolean;
  begin
     if qr=nil then exit;
     fn:=ReadStringFromINI(Sect,Ident,Def,spec);
     FileWrite(fo,DoCharSet,StrLen(DoCharSet));
     if spec then
       begin
        s:=fn;
        for i:=1 to length(s) do WriteSymb(fo,ord(s[i]));
        exit;
       end;
     s:='';
    repeat
     if fn='' then break;
   try
     if Qr.FieldByName(fn) is TMemoField then
       begin
         MemoToStream(qr,fn,ss);
         p:=ss.Memory;
         while p^<>#0 do
           begin
             WriteSymb(fo,byte(p^));
             inc(p);
             s:='';
           end;
       end
        else
         begin
           s:=qr.FieldByName(fn).AsString;
//           WriteLog('Select '+fn+' = '+s);
           for i:=1 to length(s) do
              if s[1]<>' ' then break else delete(s,1,1);
           for i:=1 to length(s) do WriteSymb(fo,ord(s[i]));
         end
     except
       begin
         WriteLog('Field not found :'+fn);
         ErrorCode:=1;
         DoCancel:=true;
       end;
    end;
   until true;
  end;{SubmitData}
{------------------------------------------------------------------------}
  procedure ProceedBlock(bnum:char);forward;
  procedure ProceedTableRow;forward;
  procedure CheckCSubmit(DoCheckCW:boolean);
  var
    i:integer;
    bnum:char;
    ptype:string;
    ch:char;
  begin
    ch:=UpCase(c);
    if ContWord then
      if IsAlpha(ch) then CWord:=CWord+ch
       else
         begin  {CWord readed}
           ContWord:=false;
           if ((CWord='OBJDATA') or (CWord='BLIPUID')) then
             begin
               SkipPicture:=true;
             end;
           if not Fnt and (CWord='F') then
             begin
               CharSet[0]:='\';CharSet[1]:='f';
               i:=2;
               while IsDigit(ch) do
                 begin
                    FileWrite(fo,c,1);
                    CharSet[i]:=ch;
                    inc(i);
                    MFileRead(fi,b,1);
                    c:=UpCase(chr(b));
                    ch:=c;
                 end;
               CharSet[i]:=' ';
               CharSet[i+1]:=#0;
             end;
           if not Fnt and (CWord='FCHARSET') then
             begin
               if ch='2' then
                 begin
                    FileWrite(fo,c,1);
                    MFileRead(fi,b,1);
                    c:=UpCase(chr(b));
                    ch:=c;
               if ch='0' then
                 begin
                    FileWrite(fo,c,1);
                    MFileRead(fi,b,1);
                    c:=UpCase(chr(b));
                    ch:=c;
               if ch='4' then begin DoCharSet:=CharSet;Fnt:=true; end;
                 end;
                 end;
             end;
           if (CWord='TROWD') then
            if (LastCWord<>'ROW') then
             begin
               inc(CurTable);
               RTables[CurTable].StartRow:=
                  RepINI.ReadInteger('Table '+Inttostr(CurTable)+' Header','StartRow',1);

{               if RTables[CurTable].DBTable and (RTables[CurTable].StartRow=0) then
                 begin
                   ProceedTableRow;
                   SkipWrite:=true;
                 end;}
             end
            else
             if RTables[CurTable].DBTable then
              begin
                dec(RTables[CurTable].StartRow);
                if RTables[CurTable].StartRow=0 then
                 begin
                   ProceedTableRow;
                   SkipWrite:=true;
                 end;
              end;
           LastCWord:=CWord;
           CWord:='';
         end;
     if not SkipWrite then
     case c of
      '\' :if DoCheckCW then {begin of control word}
           begin
             ContWord:=true;
             CWord:='';
           end;
      '%' : begin
              ts:='%';
              repeat
                MFileRead(fi,b,1);c:=chr(b);
                ts:=ts+c;
              until not IsDigit(c) or InEof;
              delete(ts,length(ts),1);
              if c='%' then {submit strings}
                 begin
                  delete(ts,1,1);
                  SubmitData(CurQry,'Attributes',ts,'');
                  SkipWrite:=true;
                 end
                else {it's not contr. str}
                  FileWrite(fo,ts[1],length(ts));
            end;
      '$' : if CurTable>0 then
            begin
              ts:='$';
              repeat
                MFileRead(fi,b,1);c:=chr(b);
                ts:=ts+c;
              until not IsDigit(c) or InEof;
              delete(ts,length(ts),1);
              if c='$' then {submit strings}
                 begin
                  delete(ts,1,1);
                  SubmitData(CurTableQry,'Table '+IntToStr(CurTable)+' Attributes' ,ts,'');
                  SkipWrite:=true;
                 end
                else {it's not contr. str}
                  FileWrite(fo,ts[1],length(ts));
            end;
      '#' : begin
              ts:='#';
              repeat
                MFileRead(fi,b,1);c:=chr(b);
                ts:=ts+c;
              until not IsDigit(c) or InEof;
              delete(ts,length(ts),1);
              if c='#' then {submit strings}
                 begin
                  delete(ts,1,1);
                  s:=Parameters.Get(ts);
                  ptype:=RepINI.ReadString('Parameters',ts,'');
                  if (pType='DATE') and (s='') then s:='__.__._____';
                  FileWrite(fo,DoCharSet,StrLen(DoCharSet));
                  FileWrite(fo,s[1],length(s));
                  SkipWrite:=true;
                 end
                else {it's not contr. str}
                  FileWrite(fo,ts[1],length(ts));
            end;
      '&' : begin
              ts:='&';
              repeat
                MFileRead(fi,b,1);c:=chr(b);
                ts:=ts+c;
              until not IsAlpha(c) or InEof;
              delete(ts,length(ts),1);
              if ts='&BLOCK' then {submit strings}
                 begin
                  bnum:=c;
                  ts:='';
                  repeat
                    MFileRead(fi,b,1);c:=chr(b);
                    ts:=ts+c;
                  until not IsAlpha(c) or InEof;
                  while (c<>'}') and (not InEof) do
                    begin
                       MFileRead(fi,b,1);c:=chr(b);
                       FileWrite(fo,c,1);
                    end;
                  if ts='BEGIN&' then {block begin}
                    begin
                       ProceedBlock(bnum);
                    end else EndofBlock:=true;
                  SkipWrite:=true;
                 end
                else {it's not contr. str}
                  FileWrite(fo,ts[1],length(ts));
            end;
      '~' : if CurBlock>'0' then
            begin
              ts:='~';
              repeat
                MFileRead(fi,b,1);c:=chr(b);
                ts:=ts+c;
              until not IsDigit(c) or InEof;
              delete(ts,length(ts),1);
              if c='~' then {submit strings}
                 begin
                  delete(ts,1,1);
                  SubmitData(CurBlockQry,'Block '+CurBlock+' Attributes' ,ts,'');
                  SkipWrite:=true;
                 end
                else {it's not contr. str}
                  FileWrite(fo,ts[1],length(ts));
            end;
    end;
  end;{CheckCSubmit}
{------------------------------------------------------------------------}
  procedure ProceedTableRow;
  const
    rd :string = '\trowd ';
  var
    i      : integer;
    RowDef : pchar;
    pv,cn  : string;
    NCpos,
    NRDend : pchar;
    LCpos,
    LRDend : pchar;
    Lds    : integer;
  begin
    CurWork:='Заполнение таблицы';
    IncTableNumb;

    getmem(RowDef,RowDefSize);
    NCPos:=RowDef;
    for i:=1 to length(rd) do
      begin NCPos^:=rd[i];inc(NCPos); end;
    LW:='';
    while not InEof and (LW<>'ROW') do
      begin
        MFileRead(fi,b,1);
        NCPos^:=chr(b);inc(NCPos);
        c:=UpCase(chr(b));
        if IsAlpha(c) then LW:=LW+c else LW:='';
      end;
    MFileRead(fi,b,1);NCPos^:=chr(b);inc(i);
    inc(NCPos);MFileRead(fi,b,1);NCPos^:=chr(b);
    if NCPos^<>'}' then
      begin
        dec(NCpos);
        if DATAsrc=dsMEM then dec(CurMemPos) else FileSeek(fi,-1,1);
      end;
    NRDend:=NCPos;
    NCpos:=RowDef;

    LCPos:=CurMemPos;CurMemPos:=NCPos;
    LRDend:=MemEnd;MemEnd:=NRDend;
    Lds:=DATASrc;

    for i:=1 to 6 do inc(CurMemPos);
   repeat
    with RTables[CurTable] do
      begin
        pv:=PhysicalView;
{        ReadStringFromINI('Table '+IntToStr(CurTable)+' HEADER','PhysicalView','',Unused);}
        cn:=InsertVariables(Conditions,Unused);
{        ReadStringFromINI('Table '+IntToStr(CurTable)+' HEADER','Conditions','',Unused);}
         WriteLog('Open Table: '+pv);
        WriteLog('            '+cn);
        WriteLog('            '+SortField);
        WriteLog('Distinct    '+Distinct);
        if Distinct='' then CurTableQry:=sql.Select(pv,'',cn,SortField)
         else CurTableQry:=sql.SelectDistinct(pv,Distinct,cn,SortField);
        if sql.Error<>0 then WriteLog('Fail') else WriteLog('Ok');
        application.processmessages;
        CurRecord:=0;
      end;
    if sql.Error<>0 then
      begin ErrorCode:=sql.Error;DoCancel:=true;
      break; end;
   try
    CurTableQry.First;
    DataSrc:=dsMem;
    InEof:=false;
    if CurTableQry.Eof then FileSeek(fo,-6,1)
     else
      repeat
        IncRecNumb;
        repeat
          SkipWrite:=false;
          MFileRead(fi,c,1);
{          if c='&' then
            if c=' ' then;}
          CheckCSubmit(false);
          if not SkipWrite then FileWrite(fo,c,1);
        until InEOF;
        CurMemPos:=RowDef;
        CurTableQry.Next;
        inc(CurRecord);
      until CurTableQry.Eof or DoCancel;

    CurMemPos:=LCpos;
    MemEnd:=LRDend;
    DataSrc:=Lds;

    InEof:=false;
   except
     on EDataBaseError do
       begin ErrorCode:=ETableNotFound;DoCancel:=true;
       break; end;
   end;
   until true;
   freemem(RowDef,RowDefSize);
   CurWork:='Заполнение шаблона';
   LastCWord:='';
   CurTableQry.free;
  end; {ProceedTableRow;}

{------------------------------------------------------------------------}
  procedure ProceedBlock(bnum:char);
  var
    BlockDef : pchar;
    PV,CND,SF: string;
    TNum,Lct : integer;
    NCpos,
    NRDend : pchar;
    LCpos,
    LRDend : pchar;
    LastBlockQry : TQuery;
    LMainBlock   : char;
    Lds    : integer;
    Dst:string;
{------------------------------------------------------------------------}
  procedure CheckEndBlock(bnum:char);
  var j:integer;
      n:char;
  begin
   ts:='&';
   repeat
     MFileRead(fi,b,1);c:=chr(b);
     ts:=ts+c;
   until not IsAlpha(c) or InEof;
   n:=ts[length(ts)];
   delete(ts,length(ts),1);
   if (ts='&BLOCK') and (n=bnum) then {submit strings}
      begin
       bnum:=c;
       ts:='';
       repeat
         MFileRead(fi,b,1);c:=chr(b);
         ts:=ts+c;
       until not IsAlpha(c) or InEof;
       while (c<>'}') and (not InEof) do
         begin
            MFileRead(fi,b,1);c:=chr(b);
            NCpos^:=c;inc(NCpos);
         end;
       if ts='END&' then {block end}
            EndOfBlock:=true;
      end
    else
      begin
        for j:=1 to length(ts) do
          begin
            NCpos^:=ts[j];inc(NCpos);
          end;
        NCpos^:=n;inc(NCpos);
      end;
  end;
{------------------------------------------------------------------------}
  begin {CheckEndBlock;}
    CurWork:='Заполнение блока';
{    IncTableNumb;}
    getmem(BlockDef,BlockDefSize);
    NCPos:=BlockDef;
    LW:='';
    EndofBlock:=false;
    while not InEof and not EndofBlock do
      begin
        MFileRead(fi,c,1);
        if c='&' then CheckEndBlock(bnum)
          else begin
                 NCPos^:=c;inc(NCpos);
               end;
      end;
    NRDend:=NCPos-1;
    NCpos:=BlockDef;
    MainBlockQry:=CurBlockQry;
    LMainBlock:=MainBlock;
    MainBlock:=CurBlock;

    LCPos:=CurMemPos;CurMemPos:=NCPos;
    LRDend:=MemEnd;MemEnd:=NRDend;
    Lds:=DATASrc;
    LastBlockQry:=CurBlockQry;

   repeat
    PV:=ReadStringFromINI('Block '+bnum+' HEADER','PhysicalView','',Unused);
    CND:=ReadStringFromINI('Block '+bnum+' HEADER','Conditions','',Unused);
    SF:=ReadStringFromINI('Block '+bnum+' HEADER','SortField','',Unused);
    Dst:=ReadStringFromINI('Block '+bnum+' HEADER','Distinct','',Unused);

    InsertVariables(CND,Unused);

    CurBlock:=bnum;

    if PV<>'' then
      begin
        WriteLog('Open Block: '+pv);
        WriteLog('            '+cnd);
        WriteLog('            '+SF);
        WriteLog('Distinct    '+Dst);
        if Dst='' then CurBlockQry:=sql.Select(PV,'',CND,SF)
          else CurBlockQry:=sql.SelectDistinct(PV,Dst,CND,SF);
        if sql.Error<>0 then WriteLog('Fail') else WriteLog('Ok');
        application.processmessages;
        CurRecord:=0;
      end;
    if sql.Error<>0 then
      begin ErrorCode:=sql.Error;DoCancel:=true;
      break; end;
   try
    CurBlockQry.First;
    DataSrc:=dsMem;
    InEof:=false;
    TNum:=CurTable;
    Lct:=RTables[CurTable+1].StartRow;
    if not CurBlockQry.Eof then
      repeat
        IncRecNumb;
        CurTable:=TNum;
        RTables[CurTable+1].StartRow:=Lct;
        repeat
          SkipWrite:=false;
          MFileRead(fi,c,1);
          CheckCSubmit(true);
          if not SkipWrite then FileWrite(fo,c,1);
        until InEOF;
        CurMemPos:=BlockDef;
        CurBlockQry.Next;
        inc(CurRecord);
      until CurBlockQry.Eof or DoCancel;

    CurMemPos:=LCpos;
    MemEnd:=LRDend;
    DataSrc:=Lds;
    CurBlock:=MainBlock;
    MainBlock:=LMainBlock;

    InEof:=false;
   except
     on EDataBaseError do
       begin ErrorCode:=EBlockTableNotFound;DoCancel:=true;
       break; end;
   end;
   until true;
   CurBlockQry.free;
   CurBlockQry:=LastBlockQry;
   freemem(BlockDef,BlockDefSize);
   CurWork:='Заполнение шаблона';
  end; {ProceedBlock;}
{------------------------------------------------------------------------}
function CalcRecordsSize:longint;
var
  i,r,rc:integer;
  pv,cn:string;
begin
  r:=0;
  for i:=1 to TablesCount do
    with RTables[i] do
      if PhysicalView<>'' then
       begin
        rc:=0;
        if pos('~',Conditions)>0 then
          begin
            rc:=sql.RecordCount(PhysicalView,
             ReadStringFromINI('Table '+Inttostr(i)+' Header','ConditionForRecordCount','',Unused));
            r:=r+rc;
          end
          else begin rc:=sql.RecordCount(PhysicalView,Conditions); r:=r+rc; end;
        WriteLog('Record Count+=Table,'+inttostr(rc));
       end;

  for i:=1 to BlocksCount do
    begin
     pv:=ReadStringFromINI('Block '+IntToStr(i)+' HEADER','PhysicalView','',Unused);
     cn:=ReadStringFromINI('Block '+IntToStr(i)+' HEADER','ConditionForRecordCount','UseStdCond',Unused);
     if cn='UseStdCond' then
       cn:=ReadStringFromINI('Block '+IntToStr(i)+' HEADER','Conditions','',Unused);
     rc:=0;
     if pv<>'' then begin rc:=sql.RecordCount(pv,cn); r:=r+rc; end;
     WriteLog('Record Count+=Block,'+inttostr(rc));
    end;
  CalcRecordsSize:=longint(r)*RecEstSize;
end;
{------------------------------------------------------------------------}
function IsFreeFile(var OutRepFile:string):boolean;
var
  f:file;
begin
 result:=true;
 try {$I-}
  system.assign(f,OutRepFile);
  system.erase(f);
   except on ex:EInOutError do
     if ex.message='File access denied' then
             Result:=false;
 end;
end;

procedure DoSkipPictrue;
var
  buf:pchar;
  Count:integer;
  rev:boolean;
begin
  getmem(buf,101);
  rev:=false;
  repeat
    Count:=FileRead(fi,buf^,100);
    if pos('{',buf) > 0 then begin rev:=true;break; end;
    AddProgress(Count);
    FileWrite(fo,buf^,Count);
  until Count<>100;
  if rev then FileSeek(fi,-Count,1);
  freemem(buf);
  SkipPicture:=false;
end;

begin {doMakeReport}
  ErrorCode:=0;
  LoadData(INIFileName);
  WriteLog('Load parameters from '+INIFileName);
 {$I-}
  WriteLog('Open template '+RTFFileName);
  fi:=fileOpen(RTFFileName,fmShareDenyNone);
  if fi<0 then
    begin
      MessageBox(ParentHandle,'Не удается открыть файл формы.','Ошибка',0);
      ErrorCode:=EFormFileNotFound;
      Result:=ErrorCode;
      exit;
    end;
  WriteLog('Open for writing '+OutRepFile);
  if not IsFreeFile(OutRepFile) then
    begin
      MessageBox(ParentHandle,'Не удается создать файл отчета.','Ошибка',0);
      FileClose(fi);
      ErrorCode:=EOutRepFileNotCreated;
      Result:=ErrorCode;
      exit;
    end;
  fo:=fileCreate(OutRepFile);
  if fo<0 then
    begin
      MessageBox(ParentHandle,'Не удается создать файл отчета.','Ошибка',0);
      ErrorCode:=EOutRepFileNotCreated;
      FileClose(fi);
      Result:=ErrorCode;
      exit;
    end;
  InEof:=false;
  ContWord:=false;
  SkipPicture:=true;
  LastCWord:='';
  CWord:='';
  CurTable:=0;
  CurBlock:='0';
  Fnt:=false;
  ss:=TMemoryStream.Create;
  DataSrc:=dsFile;
  MaxProgr:={CalcRecordsSize + }FileSeek(fi,0,2) * 21 div 20;
  CurWork:='Чтение шаблона';
  if PhysicalView<>'' then
     begin
       CurQry:=sql.Select(PhysicalView,'',Conditions,'');
       CurRecord:=0;
       IncRecNumb;
     end;
  FileSeek(fi,0,0);
  repeat
    MFileRead(fi,b,1);
    c:=UpCase(chr(b));
    SkipWrite:=false;
    CheckCSubmit(true);
    if not SkipWrite then FileWrite(fo,b,1);
    if SkipPicture then DoSkipPictrue;
  until InEof or DoCancel;
  FileClose(fi);
  FileClose(fo);
  RepINI.Free;
  ss.free;
  CurProgr:=MaxProgr;
  CurWork:='Завершена успешно';
  CurQry.free;
  CallUP;
  DoMakeReport:=ErrorCode;
end; {doMakeReport}

procedure tReportMaker.LoadData(INIFileName:string);
var
  i:integer;
  ts:string;
begin
  RepINI := TIniFile.Create(INIFileName);
  Conditions:= ReadStringFromINI('HEADER','Conditions','',Unused);
  PhysicalView := ReadStringFromINI('HEADER','PhysicalView','',Unused);
  TablesCount  := RepINI.ReadInteger('HEADER','TablesCount',0);
  BlocksCount  := RepINI.ReadInteger('HEADER','BlocksCount',0);
  DoLog        := RepINI.ReadBool('HEADER','DoLOG',FALSE);
  for i:=1 to TablesCount do
    with RTables[i] do
      begin
         ts:='Table '+Inttostr(i)+' ';
         PhysicalView := ReadStringFromINI(ts+'Header','PhysicalView','',Unused);
         Conditions   := ReadStringFromINI(ts+'Header','Conditions','',Unused);
         SortField    := ReadStringFromINI(ts+'Header','SortField','',Unused);
         SortDirect   := ReadStringFromINI(ts+'Header','SortDirect','',Unused);
         StartRow     := RepINI.ReadInteger(ts+'Header','StartRow',1);
         DBTable      := RepINI.ReadBool(ts+'Header','DBTable',false);
         Distinct     := ReadStringFromINI(ts+'Header','Distinct','',Unused);
      end;
end;

procedure TReportMaker.AddParam(const s:string);
begin
  Parameters.add(s);
end;
procedure TReportMaker.ClearParam;
begin
  Parameters.clear;
end;

function tReportMaker.ReadStringFromINI(const Sect,Ident,Def:LitString;var spec:boolean):string;
var
  s:string;
begin
  s:=RepINI.ReadString(Sect,Ident,Def);
  if sql.prefixTable='"DBO".' then
    while pos('"DBA".',s)>0 do s[pos('"DBA".',s)+3]:='O';
  ReadStringFromINI:=InsertVariables(s,spec);
end;

end.
