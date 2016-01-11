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
/* s-where.i - update qbf-o (WHERE clause) from qbf-p array (WHERE parts) */

qbf-o = "".
DO qbf-i = 1 TO qbf-p# {*}:
  qbf-o = qbf-o + qbf-p[qbf-i].
END.
DISPLAY qbf-o SUBSTRING(qbf-o,79,-1,"CHARACTER":u) @ qbf-f 
  WITH FRAME qbf-select.

/* s-where.i - end of file */
