unit encoder;
interface

  function DoEncode(s:string):string;
  function DoDecode(s:string):string;
  function DoEncodeEx(s:string;code:integer):string;
  function DoDecodeEx(s:string;code:integer):string;
var
  DecodeErrorCode:integer;

implementation
const
  numbers:array[0..15] of char = ('A','B','C','D','E','F','G',
         'H','I','J','K','L','M','N','O','P');

function Crypt(s:string;code:integer):string;
var
  i:integer;
  res:string;
begin
  randseed:=code;
  for i:=1 to length(s) do
    s[i]:=chr(byte(s[i]) xor byte(random(256)));
  res:='';
  for i:=1 to length(s) do
    res:=res+numbers[byte(s[i]) and 15]+numbers[(byte(s[i]) shr 4) and 15];
  Crypt:=res;
end;

function DeCrypt(s:string;code:integer):string;
var
  i:integer;
  res:string;
begin
  res:='';
  i:=1;
  while i<length(s) do
    begin
      res:=res+chr(byte(s[i])-byte('A')+((byte(s[i+1])-byte('A')) shl 4));
      inc(i,2);
    end;
  randseed:=code;
  for i:=1 to length(res) do
    res[i]:=chr(byte(res[i]) xor byte(random(256)));
  DeCrypt:=res;
end;

function DoEncodeEx(s:string;code:integer):string;
var
  checksum:word;
  i:integer;
begin
  checksum:=0;
  for i:=1 to length(s) do checksum:=checksum+ord(s[i]);
  s:=s+chr(Lo(checksum));
  s:=s+chr(Hi(checksum));
  DoEncodeEx:=Crypt(s,code);
end;

function DoDecodeEx(s:string;code:integer):string;
var
  stc,checksum:word;
  i:integer;
begin
  checksum:=0;
  DecodeErrorCode:=0;
  if length(s) mod 2=1 then
    begin DecodeErrorCode:=1; Result:='Value changed!'; exit; end;
  s:=DeCrypt(s,code);
  for i:=1 to length(s)-2 do checksum:=checksum+ord(s[i]);
  stc:=ord(s[length(s)-1])+word(ord(s[length(s)])) shl 8;
  if stc<>checksum then begin DecodeErrorCode:=1;Result:='Value changed!' end
                 else Result:=copy(s,1,length(s)-2);
end;

function DoEncode(s:string):string;
begin
 DoEncode:=DoEncodeEx(s,100);
end;

function DoDecode(s:string):string;
begin
 DoDecode:=DoDecodeEx(s,100);
end;

end.
