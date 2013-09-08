unit FAddEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Sqlctrls,Tadjform, Lbledit,DBTables,tsqlcls, Buttons, BMPBtn,
  ExtCtrls,sequence, LblEditMoney, Lbsqlcmb;

type
  TFormAE = class(TadjustForm)
    BtOk: TBMPBtn;
    BtCancel: TBMPBtn;
    Bevel1: TBevel;
    eField1: TLabelEdit;
    efield2: TLblEditMoney;
    cbCity: TLabelSQLComboBox;
    procedure btOkClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    function AddRecord(q:Tquery;tbname:string;fldcnt:integer):longint;
    function EditRecord(q:Tquery;tbname:string;fldcnt:integer):longint;
    { Public declarations }
  end;

var
  FormAE: TFormAE;
  TabQ :tquery;
  FieldCount :integer;
implementation

{$R *.DFM}
function TFormAE.AddRecord(q:Tquery;tbname:string;fldcnt:integer):longint;
var
 l:longint;
 ident:longint;
 StrFields:string;
 SecondFields:string;
 FirstField:string;
begin
  FieldCount := fldcnt;
  Ident := sql.selectInteger ('guiview', 'ID',
     'ViewName = ''' + tbname + '''');
  TabQ := sql.select ('guifield', 'DisplayLabel,FieldName',
         sql.condintequ ('viewid', ident),'ID');
 // tabQ.next;
 if FieldCount = 0 then
   begin
  //cbCity.caption := TabQ.Fields [0].Value ;
 // cbCity.maxlength :=  q.FieldByName(TabQ.Fields [1].Value).size;
 // FirstField:= TabQ.Fields [1].Value ;
  StrFields := 'City_Ident' ;
  eField2.visible := false;
  eField1.visible := false;
   end
 else
  begin
  cbCity.visible := false;
  efield1.caption := TabQ.Fields [0].Value ;
  efield1.maxlength :=  q.FieldByName(TabQ.Fields [1].Value).size;
  FirstField:= TabQ.Fields [1].Value ;
  StrFields := 'Ident,' +  FirstField ;

   if FieldCount > 1 then
    begin
     tabQ.next;
     efield2.caption := TabQ.Fields [0].Value ;
     efield2.maxlength :=  q.FieldByName(TabQ.Fields [1].Value).size;
     SecondFields:=  TabQ.Fields [1].Value;
     StrFields := StrFields + ',' +SecondFields
    end
   else
   eField2.visible := false;
  end;
if ShowModal=mrOk then
    begin


    if  fieldcount = 0 then
      begin
       if sql.InsertString(tbname,StrFields,IntToStr(cbCity.SQLComboBox.GetData))<>0 then
              begin
              Application.MessageBox('Такая запись уже есть в справочнике!','Ошибка',0);
              Addrecord:=0;
              end else
                  begin

                   Addrecord:=cbCity.SQLComboBox.GetData;
                  end;
      end
    else
    begin
        l:=sql.FindNextInteger('Ident',tbname,'',MaxLongint);
    if fieldcount = 1 then
      begin
        tabq:=sql.select(tbname,StrFields,FirstField+'='''+trim(eField1.Text)+'''','');
        if tabq.eof then
         begin
             if sql.InsertString(tbname,StrFields,IntToStr(l)+','+
              sql.MakeStr(trim(eField1.Text)) )<>0 then
              begin

              Addrecord:=0;
              end else
                  begin

                   Addrecord:=l;
                  end;
         end
       else
         begin
          Application.MessageBox('Такая запись уже есть в справочнике!','Ошибка',0);
          l:=tabq.FieldByName('Ident').asInteger;
         end;
      end
    else if fieldcount = 2 then
      begin
       tabq:=sql.select(tbname,StrFields,FirstField+'='''+trim(eField1.Text)+
                        ''' and '+SecondFields+'='''+trim(eField2.Text)+'''','');
       if tabq.eof then
         begin
     if sql.InsertString(tbname,StrFields,IntToStr(l)+','+
        sql.MakeStr(trim(eField1.Text))+','+
        sql.MakeStr(trim(eField2.Text)))<>0 then
              begin

              Addrecord:=0;
              end else
                  begin

                   Addrecord:=l;
                  end;
        end
         else
         begin
          Application.MessageBox('Такая запись уже есть в справочнике!','Ошибка',0);
          l:=tabq.FieldByName('Ident').asInteger;
         end;
      end;
    end ;
    end
  else
    AddRecord:=0 ;
 tabq.Free;
end;

function TFormAE.EditRecord(q:Tquery;tbname:string;fldcnt:integer):longint;
var
ID:longint;
Ident:longint;
StrField1:string;
StrField2:string;
begin
  FieldCount := fldcnt;
  ID:=q.FieldByName('Ident').AsInteger;
  Ident := sql.selectInteger ('guiview', 'ID',
     'ViewName = ''' + tbname + '''');
  TabQ := sql.select ('guifield', 'DisplayLabel,FieldName',
         sql.condintequ ('viewid', Ident),'ID');
//  tabQ.next;

  cbCity.visible := false;
  efield1.caption := TabQ.Fields [0].Value ;
  StrField1 :=  TabQ.Fields [1].Value ;
  eField1.text:=q.FieldByName(StrField1).AsString ;
  efield1.maxlength :=  q.FieldByName(StrField1).size;
  if FieldCount > 1 then
    begin
      tabQ.next;
      efield2.caption := TabQ.Fields [0].Value ;
      StrField2 := TabQ.Fields [1].Value ;
      if q.FieldByName(StrField2).AsString<>'' then
          eField2.text:= q.FieldByName(StrField2).AsString
          else eField2.text:= '0.00';
      efield2.maxlength := q.FieldByName(StrField2).size
    end
  else
    eField2.visible := false;

  if ShowModal=mrOk then
    begin
    
     if FieldCount = 1 then
       begin
       tabq:=sql.select(tbname,'Ident',strField1+'='''+trim(eField1.Text)+'''','');
        if tabq.eof then
         begin

        if sql.UpdateString(tbname,
           StrField1 + '=''' + trim(eField1.Text)+'''',
           sql.CondIntEqu('Ident',ID))<>0 then
              begin

              Editrecord:=0;
              end else
                  begin

                   Editrecord:=ID;
                  end;
        end
        else
         begin
          Application.MessageBox('Такая запись уже есть в справочнике!','Ошибка',0);
          ID:=tabq.FieldByName('Ident').asInteger;
         end;
      end
     else  if FieldCount = 2 then
       begin
       tabq:=sql.select(tbname,'Ident',strField1+'='''+trim(eField1.Text)+
                         ''' and '+StrField2+'='''+trim(eField2.Text)+'''','');
        if tabq.eof then
         begin

       if sql.UpdateString(tbname,
                          StrField1 + '=''' + trim(eField1.Text)+''','+
                          StrField2+ '='''+ trim(eField2.Text)+ '''',
                          sql.CondIntEqu('Ident',ID))<>0 then
              begin

              Editrecord:=0;
              end else
                  begin

                   Editrecord:=ID;
                  end;
         end
        else
         begin
          Application.MessageBox('Такая запись уже есть в справочнике!','Ошибка',0);
          ID:=tabq.FieldByName('Ident').asInteger;
         end;
       end ;    
    end
  else  EditRecord:=0;
 TabQ.Free;
end;

procedure TFormAE.btOkClick(Sender: TObject);
begin
if   fieldcount = 0 then
 begin
   if  cbCity.SQLComboBox.GetData = 0 then
    begin
      Application.MessageBox('Введите информацию!','Ошибка',0);
      cbCity.SQLComboBox.SetFocus;
    end
   else   ModalResult:=mrOk;
 end
else
 begin
  if  eField1.text = '' then
    begin
      Application.MessageBox('Введите информацию!','Ошибка',0);
      eField1.SetFocus
    end
  else if  ( eField2.text = '' )
          and  eField2.visible  then
    begin
      Application.MessageBox('Введите информацию!','Ошибка',0);
      eField2.SetFocus
    end
  else  begin
          ModalResult:=mrOk;
          eField2.text:=trim(eField2.text);
          eField1.text:=trim(eField1.text);
        end;
 end;
end;

procedure TFormAE.btCancelClick(Sender: TObject);
begin
case Application.MessageBox('Все внесенные изменения не будут сохранены!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES: ModalResult:=mrCancel;
    IDNO:exit;
end;
end;

procedure TFormAE.FormCreate(Sender: TObject);
begin
fSection:='ADDLDC';
eField2.EditMoney.font.Size:=10;
end;

procedure TFormAE.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key = VK_Return
  then btOKClick(Sender)
end;

end.
