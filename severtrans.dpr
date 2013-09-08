program severtrans;

uses
  Forms,
  Severtrans_mysql in '..\Severtrans_mysql.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
