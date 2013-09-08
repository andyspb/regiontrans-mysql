unit AppDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, BMPBtn, Sqlctrls, Lbllist,tadjform,inifiles,
  DBTables,tsqlcls,findapps,statdlg;

const
	APP_SECTION='LanDocs Applications';
    DLG_SECTION='APPDLG';

procedure OpenAppDlg;

type
  TAliases = class(TAdjustForm)
    btAdd: TBMPBtn;
    btDelete: TBMPBtn;
    btAutoSearch: TBMPBtn;
    btExit: TBMPBtn;
    lbAppList: TLabelListbox;
    AppOpenDialog: TOpenDialog;
    procedure btAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btAutoSearchClick(Sender: TObject);
    procedure btExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
  	IniFile:TIniFile;
    Path:string;
	IdentList:TStringList;
    DirList:TStringlist;
	function AddSlash(s:string):string;
	procedure CheckAllAliases;
  end;

var
  Aliases: TAliases;

implementation

{$R *.DFM}

procedure TAliases.btAddClick(Sender: TObject);
var
	AppStr:string;
    FName:string;
    Ext:string;
begin
	AppOpenDialog.Filter:='Программы (*.exe)|*.exe|все файлы(*.*)|*.*';
    if AppOpenDialog.Execute then
    begin
    	AppStr:=AppOpenDialog.FileName;
        FName:=ExtractFileName(AppStr);
        Ext:=ExtractFileExt(FName);
        AppStr:=AddSlash(ExtractFileDir(AppStr));
        DirList.Add(AppStr);
        AppStr:=Copy(FName,1,Length(FName)-Length(Ext))+'='+AppStr;
        lbAppList.ListBox.Items.Add(AppStr);
        IdentList.Add(Copy(FName,1,Length(FName)-Length(Ext)));
        lbAppList.ListBox.ItemIndex:=lbAppList.ListBox.Items.Count-1;
        btDelete.Enabled:=TRUE;
    end;
end;

procedure TAliases.FormCreate(Sender: TObject);
var
    i:integer;
    DirStr:string;
begin
	Section:=DLG_SECTION;
	Path:='win.ini';
	IniFile:=TIniFile.Create(Path);
    IdentList:=TStringList.Create;
    DirList:=TStringList.Create;
    IniFile.ReadSection(APP_SECTION,IdentList);
    for i:=0 to IdentList.Count-1 do
    begin
        DirStr:=IniFile.ReadString(APP_SECTION,IdentList.Strings[i],'');
    	lbAppList.ListBox.Items.Add(IdentList.Strings[i]+'='+DirStr);
        DirList.Add(DirStr);
    end;
    lbAppList.ListBox.ItemIndex:=0;
    {    IniFile.ReadSectionValues(APP_SECTION,lbAppList.ListBox.Items);}
end;

procedure TAliases.btDeleteClick(Sender: TObject);
var
	DelItemIndex:integer;
begin
	DelItemIndex:=lbAppList.ListBox.ItemIndex;
	lbAppList.ListBox.Items.Delete(DelItemIndex);
    IdentList.Delete(DelItemIndex);
    DirList.Delete(DelItemIndex);
    if DelItemIndex=lbAppList.ListBox.Items.Count then
    	lbAppList.ListBox.ItemIndex:=lbAppList.ListBox.Items.Count-1
	else
    	lbAppList.ListBox.ItemIndex:=DelItemIndex;
    if lbAppList.ListBox.Items.Count=0 then
    	btDelete.Enabled:=FALSE
    else
    	btDelete.Enabled:=TRUE;
end;

Function TAliases.AddSlash(s:string):string;
begin
  if s[length(s)]='\' then AddSlash:=s
  else AddSlash:=s+'\'
end;


procedure TAliases.FormResize(Sender: TObject);
begin
  lbAppList.SetBounds(2*DeltaX,DeltaY,Client.ClientWidth-4*DeltaX,
        Client.ClientHeight-6*DeltaY);
end;

procedure TAliases.CheckAllAliases;
var
  s:string;
  Query:TQuery;
  als:string;
  i:integer;
begin
	Query:=sql.Select('FileType','','','');
    FindAppsDlg.Show;
	while (not Query.EOF) and (FindAppsDlg.StopFlag=0) do
	begin
    	als:=Query.FieldByName('ProccessFile').AsString;
        s:='';
{  		s:=IniFile.ReadString(APP_SECTION,als,'');}
 		for i:=0 to IdentList.Count-1 do
        	if IdentList.Strings[i]=als then
            	s:=DirList.Strings[i];
       	if s='' then
        begin
	        FindAppsDlg.lFindApps.Caption:='Идет поиск '+als;
            Application.ProcessMessages;
      		s:=FindAlias(als+'.EXE');
            if s<>'' then
            begin
	            IdentList.Add(als);
    	        DirList.Add(s);
        	    lbAppList.ListBox.Items.Add(als+'='+s);
            end else
            	FindAppsDlg.lFindApps.Caption:=als+' не найден.';
            FindAppsDlg.BringToFront;
            Application.ProcessMessages;
        end;
    	if als<>Query.FieldByName('ProccessFileView').AsString then
        begin
        	als:=Query.FieldByName('ProccessFileView').AsString;
            s:='';
    {  		s:=IniFile.ReadString(APP_SECTION,als,'');}
            for i:=0 to IdentList.Count-1 do
                if IdentList.Strings[i]=als then
                    s:=DirList.Strings[i];
    		if s='' then
            begin
		        FindAppsDlg.lFindApps.Caption:='Идет поиск '+als;
	            Application.ProcessMessages;
      			s:=FindAlias(als+'.EXE');
                if s<>'' then
                begin
			        IdentList.Add(als);
    			    DirList.Add(s);
        			lbAppList.ListBox.Items.Add(als+'='+s);
                end else
	            	FindAppsDlg.lFindApps.Caption:=als+' не найден.';
    	        FindAppsDlg.BringToFront;
        	    Application.ProcessMessages;
            end;
        end;
	    Query.Next;
        if lbAppList.ListBox.Items.Count>0 then
        	btDelete.Enabled:=TRUE;
	end;
    FindAppsDlg.Close;
end;

procedure TAliases.btAutoSearchClick(Sender: TObject);
begin
	CheckAllAliases;
end;

procedure TAliases.btExitClick(Sender: TObject);
begin
	ModalResult:=mrOK;
	Close;
end;

procedure TAliases.FormClose(Sender: TObject; var Action: TCloseAction);
var
    i,res:integer;
begin
	res:=MessageDlg('Сохранить изменения в файл win.ini?',mtWarning,mbYesNoCancel,0);
	if res=mrYes then
    begin
		IniFile.EraseSection(APP_SECTION);
		for i:=0 to lbAppList.ListBox.Items.Count-1 do
        	IniFile.WriteString(APP_SECTION,IdentList.Strings[i],DirList.Strings[i]);
    end;
    if res<>mrCancel then
    begin
		iniFile.free;
    	IdentList.free;
	    DirList.free;
	    ModalResult:=mrOK;
    	Action:=caFree
    end else
    	Action:=caNone;
end;

procedure OpenAppDlg;
begin
  Aliases:=TAliases.Create(Application);
  FindAppsDlg:=TFindAppsDlg.Create(Application);
  Aliases.ShowModal;
end;

end.
