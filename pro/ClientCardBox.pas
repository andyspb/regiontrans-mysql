unit ClientCardBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, Buttons, BMPBtn, toolbtn, ToolWin, ComCtrls,
  Grids,tsqlcls, DBGrids,Tadjform, DBTables, SqlGrid, Provider, DBClient,
  DBLocal, DBLocalB;

type
  TCardBox = class(tadjustform)
    ToolBar1: TToolBar;
    eCard: TToolbarButton;
    eADD: TToolbarButton;
    eDelete: TToolbarButton;
    eExit: TToolbarButton;
    SQLGrid1: TSQLGrid;
    ToolbarButton1: TToolbarButton;
    procedure FormCreate(Sender: TObject);
    procedure eExitClick(Sender: TObject);
    procedure eADDClick(Sender: TObject);
    procedure eCardClick(Sender: TObject);
    procedure eDeleteClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ToolbarButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CardBox: TCardBox;
  Ident:longint;

implementation

uses ClientCardu;

{$R *.dfm}

procedure TCardBox.FormCreate(Sender: TObject);
begin
  fsection:='ClientCardBox'  ;
  SQLGrid1.exectable('ClientsAll');
  if  (SQLGrid1.query.Eof) and (SQLGrid1.query.Bof)  then
    begin
      eCard.Enabled:=false;
      eDelete.Enabled:=false;
      SQLGrid1.visible:=false;
    end
    else
    begin
      eCard.Enabled:=true;
      eDelete.Enabled:=true;
    SQLGrid1.visible:=true;
    end;
end;

procedure TCardBox.eExitClick(Sender: TObject);
begin
close;
end;

procedure TCardBox.eADDClick(Sender: TObject);
var l:longint;
begin
sql.StartTransaction;
//sql.ExeconeSQL('set @@autocommit=0;');
//sql.ExeconeSQL('START TRANSACTION;');
Card:=TCard.Create(Application) ;
l:=Card.AddRecord;
Card.Free;
if l<>0 then
begin
sql.Commit;
//sql.ExeconeSQL('COMMIT;');
SQLGrid1.exectable('ClientsAll');
SQLGrid1.LoadPoint('Ident',l);
end else sql.Rollback;
//    sql.ExeconeSQL('ROLLBACK;');
end;

procedure TCardBox.eCardClick(Sender: TObject);
var l:longint;
begin
Ident:=SQLGrid1.Query.FieldByName('Ident').Asinteger;
sql.StartTransaction;
Card:=TCard.Create(Application) ;
l:=Card.EditRecord(Ident);
Card.Free;
if l<>0 then
begin
sql.Commit;
SQLGrid1.exectable('ClientsAll');
SQLGrid1.LoadPoint('Ident',l);
end else sql.Rollback;

end;

procedure TCardBox.eDeleteClick(Sender: TObject);
begin
Sql.StartTransaction;
Ident:=SQLGrid1.Query.FieldByName('Ident').Asinteger;
if sql.execOneSql('Delete from Clients where Ident='+IntToStr(Ident))<>0 then
begin
application.MessageBox('Клиент не может быть удален так как используется в отправках!',
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
   SQLGrid1.exectable('ClientsAll');
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

procedure TCardBox.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then eCardClick(Sender)
end;

procedure TCardBox.ToolbarButton1Click(Sender: TObject);
var
  l,Id,Id1:longint;
begin
  Ident:=SQLGrid1.Query.FieldByName('Ident').Asinteger;
  Id:=0 ;
  l:=0;
  Id1:=0;
  Id:=sql.FindNextInteger('Ident','Clients','',MaxLongint);
  sql.StartTransaction;

  if sql.InsertSelect('Clients','Ident,Name,Acronym,FullName,Telephone,Fax,Email,INN,'+
                  'CalculatCount,Bank_Ident,OKONX,OKPO,InPerson,OnReason_Ident,'+
                  'ClientType_Ident,`Start`,DateUpd,Finish,City_Ident,Country_Ident,'+
                  'PersonType_Ident,Forwarder_Ident,Kredit,NameGood_Ident,KPP',
                  'Clients',IntToStr(Id)+',Name,Concat(Acronym ,'' Duble'')'+
                  ',FullName,Telephone,Fax,Email,INN,'+
                  'CalculatCount,Bank_Ident,OKONX,OKPO,InPerson,OnReason_Ident,'+
                  'ClientType_Ident,`Start`,DateUpd,Finish,City_Ident,Country_Ident,'+
                  'PersonType_Ident,Forwarder_Ident,Kredit,NameGood_Ident,KPP',
                  'Ident='+IntToStr(Ident))=0 then
  begin
    if  sql.InsertSelect('Contact','Name,Phone,Clients_Ident','Contact','Name,Phone,'+
                     IntToStr(Id),'Clients_Ident='+IntToStr(Ident))=0 then
    begin
      if  sql.InsertSelect('Address','AdrName,AddressType_Ident,Clients_Ident',
                        'Address','AdrName,AddressType_Ident,'+
                        IntToStr(Id),'Clients_Ident='+IntToStr(Ident)
                        +' and AddressType_Ident=2')=0 then
      begin
        if  sql.InsertSelect('Address','AdrName,AddressType_Ident,Clients_Ident',
                        'Address','AdrName,AddressType_Ident,'+
                        IntToStr(Id),'Clients_Ident='+IntToStr(Ident)
                        +' and AddressType_Ident=1')=0 then
        begin
        //Id1:=0;
          Id1:=sql.FindNextInteger('Ident','Contract','',MaxLongint);
          if  sql.InsertSelect('Contract','Ident,Number,`Start`,Finish,ContractType_Ident,Clients_Ident',
                        'Contract',IntToStr(Id1)+',Number,`Start`,Finish,ContractType_Ident,'+
                        IntToStr(Id),'Clients_Ident='+IntToStr(Ident)
                        +' and ContractType_Ident=2')=0 then
          begin
          //Id1:=0;
            Id1:=sql.FindNextInteger('Ident','Contract','',MaxLongint);
            if  sql.InsertSelect('Contract','Ident,Number,`Start`,Finish,ContractType_Ident,Clients_Ident',
                        'Contract',IntToStr(Id1)+',Number,`Start`,Finish,ContractType_Ident,'+
                        IntToStr(Id),'Clients_Ident='+IntToStr(Ident)
                        +' and ContractType_Ident=1')=0 then
            begin
              Card:=TCard.Create(Application) ;
              l:=Card.EditRecord(Id);
              Card.Free;
              if l<>0 then
              begin
                sql.Commit;
                SQLGrid1.exectable('ClientsAll');
                SQLGrid1.LoadPoint('Ident',l);
              end
              else
                sql.Rollback;
            end
            else
              sql.Rollback;
          end
          else
            sql.Rollback;
        end
        else
          sql.Rollback; //else
      end
      else
        sql.Rollback;// else
    end
    else
      sql.Rollback;// else
  end
  else
    sql.Rollback;// else
  SQLGrid1.exectable('ClientsAll');
  if l<>0 then
    SQLGrid1.LoadPoint('Ident',l)
  else
    SQLGrid1.LoadPoint('Ident',Ident);
end;
end.
