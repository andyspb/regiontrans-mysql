unit Srsetup;

interface

uses View, SaveText, WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, Spin;

const
  ZoomIncrement:  integer = 2;

type
  TScanAndReadSetupForm = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    Bevel1: TBevel;
    GroupBox1: TGroupBox;
    SpinEditViewZoom: TSpinEdit;
    Label1: TLabel;
    GroupBoxFROptions: TGroupBox;
    CheckBoxFRUnloadAnyTime: TCheckBox;
    CheckBoxFRShowWindow: TCheckBox;
    CheckBoxFRShowTextTypeDialog: TCheckBox;
    CheckBoxFRNeedEditing: TCheckBox;
    CheckBoxCyclePagesViewing: TCheckBox;
    BitBtn1: TBitBtn;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}

procedure TScanAndReadSetupForm.OKBtnClick(Sender: TObject);
begin
  FineReaderUnloadAnyTime := CheckBoxFRUnloadAnyTime.Checked;
  FineReaderShowWindow := CheckBoxFRShowWindow.Checked;
  FineReaderShowTextTypeDialog := CheckBoxFRShowTextTypeDialog.Checked;
  FineReaderNeedEditing := CheckBoxFRNeedEditing.Checked;
  ZoomIncrement := SpinEditViewZoom.Value ;
  if FineReaderNeedEditing then FineReaderShowWindow := True;
  CyclePagesViewing := CheckBoxCyclePagesViewing.Checked;
end;



procedure TScanAndReadSetupForm.FormCreate(Sender: TObject);
begin
  CheckBoxFRUnloadAnyTime.Checked := FineReaderUnloadAnyTime;
  CheckBoxFRShowWindow.Checked :=  FineReaderShowWindow;
  CheckBoxFRShowTextTypeDialog.Checked := FineReaderShowTextTypeDialog;
  CheckBoxFRNeedEditing.Checked := FineReaderNeedEditing;
  SpinEditViewZoom.Value := ZoomIncrement;
  CheckBoxCyclePagesViewing.Checked := CyclePagesViewing;
end;

end.
