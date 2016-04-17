unit UBasPLFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, Grids, TntGrids, UBase, ActnList, Menus, ExtCtrls,
  UTntNiceGrid, StdCtrls, UExeFrm, TntExtCtrls, TntStdCtrls;

type
  TBasPLFrame = class(TFrame)
    sg: TTntNiceGrid;
    PopupMenu1: TPopupMenu;
    ActionList1: TActionList;
    ActionInsertLine: TAction;
    ActionDelLine: TAction;
    SorBeszrs1: TMenuItem;
    SorTrls1: TMenuItem;
    def: TTntNiceGrid;
    TntMemo1: TTntMemo;
    TntSplitter1: TTntSplitter;
    procedure sgKeyPress(Sender: TObject; var Key: Char);
    procedure ActionInsertLineExecute(Sender: TObject);
    constructor Create(AOwner: TComponent); override;
    procedure Button1Click(Sender: TObject);
    procedure TntFrameResize(Sender: TObject);
    procedure defKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ActionDelLineExecute(Sender: TObject);
    procedure TntMemo1Change(Sender: TObject);
    procedure sgKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FModified: Boolean;
    FProgMode: Boolean;
    procedure SetModified(const Value: Boolean);
    function GetModified: Boolean;
    procedure SetProgMode(const Value: Boolean);

    { Private declarations }
  public
    FExeFrame: TExeFrm;
    property ProgMode: Boolean read FProgMode write SetProgMode;
    procedure Clear;
//    procedure Compile(L: TStringList);
    property Modified: Boolean read GetModified write SetModified;
    procedure ToCode(L: TStringList);
    procedure InitSize;
  end;

var
  BasPLFrame: TBasPLFrame;

implementation

{$R *.DFM}

var
  Skip: Boolean;

{ TBasPLFrame }

procedure TBasPLFrame.SetModified(const Value: Boolean);
begin
  sg.FModified := Value;
  def.FModified := Value;
  FModified := Value;
end;

procedure TBasPLFrame.SetProgMode(const Value: Boolean);
begin
  FProgMode := Value;
  if Value then
    sg.ColCount := 5
  else
    sg.ColCount := 2;
  InitSize;
end;

procedure TBasPLFrame.sgKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i: integer;
  B: Boolean;
begin
  Skip := false;
  with sg do
    if Key = 13 then
    begin
      EditorMode := false;
      I := SG.Row + 1;
      InsertRow(I);
      EditCell(I, 0);
      Skip := true;
    end
    else if (Key = 8) then
    begin
      if (Col = 0) then
      begin
        if (Row = 1) then
          // Skip
        else
        begin
          B := true;
          for I := 0 to ColCount - 1 do
            B := B and (Cells[I, Row] = '');
          if B then
          begin
            key := 0;
            EditorMode := false;
            ActionDelLine.Execute;
            Col := ColCount - 1;
  //          if Row <> RowCount - 1 then
            if Row > 0 then
              Row := Row - 1;
            Skip := true;
          end;
        end
      end
      else if Cells[col, row] = '' then
      begin
        Col := Col - 1;
        Key := 0;
        Skip := true;
      end;
    end
  else if (Key = 9) then
  begin
    if (Col = ColCount - 1) and (Row = RowCount - 1) then
    begin
      EditorMode := false;
      I := SG.Row + 1;
      InsertRow(I);
      EditCell(I, 0);
      Key := 0;
      Skip := true;
    end;
  end;
end;

procedure TBasPLFrame.sgKeyPress(Sender: TObject; var Key: Char);
begin
  if Skip then
  begin
    Skip := false;
    Key := #0;
  end;
end;

procedure TBasPLFrame.TntFrameResize(Sender: TObject);
begin
  InitSize;
end;

procedure TBasPLFrame.TntMemo1Change(Sender: TObject);
begin
  FModified := true;
end;

procedure TBasPLFrame.ToCode(L: TStringList);
var
  I, K: Integer;
  Terms, NTerms, S: TStringList;
  Start: String;
  procedure Defs;
  begin
    if not ProgMode then
      L.Add('#pragma grammar');
    L.Add('start ' + Start + ';');
    if NTerms.Count > 0 then
      L.Add('nterm ' + NTerms.DelimitedText + ';');
    if Terms.Count > 0 then
      L.Add('term ' + Terms.DelimitedText + ';');
  end;
  function f(V: WideString): String;
  begin
    S.Clear;
    S.Delimiter := ' ';
    S.DelimitedText := V;
    S.Delimiter := ',';
    Result := S.DelimitedText;
  end;
begin
  S := TStringList.Create;
  L.Clear;
  Terms := TStringList.Create;
  NTerms := TStringList.Create;
  Terms.Duplicates := dupIgnore;
  NTerms.Duplicates := dupIgnore;
  NTerms.Sorted := true;
  Terms.Sorted := true;
  NTerms.Delimiter := ' ';
  Terms.Delimiter := ' ';
  NTerms.CaseSensitive := true;
  Terms.CaseSensitive := true;

  with sg do
  begin
    Start := Trim(def.Cells[0, 1]);
    NTerms.DelimitedText := def.Cells[1, 1];
    Terms.DelimitedText := def.Cells[2, 1];

    NTerms.Delimiter := ',';
    Terms.Delimiter := ',';

    Defs;
    L.Add('void main()');
    if ProgMode then
    begin
      L.Add('{');
      for I := 1 to RowCount - 1 do
      begin
        L.Add(Cells[0, I] + ': '
          + 'if (' + Cells[1, I] + '=' + Cells[2, I] + ') '
          + f(Cells[3, I]) + '; else ' + f(Cells[4, I]) + ';');
      end;
      L.Add('}');
    end
    else
    begin
      L.Add('[');
      for I := 1 to RowCount - 1 do
      begin
        L.Add(Cells[0, I] + '=' + Cells[1, I] + ';');
      end;
      L.Add(']');
    end;
  end;

  Terms.Free;
  NTerms.Free;
  S.Free;
end;

procedure TBasPLFrame.ActionDelLineExecute(Sender: TObject);
var
  K: Integer;
begin
  SG.EditorMode := false;
  K := SG.Row;
  Sg.DeleteRow(K);
  if (K > 0) and (K = sg.RowCount - 1) then
    K := K - 1;
end;

procedure TBasPLFrame.ActionInsertLineExecute(Sender: TObject);
begin
  SG.InsertRow(SG.Row);
end;

procedure TBasPLFrame.Button1Click(Sender: TObject);
begin
  def.EditCell(1,0);
  sg.EditCell(1,0);
end;

procedure TBasPLFrame.Clear;
begin
  SG.RowCount := 2;
  SG.RowHeights[0] := 20;
  if ProgMode then
  begin
    SG.Rows[0].Clear;
    SG.Rows[0].Add('ID');
    SG.Rows[0].Add('Left');
    SG.Rows[0].Add('Right');
    SG.Rows[0].Add(gsig);
    SG.Rows[0].Add(gfi);
  end
  else
  begin
    SG.Rows[0].Clear;
    SG.Rows[0].Add('Left');
    SG.Rows[0].Add('Right');
  end;
//  TntMemo1.Lines.Clear;
//  TntMemo1.Lines.Add('Leírás:');
  TntMemo1.Text := 'Description:';
end;

constructor TBasPLFrame.Create(AOwner: TComponent);
begin
  inherited;
  ProgMode := true;
  def.Cells[0, 0] := 'Start symbol';
  def.Cells[1, 0] := 'Nonterminals';
  def.Cells[2, 0] := 'Terminals';
  def.HideSelection;
  sg.HideSelection;
end;

procedure TBasPLFrame.defKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_TAB) and (def.Col = 2) then
  begin
//    sg.Selection := TGridRect(Rect(0, 0, 0, 0));
//    sg.EditCell(0, 1);
//    sg.HideSelection;
    sg.SetFocus;
    sg.Row := 1;
    sg.Col := 0;
    sg.EditorMode := true;
  end;
end;

function TBasPLFrame.GetModified: Boolean;
begin
  Result := sg.FModified or def.FModified or FModified;
end;

procedure TBasPLFrame.InitSize;
var
  D: Integer;
  X, Y: Integer;
  I: Integer;
  f: array[0..4] of integer;
begin
  D := def.Width div 3 - 1;
  def.Selection := TGridRect(Rect(0, 0, 0, 0));

  def.ColWidths[0] := D;
  def.ColWidths[1] := D;
  def.ColWidths[2] := Width - (def.ColWidths[0] + def.ColWidths[1] + 6);
  def.HideSelection;
  def.EditorMode := false;
//  def.Refresh;

  sg.Selection := TGridRect(Rect(0, 0, 0, 0));
  if PRogMode then
  begin
    X := 0;
    Y := 0;
    f[0] := 2; f[1] := 3; f[2] := 5; f[3] := 5; f[4] := 5;
    for I := 0 to 4 do
      X := X + f[I];
    for I := 0 to 3 do
    begin
      f[I] := trunc(Width * f[I] / X);
      Y := Y + f[I];
    end;
    f[4] := Width - Y - 8;

    sg.ColWidths[0] := f[0];
    sg.ColWidths[1] := f[1];
    sg.ColWidths[2] := f[2];
    sg.ColWidths[3] := f[3];
    sg.ColWidths[4] := f[4];
  end
  else
  begin
    D := sg.Width div 3 - 2;
    sg.ColWidths[0] := D;
    sg.ColWidths[1] := Width - sg.ColWidths[0] - 5;
  end;
  sg.HideSelection;
  sg.EditorMode := false;
end;

end.