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

/*----------------------------------------------------------------------------

File: _isdata.i

Description: 
   Check to see if there is any data in this table.  This will be compiled
   at run time when we know what the table name is.
 
Argument:
   &1  - The table to check.

Output Parameter:
   p_IsData - Flag - set to yes if there is data, no otherwise.

Author: Laura Stern

Date Created: 11/16/92 

----------------------------------------------------------------------------*/

Define OUTPUT parameter p_IsData as logical NO-UNDO.


p_IsData = CAN-FIND(FIRST {1}).