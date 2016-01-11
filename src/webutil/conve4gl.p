/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
**********************************************************************

  File: conve4gl.p

  Description: Convert Embedded SpeedScript files to Progress .w procedures

  Input Parameters:       <none>

  Output Parameters:      <none>

  Author:  D.M.Adams
  Updated: 03/01/97 Initial version
           10/06/00 Updated for POSSE
           11/01/00 Updated to create .w's in $POSSE/e4gl for POSSE. (jep)
           11/10/00 Split out samples directory
----------------------------------------------------------------------------*/

{src/web/method/cgidefs.i NEW}

DEFINE VARIABLE adeDir    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE diritem   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dirlist   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE e4glfile  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE fileext   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE htmlfile  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ix        AS INTEGER    NO-UNDO.
DEFINE VARIABLE iy        AS INTEGER    NO-UNDO.
DEFINE VARIABLE nextdir   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE newdir    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE options   AS CHARACTER  NO-UNDO.            
DEFINE VARIABLE posseDir  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE sampleDir AS CHARACTER  NO-UNDO.
DEFINE VARIABLE srcDir    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE subdir    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE targdir   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE webfile   AS CHARACTER  NO-UNDO.

/* Define list of directories to process */
ASSIGN
  adeDir    = OS-GETENV("RDLADE":U)
  posseDir  = OS-GETENV("POSSE":U).

/* Embedded 4GL file processing takes place in $POSSE/e4gl for POSSE and
   $DLC/e4gl for PSC builds. This ensures e4gl processing does not alter
   commerically installed product directories. (jep) */
IF (posseDir <> ?) THEN
  ASSIGN
    dirlist   = "webedit,webtools,webutil,workshop":U
    srcDir    = posseDir + "/src":U
    targdir   = posseDir + "/e4gl":U.
ELSE
  ASSIGN
    dirlist   = "webedit,webtools,webutil,workshop,samples/web,samples/web/intranet,samples/web/internet,samples/web/extranet":U
    sampleDir = OS-GETENV("RDLSRC":U) + "/pscade":U
    srcDir    = adeDir
    targdir   = OS-GETENV("DLC":U) + "/e4gl":U.
    
OS-CREATE-DIR VALUE(targdir).

DO ix = 1 TO NUM-ENTRIES(dirlist):
  ASSIGN
    diritem = ENTRY(ix,dirlist)
    nextdir = (IF posseDir = ? AND dirItem BEGINS "samples":U
               THEN sampleDir ELSE srcDir) + "/":U + diritem.
  
  INPUT FROM OS-DIR(nextdir).
  REPEAT:
    IMPORT e4glfile.
    fileext = TRIM(ENTRY(NUM-ENTRIES (e4glfile, ".":U), e4glfile, ".":U)).
    
    IF fileext BEGINS "html":U THEN DO:
      /* Create the target subdirectory tree. */
      newdir = "".
      DO iy = 1 TO NUM-ENTRIES(diritem,"/":U):
        ASSIGN
          newdir = newdir + (IF newdir ne "" THEN "/":U ELSE "")
                   + ENTRY(iy,diritem,"/":U)
          subdir = targdir + "/":U + newdir.
        OS-CREATE-DIR VALUE(subdir).
      END.
      
      ASSIGN
        htmlfile = nextdir + "/":U + e4glfile
        options  = ""
        webfile  = targdir + "/":U + diritem + "/":U +
                   SUBSTRING(e4glfile,1,INDEX(e4glfile,".html":U) - 1) + ".w":U.
        
      RUN VALUE(srcDir + "/webutil/e4gl-gen.p":U)
        (htmlfile, INPUT-OUTPUT options, INPUT-OUTPUT webfile) NO-ERROR.
    END.
  END.
END.

/* conve4gl.p - end of file */