unit Banks;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB, DBTables, StdCtrls, Buttons, BMPBtn,
  toolbtn,Lebtn, ToolWin,tsqlcls,Tadjform, ComCtrls, SqlGrid;

type
  TFormBank = class(TadjusTForm)
    ToolBar1: TToolBar;
    eCard: TToolbarButton;
    eADD: TToolbarButton;
    eDelete: TToolbarButton;
    eExit: TToolbarButton;
    SQLGrid1: TSQLGrid;
    procedure eExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure eADDClick(Sender: TObject);
    procedure eCardClick(Sender: TObject); 
    procedure eDeleteClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormBank: TFormBank;
  Ident:integer;
  TabName:string;
  cond:string;
implementation

uses CardBank;

{$R *.dfm}

procedure TFormBank.eExitClick(Sender: TObject);
begin
close;
end;

procedure TFormBank.FormCreate(Sender: TObject);
begin
fsection:='FormBanksBox';
sqlGrid1.ExecTable('Banks');

end;

procedure TFormBank.eADDClick(Sender: TObject);
var l:longint;
begin
FormCardBank:=TFormCardBank.Create(Application) ;
l:=FormCardBank.AddRecord;
FormCardBank.Free;
sqlgrid1.Exec;
sqlGrid1.LoadPoint('Ident',l);
 //sqlGrid1.SearchGrid.
end;

procedure TFormBank.eCardClick(Sender: TObject);
var l:longint;
begin
  Ident:=sqlgrid1.FieldByName('Ident').Asinteger;
  FormCardBank:=TFormCardBank.Create(Application) ;
  l:=FormCardBank.EditRecord(Ident);
  FormCardBank.Free;
  sqlgrid1.Exec;
  sqlGrid1.LoadPoint('Ident',l);
end;


procedure TFormBank.eDeleteClick(Sender: TObject);
begin
Ident:=sqlgrid1.Query.FieldByName('Ident').Asinteger;
sql.execOneSql('delete from bank where Ident='+IntToStr(Ident));
 sqlgrid1.Exec;
end;

end.
