unit FormAcceptorBoxu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SqlGrid, StdCtrls, Buttons,TSQLCLS,Tadjform, BMPBtn, toolbtn, ToolWin, ComCtrls;

type
  TFormAcceptorBox = class(TadjusTForm)
    ToolBar1: TToolBar;
    eCard: TToolbarButton;
    eADD: TToolbarButton;
    eDelete: TToolbarButton;
    eExit: TToolbarButton;
    SQLGrid1: TSQLGrid;
    procedure eADDClick(Sender: TObject);
    procedure eCardClick(Sender: TObject);
    procedure eExitClick(Sender: TObject);
    procedure eDeleteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAcceptorBox: TFormAcceptorBox;

implementation

uses FormAcceptoru;

{$R *.dfm}

procedure TFormAcceptorBox.eADDClick(Sender: TObject);
var l:longint;
begin
FormAcceptor:=TFormAcceptor.Create(Application) ;
l:=FormAcceptor.AddRecord;
FormAcceptor.Free;
sqlgrid1.Exec;
sqlGrid1.LoadPoint('Ident',l);
end;

procedure TFormAcceptorBox.eCardClick(Sender: TObject);
var l:longint;
    Idl:longint;
begin
  idl:=sqlgrid1.Query.FieldByName('Ident').AsInteger;
  FormAcceptor:=TFormAcceptor.Create(Application) ;
  l:=FormAcceptor.EditRecord(Idl);
  FormAcceptor.Free;
  sqlgrid1.Exec;
  sqlGrid1.LoadPoint('Ident',l);
end;

procedure TFormAcceptorBox.eExitClick(Sender: TObject);
begin
close;
end;

procedure TFormAcceptorBox.eDeleteClick(Sender: TObject);
var Ident:longint;
begin
 Ident:=sqlgrid1.Query.FieldByName('Ident').Asinteger;
 sql.execOneSql('delete from Acceptor where Ident='+IntToStr(Ident));
 sqlgrid1.Exec;
end;

procedure TFormAcceptorBox.FormCreate(Sender: TObject);
begin
fsection:='FormAcceptorsBox';
sqlGrid1.ExecTable('Acceptors');
end;

end.
