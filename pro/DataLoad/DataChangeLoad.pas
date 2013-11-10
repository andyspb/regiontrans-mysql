unit DataChangeLoad;

interface
uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, toolbtn, StdCtrls, Buttons, BMPBtn, ToolWin, ComCtrls, Sqlctrls,
  LblCombo,Printers, LblEdtDt, ExtCtrls,TSQLCLS,SqlGrid, DB,StrUtils,FunChar,
   DBTables, Lbsqlcmb, OleServer, Word2000,XMLDOM, DBClient, MConnect, EntrySec;

function ReadFiles1(strId: string):TStrings;
function WriteFiles(s: string;TempL1:TStrings): integer;
function DelFiles(s:string):integer;
function ChangeFile(j:integer):integer;
function ChangeOtheFile(f:integer;s,s2,s3:string):integer;
function DeleteFromOtherFile(f:integer;s,s2:string):integer;
function ChangeComma(s:string):integer;
function FindStr(i:integer;s:string):string ;
function FindReplaceStr(i:integer;s1,s2,s3:string):string;
function FindReplaceNumber(i:integer;s1,s2,s3:string):string;
function DatInsert:integer;
function InsertToTable(s1,s2:string):integer;
Function OrderNum(dat1:string):string;
Function SendNum(dat1:string):string;
procedure WriteLog(s2:string);

implementation

procedure WriteLog(s2:string);
var
M:TextFile;
begin
               AssignFile(m,systemdir+'LoadData.log');        {очищаем файл}
               {$I-}
               Append(m)  ;
               {$I-}
               Writeln (m,s2);
               CloseFile (m);
end;


function ChangeFile(j:integer):integer;
var
s, s1,fs,fs1 : string;
r1,r2,r3,r4,r5,r6,r7,r8:string;
i,indic,k,l,f:integer;
TempList11: TStrings;
q:TQuery;
M:TextFile;
label t1;
begin
ChangeFile:=0;{сначала считаем что все будет хорошо}
//goto t1;
if not FileExists(systemdir+'LoadData.log') then
       begin
       f:=FileCreate(systemdir+'LoadData.log'); {создаем если нет файла}
       FileClose(f) ;
       end;
               AssignFile(m,systemdir+'LoadData.log');        {очищаем файл}
               {$I-}
               Rewrite(m)  ;
               {$I-}
               Writeln (m,'Загружаем данные ');
               CloseFile(m);
//------------------------------

//TempList11.Create;
{Bank---------------------------------------------------------------}
s:='Bank';
TempList11:=ReadFiles1(s) ;
i:=0;
k:=0;
while (i <= TempList11.Count-1) do
begin
s1:='';
fs:='';
fs1:='';
indic:=0;{инициализация}
s1:= TempList11.Strings[i];
fs:=FindStr(1,s1);
r1:= FindStr(2,s1);
if r1 = 'NULL' then
 r1:= ' is '+ r1
 else r1:='= '+r1;
r2:= FindStr(3,s1);
if r2 = 'NULL' then
 r2:= ' is '+ r2
 else r2:='= '+r2;
q:=sql.Select(s,'Ident','Name ='+fs+' and KorCount '+r1+
              ' and BIK '+ r2,'') ;
if (not q.Eof) then
begin
     fs1:=q.fieldByName('Ident').asstring ;
     indic:=1;    {указывает что такая запись есть в базе}
end else
   begin
     fs1:=IntToStr(sql.FindNextInteger('Ident',s,'',MaxLongint));
     fs1:=IntToStr(StrToInt(fs1)+k) ;
     k:=k+1; {увеличиваем максимальное значение идента каждый раз на 1}
   end;
q.free;
fs:=FindStr(0,s1);

if StrToInt(fs1) <> StrToInt(fs) then
begin
ChangeOtheFile(9,'Clients',fs1,fs);

 if indic = 0 then
   TempList11.Strings[i]:= FindReplaceStr(0,s1,fs1,fs)
 else TempList11.Delete(i);   {если такая запись уже есть то удоляем из файла}
end  else  {if StrToInt(fs1) <> StrToInt(fs)}
      if indic = 1 then TempList11.Delete(i);  {если такая запись уже есть то удоляем из файла}
   if indic = 0 then   i:=i+1; {если удалили запись из листа то индекс не меняем}
end; {while (i < TempList11.Count-1) }
if TempList11.Count<>0 then
    WriteFiles(s,TempList11) {если лист не пустой то переписываем файл}
else   DelFiles(s);    {если лист пустой то и файл удоляем}
if i<>0 then
     WriteLog('    Подготовленно '+IntToStr(i)+' записи для таблицы: '+s);
TempList11.Clear;
{End Bank--------------------------------------------------------------------------}
{Onreason---------------------------------------------------------------}
s:='Onreason';
TempList11:=ReadFiles1(s) ;
i:=0;
k:=0;
while (i <= TempList11.Count-1) do
begin
s1:='';
fs:='';
fs1:='';
indic:=0;{инициализация}
s1:= TempList11.Strings[i];
fs:=FindStr(1,s1);
q:=sql.Select(s,'Ident','Name ='+fs,'') ;
if (not q.Eof) then
begin
     fs1:=q.fieldByName('Ident').asstring ;  {ищем идент в базе}
     indic:=1;    {указывает что такая запись есть в базе}
end else
    begin
     fs1:=IntToStr(sql.FindNextInteger('Ident',s,'',MaxLongint));   {берем максимальный идент из базы}
     fs1:=IntToStr(StrToInt(fs1)+k) ;
     k:=k+1; {увеличиваем максимальное значение идента каждый раз на 1}
    end;
q.free;
fs:=FindStr(0,s1);  {ищем идент в файле}
if StrToInt(fs1) <> StrToInt(fs) then    {сравниваем новый и старый иденты}
begin
ChangeOtheFile(13,'Clients',fs1,fs);
 if indic = 0 then
   TempList11.Strings[i]:= FindReplaceStr(0,s1,fs1,fs)
 else TempList11.Delete(i);   {если такая запись уже есть то удоляем из файла}
end  else  {if StrToInt(fs1) <> StrToInt(fs)}
      if indic = 1 then TempList11.Delete(i);  {если такая запись уже есть то удоляем из файла}
   if indic = 0 then   i:=i+1; {если удалили запись из листа то индекс не меняем}
end; {while (i < TempList11.Count-1) }
if TempList11.Count<>0 then
    WriteFiles(s,TempList11) {если лист не пустой то переписываем файл}
else   DelFiles(s);    {если лист пустой то и файл удоляем}
if i<>0 then
     WriteLog('    Подготовленно '+IntToStr(i)+' записи для таблицы: '+s);
TempList11.Clear;
{End OnReason--------------------------------------------------------------------------}
{City---------------------------------------------------------------}
s:='City';
TempList11:=ReadFiles1(s) ;
i:=0;
k:=0;
while (i <= TempList11.Count-1) do
begin
s1:='';
fs:='';
fs1:='';
indic:=0;{инициализация}
s1:= TempList11.Strings[i];
fs:=FindStr(1,s1);
q:=sql.Select(s,'Ident','Name ='+fs,'') ;
if (not q.Eof) then
begin
     fs1:=q.fieldByName('Ident').asstring ;  {ищем идент в базе}
     indic:=1;    {указывает что такая запись есть в базе}
end else
    begin
     fs1:=IntToStr(sql.FindNextInteger('Ident',s,'',MaxLongint));   {берем максимальный идент из базы}
     fs1:=IntToStr(StrToInt(fs1)+k) ;
     k:=k+1; {увеличиваем максимальное значение идента каждый раз на 1}
    end;
q.free;
fs:=FindStr(0,s1);  {ищем идент в файле}
if StrToInt(fs1) <> StrToInt(fs) then    {сравниваем новый и старый иденты}
begin
ChangeOtheFile(4,'Acceptor',fs1,fs);
ChangeOtheFile(18,'Clients',fs1,fs);
ChangeOtheFile(3,EntrySec.send_table {'`Send`'},fs1,fs);
 if indic = 0 then
   TempList11.Strings[i]:= FindReplaceStr(0,s1,fs1,fs)
 else TempList11.Delete(i);   {если такая запись уже есть то удоляем из файла}
end  else  {if StrToInt(fs1) <> StrToInt(fs)}
      if indic = 1 then TempList11.Delete(i);  {если такая запись уже есть то удоляем из файла}
   if indic = 0 then   i:=i+1; {если удалили запись из листа то индекс не меняем}
end; {while (i < TempList11.Count-1) }
if TempList11.Count<>0 then
    WriteFiles(s,TempList11) {если лист не пустой то переписываем файл}
else   DelFiles(s);    {если лист пустой то и файл удоляем}
if i<>0 then
     WriteLog('    Подготовленно '+IntToStr(i)+' записи для таблицы: '+s);
TempList11.Clear;
{End City--------------------------------------------------------------------------}
{Acceptor---------------------------------------------------------------}
s:='Acceptor';
TempList11:=ReadFiles1(s) ;
i:=0;
k:=0;
while (i <= TempList11.Count-1) do
begin
s1:='';
fs:='';
fs1:='';
indic:=0;{инициализация}
s1:= TempList11.Strings[i];
fs:=FindStr(1,s1);  {ищем имя в файле}
r1:=FindStr(4,s1);
r2:=FindStr(5,s1);
if r2 = 'NULL' then
 r2:= ' is '+ r2
 else r2:='= '+r2;
q:=sql.Select(s,'Ident','Name ='+fs + ' and City_Ident='+ r1+
              ' and Address '+r2,'') ;    {ищем нет ли такого имени уже в базе}
if (not q.Eof) then
begin
     fs1:=q.fieldByName('Ident').asstring ;  {ищем идент в базе}
     indic:=1;    {указывает что такая запись есть в базе}
end else
    begin
     fs1:=IntToStr(sql.FindNextInteger('Ident',s,'',MaxLongint));   {берем максимальный идент из базы}
     fs1:=IntToStr(StrToInt(fs1)+k) ;
     k:=k+1; {увеличиваем максимальное значение идента каждый раз на 1}
    end;
q.free;
fs:=FindStr(0,s1);  {ищем идент в файле}
if StrToInt(fs1) <> StrToInt(fs) then    {сравниваем новый и старый иденты}
begin
ChangeOtheFile(4,EntrySec.send_table {'`Send`'},fs1,fs);
 if indic = 0 then
   TempList11.Strings[i]:= FindReplaceStr(0,s1,fs1,fs)
 else TempList11.Delete(i);   {если такая запись уже есть то удоляем из файла}
end  else  {if StrToInt(fs1) <> StrToInt(fs)}
      if indic = 1 then TempList11.Delete(i);  {если такая запись уже есть то удоляем из файла}
   if indic = 0 then   i:=i+1; {если удалили запись из листа то индекс не меняем}
end; {while (i < TempList11.Count-1) }
if TempList11.Count<>0 then
    WriteFiles(s,TempList11) {если лист не пустой то переписываем файл}
else   DelFiles(s);    {если лист пустой то и файл удоляем}
if i<>0 then
     WriteLog('    Подготовленно '+IntToStr(i)+' записи для таблицы: '+s);
TempList11.Clear;
{End Acceptor--------------------------------------------------------------------------}
{NameGood---------------------------------------------------------------}
s:='NameGood';
TempList11:=ReadFiles1(s) ;
i:=0;
k:=0;
while (i <= TempList11.Count-1) do
begin
s1:='';
fs:='';
fs1:='';
indic:=0;{инициализация}
s1:= TempList11.Strings[i];
fs:=FindStr(1,s1);  {ищем имя в файле}
q:=sql.Select(s,'Ident','Name ='+fs,'') ;    {ищем нет ли такого имени уже в базе}
if (not q.Eof) then
begin
     fs1:=q.fieldByName('Ident').asstring ;  {ищем идент в базе}
     indic:=1;    {указывает что такая запись есть в базе}
end else
     begin
     fs1:=IntToStr(sql.FindNextInteger('Ident',s,'',MaxLongint));   {берем максимальный идент из базы}
     fs1:=IntToStr(StrToInt(fs1)+k) ;
     k:=k+1; {увеличиваем максимальное значение идента каждый раз на 1}
    end;
q.free;
fs:=FindStr(0,s1);  {ищем идент в файле}
if StrToInt(fs1) <> StrToInt(fs) then    {сравниваем новый и старый иденты}
begin
ChangeOtheFile(6,EntrySec.send_table {'`Send`'},fs1,fs);
 if indic = 0 then
   TempList11.Strings[i]:= FindReplaceStr(0,s1,fs1,fs)
 else TempList11.Delete(i);   {если такая запись уже есть то удоляем из файла}
end  else  {if StrToInt(fs1) <> StrToInt(fs)}
      if indic = 1 then TempList11.Delete(i);  {если такая запись уже есть то удоляем из файла}
   if indic = 0 then   i:=i+1; {если удалили запись из листа то индекс не меняем}
end; {while (i < TempList11.Count-1) }
if TempList11.Count<>0 then
    WriteFiles(s,TempList11) {если лист не пустой то переписываем файл}
else   DelFiles(s);    {если лист пустой то и файл удоляем}
if i<>0 then
     WriteLog('    Подготовленно '+IntToStr(i)+' записи для таблицы: '+s);
TempList11.Clear;
{End NameGood--------------------------------------------------------------------------}

{Supplier---------------------------------------------------------------}
s:='Supplier';
TempList11:=ReadFiles1(s) ;
i:=0;
k:=0;
while (i <= TempList11.Count-1) do
begin
s1:='';
fs:='';
fs1:='';
indic:=0;{инициализация}
s1:= TempList11.Strings[i];
fs:=FindStr(1,s1);  {ищем имя в файле}
q:=sql.Select(s,'Ident','Name ='+fs,'') ;    {ищем нет ли такого имени уже в базе}
if (not q.Eof) then
begin
     fs1:=q.fieldByName('Ident').asstring ;  {ищем идент в базе}
     indic:=1;    {указывает что такая запись есть в базе}
end else
    begin
     fs1:=IntToStr(sql.FindNextInteger('Ident',s,'',MaxLongint));   {берем максимальный идент из базы}
     fs1:=IntToStr(StrToInt(fs1)+k) ;
     k:=k+1; {увеличиваем максимальное значение идента каждый раз на 1}
    end;
q.free;
fs:=FindStr(0,s1);  {ищем идент в файле}
if StrToInt(fs1) <> StrToInt(fs) then    {сравниваем новый и старый иденты}
begin
ChangeOtheFile(7,EntrySec.send_table {'`Send`'},fs1,fs);
 if indic = 0 then
   TempList11.Strings[i]:= FindReplaceStr(0,s1,fs1,fs)
 else TempList11.Delete(i);   {если такая запись уже есть то удоляем из файла}
end  else  {if StrToInt(fs1) <> StrToInt(fs)}
      if indic = 1 then TempList11.Delete(i);  {если такая запись уже есть то удоляем из файла}
   if indic = 0 then   i:=i+1; {если удалили запись из листа то индекс не меняем}
end; {while (i < TempList11.Count-1) }
if TempList11.Count<>0 then
    WriteFiles(s,TempList11) {если лист не пустой то переписываем файл}
else   DelFiles(s);    {если лист пустой то и файл удоляем}
if i<>0 then
     WriteLog('    Подготовленно '+IntToStr(i)+' записи для таблицы: '+s);
TempList11.Clear;
{End Supplier--------------------------------------------------------------------------}

{Clients---------------------------------------------------------------}
s:='Clients';
TempList11:=ReadFiles1(s) ;
i:=0;
k:=0;
while (i <= TempList11.Count-1) do
begin
s1:='';
fs:='';
fs1:='';
indic:=0;{инициализация}
s1:= TempList11.Strings[i];
fs:=FindStr(2,s1);  {ищем имя в файле}
r1:=FindStr(1,s1);
r2:=FindStr(9,s1);
If (r2 = '') or (r2 = 'NULL') then   {проверяем на NULL}
  r2:= ' is NULL'
else
  r2:= ' = '+ r2;

r3:=FindStr(14,s1);
If (r3 = '') or (r3 = 'NULL') then   {проверяем на NULL}
  r3:= ' is NULL'
else
  r3:= ' = '+ r3;
r4:=FindStr(18,s1);
q:=sql.Select(s,'Ident','Acronym ='+fs+ ' and Name='+r1+ ' and Bank_Ident'+r2+
             ' and ClientType_Ident '+r3+' and City_Ident='+r4,'') ;    {ищем нет ли такого имени уже в базе}
if (not q.Eof) then
begin
     fs1:=q.fieldByName('Ident').asstring ;  {ищем идент в базе}
     indic:=1;    {указывает что такая запись есть в базе}
end else
    begin
     fs1:=IntToStr(sql.FindNextInteger('Ident',s,'',MaxLongint));   {берем максимальный идент из базы}
     fs1:=IntToStr(StrToInt(fs1)+k) ;
     k:=k+1; {увеличиваем максимальное значение идента каждый раз на 1}
    end;
q.free;
fs:=FindStr(0,s1);  {ищем идент в файле}
if StrToInt(fs1) <> StrToInt(fs) then    {сравниваем новый и старый иденты}
begin
ChangeOtheFile(0,'Address',fs1,fs);
ChangeOtheFile(0,'Contact',fs1,fs);
ChangeOtheFile(0,'Contract',fs1,fs);
ChangeOtheFile(2,'Forwarder',fs1,fs);
ChangeOtheFile(1,EntrySec.order_table {'`Order`'},fs1,fs);
ChangeOtheFile(1,EntrySec.send_table {'`Send`'},fs1,fs);
ChangeOtheFile(2,EntrySec.send_table {'`Send`'},fs1,fs);
 if indic = 0 then
   TempList11.Strings[i]:= FindReplaceStr(0,s1,fs1,fs)
 else
   begin
      TempList11.Delete(i);   {если такая запись уже есть то удоляем из файла}
      DeleteFromOtherFile(0,'Address',fs1);   {удоляем из вспомогательных таблиц}
      DeleteFromOtherFile(0,'Contact',fs1);   {удоляем из вспомогательных таблиц}
      DeleteFromOtherFile(0,'Contract',fs1);  {удоляем из вспомогательных таблиц}
    end;
end  else  {if StrToInt(fs1) <> StrToInt(fs)}
      if indic = 1 then
       begin
        TempList11.Delete(i);   {если такая запись уже есть то удоляем из файла}
        DeleteFromOtherFile(0,'Address',fs1);   {удоляем из вспомогательных таблиц}
        DeleteFromOtherFile(0,'Contact',fs1);   {удоляем из вспомогательных таблиц}
        DeleteFromOtherFile(0,'Contract',fs1);  {удоляем из вспомогательных таблиц}
       end;
   if indic = 0 then   i:=i+1; {если удалили запись из листа то индекс не меняем}
end; {while (i < TempList11.Count-1) }
if TempList11.Count<>0 then
    WriteFiles(s,TempList11) {если лист не пустой то переписываем файл}
else   DelFiles(s);    {если лист пустой то и файл удоляем}
if i<>0 then
     WriteLog('    Подготовленно '+IntToStr(i)+' записи для таблицы: '+s);
TempList11.Clear;
{End Clients--------------------------------------------------------------------------}

{Forwarder---------------------------------------------------------------}
s:='Forwarder';
TempList11:=ReadFiles1(s) ;
i:=0;
k:=0;
while (i <= TempList11.Count-1) do
begin
s1:='';
fs:='';
fs1:='';
indic:=0;{инициализация}
s1:= TempList11.Strings[i];
fs:=FindStr(1,s1);  {ищем имя в файле}
q:=sql.Select(s,'Ident','Name ='+fs,'') ;    {ищем нет ли такого имени уже в базе}
if (not q.Eof) then
begin
     fs1:=q.fieldByName('Ident').asstring ;  {ищем идент в базе}
     indic:=1;    {указывает что такая запись есть в базе}
end else
    begin
     fs1:=IntToStr(sql.FindNextInteger('Ident',s,'',MaxLongint));   {берем максимальный идент из базы}
     fs1:=IntToStr(StrToInt(fs1)+k) ;
     k:=k+1; {увеличиваем максимальное значение идента каждый раз на 1}
    end;
q.free;
fs:=FindStr(0,s1);  {ищем идент в файле}
if StrToInt(fs1) <> StrToInt(fs) then    {сравниваем новый и старый иденты}
begin
ChangeOtheFile(21,'Clients',fs1,fs);
ChangeOtheFile(5,EntrySec.send_table {'`Send`'},fs1,fs);
 if indic = 0 then
   TempList11.Strings[i]:= FindReplaceStr(0,s1,fs1,fs)
 else TempList11.Delete(i);   {если такая запись уже есть то удоляем из файла}
end  else  {if StrToInt(fs1) <> StrToInt(fs)}
      if indic = 1 then TempList11.Delete(i);  {если такая запись уже есть то удоляем из файла}
   if indic = 0 then   i:=i+1; {если удалили запись из листа то индекс не меняем}
end; {while (i < TempList11.Count-1) }
if TempList11.Count<>0 then
    WriteFiles(s,TempList11) {если лист не пустой то переписываем файл}
else   DelFiles(s);    {если лист пустой то и файл удоляем}
if i<>0 then
     WriteLog('    Подготовленно '+IntToStr(i)+' записи для таблицы: '+s);
TempList11.Clear;
{End Forwarder--------------------------------------------------------------------------}
{"Order"---------------------------------------------------------------}
s:=EntrySec.order_table {'`Order`'};  {меняем только идент}
TempList11:=ReadFiles1(s) ;
i:=0;
fs1:=IntToStr(sql.FindNextInteger('Ident',s,'',MaxLongint));   {берем максимальный идент из базы}
while (i <= TempList11.Count-1) do
begin
s1:='';
fs:='';
s1:= TempList11.Strings[i];
fs:=FindStr(0,s1);  {ищем идент в файле}
if StrToInt(fs1) <> StrToInt(fs) then    {сравниваем новый и старый иденты}
begin
TempList11.Strings[i]:= FindReplaceStr(0,s1,fs1,fs)
end ;
i:=i+1;
fs1:=IntToStr(StrToInt(fs1)+1);{}
end; {while (i < TempList11.Count-1) }
if TempList11.Count<>0 then
    WriteFiles(s,TempList11); {если лист не пустой то переписываем файл}
if i<>0 then
     WriteLog('    Подготовленно '+IntToStr(i)+' записи для таблицы: '+s);
TempList11.Clear;
{End "Order"--------------------------------------------------------------------------}
{"Send"---------------------------------------------------------------}
s:=EntrySec.send_table {'`Send`'};  {меняем только идент}
TempList11:=ReadFiles1(s) ;
i:=0;
fs1:=IntToStr(sql.FindNextInteger('Ident',s,'',MaxLongint));   {берем максимальный идент из базы}
while (i <= TempList11.Count-1) do
begin
s1:='';
fs:='';
s1:= TempList11.Strings[i];
fs:=FindStr(0,s1);  {ищем идент в файле}
if StrToInt(fs1) <> StrToInt(fs) then    {сравниваем новый и старый иденты}
begin
ChangeOtheFile(0,'SendPack',fs1,fs);
ChangeOtheFile(0,'SendPackTariff',fs1,fs);
TempList11.Strings[i]:= FindReplaceStr(0,s1,fs1,fs)
end ;
i:=i+1;
fs1:=IntToStr(StrToInt(fs1)+1);{}
end; {while (i < TempList11.Count-1) }
if TempList11.Count<>0 then
    WriteFiles(s,TempList11); {если лист не пустой то переписываем файл}
if i<>0 then
     WriteLog('    Подготовленно '+IntToStr(i)+' записи для таблицы: '+s);
TempList11.Clear;
{End "Send"--------------------------------------------------------------------------}
TempList11.free;
l:=0;
//t1:
ChangeComma('Bank');
ChangeComma('OnReason');
ChangeComma('City');
ChangeComma('Forwarder');
ChangeComma('Acceptor');
ChangeComma('NameGood');
ChangeComma('Supplier');
ChangeComma('Clients');
ChangeComma('Address');
ChangeComma('Contact');
ChangeComma('Contract');
ChangeComma('SendPack');
ChangeComma('SendPackTariff');
//t1:
 WriteLog('Вносим данные в таблицы.');
sql.StartTransaction;
l:=DatInsert;
if l=0 then
begin
sql.Commit ;
WriteLog('Все данные в таблицы внесены успешно!!!');

end
else
    begin
     sql.Rollback;
     ChangeFile:=1;
    end;
end;






function DatInsert:integer;
var
TempList11: TStrings;
Filds,s:string;
Tabl: string;
Pchar1:PChar;
NumNew,NumOld,dat1:string;
i,j:integer;
s2,s3:string;
begin
 DatInsert:=0;
{Bank---------------------------------------}
 Tabl:='Bank';
 Filds:='Ident,Name,KorCount,BIK';
 if InsertToTable(Tabl,Filds)<>0 then
   begin
    DatInsert:=1;
    Pchar1:=Pchar('Данные в таблицу '+Tabl+' не загружены!');
    Application.MessageBox(Pchar1,'Сообщение!',0);
    exit
   end;
{END Bank-----------------------------------}

{OnReason---------------------------------------}
 Tabl:='OnReason';
 Filds:='Ident,Name';
 if InsertToTable(Tabl,Filds)<>0 then
   begin
    DatInsert:=1;
    Pchar1:=Pchar('Данные в таблицу '+Tabl+' не загружены!');
    Application.MessageBox(Pchar1,'Сообщение!',0);
    exit
   end;
{END OnReason-----------------------------------}

{City---------------------------------------}
 Tabl:='City';
 Filds:='Ident,Name,Tariff200,Tariff500,Tariff1000,Tariff2000,TariffMore2000,Sending,'+
  'Distance,Check,GDStrah';
 if InsertToTable(Tabl,Filds)<>0 then
   begin
    DatInsert:=1;
    Pchar1:=Pchar('Данные в таблицу '+Tabl+' не загружены!');
    Application.MessageBox(Pchar1,'Сообщение!',0);
    exit
   end;
{END City-----------------------------------}

{Acceptor---------------------------------------}
 Tabl:='Acceptor';
 Filds:='Ident,Name,Regime,Phone,City_Ident,Address,Coment';
 if InsertToTable(Tabl,Filds)<>0 then
   begin
    DatInsert:=1;
    Pchar1:=Pchar('Данные в таблицу '+Tabl+' не загружены!');
    Application.MessageBox(Pchar1,'Сообщение!',0);
    exit
   end;
{END Acceptor-----------------------------------}

{NameGood---------------------------------------}
 Tabl:='NameGood';
 Filds:='Ident,Name,Clients_Ident';
 if InsertToTable(Tabl,Filds)<>0 then
   begin
    DatInsert:=1;
    Pchar1:=Pchar('Данные в таблицу '+Tabl+' не загружены!');
    Application.MessageBox(Pchar1,'Сообщение!',0);
    exit
   end;
{END NameGood-----------------------------------}

{Supplier---------------------------------------}
 Tabl:='Supplier';
 Filds:='Ident,Name';
 if InsertToTable(Tabl,Filds)<>0 then
   begin
    DatInsert:=1;
    Pchar1:=Pchar('Данные в таблицу '+Tabl+' не загружены!');
    Application.MessageBox(Pchar1,'Сообщение!',0);
    exit
   end;
{END Supplier-----------------------------------}

{Clients---------------------------------------}
 Tabl:='Clients';
 Filds:='Ident,Name,Acronym,FullName,Telephone,Fax,Email,INN,'+
       'CalculatCount,Bank_Ident,OKONX,OKPO,InPerson,OnReason_Ident,'+
       'ClientType_Ident,`Start`,DateUpd,Finish,City_Ident,Country_Ident,'+
       'PersonType_Ident,Forwarder_Ident,Kredit,NameGood_Ident,KPP';
 if InsertToTable(Tabl,Filds)<>0 then
   begin
    DatInsert:=1;
    Pchar1:=Pchar('Данные в таблицу '+Tabl+' не загружены!');
    Application.MessageBox(Pchar1,'Сообщение!',0);
    exit
   end;
{END Clients-----------------------------------}

{Address---------------------------------------}
 Tabl:='Address';
 Filds:='Clients_Ident,AddressType_Ident,AdrName';
 if InsertToTable(Tabl,Filds)<>0 then
   begin
    DatInsert:=1;
    Pchar1:=Pchar('Данные в таблицу '+Tabl+' не загружены!');
    Application.MessageBox(Pchar1,'Сообщение!',0);
    exit
   end;
{END Address-----------------------------------}

{Contact---------------------------------------}
 Tabl:='Contact';
 Filds:='Clients_Ident,Name,Phone';
 if InsertToTable(Tabl,Filds)<>0 then
   begin
    DatInsert:=1;
    Pchar1:=Pchar('Данные в таблицу '+Tabl+' не загружены!');
    Application.MessageBox(Pchar1,'Сообщение!',0);
    exit
   end;
{END Contact-----------------------------------}

{Contract---------------------------------------}
 Tabl:='Contract';
 Filds:='Clients_Ident,Number,`Start`,Finish,ContractType_Ident';
 if InsertToTable(Tabl,Filds)<>0 then
   begin
    DatInsert:=1;
    Pchar1:=Pchar('Данные в таблицу '+Tabl+' не загружены!');
    Application.MessageBox(Pchar1,'Сообщение!',0);
    exit
   end;
{END Contract-----------------------------------}

{Forwarder---------------------------------------}
 Tabl:='Forwarder';
 Filds:='Ident,Name,Clients_Ident';
 if InsertToTable(Tabl,Filds)<>0 then
   begin
    DatInsert:=1;
    Pchar1:=Pchar('Данные в таблицу '+Tabl+' не загружены!');
    Application.MessageBox(Pchar1,'Сообщение!',0);
    exit
   end;
{END Forwarder-----------------------------------}

{"Order"---------------------------------------}
 Tabl:=EntrySec.order_table {'`Order`'};
// TempList11.Create;
 TempList11:=ReadFiles1(Tabl);
 i:=0;
 Filds:='Ident,Client_Ident,Number,Dat,Sum,NDS,SumNDS,NSP,DatNow';
 while i<= TempList11.Count-1 do
 begin
 s:=TempList11.Strings[i];
 dat1:= FindStr(3,s);
 NumOld:=FindStr(2,s);
 NumNew:='''' + OrderNum(dat1) + '''';  {ищем новый номер}
 s:= FindReplaceNumber(2,s,NumNew,NumOld);   {меняем старый номер на новый}
  j:=0;   {заменяем все '@,@' на просто ','}
  while (Pos('@,@',s) <> 0) do
   begin
     j:= Pos('@,@',s);
     s2:=copy(s,0,j-1);
     s3:=copy(s,j+3,length(s)-j-2);
     s:=s2+','+s3;
   end;

 if sql.InsertString(Tabl,Filds,s)<>0 then
  begin
    DatInsert:=1;
    WriteLog('    В таблицу: '+Tabl+' не загрузилась следующая '+IntToStr(i)+' запись:');
    WriteLog('      '+s);
    Pchar1:=Pchar('Данные в таблицу '+Tabl+' не загружены!');
    Application.MessageBox(Pchar1,'Сообщение!',0);
    exit
  end;
  i:=i+1;
 end; {while i< TempList11.Count-1}
 if i<>0 then
 WriteLog('    В таблицу: '+Tabl+' загружено '+IntToStr(i)+' записей:');
 TempList11.Free;

{END "Order"-----------------------------------}

{"Send"---------------------------------------}
 Tabl:=EntrySec.send_table {'`Send`'};
// TempList11.Create;
 TempList11:=ReadFiles1(Tabl);
 i:=0;
 Filds:='Ident,Client_Ident,Client_Ident_Sender,City_Ident,Acceptor_Ident,' +
        'Forwarder_Ident,NameGood_Ident,Supplier_Ident,Namber,`Start`,' +
        'Credit,Contract,Inspector_Ident,ContractType_Ident,RollOut_Ident,' +
        'TypeGood_Ident,Weight,DateSend,Volume,CountWeight,Tariff,Fare,' +
        'PackTarif,AddServiceExp,AddServicePack,AddServiceProp,AddServicePrace,' +
        'InsuranceSum,InsurancePercent,InsuranceValue,SumCount,TypeGood_Ident1,' +
        'TypeGood_Ident2,PayType_Ident,NmberOrder,NumberCountPattern,' +
        'PayText,StatusSupp_Ident,DateSupp,SuppText,PackCount,ExpCount,' +
        'PropCount,ExpTarif,PropTarif,Check,Train_Ident,SumWay,NumberWay,' +
        'SumServ,NumberServ,WeightGd,PlaceGd,NumberPP,CountInvoice,PlaceC,' +
        'PayTypeServ_Ident,PayTypeWay_Ident,Invoice_Ident,InsurancePay,' +
        'Akttek_Ident,AddServStr,AddServSum,TypeGood_Ident3,PrivilegedTariff';
 while i<= TempList11.Count-1 do
 begin
 s:=TempList11.Strings[i];
 dat1:= FindStr(9,s);
 NumOld:=FindStr(8,s);
 NumNew:='''' + SendNum(dat1) + '''' ;   {ищем новый номер}
 s:= FindReplaceNumber(8,s,NumNew,NumOld); {меняем старый номер на новый}
   j:=0;   {заменяем все '@,@' на просто ','}
  while (Pos('@,@',s) <> 0) do
   begin
     j:= Pos('@,@',s);
     s2:=copy(s,0,j-1);
     s3:=copy(s,j+3,length(s)-j-2);
     s:=s2+','+s3;
   end;

 if sql.InsertString(Tabl,Filds,s)<>0 then
  begin
    DatInsert:=1;
    WriteLog('    В таблицу: '+Tabl+' не загрузилась следующая '+IntToStr(i)+' запись:');
    WriteLog('      '+s);
    Pchar1:=Pchar('Данные в таблицу '+Tabl+' не загружены!');
    Application.MessageBox(Pchar1,'Сообщение!',0);
    exit
  end;
  i:=i+1;
 end; {while i< TempList11.Count-1}
if i<>0 then
WriteLog('    В таблицу: '+Tabl+' загружено '+IntToStr(i)+' записей:');
 TempList11.Free;

{END "Send"-----------------------------------}



{SendPack---------------------------------------}
 Tabl:='SendPack';
 Filds:='Send_Ident,Name,Count';
 if InsertToTable(Tabl,Filds)<>0 then
   begin
    DatInsert:=1;
    Pchar1:=Pchar('Данные в таблицу '+Tabl+' не загружены!');
    Application.MessageBox(Pchar1,'Сообщение!',0);
    exit
   end;
{END SendPack-----------------------------------}

{SendPackTariff---------------------------------------}
 Tabl:='SendPackTariff';
 Filds:='Send_Ident,PackName,Count,Tariff';
 if InsertToTable(Tabl,Filds)<>0 then
   begin
    DatInsert:=1;
    Pchar1:=Pchar('Данные в таблицу '+Tabl+' не загружены!');
    Application.MessageBox(Pchar1,'Сообщение!',0);
    exit
   end;
{END SendPackTariff-----------------------------------}


end;

function InsertToTable(s1,s2:string):integer;
var
TempList11: TStrings;
i,j:integer;
s:string;
begin
InsertToTable:=0;
//TempList11.Create;
TempList11:=ReadFiles1(s1);
i:=0;
while i<=TempList11.Count-1 do
begin
s:=TempList11.Strings[i];
if sql.InsertString(s1,s2,s)<>0 then
 begin
 InsertToTable:=1;
WriteLog('    В таблицу: '+s1+' не загрузилась следующая '+IntToStr(i)+' запись:');
WriteLog('      '+s);
 exit
 end;
 i:=i+1;
end; {while i< TempList11.Count-1}
if i<>0 then
WriteLog('    В таблицу: '+s1+' загружено '+IntToStr(i)+' записей:');
TempList11.Free;
end;


function ChangeOtheFile(f:integer;s,s2,s3:string):integer;
var
TempL1: TStrings;
i:integer;
s1,fs:string;
begin
ChangeOtheFile:=0;
TempL1:=ReadFiles1(s);
i:=0;
while (i <= TempL1.Count-1) do
begin
s1:= TempL1.Strings[i];
fs:=FindReplaceStr(f,s1,s2,s3);

TempL1.Strings[i]:=fs;
i:=i+1;
end;
if TempL1.Count<>0 then
WriteFiles(s,TempL1);

TempL1.free;
end;

function DeleteFromOtherFile(f:integer;s,s2:string):integer;
var
TempL1: TStrings;
i:integer;
s1,fs:string;
begin
DeleteFromOtherFile:=0;
TempL1:=ReadFiles1(s);
i:=0;
while (i <= TempL1.Count-1) do
begin
fs:='';
s1:= TempL1.Strings[i];
fs:=FindStr(f,s1);
 if StrToInt(fs)<>StrToInt(s2) then
    i:=i+1
  else TempL1.Delete(i);
end;
if TempL1.Count<>0 then
      WriteFiles(s,TempL1)
else DelFiles(s);

TempL1.free;
end;

function ChangeComma(s:string):integer;
var
list1: TStrings;
i,j:integer;
s1,s2,s3:string;
begin
ChangeComma:=0;
//list1.Create;
list1:=ReadFiles1(s);
i:=0;
while  (i <= list1.Count-1) do
begin
   s1:=list1.Strings[i];
   while (Pos('@,@',s1) <> 0) do
   begin
     j:= Pos('@,@',s1);
     s2:=copy(s1,0,j-1);
     s3:=copy(s1,j+3,length(s1)-j-2);
     s1:=s2+','+s3;
   end;
  list1.Strings[i]:=s1;
  i:=i+1;
end;
if list1.Count<>0 then
WriteFiles(s,list1);

list1.free;
end;


function ReadFiles1(strId: string):TStrings;
var
    TempList11: TStrings;
begin
if Pos('"',strId)<>0 then
     strId:=copy(strId,2,length(strId)-2);  {убираем кавычки, если есть}
  TempList11 := TStringList.Create;
   strId:= systemdir+'Unload\'+strId+'.txt';
if FileExists(strId) then
   TempList11.LoadFromFile(strId);
   ReadFiles1:=TempList11;
end;

function WriteFiles(s: string;TempL1:TStrings): integer;
var
strId: string;
begin
   strId:= s;
 if Pos('"',strId)<>0 then
     strId:=copy(strId,2,length(strId)-2);  {убираем кавычки, если есть}
   strId:= systemdir+'Unload\'+strId+'.txt';
   if FileExists(strId) then
   begin
      try
      TempL1.SaveToFile(strId);
      WriteFiles:=0;
      except
         WriteFiles:=1;
          exit;
      end;    {except}
   end else WriteFiles:=0;
end;


function DelFiles(s: string): integer;
var
strId: string;
begin
   strId:= s;
   if Pos('"',strId)<>0 then
     strId:=copy(strId,2,length(strId)-2);  {убираем кавычки, если есть}
   strId:= systemdir+'Unload\'+strId+'.txt';
   if FileExists(strId) then
   begin
      try
      DeleteFile(strId);
      DelFiles:=0;
      except
         DelFiles:=1;
          exit;
      end;    {except}
   end else DelFiles:=0;
end;


function FindStr(i:integer;s:string):string;
var
j,n:integer;
stest:string;
begin
stest:=s;
j:=0;
n:=0;
while (n<i) do
begin
   j:=Pos('@,@',stest);
   stest:=copy(stest,j+3,Length(stest)-j-2);
   n:=n+1;
end; {while (n<i)}
j:=Pos('@,@',stest);
if j<>0 then
stest:=copy(stest,1,j-1);
FindStr:=stest;
end;


function FindReplaceStr(i:integer;s1,s2,s3:string):string;
var
j,n:integer;
stest,st1,st2,st3:string;
begin
stest:=s1;
j:=0;
n:=0;
while (n<i) do
begin
   j:=Pos('@,@',stest);
   stest:=copy(stest,j+3,Length(stest)-j-2);
   n:=n+1;
end; {while (n<i)}
j:=Pos('@,@',stest);
if j<>0 then
begin
stest:=copy(stest,j+3,length(stest)-j-2);
st1:=s1;
delete(st1,Length(st1)-length(stest)-2,length(stest)+3);
j:=0;
st2:=ReverseString(st1);
 j:=Pos('@,@',st2);
  if j<> 0 then
  begin
   st3:=Copy(st2,0,j-1);  {выделяем тот кусочек который нужно заменить}
   st2:=copy(st2,j,length(st2)-j+1);
   st1:=ReverseString(st2);
   st3:=ReverseString(st3);
  end else
    begin
    st3:= ReverseString(st2);
    st1:='';
    end;
 stest:='@,@' + stest;
end else
    begin
    st1:=s1;
    delete(st1,Length(st1)-length(stest)+1,length(stest));
    st3:=stest;
    stest:='';
    end;
if (st3<>'') and (st3<>'NULL') then
   if StrToInt(s3) = StrToInt(st3) then
     FindReplaceStr:=st1+s2+stest
   else FindReplaceStr:=s1
else FindReplaceStr:=s1;   
end;

function FindReplaceNumber(i:integer;s1,s2,s3:string):string;
var
j,n:integer;
stest,st1,st2,st3:string;
begin
stest:=s1;
j:=0;
n:=0;
while (n<i) do
begin
   j:=Pos('@,@',stest);
   stest:=copy(stest,j+3,Length(stest)-j-2);
   n:=n+1;
end; {while (n<i)}
j:=Pos('@,@',stest);
if j<>0 then
begin
stest:=copy(stest,j+3,length(stest)-j-2);
st1:=s1;
delete(st1,Length(st1)-length(stest)-2,length(stest)+3);
j:=0;
st2:=ReverseString(st1);
 j:=Pos('@,@',st2);
  if j<> 0 then
  begin
   st3:=Copy(st2,0,j-1);  {выделяем тот кусочек который нужно заменить}
   st2:=copy(st2,j,length(st2)-j+1);
   st1:=ReverseString(st2);
   st3:=ReverseString(st3);
  end else
    begin
    st3:= ReverseString(st2);
    st1:='';
    end;
 stest:='@,@' + stest;
end else
    begin
    st1:=s1;
    delete(st1,Length(st1)-length(stest)+1,length(stest));
    st3:=stest;
    stest:='';
    end;
FindReplaceNumber:=st1+s2+stest
end;

Function OrderNum(dat1:string):string;
var q:TQuery;
    Year, Month, Day: Word;
    Num1,Num2:string;
    N1,N2:integer;
    j:integer;
    year1:string;
begin
    j:=0;   {разбиваем дату на год, месяц, день}
     j:= Pos('-',dat1);
     year1:=copy(dat1,4,2);


q:=sql.select(EntrySec.orders_view {'`Orders`'},'Number,`Year`','`Year`=Year('+dat1+')','');
if q.eof then OrderNum:='1/'+year1
     else
     begin
      Num1:=q.fieldByName('Number').AsString;
      N1:=pos('/',Num1);
      delete(Num1,N1,Length(Num1)-N1+1) ;
      N1:=StrToInt(Num1);
      while not q.Eof do
      begin
      Num2:=q.fieldByName('Number').AsString;
      N2:=pos('/',Num2);
      delete(Num2,N2,Length(Num2)-N2+1) ;
      N2:=StrToInt(Num2);
      if N1<N2 then N1:=N2;
      q.Next;
      end;
     OrderNum:=IntToStr(N1+1)+'/'+year1;
     end;

 q.free;
end;


Function SendNum(dat1:string):string;
var Num1,Num2:string;
    N1,N2,j:integer;
    year1,month1,day1,s3:string;
    q:TQuery;
begin

    j:=0;   {разбиваем дату на год, месяц, день}
     j:= Pos('-',dat1);
     year1:=copy(dat1,4,2);
     s3:=copy(dat1,j+1,length(dat1)-j);
     j:= Pos('-',s3);
     month1:= copy(s3,1,j-1);
     day1:=copy(s3,j+1,length(s3)-j-1);

 q:=sql.Select(EntrySec.send_table {'Send'},'Namber','`Start`='+ dat1,'');

 if  q.Eof then SendNum:='1/' + day1 + month1 + year1
  else
     begin
      Num1:=q.fieldByName('Namber').AsString;
      N1:=pos('/',Num1);
      delete(Num1,N1,Length(Num1)-N1+1) ;
      N1:=StrToInt(Num1);
      while not q.Eof do
      begin
      Num2:=q.fieldByName('Namber').AsString;
      N2:=pos('/',Num2);
      delete(Num2,N2,Length(Num2)-N2+1) ;
      N2:=StrToInt(Num2);
      if N1<N2 then N1:=N2;
      q.Next;
      end;
     SendNum:=IntToStr(N1+1)+'/'+ day1 + month1 + year1;
     end;
  q.Free;   
end;


end.
