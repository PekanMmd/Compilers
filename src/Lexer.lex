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

KeywordDict				= "dict"
KeywordSeq				= "seq"
KeywordDataType         = KeywordDict | KeywordSeq

KeywordAlias			= "alias"
KeywordTdef				= "tdef"
KeywordFdef				= "fdef"
KeywordDeclaration 		= KeywordAlias | KeywordTdef | KeywordFdef

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
KeywordStatement		= KeywordIf | KeywordIfTerminator | KeywordThen | KeywordElse | KeywordLoop | KeywordLoopTerminator | KeywordReturn | KeywordPrint | KeywordBreak

Keyword					= LineTerminator | WhiteSpace | Semicolon | LiterNull | KeywordDataType | KeywordDeclaration | KeywordStatement

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
DataTypeChar		= "char"
LiteralChar   		= "'([^'\\\n]|\\.)'"
LegalCharacters		= "([^'\\\n]|\\.)"			

//Paragraph 6 -----------------------------------------------
// ----------------------------------------------------------
ValueBool = "T" | "F"

//Paragraph 7 -----------------------------------------------
// ----------------------------------------------------------
DataTypeBool  = "bol"
DataTypeInt   = "int"
DataTypeRat   = "rat"
DataTypeFloat = "float"

LiteralPosInt   = "0 | [1-9][0-9]*"
LiteralInt      = "0 | -?[1-9][0-9]*"
LiteralRational = [LiteralInt / LiteralPosInt] | [LiteralInt _ LiteralPosInt / LiteralPosInt]
LiteralFloat    = [LiteralInt . LiteralPosInt]
LiteralNumber   = LiteralInt | LiteralRational | LiteralFloat

//Paragraph 8 -----------------------------------------------
// ----------------------------------------------------------
DataTypeDictionary 		= dict<DataTypePrimitive, DataTypePrimitive>
LiteralDictionary  		= "{"((DictionaryType:DictionaryType)*)"}"

DataTypeTop       		= "top"
LiteralTop				= (LiteralRational | LiteralNumber | LiteralFloat | LiteralInt)

LiteralEmptyDictionary 	= "{" (^DictionaryType) "}"


//Paragraph 9 -----------------------------------------------
// ----------------------------------------------------------
DataTypeSequence 	= KeywordSeq < DataType >
LiteralSequence = "[" (ArbitraryText) ("," ArbitraryText)* "]"
LiteralEmptyList	= "[]"

//Paragraph 10 ----------------------------------------------
// ----------------------------------------------------------
LiteralString			= "\"" LegalCharacters* "\""
SequenceLengthParameter	= ".length"
ArbitraryText			= LegalCharacters*

// Table 1 --------------------------------------------------
// ----------------------------------------------------------
DataTypePrimitive = DataTypeBool | DataTypeInt | DataTypeRat | DataTypeFloat | DataTypeChar
DataTypeAggregate = DataTypeDictionary | DataTypeSequence
DataType          = DataTypePrimitive | DataTypeAggregate


// Table 2 --------------------------------------------------
// ----------------------------------------------------------

// boolean operators

OperatorNot		= "!"
OperatorAnd		= "&&" //"&" "&" ??
OperatorOr		= "||"
OperatorImplies	= "=>"
BooleanOperator  = (OperatorNot | OperatorAnd | OperatorOr | OperatorImplies)

// numeric operators
OperatorPlus			= "+"
OperatorMinus			= "-"
OperatorMultiplication	= "*"
OperatorDivision		= "/"
OperatorPower			= "^"
NumericaOperator		= (OperatorPlus | OperatorMinus | OperatorDivision | OperatorPower)

// dicionary/sequence operators
OperatorIn 	= "in"

// dictionary operators
OperatorDictionaryKey 	= //d[k]
DictionaryOperator		= (OperatorIn | OperatorDictionaryKey)

// sequence operators
OperatorSequenceConcatenation	= "::"
OperatorSequenceIndex			= ArbitraryText "[" [0-9]* "]"
OperatorSequenceLeftSlice		= ArbitraryText "[" [0-9]* ":" "]"
OperatorSequenceRightSlice		= ArbitraryText "[" ":" [0-9]* "]"
OperatorSequenceDualSlice		= ArbitraryText "[" [0-9]* ":" [0-9]* "]"
OperatorSequenceBoundlessSlice	= ArbitraryText "[" ":" "]"
SequenceOperator				= (OperatorIn | OperatorSequenceConcatenation | OperatorSequenceIndex | OperatorSequenceLeftSlice | OperatorSequenceRightSlice | OperatorSequenceDualSlice | OperatorSequenceBoundlessSlice)

// comparison operators
OperatorLessThan				= "<"
OperatorLessThanOrEqual		= "<="
OperatorEquality				= "="
OperatorNotEqual				= OperatorNot OperatorEquality  //"!="
ComparisonOperator			= (OperatorLessThan | OperatorLessThanOrEqual | OperatorEquality | OperatorNotEqual)

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

. {System.out.println("yo");}
















