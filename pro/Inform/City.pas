unit City;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SqlGrid, StdCtrls,tsqlcls,Tadjform, Buttons, BMPBtn, toolbtn, ToolWin, ComCtrls,
  DBTables,DB;

type
  TFormCity = class(TadjustForm)
    ToolBar1: TToolBar;
    eCard: TToolbarButton;
    eADD: TToolbarButton;
    eDelete: TToolbarButton;
    eExit: TToolbarButton;
    SQLGrid1: TSQLGrid;
    UpdateSQL1: TUpdateSQL;
    procedure FormCreate(Sender: TObject);
    procedure eCardClick(Sender: TObject);
    procedure eADDClick(Sender: TObject);
    procedure eExitClick(Sender: TObject);
    procedure eDeleteClick(Sender: TObject);
    
  private
    { Private declarations }
  public

    { Public declarations }
  end;

var
  FormCity: TFormCity;
  

implementation

uses FCity;

{$R *.dfm}

procedure TFormCity.FormCreate(Sender: TObject);
begin
fsection:='CityForm'   ;
SQLGrid1.exectable('City');
end;


procedure TFormCity.eCardClick(Sender: TObject);
var Id,l:longint;
begin
 Id:=sqlGrid1.Query.FieldByName('Ident').Asinteger;
 //CityForm.
 CityForm:=TCityForm.Create(Application) ;
 l:=CityForm.EditRecord(Id);
 CityForm.Free;
 SQLGrid1.exectable('City');
 SQLGrid1.LoadPoint('Ident',l);
end;

procedure TFormCity.eADDClick(Sender: TObject);
var l:longint;
begin
 CityForm:=TCityForm.Create(Application) ;
 l:=CityForm.AddRecord;
 CityForm.Free;
 SQLGrid1.exectable('City');
 SQLGrid1.LoadPoint('Ident',l);
end;

procedure TFormCity.eExitClick(Sender: TObject);
begin
close;
end;

procedure TFormCity.eDeleteClick(Sender: TObject);
var Id:longint;
begin
Id:=sqlGrid1.Query.FieldByName('Ident').Asinteger;
sql.delete('City','Ident='+IntToStr(Id));
SQLGrid1.exectable('City');

end;

end.
