%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    extern FILE * yyin;
    int yyerror(const char *msg);
    int yylex();
    extern char yytext[];
	extern int line;
	extern int col;

	typedef struct node
	{
		char name[50];
		int type;
	    int col;
	    int row;
	    int scope;
	}sym_tab;

	extern sym_tab symbol_table[];
	extern int counter; 
%}

%error-verbose

%token _NUMBER_
%token _STRING_
%token _AND_
%token _BREAK_
%token _DO_
%token _ELSE_
%token _ELSEIF_
%token _END_
%token _FALSE_
%token _FOR_
%token _FUNCTION_
%token _IF_
%token _IN_
%token _LOCAL_
%token _NIL_
%token _NOT_
%token _OR_
%token _REPEAT_
%token _RETURN_
%token _THEN_
%token _TRUE_
%token _UNTIL_
%token _WHILE_
%token _PLUS_
%token _STAR_
%token _MINUS_
%token _DIV_
%token _PERCENT_
%token _NAME_
%token _POWER_
%token _HASH_
%token _EQUAL_
%token _NOTEQUAL_
%token _LTE_
%token _GTE_
%token _GT_
%token _LT_
%token _ASSIGN_
%token _OP_
%token _CP_
%token _OC_
%token _CC_
%token _OS_
%token _CS_
%token _SEMICOLON_
%token _COLON_
%token _COMMA_
%token _DOT_
%token _DOUBLEDOT_
%token _TRIPLEDOT_

%left      _PLUS_ _MINUS_
%left      _STAR_ _DIV_ _PERCENT_
%right     _EXP_
%left      _OR_ 
%left      _AND_
%left      _LT_ _LTE_ _GT_ _GTE_ _EQUAL_ _NOTEQUAL_
%right     _DOUBLEDOT_
%right     _NOT_ _HASH_ 
%right     _POWER_

%%
   

    chunk   : block  
            ;

    eps     : 
            ;

    semi    : _SEMICOLON_
            | eps
            ;         

    block   : scope statlist 
            | scope statlist laststat semi
            ;

    ublock  : block _UNTIL_ exp
            ;

    scope   : eps
            | scope statlist binding semi
            ;

    statlist    : eps
            | statlist stat semi
            ;

    stat    : _DO_ block _END_
            | _WHILE_ exp _DO_ block _END_
            | repetition _DO_ block _END_
            | _REPEAT_ ublock
            | _IF_ conds _END_
            | _FUNCTION_ funcname funcbody
            | setlist _ASSIGN_ explist1
            | functioncall         
            ;

repetition  : _FOR_ _NAME_ _ASSIGN_ explist23
            | _FOR_ namelist _IN_ explist1
            ;

    conds   : condlist
            | condlist _ELSE_ block
            ;

condlist : cond
             | condlist _ELSEIF_ cond
             ; 

cond    : exp _THEN_ block           
            ;

laststat    : _BREAK_
            | _RETURN_
            | _RETURN_ explist1
            ;

binding     : _LOCAL_ namelist
            | _LOCAL_ namelist _ASSIGN_ explist1
            | _LOCAL_ _FUNCTION_ _NAME_ funcbody
            ;


funcname    : dottedname
            | dottedname _COLON_ _NAME_
            ;

dottedname  : _NAME_
            | dottedname _DOT_ _NAME_
            ;                    

namelist    : _NAME_
            | namelist _COMMA_ _NAME_
            ;

explist1    : exp
            | explist1 _COMMA_ exp
            | _OP_ exp _CP_
            | _OP_ explist1 _COMMA_ exp _CP_ 
            ;

explist23   : exp _COMMA_ exp
            | exp _COMMA_ exp _COMMA_ exp
            | _OP_ exp _COMMA_ exp _CP_
            | _OP_ exp _COMMA_ exp _COMMA_ exp _CP_
            ;

exp         : _NIL_ | _TRUE_ | _FALSE_ | _NUMBER_ | _STRING_ | _TRIPLEDOT_
            | function
            | prefixexp
            | tableconstructor
            | _NOT_ exp
            | _HASH_ exp
            | _MINUS_ exp 
            | exp _OR_ exp
            | exp _AND_ exp
            | exp _LT_ exp 
            | exp _LTE_ exp 
            | exp _GT_ exp 
            | exp _GTE_ exp 
            | exp _EQUAL_ exp
            | exp _NOTEQUAL_ exp
            | exp _DOUBLEDOT_ exp
            | exp _PLUS_ exp
            | exp _MINUS_ exp
            | exp _STAR_ exp
            | exp _DIV_ exp
            | exp _PERCENT_ exp
            | exp _POWER_ exp
            | _OP_ exp _CP_
            ; 
            

setlist     : var
            | setlist _COMMA_ var
            ;

var         : _NAME_
            | prefixexp _OS_ exp _CS_
            | prefixexp _DOT_ _NAME_
            ;        

prefixexp   : var
            | functioncall
            ;

functioncall : prefixexp args
             | prefixexp _COLON_ _NAME_ args
             ;

args        : _OP_ _CP_
            | _OP_ explist1 _CP_
            | tableconstructor
            | _STRING_
            ;

function    : _FUNCTION_ funcbody 
            ;

funcbody    : params block _END_ 
            ;

params      : _OP_ parlist _CP_
            ;

parlist     : eps
            | namelist
            | _TRIPLEDOT_
            | namelist _COMMA_ _TRIPLEDOT_
            ;

tableconstructor : _OC_ _CC_
                 | _OC_ fieldlist _CC_
                 | _OC_ fieldlist _COMMA_ _CC_
                 | _OC_ fieldlist _SEMICOLON_ _CC_ 
                 ;
            
fieldlist   : field
            | fieldlist _COMMA_ field
            | fieldlist _SEMICOLON_ field
            ;

field       : exp
            | _NAME_ _ASSIGN_ exp
            | _OS_ exp _CS_ _ASSIGN_ exp
            ;


%%

int yyerror(const char *msg) {
    printf("ERROR ---- At line %d column %d -> %s \n", line, col, msg);
}

void main() {
    yyin = fopen("input.txt", "r");
    int flag = 1;
    
    if(yyparse() == 1)
    {
    	flag = 1;
    }
    else
    {
    	flag = 0;
    }

    if(flag == 0)
    {
    printf("\n~~~~~~~~~~~~~~~~~~~~~Succesfully Parsed the Input File~~~~~~~~~~~~~~~~~~~~~\n\n");

     printf("-----------------------------SYMBOL TABLE----------------------------------\n\n");
    



    printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
    printf("%-14s|%-14s|%-14s|%-14s|%-14s|\n", "Name" , "Line Number", "Column Number", "Scope", "Type");   
    printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");

    for(int i = 0 ; i < counter ; i++)
    {
        char type[15];
        char scope[15];
        
        if(symbol_table[i].scope == 1)
            strcpy(scope, "Local");
        else
            strcpy(scope, "Global");

        if(symbol_table[i].type == 1)
            strcpy(type, "Function");
        else
            strcpy(type, "Identifier");


        printf(" %-12s | %-12d | %-12d | %-12s | %-12s |\n",symbol_table[i].name,symbol_table[i].row,symbol_table[i].col, scope, type);
    }
        printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
    }
    else
    {
    printf("\n\n\n\n\n~~~~~~~~~~~~~~~~~~~~~Failure in Parsing the Input File~~~~~~~~~~~~~~~~~~~~~\n\n\n\n");
    }

    fclose(yyin);



}
