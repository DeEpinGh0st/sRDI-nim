import winim/lean

proc bingo(): void {.cdecl, exportc, dynlib.} = 
  when defined(i386):
    discard MessageBox(0, "Hello form x86 bit bingo !", "Nim is Powerful", 0)
    quit(0)
  elif defined(amd64):
    discard MessageBox(0, "Hello form x64 bit bingo !", "Nim is Powerful", 0)
    quit(0)