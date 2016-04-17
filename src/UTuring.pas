unit UTuring;

interface

uses
  Classes, UBase, TntComCtrls, Graphics, TntClasses;

type
  TETuring = class;
  TEARule = class;
  TETState = class;

  {* irány: left/right/stand, PushDown esetén a VeremBe tartalma *}
  TDirection = TObject;

  {* színek gráfbejáráshoz *}
  TEColor = (ecWhite, ecGray, ecBlack);

  {* T-gép szintaxisfájának elemei *}
  TSTLine = class(TSLine)
  protected
//    FRefs: TList;
    FLetter: TSLetter;
  public
    class function MakePrint: TSTLine;
//    constructor Create;
//    destructor Destroy; override;
  end;

  {* read utasítás *}
  TSALine = class(TSTLine)
  public
    procedure Build(EP: TEProgram); override;
    constructor Create(T: TSLetter);
  end;

  {* író/léptetõ utasítás *}
  TSBLine = class(TSTLine)
  protected
    FDirection: TDirection;
  public
    procedure Build(EP: TEProgram); override;
    constructor Create(T: TSLetter; D: TDirection);
  end;

  {* ideiglenes Turing-gép utasítások, amiket majd összevonunk
    T-gép állapotokká és átmenetekké *}
  TETLine = class(TELine)
  protected
    FRefs: TList;
    FLetter: TELetter;
    FMark: Boolean;
    FColor: TEColor;
    FTState: TETState;
  public
    function IsLetter: Boolean; override;
    procedure AddRef(L: TETLine);
    procedure RemRef(L: TETLine);
    procedure MakeRefs;
    procedure ClearRefs;
    constructor Create;
    destructor Destroy; override;
  end;

  {* read utasítása *}
  TEARule = class(TETLine)
  end;

  {* író/léptetõ utasítás *}
  TEBRule = class(TETLine)
  protected
    FDir: TDirection;
    procedure SetDir(const Value: TDirection);
  public
    property Dir: TDirection read FDir write SetDir;
  end;

  {* átmenet leíró *}
  TETRule = class(TEBasLine)
  protected
    FLeft: TELetter;
    FRight: TELetter;
    FDir: TDirection;
    FRo: TObject;
    procedure SetDir(const Value: TDirection);
    procedure SetLeft(const Value: TELetter);
    procedure SetRight(const Value: TELetter);
    procedure SetRo(const Value: TObject);
  public
    function Visible: Boolean; override;
    function IsPrint: Boolean; override;
    procedure Assign(R: TETRule);
    property Left: TELetter read FLeft write SetLeft;
    property Right: TELetter read FRight write SetRight;
    property Dir: TDirection read FDir write SetDir;
    property Sig: TObject read FRo write SetRo;
    function ToString(UseSpace: Boolean = false): WideString; override;
  end;

  {* egy állapot átmenetein lépkedõ iterátor *}
  IRuleIterator = Interface
    ['{1DC78CF9-F43C-4486-89F2-5F9770EDE9D4}']
    function GetCurrent: TETRule;
    function GetLetter: TELetter;
    procedure SetLetter(const Value: TELetter);
    procedure RemoveCurrent;
    procedure Reset;
    function Current: TETRule;
    function Next: Boolean;
    function Prev: Boolean;
    property Letter: TELetter read GetLetter write SetLetter;
  End;

  TRuleITerator = class(TInterfacedObject, IRuleIterator)
  private
    FState: TETState;
    FI, FJ, FLetCount, FLetterIndex: Integer;
    FCurrent: TETRule;
    FLetter: TELetter;
    function GetCurrent: TETRule;
    function GetLetter: TELetter;
    procedure SetLetter(const Value: TELetter);
  public
    procedure RemoveCurrent;
    procedure Reset;
    function Current: TETRule;
    function Prev: Boolean;
    function Next: Boolean;
    constructor Create(S: TETState);
    destructor Destroy; override;
  end;

  TArrayList = array of TList;

  {* T-gép egy állapota *}
  TETState = class(TELine)
  protected
    FMark: Boolean;
    FFi: TList;
    FRules: TArrayList;
    FSubs: TList;
    FProgi: TETuring;
    function RandomRule(L: TELetter): TETRule;
  public
    property Rules: TArrayList read FRules;
    function GetIterator: IRuleIterator;
    property Progi: TETuring read FProgi;
    procedure SetTermCount(N: Integer);
    procedure RemoveRule(R: TETRule);
    function AddRule(Left: TELetter; Right: TELetter; Dir: TDirection; Sig: TObject; FL: TSLine): TETRule;
    function AddComplete(Left: TELetter; Right: TELetter; Dir: TDirection; Sig: TObject): TETRule;
    procedure AddSub(R: TEARule);
    procedure MakeRules;
    procedure Expand;
    function GetRule(L: TELetter; M: TFindMode): TETRule; overload;
    function GetRule(L, N: TELetter; M: TFindMode): TETRule; overload;
    function GetRules(L: TELetter): TList; overload;
    function GetRules(L, N: TELetter): TList; overload;
    function GetRules(I: Integer): TList; overload;
    constructor Create;
    destructor Destroy; override;
  end;

  {* elfogadó állapot *}
  TEAccept = class(TELine)
    procedure ResolveA; override;
    function IsLetter: Boolean; override;
  end;

  TTConfig = class;

  TTurConfigClass = class of TTConfig;

  {* "futtatható" T-gép *}
  TETuring = class(TEProgram)
  protected
    FAccept: TEAccept;
    FStates: TList;
    FStartState: TETState;
    FLetters: array of TELetter;
    FLetCount: Integer;
    function GetConfigClass: TConfigClass;
  public
    function GetTurConfigClass: TTurConfigClass; virtual;
    function IsEmpty: Boolean; override;
    function CanRead(L: TELetter): Boolean; override;
    function CanStep(L: TELetter): Boolean; override;

    property Accept: TEAccept read FAccept;
    property LetCount: Integer read FLetCount write FLetCount;
    procedure ToListView(LV: TTntListView); override;
    procedure GetDefinition(L: TTntStrings); override;
    procedure GetInputAlphabet(L: TStringList);
    procedure GetTapeAlphabet(L: TStringList); virtual;
    function LetterIndex(T: TELetter): Integer;
    procedure SetLetters;
    procedure AddState(T: TETState);
    procedure Build(Call: TECall); override;
    procedure RunTree(D: Integer); override;
    procedure RunList(D: Integer); override;
    procedure RunLang; override;
    procedure RunLang3; virtual;
    class function RunLang2(C: TTConfig): Boolean;

    constructor Create;
    destructor Destroy; override;
  end;

  {* T-gép által felismert nyelvet generáló thread *}
  TTurThread = class(TEThread)
    FTuring: TETuring;
    procedure RunConfig; override;
  end;

  {* T-gép egy konfigurációja *}
  TTConfig = class(TConfig)
  protected
    FRule: TETRule;
    FLetterInd: Integer;
    FSentence: TESentence;
    procedure SetLetterInd(const Value: Integer);
    procedure SetSentence(const Value: TESentence);
    procedure SetRule(const Value: TETRule);
    procedure MakeChildren; override;
  public
    function IsTerminal: Boolean; override;
    procedure DrawTreeNode(C: TCanvas; Left, Top: Integer; Color: TColor); override;

    function GetTreeString: WideString; override;
    function GetLangString: WideString; override;
    function MakeListNodeCond(TV: TObject = nil): TObject; override;
    procedure SetColor(S: TESentence; var C: TColor; HideColor: Boolean); override;
    function HasRule: Boolean;
    function GetMatrix: TCMatrix; override;
    property Rule: TETRule read FRule write SetRule;
    property LetterInd: Integer read FLetterInd write SetLetterInd;
    property Sentence: TESentence read FSentence write SetSentence;
    function Read: TELetter; virtual;
    function Add(State: TELine; R: TETRule; Re, W: TELetter; D: TDirection): TTConfig; overload; virtual;
    function Add(R: TETRule): TTConfig; overload;
    function State: TETState;
    constructor Create(P: TConfig; L: TEBasLine; R: TETRule; I: Integer; S: TESentence);
    destructor Destroy; override;
  end;

  {* irány (left/right/stand) to string *}
  function DirToStr(D: TDirection): WideString;
  procedure Next(var A: IntArray; var N: Integer; M: Integer);

var
  tdLeft, tdRight, tdStand: TDirection;

implementation

uses
  SysUtils, UPushDown, StrUtils, TNTGraphics, Contnrs, UGrammar, URunFrm,
  UMainForm;

procedure KillDir(D: TDirection);
begin
  if D is TESentence then
    D.Free;
end;

function AddRule2(L: TList; R: TETRule): Boolean;
var
  I: Integer;
begin
  for I := 0 to L.Count - 1 do
    if (TETRule(L[I]).FLeft = R.FLeft) and (TETRule(L[I]).FRo = R.FRo) then
    begin
      exit;
      Result := false;
    end;
  L.Add(R);
  Result := true;
end;

procedure AssignDir(var D1: TDirection; D2: TDirection);
begin
  KillDir(D1);
  if D2 is TESentence then
    D1 := TESentence(D2).Clone
  else
    D1 := D2;
end;

function cimke(O: TObject): String;
begin
  if O is TEExit then
    Result := 'exit'
  else if O is TEAccept then
    Result := 'accept'
  else if O is TETState then
    Result := TETState(O).Name
  else if O = nil then
    Result := 'nil'
  else
    Result := '?';
end;

function DirToStr(D: TDirection): WideString;
begin
  if D is TESentence then
    Result := TESentence(D).ToString(GUSpace)
  else if D = tdLeft then Result := bnyil
  else if D = tdRight then Result := nyil
  else if D = tdStand then Result := lnyil;
end;

{ TSBLine }

procedure TSBLine.Build(EP: TEProgram);
var
  L: TEBRule;
begin
  L := TEBRule.Create;
  if Lab <> nil then
    EP.AddRule(L, Lab.Name)
  else
    EP.AddRule3(L);
  Instance := L;
  if FLetter <> nil then
    L.FLetter := TELetter(FLetter.Instance);
  L.Sig.Assign(Sig);
  L.Fi.Assign(Fi);
  L.Dir := FDirection;
  L.FSLine := Self;
end;

constructor TSBLine.Create(T: TSLetter; D: TDirection);
begin
  inherited Create;
  FLetter := T;
  FDirection := D;
end;

{ TSALine }

procedure TSALine.Build(EP: TEProgram);
var
  L: TEARule;
begin
  L := TEARule.Create;
  if Lab <> nil then
    EP.AddRule(L, Lab.Name)
  else
    EP.AddRule3(L);
  Instance := L;
  if FLetter <> nil then
    L.FLetter := TELetter(FLetter.Instance);
  L.Sig.Assign(Sig);
  L.Fi.Assign(Fi);
  L.FSLine := Self;
end;

constructor TSALine.Create(T: TSLetter);
begin
  inherited Create;
  FLetter := T;
end;

{ TSTuring }

procedure TETuring.AddState(T: TETState);
begin
  FStates.Add(T);
  T.FProgi := Self;
  T.SetTermCount(FLetCount);
end;

procedure TETuring.Build(Call: TECall);
var
  A, B, C: TList;
//  Start: TETLine;

  procedure ProcClear;
    procedure RecClear(L: TETLine);
    var
      I: Integer;
    begin
      if L.FColor = ecWhite then
      begin
        L.FColor := ecGray;
        for I := 0 to L.Sig.Count - 1 do
          RecClear(TETLine(L.Sig[I]));
        for I := 0 to L.Fi.Count - 1 do
          RecClear(TETLine(L.Fi[I]));
        L.FColor := ecBlack;
      end;
    end;

  var
    I: Integer;
  begin
    for I := 0 to FStarts.Count - 1 do
      RecClear(TETLine(FStarts[I]));

    for I := A.Count - 1 downto 0 do
      with TEARule(A[I]) do
      begin
        if FMark and (FColor = ecWhite) then
          A.Remove(A[I])
        else
          FColor := ecWhite;
      end;
  end;

  procedure Bejar(L: TELine);
  var
    I: Integer;
  begin
    if L is TECall then
      for I := 0 to TECall(L).Lines.Count - 1 do
        Bejar(TELine(TECall(L).Lines[I]))
    else
    begin
      if L is TEARule then
        A.Add(L)
      else if L is TEBRule then
        B.Add(L);
      TETLine(L).MakeRefs;
    end;
  end;

  procedure Proc001;
  var
    I: Integer;
    X: TEARule;
  begin
    if FStarts.Count > 1 then
    begin
      X := TEARule.Create;
      A.Add(X);
      X.FLetter := FEps;
      X.Sig.Assign(FStarts);
      X.MakeRefs;
      FStarts.Clear;
      FStarts.Add(X);
    end;
  end;

  procedure Proc0;
  var
    I: Integer;
    X, Y: TEARule;
    J: Integer;
    Z: Boolean;
    NRo, NFi: TList;
  begin
    NRo := TList.Create;
    NFi := TList.Create;
    repeat
      Z := false;
      for I := 0 to A.Count - 1 do
      begin
        X := TEARule(A[I]);
        if not X.FMark then
        begin
          NRo.Assign(X.Sig);
          NFi.Assign(X.Fi);
          for J := 0 to X.Sig.Count - 1 do
            if TObject(X.Sig[J]) is TEARule then
            begin
              Y := TEARule(X.Sig[J]);
              if not Y.FMark then
              begin
                Z := true;
                if X.FLetter = Y.FLetter then
                {* felesleges olvasás *}
                begin
                  NRo.Assign(NRo, laOr, Y.Sig);
                  NFi.Assign(NFi, laOr, Y.Fi);
                  Y.FMark := true;
                end
                else
                {* lehetetlen olvasás *}
                begin
                  NRo.Remove(Y);
                  NFi.Assign(NFi, laOr, Y.Fi);
                  Y.FMark := true;
                end;
              end;
            end;
          for J := 0 to X.Fi.Count - 1 do
            if TObject(X.Fi[J]) is TEARule then
            begin
              Y := TEARule(X.Fi[J]);
              if not Y.FMark and (X.FLetter = Y.FLetter) then
              {* lehetetlen olvasás *}
              begin
                Z := true;
                NFi.Remove(Y);
                NFi.Assign(NFi, laOr, Y.Fi);
                Y.FMark := true;
              end;
            end;

          X.Sig.Assign(NRo);
          X.Fi.Assign(NFi);
        end;
      end;
    until not Z;
    NRo.Free;
    NFi.Free;
    ProcClear;
  end;

  {* eléri, hogy C szabályai B-re mutatnak (A-ra és C-re nem) *}
  procedure Proc01;
  var
    B: Boolean;

    procedure f(S: TETState);
    var
      R, T: TETRule;
      L: TList;
      I, K: Integer;
      J: IRuleIterator;
    begin
      L := TList.Create;
      for I := 0 to FLetCount - 1 do
      begin
        L.Clear;
        for K := 0 to S.FRules[I].Count - 1 do
        begin
          R := S.FRules[I][K];
          if (R.Sig is TETState) and (R.Left <> FEps) and (R.Sig <> S) then
          begin
            B := true; // tortenik valtozas
            J := (R.Sig as TETState).GetIterator;
            J.Letter := FLetters[I];
            while J.Next do
            begin
              T := TETRule.Create;
              T.Assign(R);
              T.FRo := J.Current.Sig;
              if not AddRule2(L, T) then
                T.FRee;
            end;
            R.Free;
          end
          else
            if not AddRule2(L, R) then
              R.Free;
        end;

        S.FRules[I].Assign(L);
      end;
    end;

  var
    I, N: Integer;
    IT: IRuleIterator;
  begin
    {* eléri: C szabályai C-re vagy B-re mutatnak (A-ra nem) *}
    for I := 0 to C.Count - 1 do
    begin
      IT := TETState(C[I]).GetIterator;
      while IT.Next do
        if IT.Current.Sig is TEARule then
          IT.Current.Sig := (IT.Current.Sig as TEARule).FTState;
    end;

    {* eléri: C szabályai B-re mutatnak (A-ra és C-re nem) *}
    B := true;
    N := 0;
    while B and (N < 500) do
    begin
      inc(N);
      B := false;
      for I := 0 to C.Count - 1 do
        f(TETState(C[I]));
    end;
    if N = 500 then
      raise Exception.Create('Végtelen ciklust tartalmaz a kód!');
  end;

  {* A->C összevonás *}
  procedure Proc1;
  var
    I: Integer;

    {* A-lánc keresése X-bõl *}
    procedure F(X: TEARule);
    var
      I: Integer;
      Y: TEARule;
      S, V: TETState;
    begin
      if (X.Fi.Count = 1) and (TObject(X.Fi[0]) is TEARule)
        and (TEARule(X.Fi[0]).FRefs.Count = 1) then
      begin
        Y := TEARule(X.Fi[0]);
        if X.FTState = nil then
        begin
          if Y.FTState = nil then
          begin
            S := TETState.Create;
            AddState(S);
            S.AddSub(X);
            S.AddSub(Y);
          end
          else
            Y.FTState.AddSub(X);
        end
        else
        begin
          if Y.FTState = nil then
            X.FTState.AddSub(Y)
          else
          begin
            V := Y.FTState;
            for I := 0 to Y.FTState.FSubs.Count - 1 do
              X.FTState.AddSub(TEARule(V.FSubs[I]));
            FStates.Remove(V);
            V.Free;
          end
        end
      end;
    end;

    var
      X: TEARule;
      S: TETState;
  begin
    {* lineáris összevonások *}
    for I := 0 to A.Count - 1 do
      f(TEARule(A[I]));

    {* magányosan maradt A-k átírása C-re *}
    for I := 0 to A.Count - 1 do
    begin
      X := TEARule(A[I]);
      if X.FTState = nil then
      begin
        S := TETState.Create;
        AddState(S);
        S.AddSub(X);
      end;
    end;

    {* A-k átírása C.Rule-k ba *}
    for I := 0 to C.Count - 1 do
      TETState(C[I]).MakeRules;
  end;

  {* A->B összevonások *}
  procedure Proc2;
  var
    I: Integer;
  begin
    for I := 0 to C.Count - 1 do
      TETState(C[I]).Expand;
  end;

  {* B->B hivatkozások kezelése *}
  procedure Proc3;
    procedure RecClear(L, P: TETLine);
    var
      I: Integer;
    begin
      if L.FColor = ecWhite then
      begin
        L.FColor := ecGray;
        {* lejelöli B2-t ahol van B1->B2 hivatkozás *}
        if (L is TEBRule) and (P is TEBRule) then
          L.FMark := false;

        for I := 0 to L.Sig.Count - 1 do
          RecClear(TETLine(L.Sig[I]), L);
        for I := 0 to L.Fi.Count - 1 do
          RecClear(TETLine(L.Fi[I]), L);
        L.FColor := ecBlack;
      end;
    end;

  var
    I, J, K: Integer;
    X: TEBRule;
    Y: TETState;
  begin
    for I := 0 to B.Count - 1 do
    with TEARule(B[I]) do
    begin
      FColor := ecWhite;
      FMark := true;
    end;

    for I := 0 to FStarts.Count - 1 do
    begin
      TETLine(FStarts[I]).FMark := false;
      RecClear(TETLine(FStarts[I]), nil);
    end;


    {* egyedül maradt lépésekhez új C állapotok *}
    if Self is TEPushDown then
    begin
      for I := 0 to B.Count - 1 do
      begin
        X := TEBRule(B[I]);
        if not X.FMark then
        begin
          Y := TETState.Create;
          AddState(Y);
          X.FTState := Y;
          for K := 0 to X.Sig.Count - 1 do
            Y.AddRule(FEps, X.FLetter, X.Dir, X.Sig[K], X.FSLine);
        end;
      end;
    end

    else if Self is TETuring then
    begin
      for I := 0 to B.Count - 1 do
      begin
        X := TEBRule(B[I]);
        if not X.FMark then
        begin
          Y := TETState.Create;
          AddState(Y);
          X.FTState := Y;
          for J := 0 to FLetCount - 1 do
            for K := 0 to X.Sig.Count - 1 do
              if CanStep(FLetters[J]) then {* csak terminálisokon lépkedünk *}
                if X.FLetter = nil then {* FLetter = amit ír a B *}
                  Y.AddRule(FLetters[J], FLetters[J], X.Dir, X.Sig[K], X.FSLine)
                else
                  Y.AddRule(FLetters[J], X.FLetter, X.Dir, X.Sig[K], X.FSLine);
        end;
      end;
    end;
  end;

  procedure Proc4;
  var
    I, J, K: Integer;
    L: IRuleITerator;
    R: TETRule;
    O: TObject;
    B: Boolean;

    procedure F(X: TETState);
    var
      J, K: Integer;
    begin
      {* Név beállítása *}
      // X.Name := IntToStr( C.IndexOf(X) );
      for J := 0 to FLetCount - 1 do
      begin
        if (X.FRules[J].Count = 1) and (TETRule(X.FRules[J][0]).FRo is TEExit) then
        begin
          {* exit szabályok kitörlése *}
          TETRule(X.FRules[J][0]).Free;
          X.FRules[J].Clear;
        end
        else
        for K := 0 to X.FRules[J].Count - 1 do
        begin
          {* minden átmenet C-re mutasson *}
          R := TETRule(X.FRules[J][K]);
          if R.FRo is TETLine then
            R.FRo := (R.FRo as TETLine).FTState;
        end;
      end;
    end;

    {* Start állapot beállítása *}
    procedure G;
    var
      I: Integer;
    begin
      if FStarts.Count = 1 then
        if TObject(FStarts[0]) is TETLine then
          FStartState := TETLine(FStarts[0]).FTState
        else
          FStartState := nil
      else
      begin
        FStartState := TETState.Create;
        AddState(FStartState);
        for I := 0 to FStarts.Count - 1 do
          FStartState.AddComplete(nil, nil, nil, TObject(FStarts[I]) as TEBasLine);
        FFirst.Sig.Clear;
        FFirst.Sig.Add(FStartState);
      end;

      {* Start állapot legyen az elsõ *}
      C.Move(C.IndexOf(FStartState), 0);
    end;

    procedure H;
    var
      I, J, K: Integer;
    begin
      B := false;
      {* Megjelöljük azokat az állapotokat, amelyeknek 0 db szabálya van *}
      for I := 0 to C.Count - 1 do
      begin
        K := 0;
        L := TETState(C[I]).GetIterator;
        while (L.Next) do
          Inc(K);
        TETState(C[I]).FMark := K = 0;
        B := B or (K = 0);
      end;

      {* Megjelölt állapotokra vonatkozó mutatók kitörlése *}
      for I := 0 to C.Count - 1 do
      begin
        L := TETState(C[I]).GetIterator;
        while (L.Next) do
          if (L.GetCurrent.FRo is TETState) and TETState(L.GetCurrent.FRo).FMark then
            L.RemoveCurrent;
      end;

      for I := C.Count - 1 downto 0 do
        if TETState(C[I]).FMark then
        begin
          TETState(C[I]).Free;
          C.Delete(I);
        end;
    end;

    {* Nevek beállítása *}
    procedure Nevek;
    var
      I, K, M: Integer;
      S: TETState;
    begin
      K := 0;
      for I := 0 to C.Count - 1 do
      begin
        S := TETState(C[I]);
        if S.Name = '' then
        begin
          while FNames.Find('q' + IntToStr(K), M) do
            inc(K);
          AddName(S, 'q' + IntToStr(K));
          inc(K);
        end;
      end;
    end;

  begin
    {* hivatkozások átírása C-re mutatónak, exitek kitörlése *}
    for I := 0 to C.Count - 1 do
      F(TETState(C[I]));

    for I := 0 to C.Count - 1 do
      TETState(C[I]).FMark := false;

    {* Fölöslegesek törlése *}
    B := true;
    while(B) do H;
    {* Start állapot beáll *}
    G;
    Nevek;
  end;

begin
  inherited Build(Call);

  SetLetters;

  A := TList.Create;
  B := TList.Create;
  C := FStates;

  // Start állapot beállítása
  Proc001;

  {* A, B listák feltöltése, Refs beállítása *}
  Bejar(FMain);

  {* 1. lépés, A-k összevonása C-kre *}
  Proc1;

//  {* 0. lépés, fölösleges A-k kitörlése *}
//  Proc0;

  {* 01. lépés, C szabályai B-re mutatnak (A-ra és C-re nem) *}
  Proc01;

  {* 2. lépés, C-->B szabályok átírása *}
  Proc2;

  {* 3. lépés, B-k átírása C-kre *}
  Proc3;

  {* összes rule C-re mutasson *}
  Proc4;
end;

{ TSTLine }

//constructor TSTLine.Create;
//begin
//  inherited;
//  FRefs := TList.Create;
//end;
//
//destructor TSTLine.Destroy;
//begin
//  FRefs.Destroy;
//  inherited;
//end;

class function TSTLine.MakePrint: TSTLine;
begin
  Result := TSBLine.Create(GSPrint, tdStand);
//  Result.FShowCount := 1;
end;

{ TETLine }

procedure TETLine.AddRef(L: TETLine);
begin
  if FRefs.IndexOf(L) = -1 then
    FRefs.Add(L);
end;

procedure TETLine.ClearRefs;
var
  I: Integer;
begin
  for I := 0 to Sig.Count - 1 do
    TETLine(Sig[I]).RemRef(Self);
  for I := 0 to Fi.Count - 1 do
    TETLine(Fi[I]).RemRef(Self);
end;

constructor TETLine.Create;
begin
  inherited;
  FColor := ecWhite;
  FRefs := TList.Create;
end;

destructor TETLine.Destroy;
begin
  FRefs.Free;
  inherited;
end;

function TETLine.IsLetter: Boolean;
begin
  Result := true;
end;

procedure TETLine.MakeRefs;
var
  I: Integer;
begin
  for I := 0 to Sig.Count - 1 do
    if TObject(Sig[I]) is TETLine then
      TETLine(Sig[I]).AddRef(Self);
  for I := 0 to Fi.Count - 1 do
    if TObject(Fi[I]) is TETLine then
      TETLine(Fi[I]).AddRef(Self);
end;

procedure TETLine.RemRef(L: TETLine);
begin
  FRefs.Remove(L);
end;

function TETuring.CanRead(L: TELetter): Boolean;
begin
  Result := (L <> FEps);
end;

function TETuring.CanStep(L: TELetter): Boolean;
begin
  Result := (L is TETerm) and (L <> FEps);
end;

constructor TETuring.Create;
begin
  inherited;
//  FStarts := TList.Create;
  FStates := TList.Create;
  FAccept := TEAccept.Create;
  AddName(FAccept, 'accept');
end;

destructor TETuring.Destroy;
begin
  FStates.Free;
//  FStarts.Free;
  inherited;
end;

function TETuring.GetConfigClass: TConfigClass;
begin
  Result := TTConfig;
end;

procedure TETuring.GetDefinition(L: TTntStrings);
  procedure f(A: TETState);
  var
    I, J: Integer;
    C: TECall;
    P: TETuring;
    R: TETRule;
    B: Boolean;
  begin
    P := A.FProgi;
    B := false;
    for I := 0 to P.FLetCount - 1 do
      for J := 0 to A.FRules[I].Count - 1 do
      begin
        R := TETRule(A.FRules[I][J]);
        L.Add(gdelta + '( ' + A.Name + ', '
        + R.FLeft.Name + ' ) = ( '
        + TETState(R.FRo).Name + ', '
        + R.FRight.Name + ', '
        + DirToStr(R.Dir) + ' )');
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
  L.Add('Initial tape content:' + #13#10#9 + FInput.ToString + #13#10);

  M.Assign(FStates);
  M.Add(FAccept); M.Add(FExit);
  L.Add('States:' + #13#10#9 + ListToStr2(M) + #13#10);

  L.Add('Start state:' + #13#10#9 + FStartState.Name + #13#10);

  L.Add('Accepting state:' + #13#10#9 + FAccept.Name + #13#10);

  L.Add('Rejecting state:' + #13#10#9 + FExit.Name + #13#10);

  N.Clear;
  GetInputAlphabet(N);
  L.Add('Input symbols:' + #13#10#9 + ListToStr2(N) + #13#10);

  N.Clear;
  GetTapeAlphabet(N);
  L.Add('Tape alphabet:' + #13#10#9 + ListToStr2(N) + #13#10);

  L.Add('Transition function:');
  for I := 0 to FStates.Count - 1 do
    f(TETState(FStates[I]));
  N.Free;
  M.Free;
end;

procedure TETuring.GetInputAlphabet(L: TStringList);
var
  I: Integer;
begin
  for I := 0 to FLetCount - 1 do
    if ( (FLetters[I] is TEBlank) or (FLetters[I].Name = eps) ) then
      // Skip
    else
      if (FLetters[I] is TETerm) then
        L.AddObject(FLetters[I].Name, FLetters[I]);
end;

procedure TETuring.GetTapeAlphabet(L: TStringList);
var
  I: Integer;
begin
  for I := 0 to FLetCount - 1 do
    if (FLetters[I].Name = eps) then
      // Skip
    else
      L.AddObject(FLetters[I].Name, FLetters[I]);
end;

function TETuring.GetTurConfigClass: TTurConfigClass;
begin
  Result := TTConfig;
end;

function TETuring.IsEmpty: Boolean;
begin
  Result := FStates.Count = 0;
end;

procedure TETuring.SetLetters;
var
  L: TStringList;
  I: Integer;
begin
  L := TStringList.Create;
  GetNTerms(L);
  GetTerms(L);
  FLetCount := L.Count;
  SetLength(FLetters, FLetCount);
  for I := 0 to FLetCount - 1 do
    FLetters[I] := TELetter(L.Objects[I]);
  L.Free;
end;

function TETuring.LetterIndex(T: TELetter): Integer;
var
  I: Integer;
begin
  for I := 0 to FLetCount - 1 do
    if FLetters[I] = T then
    begin
      Result := I;
      exit;
    end;
  Result := -1;
end;

procedure TETuring.RunLang;
begin
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

    GThread := TTurThread.Create; //(true);
    if FRunFrm is TRunFrm then
    begin
      GThread.ListView := TRunFrm(FRunFrm).lvLang;
      GThread.OnTerminate := TRunFrm(FRunFrm).PageControl1.OnChange;
    end;
    GThread.Priority := tpLowest;
    TTurThread(GThread).FTuring := Self;
    GThread.Limit := GDbLimit;
    GThread.Resume;
  end;
end;

procedure Next(var A: IntArray; var N: Integer; M: Integer);
var
  I: Integer;
  B: Boolean;
begin
  B := true;
  for I := 0 to N - 1 do
  begin
    if B then
      Inc(A[I]);
    B := A[I] = M;
    if B then
      A[I] := 0;
  end;
  if B then
  begin
    Inc(N);
    SetLength(A, N);
    A[N - 1] := 0;
  end;
end;

procedure TETuring.RunLang3;
var
  C, D: TTConfig;
  L: TList;
  T: TTurThread;
  Old: TESentence;
  B: Boolean;
  A: IntArray;
  N, M, I: Integer;

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

  B := false;
  N := 0;
  setlength(A, 0);
  while not B and (N <= GDbInput) do
  begin
    Input.AssignFromArray(A, N, L);
    Next(A, N, M);
    C := GetTurConfigClass.Create(nil, FStartState, nil, 0, TESentence.Create);
    D := GetTurConfigClass.Create(nil, FFirst, nil, 0, nil);
    D.Add(C);
    C.FSentence.Assign(Input);
    B := RunLang2(C);
    D.Free;
  end;
  Input.Assign(Old);
end;

class function TETuring.RunLang2(C: TTConfig): Boolean;
var
  Q: TQueue;
  I, K: Integer;
  T: TTurThread;
label
  vege;
begin
  Q := TQueue.Create;
  Q.Push(C);
  K := 0;
  T := TTurThread(GThread);

  if T.Terminated then
    goto vege;

  while (Q.Count > 0) and not T.Terminated do
  begin
    C := TTConfig(Q.Pop);
    if C.IsTerminal then
    begin
      if C.FLine is TEAccept then
      begin
        T.Config := C;
        T.Synchronize(T.GetResults);
        goto vege;
      end;
    end
    else
    begin
      C.MakeChildren;
      C.FRuned := true;
      for I := 0 to C.FChildren.Count - 1 do
        Q.Push(C.FChildren[I]);
    end;

    inc(K);

    if (K mod 1000 = 0) and T.Expired then
      T.Terminate;

    if K mod GKonfigpInput = 0 then
      goto vege;
  end;

vege:
  Q.Free;
  Result := T.Terminated;
end;

procedure TETuring.RunList(D: Integer);
var
  C, E: TTConfig;
begin
  try
    if FLines.Count > 0 then
    begin
      Select(vtList);
      FListView.Items.Clear;
      C := TTConfig.Create(nil, FStartState, nil, 0, TESentence.Create);
      E := TTConfig.Create(nil, FFirst, nil, 0, nil);
      E.Add(C);
      E.Node := FListView;
      C.FSentence.Assign(Input);
      FStartList := C;
      C.MakeListNode(FListView);
      C.RunList(D);
    end;
  except
    else
      raise Exception.Create('Runtime Error!');
  end;
end;

procedure TETuring.RunTree(D: Integer);
var
  C: TTConfig;
begin
  try
    if FLines.Count > 0 then
    begin
      Select(vtTree);
      FTreeView.Items.Clear;
      C := TTConfig.Create(nil, FStartState, nil, 0, TESentence.Create);
      TTConfig.Create(nil, FFirst, nil, 0, nil).Add(C);
      C.FSentence.Assign(Input);
      FStartTree := C;
      C.MakeTreeNode(FTreeView);
      C.RunTree(D);
    end;
  except
    else
      raise Exception.Create('Runtime Error!');
  end;
end;

procedure TETuring.ToListView(LV: TTntListView);

  procedure f(A: TETState);
  var
    I, J: Integer;
    C: TECall;
    P: TETuring;
    R: TETRule;
    B: Boolean;
  begin
    P := A.FProgi;
    B := false;
    for I := 0 to P.FLetCount - 1 do
      for J := 0 to A.FRules[I].Count - 1 do
      begin
        with LV.Items.Add do
        begin
          if not B then
          begin
            Caption := A.Name;
            B := true;
          end;
          R := TETRule(A.FRules[I][J]);
          Data := R;
          SubItems.Add(R.FLeft.Name);         // Olv
          SubItems.Add(R.FRight.Name);        // Ír
          SubItems.Add(DirToStr(R.Dir));      // Lép
          SubItems.Add(TETState(R.FRo).Name);  // Új Áll
        end;
      end;
    Lv.Items.Add;
  end;

var
  I: Integer;
begin
  for I := 0 to FStates.Count - 1 do
    f(TETState(FStates[I]));
  with LV.Items.Add do
  begin
    Caption := 'accept';
    Data := FAccept;
  end;
  LV.Items.Add;
  with LV.Items.Add do
  begin
    Caption := 'exit';
    Data := FExit;
  end;
  LV.Items.Add;
end;

{ TTState }

procedure TETState.AddSub(R: TEARule);
begin
  FSubs.Add(R);
  R.FTState := Self;
end;

constructor TETState.Create;
begin
  inherited;
  FSubs := TList.Create;
end;

destructor TETState.Destroy;
var
  I: Integer;
begin
  FSubs.Free;
  for I := 0 to length(FRules) - 1 do
    FRules[I].Free;
  inherited;
end;

{* C->B összevonások *}
procedure TETState.Expand;
var
  I, J, K: Integer;
  L, M: TList;
  R, E: TETRule;
  B: TEBRule;
begin
  for I := 0 to FProgi.FLetCount - 1 do
  begin
    L := TList.Create;
    for J := 0 to FRules[I].Count - 1 do
    begin
      R := TETRule(FRules[I][J]);
      if (R.FRo is TEBRule) then
      begin
        B := TEBRule(R.FRo);
        for K := 0 to B.Sig.Count - 1 do
        begin
          if FProgi is TEPushDown then
          begin
            Assert(B.FLetter <> nil);
            E := TETRule.Create;
            E.SLine := B.FSLine;
            E.FLeft := R.FLeft;
            E.FRight := B.FLetter;
            E.Dir := B.Dir;
            E.FRo := B.Sig[K];
            L.Add(E);
          end
          else if FProgi is TETuring then
          begin
            Assert((R.Dir = nil) or (R.Dir = tdStand));
            E := TETRule.Create;
            E.FLeft := R.FLeft;
            E.SLine := B.FSLine;
            if B.FLetter = nil then
              E.FRight := E.FLeft
            else
              E.FRight := B.FLetter;
            E.Dir := B.Dir;
            E.FRo := B.Sig[K];
            L.Add(E);
          end;
        end;
        R.Free;
      end
      else
      begin
        if (FProgi.ClassType = TETuring) and (R.FRight = nil) then
          R.FRight := R.FLeft;
        L.Add(R);
      end;
    end;
    FRules[I].Assign(L);
    L.Free;
  end;
end;

function TETState.GetIterator: IRuleIterator;
begin
  Result := TRuleIterator.Create(Self);
end;

function TETState.GetRule(L: TELetter; M: TFindMode): TETRule;
var
  N: TList;
begin
  N := GetRules(L);
  Result := TETRule(ChoiceList(N, M));
  N.Free;
end;

function TETState.GetRule(L, N: TELetter; M: TFindMode): TETRule;
var
  K: TList;
begin
  K := GetRules(L, N);
  Result := TETRule(ChoiceList(K, M));
  K.Free;
end;

function TETState.GetRules(I: Integer): TList;
begin
  Result := FRules[I];
end;

function TETState.GetRules(L, N: TELetter): TList;
var
  I: Integer;
  K: TList;
begin
  Result := TList.Create;
  K := GetRules(L);
  for I := 0 to K.Count - 1 do
    if (TETRule(K[I]).FRight = nil) or (TETRule(K[I]).FRight = GEPrint) or (TETRule(K[I]).FRight = N) then
      Result.Add(K[I]);
  K.Free;
end;

function TETState.GetRules(L: TELetter): TList;
begin
  Result := TList.Create;
  Result.Assign(FRules[FProgi.LetterIndex(L)], laOr, FRules[FProgi.LetterIndex(FProgi.FEps)]);
end;

procedure TETState.MakeRules;
var
  I, J: Integer;
  X, Y: TEARule;
  D: TDirection;
begin
  if FPRogi.ClassType = TETuring then
    D := tdStand
  else
    D := nil;

  {* A-láncok összevonása *}
  for I := 0 to FSubs.Count - 1 do
  begin
    X := TEARule(FSubs[I]);
    if (Name = '') and (X.Name <> '') then
      Name := X.Name;

    for J := 0 to X.Sig.Count - 1 do
      AddRule(X.FLetter, nil, D, X.Sig[J], X.FSLine);
  end;

  {* A-lánc else ága *}
  Y := TEARule(FSubs.Last);
  for I := 0 to FProgi.FLetCount - 1 do
    if (FRules[I].Count = 0) and FProgi.CanRead(FProgi.FLetters[I]) then
      for J := 0 to Y.Fi.Count - 1 do
        AddRule(FProgi.FLetters[I], nil, D, Y.Fi[J], nil);
end;

function TETState.RandomRule(L: TELetter): TETRule;
begin

end;

procedure TETState.RemoveRule(R: TETRule);
begin
  FRules[FProgi.LetterIndex(R.Left)].Remove(R);
end;

procedure TETState.SetTermCount(N: Integer);
var
  I: Integer;
begin
  SetLength(FRules, FProgi.FLetCount);
  for I := 0 to FProgi.FLetCount - 1 do
    FRules[I] := TList.Create;
end;

function TETState.AddComplete(Left, Right: TELetter; Dir: TDirection;
  Sig: TObject): TETRule;
var
  I: Integer;
begin
  if Left = nil then
  begin
    if FProgi.ClassType = TETuring then
    begin
      for I := 0 to FProgi.FLetCount - 1 do
        if FProgi.CanStep(FProgi.FLetters[I]) then {* csak terminálisokon lépkedünk *}
          AddComplete(FProgi.FLetters[I], Right, Dir, Sig)
    end
    else if FProgi.ClassType = TEPushDown then
      AddComplete(FProgi.FEps, Right, Dir, Sig);
  end
  else if Right = nil then
  begin
    if FProgi.ClassType = TETuring then
      AddComplete(Left, Left, Dir, Sig);
  end
  else if Dir = nil then
  begin
    if FProgi.ClassType = TETuring then
      AddComplete(Left, Right, tdStand, Sig)
  end
  else
    Result := AddRule(Left, Right, Dir, Sig, nil);
end;

function TETState.AddRule(Left, Right: TELetter; Dir: TDirection;
  Sig: TObject; FL: TSLine): TETRule;
var
  I: Integer;
begin
  Result := TETRule.Create;
  Result.FLeft := Left;
  Result.FRight := Right;
  Result.Dir := Dir;
  Result.FRo := Sig;
  Result.SLine := FL;
  FRules[FProgi.LetterIndex(Left)].Add(Result);
end;

{ TEAccept }

function TEAccept.IsLetter: Boolean;
begin
  Result := true;
end;

procedure TEAccept.ResolveA;
begin
  // Skip
end;

{ TTConfig }

{* State lehet pl. accept vagy TTState is *}
function TTConfig.Add(State: TELine; R: TETRule; Re, W: TELetter; D: TDirection): TTConfig;
var
  S: TESentence;
  I: Integer;
begin
  if FSentence.Count > GMaxLength then
  begin
    Result := nil;
    exit;
  end;

  S := TESentence.Create;
  S.Items.Assign(FSentence.Items);
  if W <> GEPrint then
    S.Write(FLetterInd, W);

  if D = tdLeft then I := FLetterInd - 1
  else if D = tdRight then I := FLetterInd + 1
  else if D = tdStand then I := FLetterInd;

  Result := TTConfig(ClassType.Create);
  Result.Create(Self, State, R, I, S);
  Add(Result);
end;

constructor TTConfig.Create(P: TConfig; L: TEBasLine; R: TETRule; I: Integer;
  S: TESentence);
begin
  inherited Create(P, L);
  FLetterInd := I;
  FSentence := S;
  FRule := R;
end;

destructor TTConfig.Destroy;
begin
  FSentence.Free;
  inherited;
end;

procedure TTConfig.DrawTreeNode(C: TCanvas; Left, Top: Integer; Color: TColor);
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
  end;
end;

function TTConfig.HasRule: Boolean;
begin
  Result := (Rule <> nil) and (Rule.Right <> nil);
end;

function TTConfig.IsTerminal: Boolean;
begin
  Result := not (FLine is TETState);
end;

function TTConfig.GetLangString: WideString;
var
  S: TESentence;
begin
  S := GetProgram.Input;
  if (S.Count = 1) and (S.Letters[0] is TEBlank) then
    Result := eps
  else
    Result := S.ToTapeString;
end;

function TTConfig.GetMatrix: TCMatrix;
begin
  Result := TCMatrix.Create;
  Result.Rows.Assign(Items);
end;

function TTConfig.GetTreeString: WideString;
begin
  Result := Sentence.ToString(GUSpace);
end;

procedure TTConfig.MakeChildren;

  procedure AddExit;
  var
    C: TTConfig;
  begin
    C := TTConfig(ClassType.Create);
    C.Create(Self, GetProgram.PExit, nil, FLetterInd, TESentence.Create);
    C.Sentence.Items.Assign(Sentence.Items);
    Add(C);
  end;

  procedure ChoiceRule;
  var
    L: TList;
    I: Integer;
    R: TETRule;
    M: TELetter;
  begin
    if State = nil then
      exit;

    M := Read;
    L := State.GetRules(M);

    if L.Count = 0 then
      // Skip
    else if GRuleChoice = fmAll then
    begin
      R := State.GetRule(M, GRuleChoice2);
      Add(R);

      for I := 0 to L.Count - 1 do
        if L[I] <> R then
          Add(TETRule(L[I]));
    end
    else
      Add(State.GetRule(M, GRuleChoice));

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

function TTConfig.MakeListNodeCond(TV: TObject): TObject;
var
  C: TTConfig;
  function F: TObject;
  begin
    if IsLast or Rule.Visible then
      Result := MakeListNode(TV)
  end;
begin
  if Items.Count = 0 then
    C := nil
  else
    C := TTConfig(Items[0]);
  {* print eset: *}
  if ((C <> nil) and (C.Rule <> nil) and (C.Rule.IsPrint)) then
    Result := MakeListNode(TV)
  else
    if not GDeterm then
    begin
      {* ha determ elrejtés van, akkor: *}
      if IsLast or (Items.Count > 1) then
        Result := F
    end
    else
      Result := F;
end;

function TTConfig.Read: TELetter;
begin
  if (FLetterInd >= 0) and (FLetterInd <= FSentence.Count - 1) then
    Result := FSentence[FLetterInd]
  else
  begin
    Result := Blank;
    Sentence.Write(FLetterInd, Blank);
    if FLetterInd < 0 then
      FLetterInd := 0;
  end;
end;

procedure TTConfig.SetColor(S: TESentence; var C: TColor; HideColor: Boolean);
begin
  if HideColor then
  begin
    S.First := -1;
    exit;
  end
  else
    S.First := LetterInd;
  S.Last := S.First;

  if Line is TEAccept then
  begin
    S.First := 0; S.Last := S.Count - 1;
    C := colAccept;
  end
  else if Line is TEExit then
  begin
    S.First := 0; S.Last := S.Count - 1;
    C := colexit;
  end
  else
    C := colselect;
end;

procedure TTConfig.SetLetterInd(const Value: Integer);
begin
  FLetterInd := Value;
end;

procedure TTConfig.SetRule(const Value: TETRule);
begin
  FRule := Value;
end;

procedure TTConfig.SetSentence(const Value: TESentence);
begin
  FSentence := Value;
end;

function TTConfig.State: TETState;
begin
  if FLine is TETState then
    Result := TETState(FLine)
  else
    Result := nil;
end;

function TTConfig.Add(R: TETRule): TTConfig;
begin
  Result := Add(R.FRo as TELine, R, R.FLeft, R.FRight, R.Dir);
end;

{ TTRule }

procedure TETRule.Assign(R: TETRule);
begin
  FLeft := R.FLeft;
  FRight := R.FRight;
  Dir := R.Dir;
  FRo := R.FRo;
end;

function TETRule.IsPrint: Boolean;
begin
  Result := FRight = GEPrint;
end;

procedure TETRule.SetDir(const Value: TDirection);
begin
  KillDir(FDir);
  AssignDir(FDir, Value);
end;

procedure TETRule.SetLeft(const Value: TELetter);
begin
  FLeft := Value;
end;

procedure TETRule.SetRight(const Value: TELetter);
begin
  FRight := Value;
end;

procedure TETRule.SetRo(const Value: TObject);
begin
  FRo := Value;
end;

function TETRule.ToString(UseSpace: Boolean): WideString;
const
  d = 5;

  function f(S: WideString; i: integer): WideString;
  begin
    if length(S) < i then
      Result := DupeString(' ', i - length(S)) + S
    else
      Result := ' ' + S;
  end;
begin
  if FRight = nil then
    Result := f('', d) + f('', d) + f(TEItem(FRo).Name, d)
  else
    Result := f(FLeft.Name, d) + f(FRight.Name, d) + f(DirToStr(Dir), d)
      + f(TEItem(FRo).Name, d);
end;

function TETRule.Visible: Boolean;
begin
  Result := (FSLine <> nil) and (FSLine.ShowCount > 0);
end;

{ TEBRule }

procedure TEBRule.SetDir(const Value: TDirection);
begin
  KillDir(FDir);
  AssignDir(FDir, Value);
end;

{ TRuleITerator }

constructor TRuleITerator.Create(S: TETState);
begin
  FLetterIndex := -1;
  FLetter := nil;
  FState := S;
  FLetCount := S.FProgi.FLetCount;
  Reset;
end;

function TRuleITerator.Current: TETRule;
begin
  Result := FCurrent;
end;

destructor TRuleITerator.Destroy;
begin
  inherited;
end;

function TRuleITerator.GetCurrent: TETRule;
begin
  if (FI >= 0) and (FI < FLetCount)
    and (FJ >= 0) and (FJ < FState.FRules[FI].Count) then
      Result := FState.FRules[FI][FJ]
  else
    Result := nil;
end;

function TRuleITerator.GetLetter: TELetter;
begin
  Result := FLetter;
end;

function TRuleITerator.Next: Boolean;
label
  vege;
begin
  FCurrent := nil;
  while (FI < FLetCount) do
  begin
    inc(FJ);
    FCurrent := GetCurrent;
    if (FCurrent = nil) then
    begin
      if FLetter <> nil then
        goto vege;
      inc(FI);
      FJ := -1;
    end
    else
    begin
      Result := true;
      exit;
    end;
  end;
vege:
  FCurrent := nil;
  Result := false;
end;

function TRuleITerator.Prev: Boolean;
label
  vege;
begin
  FCurrent := nil;
  while 0 <= FI do
  begin
    dec(FJ);
    FCurrent := GetCurrent;
    if (FCurrent = nil) then
    begin
      if FLetter <> nil then
        goto vege;
      dec(FI);
      if FI >= 0 then
        FJ := FState.FRules[FI].Count;
    end
    else
    begin
      Result := true;
      exit;
    end;
  end;
vege:
  FCurrent := nil;
  Result := false;
end;

procedure TRuleITerator.RemoveCurrent;
var
  I, J: Integer;
begin
  if GetCurrent <> nil then
  begin
    I := FI; J := FJ;
    Prev;
    FState.FRules[I].Delete(J);
  end;
end;

procedure TRuleITerator.Reset;
begin
  FI := 0;
  FJ := -1;
  FCurrent := nil;
end;

procedure TRuleITerator.SetLetter(const Value: TELetter);
begin
  FLetter := Value;
  if Value = nil then
  begin
    Reset;
    FLetterIndex := -1;
  end
  else
  begin
    FJ := -1;
    FI := FState.FProgi.LetterIndex(Value);
    FLetterIndex := FI;
  end;
end;

{ TTurThread }

procedure TTurThread.RunConfig;
begin
  FTuring.RunLang3;
end;

initialization
  tdLeft := TDirection.Create;
  tdRight := TDirection.Create;
  tdStand := TDirection.Create;
end.
