unit EditDate;

interface
Uses SysUtils,StdCtrls,Classes,Buttons,Controls,ExtCtrls,
     Messages,Forms,Mask;

Type TEditDate=class(TMaskEdit)
      protected
        procedure KillFocus(Sender:TObject);
      public
        fOnUserExit:TNotifyEvent;
        PrevDate:string;
        procedure SetNow;
        constructor Create(AC:TComponent); override;
      published
        property OnUserExit:TNotifyEvent read fOnUserExit write fOnUserExit;
    end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('MyOwn',[TEditDate])
end;

procedure TEditDate.SetNow;
begin
  Text:=DateToStr(Now);
end;

constructor TEditDate.Create(AC:TComponent);
begin
  inherited Create(AC);
  OnExit:=KillFocus;
  PrevDate:='  .  .    ';
  EditMask:='99.99.9999;1;_'
end;

procedure TEditDate.KillFocus(Sender:TObject);
begin
  Text:=EditText;
    try
      StrToDate(Text)
    except on t:EConvertError do
      begin
        if (Text<>'') and (Text<>'  .  .    ') then
          begin
            Text:=PrevDate;
          end
      end
    end;
  PrevDate:=Text;
  if Assigned(fOnUserExit) then
    fOnUserExit(Sender)

end;

end.
