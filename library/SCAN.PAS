unit Scan;

interface
Uses
 WinTypes,SysUtils,ScanFrm,Forms;

function ScanToFile: String;

implementation

function ScanToFile: String;
{���������� True ��� ���������� ���������� }
var
  s : String;
  ScanForm: TScanForm;

begin
  ScanForm:=TScanForm.Create(Application);
  ScanForm.ShowModal;
  s:=ScanForm.FileName;
  ScanForm.Free;
  ScanToFile:=s
end;

end.
