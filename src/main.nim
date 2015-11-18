import nimshell, os

when defined windows:
  proc appRoot(): string = "c:\\apps"
elif defined posix:
  proc appRoot(): string = joinPath(getHomeDir(), "apps")


echo appRoot()
