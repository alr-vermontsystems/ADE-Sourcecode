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
*********************************************************************/
/* connect.p */
{adm2/globals.i}

DEFINE INPUT PARAMETER user-id          AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER password         AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER app-server-info  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hDynUser    AS HANDLE     NO-UNDO.
DEFINE VARIABLE cPassword   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSessType   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNumFormat  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDateFormat AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOldSession AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRetVal     AS CHARACTER  NO-UNDO.

/* Make sure that afdynuser.p is running */
RUN startProcedure IN THIS-PROCEDURE ("ONCE|af/app/afdynuser.p":U, OUTPUT hDynUser) NO-ERROR.
IF ERROR-STATUS:ERROR OR 
   RETURN-VALUE <> "":U THEN
DO:
  MESSAGE "UNABLE TO START USER VALIDATION ALGORITHM":U.
  RETURN ERROR "UNABLE TO START USER VALIDATION ALGORITHM":U.
END.


/* First see if we can authenticate the user using the password mangle
   mechanism. */

/* Now obtain a password from the userid */
cPassword = DYNAMIC-FUNCTION("createPassword":U IN hDynUser, user-id).

/* If the password we obtained doesn't match the password that came in as a parameter,
   we should fail this connection */
IF cPassword = ? OR
   cPassword <> password THEN
DO:
  /* If this failed, lets try authenticating this user using the session manager */
  RUN authenticateUser IN gshSecurityManager
    (INPUT user-id,
     INPUT password,
     OUTPUT cRetVal) NO-ERROR.
  IF ERROR-STATUS:ERROR OR 
     RETURN-VALUE <> "":U OR 
     cRetVal <> "":U THEN
  DO:
    MESSAGE "INVALID USER NAME (":U + user-id + ") OR PASSWORD TO CONNECT TO APPSEVER":U.
    RETURN ERROR "INVALID USER NAME OR PASSWORD TO CONNECT TO APPSEVER":U.
  END.
END.

/* Parse the AppServer information string so we have data for the parameters for the
   activateSession call */
RUN storeAppServerInfo IN gshSessionManager
  (INPUT app-server-info).

/* If we got this far we should go and try and create the session */
RUN establishSession IN gshSessionManager
  (INPUT NO,           /* Are we activating an already existing session */
   INPUT YES)          /* Should we check inactivity timeouts */
  NO-ERROR.
IF ERROR-STATUS:ERROR OR
   (RETURN-VALUE <> "":U AND
    RETURN-VALUE <> ?) THEN
DO:
  MESSAGE "UNABLE TO CREATE SESSION. ":U + RETURN-VALUE.
  RETURN ERROR RETURN-VALUE.
END.