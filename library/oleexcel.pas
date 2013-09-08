{EXPORT TO EXCEL}
{*****************************************************}
{                                                     }
{   TOLEExcel 1.0 for Delphi 2 by Duong Luu           }
{   E-mail: dluu@wt.net                               }
{   http://web.wt.net/~dluu/index.html                }
{                                                     }
{*****************************************************}
{                                                     }
{   This component transfer data from Table, Query    }
{   or StringGrid to your Excel App.                  }
{   Usage: Install and Drop component on the form     }
{                                                     }
{          OLEExcel1.CreateExcelInstance;             }
{          OLEExcel1.TableToExcel( Table1 );          }
{          OLEExcel1.Visible := True;                 }
{                                                     }
{   It's a freeware, but keep author name with all    }
{   files. Enjoy!                                     }
{                                                     }
{*****************************************************}
unit OLEExcel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComObj, DBTables, Grids, QExport;


type
  TOLEExcel = class(TComponent)
  private
    FExcelCreated: Boolean;
    FVisible: Boolean;
    FExcel: Variant;
    FWorkBook: Variant;
    FWorkSheet: Variant;
    FCellFont: TFont;
    FTitleFont: TFont;
    FFontChanged: Boolean;
    FIgnoreFont: Boolean;
    procedure SetExcelCellFont( var Cell: Variant );
    procedure SetExcelTitleFont( var Cell: Variant );
    procedure GetTableColumnName( const Table: TTable; var Cell: Variant );
    procedure GetQueryColumnName( const Query: TQuery; var Cell: Variant );
    procedure GetFixedCols( const StringGrid: TStringGrid; var Cell: Variant );
    procedure GetFixedRows( const StringGrid: TStringGrid; var Cell: Variant );
    procedure GetStringGridBody( const StringGrid: TStringGrid; var Cell: Variant );    
  protected
    procedure SetCellFont( NewFont: TFont );
    procedure SetTitleFont( NewFont: TFont );
    procedure SetVisible(DoShow: Boolean);
  public
    function GetCell(ACol, ARow: Integer): string;
    procedure SetCell(ACol, ARow: Integer; const Value: string);
    function GetDateCell(ACol, ARow: Integer): TDateTime;
    procedure SetDateCell(ACol, ARow: Integer; const Value: TDateTime);
    constructor Create ( AOwner : TComponent ); override;
    destructor Destroy; override;
    procedure CreateExcelInstance;
    property Cell[ACol, ARow: Integer]: string read GetCell write SetCell;
    property DateCell[ACol, ARow: Integer]: TDateTime read GetDateCell write SetDateCell;
    function IsCreated: Boolean;
    procedure TableToExcel( const Table: TTable );
    procedure QueryToExcel( const Query: TQuery );
    procedure StringGridToExcel( const StringGrid: TStringGrid );
  published
    property TitleFont: TFont read FTitleFont write SetTitleFont;
    property CellFont: TFont read FCellFont write SetCellFont;
    property Visible: Boolean read FVisible write SetVisible;
    property IgnoreFont: Boolean read FIgnoreFont write FIgnoreFont;
  end;

procedure Register;

implementation

constructor TOLEExcel.Create ( AOwner : TComponent );
begin
  inherited Create( AOwner );
  FIgnoreFont := True;  
  FCellFont := TFont.Create;
  FTitleFont := TFont.Create;
  FExcelCreated := False;
  FVisible := False;
  FFontChanged := False;
end;

destructor TOLEExcel.Destroy;
begin
  FCellFont.Free;
  FTitleFont.Free;
  inherited Destroy;
end;

procedure TOLEExcel.SetExcelCellFont( var Cell: Variant );
begin
  if FIgnoreFont then exit;
  with FCellFont do
    begin
      Cell.Font.Name := Name;
      Cell.Font.Size := Size;
      Cell.Font.Color := Color;
      Cell.Font.Bold := fsBold in Style;
      Cell.Font.Italic := fsItalic in Style;
      Cell.Font.UnderLine := fsUnderline in Style;
      Cell.Font.Strikethrough := fsStrikeout in Style;
    end;
end;

procedure TOLEExcel.SetExcelTitleFont( var Cell: Variant );
begin
  if FIgnoreFont then exit;
  with FTitleFont do
    begin
      Cell.Font.Name := Name;
      Cell.Font.Size := Size;
      Cell.Font.Color := Color;
      Cell.Font.Bold := fsBold in Style;
      Cell.Font.Italic := fsItalic in Style;
      Cell.Font.UnderLine := fsUnderline in Style;
      Cell.Font.Strikethrough := fsStrikeout in Style;
    end;
end;


procedure TOLEExcel.SetVisible( DoShow: Boolean );
begin
  if not FExcelCreated then exit;
  if DoShow then
    FExcel.Visible := True
  else
    FExcel.Visible := False;
end;

function TOLEExcel.GetCell( ACol, ARow: Integer ): string;
begin
  if not FExcelCreated then exit;
  result := FWorkSheet.Cells[ ARow, ACol ];
end;

procedure TOLEExcel.SetCell(ACol, ARow: Integer; const Value: string);
var
  Cell: Variant;
begin
  if not FExcelCreated then exit;
  Cell := FWorkSheet.Cells[ ARow, ACol ];
  SetExcelCellFont( Cell );
  Cell.Value := Value;
end;


function TOLEExcel.GetDateCell( ACol, ARow: Integer ): TDateTime;
begin
  if not FExcelCreated then
    begin
      result := 0;
      exit;
    end;
  result := StrToDateTime( FWorkSheet.Cells[ ARow, ACol ] );
end;

procedure TOLEExcel.SetDateCell(ACol, ARow: Integer; const Value: TDateTime);
var
  Cell: Variant;
begin
  if not FExcelCreated then exit;
  Cell := FWorkSheet.Cells[ ARow, ACol ];
  SetExcelCellFont( Cell );
  Cell.Value := '''' + DateTimeToStr( Value );
end;

procedure TOLEExcel.CreateExcelInstance;
begin
  try
    FExcel := CreateOLEObject( 'Excel.Application' );
    FWorkBook := FExcel.WorkBooks.Add;
    FWorkSheet := FWorkBook.WorkSheets.Add;
    FExcelCreated := True;
  except
    FExcelCreated := False;
  end;
end;

function TOLEExcel.IsCreated: Boolean;
begin
  result := FExcelCreated;
end;

procedure TOLEExcel.SetTitleFont( NewFont: TFont );
begin
  if NewFont <> FTitleFont then
    FTitleFont.Assign( NewFont );
end;

procedure TOLEExcel.SetCellFont( NewFont: TFont );
begin
  if NewFont <> FCellFont then
    FCellFont.Assign( NewFont );
end;

procedure TOLEExcel.GetTableColumnName( const Table: TTable; var Cell: Variant );
var
  Col: integer;
begin
  for Col := 0 to Table.FieldCount-1 do
    begin
      Cell := FWorkSheet.Cells[ 1, Col+1 ];
      SetExcelTitleFont( Cell );
      Cell.Value := Table.Fields[ Col ].FieldName;
    end;
end;

procedure TOLEExcel.TableToExcel( const Table: TTable );
var
  Col, Row: LongInt;
  Cell: Variant;
begin
  if not FExcelCreated then exit;
  if Table.Active = False then exit;

  GetTableColumnName( Table, Cell );
  Row := 2;
  with Table do
    begin
      first;
      while not EOF do
        begin
          for Col := 0 to FieldCount-1 do
            begin
              Cell := FWorkSheet.Cells[ Row, Col+1 ];
              SetExcelCellFont( Cell );              
              Cell.Value := Fields[ Col ].AsString;
            end;
          next;
          Inc( Row );
        end;
    end;
end;


procedure TOLEExcel.GetQueryColumnName( const Query: TQuery; var Cell: Variant );
var
  Col,eCol: integer;
  Column: Variant;
begin
  eCol:=0;
  for Col := 0 to Query.FieldCount-1 do
   if Query.Fields[Col].Visible then
    begin
      Cell := FWorkSheet.Cells[ 1, eCol+1 ];
      SetExcelTitleFont( Cell );
      Cell.Value := Query.Fields[ Col ].DisplayLabel;
//      Column:=FWorkSheet.Columns[eCol+1];
      Cell.ColumnWidth:=Query.Fields[ Col ].DisplayWidth;
      inc(eCol);
    end;
end;


procedure TOLEExcel.QueryToExcel( const Query: TQuery );
var
  Col, eCol, Row: LongInt;
  Cell: Variant;
  s:string;
begin
  if not FExcelCreated then exit;
  if Query.Active = False then exit;

  GetQueryColumnName( Query, Cell );
  Row := 2;
  with Query do
    begin
      first;
      while not EOF do
        begin
          eCol:=0;    
          for Col := 0 to FieldCount-1 do
           if Fields[Col].Visible then
            begin
              Cell := FWorkSheet.Cells[ Row, eCol+1 ];
              SetExcelCellFont( Cell );
              s:=ConvertStr(Fields[ Col ].AsString);
              Cell.Value := s;
//              if length(s)>40 then Cell.Width:=length(s)*8;
              inc(eCol);
            end;
          next;
          Inc( Row );
          if Row>100 then break;
        end;
    end;
end;

procedure TOLEExcel.GetFixedCols( const StringGrid: TStringGrid; var Cell: Variant );
var
  Col, Row: LongInt;
begin
  for Col := 0 to StringGrid.FixedCols-1 do
    for Row := 0 to StringGrid.RowCount-1 do
      begin
        Cell := FWorkSheet.Cells[ Row+1, Col+1 ];
        SetExcelTitleFont( Cell );
        Cell.Value := StringGrid.Cells[ Col, Row ];
      end;
end;

procedure TOLEExcel.GetFixedRows( const StringGrid: TStringGrid; var Cell: Variant );
var
  Col, Row: LongInt;
begin
  for Row := 0 to StringGrid.FixedRows-1 do
    for Col := 0 to StringGrid.ColCount-1 do
      begin
        Cell := FWorkSheet.Cells[ Row+1, Col+1 ];
        SetExcelTitleFont( Cell );
        Cell.Value := StringGrid.Cells[ Col, Row ];
      end;
end;

procedure TOLEExcel.GetStringGridBody( const StringGrid: TStringGrid; var Cell: Variant );
var
  Col, Row, x, y: LongInt;
begin
  Col := StringGrid.FixedCols;
  Row := StringGrid.FixedRows;
  for x := Row to StringGrid.RowCount-1 do
    for y := Col to StringGrid.ColCount-1 do
      begin
        Cell := FWorkSheet.Cells[ x+1, y+1 ];
        SetExcelCellFont( Cell );
        Cell.Value := StringGrid.Cells[ y, x ];
      end;
end;

procedure TOLEExcel.StringGridToExcel( const StringGrid: TStringGrid );
var
  Cell: Variant;
begin
  if not FExcelCreated then exit;
  GetFixedCols( StringGrid, Cell );
  GetFixedRows( StringGrid, Cell );
  GetStringGridBody( StringGrid, Cell );    
end;

procedure Register;
begin
  RegisterComponents('DLSoft', [TOLEExcel]);
end;

end.
