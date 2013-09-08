				  unit Frbatfrm;

{****************************************************************************}
{*}			            Interface				   {*}
{****************************************************************************}

uses FineBat, Fr3Api,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls;

{ $define InterfaceMode} { define it for skipping FR }

function BatchAutoRecognizeDialog(const SourceFiles:  TStrings;
       const TargetFile, Format: string):  boolean;

type
  TFineBatchForm = class(TForm)
    Panel1: TPanel;
    BitBtnRecognize: TBitBtn;
    BitBtnExit: TBitBtn;
    GroupBoxFROptions: TGroupBox;
    CheckBoxFRUnloadAnyTime: TCheckBox;
    CheckBoxFRShowWindow: TCheckBox;
    CheckBoxFRShowTextTypeDialog: TCheckBox;
    procedure BitBtnRecognizeClick(Sender: TObject);
    procedure CheckBoxFRUnloadAnyTimeClick(Sender: TObject);
    procedure BitBtnExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBoxFRShowWindowClick(Sender: TObject);
    procedure CheckBoxFRShowTextTypeDialogClick(Sender: TObject);
  private
    { Private declarations }
      Source: ^TStrings;
      Target, OutFormat:  ^String;
      Result:  boolean;
  public
    { Public declarations }
  end;

var
  FineBatchForm: TFineBatchForm;

{****************************************************************************}
{*}		                 Implementation				   {*}
{****************************************************************************}

{$R *.DFM}


{-----------------------------------------------------------------------------}
function BatchAutoRecognizeDialog(const SourceFiles:  TStrings;
       const TargetFile, Format: string):  boolean;
begin
{!!!}{  Application.CreateForm(TFineBatchForm, FineBatchForm);}

  with FineBatchForm do
    begin
      Source := @SourceFiles;
      Target := @TargetFile;
      OutFormat := @Format;
      ShowModal;
      BatchAutoRecognizeDialog := Result;
{!!!}     { Free;}
    end;
end;


{-----------------------------------------------------------------------------}
procedure TFineBatchForm.BitBtnRecognizeClick(Sender: TObject);
begin
{$ifndef InterfaceMode}
   if not LoadFineReader then exit;

{   DisableFineReaderControl;}

   if FineReaderShowTextTypeDialog then FineReaderSetup;

   ShowFineReaderWindow(FineReaderShowWindow);

   Result := BatchAutoRecognize(Source^, Target^, OutFormat^);

   UnLoadFineReader;
{$else}
   Result := False;
{$endif}
{!!!} { Release;}
end;

procedure TFineBatchForm.CheckBoxFRUnloadAnyTimeClick(Sender: TObject);
begin
   if not Visible then exit;
   FineReaderUnloadAnyTime := not FineReaderUnloadAnyTime;
end;

procedure TFineBatchForm.CheckBoxFRShowWindowClick(Sender: TObject);
begin
  if not Visible then exit;
  FineReaderShowWindow := not FineReaderShowWindow;
end;

procedure TFineBatchForm.CheckBoxFRShowTextTypeDialogClick(
  Sender: TObject);
begin
  if not Visible then exit;
  FineReaderShowTextTypeDialog := not FineReaderShowTextTypeDialog;
end;

procedure TFineBatchForm.BitBtnExitClick(Sender: TObject);
begin
{!!!}  {Destroy;}
end;

procedure TFineBatchForm.FormCreate(Sender: TObject);
begin
  CheckBoxFRUnloadAnyTime.Checked := FineReaderUnloadAnyTime;
  CheckBoxFRShowWindow.Checked :=  FineReaderShowWindow;
  CheckBoxFRShowTextTypeDialog.Checked := FineReaderShowTextTypeDialog;
end;



end.
