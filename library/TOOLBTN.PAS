unit toolbtn;

interface

uses
  WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons,BmpBtn;

type
  TToolbarButton = class(TBmpBtn)
  private
  protected
  public
  published
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tehno', [TToolbarButton]);
end;

end.
