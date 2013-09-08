{ -------------------------------------------------------------------------------------}
{ An "Export Query" component for Delphi32.                                            }
{ Copyright 1996, Jean-Fabien Connault.  All Rights Reserved.                          }
{ This component can be freely used and distributed in commercial and private          }
{ environments, provided this notice is not modified in any way.                       }
{ -------------------------------------------------------------------------------------}
{ Feel free to contact me if you have any questions, comments or suggestions at        }
{   JFConnault@mail.dotcom.fr (Jean-Fabien Connault)                                   }
{ You can always find the latest version of this component at:                         }
{   http://www.worldnet.net/~cycocrew/delphi/                                          }
{ -------------------------------------------------------------------------------------}
{ Date last modified:  01/28/97                                                        }
{ -------------------------------------------------------------------------------------}

{ -------------------------------------------------------------------------------------}
{ TQExport v1.01                                                                       }
{ -------------------------------------------------------------------------------------}
{ Description:                                                                         }
{   A component that allows you to export the result of a Query to a Word              }
{   document or an Excel sheet.                                                        }
{ Properties:                                                                          }
{   property FileName: String;                                                         }
{   property Query: TQuery;                                                            }
{ Procedures and functions:                                                            }
{   function ExportWord:boolean;                                                       }
{   function ExportExcel:boolean;                                                      }
{ Needs:                                                                               }
{   Excels package version 2.0 from Tibor F. Liska (liska@sztaki.hu)                   }
{          and Stefan Hoffmeister (Stefan.Hoffmeister@Uni-Passau.de)                   }
{                                                                                      }
{ See example contained in example.zip file for more details.                          }
{ -------------------------------------------------------------------------------------}
{ Revision History:                                                                    }
{ 1.00:  + Initial release                                                             }
{ 1.01:  + Fixed to use Excels package version 2.0                                     }
{ -------------------------------------------------------------------------------------}

unit QExport;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DBTables, ComObj;

type
  TQExport = class(TComponent)
  private
    { Private-déclarations }
    {$IFNDEF INSTALLED}
//    FExcel: TAdvExcel;
    {$ENDIF}
    FFileName: String;
    FQuery: TQuery;
  protected
    { Protected-déclarations }
  public
    { Public-déclarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExportWord:boolean;
    function ExportExcel:boolean;
  published
    { Published-déclarations }
    property FileName: String read FFileName write FFileName;
    property Query: TQuery read FQuery write FQuery;
  end;

function ConvertStr(const s:string):string;
procedure Register;

implementation


procedure Register;
begin
//  RegisterComponents(LoadStr(srDAccess), [TQExport]);
end;

constructor TQExport.Create(AOwner: TComponent);
begin
//  FExcel := TAdvExcel.create(self);
  inherited Create(AOwner);
end;

destructor TQExport.Destroy;
begin
//  FExcel.free;
  inherited Destroy;
end;

function ConvertStr(const s:string):string;
var i:integer;
begin
  Result:='';
  for i:=1 to length(s) do
    if s[i] in [#9,#10,#13,';'] then Result:=Result+' ' else Result:=Result+s[i];
end;
{*****************************************************************************}
{* FUNCTION ExportWord                                                       *}
{*****************************************************************************}

function TQExport.ExportWord: boolean;
var
  S, Lang: string;
  MSWord: Variant;
  L,i,n: Integer;
  SlFlag:boolean;
begin
 { OLE Automation }
 result := true;
 try
    MsWord := CreateOleObject('Word.Basic');
 except
    ShowMessage('Could not start Microsoft Word.');
    result := false;
    Exit;
 end;

  { Détermination du langage utilisé }
  try
    Lang := MsWord.AppInfo(16);
  except
   MessageDlg('Cette version de Microsoft Word n''est pas supportée.',mtInformation,[mbOk],0);
   result := false;
   Exit;
  end;
  //Form1.Caption := Lang;

  { Requête }
  with FQuery do
  if FQuery.Active then
   begin
    L := 0;
    N := 0;
    { Construction de la chaine (titre) }
    SlFlag:=false;
    for i := 0 to FQuery.FieldCount - 1 do
     if FQuery.Fields[i].Visible then
       begin
         if SlFlag then  S := S + ';';
         SlFlag:=true;
         S := S + FQuery.Fields[i].DisplayLabel;
         inc(N);
       end;
    S := S + #13;
    inc(L);

    try
     First;
     while not EOF do
      begin
       { Construction de la chaine (valeurs) }
       SlFlag:=false;
       for i := 0 to FQuery.FieldCount - 1 do
        if FQuery.Fields[i].Visible then
          begin
           if SlFlag then  S := S + ';';
           SlFlag:=true;
           S := S + ConvertStr((FQuery.Fields[i]).AsString);
          end;
       S := S + #13;

       Inc(L);
       if L>20 then break;
       Next;
      end;

      { Langue anglaise }
//      if (Lang = 'English (US)') or (Lang = 'English (UK)') then
      begin
       MsWord.AppShow;
       MSWord.FileNew;
       MSWord.Insert(S);
//       MSWord.LineUp(L+1, 1);
       MSWord.EditSelectAll;
       MSWord.TextToTable(ConvertFrom := 2, NumColumns := N);
       MSWord.StartOfDocument;
//       MSWord.LineUp(0, 1);
//       MSWord.Close;
//       MSWord.FileSaveAs('FileName', 0);
      end;

      { Langue française }
(*      if Lang = 'Français' then
      begin
       MsWord.FenAppAfficher;
       MsWord.FichierNouveau;
       MSWord.Insertion(S);
       MSWord.LigneVersHaut(L, 1);
       MSWord.TexteEnTableau(ConvertirDe := 2, NbColonnesTableau := FQuery.FieldCount);
       MSWord.
//       MSWord.FichierEnregistrerSous(FFileName, 0);
      end;*)

     finally
//      Close;   // Close Query
    end;
  end;

end;

{*****************************************************************************}
{* FUNCTION ExportExcel                                                      *}
{*****************************************************************************}

function TQExport.ExportExcel: boolean;
var
  MSExcel: Variant;
  i, L, Row, Column: integer;
  S: string;
begin

 result := true;

 try
    MsExcel := CreateOleObject('Excel.Application');
 except
    ShowMessage('Could not start Microsoft Excel.');
    result := false;
    Exit;
 end;
(*

 { Tentative de connexion à Excel }
 try
  FExcel.Connect;   { Same as Excel.Connected := True; }
 except
  result := false;
  Exit;
 end;

 FExcel.StartTable;        { Create new workbook }

 with FQuery do
  begin
   L := 1;
   { Construction de la chaine (titre) }
   for i := 0 to FQuery.FieldCount - 1 do
   begin
    S:= FQuery.Fields[i].Fieldname;
    Row := L;
    Column := i + 1;
    try
     FExcel.PutStrAt(Row, Column, S);
    except
     //ShowMessage('Error with string "'+S+'"');
    end;
   end;
   inc(L);

   Close;
   Open;
   try
    while not EOF do
     begin
      { Construction de la chaine (valeurs) }
      for i := 0 to FQuery.FieldCount - 1 do
       begin
        S := (FQuery.Fields[i]).AsString;
        Row := L;
        Column := i + 1;
        try
         FExcel.PutStrAt(Row, Column, S);
        except
         //ShowMessage('Error with string "'+S+'"');
        end;
       end;
       inc(L);
       Next;
     end;
    finally
     Close;  // Close Query
    end;
  end;

 FExcel.EndTable;          { Show excel table }

 FExcel.Exec('[SAVE.AS("' + FFileName + '";1;"";FALSE;FALSE)]');
 FExcel.Exec('[CLOSE(FALSE)]');
 FExcel.Exec('[QUIT]');
*)
end;



end.
