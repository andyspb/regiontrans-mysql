unit Prnrpt;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Gauges, StdCtrls, Buttons, PRinters,IniFiles,DBTables,
  DB;

Type
  PInteger = ^Integer;
  TPrnReport = class(TObject)
  private
    { Private declarations }
  protected
     FieldsName : TStringList;
     FieldsDescr: TStringList;
     FieldsSize : Array [0..20]of Integer;{20-Макс кол-во полей}
     FieldsNum  : Integer;
     AmountPart : integer;
    { Protected declarations }
  public
    { Public declarations }
      Printer    : TPrinter;
      ReportName : String;
      ReportIni  : TIniFile;
      Query      : TQuery;
      sqlstr     : TStringList;
      Title      : String;
      Dsn        : String;
      DeltaLeft,DeltaTop,DeltaRight,DEltaBottom:integer;
      Constructor Create;
      Destructor  Destroy;
      Procedure   Print(var Label1:TLabel);
      Procedure   PrintTableOnPage(Left,Top,Right,Bottom: Integer);
      Procedure   DrawField(Rect:TRect;text:String; justify:TAlignment);
    { Published declarations }
  end;


TPrinterDialog = class(TForm)
  BitBtn1 : TBitBtn;
  Label1  : TLabel;
  procedure BitBtn1Click(Sender: TObject);
  procedure FormActivate(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure FormClose(Sender: TObject; var Action: TCloseAction);
private
  { Private declarations }
public
  { Public declarations }
  Report:TPrnReport;
end;

(*
  {$R *.dfm}
*)

Var
ReportsDir:TFileName;

implementation

Constructor TPrnReport.Create;
begin
  Printer:=TPrinter.Create;
  ReportIni := TIniFile.Create( ReportsDir + 'Reports.Ini' );
  Query:=TQuery.Create(Application);
  FieldsDescr:= TStringList.Create;
  SQLStr:= TStringList.Create;
  fieldsName:=tStringList.create;
end;

Destructor TPrnReport.Destroy;
begin
  Printer.Free;
  ReportIni.Free;
  Query.Free;
  FieldsDescr.Free;
  SQLStr.Free;
  FieldsName.Free
end;

Procedure TPrnReport.Print(var Label1:TLabel);
var
  t,s,tmp:string;
  i,d:integer;
begin
  tmp:=Label1.Caption;
  Label1.Caption:=tmp+'0';
  Label1.Update;
  Query.DataBaseName:=Dsn;
  Query.Close;
  Query.Sql.Clear;
  Query.SQL.AddStrings(SqlStr);
  d:=1;
  Try
    Query.Open;
  except
    begin
      d:=0;
    end
  end;
  if d=1 then
    begin
    { Считаю максимальное кол-во страничек отчета }
       i:= ReportIni.ReadInteger(ReportName,'DataFontSize',10);
       printer.BeginDoc;
       with Printer.Canvas do
         begin
         { Считываю данные отступа на страничке }
           t:='Space';
           DeltaLeft  := ReportIni.ReadInteger(ReportName,'Left'+t,20);
           DeltaRight := ReportIni.ReadInteger(ReportName,'Right'+t,15);
           DeltaTop   := ReportIni.ReadInteger(ReportName,'Top'+t,15);
           DeltaBottom:= ReportIni.ReadInteger(ReportName,'Bottom'+t,15);

           ReportIni.ReadSection(ReportName+' Fields',FieldsName);
           FieldsNum:=FieldsName.Count;
           AmountPart:=0;
           for i:=0 to FieldsNum-1 do
             begin
               t:=ReportIni.ReadString(ReportName+' Fields',FieldsName.Strings[i],'|');
               FieldsDescr.Add(Copy(t,1,Pos('|',t)-1));
               Delete(t,1,Pos('|',t));
               FieldsSize[i]:=StrToInt(t);
               AmountPart:=AmountPart+FieldsSize[i];
             end;
           { Печать заголовка отчета }
           s:=ReportIni.ReadString(ReportName,'Title','');
           font.Style:=[];
           t:='Title';
           if ReportIni.ReadBool(ReportName,t+'FontBold',False) then
              font.Style:= font.Style+[fsBold];
           if ReportIni.ReadBool(ReportName,t+'FontItalic',False) then
              font.Style:= font.Style+[fsItalic];
           if ReportIni.ReadBool(ReportName,t+'FontUnderline',False) then
              font.Style:= font.Style+[fsUnderline];
           if ReportIni.ReadBool(ReportName,t+'FontStrikeOut',False) then
              font.Style:= font.Style+[fsStrikeOut];
           font.Size := ReportIni.ReadInteger(ReportName,t+'FontSize',20);
           font.Name := ReportIni.ReadString (ReportName,t+'FontName','System');

           TextOut((Printer.PageWidth-Printer.Canvas.TextWidth(s)) Div 2, DeltaTop, s);

     { Подготовка печати названия полей }
           t:='Field';
           d:=Printer.Canvas.TextHeight('A')+4;
           font.Style:=[];
           if ReportIni.ReadBool(ReportName,t+'FontBold',False) then
              font.Style:= font.Style+[fsBold];
           if ReportIni.ReadBool(ReportName,t+'FontItalic',False) then
              font.Style:= font.Style+[fsItalic];
           if ReportIni.ReadBool(ReportName,t+'FontUnderline',False) then
              font.Style:= font.Style+[fsUnderline];
           if ReportIni.ReadBool(ReportName,t+'FontStrikeOut',False) then
              font.Style:= font.Style+[fsStrikeOut];
           font.Size := ReportIni.ReadInteger(ReportName,t+'FontSize',10);
           font.Name := ReportIni.ReadString (ReportName,t+'FontName','System');
           while not Query.eof do
           begin
             Label1.Caption:=tmp+intTostr(Printer.PageNumber);
             Label1.Update;
             PrintTableOnPage(DeltaLeft,DeltaTop+d,
                      Printer.PageWidth-DeltaRight,
                      Printer.PageHeight-DeltaBottom);
             if not Query.Eof then Printer.NewPage;
             d:=0
           end;
         end;
       printer.EndDoc;
  end;

end;

procedure TPrnReport.PrintTableOnPage(Left,Top,Right,Bottom: Integer);
var
  i,j,h,dx:Integer;
  Rect: TRect;
  text,t : String;
  justify : TAlignment;
  Field   : TField;
begin
  dx:=Right-Left;
  h:=Printer.Canvas.TextHeight('A')+4;
  i:=0;
  justify:=taLeftJustify;
 { Печать названия полей }
  for j:=0 to FieldsNum-1 do
    begin
      if j=0 then
        Rect.Left:=Left
      else
        Rect.Left:=Left+FieldsSize[j-1]*dx div AmountPart;
      Rect.Right:=Rect.Left+FieldsSize[j]*dx div AmountPart;
      Rect.Top:=i*h+Top;
      Rect.Bottom:=Rect.Top+h;
      Printer.Canvas.Rectangle(Rect.Left,Rect.Top,Rect.Right,Rect.Bottom);
      DrawField(Rect,FieldsDescr.Strings[j],justify );
    end;
  i:=i+1;

 { Печать полей данных }

  with Printer.Canvas do
    begin
      font.Style:=[];
      t:='Data';
      if ReportIni.ReadBool(ReportName,t+'FontBold',False) then
           font.Style:= font.Style+[fsBold];
      if ReportIni.ReadBool(ReportName,t+'FontItalic',False) then
           font.Style:= font.Style+[fsItalic];
      if ReportIni.ReadBool(ReportName,t+'FontUnderline',False) then
           font.Style:= font.Style+[fsUnderline];
      if ReportIni.ReadBool(ReportName,t+'FontStrikeOut',False) then
           font.Style:= font.Style+[fsStrikeOut];
      font.Size := ReportIni.ReadInteger(ReportName,t+'FontSize',10);
      font.Name := ReportIni.ReadString (ReportName,t+'FontName','System');

      while ( Bottom-Top > i*h ) and  {Пока есть место на страничке}
        ( Bottom-Top-i*h > h ) and (not Query.eof)do
        begin
          for j:=0 to FieldsNum-1 do
           begin
             if j=0 then Rect.Left:=Left
             else Rect.Left:=Left+FieldsSize[j-1]*dx div AmountPart;
             Rect.Right:=Rect.Left+FieldsSize[j]*dx div AmountPart;
             Rect.Top:=i*h+Top;
             Rect.Bottom:=Rect.Top+h;
             Printer.Canvas.Rectangle(Rect.Left,Rect.Top,Rect.Right,Rect.Bottom);

             Field:=Query.FieldByName(FieldsName[j]);
             text:=Field.AsString;
{             if Field is TFieldMemo then
               with  Field as TFieldMemo do
                 begin
                 end;}
             justify:=Field.Alignment;
             DrawField(Rect,text,justify );
           end;
          Query.Next;
          inc(i);
        end;{While}

 { Печать номера странички }
      t:=IntToStr(Printer.PageNumber);
      TextOut((Printer.PageWidth-Printer.Canvas.TextWidth(t)) Div 2, Printer.PageHeight-DeltaBottom, t);
   end;
end;

procedure TPrnReport.DrawField( Rect:TRect; text:String; justify:TAlignment);
var d:integer;
begin
  inc(Rect.Left);
  inc(Rect.Top);
  dec(Rect.Right);
  dec(Rect.Bottom);
  d:=Printer.Canvas.TextWidth('A');
  case justify of
    taLeftJustify:
      Printer.Canvas.TextRect(Rect,Rect.Left+d,Rect.Top+2,text);
    taRightJustify:
      Printer.Canvas.TextRect(Rect,Rect.Right-Printer.Canvas.TextWidth(Text)-d,Rect.Top+2,text);
    taCenter:
      Printer.Canvas.TextRect(Rect,(Rect.Right-Printer.Canvas.TextWidth(Text)) div 2,
      Rect.Top+2,Text);
  end;
end;

procedure TPrinterDialog.BitBtn1Click(Sender: TObject);
begin
  if Report.Printer.Printing then Report.Printer.Abort
end;

procedure TPrinterDialog.FormActivate(Sender: TObject);
begin
  Report.Print(Label1);
  Label1.Caption:='Печать окончена';
  BitBtn1.Caption:='Закрыть';
end;

procedure TPrinterDialog.FormCreate(Sender: TObject);
begin
  Report:=TPrnReport.Create;
end;

procedure TPrinterDialog.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Report.Free;
end;

end.
