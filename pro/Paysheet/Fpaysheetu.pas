unit Fpaysheetu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, LblEdtDt, Lbledit, Sqlctrls, Lbsqlcmb, StdCtrls, Buttons,
  BMPBtn, DB,TSQLCLS,DBTables,SqlGrid,Tadjform,ComCtrls, EntrySec;

type
  TFormPaySheet = class(TForm)
    HeaderControl1: THeaderControl;
    btSave: TBMPBtn;
    btCansel: TBMPBtn;
    cbClient: TLabelSQLComboBox;
    eNumber: TLabelEdit;
    LabelEditDate1: TLabelEditDate;
    eSum: TLabelEdit;
    procedure btCanselClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
  Function AddRecord:longint;
  Function EditRecord(q:TQuery):longint;
    { Public declarations }
  end;

var
  FormPaySheet: TFormPaySheet;

implementation

{$R *.dfm}


Function TFormPaySheet.AddRecord:longint;
var
  fields: string;
  str: string;
  l  : longint;
  thread : TInsertThread;
begin
  LabelEditDate1.Text:=FormatDateTime('dd.mm.yyyy',now);
  if showModal=mrOk then
  begin
    l:=sql.FindNextInteger('Ident',EntrySec.paysheet_table {'PaySheet'},'',MaxLongint);
    str:=IntToStr(L);
    str:=str+','+Sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.Text)));
    if  eSum.text<>'' then
      str:=str+','+sql.MakeStr(eSum.text)
    else
      str:=str+',NULL';
    if cbClient.GetData<>0 then
      str:=str+','+IntToStr(cbClient.GetData)
    else
      str:=str+',NULL';
    if  eNumber.text<>'' then
      str:=str+','+sql.MakeStr(eNumber.text)
    else
      str:=str+',NULL';
    fields:='Ident,Dat,Sum,Client_Ident,Number';
    if (sql.InsertString(EntrySec.paysheet_table {'PaySheet'},fields,str) <> 0) then
      AddRecord:=0
    else
      begin
        // seccess
        Addrecord:=l;
        // update other table
        thread:= TInsertThread.Create(True, EntrySec.paysheet_table_other, fields, str);
        thread.Resume();
      end
  end
  else
    AddRecord:=0;
end;

Function TFormPaySheet.EditRecord(q:TQuery):longint;
var
  Id: longint;
  str: string;
  key: string;
  thread: TUpdateThread;
begin
  eNumber.setValue(q);
  eSum.Text:=q.fieldByName('Sum').AsString;
  cbClient.setValue(q);
  LabelEditDate1.text:=FormatDateTime('dd.mm.yyyy',q.fieldByName('Dat').AsDateTime);
  Id:=q.fieldByName('Ident').AsInteger;
  if showModal=mrOk then
  begin
    str:='Dat='+Sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.Text)));
    if  eSum.text<>'' then
      str:=str+',Sum='+sql.MakeStr(eSum.text)
    else
      str:=str+',Sum=NULL';
    if cbClient.GetData<>0 then
      str:=str+',Client_Ident='+IntToStr(cbClient.GetData)
    else
      str:=str+',Client_Ident=NULL';
    if eNumber.text<>'' then
      str:=str+',Number='+sql.MakeStr(eNumber.text)
    else
      str:=str+',Number=NULL';
    key:='Ident='+IntToStr(Id);
    if (sql.UpdateString(EntrySec.paysheet_table {'PaySheet'}, str, key) <> 0) then
      EditRecord:=0
    else
    begin
      // success
      EditRecord:=ID;
      // update other table
      thread:= TUpdateThread.Create(True, EntrySec.paysheet_table_other, str, key);
      thread.Resume();
    end
  end
  else
    EditRecord:=Id;
end;

procedure TFormPaySheet.btCanselClick(Sender: TObject);
begin
case Application.MessageBox('Все внесенные изменения не будут сохранены!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES: ModalResult:=mrCancel;
    IDNO:exit;
end;
end;

procedure TFormPaySheet.btSaveClick(Sender: TObject);
begin
  if  cbClient.GetData=0 then
  begin
    Application.MessageBox('Выберите заказчика!','Ошибка!',0);
    cbClient.SetFocus;
    exit;
  end;
  ModalResult:=mrOk;
end;

procedure TFormPaySheet.FormCreate(Sender: TObject);
begin
 //cbClient.SQLComboBox.Sorted:=true;
end;

procedure TFormPaySheet.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_Return then
    btSaveClick(Sender)
end;

end.
