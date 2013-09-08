unit TifFuncs;
{ Библиотека для создания мнгостраничных TIF-файлов }
{ Для использования этих функций необходимо удостовериться,
  что файлы-источники не пусты и корректны.}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, Buttons;

const
  Soft    = 'Lanit/LanDocs.Version 1.0. TIF-File functions library'+#0;
  tmpName = 'tiff.tmp';

 { Константы кодов ошибок, возвращаемые функциями TIFF_x }
type
  TTiffErrors=(
    TIFF_OK,
    TIFF_PAGE_NOT_EXISTS
  );

type
  TLongIntType=record
    case byte of
    0 : (c:array[1..4]of char);
    1 : (l:LongInt);
  end;

  TIntType=record
    case byte of
    0 : (c:array[1..2]of char);
    1 : (i:Integer);
  end;

  TFields=record
    fTag    : TIntType;
    fType   : TIntType;
    fLength : TLongIntType;
    fValue  : TLongIntType;
  end;

  PEntry=^TEntry;
  TEntry=record
    case byte of
      0: ( buf : array[1..12] of char);
      1: ( fields: TFields);
  end;

var
  Win_Path : array [0..200] of Char;

procedure TIFF_MakeFile(const Dest,Source:String);
procedure TIFF_InsertFile(Dest,Source:String; Position :Integer);
procedure TIFF_ReWriteSoftware(var f: File; Entry: PEntry; delta :LongInt);
procedure TIFF_AddFile(const Dest,Source:String);
function  TIFF_PagePos(var F:File; N:Word):LongInt;
function  TIFF_DeletePage(fName:String; N:Integer):TTiffErrors;
procedure TIFF_ChangeStripOffsets(var f:File; Entry : PEntry; delta:LongInt);
function  TIFF_ImageExests(fName:String):Boolean;
procedure FileCopy(dest,sour:String);
function  TIFF_PagesName(FName:String):Word;


implementation

function TIFF_PagesName(FName:String):Word;
var
  k:Word;
  i:TIntType;
  l:TLongIntType;
  NumRead:Word;
  f:File;
begin

  AssignFile(F, FName);
  Reset(F, 1);

  l.l:=4;
  Reset(f,1);
  Seek(f,l.l);
  BlockRead(F, l.c, 4, NumRead); {Читаю первый IFD Offset}

  k:=0;
  while l.l<>0 do
  begin
    inc(k);
    Seek(F,l.l);
    BlockRead(F, i.c, 2, NumRead);
    l.l:=l.l + (12*i.i +2);
    Seek(f,l.l);
    BlockRead(F, l.c, 4, NumRead);
  end;
  System.CloseFile(F);

  TIFF_PagesName:=k
end;

procedure TIFF_MakeFile(const Dest,Source:String);
{ Переписывает одно/много страничный TIF файл SOURCE
  в одно/много страничный TIF файл DEST с внесением некоторых изменений
  в структуре, а именно - изменяется динамическое поле SoftWare во всех
  страницах файла.
}
var
  FromF, ToF : file;
  NumRead, NumWritten : Word;
  Buf : array[1..2048] of Char;
  k : Integer; { Tmp }
  i : TIntType;
  l : TLongIntType;
  entry: TEntry;
begin

  AssignFile(ToF,Dest);
  Rewrite(ToF, 1);

  AssignFile(FromF, Source);
  Reset(FromF, 1);

  { Переписываю полностью весь файл }
  repeat
     BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
     BlockWrite(ToF, Buf, NumRead, NumWritten);
  until (NumRead = 0) or (NumWritten <> NumRead);

  Seek(ToF,4); { Пропускаю заголовок файла длиной 4 байта }
  { Читаю 1stIFD Offset }
  BlockRead(ToF, l.c, 4 ,NumRead);
  Seek(ToF,l.l);

  { Повторяю для все страниц файла }
  repeat
    { Читаю 1stIFD Offset }
    BlockRead(ToF, i.c, 2 ,NumRead);
    for k:=1 to i.i do
    begin
       BlockRead(ToF, entry.buf, 12, NumRead);
       if Entry.Fields.fTag.i=$0131 then
           TIFF_ReWriteSoftware(ToF,@Entry,0)
    end;
    { Читаю поле Next IFD Offset }
    BlockRead(ToF, l.c, 4 ,NumRead);
    Seek(ToF,l.l);
  until l.l=0;

  System.CloseFile(FromF);
  System.CloseFile(ToF)

end; { procedure MakeFirstFile }

(*****************************************************************************)
procedure TIFF_AddFile(const Dest,Source:String);
{ Добавляет к одно/много страничному TIF файлу DEST
  одно/много страничный TIF файл SOURCE безо всяких изменений в структуре.
}
var
  FromF, ToF : file;
  NumRead, NumWritten : Word;
  Buf : array[1..2048] of Char;
  k,size : Integer; { Tmp }
  i : TIntType;
  l : TLongIntType;
  LocalByteRead,LongTmp : Longint; { Кол-во прочитанных уже байт для каждого из файлов }
  entry: TEntry;
  CurrentToFileSize : LongInt; { Хранение длины выходного файла }
begin
  AssignFile(ToF, Dest);
  Reset(ToF, 1);
  {Подготавливаю файл-сток для присоединения к нему др файла}
  CurrentToFileSize := FileSize(ToF);
  seek(ToF,CurrentToFileSize);

  AssignFile(FromF, Source);
  Reset(FromF, 1);
  seek(FromF, 8);

  repeat { Дописываю файл-исток в конца файла-стока }
    BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
    BlockWrite(ToF, Buf, NumRead, NumWritten);
  until (NumWritten=0)or(NumWritten<>NumRead);


 {читаю где статическая часть 1ой страницы}
  LocalByteRead:=4;
  Seek(ToF,LocalByteRead);
  BlockRead(ToF, l.c, 4, NumRead);
  inc(LocalByteRead,NumRead);

  { Встаю на начало статической части 1ой страницы}
  Seek(ToF,l.l);
  LocalByteRead:=l.l;

  { Встаю на последнюю страницу }
  repeat
    BlockRead(ToF, i.c, 2, NumRead);
    inc(LocalByteRead,i.i*12 +NumRead);
    seek(ToF, LocalByteRead);
    BlockRead(ToF, l.c, 4, NumRead);
    if l.l>0 then
    begin
      LocalByteRead:=l.l;
      Seek(ToF,LocalByteRead)
    end
  until l.l=0;

  {На начало статической части 1ой страницы файла-истока}
  Seek(FromF,4);
  BlockRead(FromF, l.c, 4, NumRead);
  Seek(FromF,l.l);
  l.l:=l.l+CurrentToFileSize-8;

  { Возвратил на поле NextIFD Offset последней страницы файла-стока }
  Seek(ToF,LocalByteRead);

  { Записываю значение в поле NextIFD Offset файла-стока }
  BlockWrite(ToF, l.c, NumRead, NumWritten);
  Seek(ToF,l.l);

  { Добавляю сам файл-исток в конец файла-стока }

  { Повторять для всех страниц файла-истока }
  repeat
    BlockRead (FromF, i.c, 2, NumRead);
    BlockWrite(ToF, i.c, NumRead, NumWritten);

    for k:=1 to i.i do
    begin
      BlockRead(FromF, entry.buf, 12, NumRead);
      case Entry.Fields.fType.i of
        1: size := Entry.Fields.fLength.l;  {Byte}
        2: size := Entry.Fields.fLength.l;  {ASCII}
        3: size := Entry.Fields.fLength.l*2;{Short}
        4: size := Entry.Fields.fLength.l*4;{Long}
        5: size := Entry.Fields.fLength.l*8;{Ration}
      end; {case}
{*********************************************************}
      if size>4 then { More then Max size }
      begin
        case Entry.Fields.fTag.i of
         $0131 : TIFF_ReWriteSoftware   (ToF, @Entry, CurrentToFileSize - 8);
         $0111 : TIFF_ChangeStripOffsets(ToF, @entry, CurrentToFileSize - 8);
        else {Я не знаю ни такого поля, ни как его обрабатывать};
        end; {case}
        Entry.Fields.fValue.l := Entry.Fields.fValue.l + CurrentToFileSize - 8;
      end else { Size < Max_Size }
      begin
        if Entry.Fields.fTag.i= $0111 then
          Entry.Fields.fValue.l := Entry.Fields.fValue.l + CurrentToFileSize - 8
      end;
{*********************************************************}
      BlockWrite(ToF, entry.buf, NumRead, NumWritten);
    end; { for k:=1 to i.i do }


    BlockRead(FromF, l.c, 4, NumRead);
    if l.l>0 then  { Не последняя страница у файла-истока }
    begin { Подправляю значение, добавляя текущую длину файла}
      Seek(FromF,l.l);   { Позиционирую на начало статической части }
      l.l:=l.l+CurrentToFileSize-8;
      BlockWrite(ToF, l.c, NumRead, NumWritten);
      Seek(ToF,l.l) { Позиционирую на начало статической части }
    end
  until l.l=0; { Пока не последняя страница файла-истока }

  System.CloseFile(FromF);
  System.CloseFile(ToF);

end; { procedure AddFile }

procedure TIFF_ReWriteSoftware(var f: File; Entry: PEntry; delta :LongInt);
var
  tmpPos : LongInt;
  i : Integer;
  buf : array [0..200] of char;
  l : Longint;
begin
  l:=Length(Soft)+2;
  if Entry^.Fields.fLength.l<l then
     l:=Entry^.Fields.fLength.l;
  strlCopy(Buf,PChar(soft),l);

  tmpPos:=FilePos(f);
  seek(f,Entry^.Fields.fValue.l + delta);
  BlockWrite(F, Buf, l-1, i);
  Seek(f,tmpPos)
end;

procedure  TIFF_ChangeStripOffsets(var f:File; Entry : PEntry; delta:LongInt);
var
  tmpPos : LongInt;
  i : Word;
  Num,off : Longint;
  NumRead, NumWritten : Word;
  l : TLongIntType;
begin
  tmpPos:=FilePos(f);

  Num:=Entry^.Fields.fLength.l;
  off:=Entry^.Fields.fValue.l + delta;
  Seek(f,off);

  for i:=1 to Num do
  begin
    BlockRead(F, l.c, 4, NumRead);
    l.l:=l.l+delta;
    seek(f,off);
    BlockWrite(F, l.c, NumRead, NumWritten);
    inc(off,NumWritten)
  end;
  Seek(f,tmpPos)
end;


procedure TIFF_InsertFile(Dest,Source:String; Position :Integer);
{ Вставляет в одно/много страничный TIF файл DEST
  одно/много страничный TIF файл SOURCE безо всяких изменений в структуре.
  Первая позиция имеет значение Position=0.
}
var
  From1F, From2F, ToF : file;
  NumRead, NumWritten : Word;
  Buf : array[1..2048] of Char;
  k : Integer; { Tmp }
  i : TIntType;
  l : TLongIntType;
  From1FilePos:LongInt;
  size : LongInt; { Для измерения длины полей Entry }
  CurrentToFileSize : LongInt; { Хранение длины выходного файла }
  LongTmp : LongInt;  { tmp }
  LocalByteRead : Longint; { Кол-во прочитанных уже байт для каждого из файлов }
  entry: TEntry;
begin
  {Подготавливаю файл-сток для слития в него двух файлов:
                               Sourse и Dest}
  AssignFile(ToF, StrPas(Win_Path) +'\'+ tmpName);
  Reset(ToF, 1);

  AssignFile(From1F, Dest);
  Reset(From1F, 1);
  AssignFile(From2F, Source);
  Reset(From2F, 1);
  { Переписываю заголовок из файла Dest}
  LocalByteRead:=8;
  BlockRead(From1F, buf, LocalByteRead, NumRead);
  BlockWrite(ToF, buf, NumRead, NumWritten);
  {Пропускаю заголовок файла Source}
  Seek(From2F,LocalByteRead);

  { Переписываю из файла Dest страницы до k = Position }
  for k:=0 to Position-1 do
  begin
    inc(k);
    BlockRead(From1F, i.c, 2, NumRead);
    inc(LocalByteRead, i.i*12);
    Reset(From1F,1);
    Seek(From1F, LocalByteRead); { В LocalByteRead хранится смещение}
    BlockRead(ToF, l.c, 4, NumRead); { поля Next IFD Offset }
    From1FilePos:=l.l; { Сохраняю начало следующей страницы в DEST }
    if l.l=0 then
       break;
    LocalByteRead:=l.l;
    Reset(From1F,1);
    Seek(From1F,LocalByteRead);
  end; {while (k<Position) and (l.l<>0)}

  CurrentToFileSize:=LocalByteRead;
  {CurrentToFileSize сохраняет текущую позицию файла TMP }

  { Переписываю странички из файла Source }
  { 1) Читаю кол-во статических полей
    2) Переписываю эти поля и встаю на поле Next IFD Offest
    3) Заменяю значение этого поля на новое: new = old + LocalByteRead
  }
  repeat { Повторять для всех страничек файла Source }
    LocalByteRead:=0;
    BlockRead(From2F, i.c, 2, NumRead);
    BlockWrite(ToF, i.c, NumRead, NumWritten);
    inc(LocalByteRead, NumRead);

    { Переписываю, изменяя поля - ссылки }
    for k:=1 to i.i do
    begin
      BlockRead(From2F, entry.buf, 12, NumRead);
      case Entry.Fields.fType.i of
        1: size := Entry.Fields.fLength.l;  {Byte}
        2: size := Entry.Fields.fLength.l;  {ASCII}
        3: size := Entry.Fields.fLength.l*2;{Short}
        4: size := Entry.Fields.fLength.l*4;{Long}
        5: size := Entry.Fields.fLength.l*8;{Ration}
      end; {case}
      if size>4 then {Out of max size}
      begin
        if Entry.Fields.fTag.i= $0131 then
          TIFF_ReWriteSoftware(From2F, @Entry, CurrentToFileSize - 8);
        Entry.Fields.fValue.l := Entry.Fields.fValue.l + CurrentToFileSize - 8;
      end else { Size < Max_Size}
      begin
        if Entry.Fields.fTag.i= $0111 then
          Entry.Fields.fValue.l := Entry.Fields.fValue.l + CurrentToFileSize - 8;
      end;
      BlockWrite(ToF, entry.buf, NumRead, NumWritten);
      inc(LocalByteRead,NumRead);
    end; { for k:=1 to i.i do }

    { Дописываю динамическую часть и данные изображения }
    BlockRead(From2F, l.c, 4, NumRead);
    if l.l>0 then  { Не последняя страница у файла-истока }
      l.l:=l.l+CurrentToFileSize-8; { Подправляю значение, добавляя текущую длину файла}
    BlockWrite(ToF, l.c, NumRead, NumWritten); {Записываю исправленное значение в файл-сток}
    inc(LocalByteRead,NumRead);
    { l.l указывает на начало следующей страницы: Number of Entries файла-стока }

    if l.l<>0 then
      repeat { Дописываю область динамических данных и изображения до начала след страницы }
        BlockRead(From2F, Buf, SizeOf(Buf), NumRead);
        { Надо отлавить начало следующей страницы }
        if CurrentToFileSize - 8 + LocalByteRead + NumRead > l.l then
        begin
          NumRead := l.l - (LocalByteRead + CurrentToFileSize );
          reset(From2F,1);
          Seek(From2F,LocalByteRead+NumRead+8)
        end;
        BlockWrite(ToF, Buf, NumRead, NumWritten);
                inc(LocalByteRead,NumRead);
      until (NumWritten=0)or(NumWritten<>NumRead)
            or(CurrentToFileSize + LocalByteRead = l.l)
    else { if l.l<>0 then }
      repeat { Дописываю область динамических данных и изображения до конца файла }
        BlockRead(From2F, Buf, SizeOf(Buf), NumRead);
        BlockWrite(ToF, Buf, NumRead, NumWritten);
      until (NumWritten=0)or(NumWritten<>NumRead);
  until l.l=0;

{  CurrentToFileSize:=Filepos();
  { LocalByteRead сохраняет текущую позицию файла Dest }
  {CurrentToFileSize сохраняет текущую позицию файла TMP }

  { Переписываю странички из файла Source }
  { 1) Читаю кол-во статических полей
    2) Переписываю эти поля и встаю на поле Next IFD Offest
    3) Заменяю значение этого поля на новое: new = old + LocalByteRead
  }
  repeat { Повторять для всех страничек файла Source }
    LocalByteRead:=0;
    BlockRead(From2F, i.c, 2, NumRead);
    BlockWrite(ToF, i.c, NumRead, NumWritten);
    inc(LocalByteRead, NumRead);

    { Переписываю, изменяя поля - ссылки }
    for k:=1 to i.i do
    begin
      BlockRead(From2F, entry.buf, 12, NumRead);
      case Entry.Fields.fType.i of
        1: size := Entry.Fields.fLength.l;  {Byte}
        2: size := Entry.Fields.fLength.l;  {ASCII}
        3: size := Entry.Fields.fLength.l*2;{Short}
        4: size := Entry.Fields.fLength.l*4;{Long}
        5: size := Entry.Fields.fLength.l*8;{Ration}
      end; {case}
      if size>4 then {Out of max size}
      begin
        if Entry.Fields.fTag.i= $0131 then
          TIFF_ReWriteSoftware(From2F,@Entry,CurrentToFileSize - 8);
        Entry.Fields.fValue.l := Entry.Fields.fValue.l + CurrentToFileSize - 8;
      end else { Size < Max_Size}
      begin
        if Entry.Fields.fTag.i= $0111 then
          Entry.Fields.fValue.l := Entry.Fields.fValue.l + CurrentToFileSize - 8;
      end;
      BlockWrite(ToF, entry.buf, NumRead, NumWritten);
      inc(LocalByteRead,NumRead);
    end; { for k:=1 to i.i do }

    { Дописываю динамическую часть и данные изображения }
    BlockRead(From2F, l.c, 4, NumRead);
    if l.l>0 then  { Не последняя страница у файла-истока }
      l.l:=l.l+CurrentToFileSize-8; { Подправляю значение, добавляя текущую длину файла}
    BlockWrite(ToF, l.c, NumRead, NumWritten); {Записываю исправленное значение в файл-сток}
    inc(LocalByteRead,NumRead);
    { l.l указывает на начало следующей страницы: Number of Entries файла-стока }

    if l.l<>0 then
      repeat { Дописываю область динамических данных и изображения до начала след страницы }
        BlockRead(From2F, Buf, SizeOf(Buf), NumRead);
        { Надо отлавить начало следующей страницы }
        if CurrentToFileSize - 8 + LocalByteRead + NumRead > l.l then
        begin
          NumRead := l.l - (LocalByteRead + CurrentToFileSize );
          reset(From2F,1);
          Seek(From2F,LocalByteRead+NumRead+8)
        end;
        BlockWrite(ToF, Buf, NumRead, NumWritten);
                inc(LocalByteRead,NumRead);
      until (NumWritten=0)or(NumWritten<>NumRead)
            or(CurrentToFileSize + LocalByteRead = l.l)
    else { if l.l<>0 then }
      repeat { Дописываю область динамических данных и изображения до конца файла }
        BlockRead(From2F, Buf, SizeOf(Buf), NumRead);
        BlockWrite(ToF, Buf, NumRead, NumWritten);
      until (NumWritten=0)or(NumWritten<>NumRead);
  until l.l=0;


  System.CloseFile(From1F);
  System.CloseFile(From2F);
  System.CloseFile(ToF);
  deleteFile(Source);
  deleteFile(Dest);
  RenameFile(tmpName,Dest);
end; { procedure InsertFile }

function TIFF_PagePos(var F:File; N:Word):LongInt;
var
  k:Word;
  i:TIntType;
  l:TLongIntType;
  NumRead:Word;
begin
  l.l:=4;
  Reset(f,1);
  Seek(f,l.l);
  BlockRead(F, l.c, 4, NumRead); {Читаю первый IFD Offset}

  for k:=0 to N-1 do
  begin
    Seek(f,l.l);
    BlockRead(F, i.c, 2, NumRead);
    l.l:=l.l + (12*i.i +2);
    Seek(f,l.l);
    BlockRead(F, l.c, 4, NumRead);
    if l.l=0 then break
  end;

  TIFF_PagePos:=l.l
end;

function TIFF_DeletePage(fName:String; N:Integer):TTiffErrors;
{Возвращает 0 если нормально, <0 - если ошибка}
var
  F,Ftmp : File;
  r : TTiffErrors;
  l : TLongIntType;
  i : TIntType;
  LongTmp : LongInt;
  NumRead,NumWritten:Integer;
  tmpFileName:String;
  Buf:array[0..1000] of char;
begin
  r:=TIFF_OK;
  AssignFile(F, fName);
  if TIFF_PagePos(f,N)=0 then {Страничка N не существует }
    r:=TIFF_PAGE_NOT_EXISTS
  else
  begin
    if TIFF_PagePos(f,N+1)>0 then {Страничка N - непоследняя}
    begin
    end
    else{Страничка N - последняя}
    begin
      if N>0 then
        l.l:=TIFF_PagePos(f,N-1);
        Reset(f,1);
        Seek(f,l.l);
        BlockRead(F, i.c, 2, NumRead);
        l.l:=l.l + (12*i.i +2);
        Reset(f,1);
        Seek(f,l.l);
        BlockRead(F, l.c, 4, NumRead);
        LongTmp := l.l;
        l.l := 0;
        BlockWrite(F, l.c, 4, NumWritten);
        Reset(f,1);
        Seek(f,longTmp);
        tmpFileName:=StrPas(Win_Path) +'\'+ tmpName;
        AssignFile(Ftmp, tmpFileName);
        Reset(FTmp,1);
        repeat{ Дописываю область динамических данных и изображения до конца файла }
          BlockRead(Ftmp, Buf, SizeOf(Buf), NumRead);
          BlockWrite(Ftmp, Buf, NumRead, NumWritten);
        until (NumWritten=0)or(NumWritten<>NumRead);
        System.CloseFile(Ftmp);
    end;
  end;
  System.CloseFile(F);

  DeleteFile(fName);
  RenameFile(tmpFileName,fName)
end;

function TIFF_ImageExests(fName:String):Boolean;
var
  F : File;
  n,j : Word;
  l : TLongIntType;
  i : TIntType;
  entry: TEntry;
begin
  AssignFile(F, fName);
  Reset(f,1);

  Seek(f,4);
  BlockRead(F, l.c, 4, n);
  Seek(f,l.l);
  BlockRead(F, i.c, 2, n);
  for j:=1 to i.i do
  begin
    BlockRead(F, entry.buf, 12, n);
    if Entry.Fields.fTag.i = $100 then
    begin
      if Entry.Fields.fValue.l <= 2 then
          i.i:=0;
      break
    end
  end;
  System.CloseFile(F);
  TIFF_ImageExests:= (i.i<>0)
end;

procedure FileCopy(dest,sour:String);
var
  FromF, ToF: file;
  NumRead, NumWritten: Word;
  Buf: array[1..2048] of Char;
begin
  AssignFile(FromF, sour);
  Reset(FromF, 1);
  AssignFile(ToF, dest);
  Rewrite(ToF, 1);
  repeat
    BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
    BlockWrite(ToF, Buf, NumRead, NumWritten);
  until (NumRead = 0) or (NumWritten <> NumRead);
  System.CloseFile(FromF);
  System.CloseFile(ToF)
end;

begin
  GetWindowsDirectory(Win_Path, sizeof(Win_Path))
end.
