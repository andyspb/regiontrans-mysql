unit FFerrymanBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SqlGrid, StdCtrls, Buttons, BMPBtn, toolbtn, ToolWin, ComCtrls,
  Grids,tsqlcls, DBGrids,Tadjform, DBTables,  Provider, DBClient,
  DBLocal, DBLocalB;

type
  TFormFerryManBox = class(tadjustform)
    ToolBar1: TToolBar;
    eCard: TToolbarButton;
    eADD: TToolbarButton;
    eDelete: TToolbarButton;
    eExit: TToolbarButton;
    SQLGrid1: TSQLGrid;
    procedure FormCreate(Sender: TObject);
    procedure eCardClick(Sender: TObject);
    procedure eADDClick(Sender: TObject);
    procedure eDeleteClick(Sender: TObject);
    procedure eExitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormFerryManBox: TFormFerryManBox;

implementation

uses FFerryman;

{$R *.dfm}

procedure TFormFerryManBox.FormCreate(Sender: TObject);
begin
fsection:='FormFerryManBox'  ;
SQLGrid1.exectable('FerryManView');
if  (SQLGrid1.query.Eof) and (SQLGrid1.query.Bof)  then
begin
eCard.Enabled:=false;
eDelete.Enabled:=false;
SQLGrid1.visible:=false;
end else
    begin
    eCard.Enabled:=true;
    eDelete.Enabled:=true;
    SQLGrid1.visible:=true;
    end;
end;



procedure TFormFerryManBox.eCardClick(Sender: TObject);
var Ident:longint;
    l:longint;
begin
Ident:=SQLGrid1.Query.FieldByName('Ident').Asinteger;
sql.StartTransaction;
FormFerryman:=TFormFerryman.Create(Application) ;
l:=FormFerryman.EditRecord(Ident);
FormFerryman.Free;
if l<>0 then
begin
sql.Commit;
SQLGrid1.exectable('FerryManView');
SQLGrid1.LoadPoint('Ident',l);
end else sql.Rollback; 
end;

procedure TFormFerryManBox.eADDClick(Sender: TObject);
var l:longint;
begin
sql.StartTransaction;
FormFerryman:=TFormFerryman.Create(Application) ;
l:=FormFerryman.AddRecord;
FormFerryman.Free;
if l<>0 then
begin
sql.Commit;
SQLGrid1.exectable('FerryManView');
SQLGrid1.LoadPoint('Ident',l);
end else sql.Rollback;
if  (SQLGrid1.query.Eof) and (SQLGrid1.query.Bof)  then
begin
eCard.Enabled:=false;
eDelete.Enabled:=false;
SQLGrid1.visible:=false;
end else
    begin
    eCard.Enabled:=true;
    eDelete.Enabled:=true;
    SQLGrid1.visible:=true;
    end;


end;

procedure TFormFerryManBox.eDeleteClick(Sender: TObject);
var Ident:longint;
begin
Sql.StartTransaction;
Ident:=SQLGrid1.Query.FieldByName('Ident').Asinteger;
if sql.execOneSql('Delete from FerryMan where Ident='+IntToStr(Ident))<>0 then
begin
application.MessageBox('Перевозчик не может быть удален где то используется!',
                       'Ошибка!',0);
sql.rollback;
exit
end else
begin

case Application.MessageBox('Удалить!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES:
    begin
    sql.commit;
   SQLGrid1.exectable('FerryManView');
   if  (SQLGrid1.query.Eof) and (SQLGrid1.query.Bof)  then
   begin
    eCard.Enabled:=false;
    eDelete.Enabled:=false;
    SQLGrid1.visible:=false;
   end
    end;
    IDNO:
      begin
      sql.rollback;
      exit
      end;
end;
end;
end;

procedure TFormFerryManBox.eExitClick(Sender: TObject);
begin
close;
end;

end.
