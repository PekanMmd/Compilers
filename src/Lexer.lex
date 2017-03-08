/*Lexer by Megan Lucas, Nadia Mahgerefteh and Stars Momodu*/

// ----------------------------------------------------------
// User Code
// ----------------------------------------------------------

import java.util.*

class TokenType {

	private final static int EOF 		=  0;
	private final static int IF 		=  1;
	private final static int SEMICOLON  =  2;
	private final static int NULL 		=  3;
	private final static int DICT 		=  4;
	private final static int SEQ 		=  5;
	private final static int ALIAS 		=  6;
	private final static int TDEF 		=  7;
	private final static int FDEF 		=  8;
	private final static int FI 		=  9;
	private final static int THEN 		= 10;
	private final static int ELSE 		= 11;
	private final static int LOOP 		= 12;
	private final static int POOL 		= 13;
	private final static int RETURN 	= 14;
	private final static int READ 		= 15;
	private final static int PRINT 		= 16;
	private final static int BREAK 		= 17;
	private final static int ID 		= 18;
	private final static int BOOLEAN 	= 19;
	private final static int INT 		= 20;
	private final static int RAT    	= 21;
	private final static int FLOAT   	= 22;
	private final static int TOP 		= 23;
	private final static int FIELD_REF 	= 24;
	private final static int NOT    	= 25;
	private final static int AND    	= 26;
	private final static int OR     	= 27;
	private final static int IMPLIES 	= 28;
	private final static int PLUS 	    = 29;
	private final static int MINUS 	    = 30;
	private final static int MULTIPLY 	= 31;
	private final static int DIVIDE 	= 32;
	private final static int POWER  	= 33;
	private final static int IN 	    = 34;
	private final static int CONCAT 	= 35;
	private final static int LESS_THAN 	= 36;
	private final static int MORE_THAN 	= 37;
	private final static int LESS_OR_EQ = 38;
	private final static int MORE_OR_EQ = 39;
	private final static int EQUAL 	    = 40;
	private final static int NOT_EQUAL 	= 41;
	private final static int ASSIGNMENT = 42;
	private final static int COLON 	    = 43;
	private final static int DOT 	    = 44;
	private final static int BRACKET_L 	= 45;
	private final static int BRACKET_R 	= 46;
	private final static int BRACKET_SL = 47;
	private final static int BRACKET_RL = 48;
	private final static int COMMA   	= 49;
	private final static int STRING 	= 50;
	private final static int CHAR   	= 51;
	private final static int QUES_MARK 	= 52;

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

%state  STATE_IF, STATE_FDEF, STATE_TDEF, STATE_LOOP
%xstate STATE_COMMENT_SINGLE, STATE_COMMENT_MULTI

// ----------------------------------------------------------
// State Stack
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
Colon 			= ":"

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
Comment 			= {CommentMultiline} | {CommentSingleLine}

CommentSingleLineBegin 	= "#"
CommentSingleLineEnd	= "\n"
CommentMultilineBegin  	= "/#" 
CommentMultiLineEnd		= "#/"

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
OperatorLessThanOrEqual		    = "<="
OperatorEquality				= "="
OperatorNotEqual				= "!="
ComparisonOperator			= ({OperatorLessThan} | {OperatorLessThanOrEqual} | {OperatorEquality} | {OperatorNotEqual})


OperatorPrefix      = OperatorNot
OperatorInfix		= ComparisonOperator | OperatorAnd | OperatorOr | OperatorImplies | NumericaOperator | OperatorIn | OperatorSequenceConcatenation
OperatorPostfix		= OperatorSequenceConcatenation | OperatorSequenceIndex | OperatorSequenceLeftSlice | OperatorSequenceRightSlice | OperatorSequenceDualSlice | OperatorSequenceBoundlessSlice | OperatorDictionaryKey

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
FunctionPredicate					= "?" Expression "?"

ExpressionFieldReference			= Identifier "." Identifier
ExpressionPrefixOperation			= OperatorInfix ArbitraryText
ExpressionInfixOperation			= ArbitraryText OperatorInfix ArbitraryText
ExpressionPostfixOperation			= Identifier OperatorPostfix 
ExpressionPredicatedFunctionCall	= FunctionPredicate Identifier "(" DeclarationFunctionParameteList ")"

Expression 							= ExpressionFieldReference | ExpressionPrefixOperation | ExpressionInfixOperation | ExpressionPostfixOperation | ExpressionPredicatedFunctionCall

//Paragraph 16 ----------------------------------------------
// ----------------------------------------------------------
// Table 4 --------------------------------------------------
// ----------------------------------------------------------
OperatorAssignment		= ":="
ExpressionList			= Expression (, Expression)*

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
{WhiteSpace} {}

// ----------------------------------------------------------
// Comments
// ----------------------------------------------------------
{CommentSingleLineBegin} { yypushState(STATE_COMMENT_SINGLE); }
{CommentMultilineBegin } { yypushState(STATE_COMMENT_MULTI ); }

<STATE_COMMENT_SINGLE> { CommentSingleLineEnd} {yypopState(); };
<STATE_COMMENT_SINGLE> . {};

<STATE_COMMENT_MULTI>  { CommentMultiLineEnd} {yypopState(); };
<STATE_COMMENT_MULTI>  . {};


// ----------------------------------------------------------
// State begins
// ----------------------------------------------------------
{KeywordIf} 	{ yypushState(STATE_IF); }
{KeywordLoop} 	{ yypushState(STATE_LOOP); }

{Keyword} { yypushState(STATE_IF); }

// ----------------------------------------------------------
// State ends
// ----------------------------------------------------------

{LiteralInt} { return new Yytoken(TokenType.INT,yytext());}

// ----------------------------------------------------------
// Initial State
// ----------------------------------------------------------
<YYINITIAL> {tdef} { yypushState(STATE_TDEF); return new Yytoken(TokenType.TDEF); }



<YYINITIAL,STATE_COMMENT_MULTI,STATE_COMMENT_SINGLE> <<EOF>> {return new Yytoken(TokenType.EOF);}
. {
	report_error(
         "Syntax error at line " + (yyline+1) + ", column "
		+ yycolumn, null );
  }













