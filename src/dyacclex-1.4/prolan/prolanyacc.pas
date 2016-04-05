// source: C:\Users\Gazda\Documents\RAD Studio\Projects\szakdoli\src\dyacclex-1.4\src\yacc\yyparse.cod line# 1

{***************************** INTERFACE BEGIN | yyparse.cod *******************************}

{***************************** INTERFACE END | yyparse.cod *******************************}



{***************************** INTERFACE BEGIN | prolan.y *******************************}

{$N+,F+}

Unit ProLanYacc;

Interface

Uses
	SysUtils,
	Dlib,
	LexLib2,
	YaccLib,
	Classes,
	YaccBase,
	UBase,
	UGrammar,
	UTuring,
	UPushDown,
	Contnrs,
	StrUtils;
	
type
	TLexer = class(TLexerParserBase)
	public
		FErrorMsg: String;
		function Parse(): integer; override;
	end;
  
	TParser = class
	private
		GFunc: TSFunction;
		GTable: TSTable;
		GShow: Integer;
		GPrintMode: Boolean;
		procedure PushTable(T: TSTable = nil); overload;
		procedure PopTable;
		function Declare(N: string; T: TClass; B: Boolean): TObject; overload;
		procedure merror(C: Integer; msg: string);
		function CurLine: Integer;
	public
		ferror: Boolean;
		GProgram: TSProgram;
		Lexer: TLexer;
		FFileName: String;
		FLine: Integer;
		FMessage: String;
		FECode: Integer;
		function Parse(InputText: TStringList): integer;
		constructor Create;
		destructor Destroy; override;
	end;	
	
Implementation

var
	Node: TSNode;

procedure TParser.merror(C: Integer; msg: string);
begin
	FMessage := msg;
	FECode := C;
	if yylineno > FLine then
		FLine := yylineno - FLine;
	ferror := true;
	yyabort;
end;
	
procedure nlist(var L: TList; I: Pointer);
begin
	L := TList.Create;
	if I <> nil then
		L.Add(I);
end;

procedure alist(var L: TList; L2: TList; I: Pointer);
begin
	L := L2;
	if I <> nil then
		L.Add(I);
end;

function TParser.Declare(N: string; T: TClass; B: Boolean): TObject;
begin
	Result := GTable.Declare(N, T, B);
	if Result = nil then
		merror(2, N);
end;

procedure TParser.PushTable(T: TSTable = nil);
begin
	if T = nil then
		T := TSTable.Create;
	T.Parent := GTable;
	GTable := T;
end;

procedure TParser.PopTable;
begin
	GTable := GTable.Parent;
	if GTable = nil then
		raise Exception.Create('Table Error!');
end;

function TParser.CurLine: Integer;
begin
	Result := yylineno - FLine;
end;

constructor TParser.Create;
begin
	Lexer := TLexer.Create;
end;

destructor TParser.Destroy;
begin
	Lexer.Free;
	inherited;
end;


{***************************** INTERFACE END | prolan.y *******************************}	

const IDENT = 257;
const _END = 258;
const _LETTER = 259;
const _TERM = 260;
const _NTERM = 261;
const _VOID = 262;
const _BOOL = 263;
const _START = 264;
const _STRING = 265;
const _FALSE = 266;
const _TRUE = 267;
const _RETURN = 268;
const _EXIT = 269;
const _ACCEPT = 270;
const _ELSE = 271;
const _GOTO = 272;
const _IF = 273;
const _WHILE = 274;
const _TRY = 275;
const _AND = 276;
const _AND2 = 277;
const _OR = 278;
const _FORK = 279;
const _NOT = 280;
const _STAR = 281;
const _EQUAL = 282;
const _ALL = 283;
const _EPSILON = 284;
const _BLANK = 285;
const _NEXT = 286;
const _SOME = 287;
const _RIGHT = 288;
const _LEFT = 289;
const _STAND = 290;
const _PRINT = 291;
const _INPUT = 292;
const _STATE = 293;
const _PRAGMA = 294;
const _TURING = 295;
const _GRAMMAR = 296;
const _PGRAMMAR = 297;
const _PUSHDOWN = 298;
const _EPUSHDOWN = 299;
const _LINDENMAYER = 300;
const _RULE = 301;
const _POSITION = 302;
const _FIRST = 303;
const _LAST = 304;
const _RANDOM = 305;
const _HIDE = 306;
const _SHOW = 307;
const _DETERM = 308;
const _DEADEND = 309;
const _COLOR = 310;
const _LIST = 311;
const _TREE = 312;
const _LANG = 313;
const _LEFTMOST = 314;
const _RIGHTMOST = 315;
const _PRINTMODE = 316;
const NUMBER = 317;
const IFX = 318;
const _COMBLOCK = 319;
const _EXPBLOCK = 320;
const COMX = 321;
const _MINUS = 322;

// If you have defined your own YYSType then put an empty  %union { } in
// your .y file. Or you can put your type definition within the curly braces.
type YYSType = record
                 yyTClass : TClass;
                 yyTFindMode : TFindMode;
                 yyTList : TList;
                 yyTObject : TObject;
                 yyTSBlock : TSBlock;
                 yyTSCommand : TSCommand;
                 yyTSFuncType : TSFuncType;
                 yyTSFunction : TSFunction;
                 yyTSGoto : TSGoto;
                 yyTSIf : TSIf;
                 yyTSLabel : TSLabel;
                 yyTSLetter : TSLetter;
                 yyTSLine : TSLine;
                 yyTSNode : TSNode;
                 yyTSProgram : TSProgram;
                 yyTSwitch : TSwitch;
                 yyTViewType : TViewType;
                 yyinteger : integer;
                 yyshortString : shortString;
               end(*YYSType*);
// source: C:\Users\Gazda\Documents\RAD Studio\Projects\szakdoli\src\dyacclex-1.4\src\yacc\yyparse.cod line# 7

{***************************** IMPLEMENTATION BEGIN | yyparse.cod *******************************}

var 
	yylval : YYSType;
	
function TParser.parse(InputText: TStringList) : integer;

var 
  yystate, yysp, yyn : Integer;
  yys : array [1..yymaxdepth] of Integer;
  yyv : array [1..yymaxdepth] of YYSType;
  yyval : YYSType;

procedure yyaction ( yyruleno : Integer );
  (* local definitions: *)

{***************************** RULES BEGIN | prolan.y *******************************}
// source: C:\Users\Gazda\Documents\RAD Studio\Projects\szakdoli\src\dyacclex-1.4\src\yacc\yyparse.cod line# 24
begin
  (* actions: *)
  case yyruleno of
1 : begin
         // source: prolan.y line#203
         
         				GTable := GProgram.Table;
         				GShow := 1;
         			
       end;
2 : begin
         yyval := yyv[yysp-1];
       end;
3 : begin
         yyval := yyv[yysp-1];
       end;
4 : begin
         yyval := yyv[yysp-0];
       end;
5 : begin
         yyval := yyv[yysp-0];
       end;
6 : begin
         yyval := yyv[yysp-2];
       end;
7 : begin
         yyval := yyv[yysp-1];
       end;
8 : begin
         yyval := yyv[yysp-1];
       end;
9 : begin
         // source: prolan.y line#215
         merror(1, '')
       end;
10 : begin
         // source: prolan.y line#218
         FLine := yylineno
       end;
11 : begin
         // source: prolan.y line#218
         FLine := FLine - StrToInt(yyv[yysp-1].yyshortString) + 1; FFileName := yyv[yysp-0].yyshortString; 
       end;
12 : begin
         // source: prolan.y line#221
         yyval.yyTViewType := vtList; 
       end;
13 : begin
         // source: prolan.y line#222
         yyval.yyTViewType := vtTree; 
       end;
14 : begin
         // source: prolan.y line#223
         yyval.yyTViewType := vtSet; 
       end;
15 : begin
         // source: prolan.y line#226
         yyval.yyTFindMode := fmFirst; 
       end;
16 : begin
         // source: prolan.y line#227
         yyval.yyTFindMode := fmLast; 
       end;
17 : begin
         // source: prolan.y line#228
         yyval.yyTFindMode := fmALL; 
       end;
18 : begin
         // source: prolan.y line#229
         yyval.yyTFindMode := fmRandom; 
       end;
19 : begin
         // source: prolan.y line#232
         yyval.yyTSwitch := swColors; 
       end;
20 : begin
         // source: prolan.y line#233
         yyval.yyTSwitch := swDeterm; 
       end;
21 : begin
         // source: prolan.y line#234
         yyval.yyTSwitch := swDeadend; 
       end;
22 : begin
         // source: prolan.y line#235
         yyval.yyTSwitch := swAll; 
       end;
23 : begin
         yyval := yyv[yysp-0];
       end;
24 : begin
         yyval := yyv[yysp-1];
       end;
25 : begin
         yyval := yyv[yysp-0];
       end;
26 : begin
         // source: prolan.y line#243
         GProgram.ProgType := ptGrammar; 
       end;
27 : begin
         // source: prolan.y line#245
         
         				GProgram.ProgType := ptGrammar; 
         				GProgram.Show(false, swDeadEnd);
         			
       end;
28 : begin
         // source: prolan.y line#249
         GProgram.ProgType := ptTuring; 
       end;
29 : begin
         // source: prolan.y line#250
         GProgram.ProgType := ptPushDown; 
       end;
30 : begin
         // source: prolan.y line#251
         GProgram.ProgType := ptEPushDown; 
       end;
31 : begin
         // source: prolan.y line#253
         
         				GProgram.ProgType := ptGrammar; 
         				// GShow := 0;
         				// GPRintMode := true;
         				GProgram.Show(false, swDeterm);
         				GProgram.Show(false, swColors);
         				GProgram.Choice[vtList, ctPos] := fmFirst;
         				GProgram.Choice[vtSet, ctPos] := fmFirst;
         				GProgram.Choice[vtTree, ctPos] := fmFirst;
         			
       end;
32 : begin
         // source: prolan.y line#263
         GProgram.Choice[yyv[yysp-3].yyTViewType, ctPos] := yyv[yysp-1].yyTFindMode; 
       end;
33 : begin
         // source: prolan.y line#264
         GProgram.Choice[yyv[yysp-3].yyTViewType, ctRule] := yyv[yysp-1].yyTFindMode; 
       end;
34 : begin
         // source: prolan.y line#265
         if yyv[yysp-1].yyTSwitch = swAll then GShow := 0 else GProgram.Show(false, yyv[yysp-1].yyTSwitch); 
       end;
35 : begin
         // source: prolan.y line#266
         if yyv[yysp-1].yyTSwitch = swAll then GShow := 1 else GProgram.Show(true, yyv[yysp-1].yyTSwitch); 
       end;
36 : begin
         // source: prolan.y line#268
         
         				GProgram.Choice[vtList, ctPos] := fmFirst;
         				GProgram.Choice[vtSet,  ctPos] := fmFirst;
         				GProgram.Choice[vtTree, ctPos] := fmFirst;
         			
       end;
37 : begin
         // source: prolan.y line#274
         
         				GProgram.Choice[vtList, ctPos] := fmLast;
         				GProgram.Choice[vtSet,  ctPos] := fmLast;
         				GProgram.Choice[vtTree, ctPos] := fmLast;
         			
       end;
38 : begin
         // source: prolan.y line#279
         GPRintMode := true; GShow := 0; 
       end;
39 : begin
         // source: prolan.y line#283
         
         				yyval.yyTObject := GTable.Find(yyv[yysp-0].yyshortString);
         				if yyval.yyTObject = nil then
         					merror(3, yyv[yysp-0].yyshortString);
         			
       end;
40 : begin
         // source: prolan.y line#291
         
         				yyval.yyTSLetter := TSLetter(GTable.Find(yyv[yysp-0].yyshortString, TSLetter));
         				if yyval.yyTSLetter = nil then
         					merror(4, yyv[yysp-0].yyshortString);
         			
       end;
41 : begin
         // source: prolan.y line#297
         
         				yyval.yyTSLetter := TSLetter(GTable.Find('eps', TSLetter));
         				if yyval.yyTSLetter = nil then
         					merror(5, 'eps');
         			
       end;
42 : begin
         // source: prolan.y line#302
         yyval.yyTSLetter := TSLetter(GTable.Find('_')); 
       end;
43 : begin
         // source: prolan.y line#306
         
         				yyval.yyTSLabel := TSLabel(GTable.Find(yyv[yysp-0].yyshortString, TSLabel));
         				if yyval.yyTSLabel = nil then
         					yyval.yyTSLabel := TSLabel(Declare(yyv[yysp-0].yyshortString, TSLabel, false));
         			
       end;
44 : begin
         // source: prolan.y line#312
         
         				yyval.yyTSLabel := TSLabel(GTable.Find('exit', TSLabel)); 
         			
       end;
45 : begin
         // source: prolan.y line#316
         
         				yyval.yyTSLabel := TSLabel(GTable.Find('accept', TSLabel)); 
         			
       end;
46 : begin
         // source: prolan.y line#322
         
         				yyval.yyTSFunction := TSFunction(GTable.Find(yyv[yysp-0].yyshortString, TSFunction));
         				if yyval.yyTSFunction = nil then
         					merror(6, yyv[yysp-0].yyshortString);
         			
       end;
47 : begin
         // source: prolan.y line#329
         yyval.yyTSFuncType := ftVoid; 
       end;
48 : begin
         // source: prolan.y line#330
         yyval.yyTSFuncType := ftBool; 
       end;
49 : begin
         // source: prolan.y line#333
         yyval.yyTList := TList.Create; 
       end;
50 : begin
         yyval := yyv[yysp-0];
       end;
51 : begin
         // source: prolan.y line#338
         
         				yyval.yyTSFunction := TSFunction(Declare(yyv[yysp-0].yyshortString, TSFunction, false));
         				yyval.yyTSFunction.FuncType := yyv[yysp-1].yyTSFuncType;
         				GFunc := yyval.yyTSFunction;
         				PushTable;
         				GTable.IsFuncTable := true;
         			
       end;
52 : begin
         // source: prolan.y line#346
         
         				if GFunc <> nil then
         				begin
         					GProgram.Add(GFunc);
         					GFunc.Params := yyv[yysp-1].yyTList;
         					yyv[yysp-1].yyTList.Free;
         				end;
         			
       end;
53 : begin
         // source: prolan.y line#355
         
         				GFunc.Add(yyv[yysp-0].yyTSBlock);
         				yyv[yysp-0].yyTSBlock.Table := GTable;
         				PopTable;
         			
       end;
54 : begin
         // source: prolan.y line#364
         
         				yyval.yyTSBlock := TSSeqBlock.Create;
         				yyval.yyTSBlock.Table := GTable;
         				yyval.yyTSBlock.Add(TSSkip.Create);
         			
       end;
55 : begin
         // source: prolan.y line#371
         
         				yyval.yyTSBlock := TSParBlock.Create;
         				yyval.yyTSBlock.Table := GTable;
         				yyval.yyTSBlock.Add(TSSkip.Create);
         			
       end;
56 : begin
         // source: prolan.y line#378
         
         				yyval.yyTSBlock := TSForkBlock.Create;
         				yyval.yyTSBlock.Table := GTable;
         				yyval.yyTSBlock.Add(TSSkip.Create);
         			
       end;
57 : begin
         // source: prolan.y line#385
         
         				yyval.yyTSBlock := TSSeqBlock.Create; 
         				yyval.yyTSBlock.AssignChildren(yyv[yysp-1].yyTList);
         				yyv[yysp-1].yyTList.Free;
         				yyval.yyTSBlock.Table := GTable;
         			
       end;
58 : begin
         // source: prolan.y line#392
         
         				yyval.yyTSBlock := TSParBlock.Create;
         				yyval.yyTSBlock.AssignChildren(yyv[yysp-1].yyTList);
         				yyv[yysp-1].yyTList.Free;
         				yyval.yyTSBlock.Table := GTable;
         			
       end;
59 : begin
         // source: prolan.y line#399
         
         				yyval.yyTSBlock := TSForkBlock.Create;
         				yyval.yyTSBlock.AssignChildren(yyv[yysp-1].yyTList);
         				yyv[yysp-1].yyTList.Free;
         				yyval.yyTSBlock.Table := GTable;
         			
       end;
60 : begin
         // source: prolan.y line#407
         nlist(yyval.yyTList, yyv[yysp-0].yyTSCommand); 
       end;
61 : begin
         // source: prolan.y line#408
         alist(yyval.yyTList, yyv[yysp-1].yyTList, yyv[yysp-0].yyTSCommand); 
       end;
62 : begin
         // source: prolan.y line#409
         merror(7, ''); 
       end;
63 : begin
         // source: prolan.y line#412
         nlist(yyval.yyTList, yyv[yysp-0].yyTSLabel); 
       end;
64 : begin
         // source: prolan.y line#413
         alist(yyval.yyTList, yyv[yysp-2].yyTList, yyv[yysp-0].yyTSLabel); 
       end;
65 : begin
         // source: prolan.y line#416
         yyval.yyTClass := TSTerm; 
       end;
66 : begin
         // source: prolan.y line#417
         yyval.yyTClass := TSNTerm; 
       end;
67 : begin
         // source: prolan.y line#418
         yyval.yyTClass := TSStart; 
       end;
68 : begin
         // source: prolan.y line#419
         yyval.yyTClass := TSLetter; 
       end;
69 : begin
         // source: prolan.y line#420
         yyval.yyTClass := TSLabel; 
       end;
70 : begin
         // source: prolan.y line#424
         
         				yyval.yyTClass := yyv[yysp-1].yyTClass;
         				Declare(yyv[yysp-0].yyshortString, yyv[yysp-1].yyTClass, true);
         			
       end;
71 : begin
         // source: prolan.y line#429
         
         				yyval.yyTClass := yyv[yysp-2].yyTClass;
         				Declare(yyv[yysp-0].yyshortString, yyv[yysp-2].yyTClass, true);
         			
       end;
72 : begin
         // source: prolan.y line#435
         nlist(yyval.yyTList, yyv[yysp-0].yyTObject); 
       end;
73 : begin
         // source: prolan.y line#436
         alist(yyval.yyTList, yyv[yysp-2].yyTList, yyv[yysp-0].yyTObject); 
       end;
74 : begin
         // source: prolan.y line#439
         yyval.yyTObject := Declare(yyv[yysp-0].yyshortString, yyv[yysp-1].yyTClass, false); 
       end;
75 : begin
         // source: prolan.y line#442
         nlist(yyval.yyTList, yyv[yysp-0].yyTSLetter); 
       end;
76 : begin
         // source: prolan.y line#443
         alist(yyval.yyTList, yyv[yysp-1].yyTList, yyv[yysp-0].yyTSLetter); 
       end;
77 : begin
         // source: prolan.y line#446
         yyval.yyTList := TList.Create; 
       end;
78 : begin
         // source: prolan.y line#447
         nlist(yyval.yyTList, yyv[yysp-0].yyTObject); 
       end;
79 : begin
         // source: prolan.y line#448
         alist(yyval.yyTList, yyv[yysp-2].yyTList, yyv[yysp-0].yyTObject); 
       end;
80 : begin
         // source: prolan.y line#452
         
         				if (yyv[yysp-3].yyTSFunction <> nil) and (yyv[yysp-1].yyTList <> nil) then
         					if yyv[yysp-3].yyTSFunction.CheckPara(yyv[yysp-1].yyTList) then
         					begin
         						yyval.yyTSLine := TSCall.Create(yyv[yysp-3].yyTSFunction, yyv[yysp-1].yyTList);
         						yyval.yyTSLine.LineInfo(CurLine, FFileName);
         						yyv[yysp-1].yyTList.Free;
         					end
         					else
         						merror(8, yyv[yysp-3].yyTSFunction.Name);
         			
       end;
81 : begin
         // source: prolan.y line#465
         yyval.yyTSCommand := yyv[yysp-1].yyTSCommand; 
       end;
82 : begin
         // source: prolan.y line#466
         yyval.yyTSCommand := yyv[yysp-0].yyTSNode; 
       end;
83 : begin
         // source: prolan.y line#467
         yyval.yyTSCommand := TSTrue.Create; 
       end;
84 : begin
         // source: prolan.y line#468
         yyval.yyTSCommand := TSFalse.Create; 
       end;
85 : begin
         // source: prolan.y line#469
         GProgram.Input.Assign(yyv[yysp-1].yyTList); yyv[yysp-1].yyTList.Free; 
       end;
86 : begin
         // source: prolan.y line#470
         yyval.yyTSCommand := yyv[yysp-0].yyTSLine; 
       end;
87 : begin
         // source: prolan.y line#472
         
         				if GPrintMode then
         				begin
         					yyval.yyTSCommand := TSIf.Create; 
         					case GProgram.ProgType of
         						ptGrammar: 
         							TSGRule(TSIf(yyval.yyTSCommand).Add(TSGRule.MakePrint)).LineInfo(CurLine, FFileName);
         						ptPushDown, ptEPushDown: 
         							TSSLine(TSIf(yyval.yyTSCommand).Add(TSSLine.MakePrint)).LineInfo(CurLine, FFileName);
         						ptTuring:
         							TSTLine(TSIf(yyval.yyTSCommand).Add(TSTLine.MakePrint)).LineInfo(CurLine, FFileName);
         					end;
         					TSIf(yyval.yyTSCommand).Add(TSSkip.Create);
         				end
         				else
         					yyval.yyTSCommand := TSSkip.Create;
         			
       end;
88 : begin
         // source: prolan.y line#490
         yyval.yyTSCommand := yyv[yysp-1].yyTSCommand; 
       end;
89 : begin
         // source: prolan.y line#500
         yyval.yyTSLine := yyv[yysp-0].yyTSLine; 
       end;
90 : begin
         // source: prolan.y line#501
         yyval.yyTSLine := TSBLine.Create(nil, tdRight); yyval.yyTSLine.LineInfo(CurLine, FFileName, GShow); 
       end;
91 : begin
         // source: prolan.y line#502
         yyval.yyTSLine := TSBLine.Create(yyv[yysp-1].yyTSLetter, tdRight); yyval.yyTSLine.LineInfo(CurLine, FFileName, GShow); 
       end;
92 : begin
         // source: prolan.y line#503
         yyval.yyTSLine := TSBLine.Create(nil, tdLeft); yyval.yyTSLine.LineInfo(CurLine, FFileName, GShow); 
       end;
93 : begin
         // source: prolan.y line#504
         yyval.yyTSLine := TSBLine.Create(yyv[yysp-1].yyTSLetter, tdLeft); yyval.yyTSLine.LineInfo(CurLine, FFileName, GShow); 
       end;
94 : begin
         // source: prolan.y line#505
         yyval.yyTSLine := TSBLine.Create(nil, tdStand); yyval.yyTSLine.LineInfo(CurLine, FFileName, GShow); 
       end;
95 : begin
         // source: prolan.y line#506
         yyval.yyTSLine := TSBLine.Create(yyv[yysp-1].yyTSLetter, tdStand); yyval.yyTSLine.LineInfo(CurLine, FFileName, GShow); 
       end;
96 : begin
         // source: prolan.y line#508
         
         				if GProgram.ProgType = ptGrammar then
         				begin
         					yyval.yyTSLine := TSGRule.Create(yyv[yysp-2].yyTList, yyv[yysp-0].yyTList); yyv[yysp-2].yyTList.Free; yyv[yysp-0].yyTList.Free;
         					yyval.yyTSLine.LineInfo(CurLine, FFileName, GShow);
         				end
         				else if GProgram.ProgType in [ptPushDown, ptEPushDown] then 
         				begin
         					yyval.yyTSLine := TSSLine.Create(yyv[yysp-2].yyTList, yyv[yysp-0].yyTList); yyv[yysp-2].yyTList.Free; yyv[yysp-0].yyTList.Free;
         					yyval.yyTSLine.LineInfo(CurLine, FFileName, GShow);
         				end;
         			
       end;
97 : begin
         // source: prolan.y line#522
         yyval.yyTSCommand := yyv[yysp-0].yyTSCommand; 
       end;
98 : begin
         // source: prolan.y line#523
         yyval.yyTSCommand := TSALine.Create(yyv[yysp-0].yyTSLetter); yyval.yyTSCommand.LineInfo(CurLine, FFileName, GShow); 
       end;
99 : begin
         // source: prolan.y line#526
         yyval.yyTSNode := TSAnd.Create; yyval.yyTSNode.Add(yyv[yysp-2].yyTSCommand); yyval.yyTSNode.Add(yyv[yysp-0].yyTSCommand); 
       end;
100 : begin
         // source: prolan.y line#527
         yyval.yyTSNode := TSSeqBlock.Create; yyval.yyTSNode.Add(yyv[yysp-2].yyTSCommand); yyval.yyTSNode.Add(yyv[yysp-0].yyTSCommand); yyval.yyTSNode.Add(TSSkip.Create); 
       end;
101 : begin
         // source: prolan.y line#528
         	yyval.yyTSNode := TSOr.Create; yyval.yyTSNode.Add(yyv[yysp-2].yyTSCommand); yyval.yyTSNode.Add(yyv[yysp-0].yyTSCommand); 
       end;
102 : begin
         // source: prolan.y line#529
         yyval.yyTSNode := TSNot.Create; yyval.yyTSNode.Add(yyv[yysp-0].yyTSCommand); 
       end;
103 : begin
         // source: prolan.y line#530
         yyval.yyTSNode := TSFork.Create; yyval.yyTSNode.Add(yyv[yysp-2].yyTSCommand); yyval.yyTSNode.Add(yyv[yysp-0].yyTSCommand); 
       end;
104 : begin
         // source: prolan.y line#531
         
         				Node := TSFork.Create; Node.Add(yyv[yysp-1].yyTSCommand); Node.Add(TSFalse.Create);
         				yyval.yyTSNode := TSWhile.Create; yyval.yyTSNode.Add(Node); yyval.yyTSNode.Add(TSSkip.Create); 
         			
       end;
105 : begin
         // source: prolan.y line#535
         
         				yyval.yyTSNode := TSAnd.Create; TSAnd(yyval.yyTSNode).Add(yyv[yysp-1].yyTSCommand); TSAnd(yyval.yyTSNode).Add(TSBLine.Create(nil, tdRight));
         				TSAnd(yyval.yyTSNode)[1].LineInfo(CurLine, FFileName, GShow);
         			
       end;
106 : begin
         // source: prolan.y line#539
         	
         				Node := TSAnd.Create; Node.Add(yyv[yysp-2].yyTSCommand); Node.Add(TSBLine.Create(nil, tdRight)); Node[1].LineInfo(CurLine, FFileName, GShow);
         				yyval.yyTSNode := TSSeqBlock.Create; yyval.yyTSNode.Add(Node); yyval.yyTSNode.Add(yyv[yysp-0].yyTSCommand); yyval.yyTSNode.Add(TSSkip.Create);
         			
       end;
107 : begin
         yyval := yyv[yysp-0];
       end;
108 : begin
         // source: prolan.y line#547
         
         				PushTable; 
         				if GFunc <> nil then
         					GFunc.AddTable(GTable);
         			
       end;
109 : begin
         // source: prolan.y line#551
         PopTable; yyval.yyTSCommand := yyv[yysp-0].yyTSBlock; 
       end;
110 : begin
         // source: prolan.y line#552
         yyval.yyTSCommand := yyv[yysp-1].yyTSCommand; 
       end;
111 : begin
         // source: prolan.y line#553
         yyval.yyTSCommand := nil; 
       end;
112 : begin
         // source: prolan.y line#554
         yyval.yyTSCommand := yyv[yysp-0].yyTSNode; 
       end;
113 : begin
         // source: prolan.y line#555
         yyval.yyTSCommand := yyv[yysp-1].yyTSGoto; 
       end;
114 : begin
         // source: prolan.y line#556
         yyval.yyTSCommand := yyv[yysp-0].yyTSCommand; yyval.yyTSCommand.Lab := yyv[yysp-2].yyTSLabel; yyv[yysp-2].yyTSLabel.Command := yyval.yyTSCommand;	
       end;
115 : begin
         // source: prolan.y line#557
         yyval.yyTSCommand := TSSkip.Create; yyval.yyTSCommand.Lab := yyv[yysp-2].yyTSLabel; yyv[yysp-2].yyTSLabel.Command := yyval.yyTSCommand;	
       end;
116 : begin
         // source: prolan.y line#558
         yyval.yyTSCommand := yyv[yysp-0].yyTSIf; 
       end;
117 : begin
         // source: prolan.y line#559
         merror(7, ''); 
       end;
118 : begin
         // source: prolan.y line#560
         yyval.yyTSCommand := TSSkip.Create; 
       end;
119 : begin
         // source: prolan.y line#561
         
         				Node := TSFork.Create; Node.Add(TSSeqBlock.Create); Node.Add(TSFalse.Create); 
         				yyval.yyTSCommand := TSWhile.Create; TSWhile(yyval.yyTSCommand).Add(Node); TSWhile(yyval.yyTSCommand).Add(TSSkip.Create); 
         				Node := TSSeqBlock(Node[0]); Node.Add(yyv[yysp-0].yyTSCommand); Node.Add(TSSkip.Create);
         			
       end;
120 : begin
         // source: prolan.y line#568
         yyval.yyTSIf := TSIf.Create; yyval.yyTSIf.Add(yyv[yysp-3].yyTSCommand); yyval.yyTSIf.Add(yyv[yysp-1].yyTSCommand); yyval.yyTSIf.Add(yyv[yysp-0].yyTSIf); 
       end;
121 : begin
         // source: prolan.y line#569
         yyval.yyTSIf := TSIf.Create; yyval.yyTSIf.Add(yyv[yysp-3].yyTSCommand); yyval.yyTSIf.Add(yyv[yysp-1].yyTSCommand); yyval.yyTSIf.Add(TSFalse.Create); 
       end;
122 : begin
         // source: prolan.y line#570
         yyval.yyTSIf := TSIf.Create; yyval.yyTSIf.Add(yyv[yysp-5].yyTSCommand); yyval.yyTSIf.Add(yyv[yysp-3].yyTSCommand); yyval.yyTSIf.Add(yyv[yysp-1].yyTSCommand); 
       end;
123 : begin
         // source: prolan.y line#573
         yyval.yyTSIf := yyv[yysp-0].yyTSIf; 
       end;
124 : begin
         // source: prolan.y line#574
         yyval.yyTSIf := TSIf.Create; yyval.yyTSIf.Add(TSTrue.Create); yyval.yyTSIf.Add(TSFalse.Create); 
       end;
125 : begin
         // source: prolan.y line#577
         yyval.yyTSGoto := TSGoto.Create(yyv[yysp-0].yyTList); yyval.yyTSGoto.LineInfo(CurLine, FFileName); yyv[yysp-0].yyTList.Free; 
       end;
126 : begin
         // source: prolan.y line#578
         yyval.yyTSGoto := TSGoto.Create(yyv[yysp-0].yyTList); yyval.yyTSGoto.LineInfo(CurLine, FFileName); yyv[yysp-0].yyTList.Free; 
       end;
127 : begin
         // source: prolan.y line#580
         
         				if GFunc.FuncType = ftVoid then
         					begin yyval.yyTSGoto := TSGoto.Create; yyval.yyTSGoto.LineInfo(CurLine, FFileName); yyval.yyTSGoto.Labels.Add(GFunc.OutTrue); end
         				else
         					merror(9, '');	
         			
       end;
128 : begin
         // source: prolan.y line#588
         
         				yyval.yyTSNode := TSIf.Create; yyval.yyTSNode.Add(yyv[yysp-2].yyTSCommand); yyval.yyTSNode.Add(yyv[yysp-0].yyTSCommand);
         			
       end;
129 : begin
         // source: prolan.y line#591
         
         				yyval.yyTSNode := TSIf.Create; yyval.yyTSNode.Add(yyv[yysp-4].yyTSCommand); yyval.yyTSNode.Add(yyv[yysp-2].yyTSCommand); yyval.yyTSNode.Add(yyv[yysp-0].yyTSCommand);
         			
       end;
130 : begin
         // source: prolan.y line#594
         
         				yyval.yyTSNode := TSWhile.Create; yyval.yyTSNode.Add(yyv[yysp-2].yyTSCommand); yyval.yyTSNode.Add(yyv[yysp-0].yyTSCommand);
         			
       end;
131 : begin
         // source: prolan.y line#597
         
         				yyval.yyTSNode := TSWhile.Create; yyval.yyTSNode.Add(yyv[yysp-0].yyTSCommand); yyval.yyTSNode.Add(TSSkip.Create);
         			
       end;
132 : begin
         // source: prolan.y line#600
         yyval.yyTSNode := TSIf.Create; yyval.yyTSNode.Add(yyv[yysp-1].yyTSCommand); yyval.yyTSNode.Add(TSSkip.Create); 
       end;
133 : begin
         // source: prolan.y line#601
         
         				if GFunc.FuncType = ftBool then
         				begin
         					yyval.yyTSNode := TSIf.Create; yyval.yyTSNode.Add(yyv[yysp-1].yyTSCommand); yyval.yyTSNode.Add(GFunc.OutTrue); yyval.yyTSNode.Add(GFunc.OutFalse);
         				end
         				else
         					merror(9, '');	
         			
       end;
// source: C:\Users\Gazda\Documents\RAD Studio\Projects\szakdoli\src\dyacclex-1.4\src\yacc\yyparse.cod line# 28
  end;
end(*yyaction*);

(* parse table: *)

type YYARec = record
                sym, act : Integer;
              end;
     YYRRec = record
                len, sym : Integer;
              end;

const

yynacts   = 1091;
yyngotos  = 510;
yynstates = 224;
yynrules  = 133;
yymaxtoken = 322;

yya : array [1..yynacts] of YYARec = (
{ 0: }
{ 1: }
  ( sym: 256; act: 13 ),
  ( sym: 259; act: 14 ),
  ( sym: 260; act: 15 ),
  ( sym: 261; act: 16 ),
  ( sym: 262; act: 17 ),
  ( sym: 263; act: 18 ),
  ( sym: 264; act: 19 ),
  ( sym: 294; act: 20 ),
  ( sym: 35; act: -10 ),
{ 2: }
  ( sym: 0; act: 0 ),
{ 3: }
{ 4: }
{ 5: }
  ( sym: 35; act: 21 ),
{ 6: }
  ( sym: 257; act: 22 ),
  ( sym: 0; act: -25 ),
  ( sym: 35; act: -25 ),
  ( sym: 256; act: -25 ),
  ( sym: 259; act: -25 ),
  ( sym: 260; act: -25 ),
  ( sym: 261; act: -25 ),
  ( sym: 262; act: -25 ),
  ( sym: 263; act: -25 ),
  ( sym: 264; act: -25 ),
  ( sym: 294; act: -25 ),
{ 7: }
  ( sym: 256; act: 13 ),
  ( sym: 259; act: 14 ),
  ( sym: 260; act: 15 ),
  ( sym: 261; act: 16 ),
  ( sym: 262; act: 17 ),
  ( sym: 263; act: 18 ),
  ( sym: 264; act: 19 ),
  ( sym: 294; act: 20 ),
  ( sym: 0; act: -4 ),
  ( sym: 35; act: -10 ),
{ 8: }
{ 9: }
  ( sym: 44; act: 25 ),
  ( sym: 258; act: 26 ),
{ 10: }
  ( sym: 257; act: 27 ),
{ 11: }
  ( sym: 257; act: 28 ),
{ 12: }
  ( sym: 256; act: 13 ),
  ( sym: 259; act: 14 ),
  ( sym: 260; act: 15 ),
  ( sym: 261; act: 16 ),
  ( sym: 262; act: 17 ),
  ( sym: 263; act: 18 ),
  ( sym: 264; act: 19 ),
  ( sym: 294; act: 20 ),
  ( sym: 0; act: -5 ),
  ( sym: 35; act: -10 ),
{ 13: }
  ( sym: 256; act: 13 ),
  ( sym: 259; act: 14 ),
  ( sym: 260; act: 15 ),
  ( sym: 261; act: 16 ),
  ( sym: 262; act: 17 ),
  ( sym: 263; act: 18 ),
  ( sym: 264; act: 19 ),
  ( sym: 294; act: 20 ),
  ( sym: 35; act: -10 ),
{ 14: }
{ 15: }
{ 16: }
{ 17: }
{ 18: }
{ 19: }
{ 20: }
  ( sym: 295; act: 31 ),
  ( sym: 296; act: 32 ),
  ( sym: 297; act: 33 ),
  ( sym: 298; act: 34 ),
  ( sym: 299; act: 35 ),
  ( sym: 300; act: 36 ),
  ( sym: 301; act: 37 ),
  ( sym: 302; act: 38 ),
  ( sym: 306; act: 39 ),
  ( sym: 307; act: 40 ),
  ( sym: 314; act: 41 ),
  ( sym: 315; act: 42 ),
  ( sym: 316; act: 43 ),
{ 21: }
  ( sym: 257; act: 44 ),
{ 22: }
{ 23: }
{ 24: }
  ( sym: 256; act: 13 ),
  ( sym: 259; act: 14 ),
  ( sym: 260; act: 15 ),
  ( sym: 261; act: 16 ),
  ( sym: 262; act: 17 ),
  ( sym: 263; act: 18 ),
  ( sym: 264; act: 19 ),
  ( sym: 294; act: 20 ),
  ( sym: 0; act: -3 ),
  ( sym: 35; act: -10 ),
{ 25: }
  ( sym: 257; act: 46 ),
{ 26: }
{ 27: }
{ 28: }
{ 29: }
{ 30: }
{ 31: }
{ 32: }
{ 33: }
{ 34: }
{ 35: }
{ 36: }
{ 37: }
  ( sym: 40; act: 48 ),
{ 38: }
  ( sym: 40; act: 49 ),
{ 39: }
  ( sym: 40; act: 50 ),
{ 40: }
  ( sym: 40; act: 51 ),
{ 41: }
{ 42: }
{ 43: }
{ 44: }
  ( sym: 265; act: 52 ),
{ 45: }
{ 46: }
{ 47: }
  ( sym: 40; act: 53 ),
{ 48: }
  ( sym: 311; act: 55 ),
  ( sym: 312; act: 56 ),
  ( sym: 313; act: 57 ),
{ 49: }
  ( sym: 311; act: 55 ),
  ( sym: 312; act: 56 ),
  ( sym: 313; act: 57 ),
{ 50: }
  ( sym: 283; act: 60 ),
  ( sym: 308; act: 61 ),
  ( sym: 309; act: 62 ),
  ( sym: 310; act: 63 ),
{ 51: }
  ( sym: 283; act: 60 ),
  ( sym: 308; act: 61 ),
  ( sym: 309; act: 62 ),
  ( sym: 310; act: 63 ),
{ 52: }
{ 53: }
  ( sym: 259; act: 14 ),
  ( sym: 260; act: 15 ),
  ( sym: 261; act: 16 ),
  ( sym: 264; act: 19 ),
  ( sym: 41; act: -49 ),
{ 54: }
  ( sym: 44; act: 69 ),
{ 55: }
{ 56: }
{ 57: }
{ 58: }
  ( sym: 44; act: 70 ),
{ 59: }
  ( sym: 41; act: 71 ),
{ 60: }
{ 61: }
{ 62: }
{ 63: }
{ 64: }
  ( sym: 41; act: 72 ),
{ 65: }
  ( sym: 257; act: 73 ),
{ 66: }
  ( sym: 41; act: 74 ),
{ 67: }
  ( sym: 44; act: 75 ),
  ( sym: 41; act: -50 ),
{ 68: }
{ 69: }
  ( sym: 283; act: 77 ),
  ( sym: 288; act: 78 ),
  ( sym: 289; act: 79 ),
  ( sym: 305; act: 80 ),
{ 70: }
  ( sym: 283; act: 77 ),
  ( sym: 288; act: 78 ),
  ( sym: 289; act: 79 ),
  ( sym: 305; act: 80 ),
{ 71: }
{ 72: }
{ 73: }
{ 74: }
{ 75: }
  ( sym: 259; act: 14 ),
  ( sym: 260; act: 15 ),
  ( sym: 261; act: 16 ),
  ( sym: 264; act: 19 ),
{ 76: }
  ( sym: 41; act: 84 ),
{ 77: }
{ 78: }
{ 79: }
{ 80: }
{ 81: }
  ( sym: 41; act: 85 ),
{ 82: }
  ( sym: 60; act: 87 ),
  ( sym: 91; act: 88 ),
  ( sym: 123; act: 89 ),
{ 83: }
{ 84: }
{ 85: }
{ 86: }
{ 87: }
  ( sym: 40; act: 109 ),
  ( sym: 62; act: 110 ),
  ( sym: 256; act: 111 ),
  ( sym: 257; act: 112 ),
  ( sym: 259; act: 14 ),
  ( sym: 260; act: 15 ),
  ( sym: 261; act: 16 ),
  ( sym: 264; act: 19 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 268; act: 115 ),
  ( sym: 269; act: 116 ),
  ( sym: 270; act: 117 ),
  ( sym: 272; act: 118 ),
  ( sym: 273; act: 119 ),
  ( sym: 274; act: 120 ),
  ( sym: 275; act: 121 ),
  ( sym: 280; act: 122 ),
  ( sym: 283; act: 123 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 287; act: 126 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
  ( sym: 293; act: 132 ),
  ( sym: 294; act: 20 ),
  ( sym: 35; act: -10 ),
  ( sym: 60; act: -108 ),
  ( sym: 91; act: -108 ),
  ( sym: 123; act: -108 ),
{ 88: }
  ( sym: 40; act: 109 ),
  ( sym: 93; act: 134 ),
  ( sym: 256; act: 111 ),
  ( sym: 257; act: 112 ),
  ( sym: 259; act: 14 ),
  ( sym: 260; act: 15 ),
  ( sym: 261; act: 16 ),
  ( sym: 264; act: 19 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 268; act: 115 ),
  ( sym: 269; act: 116 ),
  ( sym: 270; act: 117 ),
  ( sym: 272; act: 118 ),
  ( sym: 273; act: 119 ),
  ( sym: 274; act: 120 ),
  ( sym: 275; act: 121 ),
  ( sym: 280; act: 122 ),
  ( sym: 283; act: 123 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 287; act: 126 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
  ( sym: 293; act: 132 ),
  ( sym: 294; act: 20 ),
  ( sym: 35; act: -10 ),
  ( sym: 60; act: -108 ),
  ( sym: 91; act: -108 ),
  ( sym: 123; act: -108 ),
{ 89: }
  ( sym: 40; act: 109 ),
  ( sym: 125; act: 136 ),
  ( sym: 256; act: 111 ),
  ( sym: 257; act: 112 ),
  ( sym: 259; act: 14 ),
  ( sym: 260; act: 15 ),
  ( sym: 261; act: 16 ),
  ( sym: 264; act: 19 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 268; act: 115 ),
  ( sym: 269; act: 116 ),
  ( sym: 270; act: 117 ),
  ( sym: 272; act: 118 ),
  ( sym: 273; act: 119 ),
  ( sym: 274; act: 120 ),
  ( sym: 275; act: 121 ),
  ( sym: 280; act: 122 ),
  ( sym: 283; act: 123 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 287; act: 126 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
  ( sym: 293; act: 132 ),
  ( sym: 294; act: 20 ),
  ( sym: 35; act: -10 ),
  ( sym: 60; act: -108 ),
  ( sym: 91; act: -108 ),
  ( sym: 123; act: -108 ),
{ 90: }
  ( sym: 60; act: 87 ),
  ( sym: 91; act: 88 ),
  ( sym: 123; act: 89 ),
{ 91: }
{ 92: }
{ 93: }
{ 94: }
{ 95: }
{ 96: }
  ( sym: 258; act: 26 ),
{ 97: }
{ 98: }
{ 99: }
  ( sym: 276; act: 139 ),
  ( sym: 277; act: 140 ),
  ( sym: 278; act: 141 ),
  ( sym: 279; act: 142 ),
  ( sym: 281; act: 143 ),
  ( sym: 322; act: 144 ),
{ 100: }
  ( sym: 258; act: 145 ),
  ( sym: 41; act: -97 ),
  ( sym: 276; act: -97 ),
  ( sym: 277; act: -97 ),
  ( sym: 278; act: -97 ),
  ( sym: 279; act: -97 ),
  ( sym: 281; act: -97 ),
  ( sym: 322; act: -97 ),
{ 101: }
{ 102: }
  ( sym: 44; act: 25 ),
  ( sym: 258; act: 26 ),
{ 103: }
  ( sym: 40; act: 147 ),
{ 104: }
  ( sym: 44; act: 148 ),
  ( sym: 258; act: -125 ),
{ 105: }
  ( sym: 40; act: 109 ),
  ( sym: 62; act: 150 ),
  ( sym: 256; act: 151 ),
  ( sym: 257; act: 112 ),
  ( sym: 259; act: 14 ),
  ( sym: 260; act: 15 ),
  ( sym: 261; act: 16 ),
  ( sym: 264; act: 19 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 268; act: 115 ),
  ( sym: 269; act: 116 ),
  ( sym: 270; act: 117 ),
  ( sym: 272; act: 118 ),
  ( sym: 273; act: 119 ),
  ( sym: 274; act: 120 ),
  ( sym: 275; act: 121 ),
  ( sym: 280; act: 122 ),
  ( sym: 283; act: 123 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 287; act: 126 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
  ( sym: 293; act: 132 ),
  ( sym: 294; act: 20 ),
  ( sym: 35; act: -10 ),
  ( sym: 60; act: -108 ),
  ( sym: 91; act: -108 ),
  ( sym: 123; act: -108 ),
{ 106: }
  ( sym: 61; act: 153 ),
  ( sym: 257; act: 154 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
{ 107: }
  ( sym: 61; act: -75 ),
  ( sym: 257; act: -75 ),
  ( sym: 284; act: -75 ),
  ( sym: 285; act: -75 ),
  ( sym: 41; act: -98 ),
  ( sym: 58; act: -98 ),
  ( sym: 258; act: -98 ),
  ( sym: 276; act: -98 ),
  ( sym: 277; act: -98 ),
  ( sym: 278; act: -98 ),
  ( sym: 279; act: -98 ),
  ( sym: 281; act: -98 ),
  ( sym: 322; act: -98 ),
{ 108: }
  ( sym: 58; act: 155 ),
  ( sym: 44; act: -63 ),
  ( sym: 258; act: -63 ),
{ 109: }
  ( sym: 40; act: 109 ),
  ( sym: 256; act: 111 ),
  ( sym: 257; act: 112 ),
  ( sym: 259; act: 14 ),
  ( sym: 260; act: 15 ),
  ( sym: 261; act: 16 ),
  ( sym: 264; act: 19 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 268; act: 115 ),
  ( sym: 269; act: 116 ),
  ( sym: 270; act: 117 ),
  ( sym: 272; act: 118 ),
  ( sym: 273; act: 119 ),
  ( sym: 274; act: 120 ),
  ( sym: 275; act: 121 ),
  ( sym: 280; act: 122 ),
  ( sym: 283; act: 123 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 287; act: 126 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
  ( sym: 293; act: 132 ),
  ( sym: 294; act: 20 ),
  ( sym: 35; act: -10 ),
  ( sym: 60; act: -108 ),
  ( sym: 91; act: -108 ),
  ( sym: 123; act: -108 ),
{ 110: }
{ 111: }
  ( sym: 258; act: 26 ),
{ 112: }
  ( sym: 41; act: -40 ),
  ( sym: 61; act: -40 ),
  ( sym: 257; act: -40 ),
  ( sym: 276; act: -40 ),
  ( sym: 277; act: -40 ),
  ( sym: 278; act: -40 ),
  ( sym: 279; act: -40 ),
  ( sym: 281; act: -40 ),
  ( sym: 284; act: -40 ),
  ( sym: 285; act: -40 ),
  ( sym: 322; act: -40 ),
  ( sym: 44; act: -43 ),
  ( sym: 58; act: -43 ),
  ( sym: 258; act: -43 ),
  ( sym: 40; act: -46 ),
{ 113: }
{ 114: }
{ 115: }
  ( sym: 40; act: 109 ),
  ( sym: 257; act: 161 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 280; act: 122 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
  ( sym: 258; act: -127 ),
{ 116: }
{ 117: }
{ 118: }
  ( sym: 257; act: 164 ),
  ( sym: 269; act: 116 ),
  ( sym: 270; act: 117 ),
{ 119: }
  ( sym: 40; act: 165 ),
{ 120: }
  ( sym: 40; act: 166 ),
{ 121: }
  ( sym: 40; act: 109 ),
  ( sym: 257; act: 161 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 280; act: 122 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
{ 122: }
  ( sym: 40; act: 109 ),
  ( sym: 257; act: 161 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 280; act: 122 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
{ 123: }
  ( sym: 40; act: 109 ),
  ( sym: 256; act: 111 ),
  ( sym: 257; act: 112 ),
  ( sym: 259; act: 14 ),
  ( sym: 260; act: 15 ),
  ( sym: 261; act: 16 ),
  ( sym: 264; act: 19 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 268; act: 115 ),
  ( sym: 269; act: 116 ),
  ( sym: 270; act: 117 ),
  ( sym: 272; act: 118 ),
  ( sym: 273; act: 119 ),
  ( sym: 274; act: 120 ),
  ( sym: 275; act: 121 ),
  ( sym: 280; act: 122 ),
  ( sym: 283; act: 123 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 287; act: 126 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
  ( sym: 293; act: 132 ),
  ( sym: 294; act: 20 ),
  ( sym: 35; act: -10 ),
  ( sym: 60; act: -108 ),
  ( sym: 91; act: -108 ),
  ( sym: 123; act: -108 ),
{ 124: }
{ 125: }
{ 126: }
  ( sym: 40; act: 109 ),
  ( sym: 256; act: 111 ),
  ( sym: 257; act: 112 ),
  ( sym: 259; act: 14 ),
  ( sym: 260; act: 15 ),
  ( sym: 261; act: 16 ),
  ( sym: 264; act: 19 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 268; act: 115 ),
  ( sym: 269; act: 116 ),
  ( sym: 270; act: 117 ),
  ( sym: 272; act: 118 ),
  ( sym: 273; act: 119 ),
  ( sym: 274; act: 120 ),
  ( sym: 275; act: 121 ),
  ( sym: 280; act: 122 ),
  ( sym: 283; act: 123 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 287; act: 126 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
  ( sym: 293; act: 132 ),
  ( sym: 294; act: 20 ),
  ( sym: 35; act: -10 ),
  ( sym: 60; act: -108 ),
  ( sym: 91; act: -108 ),
  ( sym: 123; act: -108 ),
{ 127: }
  ( sym: 40; act: 171 ),
  ( sym: 41; act: -90 ),
  ( sym: 58; act: -90 ),
  ( sym: 258; act: -90 ),
  ( sym: 276; act: -90 ),
  ( sym: 277; act: -90 ),
  ( sym: 278; act: -90 ),
  ( sym: 279; act: -90 ),
  ( sym: 281; act: -90 ),
  ( sym: 322; act: -90 ),
{ 128: }
  ( sym: 40; act: 172 ),
  ( sym: 41; act: -92 ),
  ( sym: 58; act: -92 ),
  ( sym: 258; act: -92 ),
  ( sym: 276; act: -92 ),
  ( sym: 277; act: -92 ),
  ( sym: 278; act: -92 ),
  ( sym: 279; act: -92 ),
  ( sym: 281; act: -92 ),
  ( sym: 322; act: -92 ),
{ 129: }
  ( sym: 40; act: 173 ),
  ( sym: 41; act: -94 ),
  ( sym: 58; act: -94 ),
  ( sym: 258; act: -94 ),
  ( sym: 276; act: -94 ),
  ( sym: 277; act: -94 ),
  ( sym: 278; act: -94 ),
  ( sym: 279; act: -94 ),
  ( sym: 281; act: -94 ),
  ( sym: 322; act: -94 ),
{ 130: }
{ 131: }
  ( sym: 40; act: 174 ),
{ 132: }
  ( sym: 123; act: 175 ),
{ 133: }
  ( sym: 40; act: 109 ),
  ( sym: 93; act: 176 ),
  ( sym: 256; act: 151 ),
  ( sym: 257; act: 112 ),
  ( sym: 259; act: 14 ),
  ( sym: 260; act: 15 ),
  ( sym: 261; act: 16 ),
  ( sym: 264; act: 19 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 268; act: 115 ),
  ( sym: 269; act: 116 ),
  ( sym: 270; act: 117 ),
  ( sym: 272; act: 118 ),
  ( sym: 273; act: 119 ),
  ( sym: 274; act: 120 ),
  ( sym: 275; act: 121 ),
  ( sym: 280; act: 122 ),
  ( sym: 283; act: 123 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 287; act: 126 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
  ( sym: 293; act: 132 ),
  ( sym: 294; act: 20 ),
  ( sym: 35; act: -10 ),
  ( sym: 60; act: -108 ),
  ( sym: 91; act: -108 ),
  ( sym: 123; act: -108 ),
{ 134: }
{ 135: }
  ( sym: 40; act: 109 ),
  ( sym: 125; act: 177 ),
  ( sym: 256; act: 151 ),
  ( sym: 257; act: 112 ),
  ( sym: 259; act: 14 ),
  ( sym: 260; act: 15 ),
  ( sym: 261; act: 16 ),
  ( sym: 264; act: 19 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 268; act: 115 ),
  ( sym: 269; act: 116 ),
  ( sym: 270; act: 117 ),
  ( sym: 272; act: 118 ),
  ( sym: 273; act: 119 ),
  ( sym: 274; act: 120 ),
  ( sym: 275; act: 121 ),
  ( sym: 280; act: 122 ),
  ( sym: 283; act: 123 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 287; act: 126 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
  ( sym: 293; act: 132 ),
  ( sym: 294; act: 20 ),
  ( sym: 35; act: -10 ),
  ( sym: 60; act: -108 ),
  ( sym: 91; act: -108 ),
  ( sym: 123; act: -108 ),
{ 136: }
{ 137: }
{ 138: }
{ 139: }
  ( sym: 40; act: 109 ),
  ( sym: 257; act: 161 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 280; act: 122 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
{ 140: }
  ( sym: 40; act: 109 ),
  ( sym: 257; act: 161 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 280; act: 122 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
{ 141: }
  ( sym: 40; act: 109 ),
  ( sym: 257; act: 161 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 280; act: 122 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
{ 142: }
  ( sym: 40; act: 109 ),
  ( sym: 257; act: 161 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 280; act: 122 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
{ 143: }
{ 144: }
  ( sym: 40; act: 109 ),
  ( sym: 257; act: 161 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 280; act: 122 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
  ( sym: 41; act: -105 ),
  ( sym: 58; act: -105 ),
  ( sym: 258; act: -105 ),
  ( sym: 276; act: -105 ),
  ( sym: 277; act: -105 ),
  ( sym: 278; act: -105 ),
  ( sym: 279; act: -105 ),
  ( sym: 281; act: -105 ),
  ( sym: 322; act: -105 ),
{ 145: }
{ 146: }
{ 147: }
  ( sym: 257; act: 185 ),
  ( sym: 41; act: -77 ),
  ( sym: 44; act: -77 ),
{ 148: }
  ( sym: 257; act: 164 ),
  ( sym: 269; act: 116 ),
  ( sym: 270; act: 117 ),
{ 149: }
{ 150: }
{ 151: }
  ( sym: 258; act: 26 ),
  ( sym: 35; act: -62 ),
  ( sym: 40; act: -62 ),
  ( sym: 60; act: -62 ),
  ( sym: 62; act: -62 ),
  ( sym: 91; act: -62 ),
  ( sym: 93; act: -62 ),
  ( sym: 123; act: -62 ),
  ( sym: 125; act: -62 ),
  ( sym: 256; act: -62 ),
  ( sym: 257; act: -62 ),
  ( sym: 259; act: -62 ),
  ( sym: 260; act: -62 ),
  ( sym: 261; act: -62 ),
  ( sym: 264; act: -62 ),
  ( sym: 266; act: -62 ),
  ( sym: 267; act: -62 ),
  ( sym: 268; act: -62 ),
  ( sym: 269; act: -62 ),
  ( sym: 270; act: -62 ),
  ( sym: 272; act: -62 ),
  ( sym: 273; act: -62 ),
  ( sym: 274; act: -62 ),
  ( sym: 275; act: -62 ),
  ( sym: 280; act: -62 ),
  ( sym: 283; act: -62 ),
  ( sym: 284; act: -62 ),
  ( sym: 285; act: -62 ),
  ( sym: 287; act: -62 ),
  ( sym: 288; act: -62 ),
  ( sym: 289; act: -62 ),
  ( sym: 290; act: -62 ),
  ( sym: 291; act: -62 ),
  ( sym: 292; act: -62 ),
  ( sym: 293; act: -62 ),
  ( sym: 294; act: -62 ),
{ 152: }
{ 153: }
  ( sym: 257; act: 154 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
{ 154: }
{ 155: }
  ( sym: 40; act: 109 ),
  ( sym: 256; act: 111 ),
  ( sym: 257; act: 112 ),
  ( sym: 258; act: 26 ),
  ( sym: 259; act: 14 ),
  ( sym: 260; act: 15 ),
  ( sym: 261; act: 16 ),
  ( sym: 264; act: 19 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 268; act: 115 ),
  ( sym: 269; act: 116 ),
  ( sym: 270; act: 117 ),
  ( sym: 272; act: 118 ),
  ( sym: 273; act: 119 ),
  ( sym: 274; act: 120 ),
  ( sym: 275; act: 121 ),
  ( sym: 280; act: 122 ),
  ( sym: 283; act: 123 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 287; act: 126 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
  ( sym: 293; act: 132 ),
  ( sym: 294; act: 20 ),
  ( sym: 35; act: -10 ),
  ( sym: 60; act: -108 ),
  ( sym: 91; act: -108 ),
  ( sym: 123; act: -108 ),
{ 156: }
  ( sym: 41; act: 191 ),
  ( sym: 276; act: 139 ),
  ( sym: 277; act: 140 ),
  ( sym: 278; act: 141 ),
  ( sym: 279; act: 142 ),
  ( sym: 281; act: 143 ),
  ( sym: 322; act: 144 ),
{ 157: }
  ( sym: 41; act: 192 ),
{ 158: }
{ 159: }
  ( sym: 258; act: 26 ),
  ( sym: 276; act: 139 ),
  ( sym: 277; act: 140 ),
  ( sym: 278; act: 141 ),
  ( sym: 279; act: 142 ),
  ( sym: 281; act: 143 ),
  ( sym: 322; act: 144 ),
{ 160: }
{ 161: }
  ( sym: 41; act: -40 ),
  ( sym: 58; act: -40 ),
  ( sym: 61; act: -40 ),
  ( sym: 257; act: -40 ),
  ( sym: 258; act: -40 ),
  ( sym: 276; act: -40 ),
  ( sym: 277; act: -40 ),
  ( sym: 278; act: -40 ),
  ( sym: 279; act: -40 ),
  ( sym: 281; act: -40 ),
  ( sym: 284; act: -40 ),
  ( sym: 285; act: -40 ),
  ( sym: 322; act: -40 ),
  ( sym: 40; act: -46 ),
{ 162: }
  ( sym: 44; act: 148 ),
  ( sym: 258; act: -126 ),
{ 163: }
{ 164: }
{ 165: }
  ( sym: 40; act: 109 ),
  ( sym: 257; act: 161 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 280; act: 122 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
{ 166: }
  ( sym: 40; act: 109 ),
  ( sym: 257; act: 161 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 280; act: 122 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
{ 167: }
  ( sym: 258; act: 26 ),
  ( sym: 276; act: 139 ),
  ( sym: 277; act: 140 ),
  ( sym: 278; act: 141 ),
  ( sym: 279; act: 142 ),
  ( sym: 281; act: 143 ),
  ( sym: 322; act: 144 ),
{ 168: }
  ( sym: 281; act: 143 ),
  ( sym: 322; act: 144 ),
  ( sym: 41; act: -102 ),
  ( sym: 58; act: -102 ),
  ( sym: 258; act: -102 ),
  ( sym: 276; act: -102 ),
  ( sym: 277; act: -102 ),
  ( sym: 278; act: -102 ),
  ( sym: 279; act: -102 ),
{ 169: }
{ 170: }
{ 171: }
  ( sym: 257; act: 154 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
{ 172: }
  ( sym: 257; act: 154 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
{ 173: }
  ( sym: 257; act: 154 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
{ 174: }
  ( sym: 257; act: 154 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
{ 175: }
  ( sym: 40; act: 109 ),
  ( sym: 125; act: 203 ),
  ( sym: 257; act: 161 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 280; act: 122 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
{ 176: }
{ 177: }
{ 178: }
  ( sym: 281; act: 143 ),
  ( sym: 322; act: 144 ),
  ( sym: 41; act: -99 ),
  ( sym: 58; act: -99 ),
  ( sym: 258; act: -99 ),
  ( sym: 276; act: -99 ),
  ( sym: 277; act: -99 ),
  ( sym: 278; act: -99 ),
  ( sym: 279; act: -99 ),
{ 179: }
  ( sym: 276; act: 139 ),
  ( sym: 281; act: 143 ),
  ( sym: 322; act: 144 ),
  ( sym: 41; act: -100 ),
  ( sym: 58; act: -100 ),
  ( sym: 258; act: -100 ),
  ( sym: 277; act: -100 ),
  ( sym: 278; act: -100 ),
  ( sym: 279; act: -100 ),
{ 180: }
  ( sym: 276; act: 139 ),
  ( sym: 277; act: 140 ),
  ( sym: 281; act: 143 ),
  ( sym: 322; act: 144 ),
  ( sym: 41; act: -101 ),
  ( sym: 58; act: -101 ),
  ( sym: 258; act: -101 ),
  ( sym: 278; act: -101 ),
  ( sym: 279; act: -101 ),
{ 181: }
  ( sym: 276; act: 139 ),
  ( sym: 277; act: 140 ),
  ( sym: 278; act: 141 ),
  ( sym: 281; act: 143 ),
  ( sym: 322; act: 144 ),
  ( sym: 41; act: -103 ),
  ( sym: 58; act: -103 ),
  ( sym: 258; act: -103 ),
  ( sym: 279; act: -103 ),
{ 182: }
{ 183: }
  ( sym: 41; act: 204 ),
  ( sym: 44; act: 205 ),
{ 184: }
{ 185: }
{ 186: }
{ 187: }
  ( sym: 257; act: 154 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 41; act: -96 ),
  ( sym: 58; act: -96 ),
  ( sym: 258; act: -96 ),
  ( sym: 276; act: -96 ),
  ( sym: 277; act: -96 ),
  ( sym: 278; act: -96 ),
  ( sym: 279; act: -96 ),
  ( sym: 281; act: -96 ),
  ( sym: 322; act: -96 ),
{ 188: }
{ 189: }
{ 190: }
{ 191: }
{ 192: }
{ 193: }
{ 194: }
  ( sym: 41; act: 206 ),
  ( sym: 276; act: 139 ),
  ( sym: 277; act: 140 ),
  ( sym: 278; act: 141 ),
  ( sym: 279; act: 142 ),
  ( sym: 281; act: 143 ),
  ( sym: 322; act: 144 ),
{ 195: }
  ( sym: 41; act: 207 ),
  ( sym: 276; act: 139 ),
  ( sym: 277; act: 140 ),
  ( sym: 278; act: 141 ),
  ( sym: 279; act: 142 ),
  ( sym: 281; act: 143 ),
  ( sym: 322; act: 144 ),
{ 196: }
{ 197: }
  ( sym: 41; act: 208 ),
{ 198: }
  ( sym: 41; act: 209 ),
{ 199: }
  ( sym: 41; act: 210 ),
{ 200: }
  ( sym: 41; act: 211 ),
  ( sym: 257; act: 154 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
{ 201: }
{ 202: }
  ( sym: 58; act: 212 ),
  ( sym: 276; act: 139 ),
  ( sym: 277; act: 140 ),
  ( sym: 278; act: 141 ),
  ( sym: 279; act: 142 ),
  ( sym: 281; act: 143 ),
  ( sym: 322; act: 144 ),
{ 203: }
{ 204: }
{ 205: }
  ( sym: 257; act: 185 ),
{ 206: }
  ( sym: 40; act: 109 ),
  ( sym: 256; act: 111 ),
  ( sym: 257; act: 112 ),
  ( sym: 259; act: 14 ),
  ( sym: 260; act: 15 ),
  ( sym: 261; act: 16 ),
  ( sym: 264; act: 19 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 268; act: 115 ),
  ( sym: 269; act: 116 ),
  ( sym: 270; act: 117 ),
  ( sym: 272; act: 118 ),
  ( sym: 273; act: 119 ),
  ( sym: 274; act: 120 ),
  ( sym: 275; act: 121 ),
  ( sym: 280; act: 122 ),
  ( sym: 283; act: 123 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 287; act: 126 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
  ( sym: 293; act: 132 ),
  ( sym: 294; act: 20 ),
  ( sym: 35; act: -10 ),
  ( sym: 60; act: -108 ),
  ( sym: 91; act: -108 ),
  ( sym: 123; act: -108 ),
{ 207: }
  ( sym: 40; act: 109 ),
  ( sym: 256; act: 111 ),
  ( sym: 257; act: 112 ),
  ( sym: 259; act: 14 ),
  ( sym: 260; act: 15 ),
  ( sym: 261; act: 16 ),
  ( sym: 264; act: 19 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 268; act: 115 ),
  ( sym: 269; act: 116 ),
  ( sym: 270; act: 117 ),
  ( sym: 272; act: 118 ),
  ( sym: 273; act: 119 ),
  ( sym: 274; act: 120 ),
  ( sym: 275; act: 121 ),
  ( sym: 280; act: 122 ),
  ( sym: 283; act: 123 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 287; act: 126 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
  ( sym: 293; act: 132 ),
  ( sym: 294; act: 20 ),
  ( sym: 35; act: -10 ),
  ( sym: 60; act: -108 ),
  ( sym: 91; act: -108 ),
  ( sym: 123; act: -108 ),
{ 208: }
{ 209: }
{ 210: }
{ 211: }
{ 212: }
  ( sym: 40; act: 109 ),
  ( sym: 256; act: 111 ),
  ( sym: 257; act: 112 ),
  ( sym: 259; act: 14 ),
  ( sym: 260; act: 15 ),
  ( sym: 261; act: 16 ),
  ( sym: 264; act: 19 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 268; act: 115 ),
  ( sym: 269; act: 116 ),
  ( sym: 270; act: 117 ),
  ( sym: 272; act: 118 ),
  ( sym: 273; act: 119 ),
  ( sym: 274; act: 120 ),
  ( sym: 275; act: 121 ),
  ( sym: 280; act: 122 ),
  ( sym: 283; act: 123 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 287; act: 126 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
  ( sym: 293; act: 132 ),
  ( sym: 294; act: 20 ),
  ( sym: 35; act: -10 ),
  ( sym: 60; act: -108 ),
  ( sym: 91; act: -108 ),
  ( sym: 123; act: -108 ),
{ 213: }
{ 214: }
  ( sym: 271; act: 217 ),
  ( sym: 35; act: -128 ),
  ( sym: 40; act: -128 ),
  ( sym: 41; act: -128 ),
  ( sym: 60; act: -128 ),
  ( sym: 62; act: -128 ),
  ( sym: 91; act: -128 ),
  ( sym: 93; act: -128 ),
  ( sym: 123; act: -128 ),
  ( sym: 125; act: -128 ),
  ( sym: 256; act: -128 ),
  ( sym: 257; act: -128 ),
  ( sym: 259; act: -128 ),
  ( sym: 260; act: -128 ),
  ( sym: 261; act: -128 ),
  ( sym: 264; act: -128 ),
  ( sym: 266; act: -128 ),
  ( sym: 267; act: -128 ),
  ( sym: 268; act: -128 ),
  ( sym: 269; act: -128 ),
  ( sym: 270; act: -128 ),
  ( sym: 272; act: -128 ),
  ( sym: 273; act: -128 ),
  ( sym: 274; act: -128 ),
  ( sym: 275; act: -128 ),
  ( sym: 280; act: -128 ),
  ( sym: 283; act: -128 ),
  ( sym: 284; act: -128 ),
  ( sym: 285; act: -128 ),
  ( sym: 287; act: -128 ),
  ( sym: 288; act: -128 ),
  ( sym: 289; act: -128 ),
  ( sym: 290; act: -128 ),
  ( sym: 291; act: -128 ),
  ( sym: 292; act: -128 ),
  ( sym: 293; act: -128 ),
  ( sym: 294; act: -128 ),
{ 215: }
{ 216: }
  ( sym: 40; act: 109 ),
  ( sym: 125; act: 219 ),
  ( sym: 257; act: 161 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 271; act: 220 ),
  ( sym: 280; act: 122 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
{ 217: }
  ( sym: 40; act: 109 ),
  ( sym: 256; act: 111 ),
  ( sym: 257; act: 112 ),
  ( sym: 259; act: 14 ),
  ( sym: 260; act: 15 ),
  ( sym: 261; act: 16 ),
  ( sym: 264; act: 19 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 268; act: 115 ),
  ( sym: 269; act: 116 ),
  ( sym: 270; act: 117 ),
  ( sym: 272; act: 118 ),
  ( sym: 273; act: 119 ),
  ( sym: 274; act: 120 ),
  ( sym: 275; act: 121 ),
  ( sym: 280; act: 122 ),
  ( sym: 283; act: 123 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 287; act: 126 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
  ( sym: 293; act: 132 ),
  ( sym: 294; act: 20 ),
  ( sym: 35; act: -10 ),
  ( sym: 60; act: -108 ),
  ( sym: 91; act: -108 ),
  ( sym: 123; act: -108 ),
{ 218: }
{ 219: }
{ 220: }
  ( sym: 40; act: 109 ),
  ( sym: 256; act: 111 ),
  ( sym: 257; act: 112 ),
  ( sym: 259; act: 14 ),
  ( sym: 260; act: 15 ),
  ( sym: 261; act: 16 ),
  ( sym: 264; act: 19 ),
  ( sym: 266; act: 113 ),
  ( sym: 267; act: 114 ),
  ( sym: 268; act: 115 ),
  ( sym: 269; act: 116 ),
  ( sym: 270; act: 117 ),
  ( sym: 272; act: 118 ),
  ( sym: 273; act: 119 ),
  ( sym: 274; act: 120 ),
  ( sym: 275; act: 121 ),
  ( sym: 280; act: 122 ),
  ( sym: 283; act: 123 ),
  ( sym: 284; act: 124 ),
  ( sym: 285; act: 125 ),
  ( sym: 287; act: 126 ),
  ( sym: 288; act: 127 ),
  ( sym: 289; act: 128 ),
  ( sym: 290; act: 129 ),
  ( sym: 291; act: 130 ),
  ( sym: 292; act: 131 ),
  ( sym: 293; act: 132 ),
  ( sym: 294; act: 20 ),
  ( sym: 35; act: -10 ),
  ( sym: 60; act: -108 ),
  ( sym: 91; act: -108 ),
  ( sym: 123; act: -108 ),
{ 221: }
{ 222: }
  ( sym: 125; act: 223 )
{ 223: }
);

yyg : array [1..yyngotos] of YYARec = (
{ 0: }
  ( sym: -36; act: 1 ),
  ( sym: -7; act: 2 ),
{ 1: }
  ( sym: -44; act: 3 ),
  ( sym: -41; act: 4 ),
  ( sym: -40; act: 5 ),
  ( sym: -39; act: 6 ),
  ( sym: -38; act: 7 ),
  ( sym: -35; act: 8 ),
  ( sym: -19; act: 9 ),
  ( sym: -18; act: 10 ),
  ( sym: -17; act: 11 ),
  ( sym: -15; act: 12 ),
{ 2: }
{ 3: }
{ 4: }
{ 5: }
{ 6: }
{ 7: }
  ( sym: -44; act: 3 ),
  ( sym: -41; act: 4 ),
  ( sym: -40; act: 5 ),
  ( sym: -39; act: 6 ),
  ( sym: -38; act: 7 ),
  ( sym: -35; act: 23 ),
  ( sym: -19; act: 9 ),
  ( sym: -18; act: 10 ),
  ( sym: -17; act: 11 ),
  ( sym: -15; act: 12 ),
{ 8: }
{ 9: }
  ( sym: -37; act: 24 ),
{ 10: }
{ 11: }
{ 12: }
  ( sym: -44; act: 3 ),
  ( sym: -41; act: 4 ),
  ( sym: -40; act: 5 ),
  ( sym: -39; act: 6 ),
  ( sym: -38; act: 7 ),
  ( sym: -35; act: 29 ),
  ( sym: -19; act: 9 ),
  ( sym: -18; act: 10 ),
  ( sym: -17; act: 11 ),
  ( sym: -15; act: 12 ),
{ 13: }
  ( sym: -44; act: 3 ),
  ( sym: -41; act: 4 ),
  ( sym: -40; act: 5 ),
  ( sym: -39; act: 6 ),
  ( sym: -38; act: 7 ),
  ( sym: -35; act: 30 ),
  ( sym: -19; act: 9 ),
  ( sym: -18; act: 10 ),
  ( sym: -17; act: 11 ),
  ( sym: -15; act: 12 ),
{ 14: }
{ 15: }
{ 16: }
{ 17: }
{ 18: }
{ 19: }
{ 20: }
{ 21: }
{ 22: }
{ 23: }
{ 24: }
  ( sym: -44; act: 3 ),
  ( sym: -41; act: 4 ),
  ( sym: -40; act: 5 ),
  ( sym: -39; act: 6 ),
  ( sym: -38; act: 7 ),
  ( sym: -35; act: 45 ),
  ( sym: -19; act: 9 ),
  ( sym: -18; act: 10 ),
  ( sym: -17; act: 11 ),
  ( sym: -15; act: 12 ),
{ 25: }
{ 26: }
{ 27: }
{ 28: }
  ( sym: -42; act: 47 ),
{ 29: }
{ 30: }
{ 31: }
{ 32: }
{ 33: }
{ 34: }
{ 35: }
{ 36: }
{ 37: }
{ 38: }
{ 39: }
{ 40: }
{ 41: }
{ 42: }
{ 43: }
{ 44: }
{ 45: }
{ 46: }
{ 47: }
{ 48: }
  ( sym: -32; act: 54 ),
{ 49: }
  ( sym: -32; act: 58 ),
{ 50: }
  ( sym: -34; act: 59 ),
{ 51: }
  ( sym: -34; act: 64 ),
{ 52: }
{ 53: }
  ( sym: -44; act: 3 ),
  ( sym: -18; act: 65 ),
  ( sym: -10; act: 66 ),
  ( sym: -9; act: 67 ),
  ( sym: -5; act: 68 ),
{ 54: }
{ 55: }
{ 56: }
{ 57: }
{ 58: }
{ 59: }
{ 60: }
{ 61: }
{ 62: }
{ 63: }
{ 64: }
{ 65: }
{ 66: }
{ 67: }
{ 68: }
{ 69: }
  ( sym: -33; act: 76 ),
{ 70: }
  ( sym: -33; act: 81 ),
{ 71: }
{ 72: }
{ 73: }
{ 74: }
  ( sym: -43; act: 82 ),
{ 75: }
  ( sym: -44; act: 3 ),
  ( sym: -18; act: 65 ),
  ( sym: -5; act: 83 ),
{ 76: }
{ 77: }
{ 78: }
{ 79: }
{ 80: }
{ 81: }
{ 82: }
  ( sym: -29; act: 86 ),
{ 83: }
{ 84: }
{ 85: }
{ 86: }
{ 87: }
  ( sym: -45; act: 90 ),
  ( sym: -44; act: 3 ),
  ( sym: -41; act: 91 ),
  ( sym: -40; act: 5 ),
  ( sym: -39; act: 92 ),
  ( sym: -31; act: 93 ),
  ( sym: -28; act: 94 ),
  ( sym: -27; act: 95 ),
  ( sym: -26; act: 96 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 99 ),
  ( sym: -21; act: 100 ),
  ( sym: -20; act: 101 ),
  ( sym: -19; act: 102 ),
  ( sym: -18; act: 10 ),
  ( sym: -16; act: 103 ),
  ( sym: -14; act: 104 ),
  ( sym: -13; act: 105 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
  ( sym: -3; act: 108 ),
{ 88: }
  ( sym: -45; act: 90 ),
  ( sym: -44; act: 3 ),
  ( sym: -41; act: 91 ),
  ( sym: -40; act: 5 ),
  ( sym: -39; act: 92 ),
  ( sym: -31; act: 93 ),
  ( sym: -28; act: 94 ),
  ( sym: -27; act: 95 ),
  ( sym: -26; act: 96 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 99 ),
  ( sym: -21; act: 100 ),
  ( sym: -20; act: 101 ),
  ( sym: -19; act: 102 ),
  ( sym: -18; act: 10 ),
  ( sym: -16; act: 103 ),
  ( sym: -14; act: 104 ),
  ( sym: -13; act: 133 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
  ( sym: -3; act: 108 ),
{ 89: }
  ( sym: -45; act: 90 ),
  ( sym: -44; act: 3 ),
  ( sym: -41; act: 91 ),
  ( sym: -40; act: 5 ),
  ( sym: -39; act: 92 ),
  ( sym: -31; act: 93 ),
  ( sym: -28; act: 94 ),
  ( sym: -27; act: 95 ),
  ( sym: -26; act: 96 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 99 ),
  ( sym: -21; act: 100 ),
  ( sym: -20; act: 101 ),
  ( sym: -19; act: 102 ),
  ( sym: -18; act: 10 ),
  ( sym: -16; act: 103 ),
  ( sym: -14; act: 104 ),
  ( sym: -13; act: 135 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
  ( sym: -3; act: 108 ),
{ 90: }
  ( sym: -29; act: 137 ),
{ 91: }
{ 92: }
{ 93: }
{ 94: }
{ 95: }
{ 96: }
  ( sym: -37; act: 138 ),
{ 97: }
{ 98: }
{ 99: }
{ 100: }
{ 101: }
{ 102: }
  ( sym: -37; act: 146 ),
{ 103: }
{ 104: }
{ 105: }
  ( sym: -45; act: 90 ),
  ( sym: -44; act: 3 ),
  ( sym: -41; act: 91 ),
  ( sym: -40; act: 5 ),
  ( sym: -39; act: 92 ),
  ( sym: -31; act: 93 ),
  ( sym: -28; act: 94 ),
  ( sym: -27; act: 95 ),
  ( sym: -26; act: 96 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 99 ),
  ( sym: -21; act: 100 ),
  ( sym: -20; act: 149 ),
  ( sym: -19; act: 102 ),
  ( sym: -18; act: 10 ),
  ( sym: -16; act: 103 ),
  ( sym: -14; act: 104 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
  ( sym: -3; act: 108 ),
{ 106: }
  ( sym: -6; act: 152 ),
{ 107: }
{ 108: }
{ 109: }
  ( sym: -45; act: 90 ),
  ( sym: -44; act: 3 ),
  ( sym: -41; act: 91 ),
  ( sym: -40; act: 5 ),
  ( sym: -39; act: 92 ),
  ( sym: -31; act: 93 ),
  ( sym: -28; act: 94 ),
  ( sym: -27; act: 95 ),
  ( sym: -26; act: 96 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 156 ),
  ( sym: -21; act: 100 ),
  ( sym: -20; act: 157 ),
  ( sym: -19; act: 102 ),
  ( sym: -18; act: 10 ),
  ( sym: -16; act: 103 ),
  ( sym: -14; act: 104 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
  ( sym: -3; act: 108 ),
{ 110: }
{ 111: }
  ( sym: -37; act: 158 ),
{ 112: }
{ 113: }
{ 114: }
{ 115: }
  ( sym: -27; act: 95 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 159 ),
  ( sym: -21; act: 160 ),
  ( sym: -16; act: 103 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
{ 116: }
{ 117: }
{ 118: }
  ( sym: -14; act: 162 ),
  ( sym: -3; act: 163 ),
{ 119: }
{ 120: }
{ 121: }
  ( sym: -27; act: 95 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 167 ),
  ( sym: -21; act: 160 ),
  ( sym: -16; act: 103 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
{ 122: }
  ( sym: -27; act: 95 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 168 ),
  ( sym: -21; act: 160 ),
  ( sym: -16; act: 103 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
{ 123: }
  ( sym: -45; act: 90 ),
  ( sym: -44; act: 3 ),
  ( sym: -41; act: 91 ),
  ( sym: -40; act: 5 ),
  ( sym: -39; act: 92 ),
  ( sym: -31; act: 93 ),
  ( sym: -28; act: 94 ),
  ( sym: -27; act: 95 ),
  ( sym: -26; act: 96 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 99 ),
  ( sym: -21; act: 100 ),
  ( sym: -20; act: 169 ),
  ( sym: -19; act: 102 ),
  ( sym: -18; act: 10 ),
  ( sym: -16; act: 103 ),
  ( sym: -14; act: 104 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
  ( sym: -3; act: 108 ),
{ 124: }
{ 125: }
{ 126: }
  ( sym: -45; act: 90 ),
  ( sym: -44; act: 3 ),
  ( sym: -41; act: 91 ),
  ( sym: -40; act: 5 ),
  ( sym: -39; act: 92 ),
  ( sym: -31; act: 93 ),
  ( sym: -28; act: 94 ),
  ( sym: -27; act: 95 ),
  ( sym: -26; act: 96 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 99 ),
  ( sym: -21; act: 100 ),
  ( sym: -20; act: 170 ),
  ( sym: -19; act: 102 ),
  ( sym: -18; act: 10 ),
  ( sym: -16; act: 103 ),
  ( sym: -14; act: 104 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
  ( sym: -3; act: 108 ),
{ 127: }
{ 128: }
{ 129: }
{ 130: }
{ 131: }
{ 132: }
{ 133: }
  ( sym: -45; act: 90 ),
  ( sym: -44; act: 3 ),
  ( sym: -41; act: 91 ),
  ( sym: -40; act: 5 ),
  ( sym: -39; act: 92 ),
  ( sym: -31; act: 93 ),
  ( sym: -28; act: 94 ),
  ( sym: -27; act: 95 ),
  ( sym: -26; act: 96 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 99 ),
  ( sym: -21; act: 100 ),
  ( sym: -20; act: 149 ),
  ( sym: -19; act: 102 ),
  ( sym: -18; act: 10 ),
  ( sym: -16; act: 103 ),
  ( sym: -14; act: 104 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
  ( sym: -3; act: 108 ),
{ 134: }
{ 135: }
  ( sym: -45; act: 90 ),
  ( sym: -44; act: 3 ),
  ( sym: -41; act: 91 ),
  ( sym: -40; act: 5 ),
  ( sym: -39; act: 92 ),
  ( sym: -31; act: 93 ),
  ( sym: -28; act: 94 ),
  ( sym: -27; act: 95 ),
  ( sym: -26; act: 96 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 99 ),
  ( sym: -21; act: 100 ),
  ( sym: -20; act: 149 ),
  ( sym: -19; act: 102 ),
  ( sym: -18; act: 10 ),
  ( sym: -16; act: 103 ),
  ( sym: -14; act: 104 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
  ( sym: -3; act: 108 ),
{ 136: }
{ 137: }
{ 138: }
{ 139: }
  ( sym: -27; act: 95 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 178 ),
  ( sym: -21; act: 160 ),
  ( sym: -16; act: 103 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
{ 140: }
  ( sym: -27; act: 95 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 179 ),
  ( sym: -21; act: 160 ),
  ( sym: -16; act: 103 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
{ 141: }
  ( sym: -27; act: 95 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 180 ),
  ( sym: -21; act: 160 ),
  ( sym: -16; act: 103 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
{ 142: }
  ( sym: -27; act: 95 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 181 ),
  ( sym: -21; act: 160 ),
  ( sym: -16; act: 103 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
{ 143: }
{ 144: }
  ( sym: -27; act: 95 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 182 ),
  ( sym: -21; act: 160 ),
  ( sym: -16; act: 103 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
{ 145: }
{ 146: }
{ 147: }
  ( sym: -8; act: 183 ),
  ( sym: -2; act: 184 ),
{ 148: }
  ( sym: -3; act: 186 ),
{ 149: }
{ 150: }
{ 151: }
  ( sym: -37; act: 158 ),
{ 152: }
{ 153: }
  ( sym: -11; act: 187 ),
  ( sym: -6; act: 188 ),
{ 154: }
{ 155: }
  ( sym: -45; act: 90 ),
  ( sym: -44; act: 3 ),
  ( sym: -41; act: 91 ),
  ( sym: -40; act: 5 ),
  ( sym: -39; act: 92 ),
  ( sym: -37; act: 189 ),
  ( sym: -31; act: 93 ),
  ( sym: -28; act: 94 ),
  ( sym: -27; act: 95 ),
  ( sym: -26; act: 96 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 99 ),
  ( sym: -21; act: 100 ),
  ( sym: -20; act: 190 ),
  ( sym: -19; act: 102 ),
  ( sym: -18; act: 10 ),
  ( sym: -16; act: 103 ),
  ( sym: -14; act: 104 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
  ( sym: -3; act: 108 ),
{ 156: }
{ 157: }
{ 158: }
{ 159: }
  ( sym: -37; act: 193 ),
{ 160: }
{ 161: }
{ 162: }
{ 163: }
{ 164: }
{ 165: }
  ( sym: -27; act: 95 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 194 ),
  ( sym: -21; act: 160 ),
  ( sym: -16; act: 103 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
{ 166: }
  ( sym: -27; act: 95 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 195 ),
  ( sym: -21; act: 160 ),
  ( sym: -16; act: 103 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
{ 167: }
  ( sym: -37; act: 196 ),
{ 168: }
{ 169: }
{ 170: }
{ 171: }
  ( sym: -6; act: 197 ),
{ 172: }
  ( sym: -6; act: 198 ),
{ 173: }
  ( sym: -6; act: 199 ),
{ 174: }
  ( sym: -11; act: 200 ),
  ( sym: -6; act: 188 ),
{ 175: }
  ( sym: -30; act: 201 ),
  ( sym: -27; act: 95 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 202 ),
  ( sym: -21; act: 160 ),
  ( sym: -16; act: 103 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
{ 176: }
{ 177: }
{ 178: }
{ 179: }
{ 180: }
{ 181: }
{ 182: }
{ 183: }
{ 184: }
{ 185: }
{ 186: }
{ 187: }
  ( sym: -6; act: 152 ),
{ 188: }
{ 189: }
{ 190: }
{ 191: }
{ 192: }
{ 193: }
{ 194: }
{ 195: }
{ 196: }
{ 197: }
{ 198: }
{ 199: }
{ 200: }
  ( sym: -6; act: 152 ),
{ 201: }
{ 202: }
{ 203: }
{ 204: }
{ 205: }
  ( sym: -2; act: 213 ),
{ 206: }
  ( sym: -45; act: 90 ),
  ( sym: -44; act: 3 ),
  ( sym: -41; act: 91 ),
  ( sym: -40; act: 5 ),
  ( sym: -39; act: 92 ),
  ( sym: -31; act: 93 ),
  ( sym: -28; act: 94 ),
  ( sym: -27; act: 95 ),
  ( sym: -26; act: 96 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 99 ),
  ( sym: -21; act: 100 ),
  ( sym: -20; act: 214 ),
  ( sym: -19; act: 102 ),
  ( sym: -18; act: 10 ),
  ( sym: -16; act: 103 ),
  ( sym: -14; act: 104 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
  ( sym: -3; act: 108 ),
{ 207: }
  ( sym: -45; act: 90 ),
  ( sym: -44; act: 3 ),
  ( sym: -41; act: 91 ),
  ( sym: -40; act: 5 ),
  ( sym: -39; act: 92 ),
  ( sym: -31; act: 93 ),
  ( sym: -28; act: 94 ),
  ( sym: -27; act: 95 ),
  ( sym: -26; act: 96 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 99 ),
  ( sym: -21; act: 100 ),
  ( sym: -20; act: 215 ),
  ( sym: -19; act: 102 ),
  ( sym: -18; act: 10 ),
  ( sym: -16; act: 103 ),
  ( sym: -14; act: 104 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
  ( sym: -3; act: 108 ),
{ 208: }
{ 209: }
{ 210: }
{ 211: }
{ 212: }
  ( sym: -45; act: 90 ),
  ( sym: -44; act: 3 ),
  ( sym: -41; act: 91 ),
  ( sym: -40; act: 5 ),
  ( sym: -39; act: 92 ),
  ( sym: -31; act: 93 ),
  ( sym: -28; act: 94 ),
  ( sym: -27; act: 95 ),
  ( sym: -26; act: 96 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 99 ),
  ( sym: -21; act: 100 ),
  ( sym: -20; act: 216 ),
  ( sym: -19; act: 102 ),
  ( sym: -18; act: 10 ),
  ( sym: -16; act: 103 ),
  ( sym: -14; act: 104 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
  ( sym: -3; act: 108 ),
{ 213: }
{ 214: }
{ 215: }
{ 216: }
  ( sym: -30; act: 218 ),
  ( sym: -27; act: 95 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 202 ),
  ( sym: -21; act: 160 ),
  ( sym: -16; act: 103 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
{ 217: }
  ( sym: -45; act: 90 ),
  ( sym: -44; act: 3 ),
  ( sym: -41; act: 91 ),
  ( sym: -40; act: 5 ),
  ( sym: -39; act: 92 ),
  ( sym: -31; act: 93 ),
  ( sym: -28; act: 94 ),
  ( sym: -27; act: 95 ),
  ( sym: -26; act: 96 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 99 ),
  ( sym: -21; act: 100 ),
  ( sym: -20; act: 221 ),
  ( sym: -19; act: 102 ),
  ( sym: -18; act: 10 ),
  ( sym: -16; act: 103 ),
  ( sym: -14; act: 104 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
  ( sym: -3; act: 108 ),
{ 218: }
{ 219: }
{ 220: }
  ( sym: -45; act: 90 ),
  ( sym: -44; act: 3 ),
  ( sym: -41; act: 91 ),
  ( sym: -40; act: 5 ),
  ( sym: -39; act: 92 ),
  ( sym: -31; act: 93 ),
  ( sym: -28; act: 94 ),
  ( sym: -27; act: 95 ),
  ( sym: -26; act: 96 ),
  ( sym: -25; act: 97 ),
  ( sym: -24; act: 98 ),
  ( sym: -22; act: 99 ),
  ( sym: -21; act: 100 ),
  ( sym: -20; act: 222 ),
  ( sym: -19; act: 102 ),
  ( sym: -18; act: 10 ),
  ( sym: -16; act: 103 ),
  ( sym: -14; act: 104 ),
  ( sym: -11; act: 106 ),
  ( sym: -6; act: 107 ),
  ( sym: -3; act: 108 )
{ 221: }
{ 222: }
{ 223: }
);

yyd : array [0..yynstates-1] of Integer = (
{ 0: } -1,
{ 1: } 0,
{ 2: } 0,
{ 3: } -69,
{ 4: } -23,
{ 5: } 0,
{ 6: } 0,
{ 7: } 0,
{ 8: } -2,
{ 9: } 0,
{ 10: } 0,
{ 11: } 0,
{ 12: } 0,
{ 13: } 0,
{ 14: } -68,
{ 15: } -65,
{ 16: } -66,
{ 17: } -47,
{ 18: } -48,
{ 19: } -67,
{ 20: } 0,
{ 21: } 0,
{ 22: } -24,
{ 23: } -7,
{ 24: } 0,
{ 25: } 0,
{ 26: } -107,
{ 27: } -70,
{ 28: } -51,
{ 29: } -8,
{ 30: } -9,
{ 31: } -28,
{ 32: } -27,
{ 33: } -26,
{ 34: } -29,
{ 35: } -30,
{ 36: } -31,
{ 37: } 0,
{ 38: } 0,
{ 39: } 0,
{ 40: } 0,
{ 41: } -36,
{ 42: } -37,
{ 43: } -38,
{ 44: } 0,
{ 45: } -6,
{ 46: } -71,
{ 47: } 0,
{ 48: } 0,
{ 49: } 0,
{ 50: } 0,
{ 51: } 0,
{ 52: } -11,
{ 53: } 0,
{ 54: } 0,
{ 55: } -12,
{ 56: } -13,
{ 57: } -14,
{ 58: } 0,
{ 59: } 0,
{ 60: } -22,
{ 61: } -20,
{ 62: } -21,
{ 63: } -19,
{ 64: } 0,
{ 65: } 0,
{ 66: } 0,
{ 67: } 0,
{ 68: } -72,
{ 69: } 0,
{ 70: } 0,
{ 71: } -34,
{ 72: } -35,
{ 73: } -74,
{ 74: } -52,
{ 75: } 0,
{ 76: } 0,
{ 77: } -17,
{ 78: } -16,
{ 79: } -15,
{ 80: } -18,
{ 81: } 0,
{ 82: } 0,
{ 83: } -73,
{ 84: } -33,
{ 85: } -32,
{ 86: } -53,
{ 87: } 0,
{ 88: } 0,
{ 89: } 0,
{ 90: } 0,
{ 91: } -118,
{ 92: } -25,
{ 93: } -116,
{ 94: } -112,
{ 95: } -82,
{ 96: } 0,
{ 97: } -89,
{ 98: } -86,
{ 99: } 0,
{ 100: } 0,
{ 101: } -60,
{ 102: } 0,
{ 103: } 0,
{ 104: } 0,
{ 105: } 0,
{ 106: } 0,
{ 107: } 0,
{ 108: } 0,
{ 109: } 0,
{ 110: } -56,
{ 111: } 0,
{ 112: } 0,
{ 113: } -84,
{ 114: } -83,
{ 115: } 0,
{ 116: } -44,
{ 117: } -45,
{ 118: } 0,
{ 119: } 0,
{ 120: } 0,
{ 121: } 0,
{ 122: } 0,
{ 123: } 0,
{ 124: } -41,
{ 125: } -42,
{ 126: } 0,
{ 127: } 0,
{ 128: } 0,
{ 129: } 0,
{ 130: } -87,
{ 131: } 0,
{ 132: } 0,
{ 133: } 0,
{ 134: } -55,
{ 135: } 0,
{ 136: } -54,
{ 137: } -109,
{ 138: } -113,
{ 139: } 0,
{ 140: } 0,
{ 141: } 0,
{ 142: } 0,
{ 143: } -104,
{ 144: } 0,
{ 145: } -110,
{ 146: } -111,
{ 147: } 0,
{ 148: } 0,
{ 149: } -61,
{ 150: } -59,
{ 151: } 0,
{ 152: } -76,
{ 153: } 0,
{ 154: } -40,
{ 155: } 0,
{ 156: } 0,
{ 157: } 0,
{ 158: } -117,
{ 159: } 0,
{ 160: } -97,
{ 161: } 0,
{ 162: } 0,
{ 163: } -63,
{ 164: } -43,
{ 165: } 0,
{ 166: } 0,
{ 167: } 0,
{ 168: } 0,
{ 169: } -131,
{ 170: } -119,
{ 171: } 0,
{ 172: } 0,
{ 173: } 0,
{ 174: } 0,
{ 175: } 0,
{ 176: } -58,
{ 177: } -57,
{ 178: } 0,
{ 179: } 0,
{ 180: } 0,
{ 181: } 0,
{ 182: } -106,
{ 183: } 0,
{ 184: } -78,
{ 185: } -39,
{ 186: } -64,
{ 187: } 0,
{ 188: } -75,
{ 189: } -115,
{ 190: } -114,
{ 191: } -81,
{ 192: } -88,
{ 193: } -133,
{ 194: } 0,
{ 195: } 0,
{ 196: } -132,
{ 197: } 0,
{ 198: } 0,
{ 199: } 0,
{ 200: } 0,
{ 201: } -123,
{ 202: } 0,
{ 203: } -124,
{ 204: } -80,
{ 205: } 0,
{ 206: } 0,
{ 207: } 0,
{ 208: } -91,
{ 209: } -93,
{ 210: } -95,
{ 211: } -85,
{ 212: } 0,
{ 213: } -79,
{ 214: } 0,
{ 215: } -130,
{ 216: } 0,
{ 217: } 0,
{ 218: } -120,
{ 219: } -121,
{ 220: } 0,
{ 221: } -129,
{ 222: } 0,
{ 223: } -122
);

yyal : array [0..yynstates-1] of Integer = (
{ 0: } 1,
{ 1: } 1,
{ 2: } 10,
{ 3: } 11,
{ 4: } 11,
{ 5: } 11,
{ 6: } 12,
{ 7: } 23,
{ 8: } 33,
{ 9: } 33,
{ 10: } 35,
{ 11: } 36,
{ 12: } 37,
{ 13: } 47,
{ 14: } 56,
{ 15: } 56,
{ 16: } 56,
{ 17: } 56,
{ 18: } 56,
{ 19: } 56,
{ 20: } 56,
{ 21: } 69,
{ 22: } 70,
{ 23: } 70,
{ 24: } 70,
{ 25: } 80,
{ 26: } 81,
{ 27: } 81,
{ 28: } 81,
{ 29: } 81,
{ 30: } 81,
{ 31: } 81,
{ 32: } 81,
{ 33: } 81,
{ 34: } 81,
{ 35: } 81,
{ 36: } 81,
{ 37: } 81,
{ 38: } 82,
{ 39: } 83,
{ 40: } 84,
{ 41: } 85,
{ 42: } 85,
{ 43: } 85,
{ 44: } 85,
{ 45: } 86,
{ 46: } 86,
{ 47: } 86,
{ 48: } 87,
{ 49: } 90,
{ 50: } 93,
{ 51: } 97,
{ 52: } 101,
{ 53: } 101,
{ 54: } 106,
{ 55: } 107,
{ 56: } 107,
{ 57: } 107,
{ 58: } 107,
{ 59: } 108,
{ 60: } 109,
{ 61: } 109,
{ 62: } 109,
{ 63: } 109,
{ 64: } 109,
{ 65: } 110,
{ 66: } 111,
{ 67: } 112,
{ 68: } 114,
{ 69: } 114,
{ 70: } 118,
{ 71: } 122,
{ 72: } 122,
{ 73: } 122,
{ 74: } 122,
{ 75: } 122,
{ 76: } 126,
{ 77: } 127,
{ 78: } 127,
{ 79: } 127,
{ 80: } 127,
{ 81: } 127,
{ 82: } 128,
{ 83: } 131,
{ 84: } 131,
{ 85: } 131,
{ 86: } 131,
{ 87: } 131,
{ 88: } 164,
{ 89: } 197,
{ 90: } 230,
{ 91: } 233,
{ 92: } 233,
{ 93: } 233,
{ 94: } 233,
{ 95: } 233,
{ 96: } 233,
{ 97: } 234,
{ 98: } 234,
{ 99: } 234,
{ 100: } 240,
{ 101: } 248,
{ 102: } 248,
{ 103: } 250,
{ 104: } 251,
{ 105: } 253,
{ 106: } 286,
{ 107: } 290,
{ 108: } 303,
{ 109: } 306,
{ 110: } 338,
{ 111: } 338,
{ 112: } 339,
{ 113: } 354,
{ 114: } 354,
{ 115: } 354,
{ 116: } 367,
{ 117: } 367,
{ 118: } 367,
{ 119: } 370,
{ 120: } 371,
{ 121: } 372,
{ 122: } 384,
{ 123: } 396,
{ 124: } 428,
{ 125: } 428,
{ 126: } 428,
{ 127: } 460,
{ 128: } 470,
{ 129: } 480,
{ 130: } 490,
{ 131: } 490,
{ 132: } 491,
{ 133: } 492,
{ 134: } 525,
{ 135: } 525,
{ 136: } 558,
{ 137: } 558,
{ 138: } 558,
{ 139: } 558,
{ 140: } 570,
{ 141: } 582,
{ 142: } 594,
{ 143: } 606,
{ 144: } 606,
{ 145: } 627,
{ 146: } 627,
{ 147: } 627,
{ 148: } 630,
{ 149: } 633,
{ 150: } 633,
{ 151: } 633,
{ 152: } 669,
{ 153: } 669,
{ 154: } 672,
{ 155: } 672,
{ 156: } 705,
{ 157: } 712,
{ 158: } 713,
{ 159: } 713,
{ 160: } 720,
{ 161: } 720,
{ 162: } 734,
{ 163: } 736,
{ 164: } 736,
{ 165: } 736,
{ 166: } 748,
{ 167: } 760,
{ 168: } 767,
{ 169: } 776,
{ 170: } 776,
{ 171: } 776,
{ 172: } 779,
{ 173: } 782,
{ 174: } 785,
{ 175: } 788,
{ 176: } 801,
{ 177: } 801,
{ 178: } 801,
{ 179: } 810,
{ 180: } 819,
{ 181: } 828,
{ 182: } 837,
{ 183: } 837,
{ 184: } 839,
{ 185: } 839,
{ 186: } 839,
{ 187: } 839,
{ 188: } 851,
{ 189: } 851,
{ 190: } 851,
{ 191: } 851,
{ 192: } 851,
{ 193: } 851,
{ 194: } 851,
{ 195: } 858,
{ 196: } 865,
{ 197: } 865,
{ 198: } 866,
{ 199: } 867,
{ 200: } 868,
{ 201: } 872,
{ 202: } 872,
{ 203: } 879,
{ 204: } 879,
{ 205: } 879,
{ 206: } 880,
{ 207: } 912,
{ 208: } 944,
{ 209: } 944,
{ 210: } 944,
{ 211: } 944,
{ 212: } 944,
{ 213: } 976,
{ 214: } 976,
{ 215: } 1013,
{ 216: } 1013,
{ 217: } 1027,
{ 218: } 1059,
{ 219: } 1059,
{ 220: } 1059,
{ 221: } 1091,
{ 222: } 1091,
{ 223: } 1092
);

yyah : array [0..yynstates-1] of Integer = (
{ 0: } 0,
{ 1: } 9,
{ 2: } 10,
{ 3: } 10,
{ 4: } 10,
{ 5: } 11,
{ 6: } 22,
{ 7: } 32,
{ 8: } 32,
{ 9: } 34,
{ 10: } 35,
{ 11: } 36,
{ 12: } 46,
{ 13: } 55,
{ 14: } 55,
{ 15: } 55,
{ 16: } 55,
{ 17: } 55,
{ 18: } 55,
{ 19: } 55,
{ 20: } 68,
{ 21: } 69,
{ 22: } 69,
{ 23: } 69,
{ 24: } 79,
{ 25: } 80,
{ 26: } 80,
{ 27: } 80,
{ 28: } 80,
{ 29: } 80,
{ 30: } 80,
{ 31: } 80,
{ 32: } 80,
{ 33: } 80,
{ 34: } 80,
{ 35: } 80,
{ 36: } 80,
{ 37: } 81,
{ 38: } 82,
{ 39: } 83,
{ 40: } 84,
{ 41: } 84,
{ 42: } 84,
{ 43: } 84,
{ 44: } 85,
{ 45: } 85,
{ 46: } 85,
{ 47: } 86,
{ 48: } 89,
{ 49: } 92,
{ 50: } 96,
{ 51: } 100,
{ 52: } 100,
{ 53: } 105,
{ 54: } 106,
{ 55: } 106,
{ 56: } 106,
{ 57: } 106,
{ 58: } 107,
{ 59: } 108,
{ 60: } 108,
{ 61: } 108,
{ 62: } 108,
{ 63: } 108,
{ 64: } 109,
{ 65: } 110,
{ 66: } 111,
{ 67: } 113,
{ 68: } 113,
{ 69: } 117,
{ 70: } 121,
{ 71: } 121,
{ 72: } 121,
{ 73: } 121,
{ 74: } 121,
{ 75: } 125,
{ 76: } 126,
{ 77: } 126,
{ 78: } 126,
{ 79: } 126,
{ 80: } 126,
{ 81: } 127,
{ 82: } 130,
{ 83: } 130,
{ 84: } 130,
{ 85: } 130,
{ 86: } 130,
{ 87: } 163,
{ 88: } 196,
{ 89: } 229,
{ 90: } 232,
{ 91: } 232,
{ 92: } 232,
{ 93: } 232,
{ 94: } 232,
{ 95: } 232,
{ 96: } 233,
{ 97: } 233,
{ 98: } 233,
{ 99: } 239,
{ 100: } 247,
{ 101: } 247,
{ 102: } 249,
{ 103: } 250,
{ 104: } 252,
{ 105: } 285,
{ 106: } 289,
{ 107: } 302,
{ 108: } 305,
{ 109: } 337,
{ 110: } 337,
{ 111: } 338,
{ 112: } 353,
{ 113: } 353,
{ 114: } 353,
{ 115: } 366,
{ 116: } 366,
{ 117: } 366,
{ 118: } 369,
{ 119: } 370,
{ 120: } 371,
{ 121: } 383,
{ 122: } 395,
{ 123: } 427,
{ 124: } 427,
{ 125: } 427,
{ 126: } 459,
{ 127: } 469,
{ 128: } 479,
{ 129: } 489,
{ 130: } 489,
{ 131: } 490,
{ 132: } 491,
{ 133: } 524,
{ 134: } 524,
{ 135: } 557,
{ 136: } 557,
{ 137: } 557,
{ 138: } 557,
{ 139: } 569,
{ 140: } 581,
{ 141: } 593,
{ 142: } 605,
{ 143: } 605,
{ 144: } 626,
{ 145: } 626,
{ 146: } 626,
{ 147: } 629,
{ 148: } 632,
{ 149: } 632,
{ 150: } 632,
{ 151: } 668,
{ 152: } 668,
{ 153: } 671,
{ 154: } 671,
{ 155: } 704,
{ 156: } 711,
{ 157: } 712,
{ 158: } 712,
{ 159: } 719,
{ 160: } 719,
{ 161: } 733,
{ 162: } 735,
{ 163: } 735,
{ 164: } 735,
{ 165: } 747,
{ 166: } 759,
{ 167: } 766,
{ 168: } 775,
{ 169: } 775,
{ 170: } 775,
{ 171: } 778,
{ 172: } 781,
{ 173: } 784,
{ 174: } 787,
{ 175: } 800,
{ 176: } 800,
{ 177: } 800,
{ 178: } 809,
{ 179: } 818,
{ 180: } 827,
{ 181: } 836,
{ 182: } 836,
{ 183: } 838,
{ 184: } 838,
{ 185: } 838,
{ 186: } 838,
{ 187: } 850,
{ 188: } 850,
{ 189: } 850,
{ 190: } 850,
{ 191: } 850,
{ 192: } 850,
{ 193: } 850,
{ 194: } 857,
{ 195: } 864,
{ 196: } 864,
{ 197: } 865,
{ 198: } 866,
{ 199: } 867,
{ 200: } 871,
{ 201: } 871,
{ 202: } 878,
{ 203: } 878,
{ 204: } 878,
{ 205: } 879,
{ 206: } 911,
{ 207: } 943,
{ 208: } 943,
{ 209: } 943,
{ 210: } 943,
{ 211: } 943,
{ 212: } 975,
{ 213: } 975,
{ 214: } 1012,
{ 215: } 1012,
{ 216: } 1026,
{ 217: } 1058,
{ 218: } 1058,
{ 219: } 1058,
{ 220: } 1090,
{ 221: } 1090,
{ 222: } 1091,
{ 223: } 1091
);

yygl : array [0..yynstates-1] of Integer = (
{ 0: } 1,
{ 1: } 3,
{ 2: } 13,
{ 3: } 13,
{ 4: } 13,
{ 5: } 13,
{ 6: } 13,
{ 7: } 13,
{ 8: } 23,
{ 9: } 23,
{ 10: } 24,
{ 11: } 24,
{ 12: } 24,
{ 13: } 34,
{ 14: } 44,
{ 15: } 44,
{ 16: } 44,
{ 17: } 44,
{ 18: } 44,
{ 19: } 44,
{ 20: } 44,
{ 21: } 44,
{ 22: } 44,
{ 23: } 44,
{ 24: } 44,
{ 25: } 54,
{ 26: } 54,
{ 27: } 54,
{ 28: } 54,
{ 29: } 55,
{ 30: } 55,
{ 31: } 55,
{ 32: } 55,
{ 33: } 55,
{ 34: } 55,
{ 35: } 55,
{ 36: } 55,
{ 37: } 55,
{ 38: } 55,
{ 39: } 55,
{ 40: } 55,
{ 41: } 55,
{ 42: } 55,
{ 43: } 55,
{ 44: } 55,
{ 45: } 55,
{ 46: } 55,
{ 47: } 55,
{ 48: } 55,
{ 49: } 56,
{ 50: } 57,
{ 51: } 58,
{ 52: } 59,
{ 53: } 59,
{ 54: } 64,
{ 55: } 64,
{ 56: } 64,
{ 57: } 64,
{ 58: } 64,
{ 59: } 64,
{ 60: } 64,
{ 61: } 64,
{ 62: } 64,
{ 63: } 64,
{ 64: } 64,
{ 65: } 64,
{ 66: } 64,
{ 67: } 64,
{ 68: } 64,
{ 69: } 64,
{ 70: } 65,
{ 71: } 66,
{ 72: } 66,
{ 73: } 66,
{ 74: } 66,
{ 75: } 67,
{ 76: } 70,
{ 77: } 70,
{ 78: } 70,
{ 79: } 70,
{ 80: } 70,
{ 81: } 70,
{ 82: } 70,
{ 83: } 71,
{ 84: } 71,
{ 85: } 71,
{ 86: } 71,
{ 87: } 71,
{ 88: } 93,
{ 89: } 115,
{ 90: } 137,
{ 91: } 138,
{ 92: } 138,
{ 93: } 138,
{ 94: } 138,
{ 95: } 138,
{ 96: } 138,
{ 97: } 139,
{ 98: } 139,
{ 99: } 139,
{ 100: } 139,
{ 101: } 139,
{ 102: } 139,
{ 103: } 140,
{ 104: } 140,
{ 105: } 140,
{ 106: } 161,
{ 107: } 162,
{ 108: } 162,
{ 109: } 162,
{ 110: } 183,
{ 111: } 183,
{ 112: } 184,
{ 113: } 184,
{ 114: } 184,
{ 115: } 184,
{ 116: } 192,
{ 117: } 192,
{ 118: } 192,
{ 119: } 194,
{ 120: } 194,
{ 121: } 194,
{ 122: } 202,
{ 123: } 210,
{ 124: } 231,
{ 125: } 231,
{ 126: } 231,
{ 127: } 252,
{ 128: } 252,
{ 129: } 252,
{ 130: } 252,
{ 131: } 252,
{ 132: } 252,
{ 133: } 252,
{ 134: } 273,
{ 135: } 273,
{ 136: } 294,
{ 137: } 294,
{ 138: } 294,
{ 139: } 294,
{ 140: } 302,
{ 141: } 310,
{ 142: } 318,
{ 143: } 326,
{ 144: } 326,
{ 145: } 334,
{ 146: } 334,
{ 147: } 334,
{ 148: } 336,
{ 149: } 337,
{ 150: } 337,
{ 151: } 337,
{ 152: } 338,
{ 153: } 338,
{ 154: } 340,
{ 155: } 340,
{ 156: } 362,
{ 157: } 362,
{ 158: } 362,
{ 159: } 362,
{ 160: } 363,
{ 161: } 363,
{ 162: } 363,
{ 163: } 363,
{ 164: } 363,
{ 165: } 363,
{ 166: } 371,
{ 167: } 379,
{ 168: } 380,
{ 169: } 380,
{ 170: } 380,
{ 171: } 380,
{ 172: } 381,
{ 173: } 382,
{ 174: } 383,
{ 175: } 385,
{ 176: } 394,
{ 177: } 394,
{ 178: } 394,
{ 179: } 394,
{ 180: } 394,
{ 181: } 394,
{ 182: } 394,
{ 183: } 394,
{ 184: } 394,
{ 185: } 394,
{ 186: } 394,
{ 187: } 394,
{ 188: } 395,
{ 189: } 395,
{ 190: } 395,
{ 191: } 395,
{ 192: } 395,
{ 193: } 395,
{ 194: } 395,
{ 195: } 395,
{ 196: } 395,
{ 197: } 395,
{ 198: } 395,
{ 199: } 395,
{ 200: } 395,
{ 201: } 396,
{ 202: } 396,
{ 203: } 396,
{ 204: } 396,
{ 205: } 396,
{ 206: } 397,
{ 207: } 418,
{ 208: } 439,
{ 209: } 439,
{ 210: } 439,
{ 211: } 439,
{ 212: } 439,
{ 213: } 460,
{ 214: } 460,
{ 215: } 460,
{ 216: } 460,
{ 217: } 469,
{ 218: } 490,
{ 219: } 490,
{ 220: } 490,
{ 221: } 511,
{ 222: } 511,
{ 223: } 511
);

yygh : array [0..yynstates-1] of Integer = (
{ 0: } 2,
{ 1: } 12,
{ 2: } 12,
{ 3: } 12,
{ 4: } 12,
{ 5: } 12,
{ 6: } 12,
{ 7: } 22,
{ 8: } 22,
{ 9: } 23,
{ 10: } 23,
{ 11: } 23,
{ 12: } 33,
{ 13: } 43,
{ 14: } 43,
{ 15: } 43,
{ 16: } 43,
{ 17: } 43,
{ 18: } 43,
{ 19: } 43,
{ 20: } 43,
{ 21: } 43,
{ 22: } 43,
{ 23: } 43,
{ 24: } 53,
{ 25: } 53,
{ 26: } 53,
{ 27: } 53,
{ 28: } 54,
{ 29: } 54,
{ 30: } 54,
{ 31: } 54,
{ 32: } 54,
{ 33: } 54,
{ 34: } 54,
{ 35: } 54,
{ 36: } 54,
{ 37: } 54,
{ 38: } 54,
{ 39: } 54,
{ 40: } 54,
{ 41: } 54,
{ 42: } 54,
{ 43: } 54,
{ 44: } 54,
{ 45: } 54,
{ 46: } 54,
{ 47: } 54,
{ 48: } 55,
{ 49: } 56,
{ 50: } 57,
{ 51: } 58,
{ 52: } 58,
{ 53: } 63,
{ 54: } 63,
{ 55: } 63,
{ 56: } 63,
{ 57: } 63,
{ 58: } 63,
{ 59: } 63,
{ 60: } 63,
{ 61: } 63,
{ 62: } 63,
{ 63: } 63,
{ 64: } 63,
{ 65: } 63,
{ 66: } 63,
{ 67: } 63,
{ 68: } 63,
{ 69: } 64,
{ 70: } 65,
{ 71: } 65,
{ 72: } 65,
{ 73: } 65,
{ 74: } 66,
{ 75: } 69,
{ 76: } 69,
{ 77: } 69,
{ 78: } 69,
{ 79: } 69,
{ 80: } 69,
{ 81: } 69,
{ 82: } 70,
{ 83: } 70,
{ 84: } 70,
{ 85: } 70,
{ 86: } 70,
{ 87: } 92,
{ 88: } 114,
{ 89: } 136,
{ 90: } 137,
{ 91: } 137,
{ 92: } 137,
{ 93: } 137,
{ 94: } 137,
{ 95: } 137,
{ 96: } 138,
{ 97: } 138,
{ 98: } 138,
{ 99: } 138,
{ 100: } 138,
{ 101: } 138,
{ 102: } 139,
{ 103: } 139,
{ 104: } 139,
{ 105: } 160,
{ 106: } 161,
{ 107: } 161,
{ 108: } 161,
{ 109: } 182,
{ 110: } 182,
{ 111: } 183,
{ 112: } 183,
{ 113: } 183,
{ 114: } 183,
{ 115: } 191,
{ 116: } 191,
{ 117: } 191,
{ 118: } 193,
{ 119: } 193,
{ 120: } 193,
{ 121: } 201,
{ 122: } 209,
{ 123: } 230,
{ 124: } 230,
{ 125: } 230,
{ 126: } 251,
{ 127: } 251,
{ 128: } 251,
{ 129: } 251,
{ 130: } 251,
{ 131: } 251,
{ 132: } 251,
{ 133: } 272,
{ 134: } 272,
{ 135: } 293,
{ 136: } 293,
{ 137: } 293,
{ 138: } 293,
{ 139: } 301,
{ 140: } 309,
{ 141: } 317,
{ 142: } 325,
{ 143: } 325,
{ 144: } 333,
{ 145: } 333,
{ 146: } 333,
{ 147: } 335,
{ 148: } 336,
{ 149: } 336,
{ 150: } 336,
{ 151: } 337,
{ 152: } 337,
{ 153: } 339,
{ 154: } 339,
{ 155: } 361,
{ 156: } 361,
{ 157: } 361,
{ 158: } 361,
{ 159: } 362,
{ 160: } 362,
{ 161: } 362,
{ 162: } 362,
{ 163: } 362,
{ 164: } 362,
{ 165: } 370,
{ 166: } 378,
{ 167: } 379,
{ 168: } 379,
{ 169: } 379,
{ 170: } 379,
{ 171: } 380,
{ 172: } 381,
{ 173: } 382,
{ 174: } 384,
{ 175: } 393,
{ 176: } 393,
{ 177: } 393,
{ 178: } 393,
{ 179: } 393,
{ 180: } 393,
{ 181: } 393,
{ 182: } 393,
{ 183: } 393,
{ 184: } 393,
{ 185: } 393,
{ 186: } 393,
{ 187: } 394,
{ 188: } 394,
{ 189: } 394,
{ 190: } 394,
{ 191: } 394,
{ 192: } 394,
{ 193: } 394,
{ 194: } 394,
{ 195: } 394,
{ 196: } 394,
{ 197: } 394,
{ 198: } 394,
{ 199: } 394,
{ 200: } 395,
{ 201: } 395,
{ 202: } 395,
{ 203: } 395,
{ 204: } 395,
{ 205: } 396,
{ 206: } 417,
{ 207: } 438,
{ 208: } 438,
{ 209: } 438,
{ 210: } 438,
{ 211: } 438,
{ 212: } 459,
{ 213: } 459,
{ 214: } 459,
{ 215: } 459,
{ 216: } 468,
{ 217: } 489,
{ 218: } 489,
{ 219: } 489,
{ 220: } 510,
{ 221: } 510,
{ 222: } 510,
{ 223: } 510
);

yyr : array [1..yynrules] of YYRRec = (
{ 1: } ( len: 0; sym: -36 ),
{ 2: } ( len: 2; sym: -7 ),
{ 3: } ( len: 2; sym: -35 ),
{ 4: } ( len: 1; sym: -35 ),
{ 5: } ( len: 1; sym: -35 ),
{ 6: } ( len: 3; sym: -35 ),
{ 7: } ( len: 2; sym: -35 ),
{ 8: } ( len: 2; sym: -35 ),
{ 9: } ( len: 2; sym: -35 ),
{ 10: } ( len: 0; sym: -40 ),
{ 11: } ( len: 4; sym: -39 ),
{ 12: } ( len: 1; sym: -32 ),
{ 13: } ( len: 1; sym: -32 ),
{ 14: } ( len: 1; sym: -32 ),
{ 15: } ( len: 1; sym: -33 ),
{ 16: } ( len: 1; sym: -33 ),
{ 17: } ( len: 1; sym: -33 ),
{ 18: } ( len: 1; sym: -33 ),
{ 19: } ( len: 1; sym: -34 ),
{ 20: } ( len: 1; sym: -34 ),
{ 21: } ( len: 1; sym: -34 ),
{ 22: } ( len: 1; sym: -34 ),
{ 23: } ( len: 1; sym: -38 ),
{ 24: } ( len: 2; sym: -38 ),
{ 25: } ( len: 1; sym: -41 ),
{ 26: } ( len: 2; sym: -41 ),
{ 27: } ( len: 2; sym: -41 ),
{ 28: } ( len: 2; sym: -41 ),
{ 29: } ( len: 2; sym: -41 ),
{ 30: } ( len: 2; sym: -41 ),
{ 31: } ( len: 2; sym: -41 ),
{ 32: } ( len: 7; sym: -41 ),
{ 33: } ( len: 7; sym: -41 ),
{ 34: } ( len: 5; sym: -41 ),
{ 35: } ( len: 5; sym: -41 ),
{ 36: } ( len: 2; sym: -41 ),
{ 37: } ( len: 2; sym: -41 ),
{ 38: } ( len: 2; sym: -41 ),
{ 39: } ( len: 1; sym: -2 ),
{ 40: } ( len: 1; sym: -6 ),
{ 41: } ( len: 1; sym: -6 ),
{ 42: } ( len: 1; sym: -6 ),
{ 43: } ( len: 1; sym: -3 ),
{ 44: } ( len: 1; sym: -3 ),
{ 45: } ( len: 1; sym: -3 ),
{ 46: } ( len: 1; sym: -16 ),
{ 47: } ( len: 1; sym: -17 ),
{ 48: } ( len: 1; sym: -17 ),
{ 49: } ( len: 0; sym: -10 ),
{ 50: } ( len: 1; sym: -10 ),
{ 51: } ( len: 0; sym: -42 ),
{ 52: } ( len: 0; sym: -43 ),
{ 53: } ( len: 8; sym: -15 ),
{ 54: } ( len: 2; sym: -29 ),
{ 55: } ( len: 2; sym: -29 ),
{ 56: } ( len: 2; sym: -29 ),
{ 57: } ( len: 3; sym: -29 ),
{ 58: } ( len: 3; sym: -29 ),
{ 59: } ( len: 3; sym: -29 ),
{ 60: } ( len: 1; sym: -13 ),
{ 61: } ( len: 2; sym: -13 ),
{ 62: } ( len: 2; sym: -13 ),
{ 63: } ( len: 1; sym: -14 ),
{ 64: } ( len: 3; sym: -14 ),
{ 65: } ( len: 1; sym: -18 ),
{ 66: } ( len: 1; sym: -18 ),
{ 67: } ( len: 1; sym: -18 ),
{ 68: } ( len: 1; sym: -18 ),
{ 69: } ( len: 1; sym: -18 ),
{ 70: } ( len: 2; sym: -19 ),
{ 71: } ( len: 3; sym: -19 ),
{ 72: } ( len: 1; sym: -9 ),
{ 73: } ( len: 3; sym: -9 ),
{ 74: } ( len: 2; sym: -5 ),
{ 75: } ( len: 1; sym: -11 ),
{ 76: } ( len: 2; sym: -11 ),
{ 77: } ( len: 0; sym: -8 ),
{ 78: } ( len: 1; sym: -8 ),
{ 79: } ( len: 3; sym: -8 ),
{ 80: } ( len: 4; sym: -25 ),
{ 81: } ( len: 3; sym: -21 ),
{ 82: } ( len: 1; sym: -21 ),
{ 83: } ( len: 1; sym: -21 ),
{ 84: } ( len: 1; sym: -21 ),
{ 85: } ( len: 4; sym: -21 ),
{ 86: } ( len: 1; sym: -21 ),
{ 87: } ( len: 1; sym: -21 ),
{ 88: } ( len: 3; sym: -21 ),
{ 89: } ( len: 1; sym: -24 ),
{ 90: } ( len: 1; sym: -24 ),
{ 91: } ( len: 4; sym: -24 ),
{ 92: } ( len: 1; sym: -24 ),
{ 93: } ( len: 4; sym: -24 ),
{ 94: } ( len: 1; sym: -24 ),
{ 95: } ( len: 4; sym: -24 ),
{ 96: } ( len: 3; sym: -24 ),
{ 97: } ( len: 1; sym: -22 ),
{ 98: } ( len: 1; sym: -22 ),
{ 99: } ( len: 3; sym: -27 ),
{ 100: } ( len: 3; sym: -27 ),
{ 101: } ( len: 3; sym: -27 ),
{ 102: } ( len: 2; sym: -27 ),
{ 103: } ( len: 3; sym: -27 ),
{ 104: } ( len: 2; sym: -27 ),
{ 105: } ( len: 2; sym: -27 ),
{ 106: } ( len: 3; sym: -27 ),
{ 107: } ( len: 1; sym: -37 ),
{ 108: } ( len: 0; sym: -45 ),
{ 109: } ( len: 2; sym: -20 ),
{ 110: } ( len: 2; sym: -20 ),
{ 111: } ( len: 2; sym: -20 ),
{ 112: } ( len: 1; sym: -20 ),
{ 113: } ( len: 2; sym: -20 ),
{ 114: } ( len: 3; sym: -20 ),
{ 115: } ( len: 3; sym: -20 ),
{ 116: } ( len: 1; sym: -20 ),
{ 117: } ( len: 2; sym: -20 ),
{ 118: } ( len: 1; sym: -20 ),
{ 119: } ( len: 2; sym: -20 ),
{ 120: } ( len: 4; sym: -30 ),
{ 121: } ( len: 4; sym: -30 ),
{ 122: } ( len: 6; sym: -30 ),
{ 123: } ( len: 3; sym: -31 ),
{ 124: } ( len: 3; sym: -31 ),
{ 125: } ( len: 1; sym: -26 ),
{ 126: } ( len: 2; sym: -26 ),
{ 127: } ( len: 1; sym: -26 ),
{ 128: } ( len: 5; sym: -28 ),
{ 129: } ( len: 7; sym: -28 ),
{ 130: } ( len: 5; sym: -28 ),
{ 131: } ( len: 2; sym: -28 ),
{ 132: } ( len: 3; sym: -28 ),
{ 133: } ( len: 3; sym: -28 )
);

// source: C:\Users\Gazda\Documents\RAD Studio\Projects\szakdoli\src\dyacclex-1.4\src\yacc\yyparse.cod line# 33

const _error = 256; (* error token *)

function yyact(state, sym : Integer; var act : Integer) : Boolean;
  (* search action table *)
  var k : Integer;
  begin
    k := yyal[state];
    while (k<=yyah[state]) and (yya[k].sym<>sym) do inc(k);
    if k>yyah[state] then
      yyact := false
    else
      begin
        act := yya[k].act;
        yyact := true;
      end;
  end(*yyact*);

function yygoto(state, sym : Integer; var nstate : Integer) : Boolean;
  (* search goto table *)
  var k : Integer;
  begin
    k := yygl[state];
    while (k<=yygh[state]) and (yyg[k].sym<>sym) do inc(k);
    if k>yygh[state] then
      yygoto := false
    else
      begin
        nstate := yyg[k].act;
        yygoto := true;
      end;
  end(*yygoto*);

function yycharsym(i : Integer) : String;
begin
  if (i >= 1) and (i <= 255) then
    begin
      if i < 32 then
        begin
          if i = 9 then
            Result := #39'\t'#39
          else if i = 10 then
            Result := #39'\f'#39
          else if i = 13 then
            Result := #39'\n'#39
          else
            Result := #39'\0x' + IntToHex(i,2) + #39;
        end
      else
        Result := #39 + Char(i) + #39;
      Result := ' literal ' + Result;
    end
  else
    begin
      if i < -1 then
        Result := ' unknown'
      else if i = -1 then
        Result := ' token $accept'
      else if i = 0 then
        Result := ' token $eof'
      else if i = 256 then
        Result := ' token $error'
{$ifdef yyextradebug}
      else if i <= yymaxtoken then
        Result := ' token ' + yytokens[yychar].tokenname
      else
        Result := ' unknown token';
{$else}
      else
        Result := ' token';
{$endif}
    end;
  Result := Result + ' ' + IntToStr(yychar);
end;

label parse, next, error, errlab, shift, reduce, accept, abort;

begin(*yyparse*)

  (* initialize: *)

  yystate := 0; yychar := -1; yynerrs := 0; yyerrflag := 0; yysp := 0;
  yyInput := InputText; yyclear;

parse:

  (* push state and value: *)

  inc(yysp);
  if yysp>yymaxdepth then
    begin
      yyerror('yyparse stack overflow');
      goto abort;
    end;
  yys[yysp] := yystate; yyv[yysp] := yyval;

next:

  if (yyd[yystate]=0) and (yychar=-1) then
    (* get next symbol *)
    begin
      yychar := lexer.parse(); if yychar<0 then yychar := 0;
    end;

  {$IFDEF YYDEBUG}writeln('state ', yystate, yycharsym(yychar));{$ENDIF}

  (* determine parse action: *)

  yyn := yyd[yystate];
  if yyn<>0 then goto reduce; (* simple state *)

  (* no default action; search parse table *)

  if not yyact(yystate, yychar, yyn) then goto error
  else if yyn>0 then                      goto shift
  else if yyn<0 then                      goto reduce
  else                                    goto accept;

error:

  (* error; start error recovery: *)

  if yyerrflag=0 then yyerror('syntax error: ' + yyLine);

errlab:

  if yyerrflag=0 then inc(yynerrs);     (* new error *)

  if yyerrflag<=2 then                  (* incomplete recovery; try again *)
    begin
      yyerrflag := 3;
      (* uncover a state with shift action on error token *)
      while (yysp>0) and not ( yyact(yys[yysp], _error, yyn) and
                               (yyn>0) ) do
        begin
          {$IFDEF YYDEBUG}
            if yysp>1 then
              writeln('error recovery pops state ', yys[yysp], ', uncovers ',
                      yys[yysp-1])
            else
              writeln('error recovery fails ... abort');
          {$ENDIF}
          dec(yysp);
        end;
      if yysp=0 then goto abort; (* parser has fallen from stack; abort *)
      yystate := yyn;            (* simulate shift on error *)
      goto parse;
    end
  else                                  (* no shift yet; discard symbol *)
    begin
      {$IFDEF YYDEBUG}writeln('error recovery discards ' + yycharsym(yychar));{$ENDIF}
      if yychar=0 then goto abort; (* end of input; abort *)
      yychar := -1; goto next;     (* clear lookahead char and try again *)
    end;

shift:

  (* go to new state, clear lookahead character: *)

  yystate := yyn; yychar := -1; yyval := yylval;
  if yyerrflag>0 then dec(yyerrflag);

  goto parse;

reduce:

  (* execute action, pop rule from stack, and go to next state: *)

  {$IFDEF YYDEBUG}writeln('reduce ' + IntToStr(-yyn) {$IFDEF YYEXTRADEBUG} + ' rule ' + yyr[-yyn].symname {$ENDIF});{$ENDIF}

  yyflag := yyfnone; yyaction(-yyn);
  dec(yysp, yyr[-yyn].len);
  if yygoto(yys[yysp], yyr[-yyn].sym, yyn) then yystate := yyn;

  (* handle action calls to yyaccept, yyabort and yyerror: *)

  case yyflag of
    yyfaccept : goto accept;
    yyfabort  : goto abort;
    yyferror  : goto errlab;
  end;

  goto parse;

accept:

  Result := 0; exit;

abort:

  Result := 1; exit;

end(*yyparse*);


{***************************** INITIALIZATION | prolang.y *******************************}


{$I prolanlex.pas}

initialization

 { .. nope .. }

end.