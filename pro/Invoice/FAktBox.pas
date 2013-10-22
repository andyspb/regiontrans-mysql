unit FAktBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SqlGrid,Tadjform,tsqlcls,  StdCtrls, Buttons, BMPBtn, EntrySec;

type
  TFormAktBox = class(TAdjustForm)
    BEdit: TBMPBtn;
    BAdd: TBMPBtn;
    BDel: TBMPBtn;
    BExit: TBMPBtn;
    SQLGrid1: TSQLGrid;
    procedure BExitClick(Sender: TObject);
    procedure BDelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure BEditClick(Sender: TObject);
    procedure SQLGrid1RowChange(Sender: TObject);
    procedure BAddClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAktBox: TFormAktBox;
  akttekview_str: string;

implementation
uses FInvoice,Invoice, FAKT;
{$R *.dfm}

procedure TFormAktBox.FormCreate(Sender: TObject);
begin
  Caption:='Акты-ТЭК ( ' + EntrySec.period + ' )';
  if EntrySec.bAllData then
    begin
      akttekview_str:='AktTekView_all';
      BAdd.Enabled:=False;
    end
  else
    begin
      akttekview_str:='AktTekView_all';
      BAdd.Enabled:=True;
    end;
  SQLGrid1.Section:='AktTekView';
  SQLGrid1.ExecTable(akttekview_str);
  if SQLGrid1.Query.eof then
  begin
    SQLGrid1.visible:=false;
    BEdit.enabled:=false;
    BDel.enabled:=false;
  end
  else
  begin
    SQLGrid1.visible:=true;
    BEdit.enabled:=true;
    BDel.enabled:=true;
  end;
  fsection:='FAktTek' ;

end;


procedure TFormAktBox.BExitClick(Sender: TObject);
begin
  close;
end;

procedure TFormAktBox.BDelClick(Sender: TObject);
var
  Id:longint;
  N:string;
begin
  Id:=sqlGrid1.Query.FieldByName('Ident').AsInteger;
  N:=sqlGrid1.Query.FieldByName('Number').AsString;
  sqlGrid1.SaveNextPoint('Ident');
  Sql.StartTransaction;
  if sql.Delete('AktTek','Ident='+IntToStr(Id))<>0 then
  begin
    application.MessageBox('Запись не подлежит удалению!','Ошибка!',0);
    sql.Rollback;
    exit
  end;

  case Application.MessageBox('Удалить!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES:
    begin
      sql.Commit;
      SQLGrid1.exec;
      SQLGrid1RowChange(Sender);
    end;
    IDNO:
    begin
      sql.rollback;
      exit
    end;
  end;

end;

procedure TFormAktBox.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_Return then
    BEditClick(Sender)
end;

procedure TFormAktBox.BEditClick(Sender: TObject);
var
  L,Id:longint;
begin
  Id:=SQLGrid1.Query.FieldByName('Ident').asInteger;
  sql.StartTransaction;
  FormAkt:=TFormAkt.Create(Application) ;
  l:=FormAkt.EditRecord(Id);
  FormAkt.Free;
  if l<>0 then
  begin
    sql.Commit;
    SQLGrid1.execTable(akttekview_str);
    SQLGrid1.LoadPoint('Ident',l);
  end
  else
    sql.Rollback;

end;

procedure TFormAktBox.SQLGrid1RowChange(Sender: TObject);
begin
  if (SQLGrid1.Query.Eof) and (SQLGrid1.Query.bof) then
  begin
    SQLGrid1.visible:=false;
    BEdit.enabled:=false;
    BDel.enabled:=false;
  end
  else
  begin
    SQLGrid1.visible:=true;
    BEdit.enabled:=true;
    BDel.enabled:=true;
  end;
end;

procedure TFormAktBox.BAddClick(Sender: TObject);
var
  l:longint;
begin
  sql.StartTransaction;
  FormAkt:=TFormAkt.Create(Application) ;
  l:=FormAkt.AddRecord(0);
  FormAkt.Free;
  if l<>0 then
  begin
    sql.Commit;
    SQLGrid1.execTable(akttekview_str);
    SQLGrid1.LoadPoint('Ident',l);
  end else sql.Rollback;

end;

end.
