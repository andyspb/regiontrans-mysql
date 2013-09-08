unit BMPBtn;

interface
Uses SysUtils,StdCtrls,Classes,Buttons,Controls,ExtCtrls,
     Messages;

Type TBMPBtn=class(TBitBtn)
      protected
        fToolBarButton :Boolean;
        procedure WriteFileName(FN:TFileName);
        procedure WriteToolBarButton(status:Boolean);
      public
        Data:longint;
        FFileName:TFileName;
        constructor Create(AC:TComponent); override;
      published
        property ToolBarButton:Boolean read fToolBarButton write writeToolBarButton;
        property FileName:TFileName read FFileName write WriteFileName;
    end;

procedure Register;

implementation

Uses WinProcs;

procedure Register;
begin
  RegisterComponents('LanDocs',[TBMPBtn])
end;

constructor TBMPBtn.Create(AC:TComponent);
begin
  FFileName:='';
  inherited Create(AC);
end;

procedure TBMPBtn.WriteFileName(FN:TFileName);
var
  i:Byte;
begin
  FFileName:=FN;
  if FN<>'' then
    begin
      FFileName:=FFileName+#0;
      i:=Pos('.',FFileName);
      if i>0 then
        FfileName[i]:='_';
      try
        Glyph.handle:=LoadBitMap(HInstance,@FFileName[1])
      except
      end;
    end;
end;

procedure TBmpBtn.WriteToolBarButton(status:Boolean);
begin
  fToolBarButton:=status
end;


end.
