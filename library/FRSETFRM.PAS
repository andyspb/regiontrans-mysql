unit Frsetfrm;

interface

uses  {Fr3Api,}
  WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls;

procedure FineReaderSetup;

type
  TFineReaderSetupForm = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    Bevel1: TBevel;
    ComboBoxLanguage: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    ComboBoxTextType: TComboBox;
    Label3: TLabel;
    ComboBoxPageFormatting: TComboBox;
    Label4: TLabel;
    ComboBoxTextLayOut: TComboBox;
    CheckBoxFastRecogn: TCheckBox;
    CheckBoxRectTable: TCheckBox;
    CheckBoxLinearTable: TCheckBox;
    CheckBoxDivTable: TCheckBox;
    CheckBoxKeepPictures: TCheckBox;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

var
  FineReaderSetupForm: TFineReaderSetupForm;


{-----------------------------------------------------------------------------}
procedure FineReaderSetup;
begin
  Application.CreateForm(TFineReaderSetupForm, FineReaderSetupForm);
  FineReaderSetupForm.ShowModal;
  FineReaderSetupForm.Free;
end;

{-----------------------------------------------------------------------------}
procedure TFineReaderSetupForm.OKBtnClick(Sender: TObject);
begin
{  SetLanguage(ComboBoxLanguage.ItemIndex);
  SetTextType(ComboBoxTextType.ItemIndex );
  SetPageFormatting(ComboBoxPageFormatting.ItemIndex );
  SetTextLayout( ComboBoxTextLayout.ItemIndex );

  FineStandard_SetFastRecognition( CheckBoxFastRecogn.Checked );
  FineStandard_SetRectangularTables( CheckBoxRectTable.Checked );
  FineStandard_SetLinearTables( CheckBoxLinearTable.Checked );
  FineStandard_SetDivideByBlackLines( CheckBoxDivTable.Checked );
  FineStandard_SetKeepPicturesInText( CheckBoxKeepPictures.Checked );}
end;

procedure TFineReaderSetupForm.FormCreate(Sender: TObject);
begin
{  ComboBoxLanguage.ItemIndex := GetLanguage;
  ComboBoxTextType.ItemIndex := GetTextType;
  ComboBoxPageFormatting.ItemIndex := GetPageFormatting;
  ComboBoxTextLayout.ItemIndex := GetTextLayout;

  CheckBoxFastRecogn.Checked := FineStandard_GetFastRecognition;
  CheckBoxRectTable.Checked := FineStandard_GetRectangularTables;
  CheckBoxLinearTable.Checked := FineStandard_GetLinearTables;
  CheckBoxDivTable.Checked := FineStandard_GetDivideByBlackLines;
  CheckBoxKeepPictures.Checked := FineStandard_GetKeepPicturesInText;}
end;

end.
