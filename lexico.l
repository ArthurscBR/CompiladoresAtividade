%{

%}

NUM [0-9]+\.?[0-9]*
VARS [a-z]+[0-9]*
IF "SE"
ELSE "SENAO"
PRINT "escreva"
DECL "var"
TIPO_INT "int"
TIPO_FLOAT "float"
WHILE "repete"

%%

"//".* {;}

{IF} {return IF;}
{ELSE} {return ELSE;}
{WHILE} {return WHILE;}
{PRINT} {return PRINT;}
{DECL} {return DECL;}

{TIPO_INT} {
    return TIPO_INT;
}

{TIPO_FLOAT} {
    return TIPO_FLOAT;
}

{VARS} {
	strcpy(yylval.str,yytext);
	return VARS;
	}

{NUM} {
	yylval.real = atof(yytext);
	return NUM;
	}

[-+()=/*^{};] {return *yytext;
			}

">" {yylval.op_log = 1; return CMP; }
"<" {yylval.op_log = 2; return CMP; }
">=" {yylval.op_log = 3; return CMP; }
"<=" {yylval.op_log = 4; return CMP; }
"==" {yylval.op_log = 5; return CMP; }
"!=" {yylval.op_log = 6; return CMP; }

[\ \n\t]*	{;}
. {printf("(%s) Não reconhecido\n",yytext);}
%%