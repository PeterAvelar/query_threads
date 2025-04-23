unit UntThreadPesq;

interface

uses Windows, Messages, SysUtils, Variants, Classes, ADODB, Dialogs, Grids, DBGrids, DB, Forms, Controls;

type
 pTDBGrid = ^TDBGrid;
 pTADOQuery = ^TADOQuery;
 pTForm = ^TForm;

type
 TThreadPesq = class(TThread)
 private
  FADOQ: TADOQuery;         
  FSQL: String;             
  FID: Integer;             
  FOriginGrid: pTDBGrid;
  FOriginQuery: pTADOQuery;
  FOriginForm: pTForm;
 public
  constructor Create(CreateSuspended: Boolean; AConnString: String; ASQL: String; IDThread: Integer; AParameters: TParameters; OriginGrid: pTDBGrid; OriginQuery: pTADOQuery; OriginForm: pTForm);
  destructor Destroy;  override;
  procedure Execute(); override;
  procedure ExecUpdate();

  property ADOQ: TADOQuery read FADOQ write FADOQ;
  property SQL: String read FSQL write FSQL;
  property ID: Integer read FID write FID;
  property OriginGrid: pTDBGrid read FOriginGrid write FOriginGrid;
  property OriginQuery: pTADOQuery read FOriginQuery write FOriginQuery;
  property OriginForm: pTForm read FOriginForm write FOriginForm;
 end;

 TThreadPesqManager = class
  private
   FThreadList: TThreadList;
   FNextID: Integer;
  public
   constructor Create;
   destructor Destroy; override;
   procedure CleanupOldThreads;
   function CreateNewThread(AConnString, ASQL: String; AParameters: TParameters; Grid: pTDBGrid; Query: pTADOQuery; Frm: pTForm): TThreadPesq;
   procedure RemoveThread(ThreadID: Integer);
  end;

var ThreadPesqManager: TThreadPesqManager; 

implementation

{ TThreadPesq }

constructor TThreadPesq.Create(CreateSuspended: Boolean; AConnString,
  ASQL: String; IDThread: Integer; AParameters: TParameters; OriginGrid: pTDBGrid; OriginQuery: pTADOQuery; OriginForm: pTForm);
begin
 inherited Create(CreateSuspended);
 Self.FreeOnTerminate := True;
 Self.ID := IDThread;
 Self.OriginGrid  := OriginGrid;
 Self.OriginQuery := OriginQuery;
 Self.OriginForm  := OriginForm;

 Self.ADOQ := TADOQuery.Create(nil);
 Self.ADOQ.Close;
 Self.ADOQ.ConnectionString := AConnString;
 Self.ADOQ.SQL.Add(ASQL);
 Self.ADOQ.Parameters := AParameters;

 Screen.Cursor := crHourGlass;
end;

procedure TThreadPesq.Execute;
begin
  inherited;
  try
    if not Terminated then
      Self.ADOQ.Open();

    if not Terminated then
      Synchronize(ExecUpdate);
   except
   on E: Exception do
      OutputDebugString(PChar('Erro na thread ' + IntToStr(Self.ID) + ': ' + E.Message));
  end;
end;

procedure TThreadPesq.ExecUpdate();
begin
  if Assigned(Self.OriginForm) and not Terminated then
  begin
   Self.OriginQuery.Recordset := Self.ADOQ.Recordset;
   Self.OriginGrid.Refresh;
   Screen.Cursor := crDefault;
  end;
end;

destructor TThreadPesq.Destroy;
begin
  if Assigned(FADOQ) then
  begin
    Self.ADOQ.Close;
    Self.ADOQ.Free;
    Self.ADOQ := nil;
  end;

  if Assigned(ThreadPesqManager) then
    ThreadPesqManager.RemoveThread(Self.ID);
  inherited;
end;

{ TThreadPesqManager }
constructor TThreadPesqManager.Create;
begin
  inherited;
  FThreadList := TThreadList.Create;
  FNextID := 1;
end;

destructor TThreadPesqManager.Destroy;
begin
  CleanupOldThreads;
  FThreadList.Free;
  inherited;
end;

procedure TThreadPesqManager.CleanupOldThreads;
var
  List: TList;
  i: Integer;
  Thread: TThreadPesq;
begin
  List := FThreadList.LockList;
  try
    for i := List.Count - 1 downto 0 do
    begin
      Thread := TThreadPesq(List[i]);
      Thread.Terminate;
    end;
  finally
    FThreadList.UnlockList;
  end;
end;

function TThreadPesqManager.CreateNewThread(AConnString, ASQL: String; AParameters: TParameters; Grid: pTDBGrid; Query: pTADOQuery; Frm: pTForm): TThreadPesq;
var
  NewThread: TThreadPesq;
  List: TList;
begin

  CleanupOldThreads;
  
  NewThread := TThreadPesq.Create(True, AConnString, ASQL, FNextID, AParameters, Grid, Query, Frm);
  Inc(FNextID);
  
  List := FThreadList.LockList;
  try
    List.Add(NewThread);
  finally
    FThreadList.UnlockList;
  end;
  Result := NewThread;
end;

procedure TThreadPesqManager.RemoveThread(ThreadID: Integer);
var
  List: TList;
  i: Integer;
  Thread: TThreadPesq;
begin
  List := FThreadList.LockList;
  try
    for i := 0 to List.Count - 1 do
    begin
      Thread := TThreadPesq(List[i]);
      if Thread.ID = ThreadID then
      begin
        List.Delete(i);
        Break;
      end;
    end;
  finally
    FThreadList.UnlockList;
  end;
end;

initialization
  ThreadPesqManager := TThreadPesqManager.Create;

finalization
  if Assigned(ThreadPesqManager) then
  begin
    ThreadPesqManager.Free;
    ThreadPesqManager := nil;
  end;

end.

