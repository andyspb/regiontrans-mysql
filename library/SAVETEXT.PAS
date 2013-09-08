
				unit SaveText;

{***************************************************************************}
{*}                                interface                              {*}
{***************************************************************************}

{ $Define InitOLE}{define it for OLE init/deinit for FR in (Un)LoadFineReader}

Uses Wait, FrCtrl, Files, Fr3Api, FrSetFrm, WinProcs, SysUtils, Controls,
     Loading, Forms, WinTypes, Classes;

const
	FineReaderUnloadAnyTime: boolean = True;
	FineReaderShowWindow:    boolean = True;
	FineReaderShowTextTypeDialog: boolean = True;
	FineReaderNeedEditing:   boolean = True;

var
	MainScanForm:	^TForm;
 
function SaveAsText(CountOfSourceFiles: word; const TargetFile,
	 ControlData:  string): boolean;

{***************************************************************************}
{*}                                implementation                         {*}
{***************************************************************************}
const
  EmptyPacketName = 'fine.dat';
  TempPacketName  = 'temp.pac';
var
  EmptyPacketPathName:  string;

{-----------------------------------------------------------------------------}
Procedure FineError(const Msg:  string);
var
   s:     string;
begin
   MessageBox(0, StrPCopy(@s, 'Ошибка ввода/вывода: ' + Msg),
      'Ошибка в процессе распознавания', $10);
end;

{-----------------------------------------------------------------------------}
function LoadFineReader: boolean;
var
   LoadForm:   TLoadForm;
begin
{$ifdef InitOLE}
   FineInit;
{$endif}

   Application.CreateForm(TLoadForm, LoadForm);
   LoadForm.Show;
   LoadForm.Repaint;
   if MainScanForm <> nil then MainScanForm^.Repaint;
   FineReaderLoaded := FineStandard_BeginSession;
   LoadForm.Close;
   LoadForm.Free;

   if not FineReaderLoaded then
     begin
	FineError('не могу загрузить систему "Fine Reader 3.0 Professional"');
	LoadFineReader := False;
	exit;
      end;

   LoadFineReader := True;
end;

{-----------------------------------------------------------------------------}
function UnLoadFineReader: boolean;
var
  Wait:  TWait;
begin
   if FineReaderUnloadAnyTime then
     begin
	Wait.Init;
	FineReaderLoaded := not FineStandard_EndSession(True);
	Wait.Done;

	if FineReaderLoaded then
	  begin
	    FineError('не могу выгрузить систему Fine Reader');
	    UnLoadFineReader := False;
	  end
	else
	  UnLoadFineReader := True;
     end;

{$ifdef InitOLE}
   FineQuit;
{$endif}
end;

{-----------------------------------------------------------------------------}
function WaitUserSaving: boolean;
var
   ControlForm:		TFineReaderControlForm;
begin
   if MainScanForm <> nil then MainScanForm^.Hide;
   ControlForm := TFineReaderControlForm.Create(Application);

{   ControlForm := TFineReaderControlForm.Create(nil);
   MessageBox(0, 'Show start', '', 0);
   if ControlForm = nil then MessageBox(0, 'Form = NIL', '', 0);
 }
   ControlForm.ShowModal;

{   MessageBox(0, 'Show done', '', 0);}

   WaitUserSaving := ControlForm.DialogResult;
   ControlForm.Free;
   if MainScanForm <> nil then
    begin
      MainScanForm^.Show;
      MainScanForm^.RePaint;
    end;
end;


{-----------------------------------------------------------------------------}
procedure DeleteTempFiles;
begin
  if not FineBatch_Remove then FineError('не могу удалить временные файлы');
end;


{-----------------------------------------------------------------------------}
function GetNumberOfValidPages: integer;
var
  i, Total:  integer;
  Count: integer;
  IsImage, IsText, IsEdited, IsExported, IsError,IsOpen,
	IsSelected:  wordbool;
  s:  string;
begin
(*  Count := 0;
  Total := FineBatch_GetNumberOfPages;
  for i := 1 to Total do
    begin
{
function FineBatch_GetPageInfo(
    PageNumber: integer;
var IsOpen:  wordbool;
    OpenBy:  pchar;   OpenByLen:  integer;
var IsImage, IsText, IsEdited, IsExported, IsError,
    IsSelected:  wordbool):  boolean;
}

     FineBatch_GetPageInfo(i, IsOpen,
	@s, 128,
	IsImage, IsText, IsEdited, IsExported, IsError,
	IsSelected);
     if IsText and not IsError then inc(Count);
    end;
  GetNumberOfValidPages := count;*)
  GetNumberOfValidPages := FineBatch_GetNumberOfPages;
end;

{-----------------------------------------------------------------------------}
function BatchAutoRecognize(CountOfSourceFiles: word;
       const TargetFile, Format: string):  boolean;
var
   i:		        integer;
   s, s2,
   TempPacketPathName:  string;
   b, SavingResult, NeedSaving: 	boolean;
   ControlForm:		TFineReaderControlForm;
begin
  BatchAutoRecognize := False;
  TempPacketPathName := GetWindowsTempDir + TempPacketName;
  DeleteFile(TargetFile);
  DeleteFile(TempPacketPathName);
  GroupDeleteFiles(GetWindowsTempDir + 'temp????.frf');
  GroupDeleteFiles(GetWindowsTempDir + 'temp????.box');

  if CountOfSourceFiles = 0 then exit;

  if FineBatch_IsOpen then
      if not FineBatch_Close then
	begin
	  FineError('не могу инициализировать систему Fine Reader');
	  exit;
	end;

   if not CopyFile(EmptyPacketPathName, TempPacketPathName) then
     begin
       FineError('не могу создать пакет');
       exit;
     end;

  if not FineBatch_Open(StrPCopy(@s, TempPacketPathName)) then
	begin
	  FineError('не могу открыть пакет');
	  exit;
	end;

  for i:=1 to CountOfSourceFiles do
     if not FineBatch_AddImageFile(StrPCopy(@s, GetSourceFileName(i)) ,
	 0, True) then
	begin
	  FineError('не найдены файлы данных');
	  DeleteTempFiles;
	  exit;
	end;


  if not FineBatch_Read(False, False, False) then
	begin
	  FineError('ошибка при доступе к файлам данных');
	  DeleteTempFiles;
	  exit;
	end;


  NeedSaving := True;
  if FineReaderNeedEditing then
     NeedSaving := WaitUserSaving;
 


  if NeedSaving then
   begin

     if FineBatch_GetNumberOfPages = 0 then
       begin
	 MessageBox(0, 'Все страницы были удалены - сохранение бессмысленно!',
	     'Сообщение', mb_Ok + mb_IconAsterisk);
	 DeleteTempFiles;
	 exit;
       end;

     if GetNumberOfValidPages = 0 then
       begin
	 MessageBox(0, 'Нет распознанных страниц ввиду ошибки - сохранение бессмысленно!',
	     'Сообщение', mb_Ok + mb_IconAsterisk);
	 DeleteTempFiles;
	 exit;
       end;

     if GetNumberOfValidPages <> FineBatch_GetNumberOfPages then
       begin
	if MessageBox(0, 'Из-за ошибки некоторые страницы не распознались. Сохранить остальные страницы?',
	   'Подтвердите', mb_YesNo + MB_ICONEXCLAMATION) <> idYes then
	     begin
	       DeleteTempFiles;
	       exit;
	     end;
       end;

     if FineBatch_GetNumberOfPages = 1 then
	begin
	   SavingResult := FineText_SaveAs(StrPCopy(@s, TargetFile), StrPCopy(@s2, Format));
	end
     else
	begin
	  b:= FineBatch_OpenPage(1); { switch to other page for saving current }
	  b:= FineBatch_OpenPage(2); { switch to other page for saving current }
	  SavingResult := FineBatch_Export(StrPCopy(@s, TargetFile), StrPCopy(@s2, Format),
	    False, False);
	end;

     if (not FileExists(TargetFile)) or (not SavingResult) then
       begin
	  FineError('ошибка записи выходного файла');
	  BatchAutoRecognize := False;
       end
     else
	  BatchAutoRecognize := True;
   end
  else
     BatchAutoRecognize := False;

  DeleteTempFiles;
end;


{-----------------------------------------------------------------------------}
function SaveAsText(CountOfSourceFiles: word; const TargetFile,
	 ControlData:  string): boolean;
begin
   SaveAsText := False;

   if not LoadFineReader then exit;

   if FineReaderShowTextTypeDialog then FineReaderSetup;

   ShowFineReaderWindow(FineReaderShowWindow);

   FineStandard_EndLogMode;
   FineBatch_SetDoNotStopOnErrors(True);
   DisableFineReaderControl;

   SaveAsText := BatchAutoRecognize(CountOfSourceFiles, TargetFile,ControlData);

   UnLoadFineReader;
end;

{-----------------------------------------------------------------------------}
begin
  GetDir(0, EmptyPacketPathName);
  EmptyPacketPathName := EmptyPacketPathName + '\' + EmptyPacketName;
end.
