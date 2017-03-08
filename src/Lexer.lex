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

KeywordAlias			= .
KeywordDict				= .
KeywordSeq				= .
KeywordTdef				= .
KeywordFdef				= .
KeywordIf				= .
KeywordIfTerminator		= .
KeywordThen				= .
KeywordElse				= .
KeywordLoop				= .
KeywordLoopTerminator	= .
KeywordReturn			= .
KeywordRead				= .
KeywordPrint 			= .
KeywordBreak			= .
Keyword					= .

//Paragraph 3 -----------------------------------------------
// ----------------------------------------------------------
CommentSingleLine = .
CommentMultiline  = .
Comment 			= CommentMultiline | CommentSingleLine

//Paragraph 4 -----------------------------------------------
// ----------------------------------------------------------
Identifier = .

//Paragraph 5 -----------------------------------------------
// ----------------------------------------------------------
DataTypeChar		= .
LiteralChar   		= .

//Paragraph 6 -----------------------------------------------
// ----------------------------------------------------------
ValueBool = .

//Paragraph 7 -----------------------------------------------
// ----------------------------------------------------------
DataTypeBool  = .
DataTypeInt   = .
DataTypeRat   = .
DataTypeFloat = .

LiteralInt      = .
LiteralRational = .
LiteralFloat    = .
LiteralNumber   = .

//Paragraph 8 -----------------------------------------------
// ----------------------------------------------------------
DataTypeDictionary 		= .
LiteralDictionary  		= .

DataTypeTop       		= .
LiteralTop				= .

LiteralEmptyDictionary 	= .


//Paragraph 9 -----------------------------------------------
// ----------------------------------------------------------
DataTypeSequence 	= .
LiteralSequence    	= .
LiteralEmptyList	= .

//Paragraph 10 ----------------------------------------------
// ----------------------------------------------------------
LiteralString			= .
SequenceLengthParameter	= .


// Table 1 --------------------------------------------------
// ----------------------------------------------------------
DataTypePrimitive = .
DataTypeAggregate = .
DataType          = .


// Table 2 --------------------------------------------------
// ----------------------------------------------------------

// boolean operators
OperatorNot		= .
OperatorAnd		= .
OperatorOr		= .
OperatorImplies	= .
BooleanOperator  = .

// numeric operators
OperatorPlus			= .
OperatorMinus			= .
OperatorMultiplication	= .
OperatorDivision		= .
OperatorPower			= .
NumericaOperator		= .

// dicionary/sequence operators
OperatorIn 	= .

// dictionary operators
OperatorDictionaryKey 	= .
DictionaryOperator		= .

// sequence operators
OperatorSequenceConcatenation	= .
OperatorSequenceIndex			= .
OperatorSequenceLeftSlice		= .
OperatorSequenceRightSlice		= .
OperatorSequenceDualSlice		= .
OperatorSequenceBoundlessSlice	= .
SequenceOperator					= .

// comparison operators
OperatorLessThan				= .
OperatorLessThanOrEqual		= .
OperatorEquality				= .
OperatorNotEqual				= .
ComparisonOperator			= .

OperatorInfix		= .
OperatorPostfix		= .

//Paragraph 13 ----------------------------------------------
// ----------------------------------------------------------
DeclarationVariable		= .
DeclarationType			= .
DeclarationTypeAlias	= .

//Paragraph 14 ----------------------------------------------
// ----------------------------------------------------------
DeclarationFunctionParameter		= .
DeclarationFunctionParameteList		= .
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

//Paragraph 17 ----------------------------------------------
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














