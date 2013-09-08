unit View;

interface

Uses LLi, LLo, Files;

type
  PImageWindow=^TImageWindow;

const
  CyclePagesViewing: boolean = True;

var
  ImageWindow: PImageWindow;
  TotalPage,CurrentPage: Integer;


  procedure PrevPage;
  procedure NextPage;
  procedure ShowPage(n:Word);


implementation

procedure PrevPage;
begin
  if CurrentPage>1 then
   begin
    ShowPage(CurrentPage-1)
   end
  else
   if CyclePagesViewing then ShowPage(TotalPage);
end;


procedure NextPage;
begin
  if CurrentPage<TotalPage then
   begin
    ShowPage(CurrentPage+1);
   end
  else
   if CyclePagesViewing then ShowPage(1);
end;

procedure ShowPage(n:Word);
begin
  if (n = 0) or (n > TotalPage) then exit;
  CurrentPage:=n;
  ImageWindow^.LoadFile(GetTIFFileName(CurrentPage), LLI_DISK_TIF,0);
end;


end.
