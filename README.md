# misc-scripts

Just misc scripts

---

### lll.ps1 - file lister

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

Show sizes

> `lll.ps1 -ShowSize`

Output to file

> `lll . 99 '*.js' > jss.txt`
