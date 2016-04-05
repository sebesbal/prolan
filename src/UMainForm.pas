unit UMainForm;

interface

uses
  Windows, Classes, Controls, ComCtrls, Forms, StdCtrls, ExtCtrls, ToolWin,
  ActnMan, ActnCtrls, ActnList, StdActns, XPStyleActnCtrls, ImgList, Menus, ShellApi,
  AppEvnts, URunFrm, UPlFrm, UCodeFrm, UBase, TntForms, UPageFrm, TntComCtrls, inifiles;

type
  TMainForm = class(TForm)
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ImageList1: TImageList;
    ToolButton2: TToolButton;
    MainMenu1: TMainMenu;
    Fille1: TMenuItem;
    Open1: TMenuItem;
    SaveAs1: TMenuItem;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    Belltsok1: TMenuItem;
    Sg1: TMenuItem;
    ActionSave1: TMenuItem;
    Debug1: TMenuItem;
    EnablePreProc1: TMenuItem;
    PageFrame1: TPageFrm;
    ApplicationEvents1: TApplicationEvents;
    ActionClose1: TMenuItem;
    ActionCloseAll1: TMenuItem;
    j2: TMenuItem;
    jNyelvtan2: TMenuItem;
    jProgramozottNyelvtan1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    Kilps1: TMenuItem;
    ProgramPNY1: TMenuItem;
    ProgramTG1: TMenuItem;
    ProgramVA1: TMenuItem;
    ProlanHelp1: TMenuItem;
    Nvjegy1: TMenuItem;
    Szerkeszts1: TMenuItem;
    ActionList1: TActionList;
    EditCopy1: TEditCopy;
    EditCut1: TEditCut;
    EditPaste1: TEditPaste;
    Kivgs1: TMenuItem;
    Msols1: TMenuItem;
    Beilleszts1: TMenuItem;
    InsertLine: TAction;
    DeleteLine: TAction;
    Sorbeszrs1: TMenuItem;
    Sortrls1: TMenuItem;
    N3: TMenuItem;
    Sortrls2: TMenuItem;
    procedure Belltsok1Click(Sender: TObject);
    procedure Sg1Click(Sender: TObject);
    procedure SetFileName(S: WideString);
    procedure AutoLoad;
    procedure FormCreate(Sender: TObject);
    procedure OnSetFileName(Sender: TObject);
    procedure MainMenu1Change(Sender: TObject; Source: TMenuItem;
      Rebuild: Boolean);
    procedure PageFrame1PageControl1Change(Sender: TObject);
    procedure Nvjegy1Click(Sender: TObject);
    procedure InsertLineExecute(Sender: TObject);
    procedure DeleteLineExecute(Sender: TObject);
    procedure InsertLineUpdate(Sender: TObject);
    procedure DeleteLineUpdate(Sender: TObject);
    function BasicPage: Boolean;
    procedure ProlanHelp1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Kilps1Click(Sender: TObject);
    { Private declarations }
  public
    FileName: WideString;
    Modified: Boolean;
    procedure RefreshFont(Sender: TObject);
  end;
var
  MainForm: TMainForm;

var
  cautoload: widestring = ''; // 'turing - u u.mc';
implementation

uses
  UPrefDlg, Dialogs, SysUtils, UCard, UBasFrm, UAdvFrm;

{$R *.dfm}

procedure TMainForm.SetFileName(S: WideString);
begin
  FileName := S;
  Caption := ExtractFileName(S) + ' - ProLan';
  Modified := false;
end;

procedure TMainForm.AutoLoad;
begin
  if cautoload <> '' then
    PageFrame1.AddFromFile(ExtractFileName(cautoload))
  else;
end;

function TMainForm.BasicPage: Boolean;
begin
  if (PageFrame1.Current <> nil) then
    Result := PageFrame1.Current is TBasFrm
  else
    Result := false;
end;

procedure TMainForm.Belltsok1Click(Sender: TObject);
begin
  PrefDlg.OnFontChanged := RefreshFont;
  PrefDlg.Init;
  PrefDlg.ShowModal;
end;

procedure TMainForm.DeleteLineExecute(Sender: TObject);
begin
  if BasicPage then
    TBasFrm(PageFrame1.Current).blf.ActionDelLine.Execute
  else
    TAdvFrm(PageFrame1.Current).CodeFrm1.DeleteLine.Execute;
end;

procedure TMainForm.DeleteLineUpdate(Sender: TObject);
begin
  DeleteLine.Enabled := PageFrame1.Current <> nil;
end;

procedure LoadDirs;
begin
  max_path;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not PageFrame1.CloseAll then
    Action := caNone;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Font := GFont;
  PageFrame1.OnFileNameChanged := OnSetFileName;
  AutoLoad;
end;

procedure TMainForm.InsertLineExecute(Sender: TObject);
begin
  if BasicPage then
    TBasFrm(PageFrame1.Current).blf.ActionInsertLine.Execute;
end;

procedure TMainForm.InsertLineUpdate(Sender: TObject);
begin
  InsertLine.Enabled := BasicPage;
end;

procedure TMainForm.Kilps1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.MainMenu1Change(Sender: TObject; Source: TMenuItem;
  Rebuild: Boolean);
begin
  {$IfDef DEBUG}
    TSProgram.FDisablePreprocessor := not EnablePreProc1.Checked;
  {$Else}
    TSProgram.FDisablePreprocessor := false;
  {$EndIf}
end;

procedure TMainForm.Nvjegy1Click(Sender: TObject);
begin
  CardForm.ShowModal;
end;

procedure TMainForm.OnSetFileName(Sender: TObject);
begin
  SetFileName(PageFrame1.FileName);
end;

procedure TMainForm.PageFrame1PageControl1Change(Sender: TObject);
begin
  if PageFrame1.PG.ActivePageIndex > -1 then
    SetFileName(PageFrame1.PG.ActivePage.Caption);
end;

procedure TMainForm.ProlanHelp1Click(Sender: TObject);
begin
  ShellExecute(Application.Handle,
             PChar('open'),
             PChar('kézikönyv.pdf'),
             PChar(0),
             nil,
             SW_NORMAL);
end;

procedure TMainForm.RefreshFont(Sender: TObject);
begin
  Font := GFont;
  PageFrame1.RefreshFont;
end;

procedure TMainForm.Sg1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'prolan.chm', nil, nil, SW_SHOWNORMAL);
end;

end.
