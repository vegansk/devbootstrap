import httpclient, nimshell, logging, os, fp.option, future

proc downloadFarManager(tmpDir: string): string =
  result = tmpDir / "far.msi"
  if existsFile result:
    info "Far manager allready downloaded"
  else:
    info "Downloading far manager to " & result
    downloadFile("http://www.farmanager.com/files/Far30b4455.x86.20151115.msi", result)
    info "Downloading far manager to " & result & " done!"

  
proc setupFarManager*(tmpDir: string, localCache = string.none) =
  if ?(which "far"):
    info "Far manager allready installed"
  else:
    let farDir = localCache.map(v => v / "far").getOrElse(tmpDir)
    createDir farDir
    let tmp = downloadFarManager(farDir)
    >>! cmd"msiexec /qb- /a /i ${tmp}"
