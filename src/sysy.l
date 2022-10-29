%option noyywrap
%option nounput
%option noinput

%{

// C++ 的头文件和全局定义写在这里

#include <cstdlib>
#include <string>

// 由 Bison 生成出来的
#include "sysy.tab.hpp"

using namespace std;

%}

/* 这里写 Flex/Bison 相关的定义
   Flex： 某符号对应的正则表达式
   Bison：定义 终结符/非终结符 的类型 */

/* 空白符，中括号代表或，* 代表0或多 */
WhiteSpace  [ \t\n\r]*

/* 注释 */
LineComment "//".*

/* 标识符 */
Identifier  [a-zA-Z_][a-zA-Z0-9_]*

/* 整数字面量 */
Decimal     [1-9][0-9]*
Octal       0[0-7]*
Hexadecimal 0[xX][0-9a-fA-F]+

%%

{WhiteSpace} { /* 忽略 */ }
{LineComment} { /* 忽略 */ }

"int"           { return INT; }
"return"        { return RETURN; }

{Identifier}    { yylval.str_val = new string(yytext); return IDENT; }

{Decimal}       { yylval.int_val = strtol(yytext, nullptr, 0); return INT_CONST; }
{Octal}         { yylval.int_val = strtol(yytext, nullptr, 0); return INT_CONST; }
{Hexadecimal}   { yylval.int_val = strtol(yytext, nullptr, 0); return INT_CONST; }

.               { return yytext[0]; }

%%

// 用户自定义代码
