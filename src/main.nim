import nimshell, os, logging

when defined windows:
  import private/far_manager
  proc appRoot(): string = "c:\\apps"

  proc installOnWindow() =
    setupFarManager tmpDir, appRoot() / "Far"
  
elif defined linux:
  proc appRoot(): string = joinPath(getHomeDir(), "apps")
  proc pkgInstall(pkg: string) =
    >>! cmd"sudo apt-get install -y ${pkg}" 

  proc installGit() =
    if not ?"git".which:
      info "Install git..."
      pkgInstall "git"

  proc installGcc() =
    if not ?"gcc".which:
      info "Install gcc..."
      pkgInstall "gcc"
    if not ?"g++".which:
      info "Install g++..."
      pkgInstall "g++"

  proc installOnLinux() =
    installGit()
    installGcc()
    
when isMainModule:
  logging.addHandler(newConsoleLogger())

  let tmpDir = mktemp()
  defer: removeDir(tmpDir)

  info "Temp dir is " & tmpDir

  when defined windows:
    installOnWindows()
  elif defined linux:
    installOnLinux()
