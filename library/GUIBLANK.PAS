Unit Guiblank;

Interface
Uses OperType;

Type TGUIBlank=class(TGUIObject)
      protected
        fID:longint;
        function GetID:longint;
      public
        constructor Create(dID:longint;dDisplayLabel:string);
        property ID:longint read GetID;
     end;

Implementation

function TGUIBlank.GetID:longint;
begin
  GetID:=fID
end;

constructor TGUIBlank.Create(dID:longint;dDisplayLabel:string);
begin
  DisplayLabel:=dDisplayLabel;
  fID:=dID
end;

End.