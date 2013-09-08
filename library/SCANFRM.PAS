
				  unit ScanFrm;

{****************************************************************************}
{*}			            Interface				   {*}
{****************************************************************************}

{ $Define InitOLE} {define it for OLE init/deinit for FR in ScanAndReadDialog }
{ $Define UseExtension} {define it for using external extension}

uses Fr3Api, Saver, Files, View, FrSetFrm, SrSetup, ViewSet,
  TifFuncs,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, TAdjForm, StdCtrls, Buttons, BMPBtn, ExtCtrls, llo, lli;

function ScanAndReadDialog(SaveMode:  integer;
  const Extension, ControlData:  string): string;

procedure ScanAndReadSetupDialog;

type
  TScanForm = class(TAdjustForm)
    Panel1: TPanel;
    BMPBtnScan: TBMPBtn;
    BMPBtnClear: TBMPBtn;
    BMPBtnCancel: TBMPBtn;
    BMPBtnReScan: TBMPBtn;
    BMPBtnOptions: TBMPBtn;
    BMPBtnSave: TBMPBtn;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
    SpeedButton15: TSpeedButton;
    SpeedButton16: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton19: TSpeedButton;
    ImageWindow1: TImageWindow;
    BMPBtnDeleteCurrentPage: TBMPBtn;
    BMPBtnScanAndInsert: TBMPBtn;
    BMPBtnRenumber: TBMPBtn;
    procedure BMPBtnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BMPBtnScanClick(Sender: TObject);
    procedure BMPBtnSaveClick(Sender: TObject);
    procedure BMPBtnClearClick(Sender: TObject);
    procedure BMPBtnReScanClick(Sender: TObject);
    procedure BMPBtnOptionsClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure SpeedButton14Click(Sender: TObject);
    procedure SpeedButton15Click(Sender: TObject);
    procedure SpeedButton16Click(Sender: TObject);
    procedure SpeedButton19Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BMPBtnDeleteCurrentPageClick(Sender: TObject);
    procedure BMPBtnScanAndInsertClick(Sender: TObject);
  private
    ImageWasChanged:  boolean;
    procedure SaveImageChanges;
    procedure RewriteCaption;
    procedure ButtonsVisible;
    procedure DeleteTempFiles;
    procedure CriticalIOError;
  public
    SaveMode:  integer;
    Extension,
    ControlData,
    FileName : String;
  end;


{****************************************************************************}
{*}		                 Implementation				   {*}
{****************************************************************************}

{$R *.DFM}



const
  TitlePart1 = 'Всего страниц в документе : ';
  TitlePart2 = '  Текущая страница : ';

  DefaultResultExtension = '.tmp';
  DefaultResultName = 'scanread';

var
  ScanForm:   TScanForm;

{-----------------------------------------------------------------------------}
procedure TScanForm.CriticalIOError;
begin
    MessageBox(0, 'Критическая ошибка ввода/вывода', 'Ошибка', mb_IconStop);
    DeleteTempFiles;
    FileName := '';
    Close
end;

function DeletePage(n: word): boolean;
begin
{$B+}
   DeletePage :=
       DeleteFile(GetTIFFileName(n)) and
       DeleteFile(GetOriginTIFFileName(n)) and
       DeleteFile(GetSourceFileName(n))
{$B-}
end;

function RenamePage(Old, New: word): boolean;
begin
{$B-}
   DeletePage(New);

   RenamePage :=
      RenameFile(GetTIFFileName(Old), GetTIFFileName(New)) and
      RenameFile(GetOriginTIFFileName(Old), GetOriginTIFFileName(New)) and
      RenameFile(GetSourceFileName(Old), GetSourceFileName(New));
end;

function xchgPages(Page1, Page2:  word): boolean;
begin
   xchgPages := False;
   if not RenamePage(Page1, TotalPage+1) then exit;
   if not RenamePage(Page2, Page1) then exit;
   if not RenamePage(TotalPage+1, Page2) then exit;
   xchgPages := True;
end;

{-----------------------------------------------------------------------------}
function Exclamation(Msg:  PChar): boolean;
begin
   Exclamation := MessageBox(0, Msg,
      'Подтвердите', mb_YesNo + MB_ICONEXCLAMATION) = idYes;
end;

{-----------------------------------------------------------------------------}
function PageScaned(n:Word):Boolean;
begin
  PageScaned:=TIFF_ImageExests(GetTIFFileName(n))
end;

{-----------------------------------------------------------------------------}
procedure TScanForm.SaveImageChanges;
begin
  if (not ImageWasChanged) or (TotalPage = 0) then exit;
  ImageWindow1.ImageInWindow.SaveAs( GetTIFFileName(CurrentPage),
      LLI_DISK_TIF, LLI_DISK_COMPRESS_CCITTG4);
  ImageWindow1.ImageInWindow.SaveAs( GetSourceFileName(CurrentPage),
      SourceFormat, SourceCompress);

  ImageWasChanged := False
end;

{-----------------------------------------------------------------------------}
function ScanAndReadDialog(SaveMode:  integer;
  const Extension, ControlData:  string): string;
var
  Control:  string;
begin

  if not ((SaveMode = smText) or (SaveMode = smImage)) then
    begin
      MessageBox(0, 'Выбранный Вами формат не поддерживается блоком сканирования/распознавания!',
	  'Ошибка', mb_Ok + mb_IconStop);
      ScanAndReadDialog := '';
      exit;
    end;



  Control := ControlData;
  if not isCorrectControlData(SaveMode, Control) then
    begin
      MessageBox(0, 'Неверные управляющие данные для модуля сканирования/распознавания.'+
       'Вам требуется помощь системного администратора',
	  'Ошибка', mb_Ok + mb_IconStop);
      ScanAndReadDialog := '';
      exit;
    end;

{$Ifdef InitOLE}
  FineInit;
{$endif}
  ScanForm:=TScanForm.Create(Application);
  ScanForm.SaveMode := SaveMode;
  ScanForm.ControlData := Control;
  ScanForm.Extension := Extension;
  ScanForm.ShowModal;
  ScanAndReadDialog:=ScanForm.FileName;
  ScanForm.Free;
{$Ifdef InitOLE}
  FineQuit;
{$endif}
end;

{-----------------------------------------------------------------------------}
procedure TScanForm.RewriteCaption;
begin
  caption := TitlePart1+intToStr(TotalPage)+TitlePart2+intToStr(CurrentPage)
end;


procedure TScanForm.BMPBtnCancelClick(Sender: TObject);
begin
  if TotalPage <> 0 then
   begin
    if not Exclamation('Вы действительно хотите выйти без сохранения?')
       then exit;
   end
  else
    if not Exclamation('Вы действительно хотите выйти из блока сканирования/распознавания?')
       then exit;
  close;
end;

procedure TScanForm.FormCreate(Sender: TObject);
begin
  Section:='ScanDoc';
  TotalPage:=0;
  CurrentPage:=0;
  RewriteCaption;
  ButtonsVisible;
  ImageWindow:=@ImageWindow1;
  ImageWindow1.ImageInWindow.Clear;
  ImageWindow1.ZoomIncrement := ZoomIncrement;
end;

procedure TScanForm.BMPBtnScanClick(Sender: TObject);
begin { Сканировать страницу }
  SaveImageChanges;
  ImageWindow1.Scan;
{!!!}  ImageWindow1.ImageInWindow.SaveAs( GetTIFFileName(TotalPage+1), LLI_DISK_TIF, LLI_DISK_COMPRESS_CCITTG4);
  ImageWindow1.ImageInWindow.SaveAs( GetSourceFileName(TotalPage+1),
      SourceFormat, SourceCompress);
  FileCopy(GetOriginTIFFileName(TotalPage+1),GetTIFFileName(TotalPage+1));
  if PageScaned(TotalPage+1) then
  begin
    inc(TotalPage);
    inc(CurrentPage);
    RewriteCaption;
    ButtonsVisible
  end;
  ImageWindow1.SelectionEnabled:=True
end;

procedure TScanForm.BMPBtnReScanClick(Sender: TObject);
begin   { ПереСканирование страницу }
  SaveImageChanges;

  if not Exclamation('Вы действительно хотите пересканировать текущую страницу?')
    then exit;

  ImageWindow1.Scan;
  ImageWindow1.ImageInWindow.SaveAs( GetTIFFileName(CurrentPage), LLI_DISK_TIF, LLI_DISK_COMPRESS_CCITTG4);
  ImageWindow1.ImageInWindow.SaveAs( GetSourceFileName(TotalPage+1),
      SourceFormat, SourceCompress);
end;


procedure TScanForm.BMPBtnSaveClick(Sender: TObject);
begin
   SaveImageChanges;
   FileName := GetWindowsTempDir + DefaultResultName +
{$ifdef UseExtension}
     Extension;
{$else}
     DefaultResultExtension;
{$endif}
   SaveText.MainScanForm := @Self;

{   if SaveMode = smText then WindowState := wsMinimized;}
   if not SaveProcessing(SaveMode, TotalPage, FileName, ControlData)
     then FileName := '';
   close;
end;

procedure TScanForm.BMPBtnClearClick(Sender: TObject);
begin
  if not Exclamation('Вы действительно хотите удалить все страницы?')
       then exit;

  TotalPage:=0;
  CurrentPage:=0;
  ButtonsVisible;
  ImageWindow1.SelectionEnabled:=False;
  ImageWindow1.ImageInWindow.Clear;
  RewriteCaption;
  ImageWindow1.RePaint;
end;


procedure ScanAndReadSetupDialog;
var
  SetUpForm:TScanAndReadSetupForm;
begin
  SetupForm:=TScanAndReadSetupForm.Create(Application);
  SetupForm.ShowModal;
  SetUpForm.Free
end;



procedure TScanForm.BMPBtnOptionsClick(Sender: TObject);
begin
  ScanAndReadSetupDialog;
  ImageWindow1.ZoomIncrement:=ZoomIncrement;
end;

procedure TScanForm.SpeedButton2Click(Sender: TObject);
begin
  ImageWindow1.FitToWidth
end;

procedure TScanForm.SpeedButton3Click(Sender: TObject);
begin
  ImageWindow1.FitToHeight
end;


procedure TScanForm.SpeedButton4Click(Sender: TObject);
begin
  ImageWindow1.FitInWindow
end;

procedure TScanForm.SpeedButton6Click(Sender: TObject);
begin
  ImageWasChanged := True;
  ImageWindow1.RotateRight
end;

procedure TScanForm.SpeedButton7Click(Sender: TObject);
begin
  ImageWasChanged := True;
  ImageWindow1.RotateLeft
end;

procedure TScanForm.SpeedButton8Click(Sender: TObject);
begin
  ImageWasChanged := True;
  ImageWindow1.RotateInvert
end;

procedure TScanForm.SpeedButton9Click(Sender: TObject);
begin
  ImageWindow1.FlipHorizontal;
  ImageWasChanged := True;
end;

procedure TScanForm.SpeedButton10Click(Sender: TObject);
begin
  ImageWasChanged := True;
  ImageWindow1.FlipVertical
end;

procedure TScanForm.SpeedButton11Click(Sender: TObject);
begin
  ImageWindow1.Crop;
  ImageWindow1.ImageInWindow.Display(TRUE);
  ImageWasChanged := True;
end;

procedure TScanForm.SpeedButton12Click(Sender: TObject);
begin
{  ImageWindow1.Zoom10In}
  ImageWindow1.ZoomInByIncrement
end;

procedure TScanForm.SpeedButton13Click(Sender: TObject);
begin
{   ImageWindow1.Zoom10Out}
  ImageWindow1.ZoomOutByIncrement
end;

procedure TScanForm.SpeedButton14Click(Sender: TObject);
var
  SetUpForm:TViewSetUpForm;
begin
  SetupForm := TViewSetUpForm.Create(Application);
  SetUpForm.ZoomIncrement:= ZoomIncrement;
  SetupForm.SpinEdit1.Value := ZoomIncrement;
  if SetUpForm.ShowModal=mrOk then
    begin
     ImageWindow1.ZoomIncrement:=SetUpForm.ZoomIncrement;
     ZoomIncrement:=SetUpForm.ZoomIncrement;
    end;
  SetUpForm.Free;
end;

procedure TScanForm.SpeedButton15Click(Sender: TObject);
begin
{  ImageWindow1.ImageInWindow.SaveAs( GetTIFFileName(CurrentPage), LLI_DISK_TIF, LLI_DISK_COMPRESS_CCITTG4);}
  SaveImageChanges;
  PrevPage;
  RewriteCaption
end;

procedure TScanForm.SpeedButton16Click(Sender: TObject);
begin
{  ImageWindow1.ImageInWindow.SaveAs( GetTIFFileName(CurrentPage), LLI_DISK_TIF, LLI_DISK_COMPRESS_CCITTG4);}
  SaveImageChanges;
  NextPage;
  RewriteCaption
end;

procedure TScanForm.SpeedButton19Click(Sender: TObject);
begin
  ImageWindow1.ImageOperations;
  ImageWindow1.ImageInWindow.Display(TRUE)
end;

procedure TScanForm.SpeedButton5Click(Sender: TObject);
begin
  ImageWasChanged := False;
  ImageWindow1.ImageInWindow.Clear;
  ImageWindow1.LoadFile(GetOriginTIFFileName(CurrentPage), LLI_DISK_TIF, 0);
  ImageWindow1.ImageInWindow.Display(TRUE)
end;

procedure TScanForm.ButtonsVisible;
var
  State : Boolean;
begin
  state:=TotalPage>0;
  BMPBtnReScan.Enabled:=State;
  BMPBtnClear.Enabled:=State;
  BMPBtnSave.Enabled:=State;
  BMPBtnDeleteCurrentPage.Enabled:=State;
  BMPBtnScanAndInsert.Enabled := State;
{  BMPBtnRenumber.Enabled := State;}
  SpeedButton2.Enabled:=State;
  SpeedButton3.Enabled:=State;
  SpeedButton4.Enabled:=State;
  SpeedButton5.Enabled:=State;
  SpeedButton6.Enabled:=State;
  SpeedButton7.Enabled:=State;
  SpeedButton8.Enabled:=State;
  SpeedButton9.Enabled:=State;
  SpeedButton10.Enabled:=State;
  SpeedButton11.Enabled:=State;
  SpeedButton12.Enabled:=State;
  SpeedButton13.Enabled:=State;
  SpeedButton14.Enabled:=State;
  SpeedButton19.Enabled:=State;

  state := (TotalPage>1) and state;
  SpeedButton15.Enabled:=State; {Up}
  SpeedButton16.Enabled:=State; {Down}
end;


procedure TScanForm.FormDestroy(Sender: TObject);
var
   s:  string;
begin
   DeleteTempFiles;
end;

procedure TScanForm.DeleteTempFiles;
var
   i:  word;
begin
   for i := 1 to TotalPage do DeletePage(i)
end;


procedure TScanForm.BMPBtnDeleteCurrentPageClick(Sender: TObject);
var
   i:   word;
begin
   if not Exclamation('Вы действительно хотите удалить текущую страницу?')
      then exit;

   DeletePage(CurrentPage);

   for i := CurrentPage+1 to TotalPage do
    begin
       if not RenamePage(i, i-1) then
	 begin
	    CriticalIOError;
	    exit;
	 end;
    end;

   Dec(TotalPage);
   if TotalPage = 0 then
    begin
      ImageWindow1.SelectionEnabled:=False;
      CurrentPage:=0;
      ImageWindow1.ImageInWindow.Clear;
      ImageWindow1.RePaint;
    end
   else
    begin
      if CurrentPage > TotalPage then CurrentPage := TotalPage;
      ShowPage(CurrentPage);
    end;

   RewriteCaption;
   ButtonsVisible;
end;


procedure TScanForm.BMPBtnScanAndInsertClick(Sender: TObject);
const
  NewPageNumber = High(Integer);
var
  i:  word;
begin
   if not Exclamation('Вы действительно хотите отсканировать новую страницу и вставить ее вместо текущей?')
      then exit;


  DeletePage(NewPageNumber);

{!!! - no control of result }  ImageWindow1.Scan;
{!!!}  ImageWindow1.ImageInWindow.SaveAs( GetTIFFileName(NewPageNumber),
                LLI_DISK_TIF, LLI_DISK_COMPRESS_CCITTG4);
  ImageWindow1.ImageInWindow.SaveAs( GetSourceFileName(NewPageNumber),
  SourceFormat, SourceCompress);
  FileCopy(GetOriginTIFFileName(NewPageNumber),GetTIFFileName(NewPageNumber));

  if not PageScaned(NewPageNumber) then exit;

  for i:=TotalPage downto CurrentPage do
    if not RenamePage(i, i+1) then
      begin
	CriticalIOError;
	exit;
      end;

  if not RenamePage(NewPageNumber, CurrentPage) then
     begin
	CriticalIOError;
	exit;
     end;

  Inc(TotalPage);
  ShowPage(CurrentPage);
  RewriteCaption;
  ButtonsVisible;
  ImageWindow1.SelectionEnabled:=True;
end;

end.
