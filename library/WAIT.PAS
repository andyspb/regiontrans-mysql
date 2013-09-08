unit Wait;


interface

Uses Controls, Forms;

type
   TWait = object
     constructor Init;
     destructor Done;
   private
     OldCursor:  TCursor;
   end;

implementation
constructor TWait.Init;
begin
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourglass;
end;

destructor TWait.Done;
begin
  Screen.Cursor := OldCursor;
end;


end.
