Duo Yu
dyu33
Winter 2020
Lab 3: ASCII-risks (Asterisks)

-----------
DESCRIPTION

This lab will introduce you to the MIPS ISA using MARS. You will write a program with several nested loops to print variable sized ASCII diamond and a sequence of embedded numbers.
In addition, this lab will introduce you to several different syscalls to incorporate I/O into your program.

-----------
FILES

Lab3.asm

REAME.txt

-----------
INSTRUCTIONS

at first, it would detect if the number is bigger than 0. Then, the number of level would load into t0. I set t7 as the level of the pattern which would increase through loop. I use t1 and t2 as counting of how many * and tab on each side. At the end, I would print a new line after a line. When the t7 is equal to t0, the loop is over.
