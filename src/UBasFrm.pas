unit UBasFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, UBase, UBasPLFrm, URunFrm, ExtCtrls, UExeFrm;

type
  TBasFrm = class(TExeFrm)
    runf: TRunFrm;
    blf: TBasPLFrame;
    Splitter1: TSplitter;
    SaveDialog1: TSaveDialog;
  private
    FTableWidth, FRunWidth: Integer;
    FIsFullView: Boolean;
  protected
    Lines: TStringList;
    FProgMode: Boolean;
    FModified: Boolean;
    procedure SetProgMode(const Value: Boolean);
    function GetProgMode: Boolean;
    procedure SetFileName(const Value: WideString); override;
    function GetModified: Boolean; override;
    procedure SetModified(const Value: Boolean); override;
    procedure SetView(A, B: Integer);
    procedure StoreView;
  published
  public
    procedure FullView(O: TObject);
    procedure NormalView;
    property IsFullView: Boolean read FIsFullView;
    procedure RefreshFont; override;
    property ProgMode: Boolean read GetProgMode write SetProgMode;
    procedure Clear; override;
    procedure Run; override;
    procedure Deselect; override;
    procedure SelectRule(C: TEBasLine); override;
    procedure SaveToFile(S: WideString = ''); override;
    procedure LoadFromFile(S: WideString); override;
    procedure Close; override;
    property Modified: Boolean read GetModified write SetModified;
    function SaveDialog: Boolean; override;
    procedure AfterConstruction; override;
    function Compile(L: TStringList): Boolean;
    function GetMode(P: TEProgram): Integer;
    procedure SelectMode(M: TProgType; P: Boolean);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  BasFrm: TBasFrm;

implementation

{$R *.DFM}

{ TBasFrame }

procedure TBasFrm.Afterconstruction;
begin
  inherited;
  Clear;
end;

procedure TBasFrm.Clear;
begin
  blf.Clear;
  runf.Clear;
  FreeAndNil(FEProgram);
end;

procedure TBasFrm.Close;
begin

end;

function TBasFrm.Compile(L: TStringList): Boolean;
begin
  Result := UBase.Compile(L, FEProgram) = 0;
//  SelectMode(ptGrammar, Result);
//
//  case UBase.Compile(L, FEProgram) of
//    0:
//    begin
//      Result := true;
////      case GetMode(FEProgram) of
////        0: Result := false; // Makro
////        1: ProgMode := false;
////        2: ProgMode := true;
////      end;
//    end;
//    1:
//    begin
//      Result := false;
//    end;
//    2:
//    begin
//      Result := false;
//    end
//    else
//  end;
end;

constructor TBasFrm.Create(AOwner: TComponent);
begin
  inherited;
  Lines := TStringList.Create;
  blf.FExeFrame := Self;
  runf.FExeFrame := Self;

  SaveDialog1.Filter := 'ProLan Files|*.gr|All Files|*.*';
  SaveDialog1.FilterIndex := 1;
  SaveDialog1.DefaultExt := 'gr';
end;

procedure TBasFrm.Deselect;
begin

end;

destructor TBasFrm.Destroy;
begin
  Lines.Free;
  inherited;
end;

procedure TBasFrm.FullView(O: TObject);
  procedure F(A, B: Integer);
  begin
    FIsFullView := true;
    SetView(A, B);
  end;
begin
  if (O = nil) or FIsFullView then
    exit
  else if O is TRunFrm then
    F(0, Width)
  else if O is TBasPLFrame then
    F(Width, 0)
  else if O is TComponent then
    FullView(TComponent(O).Owner);
end;

function TBasFrm.GetModified: Boolean;
begin
  Result := blf.Modified;
end;

function TBasFrm.GetProgMode: Boolean;
begin
  Result := blf.ProgMode;
end;

procedure TBasFrm.LoadFromFile(S: WideString);
var
  F: TFileStream;
  B: Boolean;
begin
  F := TFileStream.Create(S, fmOpenRead);
  F.Read(B, Sizeof(Boolean));
  ProgMode := B;
  blf.def.LoadFromStream(F);
  blf.sg.LoadFromStream(F);
  blf.TntMemo1.Lines.LoadFromStream(F);
  F.Free;
  FileName := S;
  Modified := false;
end;

procedure TBasFrm.NormalView;
begin
  FIsFullView := false;
  SetView(FTableWidth, FRunWidth);
end;

procedure TBasFrm.RefreshFont;
begin
//  blf.def.Font := GFont;
//  blf.sg.Font := GFont;
//  blf.TntMemo1.Font := GFont;
  RunF.RefreshFont;
end;

procedure TBasFrm.Run;
begin
//  GGrammar := true;
  Lines.Clear;
  blf.ToCode(Lines);
  runf.Clear;
  FreeAndNil(FEProgram);
  Compile(Lines);
  runf.Run;
end;

function TBasFrm.SaveDialog: Boolean;
begin
  if FileName = '' then
    SaveDialog1.FileName := Caption + '.gr'
  else
  begin
    SaveDialog1.InitialDir := ExtractFilePath(FileName);
    SaveDialog1.FileName := ExtractFileName(FileName);
  end;

  Result := SaveDialog1.Execute;
  if Result then
    SaveToFile(SaveDialog1.FileName);
end;

procedure TBasFrm.SaveToFile(S: WideString);
var
  F: TFileStream;
  K: Integer;
begin
  if S = '' then
    S := FFileName;
  F := TFileStream.Create(S, fmCreate);
  F.Write(blf.ProgMode, Sizeof(Boolean));
  blf.def.SaveToStream(F);
  blf.sg.SaveToStream(F);
  blf.TntMemo1.Lines.SaveToStream(F);
  F.Free;
  SetFileName(S);
  Modified := false;
end;

procedure TBasFrm.SelectRule(C: TEBasLine);
begin

end;

procedure TBasFrm.SetFileName(const Value: WideString);
begin
  FFileName := Value;
end;

procedure TBasFrm.SetModified(const Value: Boolean);
begin
  blf.Modified := Value;
end;

function TBasFrm.GetMode(P: TEProgram): Integer;
begin
  try
    if P.Count = 0 then
      Result := -1 // Hiba
    else if P.Count > 1 then
      Result := 0 // Makró
    else if P.SProgram.Main.Block is TSParBlock then
      Result := 1 // Sima nyelvtan
    else
      Result := 2; // Programozott nyelvtan
  except
    Result := -1;
  end;
end;

procedure TBasFrm.SetProgMode(const Value: Boolean);
begin
  blf.ProgMode := Value;
end;

procedure TBasFrm.SetView(A, B: Integer);
begin
  StoreView;
  blf.Left := 0;
  blf.Width := A;
  Splitter1.Left := blf.Left + blf.Width;
  runf.Left := Splitter1.Left + Splitter1.Width;
  runf.Width := B;
end;

procedure TBasFrm.StoreView;
begin
  FTableWidth := blf.Width;
  FRunWidth := runf.Width;
end;

procedure TBasFrm.SelectMode(M: TProgType; P: Boolean);
begin
  ProgMode := P;
  runf.SelectMode(M);
end;

end.