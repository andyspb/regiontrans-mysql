unit FNation;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, BMPBtn, Sqlctrls, Lbsqlcmb, Lbsqlist, Lbsqloln, Grids,
  DBGrids,Tadjform, DB,DBTables,tsqlcls, SqlGrid, ExtCtrls ;


type
  TFormNat = class(Tadjustform)
    SQLGrid1: TSQLGrid;
    BAdd: TBMPBtn;
    BEdit: TBMPBtn;
    BDel: TBMPBtn;
    BCorr: TBMPBtn;
    btClosed: TBMPBtn;
    btSelect: TBMPBtn;
    BtHst: TBMPBtn;
    BtValue: TBMPBtn;
    BExit: TBMPBtn;
    procedure Showlist(s:string;fldcnt:integer;check:String);
    procedure BExitClick(Sender: TObject);
    procedure BDelClick(Sender: TObject);
    procedure BAddClick(Sender: TObject);
    procedure BEditClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure BCorrClick(Sender: TObject);
    procedure SQLGrid1RowChange(Sender: TObject);
    procedure btClosedClick(Sender: TObject);
    procedure BtHstClick(Sender: TObject);
    procedure btSelectClick(Sender: TObject);
    procedure BtValueClick(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  FormNat: TFormNat;
  TbName : string;
  TabQ:Tquery;
  FieldCount:integer;
  UpdatePerm :boolean;
  ID:longint;
implementation

uses FAddEdit, CardBank, ContractCard, FormAcceptoru, FCity;

{$R *.DFM}

procedure TFormNat.Showlist(s:string;fldcnt:integer;check:String);
var
Ident:longint;
field1: string;
field2: string;
begin
  SQLGrid1.Section := s ;
  TbName := s ; 
  if s='Banks' then TbName :='Bank';
  if s='CityView' then TbName :='City';
  if s='Acceptors' then tbName:='Acceptor';
  if s='Contacts' then tbName:='Contact';
  if s='CitySklad1View' then tbName:='CitySklad1';
  if s='CitySklad2View' then tbName:='CitySklad2';
  FieldCount:=fldcnt;
  Ident := sql.selectInteger ('guiview', 'ID',
     'ViewName = ''' + s + '''');
  FormNat.Caption := sql.SelectString('guiview',
     'DisplayLabel', sql.condintequ ('ID', ident));
  if FieldCount=0 then     {Закрываем возможность редактировать города по складам}
     BEdit.enabled := false
   else BEdit.enabled := true ;
  SQLGrid1.ExecTable(s);
  if  (SQLGrid1.Query.eof) and(SQLGrid1.Query.bof) then
    begin
     BEdit.enabled := false ;
     BDel.enabled := false ;  
    end;
  FormNat.ShowModal;
end;

procedure TFormNat.BExitClick(Sender: TObject);
begin
       close;
{       WorkPeriodChangeTerkom;}
end;

procedure TFormNat.BDelClick(Sender: TObject);
begin
sql.StartTransaction;
  if (TbName = 'City') or
     (TbName = 'Country') or
     (TbName = 'Bank') or
     (TbName = 'Contact') or
     (TbName = 'Supplier') or
     (TbName = 'Forwarder') or
     (TbName = 'NameGood') or
     (TbName = 'PackType') or
     (TbName = 'PackTariff') or
     (TbName = 'OnReason') or
     (TbName = 'Acceptor')then
        begin
           SQLGrid1.SaveNextPoint('Ident');
          if sql.Delete( TbName, sql.CondIntEqu('Ident',
                SQLGrid1.FieldByName('Ident').AsInteger))<>0 then
                begin
                Application.MessageBox('Запись не подлежит удалению!','Ошибка',0);

                sql.Rollback;
                end else
                case Application.MessageBox('Удалить!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES: sql.commit;
    IDNO: sql.rollback;
                end ;
         end

  else  begin
       if (TbName = 'CitySklad2') or
        (TbName = 'CitySklad1') then
        begin
          if sql.Delete( TbName, sql.CondIntEqu('City_Ident',
                SQLGrid1.FieldByName('Ident').AsInteger))<>0 then
                begin
                Application.MessageBox('Запись не подлежит удалению!','Ошибка',0);

                sql.Rollback;
                end else
                case Application.MessageBox('Удалить!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES: sql.commit;
    IDNO: sql.rollback;
                end ;
         end

         else  begin
        Application.MessageBox('Запись не подлежит удалению!','Ошибка',0);
        sql.Rollback;
              end;
        end;
 SQLGrid1.Exec;
  if  (SQLGrid1.Query.eof) and (SQLGrid1.Query.bof)then
    begin
     SQLGrid1.Visible:=false;
     BEdit.enabled := false ;
     BDel.enabled := false ;
     BCorr.enabled:=false;
     btClosed.enabled:=false;
     btHst.enabled:=false;
     
    end;
end;

procedure TFormNat.BAddClick(Sender: TObject);
var l:longint;
begin
 if FieldCount <> 3 then
 begin
 sql.StartTransaction;
  FormAE:=TFormAE.Create(Application);
  l:=FormAE.AddRecord (SQLGrid1.Query,tbname,FieldCount);
  if l<>0 then
    begin
     sql.commit;
      SQLGrid1.Exec;
      SQLGrid1.Visible:=true;
      SQLGrid1.LoadPoint('Ident',l);
      BEdit.enabled := true ;
      BDel.enabled := true ;  
    end else sql.Rollback;
  FormAE.Free
  end
  else if tbName='Bank' then
        begin
         sql.StartTransaction;
         FormCardBank:=TFormCardBank.Create(Application) ;
         l:=FormCardBank.AddRecord;
         if l<>0 then
         begin
         sql.Commit;
          SQLGrid1.Exec;
          SQLGrid1.Visible:=true;
          SQLGrid1.LoadPoint('Ident',l);
          BEdit.enabled := true ;
          BDel.enabled := true ;

         end else sql.Rollback;
         FormCardBank.Free;
        end
  else if tbName='Acceptor' then
         begin
          sql.StartTransaction;
          FormAcceptor:=TFormAcceptor.Create(Application) ;
          l:=FormAcceptor.AddRecord;
         if l<>0 then
         begin
          sql.Commit;
          SQLGrid1.Exec;
          SQLGrid1.Visible:=true;
          SQLGrid1.LoadPoint('Ident',l);
          BEdit.enabled := true ;
          BDel.enabled := true ;

         end else sql.Rollback;
          FormAcceptor.Free;
         end
 else if tbName='Contact' then
         begin
          sql.StartTransaction;
          FormAcceptor:=TFormAcceptor.Create(Application) ;
          l:=FormAcceptor.AddRecord;
         if l<>0 then
         begin
          sql.Commit;
          SQLGrid1.Exec;
          SQLGrid1.Visible:=true;
          SQLGrid1.LoadPoint('Ident',l);
          BEdit.enabled := true ;
          BDel.enabled := true ;

         end else sql.Rollback;
          FormAcceptor.Free;
         end
 else if tbName='City' then
  begin
  sql.StartTransaction;
  CityForm:=TCityForm.Create(Application) ;
  l:=CityForm.AddRecord;
  if l<>0 then
         begin
          sql.commit;
          SQLGrid1.Exec;
          SQLGrid1.Visible:=true;
          SQLGrid1.LoadPoint('Ident',l);
          BEdit.enabled := true ;
          BDel.enabled := true ;
         end else sql.Rollback;
   CityForm.Free;
  end;
end;

procedure TFormNat.BEditClick(Sender: TObject);
var
L:longint;
nameCap,str:String; 
begin
 if ((not SQLGrid1.Query.eof) or (not SQLGrid1.Query.bof)) and (FieldCount<>0) then
begin
 // if sql.LockRecord(tbname,'Ident',
    // SQLGrid1.FieldByName('Ident').AsString,'')=0 then
   // begin
     if FieldCount <> 3 then
     begin
                   sql.StartTransaction;
                   FormAE:=TFormAE.Create(Application);
                   SQLGrid1.SavePoint('Ident');
                   l:=FormAE.EditRecord(SQLGrid1.Query,tbname,FieldCount);
                   if l<>0 then
                     begin
                     sql.Commit;
                     SQLGrid1.Exec;
                     end else sql.Rollback;
                   FormAE.Free
    end

    else if tbName='Bank' then
        begin
          l:=sqlgrid1.FieldByName('Ident').Asinteger;
          SQLGrid1.SavePoint('Ident');
           sql.StartTransaction;
          FormCardBank:=TFormCardBank.Create(Application) ;
          l:=FormCardBank.EditRecord(l);
           if l<>0 then
           begin
                     sql.Commit;
                     SQLGrid1.Exec;
           end else sql.Rollback;
          FormCardBank.Free;
        end
    else if tbName='Acceptor' then
        begin
         l:=sqlgrid1.Query.FieldByName('Ident').AsInteger;
         SQLGrid1.SavePoint('Ident');
          sql.StartTransaction;
         FormAcceptor:=TFormAcceptor.Create(Application) ;
         l:=FormAcceptor.EditRecord(l);
         if l<>0 then
                  begin
                     sql.Commit;
                     SQLGrid1.Exec;
                  end else sql.Rollback;
         FormAcceptor.Free;
        end
     else if tbName='Contact' then
        begin
         l:=sqlgrid1.Query.FieldByName('Ident').AsInteger;
         SQLGrid1.SavePoint('Ident');
          sql.StartTransaction;
         FormAcceptor:=TFormAcceptor.Create(Application) ;
         l:=FormAcceptor.EditRecord(l);
         if l<>0 then
                  begin
                     sql.Commit;
                     SQLGrid1.Exec;
                  end else sql.Rollback;
         FormAcceptor.Free;
        end
    else if tbName='City' then
        begin
         l:=sqlgrid1.Query.FieldByName('Ident').AsInteger;
         SQLGrid1.SavePoint('Ident');
          sql.StartTransaction;
         CityForm:=TCityForm.Create(Application) ;
         l:=CityForm.EditRecord(l);
         if l<>0 then
                  begin
                     sql.Commit;
                     SQLGrid1.Exec;
                  end else sql.Rollback;   
         CityForm.Free;
        end
  // end
end
end;





procedure TFormNat.FormShow(Sender: TObject);
begin
    BExit.SetFocus;
end;

procedure TFormNat.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_Return
  then BEditClick(Sender)
end;

procedure TFormNat.FormCreate(Sender: TObject);
begin
fsection:='nation';
end;

procedure TFormNat.BCorrClick(Sender: TObject);
begin
{if (TbName = 'PAYTYPE') or
   (TbName = 'PROFITTYPEVIEW') or
   (TbName = 'SALTAXFZP') or
   (TbName = 'SALESN')then
   begin
     FormProfTypeBase:=TFormProfTypeBase.Create(Application);
     FormProfTypeBase.ShowList(ID,tbname);
     FormProfTypeBase.free;
   end
else
begin
 if (not SQLGrid1.Query.eof) and   UpdatePerm then
    if sql.LockRecord(tbname,'Ident',
       SQLGrid1.FieldByName('Ident').AsString,'')=0 then
    begin
     FormCorr:=TFormCorr.Create(Application);
     if FormCorr.ShowList (TbName,ID)=1 then
         sql.commit
     else sql.rollback;
     FormCorr.Free ;
    end
 end;   }
end;

procedure TFormNat.SQLGrid1RowChange(Sender: TObject);
begin
  ID:=SQLGrid1.Query.FieldByName('Ident').AsInteger;  
end;

procedure TFormNat.btClosedClick(Sender: TObject);
var
 Ident:longInt;
begin
  {Ident:=SQLGrid1.Query.FieldByName('Ident').asinteger;
  SQLGrid1.SavePoint('Ident');
  if TbName ='INCCLASS' then
  begin
   if sql.LockRecord('INCCLASS','Ident', IntToStr(Ident),'')=0 then
    begin
      sql.UpdateString('INCCLASS','Finish='''+FormatDateTime('yyyy.mm.dd',now)
         + '''', sql.CondIntEqu('Ident',Ident));
      sql.commit
    end
  end
  else
  begin
   if sql.LockRecord('INCREASE','Ident', IntToStr(Ident),'')=0 then
    begin
      sql.UpdateString('INCREASE','Finish='''+FormatDateTime('yyyy.mm.dd',now)
         + '''', sql.CondIntEqu('Ident',Ident));
      sql.UpdateString('INCREASEHST','Finish='''+FormatDateTime('yyyy.mm.dd', now)
      + '''','(Increase_Ident='+ IntToStr(Ident)+  ')and(Finish is NULL)');
      sql.commit ;
    end
  end ;
  SQLGrid1.Exec; }
end;

procedure TFormNat.BtHstClick(Sender: TObject);
begin
  {FormRateHst:=TFormRateHst.Create(Application);
  FormRateHst.ShowList('INCREASE',ID);
  FormRateHst.Free;  }
end;

procedure TFormNat.btSelectClick(Sender: TObject);
var
BankIdent:Integer;
begin
 { BankIdent:=SQLGrid1.query.FieldByName ('Ident').AsInteger;
  FADPay.BankStr(BankIdent);
  ModalResult:=mrOk;   }
end;

procedure TFormNat.BtValueClick(Sender: TObject);
begin
 { FormPrivTypeValue:=TFormPrivTypeValue.Create(Application);
  FormPrivTypeValue.ShowList(SQLGrid1.query.FieldByName ('Ident').AsInteger,'SALESNTAX',SQLGrid1.query.FieldByName ('Name').AsString);
  FormPrivTypeValue.Free;   }
end;

end.
