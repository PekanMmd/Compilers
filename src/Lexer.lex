// Lexer by Megan Lucas, Nadia Mahgerefteh and Stars Momodu

/* -----------------------------------------------------------------------------------------
 * User Code
 * -----------------------------------------------------------------------------------------
 */
import java_cup.runtime.*;
import java.util.*

private Symbol createSymbol(int type) {
	return new Symbol(type, yyline, yycolumn);
}
private Symbol createSymbol(int type, Object value) {
	return new Symbol(type, yyline, yycolumn, value);
}

public void syntax_error(Symbol current_token) { report_error(
     "Syntax error at line " + (current_token.left+1) + ", column " + current_token.right, null );
}

%%
/* -----------------------------------------------------------------------------------------
 * Options and Declarations
 * -----------------------------------------------------------------------------------------
 */
%class Lexer
%cup
%line
%column

/* -----------------------------------------------------------------------------------------
 * States
 * -----------------------------------------------------------------------------------------
 */
%xstate STATE_COMMENT_SINGLE, STATE_COMMENT_MULTI

/* -----------------------------------------------------------------------------------------
 * Macros
 * -----------------------------------------------------------------------------------------
 */

// White space
LineTerminator	= "\r"|"\n"|"\r\n"
WhiteSpace    	= {LineTerminator} | [ \t\f]

// Punctuation
Semicolon			= ";"
Colon 				= ":"
Semicolon		   = ";"
Dot 			   = "."
LeftBracket		   = "("
RightBracket       = ")"
LeftSquareBracket  = "["
RightSquareBracket = "]"
LeftCurlyBracket   = "{"
RightCurlyBracket  = "}"
LeftAngleBracket   = "<"
RightAngleBracket  = ">"
Comma              = ","
QuestionMark       = "?"

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

KeywordMain				= "main"
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
Keyword					= {LineTerminator} | {WhiteSpace} | {Semicolon} | {LiterNull} | {KeywordDataType} | {KeywordDeclaration} | {KeywordStatement} | {KeywordMain}

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
LiteralRational = ({LiteralInt} "/" {LiteralPosInt}) | ({LiteralInt} _ {LiteralPosInt} "/" {LiteralPosInt})
LiteralFloat    = {LiteralInt} . {LiteralPosInt}
LiteralNumber   = {LiteralInt} | {LiteralRational} | {LiteralFloat}

//Paragraph 8 -----------------------------------------------
// ----------------------------------------------------------
DataTypeDictionary 		= dict<{DataTypePrimitive}, {DataTypePrimitive}>
LiteralDictionary  		= "{"(({DictionaryType} : {DictionaryType})*)"}"

DataTypeTop       		= "top"
LiteralTop				= ({LiteralNumber})   

LiteralEmptyDictionary 	= "{}"


//Paragraph 9 -----------------------------------------------
// ----------------------------------------------------------
DataTypeSequence 	= {KeywordSeq} < {DataType} >
LiteralSequence = "[" ({ArbitraryText}) ("," {ArbitraryText})* "]"        
LiteralEmptyList	= "[]"

//Paragraph 10 ----------------------------------------------
// ----------------------------------------------------------
DataTypeString			= "string"
LiteralString			= "\"" {LegalCharacters}* "\""
SequenceLengthParameter	= ".length"
ArbitraryText			= {LegalCharacters}+      

// Table 1 --------------------------------------------------
// ----------------------------------------------------------
DataTypePrimitive 		= {DataTypeBool} | {DataTypeInt} | {DataTypeRat} | {DataTypeFloat} | {DataTypeChar}
DataTypeAggregate 		= {DataTypeDictionary} | {DataTypeSequence}
DataType          		= {DataTypePrimitive} | {DataTypeAggregate}

LiteralPrimitive  		= {ValueBool} | {LiteralNumber} | {LiteralChar}
LiteralAggregate  		= {LiteralDictionary} | {LiteralEmptyDictionary} | {LiteralEmptyList} | {LiteralSequence} | {LiteralString}
LiteralDictionaryKey 	= {LiteralPrimitive}
Literal           		= {LiteralPrimitive} | {LiteralAggregate}             

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
OperatorDictionaryKey 	= "[" {LiteralDictionaryKey} "]"
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
/* -----------------------------------------------------------------------------------------
 * Lexical Rules
 * -----------------------------------------------------------------------------------------
 */
{WhiteSpace} { /* ignored */ }

// Comments
{CommentSingleLineBegin} { yybegin(STATE_COMMENT_SINGLE); }
{CommentMultilineBegin } { yybegin(STATE_COMMENT_MULTI ); }

<STATE_COMMENT_SINGLE> { CommentSingleLineEnd} { yybegin(YYINITIAL); }
<STATE_COMMENT_SINGLE> . {}

<STATE_COMMENT_MULTI>  { CommentMultiLineEnd} { yybegin(YYINITIAL); }
<STATE_COMMENT_MULTI>  . {}


// Initial State
<YYINITIAL> {KeywordTdef } { return new Yytoken(TokenType.TDEF ); }
<YYINITIAL> {KeywordFdef } { return new Yytoken(TokenType.FDEF ); }
<YYINITIAL> {KeywordAlias} { return new Yytoken(TokenType.ALIAS); }
<YYINITIAL> {KeywordMain } { return new Yytoken(TokenType.MAIN ); }

// Tokens
{LiteralInt} 				{ return new Yytoken(TokenType.LIT_INT,yytext()); }
{KeywordIf} 				{ return new Yytoken(TokenType.IF); }
{Semicolon} 				{ return new Yytoken(TokenType.SEMICOLON); }
{LiteralNull} 				{ return new Yytoken(TokenType.NULL); }
{DictionaryType}			{ return new Yytoken(TokenType.DICT, yytext()); }
{LiteralSequence} 			{ return new Yytoken(TokenType.SEQ, yytext()); }
{KeywordAlias} 				{ return new Yytoken(TokenType.ALIAS); }
{KeywordTdef} 				{ return new Yytoken(TokenType.TDEF); }
{KeywordFdef} 				{ return new Yytoken(TokenType.FDEF); }
{KeywordIfTerminator} 		{ return new Yytoken(TokenType.FI); }
{KeywordThen} 				{ return new Yytoken(TokenType.THEN); }
{KeywordElse} 				{ return new Yytoken(TokenType.ELSE); }
{KeywordLoop} 				{ return new Yytoken(TokenType.LOOP); }
{KeywordLoopTerminator} 	{ return new Yytoken(TokenType.POOL); }
{KeywordReturn} 			{ return new Yytoken(TokenType.RETURN); }
{KeywordRead} 				{ return new Yytoken(TokenType.READ); }
{KeywordPrint} 				{ return new Yytoken(TokenType.PRINT); }
{KeywordBreak} 				{ return new Yytoken(TokenType.BREAK); }
{Identifier} 				{ return new Yytoken(TokenType.ID,yytext()); }
{DataTypeInt} 				{ return new Yytoken(TokenType.TYPE_INT); }
{DataTypeBool}				{ return new Yytoken(TokenType.TYPE_BOOL); }
{DataTypeRat} 				{ return new Yytoken(TokenType.TYPE_RAT); }
{DataTypeFloat} 			{ return new Yytoken(TokenType.TYPE_FLOAT); }
{DataTypeTop} 				{ return new Yytoken(TokenType.TOP); }
{ExpressionFieldReference}  { return new Yytoken(TokenType.FIELD_REF,yytext()); }
{OperatorNot} 				{ return new Yytoken(TokenType.NOT); }
{OperatorAnd} { return new Yytoken(TokenType.AND); }
{OperatorOr} { return new Yytoken(TokenType.OR); }
{OperatorImplies} { return new Yytoken(TokenType.IMPLIES); }
{OperatorPlus} { return new Yytoken(TokenType.PLUS); }
{OperatorMinus} { return new Yytoken(TokenType.MINUS); }
{OperatorMultiplication} { return new Yytoken(TokenType.MULTIPLY); }
{OperatorDivision} { return new Yytoken(TokenType.DIVIDE); }
{OperatorPower} { return new Yytoken(TokenType.POWER); }
{OperatorIn} { return new Yytoken(TokenType.IN); }
{OperatorSequenceConcatenation} { return new Yytoken(TokenType.CONCAT); }
{OperatorLessThan} { return new Yytoken(TokenType.LESS_THAN); }
{OperatorLessThanOrEqual} { return new Yytoken(TokenType.LESS_OR_EQ); }
{OperatorEquality} { return new Yytoken(TokenType.EQUAL); }
{OperatorNotEqual} { return new Yytoken(TokenType.NOT_EQUAL); }
{OperatorAssignment} { return new Yytoken(TokenType.ASSIGNMENT); }
{Colon} { return new Yytoken(TokenType.COLON); }
{Dot} { return new Yytoken(TokenType.DOT); }
{LeftBracket} { return new Yytoken(TokenType.BRACKET_L); }
{RightBracket} { return new Yytoken(TokenType.BRACKET_R); }
{LeftSquareBracket} { return new Yytoken(TokenType.BRACKET_SL); }
{RightSquareBracket} { return new Yytoken(TokenType.BRACKET_SR); }
{Comma} { return new Yytoken(TokenType.COMMA); }
{DataTypeString} { return new Yytoken(TokenType.TYPE_STRING); }
{DataTypeChar} { return new Yytoken(TokenType.TYPE_CHAR); }
{QuestionMark} { return new Yytoken(TokenType.QUES_MARK); }
{KeywordMain} { return new Yytoken(TokenType.MAIN); }
{LeftCurlyBracket} { return new Yytoken(TokenType.CURLY_L); }
{RightCurlyBracket} { return new Yytoken(TokenType.CURLY_R); }
{LeftAngleBracket} { return new Yytoken(TokenType.ANGLE_L); }
{RightAngleBracket} { return new Yytoken(TokenType.ANGLE_R); }
{LiteralInt} { return new Yytoken(TokenType.LIT_INT,yytext()); }
{ValueBool} { return new Yytoken(TokenType.VAL_BOOL,yytext()); }
{LiteralRational} { return new Yytoken(TokenType.LIT_RAT,yytext()); }
{LiteralFloat} { return new Yytoken(TokenType.LIT_FLOAT,yytext()); }
{LiteralChar} { return new Yytoken(TokenType.LIT_CHAR,yytext()); }
{LiteralString} { return new Yytoken(TokenType.LIT_STRING,yytext()); }


// End of File
<YYINITIAL,STATE_COMMENT_SINGLE> <<EOF>> {return new Yytoken(TokenType.EOF);}


/* -----------------------------------------------------------------------------------------
 * Unmatched input
 * -----------------------------------------------------------------------------------------
 */
. {
	syntax_error(sym.ERROR);
  }













