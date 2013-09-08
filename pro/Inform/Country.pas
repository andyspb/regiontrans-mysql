unit Country;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SqlGrid, StdCtrls,tsqlcls,Tadjform, Buttons, BMPBtn, toolbtn, ToolWin, ComCtrls;

type
  TFCountry = class(TadjusTForm)
    ToolBar1: TToolBar;
    eCard: TToolbarButton;
    eADD: TToolbarButton;
    eDelete: TToolbarButton;
    eExit: TToolbarButton;
    SQLGrid1: TSQLGrid;
    procedure FormCreate(Sender: TObject);
    procedure eExitClick(Sender: TObject);
    procedure eDeleteClick(Sender: TObject);
    procedure eCardClick(Sender: TObject);
    procedure eADDClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FCountry: TFCountry;

implementation

uses Cardcountry;

{$R *.dfm}

procedure TFCountry.FormCreate(Sender: TObject);
begin
fsection:='FrCountry';
sqlGrid1.ExecTable('Country');
end;

procedure TFCountry.eExitClick(Sender: TObject);
begin
close;
end;

procedure TFCountry.eDeleteClick(Sender: TObject);
var Id: longint;
begin
Id:=sqlGrid1.Query.FieldByName('Ident').Asinteger;
sql.delete('Country','Ident='+IntToStr(Id));
SQLGrid1.exectable('Country');
end;

procedure TFCountry.eCardClick(Sender: TObject);
var Id,l:longint;
begin
 Id:=sqlGrid1.Query.FieldByName('Ident').Asinteger;
 //CityForm.
 FormCountry:=TFormCountry.Create(Application) ;
 l:=FormCountry.EditRecord(Id);
 FormCountry.Free;
 SQLGrid1.exectable('Country');
 SQLGrid1.LoadPoint('Ident',l);
end;

procedure TFCountry.eADDClick(Sender: TObject);
var l:longint;
begin
 FormCountry:=TFormCountry.Create(Application) ;
 l:=FormCountry.AddRecord;
 FormCountry.Free;
 SQLGrid1.exectable('Country');
 SQLGrid1.LoadPoint('Ident',l);
end;


end.
