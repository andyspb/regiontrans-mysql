
(*
             Document Server's interface module for client system.

             Notes:
               - Mixed 16/32-bit version
               - uses DSAPI.DLL (32-bit) or DSAPI16.DLL (16-bit)

             ??? Raising exceptions in DLLs
*)


				 Unit DSAPI;
{**************************************************************************}
{*} 				  Interface                              {*}
{**************************************************************************}

Uses
  DSAPICom;
Type

TDS_CreateDocumentServer=function(const InitData: DS_TInitData): DS_TAbstractDocumentServer;


TDS_DestroyDocumentServer=procedure (DocumentServer: DS_TAbstractDocumentServer);


TDS_Function=function(DocumentServer: DS_TAbstractDocumentServer;
  var UEDP:  DS_RUnifiedExchangeDataPacket):   longint;


TDS_ErrorCode=function (DocumentServer: DS_TAbstractDocumentServer):  longint;


TDS_ErrorMessage=function (DocumentServer: DS_TAbstractDocumentServer):  DS_TString;


TDS_Init=procedure;


TDS_Done=procedure;

{**************************************************************************}
{*}    	 		       Implementation                            {*}
{**************************************************************************}

END.