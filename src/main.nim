import nimshell, os, logging

import private/far_manager

when defined windows:
  proc appRoot(): string = "c:\\apps"
elif defined posix:
  proc appRoot(): string = joinPath(getHomeDir(), "apps")

when isMainModule:
  logging.addHandler(newConsoleLogger())

  let tmpDir = mktemp()
  defer: removeDir(tmpDir)

  info "Temp dir is " & tmpDir

  setupFarManager(tmpDir)
