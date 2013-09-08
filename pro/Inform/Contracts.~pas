unit Contracts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, Grids, DBGrids, StdCtrls, Buttons, BMPBtn,
  toolbtn,tsqlcls, ToolWin, ComCtrls,Tadjform, SqlGrid;

type
  TFormContracts = class(tadjustform)
    ToolBar1: TToolBar;
    eCard: TToolbarButton;
    eDelete: TToolbarButton;
    eExit: TToolbarButton;
    SQLGrid1: TSQLGrid;
    procedure eDeleteClick(Sender: TObject);  
    procedure eCardClick(Sender: TObject);
    procedure eExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormContracts: TFormContracts;

implementation

uses ContractCard;

{$R *.dfm}

procedure TFormContracts.eDeleteClick(Sender: TObject);
var
  Nam:string;
  Cl_Id:longint;
  CT_Id:integer;
begin
if (not SQLGrid1.Query.eof) or (not SQLGrid1.Query.bof) then
begin
sql.startTransaction;
Nam:=SqlGrid1.Query.FieldByName('Number').Asstring;
Cl_Id:=sqlGrid1.Query.fieldByName('Clients_Ident').AsInteger;
CT_Id:=sqlGrid1.Query.fieldByName('ContractType_Ident').AsInteger;
if sql.execOneSql('delete from Contract where Number='+sql.Makestr(Nam)+' and Clients_Ident='+
                IntToStr(CL_ID)+' and ContractType_Ident='+IntToStr(CT_ID))<>0 then
                begin
                 sql.Rollback;
                 application.messageBox('Контракт нельзя удалить он используется!','Ошибка',0);
                 exit
                end else begin
                         case Application.MessageBox('Удалить!',
                                                     'Предупреждение!',
                                                     MB_YESNO+MB_ICONQUESTION) of
                         IDYES: sql.Commit;
                         IDNO:
                           begin
                             sql.rollback;
                             exit
                           end;
                         end;
                         end;
SqlGrid1.exec;
end;
end;



procedure TFormContracts.eCardClick(Sender: TObject);
var Cl_Id:longint;
    CT_Id:integer;
begin
if (not SQLGrid1.Query.eof) or (not SQLGrid1.Query.bof) then
begin
Cl_Id:=sqlGrid1.Query.fieldByName('Clients_Ident').AsInteger;
CT_Id:=sqlGrid1.Query.fieldByName('ContractType_Ident').AsInteger;
FormCardContract:=TFormCardContract.Create(Application) ;
FormCardContract.EditRecord(CT_Id,Cl_Id);
FormCardContract.Free;

sqlGrid1.Exec;
sqlGrid1.LoadPoint('Clients_Ident',Cl_Id);
end;
end;

procedure TFormContracts.eExitClick(Sender: TObject);
begin
close;
end;

procedure TFormContracts.FormCreate(Sender: TObject);
begin
fsection:='ContractsForm';
sqlGrid1.ExecTable('Contracts');
end;

procedure TFormContracts.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then eCardClick(Sender)
end;

end.
