unit DBPrint;

interface
Uses Classes,Printers,Graphics,DBTables,WinTypes,DB,SysUtils,dbgrids;

Type TDBPrinter=class(TObject)
       protected
         Grid:TDBGrid;
       public
         OffsetLeft,
         OffsetRight,
         OffsetTop,
         OffsetBottom:integer;
         TitleFont   :TFont;
         function  CreateStringList(Field:TField):TStringList;
         procedure Print(DBGrid:TDBGrid;Query:TQuery;Title:string);
         procedure DrawPage(Query:TQuery;oLeft,oTop,oRight,oBottom:integer);
         procedure TextRectPrn(x,y,dx,dy:integer;Txt:string;Alignment:TAlignment);
         procedure FieldRectPrn(x,y,dx,dy:integer;Field:TField);
         procedure DrawRect(x,y,dx,dy:integer);
     end;

implementation

function TDBPrinter.CreateStringList(Field:TField):TStringList;
var sl:TStringList;
    sr:TMemoryStream;
    t:integer;
begin
  sl:=TStringList.Create;
  if Field is TMemoField then
    begin
      sr:=TMemoryStream.Create;
      TMemoField(Field).SaveToStream(sr);
      t:=0;
      sr.Write(t,1);
      sl.SetText(sr.Memory);
      sr.Free;
    end
  else
    sl.Add(Field.Text);
  CreateStringList:=sl;
end;

procedure TDBPrinter.TextRectPrn(x,y,dx,dy:integer;Txt:string;Alignment:TAlignment);
var r:TRect;
begin
  Printer.Canvas.Rectangle(x,y,x+dx,y+dy);
  r.Left:=x+2;  r.Right:=x+dx-2;
  r.Top:=y+2;   r.Bottom:=y+dy-2;
  x:=Printer.Canvas.TextWidth(Txt);
  dy:=r.Top+Printer.Canvas.TextHeight('A') div 2;
  dx:=Printer.Canvas.TextWidth('A') div 2;
  case Alignment of
    taLeftJustify: Printer.Canvas.TextRect(r,r.Left+dx,dy,Txt);
    taRightJustify: Printer.Canvas.TextRect(r,r.Right-x-dx,dy,Txt);
    taCenter: Printer.Canvas.TextRect(r,r.Left+(r.Right-r.Left-x) div 2,dy,Txt);
  end;
end;

procedure TDBPrinter.DrawRect(x,y,dx,dy:integer);
begin
  Printer.Canvas.MoveTo(x,y);
  Printer.Canvas.LineTo(x+dx,y);
  Printer.Canvas.LineTo(x+dx,y+dy);
  Printer.Canvas.LineTo(x,y+dy);
  Printer.Canvas.LineTo(x,y);
end;

procedure TDBPrinter.FieldRectPrn(x,y,dx,dy:integer;Field:TField);
var r:TRect;
    sl:TStringList;
    i:integer;
    xx,yy,dxx,dyy:integer;
begin
  xx:=x; yy:=y; dxx:=dx; dyy:=dy;
  Printer.Canvas.Rectangle(x,y,x+dx,y+dy);
  sl:=CreateStringList(Field);
  r.Left:=x+2;  r.Right:=x+dx-2;
  r.Top:=y;     r.Bottom:=y+dy-2;
  y:=Printer.Canvas.TextHeight('A');
  dy:=y div 2;
  dx:=Printer.Canvas.TextWidth('A') div 2;

  r.Top:=r.Top+dy;
  for i:=0 to sl.Count-1 do
    begin
      x:=Printer.Canvas.TextWidth(sl.Strings[i]);
      case Field.Alignment of
        taLeftJustify: Printer.Canvas.TextRect(r,r.Left+dx,r.Top,sl.Strings[i]);
        taRightJustify: Printer.Canvas.TextRect(r,r.Right-x-dx,r.Top,sl.Strings[i]);
        taCenter: Printer.Canvas.TextRect(r,r.Left+(r.Right-r.Left-x) div 2,r.Top,
                   sl.Strings[i]);
      end;
      r.Top:=r.Top+y;
    end;
  sl.Free;
  DrawRect(xx,yy,dxx,dyy);
end;

procedure TDBPrinter.DrawPage(Query:TQuery;oLeft,oTop,oRight,oBottom:integer);
var r,dx:Real;
    i,Am,x,dy,k:integer;
//    b:boolean;
    sl:TStringList;
begin
  Am:=0;
  for i:=0 to Query.FieldCount-1 do
    if Query.Fields[i].Visible then
      Am:=Am+Query.Fields[i].DisplayWidth;
  r:=(oRight-oLeft)/Am;

  Printer.Canvas.Font:=Grid.TitleFont;
  dy:=Printer.Canvas.TextHeight('A')*2;
  x:=oLeft;
  for i:=0 to Query.FieldCount-1 do
    if Query.Fields[i].Visible then
      begin
        dx:=r*Query.Fields[i].DisplayWidth;
        TextRectPrn(x,oTop,round(dx),dy,Query.Fields[i].DisplayLabel,taLeftJustify);
        x:=x+round(dx);
      end;
  oTop:=oTop+dy;

  Printer.Canvas.Font:=Grid.Font;
  dy:=Printer.Canvas.TextHeight('A');
  while (not Query.Eof) and (oTop<oBottom) do
    begin
      k:=1;
      for i:=0 to Query.FieldCount-1 do
        if Query.Fields[i].Visible then
          if Query.Fields[i] is TMemoField then
            begin
              sl:=CreateStringList(TMemoField(Query.Fields[i]));
              if sl.Count>k then k:=sl.Count;
              sl.Free;
            end;
      if oTop+dy*(k+1)<=oBottom then
        begin
          x:=oLeft;
          for i:=0 to Query.FieldCount-1 do
            if Query.Fields[i].Visible then
              begin
                dx:=r*Query.Fields[i].DisplayWidth;
                FieldRectPrn(x,oTop,round(dx),dy*(k+1),Query.Fields[i]);
                x:=x+round(dx);
              end;
           Query.Next;
        end;
      oTop:=oTop+dy*(k+1);
    end;
end;

procedure TDBPrinter.Print(DBGrid:TDBGrid;Query:TQuery;Title:string);
var tb:TBookMark;
    i,dd:integer;
    b:boolean;
    s:String;
begin
{}
         OffsetLeft:=0;
         OffsetRight:=0;
         OffsetTop:=0;
         OffsetBottom:=0;
  Grid:=DBGrid;
  tb:=Query.GetBookMark;
  Query.DisableControls;
  Printer.BeginDoc;
  Query.First;
  Printer.Canvas.Font.Name:='Baltica';
  Printer.Canvas.Font.Size:=20;
  Printer.Canvas.TextOut((Printer.PageWidth-OffsetRight-OffsetLeft-Printer.Canvas.TextWidth(Title)) div 2 + OffsetRight,
                   OffsetTop,Title);
  i:=Printer.Canvas.TextHeight('A');
  dd:=OffsetTop+i+10;
  b:=FALSE;
  repeat
    if b then Printer.NewPage;
    Printer.Canvas.Font:=DBGrid.Font;
    i:=Printer.Canvas.TextHeight('A');
    DrawPage(Query,OffsetLeft,dd,Printer.PageWidth-OffsetRight-1,Printer.PageHeight-OffsetBottom-2*i);
    Printer.Canvas.Font:=DBGrid.Font;
    s:='Страница '+IntToStr(Printer.PageNumber);
    Printer.Canvas.TextOut((Printer.PageWidth-OffsetRight-OffsetLeft-Printer.Canvas.TextWidth(s)) div 2 + OffsetRight,
                   Printer.PageHeight-OffsetBottom-i,s);
    dd:=OffsetTop;
    b:=TRUE;
  until Query.eof;
  Printer.EndDoc;
  Query.GotoBookMark(tb);
  Query.FreeBookMark(tb);
  Query.EnableControls;
end;

end.
