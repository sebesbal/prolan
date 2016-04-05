unit UGrammar;

interface

{$DEFINE USETHREAD}

uses
  UBase, Classes, TntComCtrls, TntGrids, Graphics, TntClasses;

type

  TSGRule = class(TSLine)
  protected
    FLeft: TList;
    FRight: TList;
  public
    class function MakePrint: TSGRule;
    procedure Build(EP: TEProgram); override;
    constructor Create(L: TList; R: TList); reintroduce;
    destructor Destroy; override;
  end;

  TEGrammar = class(TEProgram)
  public
    procedure ToListView(LV: TTntListView); override;
    procedure GetDefinition(L: TTntStrings); override;
    procedure RunTree(D: Integer); override;
    procedure RunList(D: Integer); override;
    procedure RunLang; override;
    procedure GetNTerms(L: TStringList; WithStart: Boolean = false);
  end;

  {* nyelvtani szabályt reprezentál *}
  TEGRule = class(TELine)
  private
    FLeft: TESentence;
    FRight: TESentence;
    procedure SetLeft(const Value: TESentence);
    procedure SetRight(const Value: TESentence);
  public
    function IsPrint: Boolean; override;
    property Left: TESentence read FLeft write SetLeft;
    property Right: TESentence read FRight write SetRight;
    function ToAnsiString: String; override;
    function ToString(UseSpace: Boolean = false): WideString; override;
    constructor Create; overload;
    destructor Destroy; override;
  end;

  {* a levezetés egy konfigurációja *}
  TGConfig = class(TConfig)
  protected
    FPriority: double;     // prioritás nyelv generáláshoz
    FLevel: Integer;       // távolság a gyökértõl
    FSucceeded: Boolean;   // befejezõdött
    FLetterInd: Integer;   // illesztés pozíciója
    FSentence: TESentence; // aktuális mondatforma
    procedure MakeChildren; override;
  public
    procedure SetColor(S: TESentence; var C: TColor; HideColor: Boolean); override;
    property Succeeded: Boolean read FSucceeded write FSucceeded;
    function GetTreeString: WideString; override;
    function GetLangString: WideString; override;
    procedure DrawTreeNode(C: TCanvas; Left, Top: Integer; Color: TColor); override;
    function MakeListNodeCond(TV: TObject = nil): TObject; override;
    class procedure RunLang(C: TGConfig); overload;
    procedure RunLang(D: Integer); overload; override;
    function IsTerminal: Boolean; override;
    property LetterInd: Integer read FLetterInd;
    function ToString(UseSpace: Boolean = false): WideString; override;
    function Rule: TEGRule;
    function StateToString(UseSpace: Boolean = false): WideString; override;
    property Sentence: TESentence read FSentence;
    function Add(B: Boolean; C: TConfig): TConfig; overload;
    function Add(B: Boolean; K: Integer; R: TEBasLine): TGConfig; overload;
    function GetMatrix: TCMatrix; override;
    constructor Create(P: TConfig; L: TEBasLine; I: Integer; S: TESentence);
    destructor Destroy; override;
  end;

  {* nyelv generálás thread-je *}
  TGThread = class(TEThread)
    procedure RunConfig; override;
  end;

implementation

uses
  SysUtils, URunFrm, StrUtils, Contnrs, TNTGraphics, UHeap;

var
  GLanLangThread: TGThread;

{ TSLanRule }

constructor TSGRule.Create(L: TList; R: TList);
begin
  inherited Create;
  FLeft := TList.Create;
  FLeft.Assign(L);
  FRight := TList.Create;
  FRight.Assign(R);
end;

destructor TSGRule.Destroy;
begin
  FRight.Free;
  inherited;
end;

class function TSGRule.MakePrint: TSGRule;
var
  L: TList;
begin
  L := TList.Create;
  L.Add(GSPrint);
  Result := TSGRule.Create(L, L);
  L.Free;
end;

procedure TSGRule.Build;
var
  L: TEGRule;
  M: TList;
begin
  L := TEGRule.Create;
  if Lab <> nil then
    EP.AddRule(L, Lab.Name)
  else
    EP.AddRule(L);
  Instance := L;
  M := ListInst(FLeft);
  L.Left := TESentence.Create(M);
  M.Free;
  M := ListInst(FRight);
  L.Right := TESentence.Create(M);
  M.Free;
  L.Sig.Assign(Sig);
  L.Fi.Assign(Fi);
  L.FSLine := Self;
  inherited;
end;

{ TELanProgram }

procedure TEGrammar.ToListView(LV: TTntListView);

  procedure f(A: TEBasLine);
  var
    I: Integer;
    C: TECall;
  begin
    if A is TEGRule then
    begin
      with LV.Items.Add do
      begin
        Caption := A.Name;
        Data := A;
        if TEGRule(A).IsPrint then
          SubItems.Add('print')
        else
          SubItems.Add(TEGRule(A).Left.ToString + ' ' + nyil + TEGRule(A).Right.ToString);
        SubItems.Add(ListToStr(TEGRule(A).Sig));
        SubItems.Add(ListToStr(TEGRule(A).Fi));
      end;
    end

    else if A is TECall then
    begin
      C := TECall(A);
      for I := 0 to C.Lines.Count - 1 do
        f(TEBasLine(C.Lines[I]));
    end
  end;

var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    f(Self[I]);
end;

procedure TEGrammar.GetDefinition(L: TTntStrings);
var
  N: TStringList;
  I, K: Integer;

  procedure f(A: TEBasLine);
  var
    I: Integer;
    C: TECall;
  begin
    if A is TEGRule then
    begin
      N.Add(A.Name);
      L.Add(A.Name + ':  '
        + TEGRule(A).Left.ToString + ' ' + nyil + ' ' + TEGRule(A).Right.ToString
        + #9 + gsig + ': ' + ListToStr2(TEGRule(A).Sig)
        + #9 + gfi + ': ' + ListToStr2(TEGRule(A).Fi))
    end
    else if A is TECall then
    begin
      C := TECall(A);
      for I := 0 to C.Lines.Count - 1 do
        f(TEBasLine(C.Lines[I]));
    end
  end;

begin
  N := TStringList.Create;
  L.Clear;

  N.Clear;
  GetTerms(N);
  I := N.IndexOf('eps');
  if I > -1 then
    N.Delete(I);
  L.Add('Terminális jelek:' + #13#10#9 + ListToStr2(N) + #13#10);

  N.Clear;
  GetNTerms(N, true);
  L.Add('Nemterminális jelek:' + #13#10#9 + ListToStr2(N) + #13#10);

  L.Add('Startszimbólum:' + #13#10#9 + FStart.Name + #13#10);

  N.Clear;
  K := L.Count;
  L.Add('Szabályok:');
  for I := 0 to Count - 1 do
    f(TEBasLine(Self[I]));

  L.Insert(K, 'Címkék:' + #13#10#9 + ListToStr2(N) + #13#10);

  N.Free;
end;

procedure TEGrammar.GetNTerms(L: TStringList; WithStart: Boolean = false);
var
  I: Integer;
begin
  for I := 0 to FNames.Count - 1 do
    if TObject(FNames.Objects[I]) is TENTerm then
      L.Add(FNames[I]);
  if not WithStart then
  begin
    I := L.IndexOf(FStart.Name);
    if I > -1 then
      L.Delete(I);
  end;
end;

procedure TEGrammar.RunTree(D: Integer);
var
  C: TGConfig;
begin
  try
    if FLines.Count > 0 then
    begin
      Select(vtTree);
      FTreeView.Items.Clear;
      C := TGConfig.Create(nil, FFirst, 0, TESentence.Create([FStart]));
      FStartTree := C;
      C.MakeTreeNode(FTreeView);
      C.RunTree(D);
    end;
  except
    else
      raise Exception.Create('Runtime Error!');
  end;
end;

procedure TEGrammar.RunLang;
begin
  try
    inherited;
    if FLines.Count > 0 then
    begin
      Select(vtSet);
      FListView.Items.Clear;
      if GThread <> nil then
      begin
        GThread.Terminate;
        GThread := nil;
      end;

      GThread := TGThread.Create; //(true);
      if FRunFrm is TRunFrm then
      begin
        GThread.ListView := TRunFrm(FRunFrm).lvLang;
        GThread.OnTerminate := TRunFrm(FRunFrm).PageControl1.OnChange;
      end;
      GThread.Priority := tpLowest;
      GThread.Config := TGConfig.Create(nil, FFirst, 0, TESentence.Create([FStart]));
      FStartLang := GThread.Config;
      GThread.Limit := GDbLimit;
      GThread.Resume;
    end;
  except
    else
      raise Exception.Create('Runtime Error!');
  end;
end;

procedure TEGrammar.RunList(D: Integer);
var
  C: TGConfig;
begin
  try
    if FLines.Count > 0 then
    begin
      Select(vtList);
      FListView.Items.Clear;
      C := TGConfig.Create(nil, FFirst, 0, TESentence.Create([FStart]));
      FStartList := C;
      C.Node := FListView;
      C.MakeListNode(FListView);
      C.RunList(D);
      if (FRunFrm <> nil) and (C.Items.Count > 0) then
        TRunFrm(FRunFrm).AniFrm1.Config := TConfig(C.Items[0]);
    end;
  except
    else
      raise Exception.Create('Runtime Error!');
  end;
end;

{ TELanRule }

constructor TEGRule.Create;
begin
  inherited Create;
//  FRo := TList.Create;
//  FFi := TList.Create;
end;

destructor TEGRule.Destroy;
begin
  FRight.Free;
  inherited;
end;

function TEGRule.IsPrint: Boolean;
begin
  Result := (FLeft.Count = 1) and (TELetter(FLeft[0]) = GEPrint);
end;

procedure TEGRule.SetLeft(const Value: TESentence);
begin
  FLeft := Value;
end;

procedure TEGRule.SetRight(const Value: TESentence);
begin
  FRight.Free; //?
  FRight := Value;
end;

function TEGRule.ToAnsiString: String;
  function f(S: string; i: integer): string;
  begin
    if length(S) < i then
      Result := DupeString(' ', i - length(S)) + S
    else
      Result := S;
  end;
begin
  Result := f(Name, 3) + ':  ' + f(LEft.ToString, 3) + ' ='
  + f(Right.ToString, 10) + ',' + f(ListToStr(Sig), 10) + ',' + f(ListToStr(Fi), 10);
end;

function TEGRule.ToString(UseSpace: Boolean = false): WideString;
  function f(S: string; i: integer): string;
  begin
    if length(S) < i then
      Result := S + DupeString(' ', i - length(S))
    else
      Result := S;
  end;
begin
  Result := f(Name + ': ', 6);
  if Left = nil then
    // skip
  else if IsPrint then
    Result := Result + 'print'
  else
    Result := Result + Left.ToString(UseSpace)
      + nyil + Right.ToString(UseSpace);
end;

{ TGConfig }

{* Config gyereket ad hozzá:
  Letterpos: K; Line: R; Sentence: alkalmazza Rule-t a K-adik pozíción *}
function TGConfig.Add(B: Boolean; K: Integer; R: TEBasLine): TGConfig;
var
  I: Integer;
begin
  Result := TGConfig(ClassType.Create);
  Result.Create(Self, R, K, TESentence.Create);
  Result.Sentence.Items.Assign(Sentence.Items);
  if (K >= 0) and not (Line is TEStart) then
    Result.FSentence.Insert(K, K + Rule.Left.Count - 1, Rule.Right);
  if Add(B, Result) = nil then
    FreeAndNil(Result);
end;

function TGConfig.GetLangString: WideString;
begin
  Result := Sentence.ToString(GUSpace);
end;

function TGConfig.GetMatrix: TCMatrix;
var
  I: Integer;
  C: TGConfig;
begin
  Result := TCMatrix.Create;
  for I := 0 to Items.Count - 1 do
  begin
    C := TGConfig(Items[I]);
    if Result.Rows.IndexOf(C.Line) = -1 then
      Result.Rows.Add(C.Line);
    if Result.Cols.IndexOf(Pointer(C.FLetterInd)) = -1 then
      Result.Cols.Add(Pointer(C.FLetterInd));
  end;

  SetLength(Result.Items, Result.Rows.Count, Result.Cols.Count);

  for I := 0 to Items.Count - 1 do
  begin
    C := TGConfig(Items[I]);
    Result.Items[Result.Rows.IndexOf(C.Line),
      Result.Cols.IndexOf(Pointer(C.FLetterInd))] := C;
  end;
end;

function TGConfig.GetTreeString: WideString;
begin
  if Rule = nil then
    Result := Sentence.ToString(GUSpace) + '     ' + Line.ToString(GUSpace)
  else
    Result := Sentence.ToString(GUSpace) + '     '
      + Rule.Left.ToString(GUSpace) + ' ' + nyil + Rule.Right.ToString(GUSpace);
end;

function TGConfig.IsTerminal: Boolean;
begin
  Result := FSentence.IsTerminal;
end;

{* létrehozza a konfig gyerekeit *}
procedure TGConfig.MakeChildren;

  procedure ChoiceRule(LetterPos: integer);
  var
    L: TList;
    I: Integer;
    R: TELine;
    B: Boolean;
  begin
    if LetterPos < 0 then
    begin
      B := false;
      L := TELine(Line).Fi;
    end
    else
    begin
      B := true;
      L := TELine(Line).Sig;
    end;

    if L.Count = 0 then
      // SKIP
    else if GRuleChoice = fmAll then
    begin
      R := TEGRule(ChoiceList(L, GRuleChoice2));
      Add(B, LetterPos, R);
      for I := 0 to L.Count - 1 do
        if L[I] <> R then
          Add(B, LetterPos, TEGRule(L[I]));
    end
    else
      Add(B, LetterPos, TEGRule(ChoiceList(L, GRuleChoice)));
  end;

  {* Egy darab Exit gyereket ad hozzá *}
  procedure AddExit;
  var
    C: TGConfig;
    K: Integer;
  begin
    K := FSentence.Find(0, Rule.Left);
    C := TGConfig(ClassType.Create);
    C.Create(Self, GetProgram.PExit, K, TESentence.Create);
    C.Sentence.Items.Assign(Sentence.Items);
    if (K >= 0) and not (Line is TEStart) then
      C.Sentence.Insert(K, K + Rule.Left.Count - 1, Rule.Right);
    Add(false, C);
  end;

var
  T: intarray;
  I, K, L: integer;

label
  vege;

begin
  if Line is TEExit then
    exit
  else if Line is TEStart then
    ChoiceRule(0)
  else if not (Line is TEGRule) or (Rule.Left = nil) then
    // Skip
  else
  begin
    if GLetterChoice = fmAll then
    begin
      K := FSentence.FindAll(Rule.Left, T);
      if K = 0 then
        ChoiceRule(-1)
      else
      begin
        L := ChoiceInt(K, GLetterChoice2);
        ChoiceRule(T[L]);
        for I := 0 to K - 1 do
          if I <> L then
            ChoiceRule(T[I]);
      end;
    end
    else
      ChoiceRule(FSentence.Find(Rule.Left, GLetterChoice));
  end;
vege:
  if Items.Count = 0 then
    AddExit;
end;

function TGConfig.MakeListNodeCond(TV: TObject): TObject;
var
  C: TConfig;
begin
  C := Parent;
  {* print eset: *}
  if ((C <> nil) and (C.Line<>nil) and (C.Line.IsPrint)) then
    MakeListNode(TV)
  else
    if not GDeterm then
    begin
      {* ha determ elrejtés van, akkor: *}
      if IsLast or (C.Items.Count > 1) then
        Result := Inherited MakeListNodeCond(TV)
    end
    else
      Result := Inherited MakeListNodeCond(TV);
end;

function TGConfig.Rule: TEGRule;
begin
  if FLine is TEGRule then
    Result := TEGRule(FLine)
  else
    Result := nil;
end;

function TGConfig.ToString(UseSpace: Boolean = false): WideString;
begin
  if Line is TEGRule then
    if Rule.Left = nil then
      Result := FSentence.ToString(UseSpace) + '    ' + Rule.Name
    else
      Result := FSentence.ToString(UseSpace) + '    '
        + Rule.Left.ToString(UseSpace) + ' ' + nyil + Rule.Right.ToString(UseSpace);
end;

procedure TGConfig.SetColor(S: TESentence; var C: TColor; HideColor: Boolean);
begin
  if HideColor then
  begin
    S.First := -1;
    exit;
  end;

  if S.IsTerminal then
  begin
    S.First := 0; S.Last := S.Count - 1;
    C := colAccept;
  end
  else if (Items.Count > 0) and (TObject(Items[0]) is TGConfig)
    and (Rule <> nil) then
  begin
    C := colselect;
    S.First := TGConfig(Items[0]).LetterInd;
    S.Last := S.First + Rule.Left.Count - 1;
  end
  else
  begin
    S.First := 0; S.Last := S.Count - 1;
    C := colexit;
  end;
end;

function TGConfig.StateToString(UseSpace: Boolean = false): WideString;
begin
  Result := FSentence.ToString(UseSpace);
end;

function TGConfig.Add(B: Boolean; C: TConfig): TConfig;
var
  L: TGConfig;
  I: Integer;

begin
  L := C as TGConfig;

  if L.Sentence.Count > GMaxLength then
  begin
    Result := nil;
    exit;
  end;

  {* Terminális mondatot csak egyszer ad hozzá *}
  if L.Sentence.IsTerminal then
    C.SetLine(GetProgram.PExit);

  {* Nem ad hozzá olyan konfigurációt, ami zsákutca *}
  if not GDeadEnd then
  begin
    if (L.Rule <> nil) and (L.Sentence.Find(0, L.Rule.Left) < 0)
      and ((L.Rule.Fi.Count = 0) or ((L.Rule.Fi.Count = 1) and (L.Rule.Fi[0] = GetProgram.PExit)) ) then
      begin
        Result := nil;
        exit;
      end
  end;

  {* Nem ad hozzá olyan konfigurációt, ami már szerepel *}
    for I := 0 to Items.Count - 1 do
      if (TGConfig(Items[I]).Sentence.Equal(L.Sentence))
        and (TGConfig(Items[I]).FLine = L.FLine) then
        begin
          Result := nil;
          exit;
        end;

  Result := inherited Add(C);
  if Result <> nil then
    TGConfig(Result).Succeeded := B;
end;

constructor TGConfig.Create(P: TConfig; L: TEBasLine; I: Integer; S: TESentence);
begin
  inherited Create(P, L);
  FLetterInd := I;
  FSentence := S;
end;

destructor TGConfig.Destroy;
begin
  FSentence.Free;
  inherited;
end;

procedure TGConfig.DrawTreeNode(C: TCanvas; Left, Top: Integer; Color: TColor);
var
  S1, S2, S3, S4: WideString;
  X: Integer;
  Col: TColor;
begin
  with Sentence do
  begin
    S1 := ToString(GUSpace, 0, First - 1);
    S2 := ToString(GUSpace, First, Last);
    S3 := ToString(GUSpace, Last + 1, Count - 1);
    if Rule <> nil then
      S4 := '     ' + Rule.Left.ToString(GUSpace) + ' ' + nyil + Rule.Right.ToString(GUSpace)
    else
      S4 := '     ' + Line.ToString(GUSpace);

    if Count = 0 then
      S1 := eps;

    Col := C.Font.Color;
    WideCanvasTextOut(C, Left, Top, S1);

    C.Font.Color := Color; // TColor($0088EE);
    X := WideCanvasTextExtent(C, S1).cx;
    WideCanvasTextOut(C, Left + X, Top, S2);

    C.Font.Color := Col;
    X := X + WideCanvasTextExtent(C, S2).cx;
    WideCanvasTextOut(C, Left + X, Top, S3);

    C.Font.Color := Col;
    X := X + WideCanvasTextExtent(C, S3).cx;
    WideCanvasTextOut(C, Left + X, Top, S4);


    C.Font.Color := Col;
  end;
end;

{* összehasonlító függvény a kupac számára *}
function Comp(C1, C2: HeapItem): Integer;
var
  X, Y: double;
begin
  X := TGConfig(C1).FPriority;
  Y := TGConfig(C2).FPriority;
  if X < Y  then
    Result := -1
  else if X > Y then
    Result := 1
  else Result := 0;
end;

class procedure TGConfig.RunLang(C: TGConfig);
var
  H: THeap;
  I, K: Integer;
  T: TGThread;

  {* kiszámolja a konfiguráció prioritását, és belerakja a kupacba *}
  procedure AddToHeap(C: TGConfig);
  var
    I, K: integer;
  begin
    {* távolság a gyökértõl *}
    if C.Parent = nil then
      C.FLevel := 0
    else
      C.FLevel := TGConfig(C.Parent).FLevel + 1;

    {* nemterminálisok száma *}
    K := 0;
    for I := 0 to C.FSentence.Count - 1 do
      if C.FSentence[I] is TENTerm then
        Inc(K);

    C.FPriority := C.FLevel + K;
    H.Insert(C);
  end;

label
  vege;
begin
  {* prioritásás sor (kupac): *}
  H := THeap.Create;
  H.Compare := Comp;
  H.HeapType := hMin;

  AddToHeap(C);
  K := 0;
  T := TGThread(GThread);

  if T.Terminated then
    goto vege;

  while (H.Count > 0) and not T.Terminated do
  begin
    C := TGConfig(H.Pop);
    if C.FSentence.IsTerminal then
    begin
      T.Config := C;
      T.Synchronize(T.GetResults);
    end
    else
    begin
      C.MakeChildren;
      C.FRuned := true;
      for I := 0 to C.FChildren.Count - 1 do
        AddToHeap(C.FChildren[I]);
    end;

    inc(K);

    if (K mod 1000 = 0) and T.Expired then
      T.Terminate;
  end;

vege:
  H.Free;
end;

procedure TGConfig.RunLang(D: Integer);
begin
  TGConfig.RunLang(Self);
end;

{ TLanThread }

procedure TGThread.RunConfig;
begin
  TGConfig.RunLang(TGConfig(Config));
end;

end.
