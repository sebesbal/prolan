unit UBase;

interface

uses
  Classes, StrUtils, Contnrs, ComCtrls, TntComCtrls,
  Controls, SysUtils, TntGrids, Grids, TntForms, Graphics, TntClasses,
  ActiveX, ComObj, ExtCtrls, Windows, Messages;

const
  nyil = #$02192;
  bnyil = #$02190;
  lnyil = #$02193;
  eps = #$003B5;
  gsig = #$003C3;
  gfi = #$003C6;
  gdelta = #$003B4;
  tempfile1 = 'pltemp1.c';
  tempfile2 = 'pltemp2.c';
var
  colaccept: TColor;
  colselect: TColor;
  colexit: TColor;

type
  ESyntaxError = class(Exception)
  end;

  TEItem = class;
  TConfig = class;
  TSClass = class of TSCommand;
  TSLabel = class;
  TEProgram = class;
  TSFuncType = (ftVoid, ftBool);
  TSLabState = (lsUnProcessed, lsProcessing, lsProcessed);
  TSLetterClass = class of TSLetter;
  TSLine = class;
  TProgType = (ptNone, ptGrammar, ptTuring, ptPushDown, ptEPushDown);
  TESentence = class;
  TEClass = class of TEItem;
  TFindMode = (fmNone, fmFirst, fmLast, fmRandom, fmAll);
  intarray = array of integer;
  PFont = ^TFont;
  TObjectMatrix = array of array of TObject;
  TConfigClass = class of TConfig;

{ ---------------------------------------------------------------------
                          Szimbólumok
}
  {* jel *}
  TSLetter = class
  protected
    FInstanceCount: Integer;
    FName: string;
    FIsLocal: Boolean;
    FInstance: TEItem;
    procedure SetName(const Value: string);
    procedure SetIsLocal(const Value: Boolean);
    procedure SetInstance(const Value: TEItem);
  public
    property Instance: TEItem read FInstance write SetInstance;
    property IsLocal: Boolean read FIsLocal write SetIsLocal;
    property Name: string read FName write SetName;
    procedure Build(EP: TEProgram); virtual; abstract;
  end;

  {* terminális jel *}
  TSTerm = class(TSLetter)
    procedure Build(EP: TEProgram); override;
  end;

  {* epszilon *}
  TSEps = class(TSTerm)
    procedure Build(EP: TEProgram); override;
  end;

  {* print *}
  TSPrint = class(TSTerm)
  end;

  {* nemterminális jel *}
  TSNTerm = class(TSLetter)
    procedure Build(EP: TEProgram); override;
  end;

  {* szintaxisfa gyökere *}
  TSStart = class(TSNTerm)
    procedure Build(EP: TEProgram); override;
  end;

  {* blank szimbólum (T-géphez) *}
  TSBlank = class(TSNTerm)
    procedure Build(EP: TEProgram); override;
  end;

{ ---------------------------------------------------------------------
                          Szintaxisfa
}

  {* a szintaxisfa egy szögpontja *}
  TSCommand = class
  protected
    FShowCount: Integer;
    FName: string;
    FSig: TList;
    FFi: TList;
    FLab: TSLabel;
    FLineNo: Integer;
    FFileName: WideString;
    procedure SetName(const Value: string);
    procedure SetSig(const Value: TList); virtual;
    procedure SetFi(const Value: TList); virtual;
    procedure SetLab(const Value: TSLabel);
  public
    procedure LineInfo(Line: Integer; FileName: WideString; Show: Integer = -1);
    property ShowCount: Integer read FShowCount write FShowCount;
    property LineNo: Integer read FLineNo write FLineNo;
    property Sig: TList read FSig write SetSig;
    property Fi: TList read FFi write SetFi;
    procedure Proc1; virtual;
    procedure Proc3; virtual;
    property Lab: TSLabel read FLab write SetLab;
    property Name: string read FName write SetName;
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  {* szimbólumtábla *}
  TSTable = class
  protected
    FIsFuncTable: Boolean;
    FList: TStringList;
    FParent: TSTable;
    procedure SetParent(const Value: TSTable);
    function GetChild(index: string): TObject;
    procedure SetIsFuncTable(const Value: Boolean);
  public
    function GetFuncTable: TSTable;
    property IsFuncTable: Boolean read FIsFuncTable write SetIsFuncTable;
    procedure Build(EP: TEProgram);
    property Parent: TSTable read FParent write SetParent;
    function Find(S: string; C: TClass = nil): TObject;
    function FindNonRec(S: string; C: TClass = nil): TObject;
    function Declare(S: string; C: TClass; B: Boolean): TObject; overload;
    property Child[index: string]: TObject read GetChild; default;
    constructor Create;
    destructor Destroy; override;
  end;

  {* ugró utasítás *}
  TSJump = class(TSCommand)
  protected
    FLabState: TSLabState;
    FJumps: TList;
    procedure SetJumps(const Value: TList);
  public
    procedure Proc2; virtual;
    procedure Proc2Rec1;
    procedure Proc2Rec2; virtual;
    procedure AddJump(C: TObject);
    property Jumps: TList read FJumps write SetJumps;
    constructor Create; override;
    destructor Destroy; override;
  end;

  {* return utasítás (függvénybõl visszatérés) *}
  TSReturn = class(TSJump)
    procedure Proc2Rec2; override;
  end;

  {* a szintaxisfa egy csomópontja *}
  TSNode = class(TSJump)
  protected
    FChildren: TList;
    function GetChildren(index: integer): TSCommand;
    procedure SetChildren(index: integer; const Value: TSCommand);
  public
    procedure Proc1; override;
    procedure Proc2Rec2; override;
    procedure Proc2; override;
    procedure Proc3; override;
    function Count: Integer;
    function Add(C: TSCommand): TSCommand;
    property Children[index: integer]: TSCommand read GetChildren write SetChildren; default;
    procedure AssignChildren(L: TList);
    constructor Create; override;
    destructor Destroy; override;
  end;

  {* utasításcímke *}
  TSLabel = class(TSJump)
  protected
    FCommand: TSCommand;
    procedure SetCommand(const Value: TSCommand);
  public
    procedure Proc2Rec2; override;
    property Command: TSCommand read FCommand write SetCommand;
  end;

  {* blokkutasítás *}
  TSBlock = class(TSNode)
  protected
    FTable: TSTable;
    procedure SetTable(const Value: TSTable);
  public
    property Table: TSTable read FTable write SetTable;
    destructor Destroy; override;
  end;

  {* függvénydefiníció *}
  TSFunction = class(TSNode)
  protected
    FTables: TList;
    FLines: TList;
    FOTrue: TSReturn;
    FOFalse: TSReturn;
    FFuncType: TSFuncType;
    FFormalPara: TList;
    procedure SetSig(const Value: TList); override;
    procedure SetFi(const Value: TList); override;
    procedure SetParams(const Value: TList);
    procedure SetFuncType(const Value: TSFuncType);
  public
    function Block: TSBlock;
    function Table: TSTable;
    property OutTrue: TSReturn read FOTrue;
    property OutFalse: TSReturn read FOFalse;
    property FuncType: TSFuncType read FFuncType write SetFuncType;
    property Params: TList read FFormalPara write SetParams;
    procedure Build(EP: TEProgram; ShowCount: Integer);
    procedure Proc1; override;
    procedure AddTable(T: TSTable);
    procedure AddLine(L: TSLine);
    function CheckPara(L: TList): boolean;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TSwitch = (swDeterm, swColors, swDeadend, swAll);
  TChoiceType = (ctPos, ctRule);
  TViewType = (vtList, vtTree, vtSet);
  TProgOption = (
    poHideDeterm, poHideColors, poHideDeadend,
    poShowColors, poShowDeterm, poShowDeadend);
  TPRogOptions = set of TProgOption;

  {* szintaxisfa *}
  TSProgram = class(TSBlock)
  protected
    FChoices: array [TViewType] of array [TChoiceType] of TFindMode;
    FOptions: TProgOptions;
    FInput: TESentence;
    FErrorLine: Integer;
    FError: Boolean;
    FErrormsg: WideString;
    FMain: TSFunction;
    FExit: TSCommand;
    FProgType: TProgType;
    GExitLabel: TSLabel;
    procedure SetInput(const Value: TESentence);
    class procedure SError(Code: Integer; Text: WideString; Filename: WideString; Line: Integer);
    procedure SetErrorLine(const Value: Integer);
    procedure SetMain(const Value: TSFunction);
    procedure SetProgType(const Value: TProgType);
    function GetChoice(i1: TViewType; i2: TChoiceType): TFindMode;
    procedure SetChoice(i1: TViewType; i2: TChoiceType; const Value: TFindMode);
  public
    property Choice[i1: TViewType; i2: TChoiceType]: TFindMode read GetChoice write SetChoice;
    property Options: TProgOptions read FOptions write FOptions;
    procedure Show(Show: Boolean; S: TSwitch);
    procedure Select(V: TViewType);

    class var FDisablePreprocessor: Boolean;
    property Input: TESentence read FInput write SetInput;
    property ErrorLine: Integer read FErrorLine write SetErrorLine;
    property Main: TSFunction read FMain write SetMain;
    property ProgType: TProgType read FProgType write SetProgType;
    procedure Verify;
    class function PreProc(List: TStringList): TProgType;
    class function Compile(L: TStringList): TSProgram;
    function Build(EP: TEProgram = nil): TEProgram; virtual;
    constructor Create; override;
    destructor Destroy; override;
  end;

  {* true konstans *}
  TSTrue = class(TSJump)
    procedure Proc2Rec2; override;
  end;

  {* false konstans *}
  TSFalse = class(TSJump)
    procedure Proc2Rec2; override;
  end;

  {* Skip utasítás *}
  TSSkip = class(TSJump)
    procedure Proc2Rec2; override;
  end;

  {* Show utasítás *}
  TSShow = class(TSSkip)
  end;

  {* Hide utasítás *}
  TSHide = class(TSSkip)
  end;

  {* bináris operátorok *}
  TSBinop = class(TSNode)
  end;

  {* lusta és *}
  TSAnd = class(TSBinop)
    procedure Proc1; override;
  end;

  {* lusta vagy *}
  TSOr = class(TSBinop)
    procedure Proc1; override;
  end;

  {* elágazó vagy *}
  TSFork = class(TSBinop)
    procedure Proc2Rec2; override;
    procedure Proc1; override;
  end;

  {* not *}
  TSNot = class(TSNode)
  public
    procedure Proc1; override;
  end;

  {* a szintaxisfa azon elemei, melyek a redukálás során megmaradnak,
    ezek adják majd a végrehajtható programozott nyelvtan, T-gép alapját *}
  TSLine = class(TSCommand)
  protected
    FInstance: TEItem;
  public
    property FileName: WideString read FFileName;
    procedure Proc1; override;
    procedure Build(EP: TEProgram); virtual;
    property Instance: TEItem read FInstance write FInstance;
  end;

  {* függvényhívás *}
  TSCall = class(TSLine)
  protected
    FActualPara: TList;
    FFunction: TSFunction;
  public
    procedure Build(EP: TEProgram); override;
    constructor Create(F: TSFunction; P: TList = nil); reintroduce; overload;
    destructor Destroy; override;
  end;

  {* elágazás *}
  TSIf = class(TSNode)
  public
    procedure Proc1; override;
  end;

  {* elöltesztelõs ciklus *}
  TSWhile = class(TSNode)
  public
    procedure Proc1; override;
  end;

  {* szekvenciális blokk utasítás *}
  TSSeqBlock = class(TSBlock)
  public
    procedure Proc1; override;
  end;

  {* párhuzamos blokk *}
  TSParBlock = class(TSBlock)
  public
    procedure Proc1; override;
  end;

  {* elágazó blokk *}
  TSForkBlock = class(TSBlock)
  public
    procedure Proc1; override;
  end;

  {* ugró utasítás *}
  TSGoto = class(TSJump)
  protected
    FLabels: TList;
    procedure SetLabels(const Value: TList);
  public
    procedure Proc2Rec2; override;
    property Labels: TList read FLabels write SetLabels;
    constructor Create; overload; override;
    constructor Create(L: TList); overload;
    destructor Destroy; override;
  end;

  {* termináló utasítás *}
  TSExit = class(TSLine)
    procedure Build(EP: TEProgram); override;
  end;

  {* elfogadó-termináló utasítás *}
  TSAccept = class(TSLine)
    procedure Build(EP: TEProgram); override;
  end;

{ ---------------------------------------------------------------------
                "Futtatható" belsõ reprezentáció elemei
}

  {* a futtatható elemek õse *}
  TEItem = class
  protected
    FName: string;
    procedure SetName(const Value: WideString);
    function GetName: WideString;
  public
    property Name: WideString read GetName write SetName;
  end;

  {* nyelvtani jelek *}
  TELetter = class(TEItem)
  end;

  TETerm = class(TELetter)
  end;

  TENTerm = class(TELetter)
  end;

  TEBlank = class(TETerm)
  end;

  TEPrint = class(TETerm)
  end;

  {* mondatforma *}
  TESentence = class
  private
    procedure Next;
  protected
    FLetters: TList;
    FFirst: Integer;
    FLast: Integer;
    function GetChild(index: integer): TELetter;
    procedure SetChild(index: integer; const Value: TELetter);
    procedure SetFirst(const Value: Integer);
    procedure SetLast(const Value: Integer);
  public
    procedure AssignFromArray(A: array of Integer; N: Integer; L: TList);
    procedure AssignFromInt(N: LongInt; L: TList);
    function Equal(S: TESentence): Boolean;
    function Clone: TESentence;
    procedure Push(S: TESentence);
    procedure Pop;
    function TopItem: TELetter;
    procedure Write(I: Integer; L: TELetter);
    function IsEps: Boolean;
    function Len(UseSpace: Boolean): Integer;
    property First: Integer read FFirst write SetFirst;
    property Last: Integer read FLast write SetLast;
    procedure Draw(C: TCanvas; Left, Top: Integer; Color: TColor = clRed);
    function ToString(UseSpace: Boolean; First: Integer; Last: Integer): WideString; overload;
    function ToString(UseSpace: Boolean = true): WideString; overload;
    function ToTapeString: WideString;
    function CharPos(LetterPos: Integer; UseSpace: Boolean = true): Integer;
    function ToAnsiString: String;
    function Count: integer;
    procedure Add(L: TELetter); overload;
    procedure Add(S: TESentence); overload;
    function Items: TList;
    property Letters[index: integer]: TELetter read GetChild write SetChild; default;
    function Find(K: Integer; L: TESentence): integer; overload;
    function Find(L: TESentence; M: TFindMode; K: Integer = -1): integer; overload;
    function FindAll(L: TESentence; var T: intarray): integer;
    procedure Insert(K, M: Integer; S: TESentence);
    function IsTerminal: boolean;
    procedure Assign(Source: TESentence); overload;
    procedure Assign(Source: TList); overload;
    constructor Create(T: array of TELetter); overload;
    constructor Create(L: TList); overload;
    constructor Create; overload;
    destructor Destroy; override;
  end;

  {* végrehajtható program sora *}
  TEBasLine = class(TEItem)
  protected
    FShowCount: Integer;
    FSLine: TSLine;
    procedure SetSLine(const Value: TSLine);
  public
    property SLine: TSLine read FSLine write SetSLine;
    property ShowCount: Integer read FShowCount write FShowCount;
    function IsPrint: Boolean; virtual;
    function Visible: Boolean; virtual;
    function ToString(UseSpace: Boolean = false): WideString; virtual;
    function ToAnsiString: string; virtual;
    function IsLetter: Boolean; virtual;
    constructor Create;
  end;

  {* olyan programsor aminek van Sig és Fi *}
  TELine = class(TEBasLine)
  protected
    FState: TSLabState;
    FRo: TList;
    FFi: TList;
    procedure SetRo(const Value: TList);
    procedure SetFi(const Value: TList);
  public
    procedure ResolveA; virtual;
    procedure Resolve;
    class procedure ResolveList(L: TList);
    property Sig: TList read FRo write SetRo;
    property Fi: TList read FFi write SetFi;
    constructor Create; overload;
    destructor Destroy; override;
  end;

  {* függvényhívás *}
  TECall = class(TELine)
  protected
    FLines: TList;
    FPara: TList;
    FFunct: TSFunction;
    FStarts: TList;
    procedure SetFunct(const Value: TSFunction);
    procedure SetPara(const Value: TList);
    procedure ResolveA; override;
    function GetLines: TList;
  public
    function IsLetter: Boolean; override;
    procedure Expand(EP: TEProgram);
    property Lines: TList read GetLines;
    property Funct: TSFunction read FFunct write SetFunct;
    property Para: TList read FPara write SetPara;
    function ToAnsiString: string; override;
    constructor Create;
    destructor Destroy; override;
  end;

  {* futtatható program gyökere *}
  TEStart = class(TELine)
  protected
    FEProgram: TEProgram;
    FControl: TObject; // ListView, TreeView
    procedure SetEProgram(const Value: TEProgram);
  published
    property EProgram: TEProgram read FEProgram write SetEProgram;
  end;

  {* TSExit megfelelõje *}
  TEExit = class(TELine)
    function IsLetter: Boolean; override;
    procedure ResolveA; override;
  end;

  {* "futtatható" program *}
  TEProgram = class
  protected
    FStart: TENTerm;
    FInput: TESentence;
    FFirst: TEStart; // a kezdõ konfiguráció címkéje
    FStarts: TList; // a kezdõ címkék halmaza
    FMain: TECall; // Main fgv.
    FLines: TList;
    FStartTree, FStartList, FStartLang: TConfig;
    FNames: TStringList;
    FNewLineCount: Integer;
    FTreeView: TTntTreeView;
    FListView: TTntListView;
    FLog: TTntListView;
    FLangCalled: Boolean;
    FRunFrm: TObject;
    FExit: TEExit;
    FEps: TELetter;
    FSProgram: TSProgram;
    function GetLines(index: integer): TEBasLine;
    procedure SetLines(index: integer; const Value: TEBasLine);
    procedure SetInput(const Value: TESentence);
  public
    property RunFrm: TObject read FRunFrm write FRunFrm;
    property PExit: TEExit read FExit;
    property PEps: TELetter read FEps;
    function IsEmpty: Boolean; virtual;
    property Input: TESentence read FInput write SetInput;
    function AddName(I: TEItem; S: string = ''): string;
    procedure Build(C: TECall); virtual;
    procedure Select(V: TViewType);
    function CanRead(L: TELetter): Boolean; virtual;
    function CanStep(L: TELetter): Boolean; virtual;

    procedure GetTerms(L: TStringList);
    procedure GetNTerms(L: TStringList);
    function ToStringList: TStringList;
    function AddRule(L: TEBasLine; S: String = ''): TEBasLine; overload;
    function AddRule3(L: TEBasLine): TEBasLine; overload;
    function AddCall(L: TEBasLine): TEBasLine; overload;
    function Count: Integer;
    property Lines[index: integer]: TEBasLine read GetLines write SetLines; default;
    property TreeView: TTntTreeView read FTreeView write FTreeView;
    property ListView: TTntListView read FListView write FListView;
    function SProgram: TSProgram;

    procedure RunTree(D: Integer); virtual; abstract;
    procedure RunList(D: Integer); virtual; abstract;
    procedure RunLang; virtual;
    procedure ToListView(LV: TTntListView); virtual; abstract;
    procedure GetDefinition(L: TTntStrings); virtual; abstract;

    constructor Create;
    destructor Destroy; override;
  end;

{ ---------------------------------------------------------------------
                        Konfigurációk
}

  {* egy döntési pont leírója a lista nézetben *}
  TCMatrix = class
    Rows: TList;
    Cols: TList;
    Items: TObjectMatrix;
    constructor Create;
    destructor Destroy; override;
  end;

  {* PNY/TG/VA egy konfigurációja *}
  TConfig = class
    FRoot: TConfig;
    FChildren: TList;
    FParent: TConfig;
    FNode: TObject;
    FRuned: Boolean;
    FLine: TEBasLine;
    procedure SetNode(const Value: TObject);
    function GetNode: TObject;
    procedure SetChildren(const Value: TList);
    procedure SetRuned(const Value: Boolean);
  public
    function GetLangString: WideString; virtual;
    function GetTreeString: WideString; virtual;

    function MakeTreeNode(TV: TObject = nil): TObject; virtual;
    function MakeListNode(TV: TObject = nil): TObject; virtual;
    function MakeLangNode(TV: TObject = nil): TObject; virtual;
    function MakeListNodeCond(TV: TObject = nil): TObject; virtual;

    procedure DrawTreeNode(C: TCanvas; Left, Top: Integer; Color: TColor); virtual;

    function IsTerminal: Boolean; virtual;
    function GetMatrix: TCMatrix; virtual; abstract;
    function GetProgram: TEProgram;
    function GetListView: TTntListView;
    function GetTreeView: TTntTreeView;
    procedure DetachAndFree;
    property Runed: Boolean read FRuned write SetRuned;
    function Line: TEBasLine; virtual;
    procedure SetLine(L: TEBasLine);
    property Node: TObject read GetNode write SetNode;
    function Add(C: TConfig): TConfig; virtual;
    property Items: TList read FChildren write SetChildren;
    function Parent: TConfig;
    procedure SetColor(S: TESentence; var C: TColor; HideColor: Boolean); virtual; abstract;

    function ToString(UseSpace: Boolean = false): WideString; virtual; abstract;
    function StateToString(UseSpace: Boolean = false): WideString; virtual; abstract;
    procedure MakeChildren; virtual; abstract;
    procedure RunTree(D: Integer); virtual;
    procedure RunList(D: Integer); virtual;
    procedure RunLang(D: Integer); virtual;
    function MakeNode(TV: TObject = nil): TObject; virtual;
    function IsLast: Boolean; virtual;
    constructor Create(P: TConfig; L: TEBasLine);
    destructor Destroy; override;
  end;

{* A progress ablak típusai *}

const
  IID_IOleWindow: TGUID = (
    D1: $00000114;
    D2: $0000;
    D3: $0000;
    D4: ($C0, $00, $00, $00, $00, $00, $00, $46)
  );

  CLSID_ProgressDialog: TGUID = (
    D1:$F8383852;
    D2:$FCD3;
    D3:$11D1;
    D4:($A6, $B9, $0, $60, $97, $DF, $5B, $D4)
  );

  SID_IProgressDialog    = '{EBBC7C04-315E-11D2-B62F-006097DF5BD4}';

  PROGDLG_NORMAL        =  $00000000;
  PROGDLG_MODAL         =  $00000001;
  PROGDLG_AUTOTIME      =  $00000002;
  PROGDLG_NOTIME        =  $00000004;
  PROGDLG_NOMINIMIZE    =  $00000008;
  PROGDLG_NOPROGRESSBAR =  $00000010;
  PDTIMER_RESET = $00000001;
  PBM_SETMARQUEE = (WM_USER+10);
  PBS_MARQUEE = $08;

type
  IProgressDialog = interface
    [SID_IProgressDialog]
    function StartProgressDialog(hwndParent: HWND; punkEnableModless: IUnknown; dwFlags: DWORD; pvResevered: Pointer): HResult; stdcall;
    function StopProgressDialog: HResult; stdcall;
    function SetTitle(pwzTitle: LPCWSTR): HResult; stdcall;
    function SetAnimation(hInstAnimation: THandle; idAnimation: UINT): HResult; stdcall;
    function HasUserCancelled: BOOL; stdcall;
    function SetProgress(dwCompleted: DWORD; dwTotal: DWORD): HResult; stdcall;
    function SetProgress64(ullCompleted: int64; ullTotal: int64): HResult; stdcall;
    function SetLine(dwLineNum: DWORD; pwzString: LPCWSTR; fCompactPath: BOOL; pvResevered: Pointer): HResult; stdcall;
    function SetCancelMsg(pwzCancelMsg: LPCWSTR; pvResevered: Pointer): HResult; stdcall;
    function Timer(dwTimerAction: DWORD; pvResevered: Pointer): HResult; stdcall;
  end;

  {* nyelv számításához használt thread *}
  TEThread = class(TThread)
  public
    FCompl: Cardinal;
    FTimer: TTimer;
    FProgress: IProgressDialog;
    ListView: TTntListView;
    Limit: Integer;
    Config: TConfig;
    procedure Terminate3(Sender: TObject);
    procedure StepProgress(Sender: TObject);
    function Terminated2: Boolean;
    procedure RunConfig; virtual; abstract;
    function Expired: Boolean;
    procedure GetResults;
    procedure Execute; override;
    constructor Create;
    destructor Destroy; override;
  end;

  function Compile(L: TStringList; var EP: TEProgram): Integer;
  function ListInst(L: TList): TList;
  function ListToStr(L: TList): string;
  function ListToStr2(L: TList): string; overload;
  function ListToStr2(L: TStringList): string; overload;
  function MakeTreeNode3(P: TTntTreeNode; C: TConfig; S: WideString; B: boolean = false): TTntTreeNode;
  function MakeTreeNode2(TV: TTntTreeView; C: TConfig; S: WideString): TTntTreeNode;
  function ChoiceInt(N: integer; M: TFindMode): integer;
  function ChoiceList(L: TList; M: TFindMode): TObject;
  function Lighter(Color: TColor; Percent: byte): TColor;
  procedure SaveLog;

var
  GCall: TECall;

  Default: TSProgram; // beállításokat tárolja
  GRuleChoice: TFindMode;
  GLetterChoice: TFindMode;
  GRuleChoice2: TFindMode;
  GLetterChoice2: TFindMode;
  GDeadEnd: Boolean; // zsákutcákat muatassa-e
  GDeterm: Boolean; // determinisztikus ágakat mutassa-e
  GColors: Boolean; // szineket mutassa-e lista nézetben

  GTreeLetter, GTreeRule,
  GListLetter, GListRule,
  GResultLetter, GResultRule: TFindMode;

  GAniTime,
  GTimeLimit, GDbLimit,
  GDbInput, GKonfigpInput,
  GListLimit, GTreeLimit: Integer;

  GThread: TEThread;

  GLog: TTntListView;

  GUSpace, GTurSpace: Boolean;
  Blank: TEBlank;

  GSPrint: TSPrint;
  GEPrint: TEPrint;

  GMonoFont: TFont;
  GFont: TFont;
  GAniFont: TFont;
  GMaxLength: Integer;

  SelectedColor: TColor;

  LogF: TStringList;
  mainpath, datapath: WideString;
  logfile: Widestring = 'log.txt';

const
  ErrorMsg: array[0..10] of string =
  ( '',
    'Invalid global declaration',
    'Symbol is already declared',
    'Unknown symbol',
    'Expected type: letter',
    'Expected symbol: eps',             //5
    'Expected type: macro name',
    'Invalid command',
    'Invalid parameter',
    'Missing return',
    'Invalid return'    //10
  );

implementation

uses
  ProLanYacc, ShellApi, Forms,
  Dialogs, UMainForm, DateUtils, URunFrm, UGrammar, UTuring, TNTGraphics,
  UPushDown, LexLib2, UPrefDlg, UCodeFrm, UAdvFrm;

var
  GExit: TSExit;
  GAccept: TSAccept;
  GFunction: TSFunction;
  GSProgram: TSProgram;
  GShowCount: Integer;

procedure SaveLog;
begin
  try
    Logf.SaveToFile(datapath + '\' + logfile);
  except
    // Skip
  end;
end;

procedure TSProgram.Select(V: TViewType);
  function f(V: TViewType; C: TChoiceType): TFindMode;
  begin
    Result := Choice[V, C];
    if Result = fmNone then
      Result := Default.Choice[V, C];
  end;

var
  Letter, Rule: TFindMode;

begin
  Letter := f(V, ctPos);
  Rule := f(V, ctRule);

  if poShowDeadEnd in FOptions then
    GDeadEnd := true
  else if poHideDeadEnd in FOptions then
    GDeadEnd := false
  else
    GDeadEnd := poShowDeadEnd in Default.Options;

  if poShowDeterm in FOptions then
    GDeterm := true
  else if poHideDeterm in FOptions then
    GDeterm := false
  else
    GDeterm := poShowDeterm in Default.Options;

  if poShowColors in FOptions then
    GColors := true
  else if poHideColors in FOptions then
    GColors := false
  else
    GColors := poShowColors in Default.Options;

  case V of
    vtList:
    begin
      GRuleChoice := fmAll; GRuleChoice2 := Rule;
      if Letter = fmRandom then
      begin
        GLetterChoice := fmAll; GLetterChoice2 := Letter;
      end
      else
        GLetterChoice := Letter;
    end;
    vtTree:
    begin
      GRuleChoice := Rule; GRuleChoice2 := fmFirst;
      if Letter = fmAll then
      begin
        GLetterChoice := fmAll; GLetterChoice2 := fmFirst;
      end
      else
        GLetterChoice := Letter;
    end;
    vtSet:
    begin
      if Letter = fmRandom then
      begin
        GLetterChoice := fmAll; GLetterChoice2 := fmFirst;
      end
      else
        GLetterChoice := Letter;

      if Rule = fmRandom then
      begin
        GRuleChoice := fmAll; GRuleChoice2 := fmFirst;
      end
      else
        GRuleChoice := Rule;
    end;
  end;
end;

class procedure TSProgram.SError(Code: Integer; Text: WideString; Filename: WideString; Line: Integer);
var
  S: String;
begin
  if MainForm.PageFrame1 <> nil then
  with MainForm.PageFrame1.lbLog do
  begin
    if Code = -1 then
      S := Text
    else
    begin
      S := '[Syntax error] ' + FileName + '(' + IntToStr(Line) + '): ';
      if Code > 0 then
        S := S + ErrorMsg[Code];
      if Text <> '' then
        S := S + ': ' + Text;
    end;
    Items.Add(S);
    Selected[Items.Count - 1] := true;
  end;
  if MainForm.PageFrame1.Current is TAdvFrm then
  begin
    TAdvFrm(MainForm.PageFrame1.Current).CodeFrm1.SelectLine(Line, clRed);
  end;
end;

function Compile(L: TStringList; var EP: TEProgram): Integer;
var
  I: Integer;
  SP: TSProgram;
  S: String;

  procedure MError(R: Integer);
  begin
    Result := R;
    FreeAndNil(EP);
    FreeAndNil(SP);
    TSProgram.SError(-1, '[Syntax error]', '', 0);
  end;
begin
  SP := nil;
  FreeAndNil(EP);
  try
    try
      SP := TSProgram.Compile(L);
    except
      Result := 1; // Syntax error
      FreeAndNil(SP);
      exit;
    end;
    try
      if (SP <> nil) and (SP.Count > 0) and not SP.ferror then
      begin
        EP := SP.Build;
        if EP.IsEmpty then
          MError(2)
        else
          Result := 0; // OK
      end
      else
        MError(1)
    except
      MError(2)
    end;
  except
    MError(3)
  end;
end;

function ListInst(L: TList): TList;

  procedure p(C, M: TList);
  var
    I: Integer;
  begin
    for I := 0 to M.Count - 1 do
      if TObject(M[I]) is TSLetter then
        C.Add(TSLetter(M[I]).Instance)
      else if TObject(M[I]) is TList then
        p(C, TList(M[I]))
      else if TObject(M[I]) is TSLine then
        C.Add(TSLine(M[I]).Instance)
  end;

begin
  Result := TList.Create;
  p(Result, L);
end;

function Resolve(L: TList): TList;
var
  I: Integer;
  J: Integer;
  C: TSJump;
  O: TObject;
begin
  Result := TList.Create;
  for I := 0 to L.Count - 1 do
  begin
    O := TObject(L[I]);
    if (O is TSLine) or (O is TSReturn) then
      Result.Add(O)
    else if O is TSJump then
    begin
      C := TSJump(O);
      for J := 0 to C.Jumps.Count - 1 do
        Result.Add(C.Jumps[J]);
    end;
  end;
end;

procedure Resolve2(L: TList);
var
  M: TList;
begin
  M := Resolve(L);
  L.Assign(M);
  M.Free;
end;

{ TSTable }

procedure TSTable.Build;
var
  I: Integer;
  C: TObject;
begin
  for I := 0 to FList.Count - 1 do
  begin
    C := FList.Objects[I];
    if C is TSLine then
      TSLine(C).Build(EP)
    else if C is TSLetter then
      if TSLetter(C).FIsLocal then
        TSLetter(C).Build(EP);
  end;
end;

constructor TSTable.Create;
begin
  inherited Create;
  FList := TStringList.Create;
  FList.Sorted := true;
  FList.Duplicates := dupError;
  FList.CaseSensitive := true;
end;

function TSTable.Declare(S: string; C: TClass; B: Boolean): TObject;
begin
  Result := FindNonRec(S);
  if Result = nil then
  begin
    if C.InheritsFrom(TSLabel) and not IsFuncTable then
    begin
      Result := GetFuncTable.Declare(S, C, B);
      exit;
    end
    else if C.InheritsFrom(TSCommand) then
    begin
      Result := TSClass(C).Create;
      TSCommand(Result).Name := S;
    end
    else if C.InheritsFrom(TSLetter) then
    begin
      Result := TSLetterClass(C).Create;
      TSLetter(Result).Name := S;
      TSLetter(Result).FIsLocal := B;
    end;
    FList.AddObject(S, Result);
  end
  else
    Result := nil; // redeclaring
end;

destructor TSTable.Destroy;
var
  I: Integer;
begin
  for I := FList.Count - 1 downto 0 do
    if FList.Objects[I] is TSLetter then
      FList.Objects[I].Free;
  FList.Free;
  inherited;
end;

function TSTable.Find(S: string; C: TClass = nil): TObject;
begin
  Result := Self[S];
  if Result = nil then
    if Parent = nil then
      // SKIP
    else
      Result := Parent.Find(S, C)
  else if not ((C = nil) or (Result is C)) then
    Result := nil;
end;

function TSTable.FindNonRec(S: string; C: TClass): TObject;
begin
  Result := Self[S];
  if not ((C = nil) or (Result is C)) then
    Result := nil;
end;

function TSTable.GetChild(index: string): TObject;
begin
  if FList.IndexOf(index) >= 0 then
    Result := TObject( FList.Objects[ FList.IndexOf(index) ] )
  else
    Result := nil;
end;

function TSTable.GetFuncTable: TSTable;
begin
  Result := Self;
  while (Result <> nil) and not Result.IsFuncTable do
    Result := Result.Parent;
end;

procedure TSTable.SetIsFuncTable(const Value: Boolean);
begin
  FIsFuncTable := Value;
end;

procedure TSTable.SetParent(const Value: TSTable);
begin
  FParent := Value;
end;

{ TSCall }

procedure TSCall.Build;
var
  L: TECall;
begin
  L := TECall.Create;
  Instance := L;
  EP.AddCall(L);
  L.Funct := FFunction;
  L.Sig.Assign(Sig);
  L.Fi.Assign(Fi);
  L.Para := ListInst(FActualPara);
  L.FSLine := Self;
  inherited;
end;

constructor TSCall.Create(F: TSFunction; P: TList);
begin
  inherited Create;
  FActualPara := TList.Create;
  FActualPara.Assign(P);
  FFunction := F;
end;

destructor TSCall.Destroy;
begin
  FActualPara.Free;
  inherited;
end;

{ TSNot }

procedure TSNot.Proc1;
begin
  Self[0].Sig.Assign(Fi);
  Self[0].Fi.Assign(Sig);
  inherited;
end;

{ TSIf }

procedure TSIf.Proc1;
begin
  Self[0].Sig.Add(Self[1]);
  Self[1].Sig.Assign(Sig);
  Self[1].Fi.Assign(Fi);
  if Count > 2 then
  begin
    Self[0].Fi.Add(Self[2]);
    Self[2].Sig.Assign(Sig);
    Self[2].Fi.Assign(Fi);
  end
  else
    Self[0].Fi.Assign(Sig);
  inherited;
end;

{ TSBlock }

procedure TSWhile.Proc1;
begin
  Self[0].Sig.Add(Self[1]);
  Self[0].Fi.Assign(Sig);
  Self[1].Sig.Add(Self[0]);
  Self[1].Fi.Assign(Fi);
  inherited;
end;

destructor TSBlock.Destroy;
begin
  FTable.Free;
  inherited;
end;

procedure TSBlock.SetTable(const Value: TSTable);
begin
  FTable := Value;
end;

{ TSParBlock }

procedure TSParBlock.Proc1;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Sig.Add(Self[I]);
  for I := 0 to Count - 1 do
    with Self[I] do
    begin
      Sig.Assign(Self.FChildren);
      Fi.Assign(Self.Fi);
    end;
  for I := 0 to Count - 1 do
    AddJump(Self[I]);
  inherited;
end;

{ TSNode }

function TSNode.Add(C: TSCommand): TSCommand;
begin
  Result := C;
  FChildren.Add(C);
end;

procedure TSNode.AssignChildren(L: TList);
begin
  if L = nil then
    FChildren.Clear
  else
    FChildren.Assign(L);
end;

function TSNode.Count: Integer;
begin
  Result := FChildren.Count;
end;

constructor TSNode.Create;
begin
  inherited Create;
  FChildren := TList.Create;
end;

destructor TSNode.Destroy;
var
  I: Integer;
begin
  for I := 0 to FChildren.Count - 1 do
    if not (TObject(FChildren[I]) is TSReturn) then
      TObject(FChildren[I]).Free;
  FChildren.Free;
  inherited;
end;

function TSNode.GetChildren(index: integer): TSCommand;
begin
  Result := TSCommand(FChildren[index]);
end;

procedure TSNode.Proc1;
var
  I: Integer;
begin
  inherited;
  for I := 0 to Count - 1 do
    Self[I].Proc1;
end;

procedure TSNode.Proc2;
var
  I: Integer;
begin
  inherited;
  for I := 0 to Count - 1 do
    if Self[I] is TSJump then
      TSJump(Self[I]).Proc2;
end;

procedure TSNode.Proc2Rec2;
begin
  if Count > 0 then
  begin
    AddJump(Self[0]);
    if TSCommand(Self[0]).Lab = nil then
      TSCommand(Self[0]).Lab := Lab;
  end;
  inherited;
end;

procedure TSNode.Proc3;
var
  I: Integer;
begin
  inherited;
  for I := 0 to Count - 1 do
    Self[I].Proc3;
end;

procedure TSNode.SetChildren(index: integer; const Value: TSCommand);
begin
  FChildren.Insert(index, Value);
end;

{ TSAnd }

procedure TSAnd.Proc1;
begin
  Self[0].Sig.Add(Self[1]);
  Self[0].Fi.Assign(Fi);
  Self[1].Sig.Assign(Sig);
  Self[1].Fi.Assign(Fi);
  inherited;
end;

{ TSOr }

procedure TSOr.Proc1;
begin
  Self[0].Sig.Assign(Sig);
  Self[0].Fi.Add(Self[1]);
  Self[1].Sig.Assign(Sig);
  Self[1].Fi.Assign(Fi);
  inherited;
end;

{ TSSeqBlock }

procedure TSSeqBlock.Proc1;
var
  I: Integer;
begin
  if Count > 0 then
  begin
    for I := 0 to Count - 2 do
      with Self[I] do
      begin
        Sig.Add(Self[I + 1]);
        Fi.Add(GExit);
      end;
    with Self[Count - 1] do
    begin
      Sig.Assign(Self.Sig);
      Fi.Assign(Self.Fi);
    end;
  end;
  inherited;
end;

{ TSItem }

constructor TSCommand.Create;
begin
  inherited Create;
  FSig := TList.Create;
  FFi := TList.Create;
end;

destructor TSCommand.Destroy;
begin
  FSig.Free;
  FFi.Free;
  inherited;
end;

procedure TSCommand.LineInfo(Line: Integer; FileName: WideString; Show: Integer);
begin
  FFileName := FileName;
  FLineNo := Line;
  if Show > -1 then
    FShowCount := Show;
end;

procedure TSCommand.Proc1;
begin
  // SKIP
end;

procedure TSCommand.Proc3;
begin
  Resolve2(Sig);
  Resolve2(Fi);
end;

procedure TSCommand.SetFi(const Value: TList);
begin
  FFi := Value;
end;

procedure TSCommand.SetLab(const Value: TSLabel);
begin
  FLab := Value;
end;

procedure TSCommand.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TSCommand.SetSig(const Value: TList);
begin
  FSig := Value;
end;

{ TSGoto }

constructor TSGoto.Create;
begin
  inherited Create;
  FLabels := TList.Create;
end;

constructor TSGoto.Create(L: TList);
begin
  inherited Create;
  FLabels := TList.Create;
  Labels.Assign(L);
end;

destructor TSGoto.Destroy;
begin
  FLabels.Free;
  inherited;
end;

procedure TSGoto.Proc2Rec2;
var
  I: Integer;
begin
  for I := 0 to FLabels.Count - 1 do
    AddJump(FLabels[I]);

  inherited;
end;

procedure TSGoto.SetLabels(const Value: TList);
begin
  FLabels.Assign(Value);
end;

{ TSNTerm }

procedure TSNTerm.Build;
begin
  FInstance := TENTerm.Create;
  Inc(FInstanceCount);
  EP.AddName(FInstance, FName);
end;

{ TSTerm }

procedure TSTerm.Build;
begin
  FInstance := TETerm.Create;
  Inc(FInstanceCount);
  EP.AddName(FInstance, FName);
end;

{ TSProgram }

function TSProgram.Build(EP: TEProgram = nil): TEProgram;
var
  C: TECall;
  L: TList;
begin
  if EP = nil then
  begin
    case FProgType of
      ptGrammar:
        EP := TEGrammar.Create;
      ptTuring:
        EP := TETuring.Create;
      ptPushDown:
        EP := TEPushDown.Create;
      ptEPushDown:
      begin
        EP := TEPushDown.Create;
        TEPushDown(EP).EmptyMode := true;
      end;
    end;
  end;

  EP.FSProgram := Self;
  Result := EP;
  GExit.Build(EP);
  GAccept.Build(EP);
  FTable.Build(EP);
  L := ListInst(Input.FLetters);
  EP.Input.Assign(L);
  L.Free;

  C := TECall.Create;
  C.Para := TList.Create;
  C.Funct := FMain;
  C.Sig.Add(EP.FExit);
  C.Fi.Add(EP.FExit);
  EP.Build(C);
end;

class function TSProgram.Compile(L: TStringList): TSProgram;
var
  P: ProLanYacc.TParser;
  I: Integer;
  C: TSFunction;
  Lab: TSGoto;
  S: String;

  {* ellenõrzi az érvénytelen címkéket *}
  function Bejar(X: TSCommand): TSGoto;
  var
    I, J: Integer;
  begin
    Result := nil;
    if X is TSNode then
    begin
      for I := 0 to TSNode(X).Count - 1 do
      begin
        Result := Bejar(TSNode(X)[I]);
        if Result <> nil then
          exit;
      end;
    end
    else if X is TSGoto then
      for J := 0 to TSGoto(X).FLabels.Count - 1 do
        if TSLabel(TSGoto(X).FLabels[J]).FCommand = nil then
        begin
          Result := TSGoto(X);
          exit;
        end;
  end;

begin
  try

  P := ProLanYacc.TParser.Create;
  Result := TSProgram.Create;
  if FDisablePreprocessor then
    LogF.Add('Disable Preprocessor');

  if not FDisablePreprocessor then
  begin
    LogF.Add('Start Preproc');
    PreProc(L);
  end
  else Result.FProgType := ptGrammar;

  if L.Count = 0 then
  begin
    S := '[Preprocessing error]';
    SError(-1, S, P.FFileName, 0);
    LogF.Add(S + ' Count = 0');
    P.Free;
    raise ESyntaxError.Create(S);
  end;

  LogF.Add('ProgType = ' + IntToStr(Integer(Result.FProgType)));

  P.GProgram := Result;
  LogF.Add('Start Parse');
  try
    P.Parse(L);
  except
    S := '[Syntax error]';
    SError(-1, S, tempfile1, 0);
    LogF.Add(S + 'Parser error');
    P.Free;
    raise ESyntaxError.Create(S);
  end;

  Result.FError := P.ferror;
  if P.FFileName = tempfile1 then
    P.FFileName := ExtractFileName(MainForm.FileName);


  if not Result.FError then
  begin
    Lab := Bejar(Result);
    if Lab <> nil then
    begin
      SError(7, '[Syntax error]', Lab.FFileName, Lab.FLineNo);
      Result.FErrorLine := Lab.FLineNo;
      LogF.Add('Bab label :FError');
      P.Free;
      raise ESyntaxError.Create(P.FMessage);
    end;
  end
  else if not Result.FError and (Result.Count = 0) then
  begin
    S := '[Syntax error]';
    SError(-1, S, P.FFileName, 0);
    LogF.Add(S + ' Count = 0');
    P.Free;
    raise ESyntaxError.Create(S);
  end;
  if Result.FError then
  begin
    SError(P.FECode, P.FMessage, P.FFileName, P.FLine);
    Result.FErrorLine := P.FLine;
    LogF.Add(P.FMessage + ' :FError');
    P.Free;
    raise ESyntaxError.Create(P.FMessage);
  end;

  P.Free;

  if not Result.FError then
  begin
    LogF.Add('Proc1 Start');
    Result.Proc1;
    LogF.Add('Proc2 Start');
    Result.Proc2;
    LogF.Add('Proc3 Start');
    Result.Proc3;
    LogF.Add('Find main');
    for I := 0 to Result.Count - 1 do
    begin
      C := TSFunction(Result[I]);
      if  C.Name = 'main' then
      begin
        Result.FMain := TSFunction(C);
        break;
      end;
    end;
    LogF.Add('Compiling completed');
  end;
  finally
    SaveLog;
  end;
end;

constructor TSProgram.Create;
begin
  inherited;
  FProgType := ptGrammar;
  FTable := TSTable.Create;
  FTable.IsFuncTable := true;
  GSProgram := Self;

  GExit := TSExit.Create;
  GExit.Name := 'exit';
  GExitLabel := TSLabel(FTable.Declare('exit', TSLabel, true));
  GExitLabel.Command := GExit;

  GAccept := TSAccept.Create;
  GAccept.Name := 'accept';
  TSLabel(FTable.Declare('accept', TSLabel, true)).Command := GAccept;

  Sig.Add(GExit);
  Fi.Add(GExit);
  FTable.Declare('eps', TSEps, true);
  FTable.Declare('_', TSBlank, true);

  FInput := TESentence.Create;
end;

destructor TSProgram.Destroy;
begin
  GExit.Free;
  GExitLabel.Free;
  FInput.Free;
  inherited;
end;

function TSProgram.GetChoice(i1: TViewType; i2: TChoiceType): TFindMode;
begin
  Result := FChoices[i1, i2];
end;

procedure TSProgram.Show(Show: Boolean; S: TSwitch);
begin
  case Show of
    true:
      case S of
        swDeterm:  FOptions := FOptions + [poShowDeterm]  - [poHideDeterm];
        swColors:  FOptions := FOptions + [poShowColors]  - [poHideColors];
        swDeadend: FOptions := FOptions + [poShowDeadend] - [poHideDeadend];
        swAll:     FOptions := FOptions + [poShowColors]  - [poHideColors];
      end;
    false:
      case S of
        swDeterm:  FOptions := FOptions - [poShowDeterm]  + [poHideDeterm];
        swColors:  FOptions := FOptions - [poShowColors]  + [poHideColors];
        swDeadend: FOptions := FOptions - [poShowDeadend] + [poHideDeadend];
        swAll:     FOptions := FOptions - [poShowColors]  + [poHideColors];
      end;
  end;
end;

class function TSProgram.PreProc(List: TStringList): TProgType;
var
  proc_info: TProcessInformation;
  startinfo: TStartupInfo;
  ExitCode: longword;
  f1, f2, c, S, Inc: String;
  I: Integer;

  function GetTempDirectory: String;
  var
    tempFolder: array[0..MAX_PATH] of Char;
  begin
    GetTempPath(MAX_PATH, @tempFolder);
    result := StrPas(tempFolder);
  end;

begin
  Result := ptGrammar;
  f1 :=
    GetTempDirectory +
    tempfile1;
  f2 :=
    GetTempDirectory +
    tempfile2;

  LogF.Add('f1 = ' + f1);
  LogF.Add('f2 = ' + f2);

  Inc := ' -I.';

  for I := 0 to PrefDlg.ListBox1.Count - 1 do
    Inc := Inc + ' -I ' + PrefDlg.ListBox1.Items[I];

  LogF.Add('Inc = ' + Inc);

  List.SaveToFile(f1);

  FillChar(proc_info, sizeof(TProcessInformation), 0);
  FillChar(startinfo, sizeof(TStartupInfo), 0);
  startinfo.dwFlags := STARTF_USESHOWWINDOW;
  startinfo.wShowWindow := SW_HIDE;
  startinfo.cb := sizeof(TStartupInfo);
  C := MainPath + 'gcc.exe -E ' + {'-P ' +} f1 + ' -o ' + f2 + Inc;// + 'C:\Users\Gazda\Documents\RAD Studio\Projects\szakdoli'; //ExtractFilePath( Application.ExeName);


  if CreateProcess(nil, PChar(C), nil,
      nil, false, NORMAL_PRIORITY_CLASS, nil, PChar(ExtractFilePath( Application.ExeName ))  {nil PChar(GetTempDirectory)},
       startinfo, proc_info) <> False then
  begin
    LogF.Add('Process Created: ' + C);
    WaitForSingleObject(proc_info.hProcess, INFINITE);
    GetExitCodeProcess(proc_info.hProcess, ExitCode);  // Optional
    CloseHandle(proc_info.hThread);
    CloseHandle(proc_info.hProcess);
    if FileExists(f2) then
      List.LoadFromFile(f2);
    Result := ptGrammar;
    LogF.Add('Preproc completed');
  end
  else
  begin
    List.Clear;
    LogF.Add('Can''t create process: ' + C);
  end;
end;

procedure TSProgram.SetChoice(i1: TViewType; i2: TChoiceType;
  const Value: TFindMode);
begin
  FChoices[i1, i2] := Value;
end;

procedure TSProgram.SetErrorLine(const Value: Integer);
begin
  FErrorLine := Value;
end;

procedure TSProgram.SetInput(const Value: TESentence);
begin
  FInput := Value;
end;

procedure TSProgram.SetMain(const Value: TSFunction);
begin
  FMain := Value;
end;

procedure TSProgram.SetProgType(const Value: TProgType);
begin
  FProgType := Value;
end;

procedure TSProgram.Verify;
begin
  if not FError then
  begin
    if Count = 0 then
      raise ESyntaxError.Create('Üres bemenet.');
    FError := (Count = 0);
  end;
end;

{ TSFunction }

procedure TSFunction.AddLine(L: TSLine);
begin
  FLines.Add(L);
end;

procedure TSFunction.AddTable(T: TSTable);
begin
  FTables.Add(T);
end;

function TSFunction.Block: TSBlock;
begin
  if Count > 0 then
    Result := TSBlock(Self[0])
  else
    Result := nil;
end;

procedure TSFunction.Build;

  procedure Resolve(L: TList);
  var
    M: TList;
    C: TSJump;

    procedure f(X: TObject);
    var
      I: Integer;
    begin
      if X is TELine then
        M.Add(X)
      else if X is TSLine then
        M.Add(TSLine(X).Instance)
      else if X is TSJump then
      begin
        C := TSJump(X);
        for I := 0 to C.Jumps.Count - 1 do
          f(C.Jumps[I]);
      end;
    end;
  var
    I: Integer;

  begin
    M := TList.Create;
    for I := 0 to L.Count - 1 do
      f(L[I]);
    L.Assign(M);
    M.Free;
  end;

var
  I: Integer;
begin
  Table.Build(EP);
  for I := 0 to FTables.Count - 1 do
    TSTable(FTables[I]).Build(EP);

  for I := 0 to FLines.Count - 1 do
    TSLine(FLines[I]).Build(EP);

  {* Jumpok feloldása : minden TELine-re mutasson *}
  for I := 0 to FLines.Count - 1 do
  begin
    Resolve(TELine(TSLine(FLines[I]).Instance).Sig);
    Resolve(TELine(TSLine(FLines[I]).Instance).Fi);
  end;

  {* ECall-ok kibontasa *}
  for I := 0 to FLines.Count - 1 do
    if TSLine(FLines[I]).Instance is TECall then
      TECall(TSLine(FLines[I]).Instance).Expand(EP);
end;

function TSFunction.CheckPara(L: TList): boolean;
var
  i: integer;
begin
  Result := true;
  if L.Count <> FFormalPara.Count then
    Result := False
  else
    for i := 0 to L.Count - 1 do
      if not TObject(L[I]).InheritsFrom(TObject(FFormalPara[i]).ClassType) then
        Result := False;
end;

constructor TSFunction.Create;
begin
  inherited;
  FFormalPara := TList.Create;
  FTables := TList.Create;
  FLines := TList.Create;
  FOTrue := TSReturn.Create;
  FOTrue.Name := 'true';
  FSig.Add(FOTrue);
  FOFalse := TSReturn.Create;
  FFi.Add(FOFalse);
  FOFalse.Name := 'false';
end;

destructor TSFunction.Destroy;
begin
  FFormalPara.Free;
  FTables.Free;
  FLines.Free;
  FOTrue.Free;
  FOFalse.FRee;
  inherited;
end;

procedure TSFunction.Proc1;
var
  OFU: TSFunction;
begin
  if Block <> nil then
  begin
    OFU := GFunction;
    GFunction := Self;
    Block.Sig.Add(FOTrue);
    Block.Fi.Add(FOFalse);
    inherited;
    GFunction := OFU;
  end;
end;

procedure TSFunction.SetFi(const Value: TList);
begin
  FOFalse.Jumps.Assign(Value);
end;

procedure TSFunction.SetFuncType(const Value: TSFuncType);
begin
  FFuncType := Value;
end;

procedure TSFunction.SetParams(const Value: TList);
begin
  FFormalPara.Assign(Value);
end;

procedure TSFunction.SetSig(const Value: TList);
begin
  FOTrue.Jumps.Assign(Value);
end;

function TSFunction.Table: TSTable;
begin
  Result := Block.Table;
end;

{ TSExit }

procedure TSExit.Build;
begin
  FInstance := EP.FExit;
end;

{ TSLine }

procedure TSLine.Build(EP: TEProgram);
begin
  (FInstance as TEBasLine).FShowCount := FShowCount;
end;

procedure TSLine.Proc1;
begin
  GFunction.FLines.Add(Self);
end;

{ TEItem }

function TEItem.GetName: WideString;
begin
  if FName = 'eps' then
    Result := eps
  else
    Result := FName;
end;

procedure TEItem.SetName(const Value: WideString);
begin
  FName := Value;
end;

{ TSCommand }

procedure TSJump.SetJumps(const Value: TList);
begin
  FJumps.Assign(Value);
end;

procedure TSJump.AddJump;
begin
  if FJumps.IndexOf(C) = -1 then
    FJumps.Add(C);
end;

constructor TSJump.Create;
begin
  inherited;
  FJumps := TList.Create;
end;

destructor TSJump.Destroy;
begin
  FreeAndNil(FJumps);
  inherited;
end;

procedure TSJump.Proc2Rec1;
begin
  if FLabState = lsProcessing then
    raise Exception.Create('Cyclic label reference!')
  else if FLabState = lsUnprocessed then
  begin
    FLabState := lsProcessing;
    Proc2Rec2;
    FLabState := lsProcessed;
  end;
end;

procedure TSJump.Proc2;
begin
  case FLabState of
    lsUnProcessed: Proc2Rec1;
    lsProcessing: raise Exception.Create('Cyclic label reference!');
    lsProcessed: // Skip;
  end;
end;

procedure TSJump.Proc2Rec2;
var
  I: Integer;
begin
  for I := 0 to Jumps.Count - 1 do
    if TObject(Jumps[I]) is TSJump then
      TSJump(Jumps[I]).Proc2Rec1;
  Resolve2(Jumps);
end;

{ TSLabel }

procedure TSLabel.Proc2Rec2;
begin
  AddJump(FCommand);
  inherited;
end;

procedure TSLabel.SetCommand(const Value: TSCommand);
begin
  FCommand := Value;
end;

{ TSLetter }

procedure TSLetter.SetInstance(const Value: TEItem);
begin
  FInstance := Value;
end;

procedure TSLetter.SetIsLocal(const Value: Boolean);
begin
  FIsLocal := Value;
end;

procedure TSLetter.SetName(const Value: string);
begin
  FName := Value;
end;

{ TSReturn }

procedure TSReturn.Proc2Rec2;
begin
  // SKIP
end;

{ TSTrue }

procedure TSTrue.Proc2Rec2;
begin
  Jumps.Assign(Sig);
  inherited;
end;

{ TSFalse }

procedure TSFalse.Proc2Rec2;
begin
  Jumps.Assign(Fi);
  inherited;
end;

{ TSScip }

procedure TSSkip.Proc2Rec2;
begin
  Jumps.Assign(Sig);
  inherited;
end;

{ TMondatNode }

function ListToStr(L: TList): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to L.Count - 1 do
    Result := Result + ' ' + TEItem(L[I]).Name;
end;

function ListToStr2(L: TList): string;
var
  I: Integer;
begin
  if L.Count = 0 then
    Result := '{ }'
  else
  begin
    Result := '{ ' + TEItem(L[0]).Name;
    for I := 1 to L.Count - 1 do
      Result := Result + ', ' + TEItem(L[I]).Name;
    Result := Result + ' }';
  end;
end;

function ListToStr2(L: TStringList): string; overload;
var
  I: Integer;
begin
  if L.Count = 0 then
    Result := '{ }'
  else
  begin
    Result := '{ ' + L.Strings[0];
    for I := 1 to L.Count - 1 do
      Result := Result + ', ' + L.Strings[I];
    Result := Result + ' }';
  end;
end;

function ChoiceInt(N: integer; M: TFindMode): integer;
begin
  if N <= 0 then
    Result := -1
  else
    case M of
      fmFirst:  Result := 0;
      fmRandom: Result := Random(N);
      fmLast:   Result := N - 1;
    else
      Result := -1;
    end;
end;

function ChoiceList(L: TList; M: TFindMode): TObject;
begin
  if L.Count = 0 then
    Result := nil
  else
    case M of
      fmFirst:  Result := L.First;
      fmRandom: Result := L[Random(L.Count)];
      fmLast:   Result := L.Last;
    else
      Result := nil;
    end;
end;

function TConfig.Add(C: TConfig): TConfig;
begin
  C.FParent := Self;
  FChildren.Add(C);
  C.FRoot := FRoot;
  Result := C;
end;

constructor TConfig.Create(P: TConfig; L: TEBasLine);
begin
  FChildren := TList.Create;
  FLine := L;
  FParent := P;
  if P = nil then
    FRoot := Self
  else
    FRoot := P.FRoot;
end;

destructor TConfig.Destroy;
var
  I: Integer;
begin
  for I := 0 to FChildren.Count - 1 do
    TObject(FChildren[I]).Free;
  FChildren.Free;
//  FRule.Free;
  inherited;
end;

procedure TConfig.DetachAndFree;
begin
  if FParent <> nil then
    FParent.Items.Remove(Self);
//  Free;
end;

procedure TConfig.DrawTreeNode(C: TCanvas; Left, Top: Integer; Color: TColor);
begin

end;

function TConfig.GetLangString: WideString;
begin
  Result := '';
end;

function TConfig.GetListView: TTntListView;
begin
  Result := TTntListView(FRoot.Node);
end;

function TConfig.GetNode: TObject;
begin
  Result := FNode;
end;

function TConfig.GetProgram: TEProgram;
begin
  if FRoot = nil then
    Result := nil
  else
    Result := TEStart(FRoot.Line).FEProgram;
end;

function TConfig.GetTreeString: WideString;
begin
  Result := '';
end;

function TConfig.GetTreeView: TTntTreeView;
begin
  if Parent.Line is TEStart then
    Result := TTntTreeView(Parent.Node)
  else
    Result := TTntTreeView(TTntTreeNode(Parent.Node).TreeView);
end;

function TConfig.IsLast: Boolean;
begin
  Result := Items.Count = 0;
end;

function TConfig.IsTerminal: Boolean;
begin
  Result := false;
end;

function TConfig.Line: TEBasLine;
begin
  Result := FLine;
end;


function TConfig.MakeLangNode(TV: TObject): TObject;
var
  S: WideString;
  V: TTntListItems;
begin
  Result := MakeNode(TV);
  if Result <> nil then
    exit;

  if (TV = nil) then
    if FParent = nil then
      raise Exception.Create('invalid parameters!')
    else
      TV := TTntListItem(FParent.Node).ListView;

  S := GetLangString;
  V := TTntListView(TV).Items;
  if TTntListView(TV).FindCaption(0, S, false, false, false) = nil then
  begin
    if (V.Count > 0) and (V[0].Caption = S) then
      exit;
    Result := TTntListView(TV).Items.Add;
    TTntListItem(Result).Caption := S;
    FNode := Result;
  end;
end;

function TConfig.MakeListNode(TV: TObject): TObject;
begin
  Result := MakeNode(TV);
  if Result <> nil then
    exit;

  if (TV = nil) then
    TV := GetListView;

  if (Line is TEStart) then
    Result := nil
  else
  begin
    Result := TTntListView(TV).Items.Add;
    TTntListItem(Result).Data := Self;
    FNode := Result;
  end;
end;

function TConfig.MakeListNodeCond(TV: TObject = nil): TObject;
begin
  if IsLast or (Line.Visible) then
    Result := MakeListNode(TV)
end;

{* Létrehoz egy bejegyzést a ListView-be az adott confighoz *}
function TConfig.MakeNode(TV: TObject): TObject;
begin
  if (FLine is TEStart) and (TV <> nil) then
  begin
    Result := nil;
    FNode := TV;
  end
  else if FNode <> nil then
    Result := FNode
  else
    Result := nil;
end;

function TConfig.MakeTreeNode(TV: TObject): TObject;
begin
  Result := MakeNode(TV);
  if Result <> nil then
    exit;

  if Line is TEStart then
    Result := nil
  else
  begin
    if (FParent = nil) or (FParent.Line is TEStart) then
    begin
      if TV = nil then
        TV := GetTreeView;
      if TV = nil then
        raise Exception.Create('invalid parameters!')
      else
        Result := MakeTreeNode2(TTntTreeView(TV), Self, GetTreeString)
    end
    else
      Result := MakeTreeNode3(TTntTreeNode(FParent.Node), Self, GetTreeString, true);
    FNode := Result;
  end;
end;

function TConfig.Parent: TConfig;
begin
  Result := FParent;
end;

procedure TConfig.RunLang(D: Integer);
begin

end;

procedure TConfig.RunList(D: Integer);

  procedure RunRec(C: TConfig; D: Integer);
  var
    I: Integer;
  begin
    with C do
    begin
      if (D <= 0) or {Sentence.}IsTerminal then
        exit;

      if Runed then
      begin
        if (Items.Count > 0) then
          RunRec(TConfig(Items[0]), D - 1);
      end
      else
      begin
        MakeChildren;
        Runed := true;
        if Items.Count > 0 then
          RunRec(TConfig(Items[0]), D - 1);
      end;
    end;
  end;

  procedure MakeNodes;
  var
    C, D: TConfig;
    TV: TTntListView;
  begin
    C := Self;
    while C.Items.Count > 0 do
    begin
      D := TGConfig(C.Items[0]);
      D.MakeListNodeCond;
      C := D;
    end;
  end;

begin
  RunRec(Self, D);
  MakeNodes;
end;

procedure TConfig.RunTree(D: Integer);
var
  I: Integer;
begin
  if (D <= 0) or IsTerminal then
    exit;

  if FRuned then
  begin
    for I := 0 to FChildren.Count - 1 do
    begin
      TConfig(FChildren[I]).MakeTreeNode;
      TConfig(FChildren[I]).RunTree(D - 1);
    end;
  end
  else
  begin
    MakeChildren;
    FRuned := true;
    if FChildren.Count > 0 then
    begin
      for I := 0 to FChildren.Count - 1 do
      begin
        TConfig(FChildren[I]).MakeTreeNode;
        TConfig(FChildren[I]).RunTree(D - 1);
      end;
    end;
  end;
end;

procedure TConfig.SetChildren(const Value: TList);
begin
  FChildren.Free;//?
  FChildren := Value;
end;

procedure TConfig.SetLine(L: TEBasLine);
begin
  FLine := L;
end;

procedure TConfig.SetNode(const Value: TObject);
begin
  FNode := Value;
end;

procedure TConfig.SetRuned(const Value: Boolean);
begin
  FRuned := Value;
end;

{ TMondat }

procedure TESentence.Add(L: TELetter);
begin
  FLetters.Add(L);
end;

procedure TESentence.Add(S: TESentence);
var
  I: Integer;
begin
  for I := 0 to S.Count - 1 do
    FLetters.Add(S[I]);
end;

procedure TESentence.Assign(Source: TESentence);
begin
  FLetters.Assign(Source.Items);
end;

procedure TESentence.Assign(Source: TList);
begin
  FLetters.Assign(Source);
end;

{* N: szám, L.Count: számrendszer alapja *}
procedure TESentence.AssignFromArray(A: array of Integer; N: Integer; L: TList);
var
  I: Integer;
begin
  FLetters.Clear;
  for I := 0 to N - 1 do
    FLetters.Add(L[A[I]]);
end;

procedure TESentence.AssignFromInt(N: LongInt; L: TList);
//var
//  I, M: LongInt;
begin
//  FLetters.Clear;
//  if N >= 0 then
//  begin
//    M := L.Count;
////    I := (N mod (M + 1)) - 1;
////    N := N div (M + 1);
////    if I = -1 then
////      I := 0;
//////    if I >= 0 then
////    FLetters.Add(L[I]);
//
//    while (N <> 0) do
//    begin
//      I := N mod M;
//      N := N div M;
//      if N = 0 then
//        I := N mod (M + 1);
//      FLetters.Add(L[I]);
//
//    end;
//  end;
end;

constructor TESentence.Create;
begin
  inherited Create;
  FFirst := -1;
  FLast := -1;
  FLetters := TList.Create;
end;

destructor TESentence.Destroy;
begin
  FLetters.Free;
  inherited;
end;

procedure TESentence.Draw(C: TCanvas; Left, Top: Integer; Color: TColor);
var
  S1, S2, S3: WideString;
  X: Integer;
  Col: TColor;
begin
  S2 := ToString(GUSpace, First, Last);
  if (First = -1) or (S2 = '') then
  begin
    S1 := ToString(GUSpace);
    S3 := '';
  end
  else
  begin
    S1 := ToString(GUSpace, 0, First - 1);
    S3 := ToString(GUSpace, Last + 1, Count - 1);
  end;
  
  if Count = 0 then
    S1 := eps;
  Col := C.Font.Color;
  C.Brush.Style := bsClear;
  WideCanvasTextOut(C, Left, Top, S1);
  C.Font.Color := Color;
  X := WideCanvasTextExtent(C, S1).cx;
  WideCanvasTextOut(C, Left + X, Top, S2);
  X := X + WideCanvasTextExtent(C, S2).cx;
  C.Font.Color := Col;
  WideCanvasTextOut(C, Left + X, Top, S3);
end;

function TESentence.Equal(S: TESentence): Boolean;
var
  I: Integer;
begin
  if FLetters.Count <> S.FLetters.Count then
  begin
    Result := false;
    exit;
  end;
  Result := true;
  for I := 0 to FLetters.Count - 1 do
    if FLetters[I] <> S.FLetters[I] then
    begin
      Result := false;
      exit;
    end;
end;

function TESentence.Find(L: TESentence; M: TFindMode; K: Integer): integer;
var
  C: integer;
  T: intarray;
  I: Integer;
  J: Integer;
  B: Boolean;
begin
  case M of
    fmFirst: Result := Find(0, L);
    fmRandom:
      begin
        C := FindAll(L, T);
        if C = 0 then
          Result := -1
        else
          Result := T[Random(C)];
      end;
    fmLast:
      begin
        Result := -1;
        for I := Count - L.Count downto 0 do
        begin
          B := true;
          for J := 0 to L.Count - 1 do
            if FLetters[I + J] <> L[J] then
            begin
              B := false;
              break;
            end;
          if B then
          begin
            Result := I;
            exit;
          end;
        end;
      end;

    fmAll:
      begin
        C := FindAll(L, T);
        if C = 0 then
          Result := -1
        else
          Result := T[K];
      end;
  end;
end;

function TESentence.FindAll(L: TESentence; var T: intarray): integer;
var
  I: Integer;
  J: Integer;
  B: Boolean;
begin
  Result := 0;
  setlength(T, Count);
  for I := 0 to Count - L.Count do
  begin
    B := true;
    for J := 0 to L.Count - 1 do
      if L[J] <> FLetters[I + J] then
      begin
        B := false;
        break;
      end;
    if B then
    begin
      T[Result] := I;
      inc(Result);
    end;
  end;
end;

constructor TESentence.Create(T: array of TELetter);
var
  I: Integer;
begin
  inherited Create;
  FFirst := -1;
  FLast := -1;
  FLetters := TList.Create;
  for I := 0 to length(T) - 1 do
    FLetters.Add(T[I]);
end;

{* a K-tõl M-ig helyére kell berakni S-et *}
procedure TESentence.Insert(K, M: Integer; S: TESentence);
var
  L: TList;
  I: Integer;
begin
  if (S.Count = 1) then
  begin
    if S[0].Name = eps then
      for I := M downto K do
        FLetters.Delete(I)
    else
    begin
      for I := M downto K + 1 do
        FLetters.Delete(I);
      FLetters[K] := S[0];
    end;
  end
  else
  begin
    L := TList.Create;
    L.Count := FLetters.Count - (M - K + 1) + S.Count;
    for I := 0 to K - 1 do
      L[I] := FLetters[I];
    for I := 0 to S.Count - 1 do
      L[K + I] := S[I];
    for I := M + 1 to FLetters.Count - 1 do
      L[I + L.Count - FLetters.Count] := FLetters[I];

    FLetters.Free;
    FLetters := L;
  end;
end;

function TESentence.IsEps: Boolean;
begin
  Result := (Count = 0)
    or (Count = 1) and (Letters[0].Name = eps);
end;

function TESentence.IsTerminal: boolean;
var
  I: Integer;
begin
  Result := true;
  for I := 0 to Count - 1 do
    Result := Result and (Self[I] is TETerm);
end;

function TESentence.Items: TList;
begin
  Result := FLetters;
end;

function TESentence.Len(UseSpace: Boolean): Integer;
begin
  Result := length(ToString(UseSpace));
end;

procedure TESentence.Next;
begin
  
end;

procedure TESentence.Pop;
begin
  if FLetters.Count > 0 then
    FLetters.Delete(0);
end;

procedure TESentence.Push(S: TESentence);
var
  L: TList;
  I: Integer;
begin
  L := TList.Create;
  L.Assign(S.FLetters);
  for I := 0 to FLetters.Count - 1 do
    L.Add(FLetters[I]);
  FLetters.Assign(L);
  L.Free;
end;

function TESentence.CharPos(LetterPos: Integer; UseSpace: Boolean): Integer;
var
  I: Integer;
begin
  Result := 1;
  for I := 0 to LetterPos - 1 do
    Result := Result + length(Letters[I].Name) + ord(UseSpace);
end;

function TESentence.Clone: TESentence;
begin
  Result := TESentence.Create;
  Result.Assign(Self);
end;

function TESentence.Count: integer;
begin
  Result := FLetters.Count;
end;

constructor TESentence.Create(L: TList);
begin
  inherited Create;
  FFirst := -1;
  FLast := -1;
  FLetters := TList.Create;
  FLetters.Assign(L);
end;

function TESentence.Find(K: Integer; L: TESentence): integer;
var
  I: Integer;
  J: Integer;
  B: Boolean;
begin
  for I := K to Count - L.Count do
  begin
    B := true;
    for J := 0 to L.Count - 1 do
      if L[J] <> FLetters[I + J] then
      begin
        B := false;
        break;
      end;
    if B then
    begin
      Result := I;
      exit;
    end;
  end;
  Result := -1;
end;

function TESentence.GetChild(index: integer): TELetter;
begin
  Result := TELetter(FLetters[index]);
end;

procedure TESentence.SetChild(index: integer; const Value: TELetter);
begin
  FLetters[index] := Value;
end;

procedure TESentence.SetFirst(const Value: Integer);
begin
  FFirst := Value;
end;

procedure TESentence.SetLast(const Value: Integer);
begin
  FLast := Value;
end;

function TESentence.ToAnsiString: String;
var
  I: Integer;
begin
  Result := '';
  if Count > 0 then
    for I := 0 to Count - 1 do
      if Self[I].Name = eps then
        Result := Result + ' eps'
      else
        Result := Result + ' ' + Self[I].Name
  else
    Result := 'eps';
end;

function TESentence.ToTapeString: WideString;
var
  I: Integer;
begin
  Result := '';
  if Count > 0 then
    for I := 0 to Count - 1 do
      if Self[I].Name = eps then
        Result := Result + eps
      else if Self[I].Name = '_' then
        // skip
      else
        Result := Result + Self[I].Name
  else
    Result := eps;
end;

function TESentence.TopItem: TELetter;
begin
  if FLetters.Count > 0 then
    Result := TELetter(FLetters.First)
  else
    Result := nil;
end;

function TESentence.ToString(UseSpace: Boolean = true): WideString;
var
  I: Integer;
begin
  Result := '';
  if UseSpace then
    if Count > 0 then
      for I := 0 to Count - 1 do
        Result := Result + ' ' + Self[I].Name
    else
      Result := eps
  else
    if Count > 0 then
      for I := 0 to Count - 1 do
        Result := Result + Self[I].Name
    else
      Result := eps
end;

procedure TESentence.Write(I: Integer; L: TELetter);
begin
  if L.Name = eps then
    // Skip
  else if (I < 0) then
    Items.Insert(0, L)
  else if (I >= Items.Count) then
    Items.Insert(Items.Count, L)
  else
    Items[I] := L;
end;

function TESentence.ToString(UseSpace: Boolean; First, Last: Integer): WideString;
var
  I: Integer;
  X: Integer;
begin
  if (First = -1) or (Last > Count -1) then
  begin
    Result := '';
    exit;
  end;

  if (Last = -1) then
    X := Count - 1;

  if UseSpace then
    if First <= Last then
      for I := First to Last do
        Result := Result + ' ' + Self[I].Name
    else
      Result := ''
  else
    if First <= Last then
      for I := First to Last do
        Result := Result + Self[I].Name
    else
      Result := ''
end;

{ TProgram }

function TEProgram.AddRule(L: TEBasLine; S: String = ''): TEBasLine;
begin
  GCall.FLines.Add(L);
  AddName(L, S);
  Result := L;
end;

function TEProgram.AddRule3(L: TEBasLine): TEBasLine;
begin
  GCall.FLines.Add(L);
  Result := L;
end;

procedure TEProgram.Build(C: TECall);
begin
  FFirst := TEStart.Create;
  FFirst.FEProgram := Self;
  FLines.Add(FFirst);
  FMain := C;
  FLines.Add(C);
  C.Expand(Self);
  C.Resolve;
  FFirst.FRo.Assign(C.FStarts);
  FStarts.Assign(C.FStarts);
end;

function TEProgram.CanRead(L: TELetter): Boolean;
begin
  Result := true;
end;

function TEProgram.CanStep(L: TELetter): Boolean;
begin
  Result := true;
end;

function TEProgram.Count: Integer;
begin
  Result := FLines.Count;
end;

constructor TEProgram.Create;
begin
  FInput := TESentence.Create;
  FStarts := TList.Create;
  FLines := TList.Create; // !!mlist
  FNames := TStringList.Create;
  FNames.Sorted := true;
  FNames.CaseSensitive := true;
  FExit := TEExit.Create;
  AddName(FExit, 'exit');
end;

destructor TEProgram.Destroy;
var
  I: Integer;
begin
  for I := 0 to FNames.Count - 1 do
    if not ((FNames.Objects[I] is TELine) or (FNames.Objects[I] is TEBlank)) then
      FNames.Objects[I].Free;
  for I := 0 to FLines.Count - 1 do
    TObject(FLines[I]).Free;

  FInput.Free;
  FExit.Free;
  FNames.Free;
  FLines.Free;
  FStarts.Free;

  FStartTree.Free;
  FStartList.Free;
  FStartLang.Free;
  inherited;
end;

function TEProgram.GetLines(index: integer): TEBasLine;
begin
  Result := TEBasLine(FLines[index]);
end;

procedure TEProgram.GetNTerms(L: TStringList);
var
  I: Integer;
begin
  for I := 0 to FNames.Count - 1 do
    if TObject(FNames.Objects[I]) is TENTerm then
      L.AddObject(FNames[I], FNames.Objects[I]);
end;

procedure TEProgram.GetTerms(L: TStringList);
var
  I: Integer;
begin
  for I := 0 to FNames.Count - 1 do
    if TObject(FNames.Objects[I]) is TETerm then
      L.AddObject(FNames[I], FNames.Objects[I]);
end;

function TEProgram.IsEmpty: Boolean;
begin
  Result := FLines.Count = 0;
end;

procedure TEProgram.RunLang;
begin
  FLangCalled := true;
end;

function TEProgram.AddCall(L: TEBasLine): TEBasLine;
begin
  GCall.FLines.Add(L);
  Result := L;
end;

function TEProgram.AddName(I: TEItem; S: string = ''): string;
var
  N: Integer;

  function NameExists(S: String): Boolean;
  begin
    Result := FNames.IndexOf(S) >= 0;
  end;

  function NewName: string;
  begin
    if I is TELine then
    begin Result := S + IntToStr(FNewLineCount); inc(FNewLineCount); end
    else
    begin Result := S + IntToStr(N); inc(N); end
  end;

begin
  N := 1;
  if S = '' then
  begin
    if I is TELine then
      S := ''
    else
      S := '_';
    Result := NewName;
  end
  else
    Result := S;

  while NameExists(Result) do
    Result := NewName;

  I.Name := Result;
  FNames.AddObject(Result, I);
end;

procedure TEProgram.Select(V: TViewType);
begin
  FSProgram.Select(V);
  case V of
    vtList:
    begin
      if FRunFrm is TRunFrm then
      begin
        ListView := TRunFrm(FRunFrm).lvList;
        TRunFrm(FRunFrm).SelectAnItem;
      end;
    end;
    vtTree:
    begin
      GLog := nil;
      if FRunFrm is TRunFrm then
        TreeView := TRunFrm(FRunFrm).TreeView1;
    end;
    vtSet:
    begin
      GLog := nil;
      if FRunFrm is TRunFrm then
        ListView := TRunFrm(FRunFrm).lvLang;
      if not FLAngCalled then
        RunLang;
    end;
  end;
end;

procedure TEProgram.SetInput(const Value: TESentence);
begin
  FInput := Value;
end;

procedure TEProgram.SetLines(index: integer; const Value: TEBasLine);
begin
  FLines.Insert(index, Value);
end;

function TEProgram.SProgram: TSProgram;
begin
  Result := FSProgram;
end;

function TEProgram.ToStringList: TStringList;
var
  I: Integer;
begin
  Result := TStringList.Create;
  for I := 0 to Count - 1 do
    Result.Add(Self[I].ToAnsiString);
end;

{ TECall }

constructor TECall.Create;
begin
  inherited Create;
  FLines := TList.Create; //!!mlist
  FStarts := TList.Create;
end;

destructor TECall.Destroy;
begin
  FLines.Free;
  FPara.Free;
  FStarts.Free;
  inherited;
end;

procedure TECall.Expand;
var
  L: TList;
  I: Integer;
  OCall: TECall;
  M: TList;
  C: TSJump;

  procedure Resolve(L: TList);
    procedure f(X: TObject);
    var
      I: Integer;
    begin
      if X is TELine then
        M.Add(X)
      else if X is TSLine then
        M.Add(TSLine(X).Instance)
      else if X is TSJump then
      begin
        C := TSJump(X);
        for I := 0 to C.Jumps.Count - 1 do
          f(C.Jumps[I]);
      end;
    end;
  var
    I: Integer;

  begin
    M := TList.Create;
    for I := 0 to L.Count - 1 do
      f(L[I]);
    L.Assign(M);
    M.Free;
  end;

begin
  OCall := GCall;
  GCall := Self;
  {* aktuális paraméterek megfeleltetése a formálisaknak *}
  L := Funct.Params;
  for I := 0 to L.Count - 1 do
    TSLetter(L[I]).Instance := TEItem(FPara[I]);

  Funct.Sig := Sig;
  Funct.Fi := Fi;
  Funct.Build(EP, FShowCount);

  FStarts.Assign(Funct.FJumps);
  {* minden TELine-ra mutasson *}
  Resolve(FStarts);
  GCall := OCall;
end;

function TECall.GetLines: TList;
begin
  Result := FLines;
end;

function TECall.IsLetter: Boolean;
begin
  Result := false;
end;

procedure TECall.ResolveA;
var
  I: Integer;
begin
  for I := 0 to FLines.Count - 1 do
    TELine(FLines[I]).Resolve;
  ResolveList(FStarts);
  ResolveList(FRo);
  ResolveList(FFi);
end;

procedure TECall.SetFunct(const Value: TSFunction);
begin
  FFunct := Value;
end;

procedure TECall.SetPara(const Value: TList);
begin
  FPara.Free; //?
  FPara := Value;
end;

function TECall.ToAnsiString: string;
var
  I: Integer;
begin
  Result := 'call ' + Funct.Name + '()' + #13#10;
  for I := 0 to FLines.Count - 1 do
    Result := Result + TELine(FLines[I]).ToAnsiString + #13#10;
  Result := Result  + 'return ' + Funct.Name + '()';
end;

{ TELine }

constructor TELine.Create;
begin
  inherited;
  FRo := TList.Create;
  FFi := TList.Create;
end;

destructor TELine.Destroy;
begin
  FRo.Free;
  FFi.Free;
  inherited;
end;

procedure TELine.Resolve;
begin
  if FState = lsProcessing then
//    raise Exception.Create('Cyclic label reference!')
  else if FState = lsUnprocessed then
  begin
    FState := lsProcessing;
    ResolveA;
    FState := lsProcessed;
  end;
end;

procedure TELine.ResolveA;
begin
  ResolveList(FRo);
  ResolveList(FFi);
end;

class procedure TELine.ResolveList(L: TList);
var
  I, J: Integer;
  M: TList;
  C: TELine;
begin
  M := TList.Create;
  for I := 0 to L.Count - 1 do
  begin
    if TELine(L[I]).IsLetter then
      M.Add(L[I])
    else if TObject(L[I]) is TECall then
    begin
      TECall(L[I]).Resolve;
      for J := 0 to TECall(L[I]).FStarts.Count - 1 do
      begin
        C := TECall(L[I]).FStarts[J];
        M.Add(C);
      end;
    end;
  end;
  L.Assign(M);
  M.Free;
end;

procedure TELine.SetFi(const Value: TList);
begin
  FFi.Free; //?
  FFi := Value;
end;

procedure TELine.SetRo(const Value: TList);
begin
  FRo.Free; //?
  FRo := Value;
end;

{ TEExit }

function TEExit.IsLetter: Boolean;
begin
  Result := true;
end;

procedure TEExit.ResolveA;
begin
  // SKIP
end;

{ TETreeNode }

function Spaces(L: Integer): String;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to L - 1 do
    Result := Result + ' ';
end;

function SpacesPixel(S: WideString; C: TCanvas): String;
var
  I, N: Integer;
  W: Integer;
begin
  W := WideCanvasTextWidth(C, S);
  N := W div WideCanvasTextWidth(C, ' ') + 1;
  Result := '';
  for I := 0 to N - 1 do
    Result := Result + ' ';
end;

function MakeTreeNode3(P: TTntTreeNode; C: TConfig; S: WideString; B: boolean = false): TTntTreeNode;
var
  I: TTntTreeNodes;
  CA: TCanvas;
begin
  CA := P.TreeView.Canvas;
  I := TTntTreeView(P.TreeView).Items;
  Result := TTntTreeNode.Create(I);
  if B then
    I.AddNode(Result, P, SpacesPixel(S, CA), nil, naAddChild)
  else
    I.AddNode(Result, P, SpacesPixel(S, CA), nil, naAdd);
  Result.Data := C;
end;

function MakeTreeNode2(TV: TTntTreeView; C: TConfig; S: WideString): TTntTreeNode;
var
  N: TTntTreeNode;
begin
  Result := TTntTreeNode.Create(TV.Items);
  N := TV.Items.AddChild(nil, 'The Root');
  TV.Items.AddNode(Result, N, SpacesPixel(S, TV.Canvas), nil, naAdd);
  N.Delete;
  Result.Data := C;
end;

{ TCMatrix }

constructor TCMatrix.Create;
begin
  Rows := TList.Create;
  Cols := TList.Create;
end;

destructor TCMatrix.Destroy;
begin
  Rows.Free;
  Cols.Free;
  inherited;
end;

{ TLangThread }

function TEThread.Expired: Boolean;
begin
  Result := (ListView.Items.Count >= GDbLimit);
end;

constructor TEThread.Create;
begin
  inherited Create(true);
  FTimer := TTimer.Create(nil);
  FTimer.Interval := 100;
  FTimer.OnTimer := StepProgress;
  FProgress := CreateComObject(CLSID_ProgressDialog) as IProgressDialog;
end;

destructor TEThread.Destroy;
begin
  FTimer.Free;
  FTimer.Free;
  inherited;
end;

procedure TEThread.Execute;
var
  i: Integer;
  ow: IOleWindow;
  pdHandle: HWND;
  F: TFormatSettings;
begin
  MainForm.Enabled := false;
  try
    ListView.SortType := stNone;
    FTimer.Enabled := true;

    with FProgress do
    begin
      SetTitle('Dolgozom...');
      StartProgressDialog(MainForm.Handle, nil, PROGDLG_MODAL, nil);

      if QueryInterface(IID_IOleWindow, ow) = S_OK then
      begin
        ow.GetWindow(pdHandle);
        SetWindowPos(pdHandle, 0, 20, 20, 0, 0, SWP_NOZORDER or SWP_NOSIZE);
      end;
      F.CurrencyDecimals := 2;
      SetLine(1, PWideChar(WideString('Generating language...')), False, nil);
      SetLine(2, PWideChar(WideString('Time limit: ' + FloatToStr(GTimeLimit / 1000, F) + ' sec')), False, nil);
    end;

    RunConfig;

    FTimer.Enabled := false;

    FProgress.SetProgress(100, 100);
    FProgress.StopProgressDialog;
    ListView.SortType := stBoth;
    if ListView.Items.Count = 0 then
      ListView.Items.Add.Caption := 'No item found. This language may be empty.';
  finally
    MainForm.Enabled := true;
//    MainForm.Show;
//    MainForm.Focused := true;
  end;
end;

procedure TEThread.GetResults;
begin
  Config.MakeLangNode(ListView);
  if Expired then
    Terminate;
end;

procedure TEThread.StepProgress(Sender: TObject);
begin
  FCompl := FCompl + FTimer.Interval;
  FProgress.SetProgress(FCompl, GTimeLimit);
  if (FCompl >= GTimeLimit) or FProgress.HasUserCancelled then
    Terminate;
end;

procedure TEThread.Terminate3(Sender: TObject);
begin
  FProgress.SetProgress(100, 100);
  Terminate;
end;

function TEThread.Terminated2: Boolean;
begin
  Result := Terminated;
end;

{ TEBasLine }

constructor TEBasLine.Create;
begin
  FShowCount := 1;
end;

function TEBasLine.IsLetter: Boolean;
begin
  Result := true;
end;

function TEBasLine.IsPrint: Boolean;
begin
  Result := false;
end;

procedure TEBasLine.SetSLine(const Value: TSLine);
begin
  if FSLine = nil then
    FSLine := Value;
end;

function TEBasLine.ToAnsiString: string;
begin
  Result := FName;
end;

function TEBasLine.ToString(UseSpace: Boolean = false): WideString;
begin
  Result := FName;
end;

function TEBasLine.Visible: Boolean;
begin
  Result := FShowCount > 0;
end;

{ TSEps }

procedure TSEps.Build(EP: TEProgram);
begin
  FInstance := TETerm.Create;
  Inc(FInstanceCount);
  EP.AddName(FInstance, FName);
  EP.FEps := TELetter(FInstance);
end;

{ TSBlank }

procedure TSBlank.Build(EP: TEProgram);
begin
  if EP is TETuring then
  begin
    FInstance := Blank;// TENTerm.Create;
    Inc(FInstanceCount);
    EP.AddName(FInstance, FName);
  end;
end;

{ TSAccept }

procedure TSAccept.Build(EP: TEProgram);
begin
  if EP is TETuring then
    FInstance := TETuring(EP).Accept;
end;

{ TSFork }

procedure TSFork.Proc1;
begin
  Self[0].Sig.Assign(Sig);
  Self[0].Fi.Assign(Fi);
  Self[1].Sig.Assign(Sig);
  Self[1].Fi.Assign(Fi);
  inherited;
end;

procedure TSFork.Proc2Rec2;
begin
  Jumps.Add(Self[0]);
  Jumps.Add(Self[1]);
  inherited;
end;

{ TSForkBlock }

procedure TSForkBlock.Proc1;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    with Self[I] do
    begin
      Sig.Assign(Self.Sig);
      Fi.Assign(Self.Fi);
    end;
  for I := 0 to Count - 1 do
    AddJump(Self[I]);
  inherited;
end;

{ TEStart }

procedure TEStart.SetEProgram(const Value: TEProgram);
begin
  FEProgram := Value;
end;

{ TSStart }

procedure TSStart.Build;
begin
  inherited;
  EP.FStart := TENTerm(Instance);
end;

function Lighter(Color: TColor; Percent: byte): TColor;
var
  r, g, b: byte;
begin
  Color  := ColorToRGB(Color);
  r      := GetRValue(Color);
  g      := GetGValue(Color);
  b      := GetBValue(Color);
  r      := r + muldiv(255 - r, Percent, 100); //Percent% closer to white
  g      := g + muldiv(255 - g, Percent, 100);
  b      := b + muldiv(255 - b, Percent, 100);
  Result := RGB(r, g, b);
end;

initialization
  Default := TSProgram.Create;
  Default.Options := Default.Options + [poShowColors];
  LogF := TStringList.Create;
  Blank := TEBlank.Create;
  GSPrint := TSPrint.Create;
  GEPrint := TEPrint.Create;
  GEPrint.Name := 'print';
  GSPrint.FInstance := GEPrint;
  SelectedColor :=  Lighter( clSkyBlue, 60);

  colaccept := RGB(0, 255, 0);
  colselect := RGB(255, 0, 0); // Lighter(clPurple, 50);
  colexit := RGB(255, 0, 0);

end.
