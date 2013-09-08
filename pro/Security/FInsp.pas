unit FInsp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SqlGrid, StdCtrls,Tadjform, DBTables,Grids,tsqlcls,
  Buttons, BMPBtn, toolbtn, ToolWin, ComCtrls;

type
  TFormInsp = class(TadjustForm)
    ToolBar1: TToolBar;
    eCard: TToolbarButton;
    eADD: TToolbarButton;
    eDelete: TToolbarButton;
    eExit: TToolbarButton;
    SQLGrid1: TSQLGrid;
    procedure eDeleteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure eExitClick(Sender: TObject);
    procedure eADDClick(Sender: TObject);
    procedure eCardClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormInsp: TFormInsp;

implementation

uses FAEInsp;

{$R *.dfm}

procedure TFormInsp.eDeleteClick(Sender: TObject);
var l: longint;
begin
sql.StartTransaction;
 sqlGrid1.saveNextPoint('Ident');
 l:=sqlGrid1.Query.FieldByName('Ident').AsInteger;
if sql.delete('Inspector','Ident='+IntToStr(l))<>0
then begin
     application.MessageBox('Инспектор не подлежит удалению!','Ошибка!',0);
     exit;
     end
 else begin
 case Application.MessageBox('Удалить!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES:
    begin
sql.Commit;
         sqlgrid1.Exec;
         if (sqlGrid1.Query.eof)and (sqlGrid1.Query.bof)then
         begin
         eCard.Enabled:=false;
         eDelete.Enabled:=false;
         sqlgrid1.Visible:=false;
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

procedure TFormInsp.FormCreate(Sender: TObject);
begin
sqlGrid1.ExecTable('InspectorRoles');
if (sqlgrid1.Query.Eof) and (sqlgrid1.Query.bof) then
 begin
         eCard.Enabled:=false;
         eDelete.Enabled:=false;
         sqlgrid1.Visible:=false;
 end
 else begin
         eCard.Enabled:=true;
         eDelete.Enabled:=true;
         sqlgrid1.Visible:=true;
      end;
end;

procedure TFormInsp.eExitClick(Sender: TObject);
begin
  close;
end;

procedure TFormInsp.eADDClick(Sender: TObject);
var l:longint;
begin
FormAEInsp:=TFormAEInsp.Create(Application) ;
l:=FormAEInsp.AddRecord;

if l<>0 then
 begin
         eCard.Enabled:=true;
         eDelete.Enabled:=true;
         sqlgrid1.Visible:=true;
         sqlGrid1.ExecTable('InspectorRoles');
         sqlGrid1.LoadPoint('Ident',l);
 end;
 FormAEInsp.free;
end;

procedure TFormInsp.eCardClick(Sender: TObject);
var l:longint;
    id :longint;
begin
id:=sqlGrid1.Query.FieldByName('Ident').AsInteger;
FormAEInsp:=TFormAEInsp.Create(Application) ;
l:=FormAEInsp.editRecord(id);

if l<>0 then
 begin
         eCard.Enabled:=true;
         eDelete.Enabled:=true;
         sqlgrid1.Visible:=true;
         sqlGrid1.ExecTable('InspectorRoles');
         sqlGrid1.LoadPoint('Ident',l);
 end;
FormAEInsp.free;
end;

procedure TFormInsp.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then eCardClick(Sender)
end;

end.
