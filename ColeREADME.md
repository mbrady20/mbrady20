Changed files:
Makefile: added _getfilename\ to UPROGS.
proc.c: added the struct file so name could be accessed. Added getfilename method.
sysproc.c: added argfd. added getfilename
syscall.c: added system call to getfilename and declaration
syscall.h: added system call number
file.h: added name paramater to struct file
usys.S: added "SYSCALL(getfilename)"
user.h: added system call
getfilename.c: User-level program
