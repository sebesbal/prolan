unit UPushDown;

interface

uses
  UTuring, Classes, SysUtils, UBase, TntComCtrls, Graphics, TntClasses;

type

  {* verem fajtája: érvénytelen, üres veremmel felismerõ, végállapottal felismerõ *}
  TPushDownKind = (skInvalid, skEmpty, skAccept);

  {* veremmûveletet leíró utasítás a szintaxisfában (pl. Z = 0 Z;) *}
  TSSLine = class(TSBLine)
  public
    procedure Build(EP: TEProgram); override;
    class function MakePrint: TSSLine;
    constructor Create(A, B: TList); overload;
  end;

  {* "futtatható" veremautomata *}
  TEPushDown = class(TETuring)
  protected
    FEmptyMode: Boolean;
  public
    procedure GetTapeAlphabet(L: TStringList); override;
    property EmptyMode: Boolean read FEmptyMode write FEmptyMode; 
    function GetTurConfigClass: TTurConfigClass; override;
    procedure RunTree(D: Integer); override;
    procedure RunList(D: Integer); override;
    function CanRead(L: TELetter): Boolean; override;
    function CanStep(L: TELetter): Boolean; override;
    procedure ToListView(LV: TTntListView); override;
    procedure GetDefinition(L: TTntStrings); override;
    function GetPushDownKind(L: TList): TPushDownKind;
    procedure RunLang3; override;
  private
    function GetConfigClass: TConfigClass;
  end;

  TSConfig = class(TTConfig)
  public
    procedure SetColor(S: TESentence; var C: TColor; HideColor: Boolean); override;
    function IsAccept: Boolean;
    function IsFail: Boolean;
    function MakeTreeNode(TV: TObject = nil): TObject; override;
    function MakeListNodeCond(TV: TObject = nil): TObject; override;
    procedure DrawTreeNode(C: TCanvas; Left, Top: Integer; Color: TColor); override;
    function GetTreeString: WideString; override;
    function Read: TELetter; override;
    procedure MakeChildren; override;
    function Add(State: TELine; R: TETRule; Re, W: TELetter;
      D: TDirection): TTConfig; override;
    function IsLast: Boolean; override;
  end;

implementation

uses
  TNTGraphics, URunFrm;

{ TSSLine }

procedure TSSLine.Build(EP: TEProgram);
var
  L: TList;
  S: TESentence;
begin
  inherited;
  L := ListInst(FDirection as TList);
  S := TESentence.Create(L);
  TEBRule(Instance).Dir := S;
  L.Free;
  S.Free;
end;

constructor TSSLine.Create(A, B: TList);
begin
  inherited Create(nil, nil);
  if A.Count <> 1 then
    raise Exception.Create('Érvénytelen PushDown szabály');
  FLetter := TSLetter(A[0]);
  FDirection := TList.Create;
  TList(FDirection).Assign(B);
end;

class function TSSLine.MakePrint: TSSLine;
var
  L: TList;
begin
  L := TList.Create;
  L.Add(GSPrint);
  Result := TSSLine.Create(L, L);
//  Result.FShowCount := 1;
  L.Free;
end;

{ TEPushDown }

function TEPushDown.CanRead(L: TELetter): Boolean;
begin
  Result := (L <> FEps) and not (L is TEBlank);
end;

function TEPushDown.CanStep(L: TELetter): Boolean;
begin
  Result := (L <> FEps) and not (L is TEBlank);
end;

function TEPushDown.GetPushDownKind(L: TList): TPushDownKind;
var
  I: Integer;
  S: TETState;
  M: TList;
begin
  Result := skInvalid;

  for I := 0 to FStates.Count - 1 do
  begin
    S := TETState(FStates[I]);
    M := S.Rules[S.Progi.LetterIndex(Blank)];
    if M.Count = 0 then
      // Skip
    else if M.Count = 1 then
    begin
      if TETRule(M[0]).Right = nil then
      begin
        // találtunk egy végállapotot
        L.Add(S);
        Result := skAccept;
      end
      else
        exit // hiba
    end
    else
      exit; // hiba
  end;

  if FSProgram.ProgType = ptPushDown then
    if Result = skAccept then
      // OK
    else
      Result := skInvalid
  else if FSProgram.ProgType = ptEPushDown then
    if Result = skInvalid then
      Result := skEmpty
    else
      Result := skInvalid
  else
    Result := skInvalid;
end;

function TEPushDown.GetConfigClass: TConfigClass;
begin
  Result := TSConfig;
end;

procedure TEPushDown.GetDefinition(L: TTntStrings);
  procedure f(A: TETState);
  var
    I, J: Integer;
    C: TECall;
    P: TETuring;
    R: TETRule;
    B: Boolean;
  begin
    P := A.Progi;
    B := false;
    for I := 0 to P.LetCount - 1 do
      for J := 0 to A.Rules[I].Count - 1 do
      begin
        R := TETRule(A.Rules[I][J]);
        if R.Right <> nil then
        begin
          L.Add(gdelta + '( ' + A.Name + ', '
          + R.Left.Name + ' ) = ( '
          + TETState(R.Sig).Name + ', '
          + R.Right.Name + ', '
          + DirToStr(R.Dir) + ' )');
        end;
      end;
  end;

var
  I: Integer;
  N: TStringList;
  M: TList;
begin
  N := TStringList.Create;
  M := TList.Create;

  L.Clear;
  L.Add('Bemenet:' + #13#10#9 + FInput.ToString + #13#10);

  L.Add('Állapotok:' + #13#10#9 + ListToStr2(FStates) + #13#10);

  L.Add('Kezdõ állapot:' + #13#10#9 + FStartState.Name + #13#10);

  case GetPushDownKind(M) of
    skInvalid:
    begin
      L.Clear;
      L.Add('Érvénytelen veremautomata!');
      exit;
    end;
    skEmpty:
      L.Add('Üres veremmel felismerõ' + #13#10);
    skAccept:
      L.Add('Végállapottal felismerõ automata. Végállapotok:' + #13#10#9 + ListToStr2(M) + #13#10);
  end;

  N.Clear;
  GetInputAlphabet(N);
  L.Add('Bemenõ jelek ábécéje:' + #13#10#9 + ListToStr2(N) + #13#10);

//  N.AddObject(FStart.Name, FStart);
  N.Clear;
  GetTapeAlphabet(N);
  L.Add('Veremábécé:' + #13#10#9 + ListToStr2(N) + #13#10);

  L.Add('Állapotátmenetek:');
  for I := 0 to FStates.Count - 1 do
    f(TETState(FStates[I]));
  N.Free;
  M.Free;
end;


procedure TEPushDown.GetTapeAlphabet(L: TStringList);
var
  I: Integer;
begin
  for I := 0 to FLetCount - 1 do
    if (FLetters[I].Name = eps) or (FLetters[I] = Blank) then
      // Skip
    else
      L.AddObject(FLetters[I].Name, FLetters[I]);
end;

function TEPushDown.GetTurConfigClass: TTurConfigClass;
begin
  Result := TSConfig;
end;

procedure TEPushDown.RunLang3;
var
  C, D: TTConfig;
  L: TList;
  T: TTurThread;
  Old: TESentence;
  B: Boolean;
  I, N, M: Integer;
  A: IntArray;
begin
  Old := TESentence.Create;
  Old.Assign(Input);
  T := TTurThread(GThread);
  L := TList.Create;
  for I := 0 to FLetCount - 1 do
    if (FLetters[I] is TETerm) and not (FLetters[I] = FEps)
    and not (FLetters[I] is TEBlank) then
      L.Add(FLetters[I]);

  M := L.Count;
  N := 0;
  setlength(A, 0);
  B := false;
  while not B and (N <= GDbInput) do
  begin
    Input.AssignFromArray(A, N, L);
    Next(A, N, M);
    C := GetTurConfigClass.Create(nil, FStartState, nil, 0, TESentence.Create);
    D := GetTurConfigClass.Create(nil, FFirst, nil, 0, nil);
    D.Add(C);
    C.Sentence.Items.Add(FStart);
    B := RunLang2(C);
    D.Free;
  end;
  Input.Assign(Old);
end;

procedure TEPushDown.RunList(D: Integer);
var
  C, E: TSConfig;
begin
  try
    if FLines.Count > 0 then
    begin
      Select(vtList);
      FListView.Items.Clear;
      C := TSConfig.Create(nil, FStartState, nil, 0, TESentence.Create);
      E := TSConfig.Create(nil, FFirst, nil, 0, nil);
      E.Add(C);
      C.Sentence.Items.Add(FStart);
      FStartList := C;
      C.MakeListNode(FListView);
      E.Node := FListView;
      C.RunList(D);
    end;
  except
    else
      raise Exception.Create('Runtime Error!');
  end;
end;

procedure TEPushDown.RunTree(D: Integer);
var
  C: TSConfig;
begin
  try
    if FLines.Count > 0 then
    begin
      Select(vtTree);
      FTreeView.Items.Clear;
      C := TSConfig.Create(nil, FStartState, nil, 0, TESentence.Create);
      TTConfig.Create(nil, FFirst, nil, 0, nil).Add(C);
      C.Sentence.Items.Add(FStart);

      FStartTree := C;
      C.MakeTreeNode(FTreeView);
      C.RunTree(D);
    end;
  except
    else
      raise Exception.Create('Runtime Error!');
  end;
end;

procedure TEPushDown.ToListView(LV: TTntListView);
  procedure f(A: TETState);
  var
    I, J: Integer;
    C: TECall;
    P: TETuring;
    R: TETRule;
    B: Boolean;
    S: WideString;
  begin
    P := A.Progi;
    B := false;
    for I := 0 to P.LetCount - 1 do
      for J := 0 to A.GetRules(I).Count - 1 do
      begin
        with LV.Items.Add do
        begin
          if not B then
          begin
            Caption := A.Name; // Áll.
            B := true;
          end
          else
            Caption := '';
          R := TETRule(A.GetRules(I)[J]);
          Data := R;
          SubItems.Add(R.Left.Name);        // Olvas
          if R.Right = nil then
            SubItems.Add('')
          else
            SubItems.Add(R.Right.Name);       // Pop
          SubItems.Add(DirToStr(R.Dir));    // Push
          SubItems.Add(TETState(R.Sig).Name); // Új Áll.
        end;
      end;
    Lv.Items.Add;
  end;

var
  I: Integer;
begin
  for I := 0 to FStates.Count - 1 do
    f(TETState(FStates[I]));
end;

{ TSConfig }

function TSConfig.GetTreeString: WideString;
begin
  Result := GetProgram.Input.ToString(GUSpace) + '      '
    + Sentence.ToString(GUSpace);
end;

function TSConfig.IsAccept: Boolean;
var
  P: TEPushDown;
begin
  P := TEPushDown(GetProgram);
  if P = nil then
  else if P.EmptyMode then
    Result := (P.Input[FLetterInd] = Blank) and (Sentence.Count = 0)
  else
    Result := (Items.Count > 0) and (TConfig(Items[0]).Line is TEAccept);
end;

function TSConfig.IsFail: Boolean;
//var
//  P: TEPushDown;
begin
//  P := TEPushDown(GetProgram);
//  if P = nil then
//  else if P.EmptyMode then
    Result := IsLast and not IsAccept;
//      (P.Input[FLetterInd] = Blank) and not (Sentence.Count = 0)
//  else
//    Result :=
//    Result := (P.Input[FLetterInd] = Blank) and (Items.Count > 0) and not (TConfig(Items[0]).Line is TEAccept);
end;

function TSConfig.IsLast: Boolean;
begin
  Result := not ((Items.Count > 0) and (TConfig(Items[0]).Line is TETState));
end;

procedure TSConfig.MakeChildren;

  procedure AddExit;
  var
    C: TSConfig;
  begin
    C := TSConfig(ClassType.Create);
    C.Create(Self, GetProgram.PExit, nil, FLetterInd, TESentence.Create);
    C.Sentence.Items.Assign(Sentence.Items);
    Add(C);
  end;

  procedure AddAccept;
  var
    C: TSConfig;
  begin
    C := TSConfig(ClassType.Create);
    C.Create(Self, TEPushDown(GetProgram).FAccept, nil, FLetterInd, TESentence.Create);
    C.Sentence.Items.Assign(Sentence.Items);
    Add(C);
  end;

  procedure ChoiceRule;
  var
    L: TList;
    I: Integer;
    R: TETRule;
    M, N: TELetter;
  begin
    if State = nil then
      exit;

    M := Read;
    N := FSentence.TopItem;
    if (M = Blank) and (N = nil) and (TEPushDown(GetProgram).EmptyMode) then
    begin
      AddAccept;
      exit;
    end;


    L := State.GetRules(M, N);

    if L.Count = 0 then
      // Skip
    else if GRuleChoice = fmAll then
    begin
      R := State.GetRule(M, N, GRuleChoice2);
      Add(R);

      for I := 0 to L.Count - 1 do
        if L[I] <> R then
          Add(TETRule(L[I]));
    end
    else
      Add(State.GetRule(M, N, GRuleChoice));

    if L.Count = 0 then
      AddExit;
    L.Free;
  end;

begin
  if Line is TEStart then
    raise Exception.Create('ez nem lehet!')
  else
    ChoiceRule;
end;

{* veremautomata esetén az accept-re ugrás közben már nem csinálhat semmilyen
  mûveletet, így az utolsó accept sort fölösleges kiírni *}
function TSConfig.MakeListNodeCond(TV: TObject): TObject;
begin
  if FLine is TETState then
    Result := inherited MakeListNodeCond(TV)
  else
    Result := nil;
end;

function TSConfig.MakeTreeNode(TV: TObject): TObject;
begin
  if FLine is TETState then
    Result := inherited MakeTreeNode(TV)
  else
    Result := nil;
end;

function TSConfig.Read: TELetter;
var
  S: TESentence;
begin
  S := GetProgram.Input;
//  if (FLetterInd >= 0) and (FLetterInd <= S.Count - 1) then
//    Result := S[FLetterInd]
//  else
//    Result := Blank;
  if (FLetterInd >= 0) and (FLetterInd <= S.Count - 1) then
    Result := S[FLetterInd]
  else
  begin
    Result := Blank;
    S.Write(FLetterInd, Blank);
  end;
end;

procedure TSConfig.SetColor(S: TESentence; var C: TColor; HideColor: Boolean);
begin
  if HideColor then
  begin
    S.First := -1;
    exit;
  end
  else
    S.First := LetterInd;
  S.Last := S.First;
  
  if IsAccept then
  begin
    S.First := 0; S.Last := S.Count - 1;
    C := colAccept;
  end
  else if IsFail then
  begin
    S.First := 0; S.Last := S.Count - 1;
    C := colexit;
  end
  else
    C := colselect;
end;

function TSConfig.Add(State: TELine; R: TETRule; Re, W: TELetter; D: TDirection): TTConfig;
var
  S: TESentence;
  I: Integer;
begin
  S := TESentence.Create;
  S.Assign(FSentence); // verem

  if W = nil then
  begin
    Result := TTConfig(ClassType.Create);
    Result.Create(Self, State, R, -1, S);
    Add(Result);
    exit;
  end
  else if W = GEPrint then
  begin
    Result := TTConfig(ClassType.Create);
    Result.Create(Self, State, R, FLetterInd, S);
    Add(Result);
    exit;
  end;

  if W <> GetProgram.PEps then
    S.Pop;

  if not (D as TESentence).IsEps then
    S.Push(TESentence(D));

  if Re = GetProgram.PEps then
    I := FLetterInd
  else
    I := FLetterInd + 1;

  Result := TTConfig(ClassType.Create);
  Result.Create(Self, State, R, I, S);
  Add(Result);
end;

procedure TSConfig.DrawTreeNode(C: TCanvas; Left, Top: Integer; Color: TColor);
var
  S1, S2, S3, S4: WideString;
  X: Integer;
  Col: TColor;
  S: TESentence;
begin
  X := 0;
  S := GetProgram.Input;
  with S do
  begin
    S1 := ToString(GUSpace, 0, First - 1);
    S2 := ToString(GUSpace, First, Last);
    S3 := ToString(GUSpace, Last + 1, Count - 1);
    if Count = 0 then
      S1 := eps;

    Col := C.Font.Color;
    WideCanvasTextOut(C, Left + X, Top, S1);

    C.Font.Color := Color;
    X := X + WideCanvasTextExtent(C, S1).cx;
    WideCanvasTextOut(C, Left + X, Top, S2);

    C.Font.Color := Col;
    X := X + WideCanvasTextExtent(C, S2).cx;
    WideCanvasTextOut(C, Left + X, Top, S3);

    C.Font.Color := Col;
  end;

  X := X + WideCanvasTextWidth(C, S3);

  {* Sentence = a verem tartalma *}
  with Sentence do
  begin
    S1 := '     ' + ToString(GUSpace);
    Col := C.Font.Color;
    WideCanvasTextOut(C, Left + X, Top, S1);
  end;
end;

end.
