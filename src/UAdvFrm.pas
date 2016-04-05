unit UAdvFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, ExtCtrls, URunFrm, UPlFrm, UCodeFrm, UBase, UExeFrm, Menus;

const
//  sablon = 'sablon.prl';
//  cautoload = '';
  DefFileName = 'Névtelen.prl';

type
  TAdvFrm = class(TExeFrm)
    CodeFrm1: TCodeFrm;
    PlFrm1: TPlFrm;
    RunFrm1: TRunFrm;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    SaveDialog1: TSaveDialog;
  private
    FIsFullView: Boolean;
    FCodeWidth, FPLWidth, FRunWidth: Integer;
    procedure SetModified(const Value: Boolean); override;
    function GetModified: Boolean; override;
    procedure SetView(A, B, C: Integer);
    procedure StoreView;
  public
    procedure FullView(O: TObject);
    procedure NormalView;
    property IsFullView: Boolean read FIsFullView;

    procedure RefreshFont; override;
    procedure PLFrm1Changed(Sender: TObject);
    procedure SelectMode(M: TProgType);
    procedure RunFrm1ConfigChanged(Sender: TObject);
    procedure Deselect; override;
    procedure LoadFromFile(S: WideString); override;
    procedure SaveToFile(S: WideString = ''); override;
    function SaveDialog: Boolean; override;
    procedure Clear; override;
    procedure Run; override;
    procedure Compile(L: TStringList);
    procedure Close; override;
    procedure SelectRule(C: TEBasLine); override;
    property Modified: Boolean read GetModified write SetModified;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  AdvFrm: TAdvFrm;

implementation

uses
  ComCtrls, UGrammar, UTuring, UPushDown, UMainForm;

{$R *.DFM}

{ TAdvFrame }

procedure TAdvFrm.Clear;
begin
  if CodeFrm1 <> nil then
    CodeFrm1.Clear;
  if plFrm1 <> nil then
    plFrm1.Clear;
  if RunFrm1 <> nil then
    RunFrm1.Clear;
  FreeAndNil(FEProgram);
  SetFileName(DefFileName);
end;

procedure TAdvFrm.Close;
begin
//  if Modified then
//  case MessageDlg('Menti a változásokat: ' + GetFileName + '?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
//    mrYes:
//      begin
//        if FileSaveAs1.Execute then
//          ClearAll;
//      end;
//    mrCancel: exit;
//    mrNo: ClearAll;
//  end
//else
//  ClearAll;
end;

procedure TAdvFrm.PLFrm1Changed(Sender: TObject);
var
  S: WideString;
begin
  if (PLFrm1.Line = nil) or (PLFrm1.Line.SLine = nil) then
    CodeFrm1.SelectLine(-1, clNone)
  else
  begin
    S := PLFrm1.Line.SLine.FileName;
    if (S <> '') and (S <> tempfile1) then
    begin
      CodeFrm1.SelectLine(-1, clNone);
      if (MainForm.PageFrame1 <> nil) then
      with MainForm.PageFrame1.lbLog do
      begin
        Items.Add(S + '(' + IntToStr(PLFrm1.Line.SLine.LineNo) + ')');
        Selected[Count - 1] := true;
      end;
    end
    else
      CodeFrm1.SelectLine(PLFrm1.Line.SLine.LineNo, SelectedColor );
  end;
end;

procedure TAdvFrm.Compile(L: TStringList);
var
  M: TListItems;
  EL: Integer;
begin
  M := PlFrm1.ListView1.Items;
  case UBase.Compile(L, FEProgram) of
    0:
    begin
      if EProgram is TEGrammar then
        SelectMode(ptGrammar)
      else if EProgram is TEPushDown then
        SelectMode(ptPushDown)
      else if EProgram is TETuring then
        SelectMode(ptTuring);

      EProgram.ToListView(PlFrm1.ListView1);
      EProgram.GetDefinition(PlFrm1.TntMemo1.Lines);
    end;
    1:
      M.Clear;
    2:
      M.Clear;
  end;
end;

constructor TAdvFrm.Create(AOwner: TComponent);
begin
  inherited;
  RunFrm1.FExeFrame := Self;
  PlFrm1.FAdvFrame := Self;
  CodeFrm1.FAdvFrame := Self;

  SaveDialog1.Filter := 'ProLan Files|*.pla|All Files|*.*';
  SaveDialog1.FilterIndex := 1;
  SaveDialog1.DefaultExt := 'pla';

  RunFrm1.OnConfigChanged := RunFrm1ConfigChanged;
  RunFrm1.lvList.DoubleBuffered := true;
  PLFrm1.OnChanged := PLFrm1Changed;
end;

procedure TAdvFrm.Deselect;
begin
  RunFrm1.Deselect;
end;

destructor TAdvFrm.Destroy;
begin
  FreeAndNil(FEProgram);
  inherited;
end;

procedure TAdvFrm.FullView(O: TObject);
  procedure F(A, B, C: Integer);
  begin
    FIsFullView := true;
    SetView(A, B, C);
  end;
begin
  if (O = nil) or FIsFullView then
    exit
  else if O is TRunFrm then
    F(0, 0, Width)
  else if O is TCodeFrm then
    F(Width, 0, 0)
  else if O is TPLFrm then
    F(0, Width, 0)
  else if O is TComponent then
    FullView(TComponent(O).Owner);
end;

procedure TAdvFrm.LoadFromFile(S: WideString);
begin
  if FileExists(S) then
  begin
    Clear;
    CodeFrm1.Memo1.Lines.LoadFromFile(S);
    CodeFrm1.Modified := false;
    FileName := S;
  end;
end;

procedure TAdvFrm.NormalView;
begin
  FIsFullView := false;
  SetView(FCodeWidth, FPLWidth, FRunWidth);
end;

function TAdvFrm.GetModified: Boolean;
begin
  Result := CodeFrm1.Modified;
end;

procedure TAdvFrm.RefreshFont;
begin
  RunFrm1.RefreshFont;
  CodeFrm1.Font := GMonoFont;
end;

procedure TAdvFrm.Run;
var
  L: TStringList;
  I: Integer;
begin
  LogF.Add('AdvFrm Run');
  L := TStringList.Create;
  for I := 0 to CodeFrm1.Memo1.Lines.Count - 1 do
    L.Add(CodeFrm1.Memo1.Lines[I]);
  plFrm1.Clear;
  RunFrm1.Clear;
  FreeAndNil(FEProgram);
  Compile(L);
  RunFrm1.Run;
end;

procedure TAdvFrm.RunFrm1ConfigChanged(Sender: TObject);
var
  C: TConfig;
begin
  C := RunFrm1.Config;
  if C = nil then
    SelectRule(nil)
  else
    if C is TTConfig then
    begin
      if TTConfig(C).Items.Count > 0 then
        SelectRule(TTConfig(C.Items[0]).Rule)
      else
        SelectRule(C.Line);
    end
    else
      SelectRule(C.Line);
end;

function TAdvFrm.SaveDialog: Boolean;
begin
  if FileName = '' then
    SaveDialog1.FileName := Caption + '.pla'
  else
  begin
    SaveDialog1.InitialDir := ExtractFilePath(FileName);
    SaveDialog1.FileName := ExtractFileName(FileName);
  end;

  Result := SaveDialog1.Execute;
  if Result then
    SaveToFile(SaveDialog1.FileName);
end;

procedure TAdvFrm.SaveToFile(S: WideString = '');
begin
  if S = '' then
    S := FFileName;
  CodeFrm1.Memo1.Lines.SaveToFile(S);
  SetFileName(S);
//  SetCaption(ExtractFileName(S));
  Modified := false;
end;

procedure TAdvFrm.SelectMode(M: TProgType);
begin
  RunFrm1.SelectMode(M);
  PlFrm1.SelectMode(M);
end;

procedure TAdvFrm.SelectRule(C: TEBasLine);
begin
  PlFrm1.Select(C);
end;

procedure TAdvFrm.SetModified(const Value: Boolean);
begin
  CodeFrm1.Modified := Value;
end;

procedure TAdvFrm.SetView(A, B, C: Integer);
begin
  StoreView;
  CodeFrm1.Left := 0;
  CodeFrm1.Width := A;
  Splitter1.Left := CodeFrm1.Left + CodeFrm1.Width;
  PlFrm1.Left := Splitter1.Left + Splitter1.Width;
  PLFrm1.Width := B;
  Splitter2.Left := PLFrm1.Left + PLFrm1.Width;
  RunFrm1.Left := Splitter2.Left + Splitter2.Width;
  RunFrm1.Width := C;
end;

procedure TAdvFrm.StoreView;
begin
  FCodeWidth := CodeFrm1.Width;
  FPLWidth := PLFrm1.Width;
  FRunWidth := RunFrm1.Width;
end;

end.