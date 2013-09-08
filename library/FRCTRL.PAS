unit Frctrl;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, BMPBtn, ExtCtrls;

type
  TFineReaderControlForm = class(TForm)
    Panel1: TPanel;
    BMPBtnCancel: TBitBtn;
    BMPBtnSave: TBitBtn;
    BMPBtnHelp: TBitBtn;
    procedure BMPBtnSaveClick(Sender: TObject);
    procedure BMPBtnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    DialogResult:	 boolean;
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TFineReaderControlForm.BMPBtnSaveClick(Sender: TObject);
begin
  DialogResult := True;
  Close;
end;

procedure TFineReaderControlForm.BMPBtnCancelClick(Sender: TObject);
begin
  if MessageBox(Handle, 'Вы действительно хотите выйти без сохранения?',
      'Подтвердите', mb_YesNo + MB_ICONEXCLAMATION) <> idYes then exit;
  DialogResult := False;
  Close;
end;

end.
