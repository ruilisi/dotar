# Vim Basic
## Shortcuts

Shortcut |Function
:--------|:--------
h[ljk]   | Move cursor left/right/down/up
o        | Insert a new line below
O        | Insert a new line above
a        | Insert to the right of the cursor
A        | Insert at the end of line
i        | Insert to the left of the cursor
I        | Insert at the beginning of current line
u        | Undo operation
U        | Undo operation by line
CTRL r   | Redo
x        | Delete selected content
dw       | Delete word
d$       | Delete to end of line
dd       | Delete entire line
d[num]w  | Delete the specified number of words
r        | Replace a character
R        | Enter replacement mode
0        | Go to the beginning of the line
$        | Go to the end of the line
v        | Enter character selection mode
V        | Enter line selection mode
y        | Copy selected content
yy       | Copy entire line
p        | Paste copied content
Ctrl+u   | Page up
Ctrl+d   | Page down
:w       | Save file
:q       | Quit vim
w        | Move forward one word
b        | Move back one word
gg       | Move to the top of the file
G        | Move to the bottom of the file
Ctrl+\   | Show(hide) the Buffers
/ keyword| Search
n        | Go to the next content
N        | Go to the previous content
SPC c l  | (Un)comment the selected line
gg       | Move to the top
G        | Move to the bottom
CTRL g   | Show current cursor position
[NUM] G  | Cursor to the specified line
0        | Cursor to the beginning of the line
[NUM] w  | Move the cursor to the beginning of the specified number of words
[NUM] e  | Move the cursor to the end of the specified number of words
:[%]s/A/B[/g]| Replae Key1 with Key2(`%`: Selected area, `g`: for all occurrences in every line)
:q       | Quit
:w       | Save
:wq      | Save & quit
:q!      | Foce quit
ESC      | Exit current mode
