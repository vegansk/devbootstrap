#!/usr/bin/env nim
mode = ScriptMode.Verbose

import project/project

version     = "0.1"
author      = "Anatoly Galiulin"
description = "Developer tools bootstrap"
license     = "GPLv3"

requires "nim >= 0.12.1", "https://github.com/vegansk/nimshell#master, nimfp >= 0.0.1"

proc buildBase(debug = true, bin: string, src: string) =
  if not dirExists "bin":
    mkDir "bin"
  switch("out", (thisDir() & "/bin/" & bin).toExe)
  --nimcache: build
  if not debug:
    --forceBuild
    --define: release
    --opt: size
  else:
    --define: debug
    --debuginfo
    --debugger: native
    --linedir: on
    --stacktrace: on
    --linetrace: on
    --verbosity: 1

    --NimblePath: src
    --NimblePath: srcdir
    
  setCommand "c", src

task debug, "Build debug version":
  buildBase true, "devbootstrap_d", "src/main"

task release, "Build release version":
  buildBase false, "devbootstrap", "src/main"

task clean, "Clean":
  rmDir "build"

task rebuild, "Rebuild release":
  deps clean, release

task run, "Run debug version":
  dep debug
  exec "bin/devbootstrap_d"
