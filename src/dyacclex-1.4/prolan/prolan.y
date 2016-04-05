/***************************************************************************/
/*                                                                         */
/*                        Prolan 1.0  Parser                               */
/*                               2010.                                     */
/*                   Programmed by Sebestyén Balázs                        */
/*                                                                         */
/***************************************************************************/

%{

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

%}

/* token defs. */

%token <shortString>
	IDENT
	'(' ')' '{' '}' '<' '>' ',' _END '.'
	_LETTER _TERM _NTERM _VOID _BOOL _START
	'+' '-' '*' '/' '^' _STRING
	
%token
	_FALSE _TRUE _RETURN _EXIT _ACCEPT _ELSE _GOTO
	_IF _WHILE _TRY _AND _AND2 _OR _FORK _NOT _STAR _EQUAL _ALL _EPSILON _BLANK _NEXT _END _SOME
	_RIGHT _LEFT _STAND _PRINT _INPUT _STATE _PRAGMA
	_TURING _GRAMMAR _PGRAMMAR _PUSHDOWN _EPUSHDOWN _LINDENMAYER
	_RULE _POSITION _FIRST _LAST _RANDOM
	_HIDE _SHOW _DETERM _DEADEND _COLOR
	_LIST _TREE _LANG
	_LEFTMOST _RIGHTMOST _PRINT _PRINTMODE

%token <integer>
	NUMBER
	
%type <TObject> id labid declar paradec
%type <TSLetter> letterid
%type <TSProgram> prog
%type <TList> idlist paralist params letterlist leftside comlist labidlist
%type <TSFunction> func funcid
%type <TSFuncType> ftype
%type <TClass> type declist
%type <TSCommand> com exp ifexp nexp 
%type <TSLine> linecom call
%type <TSGoto> goto
%type <TSNode> nodeexp nodecom
%type <TSLabel> labid
%type <TSBlock> block
%type <TSIf> statetail state
%type <TViewType> viewtype
%type <TFindMode> findmode
%type <TSwitch> switch

/* precedentation */

%nonassoc IFX
%nonassoc _ELSE
%left _END
%nonassoc _COMBLOCK
%nonassoc _EXPBLOCK

%nonassoc COMX
%left _FORK
%left _OR
%left _AND2
%left _AND
%right _NOT
%right _SOME
%left _STAR
%left _MINUS

%%

%{
{***************************** RULES BEGIN | prolan.y *******************************}
%}



/********* main **************************************************************/

prog		: {
				GTable := GProgram.Table;
				GShow := 1;
			} progbody
			;
			
progbody	: declist endsign
			| preproc2
			| func			
			| declist endsign progbody 
			| preproc2 progbody
			| func progbody
			| error progbody {merror(1, '')}
			;

lm1			: {FLine := yylineno} '#' IDENT _STRING { FLine := FLine - StrToInt($3) + 1; FFileName := $4; } 
			;
	
viewtype :	_LIST { $$ := vtList; }
			| _TREE { $$ := vtTree; } 
			| _LANG { $$ := vtSet; }
			;
			
findmode:	_LEFT { $$ := fmFirst; }
			| _RIGHT { $$ := fmLast; }
			| _ALL { $$ := fmALL; }
			| _RANDOM { $$ := fmRandom; }
			;
	
switch:		_COLOR { $$ := swColors; }
			| _DETERM { $$ := swDeterm; }
			| _DEADEND { $$ := swDeadend; }
			| _ALL { $$ := swAll; }
			;

preproc2:	preproc
			| lm1 IDENT
			;
			
preproc: 	lm1
			| _PRAGMA _PGRAMMAR { GProgram.ProgType := ptGrammar; }
			| _PRAGMA _GRAMMAR 
			{
				GProgram.ProgType := ptGrammar; 
				GProgram.Show(false, swDeadEnd);
			}
			| _PRAGMA _TURING { GProgram.ProgType := ptTuring; }
			| _PRAGMA _PUSHDOWN { GProgram.ProgType := ptPushDown; }
			| _PRAGMA _EPUSHDOWN { GProgram.ProgType := ptEPushDown; }
			| _PRAGMA _LINDENMAYER 
			{ 
				GProgram.ProgType := ptGrammar; 
				// GShow := 0;
				// GPRintMode := true;
				GProgram.Show(false, swDeterm);
				GProgram.Show(false, swColors);
				GProgram.Choice[vtList, ctPos] := fmFirst;
				GProgram.Choice[vtSet, ctPos] := fmFirst;
				GProgram.Choice[vtTree, ctPos] := fmFirst;
			}
			| _PRAGMA _POSITION '(' viewtype ',' findmode ')' { GProgram.Choice[$4, ctPos] := $6; }
			| _PRAGMA _RULE     '(' viewtype ',' findmode ')' { GProgram.Choice[$4, ctRule] := $6; }
			| _PRAGMA _HIDE '(' switch ')' { if $4 = swAll then GShow := 0 else GProgram.Show(false, $4); }
			| _PRAGMA _SHOW '(' switch ')' { if $4 = swAll then GShow := 1 else GProgram.Show(true, $4); }
			| _PRAGMA _LEFTMOST 
			{ 
				GProgram.Choice[vtList, ctPos] := fmFirst;
				GProgram.Choice[vtSet,  ctPos] := fmFirst;
				GProgram.Choice[vtTree, ctPos] := fmFirst;
			}
			| _PRAGMA _RIGHTMOST
			{ 
				GProgram.Choice[vtList, ctPos] := fmLast;
				GProgram.Choice[vtSet,  ctPos] := fmLast;
				GProgram.Choice[vtTree, ctPos] := fmLast;
			}
			| _PRAGMA _PRINTMODE { GPRintMode := true; GShow := 0; }
			; 
			
id			: IDENT
			{
				$$ := GTable.Find($1);
				if $$ = nil then
					merror(3, $1);
			}
			;
			
letterid	: IDENT
			{
				$$ := TSLetter(GTable.Find($1, TSLetter));
				if $$ = nil then
					merror(4, $1);
			}
			| _EPSILON
			{
				$$ := TSLetter(GTable.Find('eps', TSLetter));
				if $$ = nil then
					merror(5, 'eps');
			}
			| _BLANK { $$ := TSLetter(GTable.Find('_')); }
			;

labid		: IDENT
			{
				$$ := TSLabel(GTable.Find($1, TSLabel));
				if $$ = nil then
					$$ := TSLabel(Declare($1, TSLabel, false));
			}
			| _EXIT
			{
				$$ := TSLabel(GTable.Find('exit', TSLabel)); 
			}
			| _ACCEPT
			{
				$$ := TSLabel(GTable.Find('accept', TSLabel)); 
			}
			;
			
funcid		: IDENT
			{
				$$ := TSFunction(GTable.Find($1, TSFunction));
				if $$ = nil then
					merror(6, $1);
			}
			;

ftype	:	_VOID { $$ := ftVoid; }
			| _BOOL { $$ := ftBool; }
			;	
		
params		: { $$ := TList.Create; }
			| paralist
			;
		
func		: ftype IDENT 
			{
				$$ := TSFunction(Declare($2, TSFunction, false));
				$$.FuncType := $1;
				GFunc := $$;
				PushTable;
				GTable.IsFuncTable := true;
			}
			'(' params ')' 
			{
				if GFunc <> nil then
				begin
					GProgram.Add(GFunc);
					GFunc.Params := $5;
					$5.Free;
				end;
			}
			block
			{
				GFunc.Add($8);
				$8.Table := GTable;
				PopTable;
			}
			;
			
block		: 
			'{' '}' 
			{
				$$ := TSSeqBlock.Create;
				$$.Table := GTable;
				$$.Add(TSSkip.Create);
			}
			|
			'[' ']' 
			{
				$$ := TSParBlock.Create;
				$$.Table := GTable;
				$$.Add(TSSkip.Create);
			}
			|
			'<' '>' 
			{
				$$ := TSForkBlock.Create;
				$$.Table := GTable;
				$$.Add(TSSkip.Create);
			}
			|
			'{' comlist '}' 
			{ 
				$$ := TSSeqBlock.Create; 
				$$.AssignChildren($2);
				$2.Free;
				$$.Table := GTable;
			} 
			| '[' comlist ']'
			{
				$$ := TSParBlock.Create;
				$$.AssignChildren($2);
				$2.Free;
				$$.Table := GTable;
			} 
			| '<' comlist '>'
			{
				$$ := TSForkBlock.Create;
				$$.AssignChildren($2);
				$2.Free;
				$$.Table := GTable;
			} 
			;

comlist		: com { nlist($$, $1); } 
			| comlist com { alist($$, $1, $2); }
			| comlist error { merror(7, ''); }
			;

labidlist	: labid { nlist($$, $1); }
			| labidlist ',' labid { alist($$, $1, $3); }
			;
			
type		: _TERM { $$ := TSTerm; }
			| _NTERM { $$ := TSNTerm; }
			| _START { $$ := TSStart; }
			| _LETTER { $$ := TSLetter; }
			| _LABEL { $$ := TSLabel; }
			;		
			
declist		: type IDENT
			{
				$$ := $1;
				Declare($2, $1, true);
			}
			| declist ',' IDENT
			{
				$$ := $1;
				Declare($3, $1, true);
			}
			;
			
paralist	: paradec { nlist($$, $1); }
			| paralist ',' paradec { alist($$, $1, $3); }
			;			
			
paradec		: type IDENT { $$ := Declare($2, $1, false); }
			;

letterlist	: letterid { nlist($$, $1); }
			| letterlist letterid { alist($$, $1, $2); }
			;
			
idlist		: { $$ := TList.Create; }
			| id { nlist($$, $1); }
			| idlist ',' id { alist($$, $1, $3); }
			;
	
call		: funcid '(' idlist ')'
			{
				if ($1 <> nil) and ($3 <> nil) then
					if $1.CheckPara($3) then
					begin
						$$ := TSCall.Create($1, $3);
						$$.LineInfo(CurLine, FFileName);
						$3.Free;
					end
					else
						merror(8, $1.Name);
			}
			;
			
exp			: '(' ifexp ')' { $$ := $2; }
			| nodeexp { $$ := $1; }
			| _TRUE { $$ := TSTrue.Create; }
			| _FALSE { $$ := TSFalse.Create; }
			| _INPUT '(' letterlist ')' { GProgram.Input.Assign($3); $3.Free; }
			| linecom { $$ := $1; }
			| _PRINT
			{
				if GPrintMode then
				begin
					$$ := TSIf.Create; 
					case GProgram.ProgType of
						ptGrammar: 
							TSGRule(TSIf($$).Add(TSGRule.MakePrint)).LineInfo(CurLine, FFileName);
						ptPushDown, ptEPushDown: 
							TSSLine(TSIf($$).Add(TSSLine.MakePrint)).LineInfo(CurLine, FFileName);
						ptTuring:
							TSTLine(TSIf($$).Add(TSTLine.MakePrint)).LineInfo(CurLine, FFileName);
					end;
					TSIf($$).Add(TSSkip.Create);
				end
				else
					$$ := TSSkip.Create;
			}

			| '(' com ')' { $$ := $2; }
/*
			| {
				PushTable; 
				if GFunc <> nil then
					GFunc.AddTable(GTable);
			} '?' block { PopTable; $$ := $3; }				
*/
			;
			
linecom		: call { $$ := $1; }
			| _RIGHT { $$ := TSBLine.Create(nil, tdRight); $$.LineInfo(CurLine, FFileName, GShow); }
			| _RIGHT '(' letterid ')' { $$ := TSBLine.Create($3, tdRight); $$.LineInfo(CurLine, FFileName, GShow); }
			| _LEFT { $$ := TSBLine.Create(nil, tdLeft); $$.LineInfo(CurLine, FFileName, GShow); }
			| _LEFT '(' letterid ')' { $$ := TSBLine.Create($3, tdLeft); $$.LineInfo(CurLine, FFileName, GShow); }
			| _STAND { $$ := TSBLine.Create(nil, tdStand); $$.LineInfo(CurLine, FFileName, GShow); }
			| _STAND '(' letterid ')' { $$ := TSBLine.Create($3, tdStand); $$.LineInfo(CurLine, FFileName, GShow); }
			| letterlist '=' letterlist
			{
				if GProgram.ProgType = ptGrammar then
				begin
					$$ := TSGRule.Create($1, $3); $1.Free; $3.Free;
					$$.LineInfo(CurLine, FFileName, GShow);
				end
				else if GProgram.ProgType in [ptPushDown, ptEPushDown] then 
				begin
					$$ := TSSLine.Create($1, $3); $1.Free; $3.Free;
					$$.LineInfo(CurLine, FFileName, GShow);
				end;
			}
			;
			
ifexp		: exp { $$ := $1; }
			| letterid { $$ := TSALine.Create($1); $$.LineInfo(CurLine, FFileName, GShow); }
			;
			
nodeexp		: ifexp _AND ifexp { $$ := TSAnd.Create; $$.Add($1); $$.Add($3); }
			| ifexp _AND2 ifexp { $$ := TSSeqBlock.Create; $$.Add($1); $$.Add($3); $$.Add(TSSkip.Create); }
			| ifexp _OR ifexp {	$$ := TSOr.Create; $$.Add($1); $$.Add($3); }
			| _NOT ifexp { $$ := TSNot.Create; $$.Add($2); }
			| ifexp _FORK ifexp { $$ := TSFork.Create; $$.Add($1); $$.Add($3); }
			| ifexp _STAR { 
				Node := TSFork.Create; Node.Add($1); Node.Add(TSFalse.Create);
				$$ := TSWhile.Create; $$.Add(Node); $$.Add(TSSkip.Create); 
			}
			| ifexp _MINUS { 
				$$ := TSAnd.Create; TSAnd($$).Add($1); TSAnd($$).Add(TSBLine.Create(nil, tdRight));
				TSAnd($$)[1].LineInfo(CurLine, FFileName, GShow);
			}
			| ifexp _MINUS ifexp { 	
				Node := TSAnd.Create; Node.Add($1); Node.Add(TSBLine.Create(nil, tdRight)); Node[1].LineInfo(CurLine, FFileName, GShow);
				$$ := TSSeqBlock.Create; $$.Add(Node); $$.Add($3); $$.Add(TSSkip.Create);
			}
			;
			
endsign		: _END;
			
com			: {
				PushTable; 
				if GFunc <> nil then
					GFunc.AddTable(GTable);
			} block { PopTable; $$ := $2; }
			| exp _END { $$ := $1; }
			| declist endsign { $$ := nil; }
			| nodecom { $$ := $1; }
			| goto endsign { $$ := $1; }
			| labid ':' com { $$ := $3; $$.Lab := $1; $1.Command := $$;	}
			| labid ':' endsign { $$ := TSSkip.Create; $$.Lab := $1; $1.Command := $$;	}
			| state { $$ := $1; }
			| error endsign { merror(7, ''); }
			| preproc { $$ := TSSkip.Create; }
			| _SOME com {
				Node := TSFork.Create; Node.Add(TSSeqBlock.Create); Node.Add(TSFalse.Create); 
				$$ := TSWhile.Create; TSWhile($$).Add(Node); TSWhile($$).Add(TSSkip.Create); 
				Node := TSSeqBlock(Node[0]); Node.Add($2); Node.Add(TSSkip.Create);
			}
			;
			
statetail	: ifexp ':' com statetail 		{ $$ := TSIf.Create; $$.Add($1); $$.Add($3); $$.Add($4); }
			| ifexp ':' com '}'		  		{ $$ := TSIf.Create; $$.Add($1); $$.Add($3); $$.Add(TSFalse.Create); }
			| ifexp ':' com _ELSE com '}' 	{ $$ := TSIf.Create; $$.Add($1); $$.Add($3); $$.Add($5); }
			;
			
state		: _STATE '{' statetail { $$ := $3; }
			| _STATE '{' '}' { $$ := TSIf.Create; $$.Add(TSTrue.Create); $$.Add(TSFalse.Create); }
			;
			
goto		: labidlist { $$ := TSGoto.Create($1); $$.LineInfo(CurLine, FFileName); $1.Free; } 
			| _GOTO labidlist { $$ := TSGoto.Create($2); $$.LineInfo(CurLine, FFileName); $2.Free; }
			| _RETURN
			{
				if GFunc.FuncType = ftVoid then
					begin $$ := TSGoto.Create; $$.LineInfo(CurLine, FFileName); $$.Labels.Add(GFunc.OutTrue); end
				else
					merror(9, '');	
			}
			;
			
nodecom		: _IF '(' ifexp ')' com %prec IFX {
				$$ := TSIf.Create; $$.Add($3); $$.Add($5);
			}
			| _IF '(' ifexp ')' com _ELSE com {
				$$ := TSIf.Create; $$.Add($3); $$.Add($5); $$.Add($7);
			} 
			| _WHILE '(' ifexp ')' com {
				$$ := TSWhile.Create; $$.Add($3); $$.Add($5);
			}
			| _ALL com {
				$$ := TSWhile.Create; $$.Add($2); $$.Add(TSSkip.Create);
			}
			| _TRY ifexp endsign { $$ := TSIf.Create; $$.Add($2); $$.Add(TSSkip.Create); }
			| _RETURN ifexp endsign {
				if GFunc.FuncType = ftBool then
				begin
					$$ := TSIf.Create; $$.Add($2); $$.Add(GFunc.OutTrue); $$.Add(GFunc.OutFalse);
				end
				else
					merror(9, '');	
			}
			;
			
/********* delphi ************************************************************/

%%

{***************************** INITIALIZATION | prolang.y *******************************}


{$I prolanlex.pas}

initialization

 { .. nope .. }

end.
