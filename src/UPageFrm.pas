unit UPageFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, UBase, ComCtrls, Contnrs, ActnList, StdActns, ImgList,
  Menus, UExeFrm, StdCtrls, TntStdCtrls, ExtCtrls, AppEvnts;

type
  TPageFrm = class(TTntFrame)
    PG: TPageControl;
    ImageList1: TImageList;
    ActionList1: TActionList;
    FileOpen1: TFileOpen;
    ActionCompile: TAction;
    ActionSave: TAction;
    ActionSaveAs: TAction;
    ActionClose: TAction;
    ActionCloseAll: TAction;
    PopupMenu1: TPopupMenu;
    ActionClose1: TMenuItem;
    ActionNewGram: TAction;
    Panel1: TPanel;
    lbLog: TTntListBox;
    StatusBar1: TStatusBar;
    ApplicationEvents1: TApplicationEvents;
    ActionNewProgGram: TAction;
    ActionNewProgTG: TAction;
    ActionNewProgVA: TAction;
    ActionNewTablePNY: TAction;
    ActionFullView: TAction;
    eljeskp1: TMenuItem;
    procedure FileOpen1Accept(Sender: TObject);
    procedure ActionCompileExecute(Sender: TObject);
    procedure ActionSaveUpdate(Sender: TObject);
    procedure ActionSaveExecute(Sender: TObject);
    procedure ActionNewMacroExecute(Sender: TObject);
    procedure ActionSaveAsExecute(Sender: TObject);
    procedure ActionCloseExecute(Sender: TObject);
    procedure ActionCloseAllExecute(Sender: TObject);
    procedure ActionNewGramExecute(Sender: TObject);
    procedure ActionNewPGramExecute(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ActionNewProgTGExecute(Sender: TObject);
    procedure ActionNewProgVAExecute(Sender: TObject);
    procedure ActionNewProgGramExecute(Sender: TObject);
    procedure ActionFullViewExecute(Sender: TObject);
  private
    AdvCount: Integer;
    BasCount: Integer;
    FList: TObjectList;
    FFileName: WideString;
    FOnFileNameChanged: TNotifyEvent;
    function GetFrame(index: integer): TExeFrm;
    function NextMakroName: WideString;
    function NextGramName: WideString;
    procedure SetFileName(const Value: WideString);
    procedure SetOnFileNameChanged(const Value: TNotifyEvent);
    procedure Welcome;
    { Private declarations }
  public
    procedure RefreshFont;
    procedure SetCursor(Line, Col: Integer);
    property FileName: WideString read FFileName write SetFileName;
    procedure Run;
    function AddBasic(ProgMode: Boolean = false): Integer;
    function AddBasicFromFile(S: widestring): Integer;
    function AddAdv: Integer;
    function AddAdvFromFile(S: widestring): Integer;
    function AddAdvFromText(S: widestring): Integer;
    function AddFromFile(S: widestring): Integer;
    function Close(index: Integer): Boolean;
    function CloseAll: Boolean;
    procedure SetCaption(index: Integer; S: WideString);
    property Frame[index: integer]: TExeFrm read GetFrame;
    function Current: TExeFrm;
    function index: integer;
    procedure AfterConstruction; override;
    function Count: Integer;
    function FileIsOpened(S: WideString): Boolean;
    function CaptionUsed(S: WideString): Boolean;
  published
    property OnFileNameChanged: TNotifyEvent read FOnFileNameChanged write SetOnFileNameChanged;
  end;

var
  PageFrm: TPageFrm;

implementation

uses
  UAdvFrm, UBasFrm, UWelcomeFrm;

{$R *.DFM}

{ TPageFrame }

procedure TPageFrm.ActionCloseAllExecute(Sender: TObject);
begin
  CloseAll;
end;

procedure TPageFrm.ActionCloseExecute(Sender: TObject);
begin
  Close(index);
end;

procedure TPageFrm.ActionCompileExecute(Sender: TObject);
begin
  LogF.Add('Run Action Called');
  if Current <> nil then
  begin
    LogF.Add('Current <> nil');
    lbLog.Clear;
    Current.Run;
  end;
end;

procedure TPageFrm.ActionFullViewExecute(Sender: TObject);
var
  A: TAdvFrm;
  B: TBasFrm;
begin
  if Current is TAdvFrm then
  begin
    A := TAdvFrm(Current);
    if A.IsFullView then
      A.NormalView
    else
      A.FullView(FindVCLWindow(Mouse.CursorPos));
    ActionFullView.Checked := A.IsFullView;
  end
  else if Current is TBasFrm then
  begin
    B := TBasFrm(Current);
    if B.IsFullView then
      B.NormalView
    else
      B.FullView(FindVCLWindow(Mouse.CursorPos));
    ActionFullView.Checked := B.IsFullView;
  end
end;

procedure TPageFrm.ActionNewGramExecute(Sender: TObject);
var
  I: Integer;
begin
  I := AddBasic;
  PG.Pages[I].Caption := NextGramName;
  PG.ActivePageIndex := I;
  Current.Caption := PG.Pages[I].Caption;
  SetFileName(Current.Caption);
  Frame[I].Modified := false;
  TBasFrm(Current).SelectMode(ptGrammar, false);
end;

procedure TPageFrm.ActionNewMacroExecute(Sender: TObject);
var
  I: Integer;
begin
  I := AddAdvFromFile('makrosablon');
  PG.Pages[I].Caption := NextMakroName;
  PG.ActivePageIndex := I;
  Current.Caption := PG.Pages[I].Caption;
  Current.FileName := '';
  SetFileName(Current.Caption);
end;

procedure TPageFrm.ActionNewPGramExecute(Sender: TObject);
var
  I: Integer;
begin
  I := AddBasic(true);
  PG.Pages[I].Caption := NextGramName;
  PG.ActivePageIndex := I;
  Current.Caption := PG.Pages[I].Caption;
  SetFileName(Current.Caption);
  TBasFrm(Current).SelectMode(ptGrammar, true);
end;

procedure TPageFrm.ActionNewProgGramExecute(Sender: TObject);
var
  I: Integer;
begin
  I := AddAdvFromFile('lib/pnysablon.pla');
  PG.Pages[I].Caption := NextMakroName;
  PG.ActivePageIndex := I;
  Current.Caption := PG.Pages[I].Caption;
  Current.FileName := '';
  TAdvFrm(Current).SelectMode(ptGrammar);
  SetFileName(Current.Caption);
end;

procedure TPageFrm.ActionNewProgTGExecute(Sender: TObject);
var
  I: Integer;
begin
  I := AddAdvFromFile('lib/turingsablon.pla');
  PG.Pages[I].Caption := NextMakroName;
  PG.ActivePageIndex := I;
  Current.Caption := PG.Pages[I].Caption;
  Current.FileName := '';
  TAdvFrm(Current).SelectMode(ptTuring);
  SetFileName(Current.Caption);
end;

procedure TPageFrm.ActionNewProgVAExecute(Sender: TObject);
var
  I: Integer;
begin
  I := AddAdvFromFile('lib/veremsablon.pla');
  PG.Pages[I].Caption := NextMakroName;
  PG.ActivePageIndex := I;
  Current.Caption := PG.Pages[I].Caption;
  Current.FileName := '';
  TAdvFrm(Current).SelectMode(ptPushDown);
  SetFileName(Current.Caption);
end;

procedure TPageFrm.ActionSaveAsExecute(Sender: TObject);
var
  S: WideString;
begin
  if Current <> nil then
  begin
    if Current.SaveDialog then
    begin
      S := ChangeFileExt(ExtractFileName(Current.FileName), '');
      FileName := S;
      SetCaption(Index, S);
    end;
  end;
end;

procedure TPageFrm.ActionSaveExecute(Sender: TObject);
begin
  if Current <> nil then
  begin
    if Current.FileName = '' then
      Current.SaveDialog
    else
      Current.SaveToFile;
  end;
end;

procedure TPageFrm.ActionSaveUpdate(Sender: TObject);
begin
  if Current <> nil then
    ActionSave.Enabled := Current.Modified
  else
    ActionSave.Enabled := false;
end;

function TPageFrm.AddAdv: Integer;
var
  T: TTabSheet;
  A: TAdvFrm;
begin
  T := TTabSheet.Create(PG);
  T.PageControl := PG;
  A := TAdvFrm.Create(T);
  A.RefreshFont;
  A.Parent := T;
  A.Align := alClient;
//  A.SetFileName(T.Caption);
  Result := PG.PageCount - 1;
  PG.ActivePageIndex := Result;
  FList.Insert(Result, A);
end;

function TPageFrm.AddAdvFromFile(S: WideString): Integer;
begin
  Result := AddAdv;
  Frame[Result].LoadFromFile(S);
  PG.Pages[Result].Caption := ChangeFileExt(ExtractFileName(S), '');
  FileName := S;
end;

function TPageFrm.AddAdvFromText(S: widestring): Integer;
begin

end;

function TPageFrm.AddBasic(ProgMode: Boolean = false): Integer;
var
  T: TTabSheet;
  A: TBasFrm;
begin
  T := TTabSheet.Create(PG);
  T.PageControl := PG;
  A := TBasFrm.Create(T);
  A.RefreshFont;
  A.ProgMode := ProgMode;
  A.Clear;
  A.Parent := T;
  A.Align := alClient;
  Result := PG.PageCount - 1;
  PG.ActivePageIndex := Result;
  FList.Insert(Result, A);
  A.Modified := false;
  A.SelectMode(ptGrammar, ProgMode);
end;

function TPageFrm.AddBasicFromFile(S: widestring): Integer;
begin
  Result := AddBasic;
  Frame[Result].LoadFromFile(S);
  Frame[Result].Modified := false;
  PG.Pages[Result].Caption := ChangeFileExt(ExtractFileName(S), '');
  FileName := S;
end;

function TPageFrm.AddFromFile(S: WideString): Integer;
begin
  if ExtractFileExt(S) = '.gr' then
    Result := AddBasicFromFile(S)
  else if ExtractFileExt(S) = '.pla' then
    Result := AddAdvFromFile(S);
end;

procedure TPageFrm.AfterConstruction;
begin
  inherited;
  FList := TObjectList.Create(false);
end;

procedure TPageFrm.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  if (Current <> nil) and Current.Modified then
    StatusBar1.Panels[2].Text := 'Módosított'
  else
    StatusBar1.Panels[2].Text := '          ';
end;

function TPageFrm.CaptionUsed(S: WideString): Boolean;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if PG.Pages[I].Caption = S then
    begin
      Result := true;
      exit;
    end;
  Result := false;
end;

function TPageFrm.Close(index: Integer): Boolean;

  procedure P;
  begin
    Result := true;
    Visible := false;
    PG.Pages[index].Free;
    FList.Delete(index);
    if index <> 0 then
      PG.ActivePageIndex := index - 1;
    Visible := true;
  end;

begin
  Result := false;
  with Frame[index] do
  if Modified then
  case MessageDlg('Menti a változásokat: ' + FileName + '?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
    mrYes:
      begin
        if SaveDialog then
          P;
      end;
    mrCancel: exit;
    mrNo: P;
  end
  else
    P;
end;

function TPageFrm.CloseAll: Boolean;
var
  I: Integer;
begin
  Result := true;
  for I := PG.PageCount - 1 downto 0 do
    Result := Result and Close(I);
end;

function TPageFrm.Count: Integer;
begin
  Result := FList.Count;
end;

function TPageFrm.Current: TExeFrm;
begin
  if Index = -1 then
    Result := nil
  else
    Result := TExeFrm(FList[index]);
end;

function TPageFrm.FileIsOpened(S: WideString): Boolean;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Frame[I].FileName = S then
    begin
      Result := true;
      exit;
    end;
  Result := false;
end;

procedure TPageFrm.FileOpen1Accept(Sender: TObject);
begin
  if not FileIsOpened(FileOpen1.Dialog.FileName) then
    AddFromFile(FileOpen1.Dialog.FileName);
end;

function TPageFrm.GetFrame(index: integer): TExeFrm;
begin
  Result := TExeFrm(FList[index]);
end;

function TPageFrm.index: integer;
begin
  Result := PG.ActivePageIndex;
end;

function TPageFrm.NextGramName: WideString;
begin
  Inc(BasCount);
  Result := 'nyelvtan' + IntToStr(BasCount);
  if CaptionUsed(Result) then
    Result := NextGramName;
end;

function TPageFrm.NextMakroName: WideString;
begin
  Inc(AdvCount);
  Result := 'program' + IntToStr(AdvCount);
  if CaptionUsed(Result) then
    Result := NextMakroName;
end;

procedure TPageFrm.RefreshFont;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Frame[I].RefreshFont;
end;

procedure TPageFrm.Run;
begin
  lbLog.Clear;
  Current.Run;
end;

procedure TPageFrm.SetCaption(index: Integer; S: WideString);
begin
  PG.Pages[index].Caption := S;
end;

procedure TPageFrm.SetCursor(Line, Col: Integer);
begin
  StatusBar1.Panels[0].Text := 'Sor: ' + IntToStr(Line);
  StatusBar1.Panels[1].Text := 'Oszl: ' + IntToStr(Col);
end;

procedure TPageFrm.SetFileName(const Value: WideString);
begin
  FFileName := Value;
  if Assigned(FOnFileNameChanged) then
    FOnFileNameChanged(Self);
end;

procedure TPageFrm.SetOnFileNameChanged(const Value: TNotifyEvent);
begin
  FOnFileNameChanged := Value;
end;

procedure TPageFrm.Welcome;
var
  T: TTabSheet;
  A: TWelcomeFrm;
  I: Integer;
begin
  T := TTabSheet.Create(PG);
  T.PageControl := PG;
  A := TWelcomeFrm.Create(T);
  A.Parent := T;
  A.Align := alClient;
  I := PG.PageCount - 1;
  PG.ActivePageIndex := I;
  FList.Insert(I, A);
  A.Modified := false;
end;

end.