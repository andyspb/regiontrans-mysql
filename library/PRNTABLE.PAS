unit Prntable;

interface

Type TDBPrinter=class(TPrinter)
       public:
         procedure Print(Query:TQuery);
     end;

implementation

procedure TDBPrinter.Print(Query:TQuery;Title:string);
var tb:TBookMark;
    OffsetLeft,OffsetRight,OffsetTop,OffsetBottom:integer;
begin
  tb:=Query.GetBookMark;

  Query.GotoBookMark(tb);
  Query.FreeBookMark(tb);
end;

end.
