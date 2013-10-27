; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "RegionTrans"
#define MyAppBuildNumber GetEnv("BUILD_NUMBER")

#if MyAppBuildNumber == ""
#define MyAppBuildNumber "1"
#endif

#define MyAppVersion "0.0.2." + MyAppBuildNumber
#define MyAppPublisher "RegionTrans"
#define MyAppURL "http://www.regionstrans.com/"
#define MyAppExeName "RegionTrans.exe"
#define MyAppId "{{bbbe3928-f757-411a-abd1-c14080cd4ea8}"
#define MyAppBelowVersion "0,6.1"

;--------------
#define BinarySourceDir "c:\working_dir\OZ\" + MyAppVersion + "\Oz-bin"
;--------------


[Setup]
; Disable set
DisableWelcomePage=yes
DisableDirPage=yes
DisableProgramGroupPage=yes
DisableReadyMemo=yes
DisableReadyPage=yes
DisableStartupPrompt=yes
DisableFinishedPage=yes

; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={#MyAppId}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
LicenseFile=extra_doc\license.txt
OutputDir=..\current\{#MyAppVersion}
OutputBaseFilename=OzSetup
Compression=lzma
SolidCompression=yes

CloseApplications=no

;[Languages]
;Name: "english"; MessagesFile: "compiler:Default.isl"
;Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

;[Tasks]
;Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
;Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: {#MyAppBelowVersion}

[Code]
var 
isVerySilent : boolean;

function InitializeSetup(): Boolean;
var
  j: Cardinal;
begin
  for j := 1 to ParamCount do
    begin
      if (CompareText(ParamStr(j),'/verysilent') = 0)  then
        isVerySilent := true
      else
        isVerySilent := false;   
    end; 
  if isVerySilent then
    Log ('VerySilent')
  else
    Log ('not VerySilent');
  Result := true;
end;
procedure CurStepChanged(CurStep: TSetupStep);
var
  CurFile: string;
  OldFile: string;
  isRenamed: boolean;
begin
  if CurStep = ssInstall then
  begin
    CurFile := ExpandConstant('{app}\oz.exe');
    if FileExists(CurFile) then
      begin
        OldFile := ExpandConstant('{app}\pre_{#MyAppVersion}.ver');  
        { if FileExists(OldFile) then 
          DeleteFile(OldFile);
        RenameFile(CurFile, OldFile);}
        if not FileExists(OldFile) then
          RenameFile(CurFile, OldFile);          
      end;
  end;
end;

[Files]
Source: "{#BinarySourceDir}\oz.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#BinarySourceDir}\{#MyAppVersion}\*"; DestDir: "{app}\{#MyAppVersion}"; Flags: ignoreversion recursesubdirs createallsubdirs onlyifdoesntexist
Source: "{#BinarySourceDir}\app_host.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#BinarySourceDir}\wow_helper.exe"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
;Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
;Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
;Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}" 

[Registry]
Root: HKCU; Subkey: "Software\{#MyAppName}\Update\Clients\{#MyAppId}"; ValueType: string; ValueName: "lang"; ValueData: "en"
Root: HKCU; Subkey: "Software\{#MyAppName}\Update\Clients\{#MyAppId}"; ValueType: string; ValueName: "name"; ValueData: {#MyAppName}
Root: HKCU; Subkey: "Software\{#MyAppName}\Update\Clients\{#MyAppId}"; ValueType: string; ValueName: "pv"; ValueData: {#MyAppVersion}
;Root: HKCU; Subkey: "Software\{#MyAppName}\Update\Clients\{#MyAppId}"; ValueType: string; ValueName: "version"; ValueData: {#MyAppVersion}

Root: HKCU; Subkey: "Software\Wow6432Node\{#MyAppName}\Update\Clients\{#MyAppId}"; ValueType: string; ValueName: "lang"; ValueData: "en"
Root: HKCU; Subkey: "Software\Wow6432Node\{#MyAppName}\Update\Clients\{#MyAppId}"; ValueType: string; ValueName: "name"; ValueData: {#MyAppName}
Root: HKCU; Subkey: "Software\Wow6432Node\{#MyAppName}\Update\Clients\{#MyAppId}"; ValueType: string; ValueName: "pv"; ValueData: {#MyAppVersion}
;Root: HKCU; Subkey: "Software\Wow6432Node\{#MyAppName}\Update\Clients\{#MyAppId}"; ValueType: string; ValueName: "version"; ValueData: {#MyAppVersion}
                               
Root: HKLM; Subkey: "Software\{#MyAppName}\Update\Clients\{#MyAppId}"; ValueType: string; ValueName: "lang"; ValueData: "en"
Root: HKLM; Subkey: "Software\{#MyAppName}\Update\Clients\{#MyAppId}"; ValueType: string; ValueName: "name"; ValueData: {#MyAppName}
Root: HKLM; Subkey: "Software\{#MyAppName}\Update\Clients\{#MyAppId}"; ValueType: string; ValueName: "pv"; ValueData: {#MyAppVersion}
;Root: HKLM; Subkey: "Software\{#MyAppName}\Update\Clients\{#MyAppId}"; ValueType: string; ValueName: "version"; ValueData: {#MyAppVersion}

Root: HKLM; Subkey: "Software\Wow6432Node\{#MyAppName}\Update\Clients\{#MyAppId}"; ValueType: string; ValueName: "lang"; ValueData: "en"
Root: HKLM; Subkey: "Software\Wow6432Node\{#MyAppName}\Update\Clients\{#MyAppId}"; ValueType: string; ValueName: "name"; ValueData: {#MyAppName}
Root: HKLM; Subkey: "Software\Wow6432Node\{#MyAppName}\Update\Clients\{#MyAppId}"; ValueType: string; ValueName: "pv"; ValueData: {#MyAppVersion}
;Root: HKLM; Subkey: "Software\Wow6432Node\{#MyAppName}\Update\Clients\{#MyAppId}"; ValueType: string; ValueName: "version"; ValueData: {#MyAppVersion}
          
[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
