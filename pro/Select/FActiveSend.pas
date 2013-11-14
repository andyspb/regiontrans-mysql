unit FActiveSend;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst,DB,DBTables,TSQLCLS, Buttons, BMPBtn, ComCtrls,
  Grids, DBGrids, Menus, Sqlctrls, Lbsqlcmb,SqlGrid, ExtCtrls, OleServer,
  Word2000, toolbtn, Excel2000, EntrySec;

type
  TFormActiveSend = class(TForm)
    HeaderControl1: THeaderControl;
    btPrint: TBMPBtn;
    btCansel: TBMPBtn;
    DBGrid1: TDBGrid;
    Query1: TQuery;
    DataSource1: TDataSource;
    Query1AcceptorName: TStringField;
    Query1AcceptorAddress: TStringField;
    Query1AcceptorRegime: TStringField;
    Query1AcceptorPhone: TStringField;
    Query1Sel: TStringField;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    Query1RollOutName: TStringField;
    Query1Weight: TIntegerField;
    Query1Volume: TStringField;
    Query1PackCount: TStringField;
    Query1PlaceC: TIntegerField;
    Query1ClientAcr: TStringField;
    Query1PayTypeName: TStringField;
    Panel1: TPanel;
    cbTrain: TLabelSQLComboBox;
    WordApplication1: TWordApplication;
    Query1TypeGood: TStringField;
    Query1Ident: TIntegerField;
    Query1CityName: TStringField;
    Query1Number: TStringField;
    Query1SendTypeName: TStringField;
    cbPynkt: TLabelSQLComboBox;
    Query1Train_Ident: TIntegerField;
    eFiltr: TToolbarButton;
    ToolbarButton1: TToolbarButton;
    Query1Namber: TStringField;
    Query1ClientSenderAcr: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure btPrintClick(Sender: TObject);
    procedure cbTrainChange(Sender: TObject);
    procedure btCanselClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ToolbarButton1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormActiveSend: TFormActiveSend;
  sends_view: string;

implementation

uses makerepp ;
{$R *.dfm}

procedure TFormActiveSend.FormCreate(Sender: TObject);
begin
  Caption := 'Активные отправки ( ' + EntrySec.period + ' )';
  sends_view := iff (EntrySec.bAllData, 'sends_all', 'sends');

  Query1.Close;
  Query1.DatabaseName:=sql.DataBaseName;
  Query1.SQL.Clear;
  Query1.SQL.Add('select * from ' + sends_view + ' where DateSupp is NULL '+
                ' order by AcceptorName');
  Query1.ExecSQL;
  query1.Open;
  //cbPynkt.SQLComboBox.Sorted:=true;
  //cbTrain.SQLComboBox.Sorted:=true;
end;

procedure TFormActiveSend.N1Click(Sender: TObject);
begin
  Query1.Edit;
  if query1.FieldByName('Sel').value='+' then
    query1.FieldByName('Sel').value:='-'
  else query1.FieldByName('Sel').value:='+';
    query1.Post;
  end;

procedure TFormActiveSend.btPrintClick(Sender: TObject);
var
  ReportMakerWP: TReportMakerWP;
  p, w1, w2, w3, w4: OleVariant;
  s, cond: string;
  rtffile,  inifile: string;
  CWeig, CPlac: integer;
  CVol: real;
  ActivesendGd1_ini: string;
  ActivesendAVt_ini: string;
  label T;
begin
  try
  {if cbPynkt.SQLComboBox.GetData=0 then
  begin
      Application.MessageBox('Выберите город!','Ошибка!',0);
      cbPynkt.SQLComboBox.SetFocus;
      exit;
  end;  }
  CWeig := 0;
  CPlac := 0;
  CVol := 0;
  s := '';
  sql.Delete('ActSendPrint','');
  Query1.DisableControls;
  Query1.First;

  while (not Query1.eof) do
  begin
    if (Query1.FieldByName('Sel').value = '+') then
    begin
      CWeig:=CWeig+Query1.FieldByName('Weight').asinteger;
      CPlac:=CPlac+Query1.FieldByName('PlaceC').asinteger;
      CVol:=CVol+Query1.FieldByName('Volume').asfloat;
      sql.InsertString('ActSendPrint','Send_Ident',Query1.FieldByName('Ident').asString);
    end;
    Query1.Next;
  end;
  Query1.EnableControls ;
  //if s<>'' then begin
  // delete(s,1,1);
  // s:='Ident in ('+s+')';
  // end else s:='Ident=0';
  //-----------------------------
  ReportMakerWP:=TReportMakerWP.Create(Application);
  ReportMakerWP.ClearParam;
  ReportMakerWP.AddParam('1='+IntTOStr(CWeig));
  ReportMakerWP.AddParam('2='+IntTOStr(CPlac));
  ReportMakerWP.AddParam('3='+FloatTOStr(CVol));

  ActivesendGd1_ini := iff(EntrySec.bAllData, 'ActivesendGd1_all', 'ActivesendGd1');
  ActivesendAVt_ini := iff(EntrySec.bAllData, 'ActivesendAVt_all', 'ActivesendAVt');
  if cbTrain.SQLComboBox.GetData<>0 then
    if cbPynkt.SQLComboBox.GetData<>0 then
    begin
      cond := 'ContractType_Ident=1 and City_Ident='+
          IntToStr(cbPynkt.SQLComboBox.GetData)+
          ' and Train_Ident='+intToStr(cbTrain.SQLComboBox.getdata);
      rtffile := 'Activesendgd1';
      inifile:= ActivesendGd1_ini ;
    end
    else
    begin
      cond:='ContractType_Ident=1 '+
            ' and Train_Ident='+intToStr(cbTrain.SQLComboBox.getdata);
            rtffile:='Activesendgd1';
            inifile:=ActivesendGd1_ini ;
    end
    else
    begin
      cond:='ContractType_Ident=2 and City_Ident='+
           IntToStr(cbPynkt.SQLComboBox.GetData);
      rtffile:='ActivesendAvt1';
      inifile:=ActivesendAVt_ini;
    end;
    ReportMakerWP.AddParam('4='+cond);
    ReportMakerWP.AddParam('5='+cbPynkt.SQLComboBox.Text);
    ReportMakerWP.AddParam('6='+FormatDateTime('dd.mm.yyyy',now));
    ReportMakerWP.AddParam('7='+'поезд № '+cbTrain.SQLComboBox.Text);
    if ReportMakerWP.DoMakeReport(systemdir+'Select\'+rtfFile+'.rtf',
          systemdir+'Select\'+inifile+'.ini', systemdir+'Select\out.rtf')<>0 then
    begin
      ReportMakerWP.Free;
      application.messagebox('Закройте выходной документ в WINWORD!', 'Совет!',0);
      exit
    end;;
    //--------------------------------------
    WordApplication1:=TWordApplication.Create(Application);
    p := systemdir+'Select\out.rtf';
    W1:=1;
    //w2:=sql.SelectString('Printer','NameA4','');
    WordApplication1.Documents.Open(p,
	  EmptyParam,EmptyParam,EmptyParam,
	  EmptyParam,EmptyParam,EmptyParam,
	  EmptyParam,EmptyParam,EmptyParam,
    EmptyParam,EmptyParam);
    //w3:=sql.SelectString('Printer','ComNameA4','');

    //w4:=WordApplication1.UserName;
    //if w3<>w4 then   w2:= '\\'+w3+'\'+w2;
    //WordApplication1.ActivePrinter:=w2;
    {WordApplication1.ActiveDocument.PrintOut(
    EmptyParam,EmptyParam,EmptyParam,
    EmptyParam, EmptyParam,EmptyParam,
	  EmptyParam,w1,EmptyParam,
	  EmptyParam,EmptyParam,EmptyParam,
    w2,EmptyParam,EmptyParam,
        EmptyParam,EmptyParam,EmptyParam);   }
    {T: WordApplication1.Documents.Close(EmptyParam,EmptyParam,
        EmptyParam);
}
//WordApplication1.WindowState:=2;

    WordApplication1.Free;
  except
    WordApplication1.Documents.Close(EmptyParam,EmptyParam,EmptyParam);
    application.MessageBox('Проверьте настройки печати!','Ошибка!',0);
    exit
  end;
end;

procedure TFormActiveSend.cbTrainChange(Sender: TObject);
var CId: longInt;
    str: string;
begin
  str:='';
  CId:=cbPynkt.SQLComboBox.GetData;
  if CId<>0 then
  begin
    if cbTrain.SQLComboBox.getdata<>0 then
      str:='and ContractType_Ident=1 and City_Ident='+IntToStr(CID)+
        ' and Train_Ident='+intToStr(cbTrain.SQLComboBox.getdata)
    else str:='and ContractType_Ident=2 and City_Ident='+IntToStr(CID);
      Query1.Close;
    Query1.DatabaseName:=sql.DataBaseName;
    Query1.SQL.Clear;
    Query1.SQL.Add('select * from ' + sends_view + ' where DateSupp is NULL '+
                str+' order by AcceptorName');
    Query1.ExecSQL;
    query1.Open;
  end
  else
  begin
    if cbTrain.SQLComboBox.getdata<>0 then
      str:='and ContractType_Ident=1'+
        ' and Train_Ident='+intToStr(cbTrain.SQLComboBox.getdata)
    else
      str:='';
    Query1.Close;
    Query1.DatabaseName:=sql.DataBaseName;
    Query1.SQL.Clear;
    Query1.SQL.Add('select * from ' + sends_view + ' where DateSupp is NULL '+
                str+' order by AcceptorName');
    Query1.ExecSQL;
    query1.Open;
  end;
end;

procedure TFormActiveSend.btCanselClick(Sender: TObject);
begin
  close;
end;

procedure TFormActiveSend.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_Return then
    btPrintClick(Sender)
end;

procedure TFormActiveSend.ToolbarButton1Click(Sender: TObject);
begin
  Query1.Close;
  Query1.DatabaseName:=sql.DataBaseName;
  Query1.SQL.Clear;
  Query1.SQL.Add('select * from ' + sends_view + ' where DateSupp is NULL '+
                ' order by AcceptorName');
  Query1.ExecSQL;
  query1.Open;
end;

end.
