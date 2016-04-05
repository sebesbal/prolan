unit UTntNiceGrid;

interface

uses
  SysUtils, Classes, Controls, Grids, TntGrids, Messages, Types;

type
  PTextFile = ^TextFile;
  TTntNiceGrid = class(TTntStringGrid)
  public
    FModified: Boolean;
    procedure InsertRow(N: Integer);
    procedure DeleteRow(N: Integer);
    procedure EditCell(X, Y: Integer);
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
    procedure Click; override;
    procedure HideSelection;
    constructor Create(AOwner: TComponent); override;
    procedure MOnEnter(Sender: TObject);
    procedure MOnExit(Sender: TObject);
    procedure SaveToStream(S: TStream);
    procedure LoadFromStream(S: TStream);
    function SelectCell(ACol, ARow: Longint): Boolean; override;
    procedure SetEditText(ACol, ARow: Longint; const Value: WideString); override;
  end;

procedure Register;

implementation

uses
  Graphics, Windows, Math;

procedure Register;
begin
  RegisterComponents('Tnt Standard', [TTntNiceGrid]);
end;

{ TTntNiceGrid }

procedure GradVertical(Canvas: TCanvas; Rect:TRect; FromColor, ToColor:TColor) ;
var
  Y:integer;
  dr,dg,db:Extended;
  C1,C2:TColor;
  r1,r2,g1,g2,b1,b2:Byte;
  R,G,B:Byte;
  cnt:Integer;
begin
   C1 := FromColor;
   R1 := GetRValue(C1) ;
   G1 := GetGValue(C1) ;
   B1 := GetBValue(C1) ;

   C2 := ToColor;
   R2 := GetRValue(C2) ;
   G2 := GetGValue(C2) ;
   B2 := GetBValue(C2) ;

   dr := (R2-R1) / Rect.Bottom-Rect.Top;
   dg := (G2-G1) / Rect.Bottom-Rect.Top;
   db := (B2-B1) / Rect.Bottom-Rect.Top;

   cnt := 0;
   for Y := Rect.Top to Rect.Bottom-1 do
   begin
      R := R1 + Ceil(dr * cnt) ;
      G := G1 + Ceil(dg * cnt) ;
      B := B1 + Ceil(db * cnt) ;

      Canvas.Pen.Color := RGB(R,G,B) ;
      Canvas.MoveTo(Rect.Left,Y) ;
      Canvas.LineTo(Rect.Right,Y) ;
      Inc(cnt) ;
   end;
end;

{ TTntNiceGrid }

procedure TTntNiceGrid.Click;
begin
  EditorMode := true;
  inherited;
end;

procedure TTntNiceGrid.EditCell(X, Y: Integer);
begin
  Col := Y;
  Row := X;
  EditorMode := true;
  keybd_event(VK_Right, 1,0,0);
  keybd_event(VK_LEft, 1,0,0);
//  keybd_event(VK_SPACE, 1,0,0);
//  keybd_event(VK_BACK, 1,0,0);
end;


procedure TTntNiceGrid.HideSelection;
var
  R: TGridRect;
begin
  R.Left := -1;
  R.Top := -1;
  R.Bottom := -1;
  R.Right := -1;
  Selection := R;
end;

procedure TTntNiceGrid.InsertRow(N: Integer);
var
  I: Integer;
begin
  RowCount := RowCount + 1;
  for I := RowCount - 1 downto N + 1 do
    Rows[I].Assign(Rows[I - 1]);
  Rows[N].Clear;
end;

procedure TTntNiceGrid.LoadFromStream(S: TStream);
var
  I, J, K: Integer;
  SW: WideString;
begin
  S.Read(I, SizeOf(RowCount));
  S.Read(J, SizeOf(ColCount));
  RowCount := I;
  ColCount := J;
  for I := 0 to RowCount - 1 do
    for J := 0 to ColCount - 1 do
    begin
      S.ReadBuffer(K, SizeOf(Integer));
      SetString(SW, nil, K div SizeOf(WideChar));
      S.Read(Pointer(SW)^, K);
      Cells[J, I] := SW;
    end;
end;

procedure TTntNiceGrid.MOnEnter(Sender: TObject);
begin
  Selection := TGridRect(Rect(0, 1, 0, 1));
//  EditCell(1,0);
end;

procedure TTntNiceGrid.MOnExit(Sender: TObject);
begin
  EditorMode := false;
  HideSelection;
end;

function TTntNiceGrid.SelectCell(ACol, ARow: Integer): Boolean;
begin
  if ARow = 0 then
    Result := false
  else
    Result := inherited SelectCell(ACol, ARow);
end;

procedure TTntNiceGrid.SetEditText(ACol, ARow: Integer;
  const Value: WideString);
begin
  inherited;
  FModified := True;
end;

procedure TTntNiceGrid.SaveToStream(S: TStream);
var
  I, J, K: Integer;
  SW: WideString;
begin
  S.Write(RowCount, SizeOf(RowCount));
  S.Write(ColCount, SizeOf(ColCount));
  for I := 0 to RowCount - 1 do
    for J := 0 to ColCount - 1 do
    begin
      SW := Cells[J, I];
      K := length(SW) * SizeOf(WideChar);
      S.WriteBuffer(K, SizeOf(Integer));
      S.WriteBuffer(PWideChar(SW)^, Length(SW) * SizeOf(WideChar));
    end;
end;

constructor TTntNiceGrid.Create(AOwner: TComponent);
begin
  inherited;
  Options := Options + [goAlwaysShowEditor];
  OnEnter := MOnEnter;
  OnExit := MOnExit;
  FixedRows := 0;
end;

procedure TTntNiceGrid.DeleteRow(N: Integer);
var
  I: Integer;
begin
  for I := N to RowCount - 2 do
    Rows[I].Assign(Rows[I + 1]);
  RowCount := RowCount - 1;
end;

procedure TTntNiceGrid.DrawCell(ACol, ARow: Integer; ARect: TRect;
  AState: TGridDrawState);
var
  S: WideString;
  SavedAlign: word;
  ws: array[0..200] of WideChar;
  I: Integer;
begin
  if length(S) > 200 then
    exit;
  S := Cells[ACol, ARow]; // cell contents
  for I := 1 to length(S) do
    ws[I - 1] := S[I];
  ws[length(S)] := #0;

  Canvas.FillRect(ARect);
  if ARow = 0 then
    GradVertical(Canvas, ARect, clWhite, $00D6D6D6);
//  else


  SavedAlign := SetTextAlign(Canvas.Handle, TA_CENTER);
  Canvas.Brush.Style := bsClear;
  TextOutW(Canvas.Handle, ARect.Left + (ARect.Right - ARect.Left) div 2,
    ARect.Top + 3, @ws[0], length(S));
  SetTextAlign(Canvas.Handle, SavedAlign);
end;

end.
