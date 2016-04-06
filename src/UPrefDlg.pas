unit UPrefDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, UBase, Buttons,
  TntStdCtrls;

type
  TPrefDlg = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    FileOpenDialog1: TFileOpenDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Korlatok: TTabSheet;
    Konyvt: TTabSheet;
    ListBox1: TListBox;
    Panel3: TPanel;
    SpeedButton1: TSpeedButton;
    Edit1: TEdit;
    GroupBox2: TGroupBox;
    edTime: TLabeledEdit;
    edDb: TLabeledEdit;
    rgList: TRadioGroup;
    rgLang: TRadioGroup;
    rgTree: TRadioGroup;
    StaticText1: TStaticText;
    edLength: TLabeledEdit;
    TabSheet2: TTabSheet;
    edDbInput: TLabeledEdit;
    edKonfp: TLabeledEdit;
    StaticText4: TStaticText;
    CheckBox2: TCheckBox;
    GroupBox1: TGroupBox;
    edAniTime: TLabeledEdit;
    edListLim: TLabeledEdit;
    Button4: TButton;
    btnDel: TButton;
    TabSheet3: TTabSheet;
    GroupBox3: TGroupBox;
    Button5: TButton;
    GroupBox4: TGroupBox;
    Button6: TButton;
    FontDialog1: TFontDialog;
    FontDialog2: TFontDialog;
    GroupBox5: TGroupBox;
    Button7: TButton;
    TntLabel1: TTntLabel;
    FontDialog3: TFontDialog;
    TntLabel2: TTntLabel;
    TntLabel3: TTntLabel;
    Bevel1: TBevel;
    StaticText5: TStaticText;
    edTreeLim: TLabeledEdit;
    CheckBox1: TCheckBox;
    GroupBox6: TGroupBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure PageControl1DrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    FOnFontChanged: TNotifyEvent;
    procedure SetOnFontChanged(const Value: TNotifyEvent);
  published
  public
    procedure Init;
    property OnFontChanged: TNotifyEvent read FOnFontChanged write SetOnFontChanged;
  end;

var
  PrefDlg: TPrefDlg;
  LMaxLength,
  LTimeLimit, LDbLimit,
  LDbInput, LKonfigpInput,
  LListLimit, LTreeLimit: Integer;

implementation

{$R *.dfm}

procedure TPrefDlg.btnDelClick(Sender: TObject);
begin
  ListBox1.DeleteSelected;
end;

procedure TPrefDlg.Button1Click(Sender: TObject);
begin
  case rgList.ItemIndex of
    0: Default.Choice[vtList, ctPos] := fmFirst;
    1: Default.Choice[vtList, ctPos] := fmLast;
    2: Default.Choice[vtList, ctPos] := fmRandom;
  end;

  case rgLang.ItemIndex of
    0: Default.Choice[vtSet, ctPos] := fmFirst;
    1: Default.Choice[vtSet, ctPos] := fmLast;
    2: Default.Choice[vtSet, ctPos] := fmRandom;
  end;

  case rgTree.ItemIndex of
    0: Default.Choice[vtTree, ctPos] := fmFirst;
    1: Default.Choice[vtTree, ctPos] := fmLast;
    2: Default.Choice[vtTree, ctPos] := fmAll;
  end;
  Default.Show(not CheckBox1.Checked, swDeadEnd);
  Default.Show(not CheckBox2.Checked, swDeterm);

  TryStrToInt(edAniTime.Text, GAniTime);
  TryStrToInt(edLength.Text, GMaxLength);
  TryStrToInt(edTime.Text, GTimeLimit);
  TryStrToInt(edDb.Text, GDbLimit);
  TryStrToInt(edDbInput.Text, GDbInput);
  TryStrToInt(edKonfp.Text, GKonfigpInput);
  TryStrToInt(edListLim.Text, GListLimit);
  TryStrToInt(edTreeLim.Text, GTreeLimit);

  GFont.Assign(FontDialog1.Font);
  GMonoFont.Assign(FontDialog2.Font);
  GAniFont.Assign(FontDialog3.Font);
  if Assigned(OnFontChanged) then
    OnFontChanged(nil);

  Close;
end;

procedure TPrefDlg.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TPrefDlg.Button4Click(Sender: TObject);
begin
  ListBox1.AddItem(Edit1.Text, nil);
end;

procedure TPrefDlg.Button5Click(Sender: TObject);
begin
  FontDialog1.Execute;
  TntLabel1.Font.Assign(FontDialog1.Font);
end;

procedure TPrefDlg.Button6Click(Sender: TObject);
begin
  FontDialog2.Execute;
  TntLabel2.Font.Assign(FontDialog2.Font);
end;

procedure TPrefDlg.Button7Click(Sender: TObject);
begin
  FontDialog3.Execute;
  TntLabel3.Font.Assign(FontDialog3.Font);
end;

procedure TPrefDlg.FormCreate(Sender: TObject);
begin
  PageControl1.OwnerDraw:=true;
end;

procedure TPrefDlg.Init;
begin
  PageControl1.ActivePageIndex := 0;
  case Default.Choice[vtList, ctPos] of
    fmFirst:  rgList.ItemIndex := 0;
    fmLast:   rgList.ItemIndex := 1;
    fmRandom: rgList.ItemIndex := 2;
  end;

  case Default.Choice[vtSet, ctPos] of
    fmFirst:  rgLang.ItemIndex := 0;
    fmLast:   rgLang.ItemIndex := 1;
    fmRandom: rgLang.ItemIndex := 2;
  end;

  case Default.Choice[vtTree, ctPos] of
    fmFirst:  rgTree.ItemIndex := 0;
    fmLast:   rgTree.ItemIndex := 1;
    fmAll:    rgTree.ItemIndex := 2;
  end;

//  LDeadEnd := poHideDeadEnd in Default.Options;
//  LDeterm :=  poHideDeterm  in Default.Options;
  CheckBox1.Checked := poHideDeadEnd in Default.Options;
  CheckBox2.Checked := poHideDeterm  in Default.Options;

  edAniTime.Text := IntToStr(GAniTime);

  LMaxLength := GMaxLength;
  edLength.Text := IntToStr(LMaxLength);

  LTimeLimit := GTimeLimit;
  edTime.Text := IntToStr(LTimeLimit);
  LDbLimit   := GDbLimit;
  edDb.Text := IntToStr(LDbLimit);
  LDbInput   := GDbInput;
  edDbInput.Text := IntToStr(LDbInput);
  LKonfigpInput := GKonfigpInput;
  edKonfp.Text := IntToStr(LKonfigpInput);

  LListLimit   := GListLimit;
  LTreeLimit   := GTreeLimit;
  edListLim.Text := IntToStr(LListLimit);
  edTreeLim.Text := IntToStr(LTreeLimit);

  FontDialog1.Font := GFont;
  FontDialog2.Font := GMonoFont;
  FontDialog3.Font := GAniFont;

  TntLabel1.Font.Assign(FontDialog1.Font);
  TntLabel2.Font.Assign(FontDialog2.Font);
  TntLabel3.Font.Assign(FontDialog3.Font);
end;

procedure TPrefDlg.ListBox1Click(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to ListBox1.Count - 1 do
    if ListBox1.Selected[I] then
    begin
      Edit1.Text := ListBox1.Items[I];
      exit;
    end;
end;

procedure TPrefDlg.PageControl1DrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  TargetCanvas:  TCanvas;
  TargetBounds:  TRect;
begin
  TargetCanvas := Control.Canvas;
  TargetBounds := Control.BoundsRect;
//  TargetCanvas.Brush.Color := clWhite;

  TargetBounds.Left := 0;
  TargetBounds.Top  := Rect.Bottom; // ez attól függ hogy mi a tabposition értéke

  // és a "MultiLine" az legyen 'false'

  TargetCanvas.FillRect(TargetBounds);

  // innnentõl lehet kiirni rá a szöveget meg mindent amit akarsz
  // a tab header rect az a "Rect" amit paraméterként kap a függvány (oda mehet a caption)
  Control.Canvas.TextOut(Rect.left+5,Rect.top+3,PageControl1.Pages[tabindex].Caption);
  PageControl1.Pages[TabIndex].Brush.Color := Control.Canvas.Brush.Color;
end;

procedure TPrefDlg.SetOnFontChanged(const Value: TNotifyEvent);
begin
  FOnFontChanged := Value;
end;

procedure TPrefDlg.SpeedButton1Click(Sender: TObject);
begin
  FileOpenDialog1.FileName := Edit1.Text;
  if FileOpenDialog1.Execute then
    Edit1.Text := FileOpenDialog1.FileName;
end;

end.
