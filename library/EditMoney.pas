unit EditMoney;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;
type
  TEditMoney = class(TCustomMemo)
  private
  flag_point:boolean;
  after_point:integer;
  procedure SetText;
  procedure Check_point;
  protected
    property wordwrap default False;
    property Text;
    procedure WMSETFOCUS(var message:TWMSETFOCUS);message WM_SETFOCUS;
    procedure WMKILLFOCUS(var message:TWMKILLFOCUS);message WM_KILLFOCUS;
  public
    { Public declarations }
    constructor Create(AC:TComponent);override;
    procedure KeyPress(var Key: Char);override;
    procedure KeyDown(var Key: Word; Shift: TShiftState);override;
  published
    { Published declarations }
    property alignment default taRightJustify;{}
    property Height default 21;
    property Width default 121;
    property SelStart;
    property SelText;
    property SelLength;
    property AutoSelect;
    property Caption;
    property Color;
    property Ctl3D;
    property Cursor;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property ParentColor;
    property ReadOnly;
    property MaxLength;
    property ShowHint;
    property TabOrder;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnChange;
    property OnDragDrop;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    procedure SetMoney(money:integer);
    function GetMoney:integer;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('asd', [TEditMoney]);
end;

constructor TEditMoney.Create(AC:TComponent);
begin
inherited Create(AC);
wordwrap:=False;
alignment:=taRightJustify;{}
height:=21;
width:=121;
text:='0.00';
flag_point:=false;
after_point:=0;
end;

procedure TEditMoney.Check_point;
var l : integer;
begin

     l:=length(text);
 if l<>0 then
 begin
     if text[l]='.' then
        begin
             flag_point:=true;
             after_point:=0;
        end else
     if l>1 then
        if text[l-1]='.' then
        begin
             flag_point:=true;
             after_point:=1;
        end else
     if l>2 then
        if text[l-2]='.' then
        begin
        flag_point:=true;
        after_point:=2;
        end else
        begin
             flag_point:=false;
             after_point:=0;
        end;
 end else  begin
             flag_point:=false;
             after_point:=0;
            end;
end;

procedure TEditMoney.SetText;
var vsp_text,vsp_text2:string;
begin
     vsp_text:=text;
     vsp_text2:='';
     if flag_point then
        begin
        if vsp_text[1]='.' then
           vsp_text2:='0';
           vsp_text2:=vsp_text2+vsp_text;
        if after_point=0 then
           begin
           vsp_text2:=vsp_text2+'00';
           after_point:=2;
           text:=vsp_text2;
           end else
        if after_point=1 then
           begin
           vsp_text2:=vsp_text2+'0';
           after_point:=2;
           text:=vsp_text2;
           end;
        end        else
        begin
        if text='' then
           text:='0.00'
           else
        if (text<>'0.00') and (pos('.',text)=0) then
           begin
           vsp_text2:=vsp_text+'.00';
           flag_point:=true;
           after_point:=2;
           text:=vsp_text2;
           end;

        end;
end;

procedure TEditMoney.WMSETFOCUS(var message:TWMSETFOCUS);
begin
     inherited;
     SelectAll;
end;

procedure TEditMoney.WMKILLFOCUS(var message:TWMKILLFOCUS);
begin
     inherited;
     Check_point;
     SetText;
end;

procedure TEditMoney.KeyPress(var Key: Char);
var vsp_text:string;
    vsp_text2:string;
    i       :integer;
begin
     Check_point;
     case key of
     '1','2','3','4','5','6','7','8','9','0'
         :begin
          if text='0.00' then
             begin
             text:='';
             flag_point:=false;
             after_point:=0;
             exit;
             end;{}
         if SelText='' then
         begin
          vsp_text:=text;
          if (text<>'')and(vsp_text[1]='0')and(SelStart=1)and(length(text)<5)and(flag_point)then
             begin
             vsp_text[1]:=key;
             text:=vsp_text;
             key:=#0;
             exit;
             end;
          if (after_point=2)and
             ((SelStart=length(text))or(SelStart=length(text)-1)
              or(SelStart=length(text)-2)) then
              begin
              key:=#0;
              exit;
              end;
          if (flag_point)and(after_point=0)and
             ((SelStart=length(text))or(SelStart=length(text)-1)
              or(SelStart=length(text)-2)) then
              begin
              after_point:=after_point+1;
              end else
          if (flag_point)and(after_point=1)and
             ((SelStart=length(text))or(SelStart=length(text)-1)) then
              begin
              after_point:=after_point+1;
              end;
         end else
         begin
              vsp_text:=text;
              if (SelText[SelLength]='.')or(SelText[SelLength-1]='.')or
                 (SelText[SelLength-2]='.') then
                 begin
                 flag_point:=false;
                 after_point:=0;
                 exit;
                 end else
              if (flag_point) then
              begin
                 if (SelStart=length(text)-1)then
                    after_point:=after_point-1;
                 if (SelStart=length(text)-2)then
                    if SelLength=2 then
                       after_point:=0 else
                       after_point:=1;
              end;
         after_point:=after_point+1;
         end;
         end;
     #8 :begin
         if text='0.00' then
         begin
             text:='';
             flag_point:=false;
             after_point:=0;
             exit;
         end;{}
         if SelText='' then
         begin
              vsp_text:=text;
              if (vsp_text<>'')and(SelStart<>0) then
              begin
              if vsp_text[SelStart]='.' then
                 begin
                 flag_point:=false;
                 after_point:=0;
                 end;
              end;
              if (after_point=2)and((SelStart=length(text))or(SelStart=length(text)-1))then
                 after_point:=after_point-1 else
              if (after_point=1)and(SelStart=length(text))then
                 after_point:=after_point-1;
              if (flag_point)and(SelStart=1)and(length(text)<5)and(vsp_text[2]='.')then
                 begin
                 vsp_text:=text;
                 vsp_text[1]:='0';
                 text:=vsp_text;
                 end;
         end else
         begin
              vsp_text:=text;
              if (SelText[SelLength]='.')or(SelText[SelLength-1]='.')or
                 (SelText[SelLength-2]='.') then
                 begin
                 flag_point:=false;
                 after_point:=0;
                 end else
              if (flag_point) then
              begin
                 if (SelStart=length(text)-1)then
                    after_point:=after_point-1;
                 if (SelStart=length(text)-2)then
                    if SelLength=2 then
                       after_point:=0 else
                       after_point:=1;
              end;
              if (SelStart=0)and(text[SelStart+SelLength+1]='.') then
                    begin
                         vsp_text2:='0';
                         for i:=SelStart+SelLength+1 to length(vsp_text) do
                             vsp_text2:=vsp_text2+vsp_text[i];
                         text:=vsp_text2;
                         key:=#0;
                    end;

         end;
         end;
     '.':begin
         if (text='0.00')or(text='') then
             begin
             text:='';
             flag_point:=false;
             after_point:=0;
             key:=#0;
             exit;
             end;{}
{         if text='' then
            begin
            key:=#0;
            exit;
            end;{}
         if SelText='' then
         begin
         if not(flag_point)then
            begin
            if (SelStart<length(text)-2)then
               begin
               key:=#0;
               exit;
               end else
               begin
               if SelStart=length(text)-1 then
                  after_point:=1 else
               if SelStart=length(text)-2 then
                  after_point:=2;
               end;
            end;
         if (flag_point) then
            begin
            key:=#0;
            exit;
            end;
         flag_point:=true;
         end else
         begin
         vsp_text:=text;
         if SelText=Text then
            begin
            text:='0.';
            flag_point:=true;
            after_point:=0;
            SelStart:=2;
            key:=#0;
            exit;
            end;
         if flag_point then
         begin
         if (SelText[SelLength-1]='.')then
             after_point:=after_point-1 else
         if (SelText[SelLength-2]='.')then
             after_point:=0 else
         if (SelStart=length(text)-1)or(SelStart=length(text)-2) then
            begin
                 key:=#0;
            end else
            key:=#0;
         end
                       else
         begin
              if (SelStart+SelLength)<length(text)-2 then
                 key:=#0                             else
                 begin
                 if (SelStart+SelLength)=length(text)then
                    begin
                    flag_point:=true;
                    after_point:=0;
                    end else
                 if (SelStart+SelLength)=length(text)-1 then
                    begin
                    flag_point:=true;
                    after_point:=1;
                    end else
                 if (SelStart+SelLength)=length(text)-2 then
                    begin
                    flag_point:=true;
                    after_point:=0;
                    end;
                 end;
         end;
         end;
         end
     else
         begin
              key:=#0;
         end;
     end;
end;{}

procedure TEditMoney.KeyDown(var Key: Word; Shift: TShiftState);
var vsp_text:string;
    vsp_text2:string;
    i:integer;
begin
     Check_point;
     case Chr(key) of
     '.':begin
        { if text='0.00' then
         begin
             text:='';
             flag_point:=false;
             after_point:=0;
             exit;
         end;{}
         if SelText='' then
         begin
              vsp_text:=text;
              if (vsp_text<>'')and(SelStart<>length(text)) then
              begin
              if vsp_text[SelStart+1]='.' then
                 begin
                 flag_point:=false;
                 after_point:=0;
                 end;
              end;
              if (after_point=2)and((SelStart=length(text)-1)or(SelStart=length(text)-2))then
                 after_point:=after_point-1 else
              if (after_point=1)and(SelStart=length(text)-1)then
                 after_point:=after_point-1;
              if (flag_point)and(SelStart=0)and(length(text)<5)and(vsp_text[2]='.')then
                 begin
                 vsp_text:=text;
                 vsp_text[1]:='0';
                 text:=vsp_text;
                 end;
         end else
         begin
              vsp_text:=text;
              if (SelText[SelLength]='.')or(SelText[SelLength-1]='.')or
                 (SelText[SelLength-2]='.') then
                 begin
                 flag_point:=false;
                 after_point:=0;
                 end else
              if (flag_point) then
              begin
                 if (SelStart=length(text)-1)then
                    after_point:=after_point-1;
                 if (SelStart=length(text)-2)then
                    if SelLength=2 then
                       after_point:=0 else
                       after_point:=1;
              end;
              if (SelStart=0)and(text[SelStart+SelLength+1]='.') then
                    begin
                         vsp_text2:='0';
                         for i:=SelStart+SelLength+1 to length(vsp_text) do
                             vsp_text2:=vsp_text2+vsp_text[i];
                         text:=vsp_text2;

                    end;

         end;
         end;
     end;
end;

procedure TEditMoney.SetMoney(money:integer);
var vsp_text1,vsp_text2:string;
    i,l:integer;
begin
     vsp_text1:=IntToStr(money);
     l:=length(vsp_text1);
     if vsp_text1='0' then
        text:='0.00' else
     begin
     vsp_text2:='';
     for i:=1 to l-2 do
         vsp_text2:=vsp_text2+vsp_text1[i];
     vsp_text2:=vsp_text2+'.';
     vsp_text2:=vsp_text2+vsp_text1[l-1];
     vsp_text2:=vsp_text2+vsp_text1[l];
     text:=vsp_text2;
     end;
end;

function TEditMoney.GetMoney:integer;
var vsp_text1,vsp_text2:string;
    i,l:integer;
begin
     Check_point;
     SetText;
     vsp_text2:=text;
     vsp_text1:='';
     l:=length(vsp_text2);
     for i:=1 to l-3 do
         vsp_text1:=vsp_text1+vsp_text2[i];
     vsp_text1:=vsp_text1+vsp_text2[l-1];
     vsp_text1:=vsp_text1+vsp_text2[l];
     GetMoney:=StrToInt(vsp_text1);
end;

end.
