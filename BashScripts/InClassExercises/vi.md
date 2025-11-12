
## Notes
- :undo	Undo last command
- :redo	Redo last command
- :history	Look at your command history



## Goal
Make the following files 1-3 end up looking like this:

    Number 1 Letter a
    Number 2 Letter b
    Number 3 Letter c
    Number 4 Letter d
    Number 5 Letter e
    Number 6 Letter f
    Number 7 Letter g
    Number 8 Letter h
    Number 9 Letter i
    Number 10 Letter j
    Number 11 Letter k
    Number 12 Letter l
    Number 13 Letter m
    Number 14 Letter n
    Number 15 Letter o
    Number 16 Letter p
    Number 17 Letter q
    Number 18 Letter r
    Number 19 Letter s
    Number 20 Letter t
    Number 21 Letter u
    Number 22 Letter v
    Number 23 Letter w
    Number 24 Letter x
    Number 25 Letter y
    Number 26 Letter z


## Exercise 1
Starting point:

    Number 1 Letter a
    Nuuumber 2 Letter b
    Numberrr 3 Letter c
    Number 4 Letter d
    N---er 5 Letter e
    Num 6 Letter f
    Number 7 Letter g
    ber 8 Letter h
    Number 9 Letter i
    Number 10 Letter j
    Number 11 Letter k
    Number 12 Letter l
    Number 13 Letter m
    blablabla
    Number 14 Letter n
    Number 15 Letter o
    Number 16 Letter p
    Number blabla 17 Letter q
    Number 18 Letter r
    Number 19 Letter s
    Number 20 Letter t
    Number 21 Letter u Number 22 Letter v Number 23 Letter w Number 24 Letter x
    Number 25 Letter y
    Number 26 Letter z

## Strategy:
1) Remove all dashes

    `:%s/-//g`

2) Replace all words beginning with 'N' with 'Number'

    `:%s/\<N\w*\>/Number/g`

3) Remove all words starting with 'bla'

    `:%s/\<bla\w*\>//g`

4) Replace double spaces with single spaces

    `:%s/  / /g`

5) Replace all words ending with 'ber' with 'Number'

    `:%s/\<\w*ber\>/Number/g`

6) Replace instances of  ' Number' (with a space at the beginning) with new lines

    `:%s/ Number/\rNumber/g`

7) Remove any lines that don't start with 'Number'

    `:g!/^Number/d`
8) Save and quit

    `:wq`


## Exercise 2
Starting point:

    Number 1 Letter a
    NumbEr 2 LEttEr b
    NUMbEr 3 LEttEr c
    NumbEr 4 LEttEr d
    NumbEr 5 LEttEr E
    NumbER 6 LEttER f
    NumbeR 7 LetteR g
    Number 8 LetteR h
    Number 9 LetteR i
    Number 10 LetteR j
    Number 11 Letter k
    NumbeR 12 Letter l
    NUMbeR 13 Letter m
    NUMbeR 14 Letter n
    NUMbeR 15 Letter o
    Number 16 LeTTer p
    Number 17 LeTTer q
    NumbEr 18 LETTEr r
    NumbEr 19 LETTEr s
    NumbEr 20 LETTEr t
    NUMber 21 LeTTer u
    NUMber 22 LeTTer v
    Number 23 Letter w
    Number 24 Letter x
    NUMber 25 Letter y
    Number 26 Letter z
    

## Strategy:
1) Use case-insensitive matching to replace all instances of the word Number with its roper formatting

    `:%s/\cNumber/Number/g`
2) Use case-insensitive matching to replace all instances of the word Letter with its roper formatting

    `:%s/\cLetter/Letter/g`
3) Take the last word of the line and replace it with a lowercase equivalent

    `:%s/\(\w*\)$/\L\1/g`


## Exercise 3
Starting point:
*NOTE: there are spaces behind letters u-z

    Number 1 Letter l
    Number 2 Letter m
    Number 3 Letter n
    Number 4 Letter o
    Number 5 Letter p
    Number 6 Letter q
    Number 7 Letter r
    Number 8 Letter s
    Number 9 Letter t
    Number 10 Letter u 
    Number 11 Letter v 
    Number 12 Letter w 
    Number 13 Letter x 
    Number 14 Letter y 
    Number 15 Letter z 
    Number 16 Letter a
    Number 17 Letter b
    Number 18 Letter c
    Number 19 Letter d
    Number 20 Letter e
    Number 21 Letter f
    Number 22 Letter g
    Number 23 Letter h
    Number 24 Letter i
    Number 25 Letter j
    Number 26 Letter k 

## Strategy:
1) Remove all trailing spaces

    `:%s/\s$//g`
2) Yank the last word of lines 16 through 26 into register A
    - Move cursor to line 16 after the word "Letter"
    - Press control+q (as a substitute for control+v if that is setup as a hotkey for pasting) to enter block highlight mode and include the spaces before the letters
    - Move cursor to the final line past the k
    - -OPTION 1-
    - - Press `:` and this will appear…
        `:'<,'>`
    - - Add "` $y A`" to turn the entire command into `:'<,'> $y A`
    - -OPTION 2-
    - - Press `"A` and then y to yank (The capital A allows for appending)
    - - Press Enter
3) Repeat for lines 1-9 & 10-15, appending results into register A
4) Yank the last word of lines 1-15 into register B



## Exercise 4
New goal: starting from the left, add window & door as on the right
~~~
ABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABC.	ABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABC.
ABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDAB.D	ABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDAB.D
ABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDA.CD	ABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDA.CD
ABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCD.BCD	ABCDABCD------------ABCDABCDABCDABCDABCDABCDABCDABCDABCD.BCD
ABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABC.ABCD	ABCDABCD|          |ABCDABCDABCDABCDABCDABCDABCDABCDABC.ABCD
ABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDAB.DABCD	ABCDABCD|          |ABCDABCDABCDABCDABCDABCDABCDABCDAB.DABCD
ABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDA.CDABCD	ABCDABCD|          |ABCDABCDABCDABCDABCDABCDABCDABCDA.CDABCD
ABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCD.BCDABCD	ABCDABCD|          |ABCDABCDABCDABCDABCDABCDABCDABCD.BCDABCD
ABCDABCDABCDABCDABCDABCDABCDABCDABCDA.CDABCDABCDABC.ABCDABCD	ABCDABCD------------ABCDABCDABCDABCDA.CDABCDABCDABC.ABCDABCD
ABCDABCDABCDABCDABCDABCDABCDABCDABCD.B.DABCDABCDAB.DABCDABCD	ABCDABCDABCDABCDABCDABCDABCDABCDABCD.B.DABCDABCDAB.DABCDABCD
ABCDABCDABCDABCDABCDABCDABCDABCDABC.ABC.ABCDABCDA.CDABCDABCD	ABCDABCDABCDABCDABCDABCDABCDABCDABC.ABC.ABCDABCDA.CDABCDABCD
.BCDABCDABCDABCDABCDABCDABCDABCDAB.DABCD.BCDABCD.BCDABCDABCD	.BCDABCDABCDABCDABCDABCDABCDABCDAB.DABCD.BCDABCD.BCDABCDABCD
A.CDABCDABCDABCDABCDABCDABCDABCDA.CDABCDA.CDABC.ABCDABCDABCD	A.CDABCDABCDABCDABCDABCDABCDABCDA.CDABCDA.CDABC.ABCDABCDABCD
AB.DABCDABCDABCDABCDABCDABCDABCD.BCDABCDAB.DAB.DABCDABCDABCD	AB.DABCDABCDABCDABCDABCDABCDABCD.BCDABCDAB.DAB.DABCDABCDABCD
ABC.ABCDABCDABCDABCDABCDABCDABC.ABCDABCDABC.A.CDABCDABCDABCD	ABC.ABCDABCDABCDABCDABCDABCDABC.ABCDABCDABC.A.CDABCDABCDABCD
ABCD.BCDABCDABCDABCDABCDABCDAB.DABCDABCDABCD.BCDABCDABCDABCD	ABCD.BCDABCDABCDABCDABCDABCDAB.DABCDABCDABCD.BCDABCDABCDABCD
ABCDA.CDABCDABCDABCDABCDABCDA.CDABCDABCDABCDABCDABCDABCDABCD	ABCDA.CDABCDABCDABCDABCDABCDA.CDABCDABCDABCDABCDABCDABCDABCD
ABCDAB.DABCDABCDABCDABCDABCD.BCDABCDABCDABCDABCDABCDABCDABCD	ABCDAB.DABCDABCDABCDABCDABCD.----------DABCDABCDABCDABCDABCD
ABCDABC.ABCDABCDABCDABCDABC.ABCDABCDABCDABCDABCDABCDABCDABCD	ABCDABC.ABCDABCDABCDABCDABC.A|        |DABCDABCDABCDABCDABCD
ABCDABCD.BCDABCDABCDABCDAB.DABCDABCDABCDABCDABCDABCDABCDABCD	ABCDABCD.BCDABCDABCDABCDAB.DA|        |DABCDABCDABCDABCDABCD
ABCDABCDA.CDABCDABCDABCDA.CDABCDABCDABCDABCDABCDABCDABCDABCD	ABCDABCDA.CDABCDABCDABCDA.CDA|        |DABCDABCDABCDABCDABCD
ABCDABCDAB.DABCDABCDABCD.BCDABCDABCDABCDABCDABCDABCDABCDABCD	ABCDABCDAB.DABCDABCDABCD.BCDA|        |DABCDABCDABCDABCDABCD
ABCDABCDABC.ABCDABCDABC.ABCDABCDABCDABCDABCDABCDABCDABCDABCD	ABCDABCDABC.ABCDABCDABC.ABCDA|        |DABCDABCDABCDABCDABCD
ABCDABCDABCD.BCDABCDAB.DABCDABCDABCDABCDABCDABCDABCDABCDABCD	ABCDABCDABCD.BCDABCDAB.DABCDA|o       |DABCDABCDABCDABCDABCD
ABCDABCDABCDA.CDABCDA.CDABCDABCDABCDABCDABCDABCDABCDABCDABCD	ABCDABCDABCDA.CDABCDA.CDABCDA|        |DABCDABCDABCDABCDABCD
ABCDABCDABCDAB.DABCD.BCDABCDABCDABCDABCDABCDABCDABCDABCDABCD	ABCDABCDABCDAB.DABCD.BCDABCDA|        |DABCDABCDABCDABCDABCD
ABCDABCDABCDABC.ABC.ABCDABCDABCDABCDABCDABCDABCDABCDABCDABCD	ABCDABCDABCDABC.ABC.ABCDABCDA|        |DABCDABCDABCDABCDABCD
ABCDABCDABCDABCD.B.DABCDABCDABCDABCDABCDABCDABCDABCDABCDABCD	ABCDABCDABCDABCD.B.DABCDABCDA|        |DABCDABCDABCDABCDABCD
ABCDABCDABCDABCDA.CDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCD	ABCDABCDABCDABCDA.CDABCDABCDA|        |DABCDABCDABCDABCDABCD
~~~

## Strategy:
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

