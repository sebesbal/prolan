unit URunFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, TntComCtrls, StdCtrls, TntStdCtrls, UBase, UExeFrm, UAniFrm,
  ExtCtrls, TntExtCtrls, Menus, ToolWin, ImgList;

type
  TRunFrm = class(TFrame)
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    procedure Kibont51Click(Sender: TObject);
    procedure Kibont101Click(Sender: TObject);
    procedure Kibont201Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
  private
    procedure Kibont(Node: TTntTreeNode; N: Integer; Rec: Boolean = false);
  public
    FMode: TProgType;
    FExeFrame: TExeFrm;
    FConfig: TConfig;
    FOnConfigChanged: TNotifyEvent;
    procedure SetOnConfigChanged(const Value: TNotifyEvent);
    procedure SetConfig(const Value: TConfig);
    procedure SelectConfig(C: TConfig);
    procedure RefreshFont;
    procedure Clear;
    procedure Deselect;
    procedure Run;
  published
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    lvList: TTntListView;
    cmbRules: TTntComboBox;
    btnOK: TButton;
    TabSheet1: TTabSheet;
    TreeView1: TTntTreeView;
    TabSheet3: TTabSheet;
    lvLang: TTntListView;
    cmbLetter: TTntComboBox;
    AniFrm1: TAniFrm;
    TntSplitter1: TTntSplitter;
    btnTovabb: TButton;
    procedure lvLangCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure TreeView1AdvancedCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
      var PaintImages, DefaultDraw: Boolean);
    procedure TreeView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lvListAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure lvListAdvancedCustomDraw(Sender: TCustomListView;
      const ARect: TRect; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure SelectAnItem;
    procedure btnTovabbClick(Sender: TObject);
    procedure AniFrm1ToolButton1Click(Sender: TObject);
    property Config: TConfig read FConfig write SetConfig;
    property OnConfigChanged: TNotifyEvent read FOnConfigChanged write SetOnConfigChanged;
    procedure SelectMode(M: TProgType);
    procedure PageControl1Change(Sender: TObject);
    procedure lvListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure btnOKClick(Sender: TObject);
    procedure cmbLetterChange(Sender: TObject);
    procedure cmbRulesChange(Sender: TObject);
    procedure TreeView1Expanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure AfterConstruction; override;
    procedure AniFrm1Changed(Sender: TObject);
  end;

implementation

uses UMainForm, UGrammar, TNTGraphics, CommCtrl, UTuring, UPushDown;

{$R *.dfm}

var
  Matrix: TCMatrix;
  Bmp: TBitmap;
  DroppingDown: Boolean;
  ListDX, ListWidth: Integer;

const
  RowHeight = 15;
  TopDif = 2;
  LeftDif = 7;

function HideColor: Boolean;
begin
  Result := not GColors;
end;

procedure DrawBuff(S: TESentence; C: TCanvas; R: TRect; Selected: Boolean; Color: TColor = clRed);
var
  W, H: Integer;
  R1: TRect;
  CP: TCanvas;
begin
  W := R.Right - R.Left;
  H := R.Bottom - R.Top;
  if (Bmp.Width <> W) or (Bmp.Height <> H) then
    Bmp.SetSize(W, H);
  R1 := Rect(0, 0, W, H);
  Bmp.Transparent := true;
  Bmp.TransparentMode := tmFixed;
  CP := Bmp.Canvas;
  CP.Font := C.Font;

  if Selected then
  begin
    Bmp.TransparentColor := SelectedColor;
    CP.Brush.Color := SelectedColor;
  end
  else
  begin
    Bmp.TransparentColor := clWhite;
    CP.Brush.Color := clWhite;
  end;

  CP.Brush.Style := bsSolid;
  CP.FillRect(R1);
  CP.Brush.Style := bsClear;
  S.Draw(CP, 1, 1, Color);
  C.Brush.Style := bsClear;
  C.Draw(R.Left, R.Top, Bmp);
end;

procedure DrawBuff2(L: TConfig; C: TCanvas; R: TRect; Selected: Boolean; Color: TColor = clRed);
var
  W, H: Integer;
  R1: TRect;
  CP: TCanvas;
begin
  W := R.Right - R.Left;
  H := R.Bottom - R.Top;
  if (Bmp.Width <> W) or (Bmp.Height <> H) then
    Bmp.SetSize(W, H);
  R1 := Rect(0, 0, W, H);
  CP := Bmp.Canvas;
  CP.Font := C.Font;
  Bmp.Transparent := true;
  Bmp.TransparentMode := tmFixed;
  if Selected then
  begin
    Bmp.TransparentColor := SelectedColor;
    CP.Brush.Color := SelectedColor;
  end
  else
  begin
    Bmp.TransparentColor := clWhite;
    CP.Brush.Color := clWhite;
  end;
  CP.Brush.Style := bsSolid;
  CP.FillRect(R1);
  CP.Brush.Style := bsClear;
  L.DrawTreeNode(CP, 3, 1, Color);
  C.Brush.Style := bsClear;
  C.Draw(R.Left, R.Top, Bmp);
end;

procedure TRunFrm.AfterConstruction;
begin
  inherited;
  cmbLetter.Font := lvList.Font;
  cmbRules.Font := lvList.Font;
  AniFrm1.OnChanged := AniFrm1Changed;
end;

procedure TRunFrm.AniFrm1Changed(Sender: TObject);
begin
  SelectConfig(AniFrm1.Config);
end;

procedure TRunFrm.AniFrm1ToolButton1Click(Sender: TObject);
begin
  if (lvList.Selected = nil) and (lvList.Items.Count > 0) then
    lvList.Items[0].Selected := true;

  AniFrm1.ToolButton1Click(Sender);
end;

procedure TRunFrm.btnOKClick(Sender: TObject);
var
  Item: TListItem;

  procedure LangOK;
  var
    C, D: TConfig;
    K, I: Integer;
  begin
    if ((cmbLetter.Items.Count = 0) or (cmbLetter.ItemIndex >= 0)) and (cmbRules.ItemIndex >= 0) then
    begin
      Item := lvList.Selected;
      D := Config.Parent;
      C := TConfig(Matrix.Items[cmbRules.ItemIndex, cmbLetter.ItemIndex]);

      D.Items.Move(D.Items.IndexOf(C), 0);

      K := lvList.Items.IndexOf(Item);
      for I := lvList.Items.Count - 1 downto K do
      begin
        TConfig(lvList.Items[I].Data).Node := nil;
        lvList.Items.Delete(I);
      end;

      D.RunList(GListLimit);
      lvList.Refresh;
    end;
  end;

  procedure TuringOK;
  var
    K, I: Integer;
    C, D: TConfig;
  begin
    if (cmbRules.ItemIndex >= 0) then
    begin
      Item := lvList.Selected;
      D := Config;
      C := TConfig(Matrix.Rows[cmbRules.ItemIndex]);

      D.Items.Move(D.Items.IndexOf(C), 0);

      K := lvList.Items.IndexOf(Item);
      for I := lvList.Items.Count - 1 downto K + 1 do
      begin
        TConfig(lvList.Items[I].Data).Node := nil;
        lvList.Items.Delete(I);
      end;

      Config := nil;
      lvList.Selected := nil;
      D.RunList(GListLimit);
      lvList.Refresh;
    end;
  end;

begin
  case FMode of
    ptGrammar: LangOK;
    ptTuring, ptPushDown, ptEPushDown: TuringOK;
  end;
end;

procedure TRunFrm.btnTovabbClick(Sender: TObject);
var
  Item: TListItem;

  procedure LangOK;
  var
    D: TConfig;
  begin
    if (lvList.Items.Count > 0) then
    begin
      Item := lvList.Items[lvList.Items.Count - 1];
      D := TConfig(Item.Data);
      D.RunList(GListLimit);
      lvList.Refresh;
    end;
  end;

  procedure TuringOK;
  var
    K, I: Integer;
    C, D: TConfig;
  begin
    if (cmbRules.ItemIndex >= 0) then
    begin
      Item := lvList.Selected;
      D := Config;
      C := TConfig(Matrix.Rows[cmbRules.ItemIndex]);

      D.Items.Move(D.Items.IndexOf(C), 0);

      K := lvList.Items.IndexOf(Item);
      for I := lvList.Items.Count - 1 downto K + 1 do
      begin
        TConfig(lvList.Items[I].Data).Node := nil;
        lvList.Items.Delete(I);
      end;

      Config := nil;
      lvList.Selected := nil;
      D.RunList(GListLimit);
      lvList.Refresh;
    end;
  end;

begin
  case FMode of
    ptGrammar: LangOK;
    ptTuring, ptPushDown, ptEPushDown: TuringOK;
  end;
end;
procedure TRunFrm.Clear;
begin
  TreeView1.Items.Clear;
  lvlist.Clear;
  lvLang.Clear;
end;

procedure TRunFrm.cmbLetterChange(Sender: TObject);
begin
  lvList.Repaint;
end;

procedure TRunFrm.cmbRulesChange(Sender: TObject);
begin
  lvList.Repaint;
end;

procedure TRunFrm.Deselect;
begin
  case PageControl1.TabIndex of
    0:  lvList.Selected := nil;
    1:  TreeView1.Selected := nil;
    2:  lvLang.Selected := nil;
  end;
end;

procedure TRunFrm.Kibont(Node: TTntTreeNode; N: Integer; Rec: Boolean = false);
var
  I: Integer;
begin
  if TreeView1.Items.Count > GTreeLimit then
  begin
    Node.Expand(false);
    exit;
  end;
  
  if not Rec then
    TreeView1.Visible := false;

  if (Node = nil) then
  begin
    if TreeView1.Items.Count = 0 then
      Node := nil
    else
      Node := TreeView1.Items[0];
    while Node <> nil do
    begin
      Kibont(Node, N, true);
      Node := Node.getNextSibling;
    end;
    SetScrollPos(TreeView1.Handle, 0, 0, false);
    SetScrollPos(TreeView1.Handle, 1, 0, false);
  end
  else if (N > 0) then
  begin
    Node.Expand(false);
    for I := 0 to Node.Count - 1 do
      Kibont(Node[I], N - 1, true);
  end;

  if not Rec then
    TreeView1.Visible := true;
end;

procedure TRunFrm.Kibont101Click(Sender: TObject);
begin
  Kibont(TreeView1.Selected, 16);
end;

procedure TRunFrm.Kibont201Click(Sender: TObject);
begin
  Kibont(TreeView1.Selected, 64);
end;

procedure TRunFrm.Kibont51Click(Sender: TObject);
begin
  Kibont(TreeView1.Selected, 4);
end;

procedure TRunFrm.lvLangCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var
  X, Y: Integer;
begin
  X := length(Item1.Caption);
  Y := length(Item2.Caption);

  if X < Y then
   Compare := -1
  else if X > Y then
   Compare := 1
  else // X = Y
    if Item1.Caption < Item2.Caption then
      Compare := -1
    else if Item1.Caption > Item2.Caption then
      Compare := 1
    else
      Compare := 0;
end;

procedure TRunFrm.lvListAdvancedCustomDraw(Sender: TCustomListView;
  const ARect: TRect; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
var
  Item: TListItem;
  T, H: Integer;
  ScrollInfo: TScrollInfo;
  C: TConfig;
begin
  ScrollInfo.fMask := SIF_POS;
  if GetScrollInfo(lvList.Handle, SB_HORZ, ScrollInfo) then
    ListDX := - ScrollInfo.nPos
  else
    ListDX := 0;

  ListWidth := lvList.ClientWidth;

  if Stage = cdPostPaint then
  else
    exit;

  if AniFrm1.IsPlaying then
  begin
    cmbLetter.Hide;
    cmbRules.Hide;
    btnOK.Hide;
    exit;
  end;

  case FMode of
    ptGrammar:
    begin
      if (lvList.Items.Count > 0) then
      begin
        C := TObject(lvList.Items[lvList.Items.Count - 1].Data) as TConfig;
        while (C <> nil) and (C.Items.Count > 0) do
          C := TConfig(C.Items[0]);
        if (C <> nil) and not (C.IsTerminal or not (C.Line is TEGRule))
          and (TGConfig(C).Sentence.Count < GMaxLength - 1) then
        begin
          btnTovabb.Left := ListDX + Sender.Column[0].Width
            + 2 - btnTovabb.Width;
          H := lvList.Items[lvList.Items.Count - 1].DisplayRect(drLabel).Bottom + lvList.Top;
          if H + btnTovabb.Height < lvList.Top + lvList.Height then
            btnTovabb.Top := H
          else
            btnTovabb.Top := lvList.Items[lvList.Items.Count - 1].DisplayRect(drLabel).Top + lvList.Top;
          btnTovabb.Show;
        end
        else
          btnTovabb.Hide;
      end
      else
        btnTovabb.Hide;


      if (Config <> nil) and (lvList.Selected <> nil) then
      begin
        Item := lvList.Selected;
        T := lvList.Top + Item.Top;
        if cmbLetter.Items.Count > 1 then
        begin
          cmbLetter.Top := T + 1;
          cmbLetter.Left := ListDX + 1;
          cmbLetter.Width := Sender.Column[0].Width + 1;
          cmbLetter.Show;
        end
        else
          cmbLetter.Hide;

        if cmbRules.Items.Count > 1 then
        begin
          cmbRules.Top := T + 1;
          cmbRules.Left := ListDX + Sender.Column[0].Width + 2;
          cmbRules.Width := Sender.Column[1].Width;
          cmbRules.Show;
        end
        else
          cmbRules.Hide;

        if (cmbRules.Visible and (cmbRules.ItemIndex > 0)) or
          (cmbLetter.Visible and (cmbLetter.ItemIndex > 0)) then
        begin
          btnOK.Left := ListDX + Sender.Column[0].Width + Sender.Column[1].Width + 2;
          btnOK.Top := T;
          btnOK.Show;
        end
        else
          btnOK.Hide;
      end
      else
      begin
        cmbLetter.Hide;
        cmbRules.Hide;
        btnOK.Hide;
      end;
    end;
    ptTuring, ptPushDown, ptEPushDown:
      begin
      if (Config <> nil) and (lvList.Selected <> nil) then
      begin
        Item := lvList.Selected;
        T := lvList.Top + Item.Top;

        if cmbRules.Items.Count > 1 then
        begin
          cmbRules.Top := T + 1;
          if FMode = ptTuring then
          begin
            cmbRules.Left := ListDX + Sender.Column[0].Width + Sender.Column[1].Width + 2;
            cmbRules.Width := Sender.Column[2].Width;
          end
          else
          begin
            cmbRules.Left := ListDX + Sender.Column[0].Width + Sender.Column[1].Width + Sender.Column[2].Width + 2;
            cmbRules.Width := Sender.Column[3].Width;
          end;
          cmbRules.Show;
        end
        else
          cmbRules.Hide;

        if (cmbRules.Visible and (cmbRules.ItemIndex > 0)) then
        begin
          btnOK.Left := cmbRules.Left + cmbRules.Width + 2;
          btnOK.Top := T;
          btnOK.Show;
        end
        else
          btnOK.Hide;
      end
      else
      begin
        cmbRules.Hide;
        btnOK.Hide;
      end;
    end;
  end;
  if cmbRules.Left + cmbRules.Width > ListWidth then
    cmbRules.Hide;

  if btnOK.Left + btnOK.Width > ListWidth then
    btnOK.Hide;

  if btnTovabb.Left + btnTovabb.Width > ListWidth then
    btnTovabb.Hide;

  if cmbLetter.Left + cmbLetter.Width > ListWidth then
    cmbLetter.Hide;

  DefaultDraw := true;
end;


procedure TRunFrm.lvListAdvancedCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
  var DefaultDraw: Boolean);
var
  R1, R2: TRect;
  C: TCanvas;
  S: TESentence;
  Color: TColor;
  procedure DrawGramm;
  var
    L: TGConfig;
  begin
    L := TGConfig(Item.Data);
    S := L.Sentence;
    L.SetColor(S, Color, HideColor);
    DrawBuff(S, lvList.Canvas, R2, lvList.Selected = Item, Color);

    if (L.Rule = nil) then
      WideCanvasTextOut(lvList.Canvas, R2.Right + 7, R2.Top, L.Line.Name)
    else
      WideCanvasTextOut(lvList.Canvas, R2.Right + 7, R2.Top, L.Rule.ToString(GUSpace));
  end;

  procedure DrawTuring;
  var
    L, L2: TTConfig;
    X: Integer;
    B: Boolean;
  begin
    L := TTConfig(Item.Data);
    S := L.Sentence;
    lvList.Canvas.Brush.Style := bsClear;
    WideCanvasTextOut(lvList.Canvas, R2.Left, R2.Top, L.Line.Name);

    R2.Left := R2.Right + LeftDif;
    R2.Right := R2.Left - LeftDif + lvList.Columns[1].Width;

    L.SetColor(S, Color, HideColor);

    B := GUSpace; GUSpace := GTurSpace;
    DrawBuff(S, lvList.Canvas, R2, lvList.Selected = Item, Color);
    GUSpace := B;

    X := R2.Right;
    if (L.Items.Count > 0)then
    begin
      L2 := TTConfig(L.Items[0]);
      if L2.HasRule then
        WideCanvasTextOut(lvList.Canvas, X, R2.Top, ' ' + L2.Rule.ToString(GUSpace))
      else
        WideCanvasTextOut(lvList.Canvas, X, R2.Top, '        exit');
    end;
  end;

  procedure DrawPushDown;
  var
    L, L2: TTConfig;
    X: Integer;
    B: Boolean;
  begin
    L := TTConfig(Item.Data);
    S := L.GetProgram.Input;

    lvList.Canvas.Brush.Style := bsClear;
    WideCanvasTextOut(lvList.Canvas, R2.Left, R2.Top, L.Line.Name);

    R2.Left := 7 + R2.Right;
    R2.Right := R2.Left + lvList.Columns[1].Width;
//    if HideColor then
//      S.First := -1
//    else
//      S.First := L.LetterInd;
//    S.Last := S.First;

    L.SetColor(S, Color, HideColor);
      
    B := GUSpace; GUSpace := GTurSpace;
    DrawBuff(S, lvList.Canvas, R2, lvList.Selected = Item, Color);
    GUSpace := B;

    X := R2.Right;
    WideCanvasTextOut(lvList.Canvas, X, R2.Top, L.Sentence.ToString(GUSpace));

    X := X + lvList.Columns[2].Width;
    if (L.Items.Count > 0) and (TObject(L.Items[0]) is TTConfig) then
    begin
      L2 := TTConfig(L.Items[0]);
      if L2.Rule <> nil then
        WideCanvasTextOut(lvList.Canvas, X, R2.Top, L2.Rule.ToString(GUSpace))
      else if L2.Line is TEAccept then
        WideCanvasTextOut(lvList.Canvas, X, R2.Top, '        accept')
      else if L2.Line is TEExit then
        WideCanvasTextOut(lvList.Canvas, X, R2.Top, '        exit');
    end;
  end;

begin
  if Stage <> cdPostPaint then
  begin
    DefaultDraw := true;
    exit;
  end;

  R2 := Item.DisplayRect(drLabel);
  R2.Top := R2.Top + TopDif;
  R2.Bottom := R2.Bottom - 1;

  case FMode of
    ptGrammar:
      if TObject(Item.Data) is TGConfig then
        DrawGramm;
    ptTuring:
      if TObject(Item.Data) is TTConfig then
        DrawTuring;
    ptPushDown, ptEPushDown:
      if TObject(Item.Data) is TSConfig then
        DrawPushDown;
  end;
end;

procedure TRunFrm.lvListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  R: TEBasLine;
  L, X: TList;

  procedure SelectLangItem;
  var
    I: Integer;
  begin
    if Item.Selected then
    begin
      Config := TGConfig(lvList.Items[lvList.ItemIndex].Data);
      Matrix.Free;
      Matrix := TGConfig(Config.Parent).GetMatrix;
      if Matrix.Rows.Count > 0 then
        R := Matrix.Rows[0]
      else
        R := nil;

      cmbLetter.Items.Clear;
      cmbRules.Items.Clear;
      for I := 0 to Matrix.Rows.Count - 1 do
        cmbRules.Items.Add(' ' + TEBasLine(Matrix.Rows[I]).ToString(GUSpace));
      for I := 0 to Matrix.Cols.Count - 1 do
        cmbLetter.Items.Add(' ' + TConfig(Matrix.Items[0, I]).StateToString(GUSpace));
      cmbLetter.ItemIndex := 0;
      cmbRules.ItemIndex := 0;
    end
  end;
  procedure SelectTuringItem;
  var
    I: Integer;
    L: TList;
  begin
    if Item.Selected then
    begin
      Config := TTConfig(lvList.Items[lvList.ItemIndex].Data);
      cmbRules.Items.Clear;
      Matrix.Free;
      Matrix := Config.GetMatrix;
      for I := 0 to Matrix.Rows.Count - 1 do
        if (TTConfig(Matrix.Rows[I]).HasRule) then
          cmbRules.Items.Add(' ' + TEBasLine(TTConfig(Matrix.Rows[I]).Rule).ToString(GUSpace));

      cmbRules.ItemIndex := 0;
    end
  end;

begin
  case FMode of
    ptGrammar: SelectLangItem;
    ptTuring, ptPushDown, ptEPushDown: SelectTuringItem;
  end;
end;

procedure TRunFrm.PageControl1Change(Sender: TObject);
begin
  if FExeFrame.EProgram <> nil then
    with FExeFrame.EProgram do
    begin
      RunFrm := Self;
      case PageControl1.TabIndex of
        0: Select(vtList);
        1: Select(vtTree);
        2: Select(vtSet);
      end
    end;
end;

procedure TRunFrm.RefreshFont;
begin
  cmbLetter.Font := GFont;
  cmbRules.Font := GFont;
  AniFrm1.pnlAni.Font := GAniFont;
  AniFrm1.pnlAni.RefreshFont;
  lvLang.Font := GMonoFont;
end;

procedure TRunFrm.Run;
begin
  if FExeFrame.EProgram <> nil then
  with FExeFrame.EProgram do
  begin
    RunFrm := Self;
    RunList(GListLimit);
    RunTree(2);
    PageControl1Change(nil);
  end;
end;

procedure TRunFrm.SelectAnItem;
begin
  if (lvList.Items.Count > 0) and (Config = nil) then
    Config := TObject(lvList.Items[0].Data) as TTConfig;
end;

procedure TRunFrm.SelectConfig(C: TConfig);
var
  I: Integer;
  B: Boolean;
begin
  B := false;
  Config := C;
  for I := 0 to lvList.Items.Count - 1 do
    if lvList.Items[I].Data = C then
    begin
      lvList.Selected := lvList.Items[I];
      B := true;
      break;
    end;

  if not B then
    lvList.Selected := nil;
end;

procedure TRunFrm.SelectMode(M: TProgType);
begin
  if FMode = M then
    exit;
  if FMode <> ptGrammar then
    cmbLetter.Hide;

  FMode := M;
  case M of
    ptGrammar:
    begin
      lvList.Columns.Clear;
      with lvList.Columns.Add do
      begin
        Caption := 'Sentential form';
        Width := (lvList.ClientWidth - 50) div 2;
      end;
      with lvList.Columns.Add do
      begin
        Caption := 'Rule';
        Width := (lvList.ClientWidth - 50) div 2;
      end;
    end;

    ptTuring:
    begin
      lvList.Columns.Clear;
      with lvList.Columns.Add do
      begin
        Caption := 'State';
        Width := 50;
      end;
      with lvList.Columns.Add do
      begin
        Caption := 'Tape';
        Width := 300;
      end;
      with lvList.Columns.Add do
      begin
        Caption := ' Read Write Step State';
        Width := 150;
      end;
    end;

    ptPushDown, ptEPushDown:
    begin
      lvList.Columns.Clear;
      with lvList.Columns.Add do
      begin
        Caption := 'State';
        Width := 50;
      end;
      with lvList.Columns.Add do
      begin
        Caption := 'Input';
        Width := 100;
      end;
      with lvList.Columns.Add do
      begin
        Caption := 'Stack';
        Width := 100;
      end;
      with lvList.Columns.Add do
      begin
        Caption := 'Read Pop  Push  State';
        Width := 150;
      end;
    end;
  end;
end;

procedure TRunFrm.SetConfig(const Value: TConfig);
begin
  if FConfig <> Value then
  begin
    FConfig := Value;
    if not AniFrm1.IsPLaying then
      AniFrm1.Config := Config;

    if Assigned(FOnConfigChanged) then
      FOnConfigChanged(Self);
  end;
end;

procedure TRunFrm.SetOnConfigChanged(const Value: TNotifyEvent);
begin
  FOnConfigChanged := Value;
end;

procedure TRunFrm.ToolButton1Click(Sender: TObject);
begin
  Kibont(TreeView1.Selected, 4);
end;

procedure TRunFrm.ToolButton2Click(Sender: TObject);
begin
  Kibont(TreeView1.Selected, 16);
end;

procedure TRunFrm.ToolButton3Click(Sender: TObject);
begin
  Kibont(TreeView1.Selected, 64);
end;

procedure TRunFrm.TreeView1AdvancedCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
  var PaintImages, DefaultDraw: Boolean);

  var
    Color: TColor;

  procedure DrawLang;
  var
    L, L2: TGConfig;
    S: TESentence;
    R2: TREct;
  begin
    if (Stage = cdPostPaint) and ( TObject(Node.Data) is TGConfig) then
    begin
      L := TGConfig(Node.Data);
      S := L.Sentence;

      R2 := Node.DisplayRect(true);
      R2.Right := TreeView1.Width;
      if R2.Right < R2.Left then
        exit;

      L.SetColor(S, Color, false);
      DrawBuff2(L, TreeView1.Canvas, R2, cdsSelected in State, Color);
      DefaultDraw := false;
    end;
  end;

  procedure DrawTuring;
  var
    L, L2: TTConfig;
    S: TESentence;
    R2: TREct;
  begin
    if (Stage = cdPostPaint) and ( TObject(Node.Data) is TTConfig) then
    begin
      L := TTConfig(Node.Data);
      S := L.Sentence;

      R2 := Node.DisplayRect(true);
      R2.Right := TreeView1.Width;
      if R2.Right < R2.Left then
        exit;

      L.SetColor(S, Color, false);
      DrawBuff2(L, TreeView1.Canvas, R2, cdsSelected in State, Color);
        
      DefaultDraw := false;
    end;
  end;

  procedure DrawPushDown;
  var
    L, L2: TSConfig;
    S: TESentence;
    R2: TREct;
  begin
    if (Stage = cdPostPaint) and ( TObject(Node.Data) is TSConfig) then
    begin
      L := TSConfig(Node.Data);
      S := L.GetProgram.Input;

      R2 := Node.DisplayRect(true);
      R2.Right := TreeView1.Width;
      if R2.Right < R2.Left then
        exit;

      L.SetColor(S, Color, false);
      DrawBuff2(L, TreeView1.Canvas, R2, cdsSelected in State, Color);

      DefaultDraw := false;
    end;
  end;

begin
  DefaultDraw := true;
  if Stage in [
    cdPrePaint,
    cdPreErase,
    cdPostErase
    ] then
  begin
    DefaultDraw := true;
    exit;
  end
  else
    DefaultDraw := false;

  case FMode of
    ptGrammar: DrawLang;
    ptTuring: DrawTuring;
    ptPushDown, ptEPushDown: DrawPushDown;
  end;
end;

procedure TRunFrm.TreeView1Expanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
  TConfig(TTntTreeNode(Node).Data).RunTree(2);
  TreeView1.Refresh;
end;

procedure TRunFrm.TreeView1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  N: TTntTreeNode;
begin
  N := TreeView1.GetNodeAt(X, Y);
  if N <> nil then
  begin
    if TObject(N.Data) is TConfig then
      Config := N.Data;
  end;
end;

initialization
  Bmp := TBitmap.Create;
finalization
  Bmp.Free;

end.
