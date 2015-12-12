import nimshell, os, logging, fp.option

when defined windows:
  import private/far_manager
  proc appRoot: string = "c:\\apps"

  proc installOnWindow() =
    setupFarManager tmpDir, appRoot() / "Far"
  
elif defined linux:
  proc appRoot(): string = joinPath(getHomeDir(), "apps")
  proc pkgInstall(pkgs: varargs[string]) =
    if ?"apt-get".which:
      for pkg in pkgs:
        >>! cmd"sudo apt-get install -y ${pkg}" 
    else:
      fatal "Non debian based systems is not supported yet"
      quit "Non debian based systems is not supported yet"

  proc installGit =
    if not ?"git".which:
      info "Install git..."
      pkgInstall "git"
    info "Git installed"

  proc installGcc =
    if not ?"gcc".which:
      info "Install gcc..."
      pkgInstall "gcc"
    info "Gcc installed"
    if not ?"g++".which:
      info "Install g++..."
      pkgInstall "g++"
    info "G++ installed"

  proc installNim =
    let nimRoot = appRoot() / "Nim"
    if nimRoot.dirExists:
      info "Directory ", nimRoot, " already exists, skip installation!"
    else:
      createDir nimRoot
      setCurrentDir nimRoot
      >>! cmd"git clone https://github.com/vegansk/Nim ."
      >>! cmd"git checkout my"
      >>! cmd"./bootstrap.sh"
      >>! cmd"""${nimRoot / "bin" / "nim"} ${nimRoot / "install_nimble.nims"}"""
    if not ?"nim".which:
      info "Nim not found in the PATH. Please add it:\n" &
           "  export PATH=$PATH:", nimRoot / "bin"

  proc installEmacs =
    if not ?"emacs".which:
      pkgInstall "emacs"
    info "Emacs installed"

  proc installOnLinux() =
    installGit()
    installGcc()
    installNim()
    installEmacs()
    
when isMainModule:
  logging.addHandler newConsoleLogger()

  let tmpDir = mktemp()
  defer: removeDir tmpDir

  debug "Temp dir is ", tmpDir

  when defined windows:
    installOnWindows()
  elif defined linux:
    installOnLinux()
