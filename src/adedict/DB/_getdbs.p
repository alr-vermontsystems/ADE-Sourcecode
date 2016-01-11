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

/*-----------------------------------------------------------------------

File: _getdbs.p

Description:   
   This procedure gets the list of databases as follows:

   This includes:
      all connected databases and foreign databases whose schema holders
      are connected.

Shared Output:
   s_CurrDb    	  - will have been set.

Author: Laura Stern

Date Created: 01/28/92 

History:    
     laurief       12/18/97    Made V8 to "generic version" changes
     mcmann        10/29/98    Change message to read V9 Dictionary

-----------------------------------------------------------------------*/

{ adedict/dictvar.i shared }
{ adedict/brwvar.i  shared }

{ adecomm/getdbs.i
  &new = "NEW"
  }

Define var l_i     as int     NO-UNDO.
Define var l_strng as char    NO-UNDO.

/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/

/* initialize cache */
assign
  s_DbCache_Cnt        = 0
  s_lst_dbs:list-items = "".

/* get list of dbs */
if NUM-DBS <> 0 
 then do:
  RUN adecomm/_dictdb.p.
  RUN adecomm/_getdbs.p.
  end.
  
/* create cache and selection-list */
for each s_ttb_db:
  
  /* get rid of older versions, because we can't handle them and
   * Keep track of these old connected databases so we don't keep
   * repeating this message to the user every time they connect
   * to a new database.
   */
  if s_ttb_db.vrsn < "9"
   then do:
    if NOT CAN-DO (s_OldDbs, s_ttb_db.ldbnm)
     then do:
      assign
        s_OldDbs = s_OldDbs
                 + (if s_OldDbs = "" then "" else ",")
                 + s_ttb_db.ldbnm.
        l_strng  = "V" + s_ttb_db.vrsn.
      message 
        "Database" s_ttb_db.ldbnm "is a" l_strng "database." SKIP
        "This V9 dictionary cannot be used with a" SKIP
        "PROGRESS" l_strng "database.  Use the dictionary" SKIP
        "under PROGRESS" l_strng "to access this database." SKIP(1)
        "(Note: Database" s_ttb_db.ldbnm "is still connected.)"
         view-as ALERT-BOX INFORMATION buttons OK.
      end.
    next.
    end.

  /* Skip auto-connect records
   */
  if   s_ttb_db.local = FALSE
   and s_ttb_db.dbtyp = "PROGRESS"
   then next.
   
  /* check for number of dbs to be maller than extent */
  if EXTENT(s_DbCache_Pname) <= s_DbCache_Cnt
   then next.

  assign
    /* Add the name to the select list in the browse window. */
    s_Res = ( if s_ttb_db.local = TRUE
                then s_lst_Dbs:add-last(s_ttb_db.ldbnm) in frame browse
                else s_lst_Dbs:add-last( " " + s_ttb_db.ldbnm
                                       + "(" + s_ttb_db.sdbnm + ")"
                                       ) in frame browse
            )
    /* generate internal db-type */
    l_strng = { adecomm/ds_type.i
                 &direction = "etoi"
                 &from-type = "s_ttb_db.dbtyp"
              }

    /* Add database to the cache. */
    { adedict/DB/cachedb.i
       &Lname  = s_ttb_db.ldbnm
       &Pname  = s_ttb_db.pdbnm
       &Holder = s_ttb_db.sdbnm
       &Type   = l_strng
       }

  end.  /* for each s_ttb_db */

