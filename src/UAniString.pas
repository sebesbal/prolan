unit UAniString;

interface

uses
  Windows, Graphics, ExtCtrls, Classes;

type

  TAniString = class
  private
    FStartPos: TPoint;
    FEndColor: TColor;
    FTime: double;
    FEndPos: TPoint;
    FStartColor: TColor;
    FTimer: TTimer;
    FCanvas: TCanvas;
    FText: WideString;

    FColor: TColor;
    FPos: TPoint;
    FFont: TFont;
    FStep: Integer;
    FMaxStep: Integer;
    FInverse: Boolean;
    FEndVisible: Boolean;
    procedure SetEndColor(const Value: TColor);
    procedure SetEndPos(const Value: TPoint);
    procedure SetStartColor(const Value: TColor);
    procedure SetStartPos(const Value: TPoint);
    procedure SetTime(const Value: double);
    procedure SetCanvas(const Value: TCanvas);
    procedure SetText(const Value: WideString);
    function GetSize: TSize;
    procedure SetFont(const Value: TFont);
    procedure PrepCanvas;
    function GetInterval: Cardinal;
    procedure SetInterval(const Value: Cardinal);
    procedure SetInverse(const Value: Boolean);
    procedure SetStep(const Value: Integer);
    procedure SetEndVisible(const Value: Boolean);
  published
    procedure Animate(Sender: TObject);
    procedure Draw;
    procedure Move;
    procedure StartTimer;
    procedure Start;
    procedure Finish;
    property Step: Integer read FStep write SetStep;
    property Inverse: Boolean read FInverse write SetInverse;
    property Interval: Cardinal read GetInterval write SetInterval;
    property Font: TFont read FFont write SetFont;
    property Text: WideString read FText write SetText;
    property Canvas: TCanvas read FCanvas write SetCanvas;
    property Size: TSize read GetSize;
    property StartPos: TPoint read FStartPos write SetStartPos;
    property EndPos: TPoint read FEndPos write SetEndPos;
    property StartColor: TColor read FStartColor write SetStartColor;
    property EndColor: TColor read FEndColor write SetEndColor;
    property Time: double read FTime write SetTime;
    constructor Create;
    destructor Destroy; override;
  end;

  TLanAnimation = class(TPaintBox)
  private
    FText: WideString;
    FFirst: Integer;
    FLast: Integer;
    FNewString: WideString;
    FCanvas2: TCanvas;
    FString: TAniString;
    FLeft: TAniString;
    FRight: TAniString;
    FUp: TAniString;
    FDown: TAniString;
    FPos: TPoint;
    FTextPos: TPoint;
    FTimer: TTimer;
    FStep: Integer;
    FMaxStep: Integer;
    FTime: Integer;
    FBitMap: TBitmap;
    FOnFinished: TNotifyEvent;
    FInverse: Boolean;
    FUpColor: TColor;
    FFreezing: Boolean;
    procedure SetText(const Value: WideString);
    procedure SetFirst(const Value: Integer);
    procedure SetLast(const Value: Integer);
    procedure SetNewString(const Value: WideString);
    procedure SetPos(const Value: TPoint);
    function GetInterval: Integer;
    procedure SetInterval(const Value: Integer);
    procedure SetTime(const Value: integer);
    procedure SetOnFinished(const Value: TNotifyEvent);
    procedure SetInverse(const Value: Boolean);
    procedure DoFinished;
    procedure SetUpColor(const Value: TColor);
    procedure SetFreezing(const Value: Boolean);
  public
    procedure RefreshFont;
  published
    procedure Paint; override;
    property Time: integer read FTime write SetTime;
    property Interval: Integer read GetInterval write SetInterval;
    function GetPos(S: WideString): TPoint;
    property Inverse: Boolean read FInverse write SetInverse;
    property Text: WideString read FText write SetText;
    property First: Integer read FFirst write SetFirst;
    property Last: Integer read FLast write SetLast;
    property NewString: WideString read FNewString write SetNewString;
    property Pos: TPoint read FPos write SetPos;
    property UpColor: TColor read FUpColor write SetUpColor;
    property Freezing: Boolean read FFreezing write SetFreezing;
    procedure Start;
    procedure Init;
    procedure IniConfig;
    procedure Finish;
    procedure Draw;
    function IsPlaying: Boolean;
    property OnFinished: TNotifyEvent read FOnFinished write SetOnFinished;
    procedure Animate(Sender: TObject);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  procedure Register;

implementation

uses
  TNTGraphics, UBase;


procedure Register;
begin
  RegisterComponents('Additional', [TLanAnimation]);
end;

procedure MTextOut(C: TCanvas; X, Y: Integer; W: WideString);
begin
  WideCanvasTextOut(C, X ,Y, W);
end;

{ TAniString }

procedure TAniString.Animate(Sender: TObject);
begin
  if FStep <= FMaxStep then
  begin
    Draw;
    Move;
  end
  else
    FTimer.Enabled := false;
end;

constructor TAniString.Create;
begin
  FTimer := TTimer.Create(nil);
  FTimer.OnTimer := Animate;
  FTimer.Interval := 50;
  FTime := 1000;
  FTimer.Enabled := false;
  FStartColor := clBlack;
  FEndColor := clBlack;
  FFont := TFont.Create;
  FEndVisible := true;
end;

destructor TAniString.Destroy;
begin
  FTimer.Destroy;
  FFont.Destroy;
  inherited;
end;

procedure TAniString.Draw;
begin
  if (FCanvas <> nil) and ((FStep < FMaxStep) or FEndVisible) then
  begin
    PrepCanvas;
    MTextOut(FCanvas, FPos.X, FPos.Y, FText);
  end;
end;

procedure TAniString.Finish;
begin
  FTimer.Enabled := false;
  Step := FMaxStep;
end;

function TAniString.GetInterval: Cardinal;
begin
  Result := FTimer.Interval;
end;

function TAniString.GetSize: TSize;
begin
  PrepCanvas;
  Result := WideCanvasTextExtent(FCanvas, FText);
  if FText = eps then
    Result.cx := 0;
end;

procedure TAniString.Move;
begin
  Inc(FStep);
  Step := FStep;
end;

procedure TAniString.PrepCanvas;
begin
  FCanvas.Brush.Style := bsClear;
  FCanvas.Font := FFont;
  FCanvas.Font.Color := FColor;
end;

procedure TAniString.SetCanvas(const Value: TCanvas);
begin
  FCanvas := Value;
end;

procedure TAniString.SetEndColor(const Value: TColor);
begin
  FEndColor := Value;
end;

procedure TAniString.SetEndPos(const Value: TPoint);
begin
  FEndPos := Value;
end;

procedure TAniString.SetEndVisible(const Value: Boolean);
begin
  FEndVisible := Value;
end;

procedure TAniString.SetFont(const Value: TFont);
begin
  FFont := Value;
end;

procedure TAniString.SetInterval(const Value: Cardinal);
begin
  FTimer.Interval := Value;
end;

procedure TAniString.SetInverse(const Value: Boolean);
begin
  FInverse := Value;
end;

procedure TAniString.SetStartColor(const Value: TColor);
begin
  FStartColor := Value;
end;

procedure TAniString.SetStartPos(const Value: TPoint);
begin
  FStartPos := Value;
end;

procedure TAniString.SetStep(const Value: Integer);
var
  a, b: double;
  function f(R: double): double;
  begin
    Result := 0.5 * sin(pi * (R - 0.5)) + 0.5;
  end;
begin
  FStep := Value;
  if FInverse then
    b := f((FMaxStep - FStep) / FMaxStep)
  else
    b := f(FStep / FMaxStep);
    
  a := 1 - b;
  FPos.X := round(a * FStartPos.X + b * FEndPos.X);
  FPos.Y := round(a * FStartPos.Y + b * FEndPos.Y);
  FColor := RGB(round(a * GetRValue(FStartColor) + b * GetRValue(FEndColor)),
                round(a * GetGValue(FStartColor) + b * GetGValue(FEndColor)),
                round(a * GetBValue(FStartColor) + b * GetBValue(FEndColor)) );
end;

procedure TAniString.SetText(const Value: WideString);
begin
  FText := Value;
end;

procedure TAniString.SetTime(const Value: double);
begin
  FTime := Value;
end;

procedure TAniString.Start;
begin
  FPos := FStartPos;
  FColor := FStartColor;
  FMaxStep := round(FTime / FTimer.Interval);
  Step := 0;
end;

procedure TAniString.StartTimer;
begin
  FMaxStep := round(FTime / FTimer.Interval);
  FTimer.Enabled := true;
end;

{ TLanAnimation }

procedure TLanAnimation.Animate(Sender: TObject);
begin
  if not Freezing then
    Draw;
  if FStep < FMaxStep then
  begin
    Inc(FStep);
    FLeft.Move;
    FUp.Move;
    FRight.Move;
    FDown.Move;
  end
  else
    Finish;
end;

constructor TLanAnimation.Create;
var
  d: Cardinal;
  t: integer;
begin
  inherited Create(AOwner);
  FString := TAniString.Create;
  FLeft := TAniString.Create;
  FRight := TAniString.Create;
  FUp := TAniString.Create;
  FDown := TAniString.Create;
  FTimer := TTimer.Create(Self);
  FTimer.Enabled := false;
  FTimer.OnTimer := Animate;
  FTimer.Interval := 40;
  FTime := 800;
  FBitMap := TBitmap.Create;
  FCanvas2 := FBitmap.Canvas;
  Color := clWhite;
  Font.Size := 12;
  FUpColor := clBlack;
end;

destructor TLanAnimation.Destroy;
begin
  FString.Free;
  FLeft.Free;
  FRight.Free;
  FUp.Free;
  FDown.Free;
  inherited;
end;

procedure TLanAnimation.DoFinished;
begin
  if Assigned(FOnFinished) then
    FOnFinished(Self);
end;

procedure TLanAnimation.Draw;
begin
  FCanvas2.Brush.Color := Color;
  FCanvas2.FillRect(Rect(0, 0, Width, Height));
  if FDown <> nil then
    FDown.Draw;
  if FLeft <> nil then
    FLeft.Draw;
  if FUp <> nil then
    FUp.Draw;
  if FRight <> nil then
    FRight.Draw;
  Canvas.CopyRect(Rect(0, 0, Width, Height), FCanvas2, Rect(0, 0, Width, Height));
end;

procedure TLanAnimation.Finish;
begin
  if FTimer.Enabled then
  begin
    FTimer.Enabled := false;
    FLeft.Finish;
    FRight.Finish;
    FUp.Finish;
    FDown.Finish;
    Animate(nil);
    FFreezing := false;
    DoFinished;
  end;
end;

function TLanAnimation.GetInterval: Integer;
begin
  Result := FTimer.Interval;
end;

function TLanAnimation.GetPos(S: WideString): TPoint;
begin
  FString.Text := S;
  Result.X := FPos.X - (FString.Size.cx div 2);
  Result.Y := FPos.Y - (FString.Size.cy div 2);
end;

procedure TLanAnimation.IniConfig;
const
  D = 50;
var
  W, T, X: Cardinal;
  P: TPoint;
  NewText: WideString;
begin
  init;
  FMaxStep := round(FTime / Interval);
  FStep := 0;
  FBitmap.SetSize(Width, Height);

  if FNewString = eps then
    NewText := Copy(FText, 1, FFirst - 1)
      + Copy(FText, FLast + 1, length(FText) - FLast)
  else
    NewText := Copy(FText, 1, FFirst - 1) + FNewString
      + Copy(FText, FLast + 1, length(FText) - FLast);


  P := GetPos( NewText );
  T := P.Y;

  with FLeft do
  begin
    Text := Copy(Self.FText, 1, FFirst - 1);
    StartPos := GetPos(Self.FText);
    EndPos := P;
    StartColor := clBlack;
    EndColor := clBlack;
    Start;
  end;

  with FUp do
  begin
    Text := Copy(Self.FText, FFirst, FLast - FFirst + 1);
    StartPos := Point(FLeft.StartPos.X + FLeft.Size.cx, T);
    EndPos := Point( StartPos.X, StartPos.Y - D);
    StartColor := FUpColor;
    EndColor := Self.Color;
    Start;
  end;

  with FDown do
  begin
    Text := FNewString;
    StartPos := Point( FLeft.EndPos.X + FLeft.Size.cx, T + D);
    EndPos := Point( StartPos.X, T);

    if Text = eps then
    begin
      StartColor := clBlack;
      EndColor := Self.Color;
      FEndVisible := false;
    end
    else
    begin
      StartColor := Self.Color;
      EndColor := FUpColor;
      FEndVisible := true;
    end;

    Start;
  end;

  with FRight do
  begin
    Text := Copy(Self.FText, FLast + 1, length(Self.FText) - FLast);
    StartPos := Point( FUp.StartPos.X + FUp.Size.cx, T);
    EndPos := Point( FDown.StartPos.X + FDown.Size.cx, T);
    StartColor := clBlack;
    EndColor := clBlack;
    Start;
  end;
end;

procedure TLanAnimation.Init;
  procedure f(S: TAniString);
  begin
    with S do
    begin
      Canvas := Self.FCanvas2;
      Font.Assign(Self.Font);
      StartColor := clBlack;
      EndColor := clBlack;
      Interval := Self.Interval;
      Time := Self.FTime;
    end;
  end;
begin
  f(FString);
  f(FLeft);
  f(FRight);
  f(FDown);
  f(FUp);

  FPos.X := Width div 2;
  FPos.Y := Height div 2;
  FTextPos := GetPos(FText);
end;

function TLanAnimation.IsPlaying: Boolean;
begin
  Result := FTimer.Enabled;
end;

procedure TLanAnimation.Paint;
begin
  Draw;
  inherited;
end;

procedure TLanAnimation.SetFirst(const Value: Integer);
begin
  FFirst := Value;
end;

procedure TLanAnimation.RefreshFont;
  procedure f(S: TAniString);
  begin
    if S <> nil then
    with S do
      Font.Assign(Self.Font);
  end;
begin
  f(FString);
  f(FLeft);
  f(FRight);
  f(FDown);
  f(FUp);
end;

procedure TLanAnimation.SetFreezing(const Value: Boolean);
begin
  FFreezing := Value;
end;

procedure TLanAnimation.SetInterval(const Value: Integer);
begin
  FTimer.Interval := Value;
end;

procedure TLanAnimation.SetInverse(const Value: Boolean);
begin
  FInverse := Value;
  FLeft.Inverse := Value;
  FRight.Inverse := Value;
  FUp.Inverse := Value;
  FDown.Inverse := Value;
end;

procedure TLanAnimation.SetLast(const Value: Integer);
begin
  FLast := Value;
end;

procedure TLanAnimation.SetNewString(const Value: WideString);
begin
  FNewString := Value;
end;

procedure TLanAnimation.SetOnFinished(const Value: TNotifyEvent);
begin
  FOnFinished := Value;
end;

procedure TLanAnimation.SetPos(const Value: TPoint);
begin
  FPos := Value;
end;

procedure TLanAnimation.SetText(const Value: WideString);
begin
  FText := Value;
end;

procedure TLanAnimation.SetTime(const Value: integer);
begin
  FTime := Value;
end;

procedure TLanAnimation.SetUpColor(const Value: TColor);
begin
  FUpColor := Value;
end;

procedure TLanAnimation.Start;
begin
  IniConfig;
  FTimer.Enabled := true;
end;

end.
