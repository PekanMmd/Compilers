/*Lexer by Megan Lucas, Nadia Mahgerefteh and Stars Momodu*/

// ----------------------------------------------------------
// User Code
// ----------------------------------------------------------

import java.util.*

%%
// ----------------------------------------------------------
// Options and Declarations
// ----------------------------------------------------------

%class Lexer
%cup
%line
%column

// ----------------------------------------------------------
// Lexer Code
// ----------------------------------------------------------
%{
	boolean programContainsMainFunction;
%}

//Paragraph 2 -----------------------------------------------
// ----------------------------------------------------------
%init{
	programContainsMainFunction = false;
%init}

%eofval{
	if (!programContainsMainFunction) {
		System.out.println("error: no main method");
	}
%eofval}

// ----------------------------------------------------------
// Regex Macros
// ----------------------------------------------------------

LineTerminator	= \r|\n|\r\n
WhiteSpace    	= {LineTerminator} | [ \t\f]
Semicolon		= ";"

// Literals
LiterNull		= "null"

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
CommentSingleLine = "#".*"\n"
CommentMultiline  = "/#" ~"#/"
Comment 		= CommentMultiline | CommentSingleLine

//Paragraph 4 -----------------------------------------------
// ----------------------------------------------------------
Identifier = (([a-z] | [A-Z]) ("_" | [0-9] | [a-z] | [A-Z])*) (!Keyword)

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
DataTypeDictionary 		= dict<DataTypePrimitive, DataTypePrimitive>
LiteralDictionary  		= "{"((DictionaryType:DictionaryType)*)"}"

DataTypeTop       		= "top"
LiteralTop				= (LiteralRational | LiteralNumber | LiteralFloat | LiteralInt)

LiteralEmptyDictionary 	= "{" (^DictionaryType) "}"


//Paragraph 9 -----------------------------------------------
// ----------------------------------------------------------
DataTypeSequence 	= .
LiteralSequence    	= .
LiteralEmptyList	= .

//Paragraph 10 ----------------------------------------------
// ----------------------------------------------------------
LiteralString			= "\"" LegalCharacters* "\""
SequenceLengthParameter	= .
ArbitraryText			= LegalCharacters*


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

. {System.out.println("yo");}
















