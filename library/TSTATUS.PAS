unit tstatus;

interface

uses
  WinProcs,WinTypes, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TTehnoStatusBar = class(TObject)
  protected
    procedure OnShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
  public
    constructor Create(ac:TComponent);

  end;

procedure Register;

implementation

procedure TTehnoStatusBar.OnShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
begin
{  Panels.Items[0].Text:=HintStr;}
  CanShow:=FALSE;
end;

constructor TTehnoStatusBar.Create(ac:TComponent);
begin
  inherited Create;
{  Panels.Add;
  Application.OnShowHint:=OnShowHint;}
end;

procedure Register;
begin
{  RegisterComponents('Tehno', [TTehnoStatusBar]);}
end;

end.
