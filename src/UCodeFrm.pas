unit UCodeFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, UBase, UExeFrm, ActnList;

type
  TCodeMemo = class(TMemo)
  protected
    FSelectedLine: Integer;
    FLineColor: TColor;
    procedure SetSelectedLine(const Value: Integer);
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure SetLineColor(const Value: TColor);
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    property LineColor: TColor read FLineColor write SetLineColor;
    property SelectedLine: Integer read FSelectedLine write SetSelectedLine;
  end;


  TCodeFrm = class(TFrame)
    ActionList1: TActionList;
    DeleteLine: TAction;
    procedure DeleteLineExecute(Sender: TObject);
  public
    FAdvFrame: TExeFrm;
    Modified: Boolean;
    Memo1: TCodeMemo;
    procedure Clear;
  published
    procedure Memo1OnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Memo1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Memo1OnClick(Sender: TObject);
    procedure SelectLine(L: Integer; C: TColor);
    procedure Memo1Change(Sender: TObject);
    procedure Memo1KeyPress(Sender: TObject; var Key: Char);
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  UMainForm, TntGraphics;

{$R *.dfm}

procedure CaretPos2(H: THandle; var L,C : Word);
begin
  L := SendMessage(H,EM_LINEFROMCHAR,-1,0);
  C := LoWord(SendMessage(H,EM_GETSEL,0,0)) - SendMessage(H,EM_LINEINDEX,-1,0);
end;

procedure TCodeMemo.KeyDown(var Key: Word; Shift: TShiftState);
var
  I, K, Lin, Col: Word;
  S, V: String;
begin
  if (Key = 89) and (ssCtrl in Shift) then
  begin
//    Caretpos(Memo1.Handle, Lin, Col);
//    Memo1.Lines.Delete(Lin);
  end
  else if Key = VK_RETURN then
  begin
    inherited;
//    Caretpos2(Handle, Lin, Col);
//    S := Lines[Lin];
//
//    if Lin = 0 then
//      exit;
//
////    V := Copy(S, Col, length(S) - Col + 1);
////    Lines.Insert(Lin, V);
//    K := 0;
//    while (length(S) > K) and (S[K + 1] = #9) do
//      Inc(K);
//
//    S := '';
//    for I := 1 to K do
//      S := S + #9;
//
//    Lines[Lin + 1] := S + Lines[Lin + 1];
//    for I := 0 to Lin do
//      K := K + length(Lines[I]) + 2 ;
//
//    SelStart := K;
  end
  else
    inherited;
end;

procedure TCodeMemo.SetLineColor(const Value: TColor);
begin
  FLineColor := Value;
end;

procedure TCodeMemo.SetSelectedLine(const Value: Integer);
begin
  FSelectedLine := Value;
end;

procedure TCodeMemo.WMPaint(var Message: TWMPaint);
var
  MCanvas: TControlCanvas; 
  DrawBounds : TRect;
  D: Integer;
  ScrollInfo: TScrollInfo;
  DY: Integer;
begin
  inherited;
  if FSelectedLine < 1 then
    exit;

  MCanvas := TControlCanvas.Create;
  try
    MCanvas.Control := Self;
    MCanvas.Font := Self.Font;
    D := WideCanvasTextExtent(MCanvas, 'A').cy;
    DrawBounds := ClientRect;
    ScrollInfo.fMask := SIF_POS;
    if GetScrollInfo(Self.Handle, SB_VERT, ScrollInfo) then
    DY := ScrollInfo.nPos;
    DrawBounds.Left := DrawBounds.Left + 1;
    DrawBounds.Right := DrawBounds.Right - 1;
    DrawBounds.Top := ClientRect.Top + D * (FSelectedLine - 1 - DY);
    DrawBounds.Bottom := DrawBounds.Top + D;

    with MCanvas do
    begin
      Pen.Mode    := pmMask;
      Brush.Style := bsSolid;
      Brush.Color := LineColor;
      Pen.Color := Brush.Color;
      Pen.Width   := 0;
      Rectangle(DrawBounds);
    end;
  finally
    MCanvas.Free;
  end;
end;

procedure TCodeFrm.DeleteLineExecute(Sender: TObject);
var
  Lin, Col: Word;
begin
  Caretpos2(Memo1.Handle, Lin, Col);
  Memo1.Lines.Delete(Lin);
end;

procedure TCodeFrm.Clear;
begin
  Memo1.Clear;
end;

constructor TCodeFrm.Create(AOwner: TComponent);
begin
  inherited;
  DoubleBuffered := true;
  Memo1 := TCodeMemo.Create(Self);
  Memo1.ControlStyle := Memo1.ControlStyle + [csOpaque];

  Memo1.DoubleBuffered := true;
  Memo1.Parent := Self;
  Memo1.Align := alClient;
  Memo1.OnClick := Memo1OnClick;
  Memo1.OnMouseDown := Memo1OnMouseDown;
  Memo1.OnChange := Memo1Change;
  Memo1.OnKeyUp := Memo1KeyDown;
  Memo1.ScrollBars := ssVertical;
  Memo1.TabStop := false;
//  Memo1.WantReturns := true;
  Memo1.WantTabs := true;
  Memo1.WordWrap := false;
end;

procedure TCodeFrm.Memo1Change(Sender: TObject);
begin
  Modified := true;
end;

procedure TCodeFrm.Memo1KeyPress(Sender: TObject; var Key: Char);
begin
end;

procedure TCodeFrm.Memo1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I, K, Lin, Col: Word;
  S: String;
begin
  if Memo1.SelectedLine <> -1 then
  begin
    Memo1.SelectedLine := -1;
    Memo1.Refresh;
  end;
  if (Key = 89) and (ssCtrl in Shift) then
  begin
//    Caretpos(Memo1.Handle, Lin, Col);
//    Memo1.Lines.Delete(Lin);
  end
  else if Key = VK_RETURN then
  begin
    Caretpos2(Memo1.Handle, Lin, Col);

    if Lin = 0 then
      exit;
    S := Memo1.Lines[Lin - 1];
    K := 0;
    while (length(S) > K) and (S[K + 1] = #9) do
      Inc(K);

    S := '';
    for I := 1 to K do
      S := S + #9;

    Memo1.Lines[Lin] := S + Memo1.Lines[Lin];
    for I := 0 to Lin - 1 do
      K := K + length(Memo1.Lines[I]) + 2 ;

    Memo1.SelStart := K;
  end;
end;

procedure TCodeFrm.Memo1OnClick(Sender: TObject);
begin
  if Memo1.SelectedLine <> -1 then
  begin
    Memo1.SelectedLine := -1;
    Memo1.Refresh;
  end;
end;

procedure TCodeFrm.Memo1OnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Line, Col: Word;
begin
  CaretPos2(Memo1.Handle, Line, Col);
  MainForm.PageFrame1.SetCursor(Line , Col);
end;

procedure TCodeFrm.SelectLine(L: Integer; C: TColor);
begin
  if (L <> Memo1.FSelectedLine) or (Memo1.LineColor <> C) then
  begin
    Memo1.SetSelectedLine(L);
    Memo1.LineColor := C;
    Memo1.Refresh;
  end;
end;

end.
