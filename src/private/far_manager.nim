import httpclient, nimshell, logging, os

proc downloadFarManager(tmpDir: string): string =
  result = tmpDir / "far.msi"
  info "Downloading far manager to " & result
  downloadFile("http://www.farmanager.com/files/Far30b4455.x86.20151115.msi", result)
  info "Downloading far manager to " & result & " done!"

  
proc setupFarManager*(tmpDir: string) =
  if ?(which "far"):
    info "Far manager allready installed"
  else:
    let tmp = downloadFarManager(tmpDir)
    >>! cmd"start ${tmp}"
