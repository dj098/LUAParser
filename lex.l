%{
	#include "luaparser.tab.h"
	#include <string.h>
	#include <stdio.h>
	#include <stdlib.h>

	int col = 1;
	int line = 1;
	int counter = 0;
	int isFunc = 1;
	int check = 0;
	int s_check = 0;

	char recent[50];
	typedef struct node
	{
		char name[50];
		int type;
	    int col;
	    int row;
	    int scope;
	}sym_tab;
	sym_tab tokenList[1024];
	sym_tab symbol_table[100];

	int Search_Symbol(char* str)
	{
		for(int i = 0 ; i < counter ; i++)
		{	
			//Functions and Identifiers can have Same Names
			if(strcmp(symbol_table[i].name,str) == 0)
			{
				return 1;
			}
		}
		
		return 0;
	}

%}

%%
"--".*	{}
\"(\\.|[^"\\])*\" 	{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _STRING_;}
[0-9]+ 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _NUMBER_;}
"and" 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _AND_;}
"break" 			{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _BREAK_;}
"do"				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _DO_;}
"else"  			{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _ELSE_;}
"elseif" 			{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _ELSEIF_;}
"end" 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _END_;}
"false"				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _FALSE_;}
"for"				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _FOR_;}
"function" 			{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); check = 1;return _FUNCTION_;}
"if" 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _IF_;}
"in" 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _IN_;}
"local" 			{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext);s_check = 1; return _LOCAL_;}
"nil"  				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _NIL_;}
"not"  				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _NOT_;}
"or"  				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _OR_;}
"repeat"  			{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _REPEAT_;}
"return"  			{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _RETURN_;}
"then"  			{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _THEN_;}
"true"  			{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _TRUE_;}
"until"  			{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _UNTIL_;}
"while"  			{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _WHILE_;}
"+" 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _PLUS_;}     
"-" 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _MINUS_;}    
"*"  				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _STAR_;}    
"/" 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _DIV_;}   
"%" 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _PERCENT_;}    
"^" 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _POWER_;}    
"#" 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _HASH_;}    
"==" 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _EQUAL_;}    
"~=" 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _NOTEQUAL_;}    
"<=" 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _LTE_;}    
">=" 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _GTE_;}    
"<" 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _GT_;}    
">" 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _LT_;}    
"=" 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _ASSIGN_;}    
"(" {
	if(isFunc == 1 && strcmp(recent, symbol_table[counter-1].name) == 0)
	{
		//printf("last token : %s \n",recent);
		//printf("Previous symtab entry : %s \n",symbol_table[counter-1].name );
		symbol_table[counter-1].type = 1;
	}
	isFunc = 0;
	printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _OP_;
	}    
")" 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _CP_;}    
"{" 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _OC_;}    
"}" 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _CC_;}    
"[" 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _OS_;}    
"]" 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _CS_;}    
";" 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _SEMICOLON_;}    
":" 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _COLON_;}    
"," 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _COMMA_;}    
"." 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _DOT_;}    
".." 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _DOUBLEDOT_;}    
"..." 				{isFunc = 0; printf("Sending--->  %s\n",yytext); col = col + strlen(yytext); return _TRIPLEDOT_;}
[a-zA-Z_][a-zA-Z0-9_]* {
	isFunc = 1; printf("Token parsed : %s \n",yytext); 
	strcpy(recent, yytext);
	if(!Search_Symbol(yytext))
	{
		symbol_table[counter].col = col;
		symbol_table[counter].row = line;
		symbol_table[counter].type = check;
		symbol_table[counter].scope = s_check;

		s_check = 0;

		strcpy(symbol_table[counter].name,yytext);
		counter++;
	}
		check = 0;
		col = col + strlen(yytext);

 return _NAME_;
}

"\n" {line++;col = 0;}
"\t" {col+=3;}
" " {col+=1;}
%%

int yywrap() {
    printf("Sending--->  %s\n",yytext); return 1;
}