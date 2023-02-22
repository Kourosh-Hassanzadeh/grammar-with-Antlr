grammar Midterm;

start: include* classdefining+;
//using lib
include:  Name (',' Name)* '=' ((type1 | type2 | type3)(',')?)+ SemiColon;
type1: Require '<' Name '>' ;
type2: From '<' Name '>' Require '<' Name '>';
type3: From '<' Name '>' '=>' '<' Name '>';

//variable
variabledifining: AccessLevel? Type? (normal | array | accessindex) SemiColon;
normal: Datatype Name (('=' expression)?)(',' (Name ('=' expression)?)?)*;
array: Datatype Name'[]' '=' (('new' Datatype '[' Value? ']') | ('[' Value? (','Value)* ']') | '[]');
accessindex: '='? Name? ('[' (Value (','Value)*) ']')+ | '[]' SemiColon?;
//...........................................

//class
classdefining: Class Name (OP Name CP)? (Implements Name (',' Name)*)? Begin (body | costructor)* End;
costructor: Name OP (Datatype Name)? (',' Datatype Name)* CP Begin code* End;
this: This '.' Name ('=' Name SemiColon)?;
//...........................................

//function
function: Datatype Name OP (Datatype Name ('=' Value)? (',' Datatype Name ('=' Value)?)*)? CP Begin code* return End;
callfunction: Name ('.' Name)* OP* ((accessindex | expression | Value | Name | (Name('.'Name)+) )(',' (accessindex | expression | Value |  Name | (Name ('.'Name)+) ))*)* CP* SemiColon?;
//...........................................
objectdefining: AccessLevel? Type?  (Name Name '='?)?( 'new'? (Name (OP ( (objectdefining | Value|Name) (',' (objectdefining | Value | Name))*)? CP )) | Null)? SemiColon*;

//if
ifstatement:( If OP (expression | callfunction) CP Begin code+ End (Else_if OP (expression | callfunction) CP Begin code* End)* (Else Begin code* End)? );
//...........................................

//for
for: For ((OP Datatype? Name '=' Value SemiColon expression+ (SemiColon pp_mm)?) CP | (Name In Name))  Begin code* End;
//............................................

//while
while: While expression Begin code* End;
do_while: Do Begin code* End While OP expression CP;
//.............................................

//switch-case
switch: Switch expression Begin (Case Value ':' code* (Break SemiColon)?)+ (Default ':' code* (Break SemiColon)?)? End;
//............................................

//exeption
try: Try Begin code* End Catch OP Name (',' Name)* CP Begin code* End;

//...........................................
code: this | ifstatement | callfunction| expression SemiColon| return | for |while | do_while | switch | try | objectdefining SemiColon| variabledifining | accessindex;
body: objectdefining SemiColon| variabledifining | function | code;
return: Return expression SemiColon;

//expression
expression: OP expression CP
 |expression '?' expression ':' expression
 |callfunction
 | expression '**' expression
 | '~' expression
 | pp_mm
 | expression ('*' | '/' | '%' | '//') expression
 | expression ('+' | '-') expression
 | expression ('<<' | '>>') expression
 | expression ('&' | '^' | '|') expression
 | expression ('==' | '!=' | '<>') expression
 | expression ('<' | '>' | '<=' | '>=') expression
 | expression ('not' | (( 'and' | 'or' | '||' | '&&')expression))
 | expression ('=' | '+=' | '-=' | '*=' | '/=' | '%=') expression
 | (('+'|'-')? Value | Name |this);
pp_mm: ('++'|'--') Name | Name ('++' | '--');
//...........................................

//lexer
fragment ESC: '\\' [btnr"\\] ;
Null: 'Null';
Value: (Int | String | Double | Char | Float | Bool | ScientificSymbol | Null);
Digits: [0-9];
Type: 'const';
Require: 'require';
From: 'from';
Class: 'class';
This: 'this';
Implements:'implements';
For:'for';
While: 'while';
Do: 'do';
If: 'if';
Else: 'else';
Else_if: 'else if';
Break: 'break';
Default: 'default';
Switch: 'switch';
Case: 'case';
Return: 'return';
In: 'in';
Try: 'try';
Catch: 'catch';
Double: Digits+('.'Digits+);
Float: Digits+('.'Digits+);
Bool: ('true' | 'false');
String: '"'  (ESC | . )*? '"';
Character: ([a-zA-Z] | '_' | '$');
Char: '\'' Character '\'';
Int: ([0] | [1-9]Digits*);
ScientificSymbol: Digits+ | (Digits ('.' Digits+)? 'e' ('+' | '-')? Int);
AccessLevel: ('public' | 'private');
Begin: 'begin';
End: 'end';
OP: '(';
CP: ')';
SemiColon: ';';
Datatype: ('bool' | 'int' | 'char' | 'string' | 'double' | 'float');
Name: Character (Character | Digits)+;
WS: [ \t\r\n] -> skip;
LineComment: '#' .*? '\n' -> skip;
Comment: '/*' .*? '*/' -> skip;