unit Commtype;

interface
Uses
  Classes,DB;

const
FilterCaption  ='Фильтр без названия';

Type

TFilterFormMode=(fmSaveAs,fmOpen);
TCurrField=(cfMemo,cfNotMemo);
Tstring30=string[30];

PFieldDescr=^TFieldDescr;
TFieldDescr=record
  Name,Lbl     : String[40];
  Index,Width  : Integer;
  Checked,
  Sorted,
  QuickView    : Boolean;
  ControlType  : Integer;
  FieldType    : Integer;
  Alignment    : Integer;
  Field        : TField;
end;

PStringList=^TStringList;

implementation

end.
