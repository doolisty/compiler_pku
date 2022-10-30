// 其中的内容会放到 Bison 生成的【头文件】中
%code requires {
    #include <memory>
    #include <string>
    #include "ast.hpp"
}

// 其中的内容会放到 Bison 生成的【源文件】中
%{

#include <iostream>
#include <memory>
#include <string>
#include "ast.hpp"

// 声明 lexer 函数和错误处理函数
int yylex();
void yyerror(std::unique_ptr<BaseAST> &ast, const char *s);

using namespace std;

%}

%parse-param { std::unique_ptr<BaseAST> &ast }

%union {
    std::string *str_val;
    int int_val;
    BaseAST *ast_val;
}

%token INT RETURN
%token <str_val> IDENT
%token <int_val> INT_CONST

// 非终结符
%type <ast_val> FuncDef FuncType Block Stmt
%type <int_val> Number

%%

CompUnit
    : FuncDef {
        auto comp_unit = make_unique<CompUnitAST>();
        comp_unit->func_def = unique_ptr<BaseAST>($1);
        ast = move(comp_unit);
    }
    ;


FuncDef
    : FuncType IDENT '(' ')' Block {
        auto ast = new FuncDefAST();
        ast->func_type = unique_ptr<BaseAST>($1);
        ast->ident = unique_ptr<string>($2);
        ast->block = unique_ptr<BaseAST>($5);
        $$ = ast;
    }
    ;

FuncType
    : INT {
        auto ast = new FuncTypeAST();
        ast->func_type = make_unique<string>("int");
        $$ = ast;
    }
    ;

Block
    : '{' Stmt '}' {
        auto ast = new BlockAST();
        ast->stmt = unique_ptr<BaseAST>($2);
        $$ = ast;
    }
    ;

Stmt
    : RETURN Number ';' {
        auto ast = new StmtAST();
        ast->number = $2;
        $$ = ast;
    }
    ;

Number
    : INT_CONST {
        $$ = $1;
    }

%%

void yyerror(unique_ptr<BaseAST> &ast, const char *s) {
    cerr << "error: " << s << endl;
}

