unit OptDlg;

interface

uses
  WinProcs,WinTypes, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  tadjform, Sqlctrls, Lbledit, StdCtrls, Buttons, BMPBtn, Lebtn, LblCombo,
  Lblint,setdir;

type
  TParamsDlg = class(TAdjustForm)
    Documents: TGroupBox;
    Options: TGroupBox;
    btOK: TBMPBtn;
    btCancel: TBMPBtn;
    HintPresent: TCheckBox;
    SaveLastConnection: TCheckBox;
    ClearRegCard: TCheckBox;
    FilePromptFlag: TCheckBox;
    RegPromptFlag: TCheckBox;
    OpenDialog: TOpenDialog;
    Directory: TGroupBox;
    TempPath: TLabelEditBmpBtn;
    UnsortPath: TLabelEditBmpBtn;
    TemplatePath: TLabelEditBmpBtn;
    PrintOptions: TGroupBox;
    PrintRegCard: TCheckBox;
    PrintCCAfterSave: TCheckBox;
    PrintApplication: TLabelComboBox;
    procedure TempPathButtonClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btOKClick(Sender: TObject);
  private
    { Private declarations }
  public
	DocPath,ArchivePath,DeletePath:TLabelEditBMPBtn;
	ServerName:TLabelEdit;
    Port,Timeout1,Timeout2:TLabelInteger;
	procedure ReadOptions;
	procedure WriteOptions;
	function AddSlash(s:string):string;
    { Public declarations }
  end;

var
  ParamsDlg: TParamsDlg;

implementation

{$R *.DFM}

procedure TParamsDlg.TempPathButtonClick(Sender: TObject);
begin
	(Sender as TLabelEditBMPBtn).LabelEdit.Edit.Text:=
    	SetDirectory((Sender as TLabelEditBMPBtn).LabelEdit.Edit.Text);
end;

procedure TParamsDlg.FormResize(Sender: TObject);
begin
  Documents.SetBounds(DeltaX,DeltaY,(Client.ClientWidth-4*DeltaX) div 2,
  	(Client.ClientHeight-6*DeltaY)*4 div 7);
  {$ifdef DSQuery}
	ServerName.SetBoundsEx(2*DeltaX,ServerName.Lbl.Height,
		ServerName.Parent.Width-4*DeltaX,-1);
    Port.SetDown(ServerName,-1,-1);
    Timeout1.SetBoundsEx(2*DeltaX,Port.Top+Port.Height+DeltaY,
    	(Timeout1.Parent.Width-6*DeltaX) div 2,-1);
    Timeout2.SetBoundsEx(4*DeltaX+Timeout1.Width,Port.Top+Port.Height+DeltaY,
    	(Timeout2.Parent.Width-6*DeltaX) div 2,-1);
	Documents.Height:=Timeout1.Top+Timeout1.Height+2*DeltaY;
  {$else}
	DocPath.SetBoundsEx(2*DeltaX,DocPath.LabelEdit.Lbl.Height,
          DocPath.Parent.Width-4*DeltaX,-1);
    ArchivePath.SetDown(DocPath,-1,-1);
    DeletePath.SetDown(ArchivePath,-1,-1);
	Documents.Height:=DeletePath.Top+DeletePath.Height+2*DeltaY;
   {$endif}

  Directory.SetBounds(DeltaX*2+Documents.Width+Documents.Left,DeltaY,
	(Client.ClientWidth-4*DeltaX) div 2,
  	(Client.ClientHeight-6*DeltaY)*4 div 7);
    TemplatePath.SetBoundsEx(2*DeltaX,TemplatePath.LabelEdit.Lbl.Height,
    	TemplatePath.Parent.Width-4*DeltaX,-1);
    TempPath.SetDown(TemplatePath,-1,-1);
    UnsortPath.SetDown(TempPath,-1,-1);
	Directory.Height:=UnsortPath.Top+UnsortPath.Height+2*DeltaY;

  Options.SetBounds(DeltaX,DeltaY+Documents.Height+Documents.Top,
	(Client.ClientWidth-4*DeltaX) div 2,
  	(Client.ClientHeight-6*DeltaY)*3 div 7);
	HintPresent.SetBounds(2*DeltaX,-HintPresent.Font.Height+DeltaY,
    	HintPresent.Parent.Width-4*DeltaX,HintPresent.Height);
    SaveLastConnection.SetBounds(2*DeltaX,HintPresent.Top+HintPresent.Height+DeltaY,
    	SaveLastConnection.Parent.Width-4*DeltaX,SaveLastConnection.Height);
    ClearRegCard.SetBounds(2*DeltaX,SaveLastConnection.Top+SaveLastConnection.Height+DeltaY,
    	ClearRegCard.Parent.Width-4*DeltaX,ClearRegCard.Height);
    FilePromptFlag.SetBounds(2*DeltaX,ClearRegCard.Top+ClearRegCard.Height+DeltaY,
    	FilePromptFlag.Parent.Width-4*DeltaX,FilePromptFlag.Height);
    RegPromptFlag.SetBounds(2*DeltaX,FilePromptFlag.Top+FilePromptFlag.Height+DeltaY,
    	RegPromptFlag.Parent.Width-4*DeltaX,RegPromptFlag.Height);
	Options.Height:=RegPromptFlag.Top+RegPromptFlag.Height+2*DeltaY;


  PrintOptions.SetBounds(DeltaX*2+Documents.Width+Documents.Left,DeltaY+Documents.Height+Documents.Top,
	(Client.ClientWidth-4*DeltaX) div 2,
  	(Client.ClientHeight-6*DeltaY)*3 div 7);
	PrintRegCard.SetBounds(2*DeltaX,-PrintRegCard.Font.Height+DeltaY,
    	PrintRegCard.Parent.Width-4*DeltaX,PrintRegCard.Height);
    PrintCCAfterSave.SetBounds(2*DeltaX,PrintRegCard.Top+PrintRegCard.Height+DeltaY,
    	PrintCCAfterSave.Parent.Width-4*DeltaX,PrintCCAfterSave.Height);
    PrintApplication.SetDown(PrintCCAfterSave,PrintApplication.Parent.Width-4*DeltaX,-1);
	PrintOptions.Height:=Options.Height;
    ClientHeight:=ToolBar.Height+StatusBar.Height+DeltaY+PrintOptions.Top+PrintOptions.Height;
end;

procedure TParamsDlg.FormCreate(Sender: TObject);
begin
  	Section:='OPTIONSDLG';

{$ifdef DSQuery}
    Documents.Caption:='Параметры документ-сервера';
	ServerName:=TLabelEdit.Create(Self);
    Documents.InsertControl(ServerName);
    ServerName.Caption:='Имя сервера:';
    ServerName.Name:='ServerName';
    ServerName.Lbl.Font.Assign(TempPath.LabelEdit.Lbl.Font);
    ServerName.Edit.Font.Assign(TempPath.LabelEdit.Edit.Font);
    ServerName.TabOrder:=0;

	Port:=TLabelInteger.Create(Self);
    Documents.InsertControl(Port);
    Port.Caption:='Номер порта:';
    Port.Name:='Port';
    Port.Lbl.Font.Assign(TempPath.LabelEdit.Lbl.Font);
    Port.Edit.Font.Assign(TempPath.LabelEdit.Edit.Font);
    Port.TabOrder:=1;

	Timeout1:=TLabelInteger.Create(Self);
    Documents.InsertControl(Timeout1);
    Timeout1.Caption:='Время ожидания отправки:';
    Timeout1.Name:='Timeout1';
    Timeout1.Lbl.Font.Assign(TempPath.LabelEdit.Lbl.Font);
    Timeout1.Edit.Font.Assign(TempPath.LabelEdit.Edit.Font);
    Timeout1.TabOrder:=2;

	Timeout2:=TLabelInteger.Create(Self);
    Documents.InsertControl(Timeout2);
    Timeout2.Caption:='Время ожидания получения:';
    Timeout2.Name:='Timeout2';
    Timeout2.Lbl.Font.Assign(TempPath.LabelEdit.Lbl.Font);
    Timeout2.Edit.Font.Assign(TempPath.LabelEdit.Edit.Font);
    Timeout2.TabOrder:=3;
{$else}
    Documents.Caption:='Доступ к документам';

	DocPath:=TLabelEditBMPBtn.Create(Self);
    Documents.InsertControl(DocPath);
    DocPath.Caption:='Путь к документам:';
    DocPath.Name:='DocPath';
    DocPath.OnButtonClick:=TempPathButtonClick;
    DocPath.LabelEdit.Lbl.Font.Assign(TempPath.LabelEdit.Lbl.Font);
    DocPath.LabelEdit.Edit.Font.Assign(TempPath.LabelEdit.Edit.Font);
    DocPath.BmpFile:='FIND_BMP';
    DocPath.TabOrder:=0;

    ArchivePath:=TLabelEditBMPBtn.Create(Self);
    Documents.InsertControl(ArchivePath);
    ArchivePath.Caption:='Путь к архиву:';
    ArchivePath.Name:='ArchivePath';
    ArchivePath.OnButtonClick:=TempPathButtonClick;
    ArchivePath.LabelEdit.Lbl.Font.Assign(TempPath.LabelEdit.Lbl.Font);
    ArchivePath.LabelEdit.Edit.Font.Assign(TempPath.LabelEdit.Edit.Font);
    ArchivePath.BmpFile:='FIND_BMP';
    ArchivePath.TabOrder:=1;

    DeletePath:=TLabelEditBMPBtn.Create(Self);
    Documents.InsertControl(DeletePath);
    DeletePath.Caption:='Путь к корзине:';
    DeletePath.Name:='DeletePath';
    DeletePath.OnButtonClick:=TempPathButtonClick;
    DeletePath.LabelEdit.Lbl.Font.Assign(TempPath.LabelEdit.Lbl.Font);
    DeletePath.LabelEdit.Edit.Font.Assign(TempPath.LabelEdit.Edit.Font);
    DeletePath.BmpFile:='FIND_BMP';
    DeletePath.TabOrder:=2;
{$endif}
Documents.Font.Assign(TempPath.LabelEdit.Lbl.Font);
Directory.Font.Assign(TempPath.LabelEdit.Lbl.Font);
Options.Font.Assign(TempPath.LabelEdit.Lbl.Font);
PrintOptions.Font.Assign(TempPath.LabelEdit.Lbl.Font);

PrintApplication.ComboBox.Items.Add('winword');
PrintApplication.ComboBox.Items.Add('wordview');

ReadOptions;
end;

procedure TParamsDlg.ReadOptions;
var
	i:integer;
    PrintApp:string;
begin
{$ifdef DSQuery}
   ServerName.Text:=FormsIni.ReadString('Document Server','ServerName','');
   Port.Text:=FormsIni.ReadString('Document Server','Port','');
   Timeout1.Text:=FormsIni.ReadString('Document Server','DataReceiveTimeOutMSecs','0');
   Timeout2.Text:=FormsIni.ReadString('Document Server','DataSendTimeOutMSecs','0');
{$else}
   DocPath.LabelEdit.Edit.Text:=FormsIni.ReadString('Common','DocumDir','');
   ArchivePath.LabelEdit.Edit.Text:=FormsIni.ReadString('Common','ArchivDir','');
   DeletePath.LabelEdit.Edit.Text:=FormsIni.ReadString('Common','DeletedDir','');
{$endif}
   TempPath.LabelEdit.Edit.Text:=FormsIni.ReadString('Common','OutputDir','');
   TemplatePath.LabelEdit.Edit.Text:=FormsIni.ReadString('Common','TemplateDir','');
   UnsortPath.LabelEdit.Edit.Text:=FormsIni.ReadString('Common','UnsortDir','');

   SaveLastConnection.Checked:=(FormsIni.ReadInteger('Common','SaveLastConnection',1)=1);
   ClearRegCard.Checked:=(FormsIni.ReadInteger('Landocs Options','ClearRegCard',1)=1);
   FilePromptFlag.Checked:=(FormsIni.ReadInteger('Landocs Options','FilePromptFlag',0)=1);
   HintPresent.Checked:=(FormsIni.ReadInteger('Common','HintPresent',1)=1);
   RegPromptFlag.Checked:=(FormsIni.ReadInteger('Landocs Options','RegPromptFlag',1)=1);

   PrintRegCard.Checked:=(FormsIni.ReadInteger('Common','PrintRegCard',0)=1);
   PrintCCAfterSave.Checked:=(FormsIni.ReadInteger('Landocs Options','PrintCCAfterSave',0)=1);
   PrintApp:=FormsIni.ReadString('Landocs Options','PrintApplication','winword');
   for i:=0 to PrintApplication.ComboBox.Items.Count-1 do
	if PrintApplication.ComboBox.Items[i]=PrintApp then
   		PrintApplication.ComboBox.ItemIndex:=i;
end;

procedure TParamsDlg.WriteOptions;
begin
{$ifdef DSQuery}
   FormsIni.WriteString('Document Server','ServerName',ServerName.Text);
   FormsIni.WriteString('Document Server','Port',Port.Text);
   FormsIni.WriteString('Document Server','DataReceiveTimeOutMSecs',Timeout1.Text);
   FormsIni.WriteString('Document Server','DataSendTimeOutMSecs',Timeout2.Text);
{$else}
   FormsIni.WriteString('Common','DocumDir',AddSlash(DocPath.LabelEdit.Edit.Text));
   FormsIni.WriteString('Common','ArchivDir',AddSlash(ArchivePath.LabelEdit.Edit.Text));
   FormsIni.WriteString('Common','DeletedDir',AddSlash(DeletePath.LabelEdit.Edit.Text));
{$endif}
   FormsIni.WriteString('Common','OutputDir',AddSlash(TempPath.LabelEdit.Edit.Text));
   FormsIni.WriteString('Common','TemplateDir',AddSlash(TemplatePath.LabelEdit.Edit.Text));
   FormsIni.WriteString('Common','UnsortDir',AddSlash(UnsortPath.LabelEdit.Edit.Text));

   FormsIni.WriteInteger('Common','SaveLastConnection',integer(SaveLastConnection.Checked));
   FormsIni.WriteInteger('Landocs Options','ClearRegCard',integer(ClearRegCard.Checked));
   FormsIni.WriteInteger('Landocs Options','FilePromptFlag',integer(FilePromptFlag.Checked));
   FormsIni.WriteInteger('Common','HintPresent',integer(HintPresent.Checked));
   FormsIni.WriteInteger('Landocs Options','RegPromptFlag',integer(RegPromptFlag.Checked));

   FormsIni.WriteInteger('Common','PrintRegCard',integer(PrintRegCard.Checked));
   FormsIni.WriteInteger('Landocs Options','PrintCCAfterSave',integer(PrintCCAfterSave.Checked));
   FormsIni.WriteString('Landocs Options','PrintApplication',
   PrintApplication.ComboBox.Items[PrintApplication.ComboBox.ItemIndex]);
end;

function TParamsDlg.AddSlash(s:string):string;
begin
  if s[length(s)]='\' then AddSlash:=s
  else AddSlash:=s+'\'
end;

procedure TParamsDlg.btOKClick(Sender: TObject);
begin
	WriteOptions;
    ModalResult:=mrOK;
end;

end.
