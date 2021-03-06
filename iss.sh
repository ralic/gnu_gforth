#!/bin/bash

#Copyright (C) 2000,2003,2006,2007,2009,2011,2012,2016 Free Software Foundation, Inc.

#This file is part of Gforth.

#Gforth is free software; you can redistribute it and/or
#modify it under the terms of the GNU General Public License
#as published by the Free Software Foundation, either version 3
#of the License, or (at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.#See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program; if not, see http://www.gnu.org/licenses/.

# This is the horror shell script to create an automatic install for
# Windoze.
# Note that I use sed to create a setup file

# use iss.sh >gforth.iss
# copy the resulting *.iss to the location of your Windows installation
# of Gforth, and start the setup compiler there.

VERSION=$(./gforth --version 2>&1 | cut -f2 -d' ')
machine=$(./gforth --version 2>&1 | cut -f3 -d' ')
SF=$(./gforth -e 'cell 8 = [IF] ." 64" [THEN] bye')
CYGWIN=cygwin$SF

for i in lib/gforth/$VERSION/$machine/libcc-named/*.la
do
    sed "s/dependency_libs='.*'/dependency_libs=''/g" <$i >$i+
    mv $i+ $i
done

make doc pdf install.TAGS >&2

#cp /bin/cygwin1.dll cygwin-copy.dll
#./gforth fixpath.fs cygwin-copy.dll "/bin/cygwin-console-helper.exe" "./cygwin-console-helper.exe" 1>&2
#./gforth fixpath.fs cygwin-copy.dll "/usr/bin/sh" "./sh" 1>&2
#./gforth fixpath.fs cygwin-copy.dll "/bin/sh" "./sh" 1>&2
#./gforth fixpath.fs cygwin-copy.dll "/bin/sh" "./sh" 1>&2

cat <<EOF
; This is the setup script for Gforth on Windows
; Setup program is Inno Setup

[Setup]
AppName=Gforth$SF
AppVersion=$VERSION
AppCopyright=Copyright � 1995-2015,2016 Free Software Foundation
DefaultDirName={pf}\gforth$SF
DefaultGroupName=Gforth$SF
AllowNoIcons=1
InfoBeforeFile=COPYING
Compression=lzma
DisableStartupPrompt=yes
ChangesEnvironment=yes
OutputBaseFilename=gforth$SF-$VERSION
AppPublisher=Free Software Foundation, Gforth team
AppPublisherURL=http://bernd-paysan.de/gforth.html
SignTool=signtool sign /fd SHA256 /tr http://timestamp.comodoca.com/authenticode /td SHA256 \$f
SetupIconFile=gforth.ico
UninstallDisplayIcon={app}\\gforth.ico

[Messages]
WizardInfoBefore=License Agreement
InfoBeforeLabel=Gforth is free software.
InfoBeforeClickLabel=You don't have to accept the GPL to run the program. You only have to accept this license if you want to modify, copy, or distribute this program.

[Components]
Name: "help"; Description: "HTML Documentation"; Types: full
Name: "info"; Description: "GNU info Documentation"; Types: full
Name: "print"; Description: "Postscript Documentation for printout"; Types: full
Name: "objects"; Description: "Compiler generated intermediate stuff"; Types: full

[Dirs]
$(make distfiles -f Makedist | tr ' ' '\n' | grep -v CVS | (while read i; do
  while [ ! -z "$i" ]
  do
    if [ -d $i ]; then echo $i; fi
    if [ "${i%/*}" != "$i" ]; then i="${i%/*}"; else i=""; fi
  done
done) | sort -u | sed \
  -e 's:/:\\:g' \
  -e 's,^\(..*\)$,Name: "{app}\\\1",g')
Name: "{app}\\doc\\gforth"
Name: "{app}\\doc\\vmgen"
Name: "{app}\\lib\\gforth\\$VERSION\\$machine\\libcc-named"
Name: "{app}\\include\\gforth\\$VERSION"
Name: "{app}\\..\\bin"
Name: "{app}\\..\\tmp"; Permissions: users-modify

[Files]
; Parameter quick reference:
;   "Source filename", "Dest. filename", Copy mode, Flags
Source: "README.txt"; DestDir: "{app}"; Flags: isreadme
EOF

if [ "$SF" = 64 ]
then
    mkdir -p bin32
    cp /cygdrive/c/cygwin/bin/{sh.exe,cygwin-console-helper.exe,cygwin1.dll,cyggcc_s-1.dll,cygintl-8.dll,cygiconv-2.dll,cygreadline7.dll,cygncursesw-10.dll} bin32
    cat <<EOF
Source: "bin32\\sh.exe"; DestDir: "{app}\\..\\bin"
Source: "bin32\\cygwin-console-helper.exe"; DestDir: "{app}\\..\\bin"
Source: "bin32\\cygwin1.dll"; DestDir: "{app}\\..\\bin"
Source: "bin32\\cyggcc_s-1.dll"; DestDir: "{app}\\..\\bin"
Source: "bin32\\cygintl-8.dll"; DestDir: "{app}\\..\\bin"
Source: "bin32\\cygiconv-2.dll"; DestDir: "{app}\\..\\bin"
Source: "bin32\\cygreadline7.dll"; DestDir: "{app}\\..\\bin"
Source: "bin32\\cygncursesw-10.dll"; DestDir: "{app}\\..\\bin"
Source: "c:\\$CYGWIN\\bin\\cyggcc_s-seh-1.dll"; DestDir: "{app}"
Source: "c:\\$CYGWIN\\bin\\cygwin1.dll"; DestDir: "{app}"
Source: "c:\\$CYGWIN\\bin\\cygintl-8.dll"; DestDir: "{app}"
Source: "c:\\$CYGWIN\\bin\\cygiconv-2.dll"; DestDir: "{app}"
Source: "c:\\$CYGWIN\\bin\\cygltdl-7.dll"; DestDir: "{app}"
Source: "c:\\$CYGWIN\\bin\\cygreadline7.dll"; DestDir: "{app}"
Source: "c:\\$CYGWIN\\bin\\cygncursesw-10.dll"; DestDir: "{app}"
Source: "c:\\$CYGWIN\\bin\\cygffi-6.dll"; DestDir: "{app}"
EOF
else
    cat <<EOF
Source: "c:\\$CYGWIN\\bin\\sh.exe"; DestDir: "{app}\\..\\bin"
Source: "c:\\$CYGWIN\\bin\\cygwin-console-helper.exe"; DestDir: "{app}\\..\\bin"
Source: "c:\\$CYGWIN\\bin\\cygwin1.dll"; DestDir: "{app}\\..\\bin"
Source: "c:\\$CYGWIN\\bin\\cyggcc_s-1.dll"; DestDir: "{app}\\..\\bin"
Source: "c:\\$CYGWIN\\bin\\cygintl-8.dll"; DestDir: "{app}\\..\\bin"
Source: "c:\\$CYGWIN\\bin\\cygiconv-2.dll"; DestDir: "{app}\\..\\bin"
Source: "c:\\$CYGWIN\\bin\\cygreadline7.dll"; DestDir: "{app}\\..\\bin"
Source: "c:\\$CYGWIN\\bin\\cygncursesw-10.dll"; DestDir: "{app}\\..\\bin"
Source: "c:\\$CYGWIN\\bin\\cyggcc_s-1.dll"; DestDir: "{app}"
Source: "c:\\$CYGWIN\\bin\\cygwin1.dll"; DestDir: "{app}"
Source: "c:\\$CYGWIN\\bin\\cygintl-8.dll"; DestDir: "{app}"
Source: "c:\\$CYGWIN\\bin\\cygiconv-2.dll"; DestDir: "{app}"
Source: "c:\\$CYGWIN\\bin\\cygltdl-7.dll"; DestDir: "{app}"
Source: "c:\\$CYGWIN\\bin\\cygreadline7.dll"; DestDir: "{app}"
Source: "c:\\$CYGWIN\\bin\\cygncursesw-10.dll"; DestDir: "{app}"
Source: "c:\\$CYGWIN\\bin\\cygffi-6.dll"; DestDir: "{app}"
EOF
fi

cat <<EOF
Source: "c:\\$CYGWIN\\bin\\mintty.exe"; DestDir: "{app}"
Source: "c:\\$CYGWIN\\bin\\run.exe"; DestDir: "{app}"
Source: "c:\\$CYGWIN\\bin\\env.exe"; DestDir: "{app}"
Source: "gforthmi.sh"; DestDir: "{app}"
$(ls doc/gforth | sed -e 's:/:\\:g' -e 's,^\(..*\)$,Source: "doc\\gforth\\\1"; DestDir: "{app}\\doc\\gforth"; Components: help,g')
$(ls doc/vmgen | sed -e 's:/:\\:g' -e 's,^\(..*\)$,Source: "doc\\vmgen\\\1"; DestDir: "{app}\\doc\\vmgen"; Components: help,g')
$(ls lib/gforth/$VERSION/$machine/libcc-named | sed -e 's:/:\\:g' -e 's,^\(..*\)$,Source: "lib\\gforth\\'$VERSION'\\'$machine'\\libcc-named\\\1"; DestDir: "{app}\\lib\\gforth\\'$VERSION'\\'$machine'\\libcc-named",g')
$(ls lib/gforth/$VERSION/$machine/libcc-named/.libs | sed -e 's:/:\\:g' -e 's,^\(..*\)$,Source: "lib\\gforth\\'$VERSION'\\'$machine'\\libcc-named\\.libs\\\1"; DestDir: "{app}\\lib\\gforth\\'$VERSION'\\'$machine'\\libcc-named\\.libs",g')
$(ls include/gforth/$VERSION/$machine | sed -e 's:/:\\:g' -e 's,^\(..*\)$,Source: "engine\\\1"; DestDir: "{app}\\include\\gforth\\'$VERSION'\\'$machine'",g')
$(make distfiles -f Makedist EXE=.exe | tr ' ' '\n' | grep -v engine.*exe | (while read i; do
  if [ ! -d $i ]; then echo $i; fi
done) | sed \
  -e 's:/:\\:g' \
  -e 's,^\(..*\)\\\([^\\]*\)$,Source: "\1\\\2"; DestDir: "{app}\\\1",g' \
  -e 's,^\([^\\]*\)$,Source: "\1"; DestDir: "{app}",g' \
  -e 's,^\(.*\.[oib]".*\),\1; Components: objects,g' \
  -e 's,^\(.*\.p\)s\(".*\),\1df\2; Components: print,g' \
  -e 's,^\(.*\.info.*".*\),\1; Components: info,g')

[Icons]
; Parameter quick reference:
;   "Icon title", "File name", "Parameters", "Working dir (can leave blank)",
;   "Custom icon filename (leave blank to use the default icon)", Icon index
Name: "{group}\Gforth"; Filename: "{app}\\run.exe"; Parameters: "./env HOME=%HOMEDRIVE%%HOMEPATH% ./mintty ./gforth"; WorkingDir: "{app}"; IconFilename: "{app}\\gforth.ico"
Name: "{group}\Gforth-fast"; Filename: "{app}\\run.exe"; Parameters: "./env HOME='%HOMEDRIVE%%HOMEPATH%' ./mintty ./gforth-fast"; WorkingDir: "{app}"; IconFilename: "{app}\\gforth.ico"
Name: "{group}\Gforth-ditc"; Filename: "{app}\\run.exe"; Parameters: "./env HOME='%HOMEDRIVE%%HOMEPATH%' ./mintty ./gforth-ditc"; WorkingDir: "{app}"; IconFilename: "{app}\\gforth.ico"
Name: "{group}\Gforth-itc"; Filename: "{app}\\run.exe"; Parameters: "./env HOME='%HOMEDRIVE%%HOMEPATH%' ./mintty ./gforth-itc"; WorkingDir: "{app}"; IconFilename: "{app}\\gforth.ico"
Name: "{group}\Gforth Manual"; Filename: "{app}\doc\gforth\index.html"; WorkingDir: "{app}"; Components: help
Name: "{group}\Gforth Manual (PDF)"; Filename: "{app}\doc\gforth.pdf"; WorkingDir: "{app}"; Components: help
Name: "{group}\VMgen Manual"; Filename: "{app}\doc\vmgen\index.html"; WorkingDir: "{app}"; Components: help
Name: "{group}\Bash"; Filename: "{app}\\run.exe"; Parameters: "./env HOME='%HOMEDRIVE%%HOMEPATH%' ./mintty /bin/sh"; WorkingDir: "{app}"; Flags: runminimized
Name: "{group}\Uninstall Gforth$SF"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\\..\\bin\\sh.exe"; WorkingDir: "{app}"; Parameters: "-c ""./wininst.sh '{app}' || (printf '\e[0;31;49mAn error occured, pess return to quit'; read)"""

[UninstallDelete]
Type: files; Name: "{app}\gforth.fi"
Type: files; Name: "{app}\temp-image.fi1"
Type: files; Name: "{app}\temp-image.fi2"

;[Registry]
;registry commented out
; WorkingDir: "{app}"; Parameter quick reference:
;   "Root key", "Subkey", "Value name", Data type, "Data", Flags
;HKCR, ".fs"; STRING, "forthstream",
;HKCR, ".fs", "Content Type", STRING, "application/forth",
;HKCR, ".fb"; STRING, "forthblock",
;HKCR, ".fb", "Content Type", STRING, "application/forth-block",
;HKCR, "forthstream"; STRING, "Forth Source",
;HKCR, "forthstream", "EditFlags", DWORD, "00000000",
;HKCR, "forthstream\DefaultIcon"; STRING, "{sys}\System32\shell32.dll,61"
;HKCR, "forthstream\Shell"; STRING, ""
;HKCR, "forthstream\Shell\Open\command"; STRING, "{app}\gforth.exe %1"
;HKCR, "forthblock"; STRING, "Forth Block",
;HKCR, "forthblock", "EditFlags", DWORD, "00000000",
;HKCR, "forthblock\DefaultIcon"; STRING, "{sys}\System32\shell32.dll,61"

[Tasks]
Name: modifypath; Description: Add application directory to your environmental path; Flags: unchecked

[Code]
// Utility functions for Inno Setup
//   used to add/remove programs from the windows firewall rules
// Code originally from http://news.jrsoftware.org/news/innosetup/msg43799.html

const
    ModPathName = 'modifypath';
    ModPathType = 'user';
    NET_FW_SCOPE_ALL = 0;
    NET_FW_IP_VERSION_ANY = 2;

function ModPathDir(): TArrayOfString;
begin
    setArrayLength(Result, 1)
    Result[0] := ExpandConstant('{app}');
end;
#include "modpath.iss"
#include "firewall.iss"

// event called at install
procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep=ssPostInstall then begin
     SetFirewallException('Gforth', ExpandConstant('{app}')+'\gforth.exe');
     SetFirewallException('Gforth', ExpandConstant('{app}')+'\gforth-fast.exe');
     SetFirewallException('Gforth', ExpandConstant('{app}')+'\gforth-itc.exe');
     SetFirewallException('Gforth', ExpandConstant('{app}')+'\gforth-ditc.exe');
     CurStepChangedPath();
  end;
end;

// event called at uninstall
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usUninstall then begin
     CurUninstallStepChangedPath();
  end;
  if CurUninstallStep=usPostUninstall then begin
     RemoveFirewallException(ExpandConstant('{app}')+'\gforth.exe');
     RemoveFirewallException(ExpandConstant('{app}')+'\gforth-fast.exe');
     RemoveFirewallException(ExpandConstant('{app}')+'\gforth-itc.exe');
     RemoveFirewallException(ExpandConstant('{app}')+'\gforth-ditc.exe');
  end;
end;

EOF

sed -e 's/$/\r/' <README >README.txt
