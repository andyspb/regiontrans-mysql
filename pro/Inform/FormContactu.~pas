unit FormContactu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  Lbledit, Lbsqlcmb, Sqlctrls, LblEdtDt, StdCtrls, Buttons,SqlGrid,
  DB,TSQLCLS,DBTables,Tadjform,  BMPBtn, ComCtrls, OleServer, Word2000;

type
  TFormContact = class(TForm)
    HeaderControl1: THeaderControl;
    btPrint: TBMPBtn;
    btCansel: TBMPBtn;
    cbClient: TLabelSQLComboBox;
    eName: TLabelEdit;
    ePhone: TLabelEdit;
    procedure btCanselClick(Sender: TObject);
  private
    { Private declarations }
  public
  Function AddRecord:longint;
 
    { Public declarations }
  end;

var
  FormContact: TFormContact;

implementation

{$R *.dfm}

Function TFormContact.AddRecord:longint;
begin
if showModal=mrOk then   

end;

procedure TFormContact.btCanselClick(Sender: TObject);
begin
case Application.MessageBox('Все внесенные изменения не будут сохранены!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES: ModalResult:=mrCancel;
    IDNO:exit;
end;
end;

end.
