# Racket Parser

This project is designed to scan and parse scripts written using a custom calculator grammar. It will not produce a parse tree; however, it will assess the syntactic correctness.

## LL1 Grammar Rules

program −→ stmt list $$
stmt list −→ stmt stmt list | ε
stmt −→ id := expr | read id | write expr
expr −→ term term tail
term tail −→ add op term term tail | ε
term −→ factor factor tail
factor tail −→ mult op factor factor tail | ε
factor −→ ( expr ) | id | number
add op −→ + | -
mult op −→ * | /