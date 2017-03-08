/*Lexer by Megan Lucas, Nadia Mahgerefteh and Stars Momodu*/

// ----------------------------------------------------------
// User Code
// ----------------------------------------------------------

import java.util.*

class TokenType {

	private final static int NONE 		= 0;
	private final static int IF 		= 1;
}

class Yytoken {

	Object 	value;
	int 	tokenType;
	int 	line;
	int 	column;

	public Yytoken(int tokenType) {
		this.tokenType 	= tokenType;
		this.line 		= Yyline;
		this.column 	= Yycolumn;
	}

	public Yytoken(int tokenType, Object value) {
		this.tokenType 	= tokenType;
		this.value 		= value;
		this.line 		= Yyline;
		this.column 	= Yycolumn;
	}
}

%%
// ----------------------------------------------------------
// Options and Declarations
// ----------------------------------------------------------

%class Lexer
%cup
%line
%column

// ----------------------------------------------------------
// States
// ----------------------------------------------------------

%state STATE_IF, STATE_FDEF, STATE_TDEF, STATE_COMMENT, STATE_LOOP

// ----------------------------------------------------------
// Class code
// ----------------------------------------------------------
%{
	private Stack<Integer> state_stack = new Stack<Integer>();

	public void yypushState(int newState) {
	  state_stack.push(yystate());
	  yybegin(newState);
	}

	public void yypopState() {

		state_stack.pop()
		if (state_stack.empty()) {
			yybegin(YYINITIAL)
		} else {
			yybegin(stack.peek());
		}
	}
%}

// ----------------------------------------------------------
// Regex Macros
// ----------------------------------------------------------

LineTerminator	= "\r"|"\n"|"\r\n"
WhiteSpace    	= {LineTerminator} | [ \t\f]
Semicolon		= ";"

// Literals
LiteralNull		= "null"

// Key words

KeywordDict				= "dict"
KeywordSeq				= "seq"
KeywordDataType         = {KeywordDict} | {KeywordSeq}

KeywordAlias			= "alias"
KeywordTdef				= "tdef"
KeywordFdef				= "fdef"
KeywordDeclaration 		= {KeywordAlias} | {KeywordTdef} | {KeywordFdef}

KeywordIf				= "if"
KeywordIfTerminator		= "fi"
KeywordThen				= "then"
KeywordElse				= "else"
KeywordLoop				= "loop"
KeywordLoopTerminator	= "pool"
KeywordReturn			= "return"
KeywordRead				= "read"
KeywordPrint 			= "print"
KeywordBreak			= "break"
KeywordStatement		= {KeywordIf} | {KeywordIfTerminator} | {KeywordThen} | {KeywordElse} | {KeywordLoop} | {KeywordLoopTerminator} | {KeywordReturn} | {KeywordPrint} | {KeywordBreak}
Keyword					= {LineTerminator} | {WhiteSpace} | {Semicolon} | {LiterNull} | {KeywordDataType} | {KeywordDeclaration} | {KeywordStatement}

//Paragraph 3 -----------------------------------------------
// ----------------------------------------------------------
CommentSingleLine = "#".*"\n"
CommentMultiline  = "/#" ~"#/"
Comment 		= {CommentMultiline} | {CommentSingleLine}

//Paragraph 4 -----------------------------------------------
// ----------------------------------------------------------
Identifier = (([a-z] | [A-Z]) ("_" | [0-9] | [a-z] | [A-Z])*) (!{Keyword})

//Paragraph 5 -----------------------------------------------
// ----------------------------------------------------------
DataTypeChar		= "char"
LiteralChar   		= "'([^'\\\n]|\\.)'"
LegalCharacters		= "([^'\\\n]|\\.)"			

//Paragraph 6 -----------------------------------------------
// ----------------------------------------------------------
ValueBool = "T" | "F"

//Paragraph 7 -----------------------------------------------
// ----------------------------------------------------------
DataTypeBool  = "bool"
DataTypeInt   = "int"
DataTypeRat   = "rat"
DataTypeFloat = "float"

LiteralPosInt   = "0 | [1-9][0-9]*"
LiteralInt      = "0 | -?[1-9][0-9]*"
LiteralRational = [{LiteralInt} / {LiteralPosInt}] | [{LiteralInt} _ {LiteralPosInt} / {LiteralPosInt}]
LiteralFloat    = [{LiteralInt} . {LiteralPosInt}]
LiteralNumber   = {LiteralInt} | {LiteralRational} | {LiteralFloat}

//Paragraph 8 -----------------------------------------------
// ----------------------------------------------------------
DataTypeDictionary 		= dict<{DataTypePrimitive}, {DataTypePrimitive}>
LiteralDictionary  		= "{"(({DictionaryType} : {DictionaryType})*)"}"

DataTypeTop       		= "top"
LiteralTop				= ({LiteralNumber})   

LiteralEmptyDictionary 	= "{" (^{DictionaryType}) "}"


//Paragraph 9 -----------------------------------------------
// ----------------------------------------------------------
DataTypeSequence 	= {KeywordSeq} < {DataType} >
LiteralSequence = "[" ({ArbitraryText}) ("," {ArbitraryText})* "]"        
LiteralEmptyList	= "[]"

//Paragraph 10 ----------------------------------------------
// ----------------------------------------------------------
LiteralString			= "\"" {LegalCharacters}* "\""
SequenceLengthParameter	= ".length"
ArbitraryText			= {LegalCharacters}+      

// Table 1 --------------------------------------------------
// ----------------------------------------------------------
DataTypePrimitive = {DataTypeBool} | {DataTypeInt} | {DataTypeRat} | {DataTypeFloat} | {DataTypeChar}
DataTypeAggregate = {DataTypeDictionary} | {DataTypeSequence}
DataType          = {DataTypePrimitive} | {DataTypeAggregate}

LiteralPrimitive  = {ValueBool} | {LiteralNumber} | {LiteralChar}
LiteralAggregate  = {LiteralDictionary} | {LiteralEmptyDictionary} | {LiteralEmptyList} | {LiteralSequence} | {LiteralString}
Literal           = {LiteralPrimitive} | {LiteralAggregate}             

// Table 2 --------------------------------------------------
// ----------------------------------------------------------

// boolean operators

OperatorNot		= "!"
OperatorAnd		= "&&" //"&" "&" ??
OperatorOr		= "||"
OperatorImplies	= "=>"
BooleanOperator  = ({OperatorNot} | {OperatorAnd} | {OperatorOr} | {OperatorImplies})

// numeric operators
OperatorPlus			= "+"
OperatorMinus			= "-"
OperatorMultiplication	= "*"
OperatorDivision		= "/"
OperatorPower			= "^"
NumericaOperator		= ({OperatorPlus} | {OperatorMinus} | {OperatorDivision} | {OperatorPower})

// dicionary/sequence operators
OperatorIn 	= "in"

// dictionary operators
OperatorDictionaryKey 	= //d[k]
DictionaryOperator		= ({OperatorIn} | {OperatorDictionaryKey})

// sequence operators
OperatorSequenceConcatenation	= "::"
OperatorSequenceIndex			= {ArbitraryText} "[" [0-9]* "]"
OperatorSequenceLeftSlice		= {ArbitraryText} "[" [0-9]* ":" "]"
OperatorSequenceRightSlice		= {ArbitraryText} "[" ":" [0-9]* "]"
OperatorSequenceDualSlice		= {ArbitraryText} "[" [0-9]* ":" [0-9]* "]"
OperatorSequenceBoundlessSlice	= {ArbitraryText} "[" ":" "]"
SequenceOperator				= ({OperatorIn} | {OperatorSequenceConcatenation} | {OperatorSequenceIndex} | {OperatorSequenceLeftSlice} | {OperatorSequenceRightSlice} | {OperatorSequenceDualSlice} | {OperatorSequenceBoundlessSlice})

// comparison operators
OperatorLessThan				= "<"
OperatorLessThanOrEqual		= "<="
OperatorEquality				= "="
OperatorNotEqual				= {OperatorNot} {OperatorEquality}  //"!="
ComparisonOperator			= ({OperatorLessThan} | {OperatorLessThanOrEqual} | {OperatorEquality} | {OperatorNotEqual})

OperatorInfix		= .
OperatorPostfix		= .

//Paragraph 13 ----------------------------------------------
// ----------------------------------------------------------
DeclarationVariable		= {Identifier} : {DataType} := {Literal} ";"           
DeclarationType			= {KeywordTdef} {ArbitraryText} "{" ({ArbitraryText} : {DataType}) (, {ArbitraryText} : {DataType})* "}" ";"
DeclarationTypeAlias	= {KeywordAlias} {DataType} {DataType} ";" 

//Paragraph 14 ----------------------------------------------
// ----------------------------------------------------------
DeclarationFunctionParameter		= .
DeclarationFunctionParameterList	= .
DeclarationLocalVariable			= .
DeclarationLocalVariableList		= .
DeclarationFunctionBody				= .

FunctionStatement					= .
FunctionStatementList				= .
FunctionReturnType					= .

//Listing 2 -------------------------------------------------
// ----------------------------------------------------------
DeclarationFunction 				= .

//Paragraph 15 ----------------------------------------------
// ----------------------------------------------------------
Literal 							= .
FunctionPredicate					= .

ExpressionFieldReference			= .
ExpressionInfixOperation			= .
ExpressionPostfixOperation			= .
ExpressionPredicatedFunctionCall	= .

Expression 							= .

//Paragraph 16 ----------------------------------------------
// ----------------------------------------------------------
// Table 4 --------------------------------------------------
// ----------------------------------------------------------
OperatorAssignment		= .
ExpressionList			= .

StatementAssignment		= .
StatementInput			= .
StatementOutput			= .
StatementFunctionCall	= .
StatementIfThen			= .
StatementIfThenElse		= .
StatementLoop			= .
StatementBreak			= .
StatementReturn			= .

Statement 				= .
StatementBody			= .

// Paragraph 17 ----------------------------------------------
// ----------------------------------------------------------
StatementInbuiltTypeDeclarationAndInitialisation		= .
StatementUserDefinedTypeDeclarationAndInitialisation	= .

//Paragraph 18 ----------------------------------------------
// ----------------------------------------------------------
StatementPredicatedFunctionCall		= .


%%
// ----------------------------------------------------------
// Lexical Rules
// ----------------------------------------------------------

<YYINITIAL>

{WhiteSpace} {}

. {
	report_error(
         "Syntax error at line " + (yyline+1) + ", column "
		+ yycolumn, null );
  }













