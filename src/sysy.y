// 其中的内容会放到 Bison 生成的【头文件】中
%code requires {
    #include <memory>
    #include <string>
}

// 其中的内容会放到 Bison 生成的【源文件】中
%{

#include <iostream>
#include <memory>
#include <string>

// 声明 lexer 函数和错误处理函数
int yylex();
void yyerror(std::unique_ptr<std::string> &ast, const char *s);

using namespace std;

%}

%parse-param { std::unique_ptr<std::string> &ast }

%union {
    std::string *str_val;
    int int_val;
}

%token INT RETURN
%token <str_val> IDENT
%token <int_val> INT_CONST

// 非终结符
%type <str_val> FuncDef FuncType Block Stmt Number

%%

CompUnit
    : FuncDef {
        ast = unique_ptr<string>($1);
    }
    ;


FuncDef
    : FuncType IDENT '(' ')' Block {
        auto type = unique_ptr<string>($1);
        auto ident = unique_ptr<string>($2);
        auto block = unique_ptr<string>($5);
        $$ = new string(*type + " " + *ident + "() " + *block);
    }
    ;

FuncType
    : INT {
        $$ = new string("int");
    }
    ;

Block
    : '{' Stmt '}' {
        auto stmt = unique_ptr<string>($2);
        $$ = new string("{" + *stmt + "}");
    }
    ;

Stmt
    : RETURN Number ';' {
        auto number = unique_ptr<string>($2);
        $$ = new string("return" + *number + ";");
    }
    ;

Number
    : INT_CONST {
        $$ = new string(to_string($1));
    }
    ;

%%

void yyerror(unique_ptr<string> &ast, const char *s) {
    cerr << "error: " << s << endl;
}
