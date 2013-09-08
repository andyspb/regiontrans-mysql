unit Rdlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, Buttons, BMPBtn;

type
  TRdlg = class(TForm)
    Image1: TImage;
    Qst: TLabel;
    btOk: TBitBtn;
    btIgnore: TBitBtn;
    btCancel: TBitBtn;
    btYes: TBitBtn;
    btNo: TBitBtn;
    btRetry: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function RusMessageDlg(const Msg: string; AType: TMsgDlgType;
               AButtons: TMsgDlgButtons;   HelpCtx: Longint): Word;


implementation

{$R *.DFM}
  function RusMessageDlg(const Msg: string; AType: TMsgDlgType;
               AButtons: TMsgDlgButtons;   HelpCtx: Longint): Word;
  var
    mdf:TRDlg;
    n:integer;
    x,wd:integer;
  begin
    mdf:=TRDlg.Create(application);
    mdf.Qst.Caption:=Msg;
    n:=0;
    if mbOk in AButtons then begin mdf.btOk.Visible:=true;inc(n); end;
    if mbYes in AButtons then begin mdf.btYes.Visible:=true;inc(n); end;
    if mbNo in AButtons then begin mdf.btNo.Visible:=true;inc(n); end;
    if mbIgnore in AButtons then begin mdf.btIgnore.Visible:=true;inc(n); end;
    if mbRetry in AButtons then begin mdf.btRetry.Visible:=true;inc(n); end;
    if mbCancel in AButtons then begin mdf.btCancel.Visible:=true;inc(n); end;

    if n<2 then n:=3;
    wd:=mdf.btOk.Width+4;
    mdf.width:=n*wd+40;
    if mdf.Canvas.TextWidth(Msg)+80>mdf.width then mdf.width:=mdf.Canvas.TextWidth(Msg)+80;
    x:=mdf.width div 2-n*wd div 2;

    if mbOk in AButtons then begin mdf.btOk.Left:=x;inc(x,wd); end;
    if mbYes in AButtons then begin mdf.btYes.Left:=x;inc(x,wd); end;
    if mbNo in AButtons then begin mdf.btNo.Left:=x;inc(x,wd); end;
    if mbIgnore in AButtons then begin mdf.btIgnore.Left:=x;inc(x,wd); end;
    if mbRetry in AButtons then begin mdf.btRetry.Left:=x;inc(x,wd); end;
    if mbCancel in AButtons then begin mdf.btCancel.Left:=x;inc(x,wd); end;

    RusMessageDlg:=mdf.ShowModal;
    mdf.free;
  end;

end.
