#include <cassert>
#include <cstdio>
#include <iostream>
#include <memory>
#include <string>
using namespace std;

// 声明 lexer 的输入，和 parser 函数
extern FILE *yyin;
extern int yyparse(unique_ptr<string> &ast);

int main(int argc, const char *argv[]) {
    // 用法：compiler {模式} {输入文件} -o {输出文件}
    assert(argc == 5);
    auto mode = argv[1];
    auto input = argv[2];
    auto output = argv[4];

    // 指定 lexer 在解析时读取这个文件
    yyin = fopen(input, "r");
    assert(yyin);

    // 调用 parser 函数，其中会进一步调用 lexer 解析文件
    unique_ptr<string> ast;
    auto ret = yyparse(ast); // parser 返回一个 int，若成功则返回 0
    assert(!ret);

    // 输出解析得到的 ast（一个 string）
    cout << *ast << endl;
    return 0;
}
