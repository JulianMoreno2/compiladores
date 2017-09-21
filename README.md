# compiladores
Repositorio dedicado a la materia Compiladores e Interpretes

## Para compilar

$ bison -d syntaktische.y && flex lexikon.l
$ gcc -o analyzator lex.yy.c syntaktische.tab.c
