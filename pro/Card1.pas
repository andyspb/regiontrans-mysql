unit Card1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Sqlctrls,Tadjform, Lbledit,DBTables,tsqlcls, Buttons, BMPBtn,
  ExtCtrls, Lbdbedit, Lblint,Sequence, LblEdtDt, Lbsqlcmb, SqlGrid;
type
  TFormcard1 = class(Tadjustform)
    SQLGrid1: TSQLGrid;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Formcard1: TFormcard1;

implementation

{$R *.dfm}

procedure TFormcard1.FormCreate(Sender: TObject);
begin

fsection:='formCard'  ;
sqlGrid1.ExecTableCondOrder('Clients','','Ident');
end;

end.
