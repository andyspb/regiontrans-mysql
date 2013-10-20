unit Commfunc;

interface

uses
   winprocs,Graphics,CommType,iniFiles,Classes;

Type PFont=^TFont;

function ReadFont(ini:TiniFile; Prefix:String):TFont;
Function ExtPos(sub:String; s:TStrings):Integer;
Procedure WriteFont(ini:TiniFile; Prefix:String; f:TFont);

Const
  Prefixs:array[0..6]of string=('Button','ToolBarButton','Grid','GridTitle',
   'Label','Edit','Tree');

implementation

const
  sCommon = 'Common';
  sFontBold = 'FontBold';
  sFontItalic = 'FontItalic';
  sFontUnderline = 'FontUnderline';
  sFontStrikeOut = 'FontStrikeOut';
  sFontSize = 'FontSize';
  sFontName = 'FontName';
  sFontColor = 'FontColor';

function ReadFont(ini:TiniFile; Prefix:string):TFont;
var f:TFont;
begin
  f:=TFont.Create;
  f.Style:=[];
  if Ini.ReadBool(sCommon,Prefix+sFontBold,False) then
    f.Style:= f.Style+[fsBold];
  if Ini.ReadBool(sCommon,Prefix+sFontItalic,False) then
    f.Style:= f.Style+[fsItalic];
  if Ini.ReadBool(sCommon,Prefix+sFontUnderline,False) then
    f.Style:= f.Style+[fsUnderline];
  if Ini.ReadBool(sCommon,Prefix+sFontStrikeOut,False) then
    f.Style:= f.Style+[fsStrikeOut];
  f.Size := ini.ReadInteger(sCommon,Prefix+sFontSize,10);
  f.Name := ini.ReadString (sCommon,Prefix+sFontName,'System');
  f.Color:= Ini.ReadInteger(sCommon,Prefix+sFontColor,clBlack);
  ReadFont:=f
end;

Procedure WriteFont(ini:TiniFile; Prefix:String; f:TFont);
begin
  with ini do
  begin
    WriteBool(sCommon,Prefix+sFontBold,fsBold in f.Style);
    WriteBool(sCommon,Prefix+sFontItalic,fsItalic in  f.Style);
    WriteBool(sCommon,Prefix+sFontUnderline,fsUnderline in f.Style);
    WriteBool(sCommon,Prefix+sFontStrikeOut,fsStrikeOut in f.Style);
    WriteInteger(sCommon,Prefix+sFontSize,f.Size);
    WriteString (sCommon,Prefix+sFontName,f.Name);
    WriteInteger(sCommon,Prefix+sFontColor,f.Color)
  end
end;

Function ExtPos(sub:String; s:TStrings):Integer;
var
  OpenSkobka,i,j,min:Integer;
  k           :array[1..3] of integer;
  d:string;
begin
  ExtPos:=-1;
  if sub='' then exit;
  OpenSkobka:=0;
  for i:=0 to s.count-1 do
    begin
      d:=s.Strings[i];
      repeat
        k[1]:=pos('(',d);
        k[2]:=pos(')',d);
        k[3]:=pos(sub,d);
        min:=1;
        for j:=1 to 3 do
          if ((k[j]<k[min]) or (k[min]=0)) and (k[j]<>0) then min:=j;
        if k[min]<>0 then
          begin
            case min of
              1: inc(OpenSkobka);
              2: dec(OpenSkobka);
              3: if OpenSkobka=0 then
                begin
                  ExtPos:=i;
                  exit
                end
          end;
          Delete(d,1,k[min])
      end
      until k[min]=0
    end;
  i:=0
end;

end.
