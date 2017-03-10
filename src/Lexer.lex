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

%eofval{
    return createSymbol(sym.EOF);
%eofval}

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
LiteralNull		   = {KeywordNull}

// Key words
KeywordDict				= "dict"
KeywordSeq				= "seq"
//KeywordType 			= {DataTypePrimitive} | {DataTypeAggregate} | {DataTypeTop}

KeywordAlias			= "alias"
KeywordTdef				= "tdef"
KeywordFdef				= "fdef"
KeywordMain				= "main"
//KeywordDeclarations		= {KeywordAlias} | {KeywordTdef} | {KeywordFdef} | {KeywordMain}

KeywordIf				= "if"
KeywordIfTerminator		= "fi"
KeywordThen				= "then"
KeywordElse				= "else"
KeywordLoop				= "loop"
KeywordLoopTerminator	= "pool"
//KeywordControlFlow		= {KeywordIf} | {KeywordIfTerminator} | {KeywordThen} | {KeywordElse} | {KeywordLoop} | {KeywordLoopTerminator}

KeywordReturn			= "return"
KeywordRead				= "read"
KeywordPrint 			= "print"
KeywordBreak			= "break"
//KeywordStatements		= {KeywordReturn} | {KeywordRead} | {KeywordPrint} | {KeywordBreak}

KeywordNull 			= "null"
//KeywordValue			= {KeywordNull}

//Keyword 				= {KeywordType} | {KeywordDeclarations} | {KeywordControlFlow} | {KeywordStatements} | {KeywordValue}

//Paragraph 3 -----------------------------------------------
// ----------------------------------------------------------
CommentSingleLineBegin 	= "#"
CommentSingleLineEnd	= "\n"
CommentMultilineBegin  	= "/#" 
CommentMultiLineEnd		= "#/"

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
//DataTypePrimitive = DataTypeFloat | DataTypeRat | DataTypeInt | DataTypeBool | DataTypeChar
//DataTypeAggregate = DataTypeSequence | DataTypeDictionary | DataTypeString

LiteralPosInt   =  0 | [1-9][0-9]*
LiteralInt      =  0 | -?[1-9][0-9]*
LiteralRational = ({LiteralInt} "/" {LiteralPosInt}) | ({LiteralInt} _ {LiteralPosInt} "/" {LiteralPosInt})
LiteralFloat    = {LiteralInt} . {LiteralPosInt}

//Paragraph 8 -----------------------------------------------
// ----------------------------------------------------------
//DataTypeDictionary 		= {KeywordDict}

DataTypeTop       		= "top"


//Paragraph 9 -----------------------------------------------
// ----------------------------------------------------------
//DataTypeSequence 	= {KeywordSeq}

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
//OperatorLessThan				= "<" // conflicts with left angle bracket
OperatorLessThanOrEqual		    = "<="
OperatorEquality				= "="
OperatorNotEqual				= "!="

//Paragraph 16 ----------------------------------------------
// ----------------------------------------------------------
// Table 4 --------------------------------------------------
// ----------------------------------------------------------
OperatorAssignment		= ":="

//Paragraph 4 -----------------------------------------------
// ----------------------------------------------------------
Identifier = (([a-z] | [A-Z]) ("_" | [0-9] | [a-z] | [A-Z])*)

%%
/* -----------------------------------------------------------------------------------------
 * Lexical Rules
 * -----------------------------------------------------------------------------------------
 */
{WhiteSpace} { /* ignored */ }

// Comments
{CommentSingleLineBegin} { yybegin(STATE_COMMENT_SINGLE); }
{CommentMultilineBegin } { yybegin(STATE_COMMENT_MULTI ); }

<STATE_COMMENT_SINGLE> {
		{CommentSingleLineEnd} 	{ yybegin(YYINITIAL); }
	 	. 						{ /* ignored       */ }
}

<STATE_COMMENT_MULTI> {

		{ CommentMultiLineEnd } { yybegin(YYINITIAL); }
		. 						{ /* ignored       */ }
}

/* 	-------------
 *	Terminals
 *	-------------
 */

 // ----OTHER----
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
	{ValueBool} 			{ return createSymbol(sym.LIT_BOOL, yytext()); 		}
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
    {OperatorPlus} 				{ return createSymbol(sym.PLUS); 					}
	{OperatorMinus} 			{ return createSymbol(sym.MINUS); 					}
	{OperatorMultiplication}	{ return createSymbol(sym.MULTIPLY); 				}
	{OperatorDivision} 			{ return createSymbol(sym.DIVIDE); 					}
	{OperatorPower} 			{ return createSymbol(sym.POWER); 					}
	



    //  Dictionary/Sequence Operators
    {OperatorIn} 			{ return createSymbol(sym.IN); 						}
	{OperatorSequenceConcatenation} { return createSymbol(sym.CONCAT); 			}

    //  Comparison Operators
   // {OperatorLessThan} 		{ return createSymbol(sym.LESS_THAN); 				} // Overlaps with left angle bracket
	{OperatorLessThanOrEqual} { return createSymbol(sym.LESS_OR_EQ); 			}
	{OperatorEquality} 		{ return createSymbol(sym.EQUAL); 					}
	{OperatorNotEqual} 		{ return createSymbol(sym.NOT_EQUAL);				}

    //  Other
    {OperatorAssignment} 	{ return createSymbol(sym.ASSIGNMENT); 				}

    // ----IDENTIFIER----
    // put at end because can overlap with other matches
    {Identifier} 				{ return createSymbol(sym.ID, yytext());	}


/*// End of File
<YYINITIAL,STATE_COMMENT_SINGLE> <<EOF>> {return createSymbol(sym.E_O_F)  ;}
<STATE_COMMENT_MULTI> 			 <<EOF>> {return createSymbol(sym.ERROR);}
*/

/* -----------------------------------------------------------------------------------------
 * Unmatched input
 * -----------------------------------------------------------------------------------------
 */
. {
	syntax_error(sym.ERROR);
  }













