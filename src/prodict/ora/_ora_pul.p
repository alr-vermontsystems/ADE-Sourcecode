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

/*--------------------------------------------------------------------

File: prodict/ora/_ora_pul.p   THIS ROUTINE GETS CALLED ONCE PER LINK!

Description:
    pulls schemainfo of all objects contained in gate-work into
    the temp-tables

    <DS>_get.p gets a list of all pullable objects from the foreign DB
    <DS>_pul.p pulled over the definition from the foreign side
    gat_cmp.p  compared the existing definitions with the pulled info
    gat_cro.p  replaces the existing definitions with the pulled info
               or creates the new object if it didn't already exist

    Create <DS> Schema: <DS>_get.p <DS>_pul.p gat_cro.p
    Update <DS> Schema: <DS>_get.p <DS>_pul.p gat_cro.p
    Verify <DS> Schema: <DS>_get.p <DS>_pul.p gat_cmp.p gat_cro.p

Input:
    &DS_DEBUG   DEBUG to protocol the creation
                ""    to turn off protocol
    gate-work   shared temp-table that contains all the objects to pull

Output:
    s_ttb_tbl   table-information of all objects
    s_ttb_fld   field-information of all objects
    s_ttb_idx   index-information of all objects
    s_ttb_idf   index-field-information of all objects
    s_ttb_seq   sequence-information of all objects

History:
    hutegger    95/04   created out of ora_lkm.i
    mcmann     03/20/01 Added support for decending indexes
    mcmann     05/11/01 Change unique condition to be = 1

--------------------------------------------------------------------*/
/*h-*/

define buffer ds_users          for DICTDBG.oracle_users.
define buffer ds_objects        for DICTDBG.oracle_objects.
define buffer ds_objects-2      for DICTDBG.oracle_objects.
define buffer ds_comments       for DICTDBG.oracle_comment.
define buffer ds_columns        for DICTDBG.oracle_columns.
define buffer ds_columns-2      for DICTDBG.oracle_columns.
define buffer ds_indexes        for DICTDBG.oracle_indexes.
define buffer ds_idx-cols       for DICTDBG.oracle_idxcols.
define buffer ds_sequences      for DICTDBG.oracle_sequences.

DEFINE VARIABLE h1 AS INTEGER NO-UNDO.
/*------------------------------------------------------------------*/

/* SYSDATE will be handled by ORACLE so PROGRESS gets ? */

{prodict/gate/gat_pul.i
  &buffer        = " "" "" "
  &col-fields    = "scale precision_ length_ null$ default$"
  &colid         = "col#"
  &colid-t-cmnt  = "?"
  &comment       = "comment$"
  &db-type       = "oracle"
  &dbtyp         = "ora"
  &ds_recid      = "ds_columns.col#"
  &for-idx-name  = "ds_objects-2.name"
  &for-idx-nam2  = "ds_objects-2.name"
  &for-obj-name  = "ds_objects-2.name"
  &idx-fields    = "bo# obj# unique$ "
  &idx-tbl-break = "break by ds_objects-2.name"
  &idx-uniq-cond = "(ds_indexes.unique$ = 1)"
  &idx-where     = " "
  &idxid         = "bo#"
  &init          = "( IF  ds_columns.default$ = """"SYSDATE""""
                       OR ds_columns.default$ = """"NULL""""
                       THEN ?
                       ELSE ds_columns.default$
                    )"
  &length        = "ds_columns.length_"
  &mand          = "(ds_columns.null$ <> 0)"
  &msc23         = "s_ttb_fld.ds_msc23"
  &name          = "ds_columns.name"
  &objid         = "obj#"
  &precision     = "ds_columns.precision_"
  &radix         = "(IF l_dt = """"FLOAT"""" then 0.30103 else 1)"
  &scale         = "ds_columns.scale"
  &type          = "type#"
  &typvar        = "LOOKUP(typevar-s ,oobjects) - 1"
  &typvar-b      = "LOOKUP(""VIEW""  ,oobjects) - 1"
  &usrid         = "user#"
  &usrid-t       = "owner#"
  }

/*------------------------------------------------------------------*/