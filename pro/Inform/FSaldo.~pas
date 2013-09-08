unit FSaldo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst,DB,DBTables,TSQLCLS, Buttons, BMPBtn, ComCtrls,
  Grids, DBGrids, Menus, Sqlctrls, Lbsqlcmb,SqlGrid, ExtCtrls, OleServer,
  Word2000, toolbtn, Excel2000, DBClient;
type
  TFormSaldo = class(TForm)
    HeaderControl1: THeaderControl;
    btPrint: TBMPBtn;
    btCansel: TBMPBtn;
    Panel1: TPanel;
    cbPynkt: TLabelSQLComboBox;
    eFiltr: TToolbarButton;
    ToolbarButton1: TToolbarButton;
    DBGrid1: TDBGrid;
    Query1: TQuery;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    procedure btCanselClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ToolbarButton1Click(Sender: TObject);
    procedure btPrintClick(Sender: TObject);
    procedure eFiltrClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSaldo: TFormSaldo;

implementation
uses makerepp ;
{$R *.dfm}

procedure TFormSaldo.btCanselClick(Sender: TObject);
begin
close;
end;

procedure TFormSaldo.FormCreate(Sender: TObject);
begin
 Query1.Close;
 Query1.DatabaseName:=sql.DataBaseName;
 Query1.SQL.Clear;
 Query1.SQL.Add('select Ident,Name,Saldo from Clients where PersonType_Ident=1 '+
                ' order by Name');
 Query1.ExecSQL;
 query1.Open;
end;

procedure TFormSaldo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then btPrintClick(Sender)
end;

procedure TFormSaldo.ToolbarButton1Click(Sender: TObject);
begin
 Query1.Close;
 Query1.DatabaseName:=sql.DataBaseName;
 Query1.SQL.Clear;
 Query1.SQL.Add('select Ident,Name,Saldo from Clients where PersonType_Ident=1 '+
                ' order by Name');
 Query1.ExecSQL;
 query1.Open;
end;

procedure TFormSaldo.btPrintClick(Sender: TObject);
var
ID,n: integer;
Val: string;
begin
ID:=0;
val:='';

 Query1.DisableControls;
 Query1.First;

  while (not Query1.eof) do
  begin
  if not (Query1.FieldByName('Saldo').value=Query1.FieldByName('Saldo').Oldvalue) then
  begin
  ID:=Query1.FieldByName('Ident').asinteger;
  val:=Query1.FieldByName('Saldo').asstring;
  val:=trim(val);
  n:=0;
  if (pos(',',val)>0) then
   begin
    n:=pos(',',val);
    delete(val,n,1);
    insert('.',val,n);
   end;
   n:=0;
   while (pos(' ',val)>0) do
   begin
    n:=pos(' ',val);
    delete(val,n,1);
   end;

 if sql.UpdateString('Clients','Saldo='+sql.MakeStr(val),'Ident='+IntToStr(ID))<>0 then
   begin
      Application.MessageBox('Проверьте данные!','Ошибка!',0);
      exit
   end;    

  end;
  Query1.Next;
  end;
 Query1.EnableControls ;
 Query1.Close;
 Query1.DatabaseName:=sql.DataBaseName;
 Query1.SQL.Clear;
 Query1.SQL.Add('select Ident,Name,Saldo from Clients where PersonType_Ident=1 '+
                ' order by Name');
 Query1.ExecSQL;
 query1.Open;
end;

procedure TFormSaldo.eFiltrClick(Sender: TObject);
var CId:longInt;
    str:string;
begin
str:='';
CId:=cbPynkt.SQLComboBox.GetData;
if CID<>0 then
str:=' and Ident='+IntToStr(CID);
 Query1.Close;
 Query1.DatabaseName:=sql.DataBaseName;
 Query1.SQL.Clear;
 Query1.SQL.Add('select Ident,Name,Saldo from Clients where PersonType_Ident=1 '+
                str+' order by Name');
 Query1.ExecSQL;
 query1.Open;

end;

end.
