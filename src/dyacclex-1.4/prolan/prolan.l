D	[0-9]
L	[A-Za-z]
A	[/]
B	[*]
C	[^/*]

%%
_			return(_BLANK);
letter		return(_LETTER);
term		return(_TERM);
nterm		return(_NTERM);
start		return(_START);
void		return(_VOID);
bool		return(_BOOL);
false		return(_FALSE);
true		return(_TRUE);
return		return(_RETURN);
accept		return(_ACCEPT);
print		return(_PRINT);
exit		return(_EXIT);	
else		return(_ELSE);			
if			return(_IF);
try			return(_TRY);
all			return(_ALL);
while		return(_WHILE);		
goto		return(_GOTO);	
"||"		return(_OR);
"|"			return(_FORK);
&&			return(_AND);	
!			return(_NOT);	
==			return(_EQUAL);
eps			return(_EPSILON);
right		return(_RIGHT);
left		return(_LEFT);
stand		return(_STAND);
input		return(_INPUT);
state		return(_STATE);
"#pragma"	return(_PRAGMA);
turing		return(_TURING);
grammar		return(_GRAMMAR);
pgrammar	return(_PGRAMMAR);
pushdown	return(_PUSHDOWN);
epushdown	return(_EPUSHDOWN);
lindenmayer	return(_LINDENMAYER);
rule		return(_RULE);
position	return(_POSITION);
random		return(_RANDOM);
hide		return(_HIDE);
show		return(_SHOW);
determ		return(_DETERM);
deadend		return(_DEADEND);
list		return(_LIST);
tree		return(_TREE);
lang		return(_LANG);
leftmost	return(_LEFTMOST);
rightmost	return(_RIGHTMOST);
print		return(_PRINT);
printmode	return(_PRINTMODE);
color		return(_COLOR);
"*"			return(_STAR);
";;"		return(_NEXT);
";"			return(_END);
some		return(_SOME);
"."			return(_MINUS);
"&"			return(_AND2);

({L}|{D})*				begin
							yylval.yyShortString := yytext;
							return(IDENT);
						end;

[0-9]+                  begin
							yylval.yyInteger := StrToInt(yytext);
							return(NUMBER);
						end;

\"[^"]*\"				begin
							yylval.yyShortString := ExtractFileName(copy(yytext, 2, length(yytext) - 2));
							return(_STRING);
						end;
						
						
[ \n\t\f]               ;
{A}({A}.*|{B}({A}|{C}|{B}+{C})*{B}+{A})		;

.                       begin 
							{ FErrorMsg := 'Lexikális hiba: ' + yytext + ' sor: ' + IntToStr(yylineno);} 
							returnc(yytext[1]); 
						end;