# misc-scripts

Just a personal script with features I use day-to-day

---

### lll.ps1 

A simple recursive folder lister with filtering and size info

#### Examples:

Listing files in current directory + 1 level deeper:
> `lll.ps1 -base "." -depth 1`
> 
> Or just
> 
> `lll . 1`

Only .py in `D:\Scripts`:
> `lll.ps1 -base "D:\Scripts" -filter "*.py"`
> 
> Or
> 
> `lll 'D:\Scripts' 0 '*.py'`

Show sizes:
> `lll.ps1 -ShowSize`

Output to file:
> `lll . 99 '*.js' > jss.txt`
