Duo Yu
dyu33
Winter 2021
Lab 4: Syntax Checker

-----------
DESCRIPTION

In this lab, you will develop a simple syntax checker that opens a file and determines whether it has balanced braces, brackets, and parentheses. This type of syntax checking is often used in programs to determine the point of a “syntax error” that the programmer needs to fix. You will use MIPS and the stack to check the balance and report either the location of a mismatch on failure or the number of matched items on success.



-----------
FILES

Lab4.asm

README.txt

test1.txt test2.txt test3.txt


-----------
INSTRUCTIONS

Read the file name. 
Check it if the first character is a letter. 
Check the length of the name. 
Open file and read file. 
load to the buffer
load the first character from the buffer
check if it is a open brace. if it is then push to the stack
check if it is a close brace. if it is then start read from the stack to find the fitting open brace
if there is one, then pop out the open brace and store a ramdom number
if there is not, then print mismatch and index of it
if there is more open braces, then print out all the open braces on the stack
if there is equal braces, then give success message and give out how many pairs
quit the program