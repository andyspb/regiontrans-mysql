; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "RegionTrans"
#define MyAppBuildNumber GetEnv("BUILD_NUMBER")

#if MyAppBuildNumber == ""
#define MyAppBuildNumber "2"
#endif

#define MyAppVersion "0.0.2." + MyAppBuildNumber
#define MyAppPublisher "RegionTrans"
#define MyAppURL "http://www.regionstrans.com/"
#define MyAppExeName "RegionTrans.exe"
#define MyAppId "{{bbbe3928-f757-411a-abd1-c14080cd4ea8}"
#define MyAppBelowVersion "0.0.1"

;--------------
#define BinarySourceDir "d:\work\regiontrans-mysql\"
;--------------

[LangOptions]
LanguageName=Russian
LanguageID=$0419
LanguageCodePage=1251

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
LicenseFile=license.txt
OutputDir=output\{#MyAppVersion}
OutputBaseFilename=RegionTransInstall
Compression=lzma
SolidCompression=yes

CloseApplications=no

[Languages]
;Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

;[Tasks]
;Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
;Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: {#MyAppBelowVersion}

[Files]
Source: "{#BinarySourceDir}\pro\RegionTrans.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#BinarySourceDir}\pro\Package1.bpl"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#BinarySourceDir}\pro\*.ini"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#BinarySourceDir}\pro\*.rtf"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commonprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}" 
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"

[Registry]
          
[Run]

