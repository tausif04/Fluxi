# Fluxi
A Mini Compiler Using Flex & Bison
Fluxi is a simple educational programming language created for the Compiler Design Laboratory. It demonstrates lexical analysis, syntax parsing, semantic checking, and code execution. This repository contains the full implementation of the Fluxi compiler.

Features

Variable declaration: num, real, text

Input/output: take, show

Comments:

Single-line: :: comment

Multi-line: ::< ... >::

Conditional statement: check … otherwise … endcheck

Loops:

repeat N begin … stop

forstep begin … until(condition) stop

Supports arithmetic, relational, and logical expressions

Project Structure
lexer.l            # Flex specification
parser.y           # Bison grammar
symbol_table.*     # Symbol table handling
interpreter.*      # Execution logic
fluxi_compiler.c   # Compiler driver
samples/           # Example .fxi programs
docs/              # User manual

Build Instructions

Install Flex & Bison:

sudo apt install flex bison


Compile:

bison -d parser.y
flex lexer.l
gcc parser.tab.c lex.yy.c fluxi_compiler.c symbol_table.c interpreter.c -o fluxi_compiler

Running a Fluxi Program
./fluxi_compiler file.fxi


Example:

./fluxi_compiler samples/hello.fxi

Sample Program
make text name = "Guest";
make num n = 3;

show "Enter your name:";
take name;

repeat n begin
    show "Hello", name;
    n = n - 1;
stop;
