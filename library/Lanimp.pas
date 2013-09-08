Unit LanImp;

Interface

Const
   LanImpSect = 'LanDocsImportEMail';
   LanImpName = 'Name';
   LanImpPass = 'Password';

type
  TLanImportInfo = packed record
    IniFileName:  	array [0..79] of Char;
    FileTypeName: 	array [0..256] of Char;
    FileTypeExtention: 	array [0..256] of Char;
    Param1, Param2:  	longint;
    ResultFileName:  	array [0..80] of Char;
    ResultDescription:	array [0..10240] of Char;
  end;
  TLanImportProc=function(var Params:  TLanImportInfo):longint;
Implementation

end.