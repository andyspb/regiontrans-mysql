unit FunChar;

interface

     function IsAlpha(c:char):boolean;
     function IsDigit(c:char):boolean;
     function IsAlphaDigit(c:char):boolean;

implementation

function IsAlpha(c:char):boolean;
begin
  IsAlpha:=((UpCase(c)>='A') and (UpCase(c)<='Z'));
end;

function IsDigit(c:char):boolean;
begin
  IsDigit:=((c>='0') and (c<='9'));
end;

function IsAlphaDigit(c:char):boolean;
begin
  IsAlphaDigit:=((UpCase(c)>='A') and (UpCase(c)<='Z')) or ((c>='0') and (c<='9'));
end;

end.
