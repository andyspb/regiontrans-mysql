unit entersql;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Sqlctrls, Lbledit, StdCtrls, Buttons, BMPBtn, toolbtn, tadjform,filtrfrm,
  LblMemo;

type
  TEnterSQLStr = class(TAdjustForm)
    btOk: TBMPBtn;
    btSave: TBMPBtn;
    btCancel: TBMPBtn;
    btCreate: TBMPBtn;
    LabelEdit1: TLabelMemo;
    procedure btCreateClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FilterFrm : TFilterForm;
  end;

implementation
uses filtrnam;

{$R *.DFM}

procedure TEnterSQLStr.btCreateClick(Sender: TObject);
begin
  LabelEdit1.Memo.Text:='';
  LabelEdit1.SetFocus;
end;

procedure TEnterSQLStr.btCancelClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TEnterSQLStr.btOkClick(Sender: TObject);
begin
  FilterFrm.FilterType:=Filtr_SQL;
  FilterFrm.FilterStr:=LabelEdit1.Memo.Text;
  FilterFrm.SaveFilter(FilterFrm.FilterName,FilterFrm.CurUserID);
  ModalResult:=mrOk;
end;

procedure TEnterSQLStr.btSaveClick(Sender: TObject);
begin
  if FiltrNam.ProceedDialog('Сохранить фильтр под именем','Сохранить','Сохранить',
                          FilterFrm.ViewName,true,FilterFrm,
                          aSave,FilterFrm.FilterName,FilterFrm.CurUserID)=mrOk then
    begin
      FilterFrm.FilterType:=Filtr_SQL;
      FilterFrm.FilterStr:=LabelEdit1.Memo.Text;
      FilterFrm.SaveFilter(FilterFrm.FilterName,FilterFrm.CurUserID);
//      Caption:='Фильтр '+#39+FilterName+#39;
    end;
end;

procedure TEnterSQLStr.FormShow(Sender: TObject);
begin
  if FilterFrm.FilterType=Filtr_SQL then
    LabelEdit1.Memo.Text:=FilterFrm.FilterStr
   else LabelEdit1.Memo.Text:='';
end;

end.
