unit Inform;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls;

type
  TInformationForm = class(TForm)
    Info: TPanel;
  end;

procedure ShowInfoForm(txt:string);
procedure CloseInfoForm;

var InformationForm: TInformationForm;

implementation
{$R *.DFM}

procedure ShowInfoForm(txt:string);
begin
  if InformationForm<>NIL then
    CloseInfoForm;
  InformationForm:=TInformationForm.Create(Application);
  InformationForm.Width:=InformationForm.Canvas.TextWidth(txt)+30;
  InformationForm.Height:=InformationForm.Canvas.TextHeight(txt)+30;
  InformationForm.Info.Caption:=txt;
  InformationForm.Show;
  InformationForm.Refresh;
  InformationForm.Repaint;
end;

procedure CloseInfoForm;
begin
  if InformationForm<>NIL then
    begin
      InformationForm.Close;
      InformationForm.Free;
      InformationForm:=NIL
    end;
end;

begin
  InformationForm:= NIL
end.

