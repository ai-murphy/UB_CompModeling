# Exercises

1) Generate a list of files from the /etc directory using he long format and sorting them by modification time, here the newest files should appear in the first osition. Redirect the output to the etc.out file.

    `ls -lhat /etc > etc.out`
2) Generate a list of the files (including the hidden iles) of the $HOME folder that has the "txt" "doc" or odt" extension.
    
    `ls -lha ~/*txt ~/*doc ~/*odt`
3) Write a command to change the permissions of the etc.ut file to be only readable and writeable for you and our group. 
    
    `chmod 660 etc.out`
    
    -OR-

    `chmod o-rw`

4) Use a command to display line 3 to 7 of a file named listat.llarg
    - Generate a file called llistat.llarg

      `vi llistat.llarg`

    - While in vi, write a line of text "lorem ipsum here is some text"
        
        `<i>
        lorem ipsum here is some text
        <Esc>`

    - Copy the line 10x

            yy
            9p
    - Number the lines
      
      `:%s/^/\=line('.').' ' `
            
        Explanation:
        
        `:%s` — substitute across all lines in the file.
        
        `^` — matches the beginning of each line.
        
        `\=line('.')` — evaluates the current line number.
        
        `' '` — adds a space after the number for readability.
            
    - Write the file and quit vi
        
        `:wq`
    - Combine head (to show the first 7 lines) and tail commands (to skip 2 lines from the top)
            
        `head -n 7 llistat.llarg | tail -n +3`
  5) Generate a list of files of the $HOME folder with extension ".f90" that has exactly 20 lines.
        
        `ls -lha $HOME | grep \.f90$ | head -n 20`
  6) Write a small set of commands to generate the file "poem.txt" with the following content: 

       ~~~
       I went down to the river, 
       I set down on the bank. 
       I tried to think but couldn't, 
       So I jumped in and sank. 
       ~~~

      ~~~bash
      echo "I went down to the river," > poem.txt
      echo "I set down on the bank." >> poem.txt
      echo "I tried to think but couldn't," >> poem.txt
      echo "So I jumped in and sank." >> poem.txt
      ~~~


  7) Write a command that generates another file named "me" that select all the lines of "poem.txt" that starts with "I". 
      `cat poem.txt | grep ^I > me`

  8) Write a combined command (with pipe) to select the characters 10 to 15 of the lines of file name "devices.txt" that do not contain the word "to" 
  
      `cat poem.txt | grep -v -w 'to' | cut -c 10-15`


---


# vi Exercise Solutions

## Exercise 2
1) Use case-insensitive matching to replace all instances of the word Number with its roper formatting
    
    `:%s/\cNumber/Number/g`
2) Use case-insensitive matching to replace all instances of the word Letter with its roper formatting
    
    `:%s/\cLetter/Letter/g`
3) Take the last word of the line and replace it with a lowercase equivalent
    
    `:%s/\(\w*\)$/\L\1/g`

## House 
1) Replace 3rd-5th instance of ABCD on lines 4 & 9 with 12 dashes

    1 `:4s/\%9v.\{12}/------------/`

    2 `:9s/\%9v.\{12}/------------/`
2) Replace 3rd-5th instance of ABCD on lines 5-8 with pipe character, 10 spaces, then nother pipe

    `:5,8s/\%9v.\{12}/|          |/`
3) Replace .BCDABCDABC on line 18 with a dot followed by 10 dashes

    `:18s/\%30v.\{10}/----------/`
4) Replace columns 30-39 on lines 20-29 with a pipe character, 8 spaces, then another pipe

    `:19,29s/\%30v.\{10}/|        |/`
5) Replace new pipe followed by space on line 24 with a pipe followed by a lowercase o

    `:24s/\%31v./o/`


