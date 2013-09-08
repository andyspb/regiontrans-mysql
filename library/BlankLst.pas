unit Blanklst;

interface

uses
  GUIView, tAdjForm, DBTables,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, BMPBtn;

type
  TBlankListFrm = class(TAdjustForm)
    ListBox1: TListBox;
    btPrint: TBMPBtn;
    btCancel: TBMPBtn;
    procedure FormCreate(Sender: TObject);
    procedure btPrintClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BlankListFrm: TBlankListFrm;
  FilePath:String;

procedure ShowBlankListFrm(v:TGUIView; q:TQuery);

implementation
uses IniFiles;

{$R *.DFM}
type
  TState=(sComplite,sEmptyBuffer,sFillBuffer,sFindPrefix,
         sFindName,sFindPostfix,sFoundPrefix,sFoundName,sFoundPostfix);

const
  prnFileName='print.rtf';
  SubS:PChar='%'+#0;
Var
  Query:TQuery;
  View:TGUIView;
  BlankN:String;

procedure ShowBlankListFrm(v:TGUIView; q:TQuery);
begin
  View:=v;
  Query:=q;
  BlankListFrm:=TBlankListFrm.Create(Application);
  BlankListFrm.ShowModal;
  BlankListFrm.Free
end;

procedure CopyRTFTemplate;
var
  state:TState;
  FromF, ToF: file;
  NumRead, NumWritten, l: Integer;
  Buf: array[0..2048] of Char;
  tmp: array[0..255] of Char;
  iniFile:TIniFile;
  p,pTmp:PChar;
  YetNotRead:LongInt;
  m:TMemoryStream;
  s:String;
begin
{  FileOpen
  FileRead
  FileWrite
  FileClose
  FileCreate}
  AssignFile(FromF, FilePath+BlankN+'.rtf');
  Reset(FromF, 1);
  YetNotRead:=filesize(FromF);
  AssignFile(ToF, FilePath+prnFileName);
  Rewrite(ToF, 1);
  iniFile:=TInifile.Create(FilePath+BlankN+'.ini');
  state:=sFillBuffer;
  m:=TMemoryStream.Create;
  repeat
    case state of
      {***********************************************}
      sFillBuffer: {заполнить весь буфер}
        begin
          l:=SizeOf(Buf)-1;
          if YetNotRead>0 then begin
            BlockRead(FromF, Buf, l, NumRead);
            if NumRead>0 then begin
              YetNotRead:=YetNotRead-NumRead;
              Buf[NumRead]:=#0
            end;
            p:=Buf;
            state:=sFindPrefix
          end else
            state:=sComplite
        end;
      {***********************************************}
      sEmptyBuffer: {слить весь буфер}
        begin
          NumRead:=strLen(Buf);
          BlockWrite(ToF, Buf, NumRead, NumWritten);
          if NumRead=NumWritten then state:=sFillBuffer
          else state:=sComplite
        end;
      {***********************************************}
      sFindPrefix: {искать перфикс}
        begin
          p:=StrPos(p,SubS);
          if p<>nil then state:=sFoundPrefix
          else state:=sEmptyBuffer
        end;
      {***********************************************}
      sFoundPrefix:
        begin
          l:=LongInt(@p[0])-LongInt(@buf[0]);
          if l>0 then begin
            BlockWrite(ToF, Buf, l, NumWritten); {сбрасываю допрефиксную часть}
            if NumWritten<>l then state:=sComplite
            else begin
              StrCopy(Buf,@p[strlen(Subs)]); {перемещаю в начало буфера}
              l:=strLen(Buf);
              if (SizeOf(Buf)>l)and(YetNotRead>0)then begin
                BlockRead(FromF, Buf[l],SizeOf(Buf)-l, NumRead); {дополн€ю до конца буфер}
                YetNotRead:=YetNotRead-NumRead;
                buf[l+NumRead]:=#0
              end;
              p:=Buf;
              state:=sFindPostfix
            end
          end
        end;
      {***********************************************}
      sFindPostFix:
        begin
          p:=StrPos(p,SubS);
          if p<>nil then state:=sFindName
          else state:=sEmptyBuffer
        end;
      {***********************************************}
      sFindName:
        begin
          l:=LongInt(@p[0])-LongInt(@buf[0]);
          if (l>0)and(l<SizeOf(tmp))then begin
            strlCopy(tmp,buf,l);
            s:=iniFile.ReadString('',strPas(tmp),'');
(*            if query.FieldByName(s) is TMemoField then begin
                m.Clear;
                TMemoField(query.FieldByName(s)).SaveToStream(m);
                pTmp:=PChar(m.Memory)
            end
            else begin
              s:=query.FieldByName(s).Text;
              strpCopy(tmp,s);
{              StrPCopyRus(tmp,s);}
              pTmp:=@tmp[0];
            end;*)
            if s<>'' then state:=sFoundName
            else state:=sFoundPostfix
          end
          else begin
            BlockWrite(ToF, Buf, l, NumWritten);
            if NumWritten<>l then state:=sComplite
            else begin
              StrlCopy(Buf,@p[Integer(p-buf-l)],l); {сдвигаю в начало буфера}
              state:=sFindPrefix
            end
          end
        end;
      {***********************************************}
      sFoundName:
        begin
            l:=strLen(pTmp);
            BlockWrite(ToF, Tmp, l, NumWritten);
            if NumWritten<>l then state:=sComplite
            else state:=sFoundPostfix
        end;
      {***********************************************}
      sFoundPostfix:
        begin {отрезаю %1%}
          l:=strLen(Subs);
          StrCopy(Buf,@p[l]); {перемещаю в начало буфера}
          l:=strLen(Buf); {сколько надо дополнить}
          if (YetNotRead>0)and(SizeOf(Buf)>l) then begin
            BlockRead(FromF, Buf[l], SizeOf(Buf)-l, NumRead); {дополн€ю до конца буфер}
            YetNotRead:=YetNotRead-NumRead;
            buf[l+NumRead]:=#0
          end;
          p:=Buf;
          state:=sFindPrefix
        end;
    end;{case state}
  until State=sComplite;

  m.Free;
  CloseFile(FromF);
  CloseFile(ToF);
  iniFile.Free;
  iniFile:=TIniFile.Create('mrp.ini');
  s:=iniFile.ReadString('Path','WinWord','c:\msoffice\winword\winword.exe');
  strpCopy(tmp,s+' '+prnFileName+' /mPrintTemplete');
  iniFile.Free;
  WinExec(tmp,SW_SHOWNORMAL)
end;
(*
procedure StrPCopyRus(p:PChar;s:String);
var
  i:Integer;
begin
  for i:=1 to length(s) do
   { case s[i] of

    end
   } p[i-1]:=s[i]
end;
*)

procedure TBlankListFrm.FormCreate(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to view.BlanksCount-1 do
    ListBox1.Items.AddObject(view.Blanks[i].DisplayLabel,
                              pointer(view.Blanks[i].ID)
                             );
  ListBox1.ItemIndex:=0
end;

procedure TBlankListFrm.btPrintClick(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to ListBox1.Items.Count-1 do
    if ListBox1.Selected[i] then begin
      BlankN:=IntToStr(LongInt(ListBox1.Items.Objects[i]));
      CopyRTFTemplate
    end
end;

procedure TBlankListFrm.ListBox1Click(Sender: TObject);
begin
  btPrint.Enabled:=ListBox1.SelCount>0
end;

procedure TBlankListFrm.ListBox1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  btPrint.Enabled:=ListBox1.SelCount>0
end;

begin
FilePath:='c:\1\2\'
end.
