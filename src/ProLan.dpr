program ProLan;

uses
  Forms,
  shlobj,
  Windows,
  prolanyacc in 'dyacclex-1.4\prolan\prolanyacc.pas',
  UMainForm in 'UMainForm.pas' {MainForm},
  UPrefDlg in 'UPrefDlg.pas' {PrefDlg},
  UCodeFrm in 'UCodeFrm.pas' {CodeFrm: TFrame},
  URunFrm in 'URunFrm.pas' {RunFrm: TFrame},
  UPlFrm in 'UPlFrm.pas' {PlFrm: TFrame},
  UAdvFrm in 'UAdvFrm.pas' {AdvFrm: TExeFrm},
  UBase in 'UBase.pas',
  UPageFrm in 'UPageFrm.pas' {PageFrm: TFrame},
  UBasFrm in 'UBasFrm.pas' {BasFrm: TExeFrm},
  UBasPLFrm in 'UBasPLFrm.pas' {BasPLFrame: TFrame},
  UExeFrm in 'UExeFrm.pas' {ExeFrm: TFrame},
  UTuring in 'UTuring.pas',
  UGrammar in 'UGrammar.pas',
  UAniFrm in 'UAniFrm.pas' {AniFrm: TFrame},
  UPushDown in 'UPushDown.pas',
  inifiles,
  SysUtils,
  TypInfo,
  Graphics,
  Classes,
  UCard in 'UCard.pas' {CardForm},
  UHeap in 'UHeap.pas';

{$R *.res}
var
  Ini: TIniFile;
  LibItems: TStringList;

function AppDataPath: string;
var
  Path: array[0..MAX_PATH] of Char;
begin
  if SHGetSpecialFolderPath(Application.Handle, Path, CSIDL_COMMON_APPDATA, False) then
    Result := Path
  else
    Result := '';
end;

function LoadFM(Key: string; Def: String): TFindMode;
begin
  Result := TFindMode(GetEnumValue(TypeInfo(TFindMode),
     Ini.ReadString('findmodes', Key, Def)));
end;

procedure SaveFM(Key: String; Value: TFindMode);
begin
  Ini.WriteString('findmodes', Key,
    GetEnumName(TypeInfo(TFindMode), integer(Value)));
end;

procedure SaveIni;
var
  I: Integer;
begin
  Ini.EraseSection('searchpaths');
  for I := 0 to PrefDlg.ListBox1.Count - 1 do
    Ini.WriteString('searchpaths', PrefDlg.ListBox1.Items[I], '');

  SaveFM('TreeLetter', Default.Choice[vtTree, ctPos]);
  SaveFM('TreeRule',   Default.Choice[vtTree, ctRule]);
  SaveFM('ListLetter', Default.Choice[vtList, ctPos]);
  SaveFM('ListRule',   Default.Choice[vtList, ctRule]);
  SaveFM('ResultLetter', Default.Choice[vtSet, ctPos]);
  SaveFM('ResultRule', Default.Choice[vtSet, ctRule]);
  Ini.WriteBool('misc', 'DeadEnd', poShowDeadend in Default.Options);
  Ini.WriteBool('misc', 'Determ', poShowDeterm in Default.Options);

  Ini.WriteInteger('limits', 'GAniTime', GAniTime);
  Ini.WriteInteger('limits', 'GMaxLength', GMaxLength);
  Ini.WriteInteger('limits', 'GTimeLimit', GTimeLimit);
  Ini.WriteInteger('limits', 'GDbLimit', GDbLimit);
  Ini.WriteInteger('limits', 'GDbInput', GDbInput);
  Ini.WriteInteger('limits', 'GInputpKonfig', GKonfigpInput);
  Ini.WriteInteger('limits', 'GListLimit', GListLimit);
  Ini.WriteInteger('limits', 'GTreeLimit', GTreeLimit);

  Ini.WriteBool('misc', 'GUSpace', GUSpace);
  Ini.WriteBool('misc', 'GTurSpace', GTurSpace);

  Ini.WriteString('fonts', 'mononame', GMonoFont.Name);
  Ini.WriteInteger('fonts', 'monosize', GMonoFont.Size);
  Ini.WriteString('fonts', 'name', GFont.Name);
  Ini.WriteInteger('fonts', 'size', GFont.Size);
  Ini.WriteString('fonts', 'aniname', GAniFont.Name);
  Ini.WriteInteger('fonts', 'anisize', GAniFont.Size);
end;

procedure LoadIni;
var
  I: Integer;
begin
  Ini.ReadSection('searchpaths', LibItems);

  Default.Choice[vtTree, ctPos]  := LoadFM('TreeLetter', 'fmAll');
  Default.Choice[vtTree, ctRule] := LoadFM('TreeRule', 'fmAll');
  Default.Choice[vtList, ctPos]  := LoadFM('ListLetter', 'fmRandom');
  Default.Choice[vtList, ctRule] := LoadFM('ListRule', 'fmRandom');
  Default.Choice[vtSet,  ctPos]  := LoadFM('ResultLetter', 'fmRandom');
  Default.Choice[vtSet,  ctRule] := LoadFM('ResultRule', 'fmRandom');
  Default.Show(Ini.ReadBool('misc', 'DeadEnd', false), swDeadEnd);
  Default.Show(Ini.ReadBool('misc', 'Determ', false), swDeterm);

  GAniTime := Ini.ReadInteger('limits', 'GAniTime', 800);
  GMaxLength := Ini.ReadInteger('limits', 'GMaxLength', 100);
  GTimeLimit := Ini.ReadInteger('limits', 'GTimeLimit', 3000);
  GDbLimit := Ini.ReadInteger('limits', 'GDbLimit', 100);
  GDbInput := Ini.ReadInteger('limits', 'GDbInput', 10);
  GKonfigpInput := Ini.ReadInteger('limits', 'GKonfigpInput', 1000);

  GListLimit := Ini.ReadInteger('limits', 'GListLimit', 500);
  GTreeLimit := Ini.ReadInteger('limits', 'GTreeLimit', 500);

  GUSpace := Ini.ReadBool('misc', 'GUSpace', false);
  GTurSpace := Ini.ReadBool('misc', 'GTurSpace', true);

  if Screen.Fonts.IndexOf('Consolas') = -1 then
    GMonoFont.Name := Ini.ReadString('fonts', 'mononame', 'Courier New')
  else
    GMonoFont.Name := Ini.ReadString('fonts', 'mononame', 'Consolas');

  GMonoFont.Size := Ini.ReadInteger('fonts', 'monosize', 8);
  GFont.Name := Ini.ReadString('fonts', 'name', 'Arial');
  GFont.Size := Ini.ReadInteger('fonts', 'size', 8);


  if Screen.Fonts.IndexOf('Consolas') = -1 then
    GAniFont.Name := Ini.ReadString('fonts', 'mononame', 'Courier New')
  else
    GAniFont.Name := Ini.ReadString('fonts', 'mononame', 'Consolas');

  GAniFont.Size := Ini.ReadInteger('fonts', 'anisize', 20);
end;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  LibItems := TStringList.Create;

  GFont := TFont.Create;
  GMonoFont := TFont.Create;
  GAniFont := TFont.Create;

  DataPath := AppDataPath + '/ProLan';
  MainPath := ExtractFilePath(Application.ExeName);

  if not DirectoryExists(DataPath) then
    CreateDir(DataPath);

  if not FileExists(DataPath + '/settings.ini') then
  begin
    Ini := TIniFile.Create(DataPath + '/settings.ini');
    LoadIni;
    LibItems.Add('lib');
  end
  else
  begin
    Ini := TIniFile.Create(DataPath + '/settings.ini');
    LoadIni;
  end;

  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TPrefDlg, PrefDlg);
  Application.CreateForm(TCardForm, CardForm);
  PrefDlg.ListBox1.Items.Assign(LibItems);


  Application.Run;
  SaveIni;
  SaveLog;
  LibItems.Free;
end.
