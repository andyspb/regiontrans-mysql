unit FormCalc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, BMPBtn, Sqlctrls, Lbledit,
  ComCtrls,DB,TSQLCLS,DBTables,Tadjform, SqlGrid, OleServer,
  Word2000,Printers;

type
  TFormVCalc = class(TForm)
    HeaderControl1: THeaderControl;
    btOk: TBMPBtn;
    btCansel: TBMPBtn;
    eDl: TLabelEdit;
    eSh: TLabelEdit;
    eVs: TLabelEdit;
    eCount: TLabelEdit;
    eTV: TLabelEdit;
    eSumm: TLabelEdit;
    BMPBtn1: TBMPBtn;
    eV: TLabelEdit;
    procedure FormCreate(Sender: TObject);
    procedure eDlChange(Sender: TObject);
    procedure eShChange(Sender: TObject);
    procedure eVsChange(Sender: TObject);
    procedure eCountChange(Sender: TObject);
    procedure BMPBtn1Click(Sender: TObject);
    procedure btCanselClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    function TV:real;
   
  public
 procedure addrecord(var tr:boolean;var Str:string);
    { Public declarations }
  end;

var
  FormVCalc: TFormVCalc;
  test:  boolean=false;
  V:real;
  vt:real;
  ts:real;
  DL,SH,Vs,COn:real;
implementation
Uses SendStr;
{$R *.dfm}

procedure TFormVCalc.addrecord(var tr:boolean;var Str:string);
begin
  test:=tr;
  V:=0;
  vt:=0;
  DL:=0;
  SH:=0;
  Vs:=0;
  COn:=0;
  ts:=0;
  if showModal=mrOk then
  begin
    tr:=test;
    Str:=eV.Text;
  end
  else
    Str:=''
end;

procedure TFormVCalc.FormCreate(Sender: TObject);
begin
 //
end;

procedure TFormVCalc.eDlChange(Sender: TObject);
begin
  try
    Dl:=StrToFloat(trim(eDl.text));
    VT:=Tv;
    eTV.text:= StrTo00(FloatTostr(Tv));
    eSumm.text:= StrTo00(FloatTostr(TS));
  except
    application.MessageBox('Проверьте введенные данные!','Ошибка!',0);
    eDl.SetFocus;
    exit
  end;
end;

procedure TFormVCalc.eShChange(Sender: TObject);
begin
  try
    Sh:=StrToFloat(trim(eSh.text));
    VT:=Tv;
    eTV.text:= StrTo00(FloatTostr(Tv));
    eSumm.text:= StrTo00(FloatTostr(TS));
  except
    application.MessageBox('Проверьте введенные данные!','Ошибка!',0);
    eSh.SetFocus;
    exit
  end;
end;

procedure TFormVCalc.eVsChange(Sender: TObject);
begin
  try
    Vs:=StrToFloat(trim(eVs.text));
    VT:=Tv;
    eTV.text:= StrTo00(FloatTostr(Tv));
    eSumm.text:= StrTo00(FloatTostr(TS));
  except
    application.MessageBox('Проверьте введенные данные!','Ошибка!',0);
    eVs.SetFocus;
    exit
  end;
end;

procedure TFormVCalc.eCountChange(Sender: TObject);
begin
  try
    Con:=StrToFloat(trim(eCount.text));
    VT:=Tv;
    eTV.text:= StrTo00(FloatTostr(Tv));
    eSumm.text:= StrTo00(FloatTostr(TS));
  except
    application.MessageBox('Проверьте введенные данные!','Ошибка!',0);
    eCount.SetFocus;
    exit
  end;
end;

function TFormVCalc.TV:real;
begin
  if (Dl>0)and(Sh>0) and(Vs>0)and(Con>0)then
  begin
    TV:=Dl*Sh*Vs*Con;
    TS:=Dl+Sh+Vs;
    if TS>4 then test:=true;
  end
  else
  begin
    tv:=0;
    ts:=0;
  end;
end;

procedure TFormVCalc.BMPBtn1Click(Sender: TObject);
begin
  v:=V+VT;
  eV.text:= StrTo00(FloatTostr(v));
end;

procedure TFormVCalc.btCanselClick(Sender: TObject);
begin
  case
    Application.MessageBox('Все внесенные изменения не будут сохранены!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES:
      ModalResult:=mrCancel;
    IDNO:
      exit;
  end;
end;

procedure TFormVCalc.btOkClick(Sender: TObject);
begin
  if (Dl<>0)and(Sh<>0) and(Vs<>0)and(Con<>0)then
    ModalResult:=mrOk
  else
    application.MessageBox('Проверьте введенные данные!','Ошибка!',0);
end;

procedure TFormVCalc.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_Return then
    btOkClick(Sender)
end;

end.
