## Level 0

- Commands used:

    - `ssh bandit@bandit.labs.overthewire.org -p 2220` </br>
       `-p` stands for port

    - ![level-0](.//bandit-level-screenshots/level-0.png)

## Level 0 - Level 1

- Commands used:
    - `ls` - command allows us to see list of files in directory.
    - `cat` - command is used to view content od `readme` file.
    - `exit` - command is used when we want to exit server.

    - ![level-1](.//bandit-level-screenshots/level-0-1.png)

## Level 1 - Level 2

- Commands used:
    - `ls`
    - `-` - is a special character, and it is **not recommended to start your file name with it.**</br>
    - `cat ./*` - command used to display contents in `-` file.
    - `exit` - command ues to exit current SSH session.

    - ![level-2](.//bandit-level-screenshots/level-1-2.png)

## Level 2 - Level 3

- Commands used:
    - `ssh bandit2@bandit.labs.overthewire.org -p 2220`
    - `cat "spaces in this filename"` - 

- Note:
    - used quotation marks because of spaces inside of file name, better practice would be to name it `spaces-in-this-filename`.   
    - tip: `cat spaces\ in\ this\ filename` - this command is also alternative.

    - ![level-3](.//bandit-level-screenshots/level-2-3.png)

## Level 3 -Level 4

- Commands used:
    - `ssh bandit3@bandit.labs.overthewire.org -p 2220`
    - `ls -la` - commands lists all hidden files and directories.
    - `cat .hidden` - view content of .hidden file.

    - ![level-4](.//bandit-level-screenshots/level-3-4.png)

## Level 4 - Level 5

- Commands used:
    - `ssh bandit4@bandit.labs.overthewire.org -p 2220`
    - `file ./*` - use file command to check which file content is in Human Readable format.
    - `cat ./-file07` - a file with ASCII text (Human Readable).

    - ![level-5](.//bandit-level-screenshots/level-4-5.png)

## Level 5 - Level 6

- Commands used:
    - `ssh bandit5@bandit.labs.overthewire.org -p 2220`
    - `ls -la`
    - `man find` - command is used to open manual for command find.
    - `find . -type f -size 1033c ! -executable`
    - `cat ./maybehere07/.file2` - display contents of file.

- Note:
    - `.` - stands that the search will be conducted within current directory.
    - `-type f` - indicates our interest in files.
    - `size 1033c` - indicates that file must be in 1033 bytes in size.
    - `! -executable` - indicates that file must not be executable.    

    - ![level-6](.//bandit-level-screenshots/level-5-6.png)

## Level 6 - 7

- Commands used:
    - `ssh bandit6@bandit.labs.overthewire.org -p 2220`
    - `find / -type f -user bandit7 -group bandit6 -size 33c`

- Note:

    - `find /` - search the entire filesystem.
    - `-type f -user bandit7 -group bandit6` - for a file owned by user bandit7 and group bandit6.
    - `33c` - file must be 33 bytes in size.

    - ![level-7](.//bandit-level-screenshots/level-6-7a.png)
    - ![level-7](.//bandit-level-screenshots/level-6-7b.png)


## Level  7 - 8

- Commands used:
    - `ssh bandit7@bandit.labs.overthewire.org -p 2220`
    - `man grep`
    - `grep millionth data.txt` - searching file data.txt under term millionth.

    - ![level-7](.//bandit-level-screenshots/level-7-8.png)

## Level 8 - 9

- Commands used:
    - `ssh bandit8@bandit.labs.overthewire.org -p 2220`
    - `cat data.txt`
    - `man sort`
    - `man uniq`
    - `sort data.txt | uniq -c` - sorts file data in number of count.
    - `sort data.txt | uniq -u` - is used for unique output.

- Note:

    - `sort` - command sorts the lines in a text file in alphabetical order [A - Z].
    - `uniq` - command filters out duplicate lines in a text file and outputs unique lines, with `-u` it will output those lines that occur EXACTLY once.
    - `count` - command show the number of occurances of a single line

    - ![level-8](.//bandit-level-screenshots/level-8-9.png)

## Level 9 - 10

- Commands used:

    - `ssh bandit9@bandit.labs.overthewire.org -p 2220`
    - `man strings`
    - `ls`
    - `strings data.txt | grep =======`

- Note:

    - `strings` - finds **human-readable** strings in file
    - `strings data.txt | grep =======` - finds **human-readable** strings in file, that have several `=` signs, that means more than 2.

    - ![level-9](.//bandit-level-screenshots/level-9-10.png)

## Level 10 - 11

- Commands used: 

    - `cat data.txt`
    - `man base64`
    - `base64 -d data.txt` - command that decodes data in file.

    - ![level-10](.//bandit-level-screenshots/level-10-11.png) 



       


