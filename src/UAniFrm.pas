unit UAniFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Buttons, ExtCtrls, UAniString, UBase, UGrammar, StdCtrls, ComCtrls,
  ToolWin, ImgList;

type
  TAniFrm = class(TFrame)
    pnlAni: TLanAnimation;
    Panel1: TPanel;
    ToolBar1: TToolBar;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton1: TToolButton;
    ToolButton4: TToolButton;
    ImageList1: TImageList;
    procedure Button1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure FrameResize(Sender: TObject);
  private
    FConfig: TConfig;
    NewConfig: TConfig;
    FIsPlaying: Boolean;
    FOnChanged: TNotifyEvent;
    procedure SetConfig(const Value: TConfig);
    procedure SetOnChanged(const Value: TNotifyEvent);
    procedure DoChanged;
    { Private declarations }
  public
    procedure PnlOnFinished(Sender: TObject);
    procedure Play;
    procedure Next;
    procedure Prev;
    procedure Stop;
    property OnChanged: TNotifyEvent read FOnChanged write SetOnChanged;
    property IsPlaying: Boolean read FIsPlaying;
    property Config: TConfig read FConfig write SetConfig;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  UTuring, UPushDown;

{$R *.dfm}

{ TFrame1 }

procedure TAniFrm.Button1Click(Sender: TObject);
begin
  pnlAni.Interval := 40;
end;

constructor TAniFrm.Create(AOwner: TComponent);
begin
  inherited;
  pnlAni.Interval := 40;
  pnlAni.Time := 800;
  pnlAni.Color := clWhite;
//  pnlAni.Font.Size := 12;
  pnlAni.OnFinished := PnlOnFinished;
end;

procedure TAniFrm.DoChanged;
begin
  if Assigned(FOnChanged) then
    FOnChanged(Self);
end;

procedure TAniFrm.FrameResize(Sender: TObject);
begin
  pnlAni.IniConfig;
  pnlAni.Draw;
end;

procedure TAniFrm.Next;
var
  CL: TGConfig;
  CT: TTConfig;
  UseSpace: Boolean;
begin
  if (FConfig = nil) or pnlAni.IsPlaying then
    exit;

  UseSpace := false;
  pnlAni.Time := GAniTime;

  if pnlAni.Inverse then
  begin
    NewConfig := FConfig;
    FConfig := FConfig.Parent;
    if FConfig.Parent = nil then
    begin
      FConfig := NewConfig;
      Stop;
      exit;
    end;
  end
  else
    if FConfig.Items.Count > 0 then
      NewConfig := TConfig(FConfig.Items[0])
    else
      NewConfig := nil;

  if (NewConfig = nil)
    or ((NewConfig is TSConfig) and
      (NewConfig.Line is TEExit)
      {or (NewConfig.Line is TEAccept)}) then
  begin
    Stop;
    exit;
  end;

  if (NewConfig <> nil)  then
  begin
    if (FConfig is TGConfig) and (TGConfig(FConfig).Rule <> nil)
      and (NewConfig is TGConfig) then
    begin
      CL := TGConfig(FConfig);
      pnlAni.Text := CL.Sentence.ToString(UseSpace);
      pnlAni.First := CL.Sentence.CharPos(TGConfig(NewConfig).LetterInd, UseSpace);
      if TGConfig(NewConfig).Succeeded then
      begin
        pnlAni.Last := pnlAni.First + length(CL.Rule.Left.ToString(UseSpace)) - 1;
        pnlAni.Freezing := false;
      end
      else
      begin
        pnlAni.Freezing := true;
      end;

      pnlAni.NewString := CL.Rule.Right.ToString(UseSpace);
      pnlAni.Start;
      if not pnlAni.Inverse then
        FConfig := NewConfig;
    end
    else if (FConfig is TSConfig)
      and (NewConfig is TSConfig) and (TTConfig(NewConfig).HasRule)
      and (TTConfig(NewConfig).Rule.Right <> nil) then
    begin
      CT := TSConfig(FConfig);
      pnlAni.Text := CT.Sentence.ToString(UseSpace);
      pnlAni.First := 1; // CT.LetterInd + 1;
      if TSConfig(NewConfig).Rule.Left.Name = 'eps' then
        pnlAni.Last := 0
      else
      begin
        pnlAni.Last := 1;
        if (pnlAni.Last <= length(pnlAni.Text))
          and (pnlAni.NewString = pnlAni.Text[pnlAni.First]) then
          pnlAni.Freezing := true
        else
          pnlAni.Freezing := false;
      end;
      pnlAni.NewString := TESentence(TSConfig(NewConfig).Rule.Dir).ToString(UseSpace);
      pnlAni.Start;
      if not pnlAni.Inverse then
        FConfig := NewConfig;
    end   
    else if (FConfig is TTConfig)
      and (NewConfig is TTConfig) and (TTConfig(NewConfig).HasRule) then
    begin
      CT := TTConfig(FConfig);
      pnlAni.Text := CT.Sentence.ToString(UseSpace);
      pnlAni.First := CT.LetterInd + 1;
      pnlAni.Last := pnlAni.First;
      pnlAni.NewString := TTConfig(NewConfig).Rule.Right.Name;
      if (pnlAni.Last <= length(pnlAni.Text))
        and (pnlAni.NewString = pnlAni.Text[pnlAni.First]) then
      begin
        if FIsPlaying then
        begin
          pnlAni.Freezing := true;
          pnlAni.Start; 
        end
        else
//          if pnlAni.Inverse then
//            pnlAni.Start
//          else
            pnlAni.OnFinished(self);
      end
      else
        pnlAni.Start;  
        
//      if not pnlAni.Inverse then
//      begin
//        SetConfig(NewConfig);
////        FConfig := NewConfig;
//      end;
    end
  end;
  DoChanged;
end;

procedure TAniFrm.Play;
begin
  if not (FIsPLaying or (FConfig = nil)) then
  begin
    pnlAni.Inverse := false;
    FIsPlaying := true;
    Next;
  end;
end;

procedure TAniFrm.PnlOnFinished(Sender: TObject);
begin
  if not pnlAni.Inverse then
  begin
    SetConfig(NewConfig)
  end
  else
  begin
    NewConfig := FConfig;
    FConfig := nil;
    SetConfig(NewConfig);
  end;

  
  if FIsPlaying and (FConfig <> nil) then
  begin
    Next;
  end;
end;

procedure TAniFrm.Prev;
begin
  Stop;
  pnlAni.Inverse := true;
  Next;
end;

procedure TAniFrm.SetConfig(const Value: TConfig);
begin
  if Value <> FConfig then
  begin
    FConfig := Value;
//    if IsPlaying or pnlAni.IsPlaying then
//      exit;

    if (FConfig <> nil) then
    begin
      if (FConfig is TGConfig) then
      begin
        pnlAni.Text := TGConfig(FConfig).Sentence.ToString(GUSpace);
        pnlAni.First := -1;
        pnlAni.Last := -2;
        pnlAni.NewString := '';
      end
      else if (FConfig is TSConfig) then
      begin
        pnlAni.Text := TSConfig(FConfig).Sentence.ToString(GUSpace);
        pnlAni.First := -1;
        pnlAni.Last := -2;
        pnlAni.NewString := '';
      end
      else if FConfig is TTConfig then
      begin
        if (FConfig.Items.Count > 0) and (TObject(FConfig.Items[0]) is TTConfig)
          and (TTConfig(FConfig.Items[0]).HasRule) then
        begin
          pnlAni.First := TTConfig(FConfig).LetterInd + 1;
          pnlAni.Last := pnlAni.First;
//          pnlAni.NewString := TTConfig(FConfig.Items[0]).Sentence.ToString(GUSpace);
          pnlAni.NewString := TTConfig(FConfig.Items[0]).Rule.Right.Name; 
          pnlAni.UpColor := clRed;       
        end
        else
        begin
          pnlAni.First := -1;
          pnlAni.Last := -2;
          pnlAni.NewString := '';
        end;
        pnlAni.Text := TTConfig(FConfig).Sentence.ToString(GUSpace);
      end;
      pnlAni.IniConfig;
      pnlAni.Draw;
    end;
    DoChanged;
  end;
end;

procedure TAniFrm.SetOnChanged(const Value: TNotifyEvent);
begin
  FOnChanged := Value;
end;

procedure TAniFrm.Stop;
begin
  if FIsPlaying then
    FIsPlaying := false;
  pnlAni.Finish;
end;

procedure TAniFrm.ToolButton1Click(Sender: TObject);
begin
  Stop;
  pnlAni.Inverse := false;
  Play;
end;

procedure TAniFrm.ToolButton2Click(Sender: TObject);
begin
  Prev;
end;

procedure TAniFrm.ToolButton3Click(Sender: TObject);
begin
  Stop;
end;

procedure TAniFrm.ToolButton4Click(Sender: TObject);
begin
  Stop;
  pnlAni.Inverse := false;
  Next;
end;

end.
