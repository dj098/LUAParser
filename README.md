# LUAParser

A Simple LUA language parser 

LUA Parser

This repository contains code base LUA programming language written in C using flex and bison.
Supported features include:

    Parsing constructs of LUA
    Error Reporting
    Token List Generation
    Symbol Table Generation
    

Usage
    
    Compilation:
    bison -d luaparser.y
    flex lex.l 
    gcc lex.yy.c luaparser.tab.c -o op
    
    Run the -o file:
    ./op

    


