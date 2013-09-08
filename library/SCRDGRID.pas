unit scrdGrid;

interface

uses
 DBGrids,Messages,WinTypes,WinProcs;

Type TScrollDBGrid=class(TDBGrid)
      protected
        CurrentRecord:longint; 
	procedure WMVScroll(var Msg:TMessage); message WM_VSCROLL;
     end;

implementation

procedure TScrollDBGrid.WMVScroll(var Msg:TMessage);
begin
  case Msg.wParam of
    SB_BOTTOM: DataSource.DataSet.Last;
    SB_TOP:  DataSource.DataSet.First;
    SB_LINEUP:  DataSource.DataSet.Prior;
    SB_LINEDOWN:DataSource.DataSet.Next;
    SB_PAGEUP: SendMessage(Handle,WM_KEYDOWN,VK_PRIOR,0);
    SB_PAGEDOWN: SendMessage(Handle,WM_KEYDOWN,VK_NEXT,0);
    SB_THUMBPOSITION:
      case Msg.LParamLo of
        0: DataSource.DataSet.First;
        4: DataSource.DataSet.Last;
      end;
  end;
  if DataSource.DataSet.bof then DataSource.DataSet.First;
  if DataSource.DataSet.eof then DataSource.DataSet.Last;
  SetFocus
end;

end.