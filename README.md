# Racket Parser

Zachary Halderwood | 12368443 | zjuvz6@mail.umkc.edu

University of Missouri - Kansas City | CS441 | Fall 2021

This project is designed to scan and parse scripts written using a custom calculator grammar. It will not produce a parse tree; however, it will assess the lexical and syntactic correctness of a given text file.


## User Guide

1) Clone the repository to your local machine.

2) Open *parser.rkt* in DrRacket and click the "Run" button. This will execute parsing on all of the provided input files.

3) To parse a different file, first copy the file to the parent directory of the project. (this should be the same folder in which *parser.rkt* is located.) 

4) Next, add a line to the bottom of the application as below:

```
(parser "different-file.txt")
```

5) Click "Run". It should execute scanning and parsing on your file and output the result in the console. 

### Pragmas and Rules

If a lexical error is detected, the scanner will stop analysis and send an error to the parser indicating the line number and symbol that caused the error. The parser will then print the error message to the console.

Similarly, the parser will print a message to the console indicating the location and cause of any syntactic error.

Spaces around variables are necessary in order for the scanner to tell them apart from other tokens.

```
READa ; This is a valid variable name.
READ a ; This is a valid statement.
```

The scanner is case-insensitive. A variable name *MyVariable* is equivalent to *myvariable*. This was done to minimize risk of capitalization mistakes, particularly with regard to *read* and *write* commands.

```myvariable === MyVariable ; If our language provided for deep equality comparisons, it would find these to be the same object.```

Variable names must began with an alphabetic character (A-Z), but they may contain numbers (0-9).

Numbers can include decimal points. Neither the scanner nor the parser will raise issue if a number has multiple decimal points. Logic to catch this error could (and maybe should) be implemented in a semantic analyzer.

Statements and expressions must be completed on one line. If a statement or expression begins on line 1 and ends on line 2, the parser will raise an error when it reaches the end of line 1.


## LL1 Grammar Rules

This is the set of productions that the parser was built on.

```
program −→ stmt-list $$

stmt list −→ stmt stmt-list | ε

stmt −→ id := expr | read id | write expr

expr −→ term term-tail

term tail −→ add-op term term-tail | ε

term −→ factor factor-tail

factor tail −→ mult-op factor factor-tail | ε

factor −→ ( expr ) | id | number

add op −→ + | -

mult op −→ * | /
```


## How does this thing work, anyway?

Great question!

There are a few steps to the logic of the application, as you will see below.

### 1. Lexical analysis

This is performed by the functions in *scanner-core.rkt*. This application first defines functions for matching char inputs to recognized symbols.

There are also special recursive functions for tokenizing numeric and alphabetic symbols, since those symbols can vary in length.

These functions are called by the *scan-next* function as it recursively iterates through the entire input list.

To execute this logic, we call the *scanner* function with the input file name as a parameter. This function breaks down every character in the file into a list of chars, then passes the list to the above function:

### 2. Syntactic Analysis

This is performed by functions in *parser.rkt*. For each production, there is a function which takes a token list and line number as parameters. Except for the add-op and mult-op productions; the logic for those productions was handed off to the scanner for the sake of simplicity.

Starting with the *program* function, these each call upon each other in a top-down manner. The logic is very similar to what you see in the grammar section above, though there is a bit more nuance to the actual code.

The application will recursively iterate through each token, identifying the appropriate branch based on the next token or tokens in the input stack. This code is not intended for real life use, so it does not preserve the parse tree as it traverses it. Instead, valid productions are consumed upon recognition. If the *stmt_list* receives back an empty input stack, that means the algorithm found no syntax errors, and an "ACCEPT" result is returned.
