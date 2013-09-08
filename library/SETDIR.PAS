unit Setdir;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, FileCtrl;

type
  TSetDirForm = class(TForm)
    DirectoryListBox1: TDirectoryListBox;
    DriveComboBox1: TDriveComboBox;
  private
    { Private declarations }
  public
    procedure SetDir(s:String);
    function GetDir:String;
  end;

Function SetDirectory(Dir:String):String;


implementation

{$R *.DFM}
Function SetDirectory(Dir:String):String;
var
  Form: TSetDirForm;
begin
  Form:=TSetDirForm.Create(Application);
  Form.SetDir(dir);
  Form.ShowModal;
  SetDirectory:=Form.GetDir;
  Form.Free
end;

procedure TSetDirForm.SetDir(s:String);
begin
  try
    DirectoryListBox1.Directory:=s
  except
    SetDir('C:\')
  end
end;

function TSetDirForm.GetDir:String;
begin
  GetDir:=DirectoryListBox1.Directory
end;

end.
