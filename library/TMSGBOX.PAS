unit Tmsgbox;

interface
Uses SysUtils,StdCtrls,Classes,Buttons,Controls,ExtCtrls,Menus,
     Messages,TAdjForm;

Type TMessageBox=class(TAdjustForm)
      protected
        procedure WriteText(s:string);
        procedure WriteButtons(s:boolean);
        procedure WriteTitle(s:boolean);
      public
        fText,fButtons,fTitle:string;
      published
        property Text:String read fText write WriteText;
        property Buttons:String read fButtons write ReadButtons;
        property Title:String read fTitle write WriteTitle;
end;

procedure Register;

implementation

procedure TMessageBox.WriteText(s:string);
begin
  fText:=s;
end;

procedure TMessageBox.WriteButtons(s:string);
begin
  fButtons:=s;
end;

procedure TMessageBox.WriteTitle(s:string);
begin
  fTitle:=s;
  Caption:=s;
end;

procedure Register;
begin
  RegisterComponents('MyOwn',[TMessageBox])
end;


end.
