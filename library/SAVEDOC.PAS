unit Savedoc;

interface

uses
  Files, Fr3Api,
  messform, TifFuncs, llo, lli,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, TAdjForm, StdCtrls, BMPBtn, Buttons, ExtCtrls, Grids;

const
  tmpFileName='tmp.tif';
  CaptionTitle='Сохранить документ из ';
  TIFFDir :String = 'c:\tmp\';
  TEXTDir :String = 'c:\tmp\';
  FRUnloadAnyTime:  boolean = True;
  FRLoaded:   boolean  = False;
  TEXT_ROW=1;

type
  PImageWindow=^TImageWindow;

  TScanSave = class(TAdjustForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Recognize: TBitBtn;
    BMPBtn3: TBMPBtn;
    BMPBtn4: TBMPBtn;
    BMPBtn1: TBMPBtn;
    StringGrid1: TStringGrid;
    procedure RecognizeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BMPBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BMPBtn3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BMPBtn4Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure StringGrid1SelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
  private
    Viewer,Editor : String;
    PageDeleted:Integer;
    procedure CaptionReWrite;
  public
  end;

var
  ScanSave: TScanSave;
  ImageWindow: PImageWindow;
  TotalPage,CurrentPage: Integer;
  function  GetTIFFileName(i:Integer):String;
  function GetOriginTIFFileName(i:Integer):String;
  procedure PrevPage;
  procedure NextPage;
  procedure ShowPage(n:Word);

implementation

{$R *.DFM}

function GetTIFFileName(i:Integer):String;
begin
  GetTIFFileName := 'c:\tmp\'+ intToStr(i) +'.tif'
end;

function GetOriginTIFFileName(i:Integer):String;
begin
  GetOriginTIFFileName := 'c:\tmp\'+ intToStr(i) +'.~ti'
end;

procedure PrevPage;
begin
  if CurrentPage>1 then
  begin
    dec(CurrentPage,1);
    ImageWindow^.LoadFile( GetTIFFileName(CurrentPage), LLI_DISK_TIF, 0);
  end
end;


procedure NextPage;
begin
  if CurrentPage<TotalPage then
  begin
    inc(CurrentPage,1);
    ImageWindow^.LoadFile(GetTIFFileName(CurrentPage), LLI_DISK_TIF,0);
  end
end;

procedure ShowPage(n:Word);
begin
  CurrentPage:=n;
  ImageWindow^.LoadFile(GetTIFFileName(CurrentPage), LLI_DISK_TIF,0);
end;

procedure TScanSave.RecognizeClick(Sender: TObject);
const
   Format  = 'DOS_Text';
var
   i:      integer;
   s1, s2: string;
   fName: string;
begin

  if not FRLoaded then
    begin
       FineInit;
       FRLoaded := True;
    end;


  for i:=1 to StringGrid1.RowCount -1 do
    if StringGrid1.Cells[TEXT_ROW, i]='x' then
    begin
      fName:=StringGrid1.Cells[0,i];
      Delete(fName,1,9);
      FineStandard_RecognizeFileImage(
          StrPCopy(@s1, GetWindowsTempDir+fName+'.tif'),
          StrPCopy(@s2, GetWindowsTempDir+fName+'.txt'),
          Format)
    end;
end;

procedure TScanSave.FormCreate(Sender: TObject);
begin
  PageDeleted:=0;
end;

procedure TScanSave.BMPBtn1Click(Sender: TObject);
begin
  Close
end;

procedure TScanSave.FormShow(Sender: TObject);
var
  i : Integer;
begin
  CaptionReWrite;
  StringGrid1.RowCount:=TotalPage +1; { Add Fixed row}
  StringGrid1.Cells[0,0]:='Страницы';
  StringGrid1.Cells[1,0]:='Изображение';
  StringGrid1.Cells[2,0]:='Текст';
  for i:=1 to TotalPage do
    StringGrid1.Cells[0,i]:='Страница '+intToStr(i)
end;

procedure TScanSave.CaptionReWrite;
begin
  Caption:=CaptionTitle +' '+ intToStr(TotalPage-PageDeleted) +' страниц'
end;

procedure TScanSave.BMPBtn3Click(Sender: TObject);
var { Удалить отмеченную страницу и ее файлы tif и txt }
  i : Integer;
begin
  if TotalPage-PageDeleted>1 then
   begin
     for i:=StringGrid1.Row to StringGrid1.RowCount-2 do
       StringGrid1.Rows[i]:=StringGrid1.Rows[i+1];
     inc(PageDeleted);
     StringGrid1.RowCount:=TotalPage-PageDeleted+1;
   end else
   begin
     if StringGrid1.Cells[0,1]<>'' then
       Inc(PageDeleted);
     StringGrid1.Cells[0,1]:='';
     StringGrid1.Cells[1,1]:='';
     StringGrid1.Cells[2,1]:=''
   end;
   CaptionReWrite
end;

procedure TScanSave.BitBtn1Click(Sender: TObject);
var
  sl:TStringList;
begin {Up}
  sl:=TStringList.Create;
  if StringGrid1.Row>1 then {More then fixed row}
  begin
    sl.Clear;
    sl.Add(StringGrid1.Cells[0,StringGrid1.Row]);
    sl.Add(StringGrid1.Cells[1,StringGrid1.Row]);
    sl.Add(StringGrid1.Cells[2,StringGrid1.Row]);

    StringGrid1.Rows[StringGrid1.Row]:=StringGrid1.Rows[StringGrid1.Row-1];

    StringGrid1.Cells[0,StringGrid1.Row-1]:=sl.Strings[0];
    StringGrid1.Cells[1,StringGrid1.Row-1]:=sl.Strings[1];
    StringGrid1.Cells[2,StringGrid1.Row-1]:=sl.Strings[2];

    StringGrid1.Row:=StringGrid1.Row-1;
  end;
  sl.Free
end;

procedure TScanSave.BitBtn2Click(Sender: TObject);
var
  sl:TStringList;
begin {Down}
  sl:=TStringList.Create;
  if StringGrid1.Row < StringGrid1.RowCount -1 then
  begin
    sl.Clear;
    sl.Add(StringGrid1.Cells[0,StringGrid1.Row]);
    sl.Add(StringGrid1.Cells[1,StringGrid1.Row]);
    sl.Add(StringGrid1.Cells[2,StringGrid1.Row]);

    StringGrid1.Rows[StringGrid1.Row]:=StringGrid1.Rows[StringGrid1.Row+1];

    StringGrid1.Cells[0,StringGrid1.Row+1]:=sl.Strings[0];
    StringGrid1.Cells[1,StringGrid1.Row+1]:=sl.Strings[1];
    StringGrid1.Cells[2,StringGrid1.Row+1]:=sl.Strings[2];

    StringGrid1.Row:=StringGrid1.Row+1;
  end;
  sl.Free
end;

procedure TScanSave.BMPBtn4Click(Sender: TObject);
var
  i : Integer;
  fName : String;
const
  TIFFtmpFile = 'tmp.tif';
  TEXTtmpFile = 'tmp.txt';
  TIFF_ROW = 1;
  TEXT_ROW = 2;
begin

  fName:='';

  for i:=1 to StringGrid1.RowCount -2 do
    if StringGrid1.Cells[TIFF_ROW, i]='x' then
    begin
      fName:=StringGrid1.Cells[0,i];
      Delete(fName,1,9);
      fName:= TIFFDir+fName+'.tif';
      break; { Нашли первый файл }
    end;

  if fName='' then exit;

  { Prepare tnp TIF file}
  TIFF_MakeFile(TIFFDir + TIFFtmpFile, fName);

  { save all pages }
  for i:=i+1 to StringGrid1.RowCount -1 do
  begin
    fName:=StringGrid1.Cells[0,i];
    Delete(fName,1,9);
    if StringGrid1.Cells[TIFF_ROW, i]='x' then
      TIFF_AddFile(TIFFDir + TIFFtmpFile, TIFFDir + fName +'.tif');
{    if StringGrid1.Cells[TEXT_ROW, i]='x' then
      TEXT_AddFile(TEXTDir + TEXTtmpFile,TEXTDir + fName +'.txt')
}  end;
  { Создаю свой complicated файл }

{   Удаляю все временные файлы
    DeleteFile(TEXTDir+fName+'.txt');
    DeleteFile(TIFFDir+fName+'.tif');
}
end;

procedure TScanSave.StringGrid1DblClick(Sender: TObject);
begin
  if (StringGrid1.Col>0)and(StringGrid1.Cells[0,1]<>'')
{     and(StringGrid1.Col<2) {del This string To Enable Text }
  then
  begin
    if StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row]='x' then
      StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row]:=''
    else
      StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row]:='x'
  end
end;

procedure TScanSave.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caHide
end;

procedure TScanSave.StringGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=VK_Space)or(key=VK_Return) then
    StringGrid1DblClick(Self);
end;

procedure TScanSave.StringGrid1SelectCell(Sender: TObject; Col,
  Row: Longint; var CanSelect: Boolean);
begin
  case Col of
   0:  ShowPage(Row);
   2:  CanSelect:=False
  end {case}
end;

end.
