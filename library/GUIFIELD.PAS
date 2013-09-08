Unit GUIField;

Interface
Uses OperType;
Type TGUIField=class(TGUIObject)
      private
      public
        ViewFieldName:TName;
        FieldType:TGUIFieldType;
        Alignment:integer;
        SymbolCount:integer;
        constructor Create(dPhysicalName,dDisplayLabel,dViewFieldName:string;dFieldType:TGUIFieldType;
                           Al,SC:longint);
     end;

Implementation

constructor TGUIField.Create(dPhysicalName,dDisplayLabel,dViewFieldName:string;dFieldType:TGUIFieldType;
                             Al,SC:longint);
begin
  FieldType:=dFieldType;
  PhysicalName:=dPhysicalName;
  DisplayLabel:=dDisplayLabel;
  ViewFieldName:=dViewFieldName;
  SymbolCount:=SC;
  Alignment:=Al-1;
end;

End.