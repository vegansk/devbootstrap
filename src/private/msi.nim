import nimshell

when defined(windows):
  proc installMsi*(msi: string, targetDir: string) =
    >>! cmd"""msiexec /i "${msi}" TARGETDIR="${targetDir}" /qb-"""
