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
Semicolon		   = ";"
Colon 			   = ":"
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
LiteralNull		   = "null"

// Key words

KeywordDict				= "dict"
KeywordSeq				= "seq"

KeywordAlias			= "alias"
KeywordTdef				= "tdef"
KeywordFdef				= "fdef"

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

//Paragraph 3 -----------------------------------------------
// ----------------------------------------------------------
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
LiteralChar   		= '([^'\\\n]|\\.)'
LegalCharacters		= ([^'\\\n]|\\.)

//Paragraph 6 -----------------------------------------------
// ----------------------------------------------------------
ValueBool = "T" | "F"

//Paragraph 7 -----------------------------------------------
// ----------------------------------------------------------
DataTypeBool  = "bool"
DataTypeInt   = "int"
DataTypeRat   = "rat"
DataTypeFloat = "float"
DataTypePrimitive = DataTypeFloat | DataTypeRat | DataTypeInt | DataTypeBool | DataTypeChar

LiteralPosInt   =  0 | [1-9][0-9]*
LiteralInt      =  0 | -?[1-9][0-9]*
LiteralRational = ({LiteralInt} "/" {LiteralPosInt}) | ({LiteralInt} _ {LiteralPosInt} "/" {LiteralPosInt})
LiteralFloat    = {LiteralInt} . {LiteralPosInt}

//Paragraph 8 -----------------------------------------------
// ----------------------------------------------------------
DataTypeDictionary 		= dict<{DataTypePrimitive}, {DataTypePrimitive}>

DataTypeTop       		= "top"


//Paragraph 9 -----------------------------------------------
// ----------------------------------------------------------
DataTypeSequence 	= {KeywordSeq} < {DataType} >

//Paragraph 10 ----------------------------------------------
// ----------------------------------------------------------
DataTypeString			= "string"
LiteralString			= "\"" {LegalCharacters}* "\""
SequenceLengthParameter	= "len"
        

// Table 2 --------------------------------------------------
// ----------------------------------------------------------

// boolean operators

OperatorNot		= "!"
OperatorAnd		= "&&" //"&" "&" ??
OperatorOr		= "||"
OperatorImplies	= "=>"

// numeric operators
OperatorPlus			= "+"
OperatorMinus			= "-"
OperatorMultiplication	= "*"
OperatorDivision		= "/"
OperatorPower			= "^"

// dicionary/sequence operators
OperatorIn 	= "in"

// sequence operators
OperatorSequenceConcatenation	= "::"

// comparison operators
OperatorLessThan				= "<"
OperatorLessThanOrEqual		    = "<="
OperatorEquality				= "="
OperatorNotEqual				= "!="

//Paragraph 16 ----------------------------------------------
// ----------------------------------------------------------
// Table 4 --------------------------------------------------
// ----------------------------------------------------------
OperatorAssignment		= ":="




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
<YYINITIAL> {KeywordTdef } { return createSymbol(sym.TDEF ); }
<YYINITIAL> {KeywordFdef } { return createSymbol(sym.FDEF ); }
<YYINITIAL> {KeywordAlias} { return createSymbol(sym.ALIAS); }
<YYINITIAL> {KeywordMain } { return createSymbol(sym.MAIN ); }



/* 	-------------
 *	Tokens
 *	-------------
 */


 // ----OTHER----
{Identifier} 				{ return createSymbol(sym.ID, yytext());	}
{SequenceLengthParameter} 	{ return createSymbol(sym.LEN);	}



// ----PUNCTUATION----

    //  Brackets
    {LeftBracket} 			{ return createSymbol(sym.BRACKET_L); 	}
	{RightBracket} 			{ return createSymbol(sym.BRACKET_R); 	}
    {LeftSquareBracket} 	{ return createSymbol(sym.BRACKET_SL);  }
	{RightSquareBracket} 	{ return createSymbol(sym.BRACKET_SR);  }
	{LeftCurlyBracket} 		{ return createSymbol(sym.CURLY_L); 	}
	{RightCurlyBracket} 	{ return createSymbol(sym.CURLY_R); 	}
	{LeftAngleBracket} 		{ return createSymbol(sym.ANGLE_L); 	}
	{RightAngleBracket} 	{ return createSymbol(sym.ANGLE_R); 	}

    //  Other
    {Semicolon} 			{ return createSymbol(sym.SEMICOLON); 	}
    {Colon} 				{ return createSymbol(sym.COLON); 		}
	{Dot} 					{ return createSymbol(sym.DOT); 		}
	{Comma} 				{ return createSymbol(sym.COMMA);		}
	{QuestionMark} 			{ return createSymbol(sym.QUES_MARK); 	}


// ----KEYWORDS----

    //  Declaration
    {KeywordAlias} 			{ return createSymbol(sym.ALIAS); 		}
	{KeywordTdef} 			{ return createSymbol(sym.TDEF); 		}
	{KeywordFdef} 			{ return createSymbol(sym.FDEF); 		}
	{KeywordMain} 			{ return createSymbol(sym.MAIN); 		}

    //  Control Flow
    {KeywordIf} 			{ return createSymbol(sym.IF); 			}
    {KeywordIfTerminator} 	{ return createSymbol(sym.FI); 			}
	{KeywordThen} 			{ return createSymbol(sym.THEN); 		}
	{KeywordElse} 			{ return createSymbol(sym.ELSE); 		}
	{KeywordLoop} 			{ return createSymbol(sym.LOOP); 		}
	{KeywordLoopTerminator} { return createSymbol(sym.POOL); 		}
	{KeywordReturn} 		{ return createSymbol(sym.RETURN); 		}
	{KeywordBreak} 			{ return createSymbol(sym.BREAK); 		}
      
    //  IO
    {KeywordRead} 			{ return createSymbol(sym.READ); 		}
	{KeywordPrint} 			{ return createSymbol(sym.PRINT); 		}


// ----DATA TYPES----

    //  Primitive
    {DataTypeInt} 			{ return createSymbol(sym.TYPE_INT); 	}
	{DataTypeBool}			{ return createSymbol(sym.TYPE_BOOL); 	}
	{DataTypeRat} 			{ return createSymbol(sym.TYPE_RAT); 	}
	{DataTypeFloat}			{ return createSymbol(sym.TYPE_FLOAT); 	}
	{DataTypeChar} 			{ return createSymbol(sym.TYPE_CHAR); 	}
      
    //  Aggregate
    {KeywordDict}			{ return createSymbol(sym.DICT); 		}
	{KeywordSeq} 			{ return createSymbol(sym.SEQ); 		}
	{DataTypeString}		{ return createSymbol(sym.TYPE_STRING);	}
    
    //  Other
    {DataTypeTop} 			{ return createSymbol(sym.TOP); 		}


// ----LITERALS----

    //  Primitive
    {LiteralInt} 			{ return createSymbol(sym.LIT_INT, yytext()); 		}
	{ValueBool} 			{ return createSymbol(sym.VAL_BOOL, yytext()); 		}
	{LiteralRational} 		{ return createSymbol(sym.LIT_RAT, yytext()); 		}
	{LiteralFloat} 			{ return createSymbol(sym.LIT_FLOAT, yytext()); 	}
	{LiteralChar} 			{ return createSymbol(sym.LIT_CHAR, yytext()); 		}

    //  Aggregate
    {LiteralString} 		{ return createSymbol(sym.LIT_STRING,yytext()); 	}

    //  Other
	{LiteralNull} 			{ return createSymbol(sym.NULL); 					}


// ----OPERATORS----

    //  Boolean Operators
    {OperatorNot} 			{ return createSymbol(sym.NOT); 					}
	{OperatorAnd} 			{ return createSymbol(sym.AND); 					}
	{OperatorOr} 			{ return createSymbol(sym.OR); 						}
	{OperatorImplies} 		{ return createSymbol(sym.IMPLIES); 				}
	
      

    //  Numeric Operators
    {OperatorPlus} 			{ return createSymbol(sym.PLUS); 					}
	{OperatorMinus} 		{ return createSymbol(sym.MINUS); 					}
	{OperatorMultiplication}{ return createSymbol(sym.MULTIPLY); 				}
	{OperatorDivision} 		{ return createSymbol(sym.DIVIDE); 					}
	{OperatorPower} 		{ return createSymbol(sym.POWER); 					}
	



    //  Dictionary/Sequence Operators
    {OperatorIn} 			{ return createSymbol(sym.IN); 						}
	{OperatorSequenceConcatenation} { return createSymbol(sym.CONCAT); 			}

    //  Comparison Operators
    {OperatorLessThan} 		{ return createSymbol(sym.LESS_THAN); 				}
	{OperatorLessThanOrEqual} { return createSymbol(sym.LESS_OR_EQ); 			}
	{OperatorEquality} 		{ return createSymbol(sym.EQUAL); 					}
	{OperatorNotEqual} 		{ return createSymbol(sym.NOT_EQUAL);				}

    //  Other
    {OperatorAssignment} 	{ return createSymbol(sym.ASSIGNMENT); 				}


// End of File
<YYINITIAL,STATE_COMMENT_SINGLE> <<EOF>> {return createSymbol(sym.EOF);}


/* -----------------------------------------------------------------------------------------
 * Unmatched input
 * -----------------------------------------------------------------------------------------
 */
. {
	syntax_error(sym.ERROR);
  }













