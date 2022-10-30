#pragma once

#include <iostream>
#include <string>
#include <memory>

class BaseAST {
public:
    virtual ~BaseAST() = default;
    virtual void Dump() = 0;
};

class CompUnitAST : public BaseAST {
public:
    std::unique_ptr<BaseAST> func_def;
    
    void Dump() {
        std::cout << "CompUnitAST { ";
        func_def->Dump();
        std::cout << " }";
    }
};

class FuncDefAST : public BaseAST {
public:
    std::unique_ptr<BaseAST> func_type;
    std::unique_ptr<std::string> ident;
    std::unique_ptr<BaseAST> block;

    void Dump() {
        std::cout << "FuncDefAST { ";
        func_type->Dump();
        std::cout << ", " << *ident << ", ";
        block->Dump();
        std::cout << " }";
    }
};

class FuncTypeAST : public BaseAST {
public:
    std::unique_ptr<std::string> func_type;

    void Dump() {
        std::cout << "FuncTypeAST { " << *func_type << " }";
    }
};

class BlockAST : public BaseAST {
public:
    std::unique_ptr<BaseAST> stmt;

    void Dump() {
        std::cout << "BlockAST { ";
        stmt->Dump();
        std::cout << " }";
    }
};

class StmtAST : public BaseAST {
public:
    int number;

    void Dump() {
        std::cout << "StmtAST { " << number << " }";
    }
};
