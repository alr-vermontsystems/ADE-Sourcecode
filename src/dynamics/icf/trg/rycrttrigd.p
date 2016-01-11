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
* Contributors: MIP Holdings (Pty) Ltd ("MIP")                       *
*               PSC                                                  *
*                                                                    *
*********************************************************************/

TRIGGER PROCEDURE FOR DELETE OF ryc_render_type .

/* Created automatically using ERwin ICF Trigger template db/af/erw/afercustrg.i
   Do not change manually. Customisations to triggers should be placed in separate
   include files pulled into the trigger. ICF auto generates write trigger custom
   include files. Delete or create customisation include files need to be created
   manually. Be sure to put the hook in ERwin directly so as not to have you changes
   overwritten.
   User defined Macro (UDP) Summary (case sensitive)
   ryc_render_type           Expands to full table name, e.g. gsm_user
   %TableFLA            Expands to table unique code, e.g. gsmus
   %TableObj            If blank or not defined expands to table_obj with no prefix (framework standard)
                        If defined, uses this field as the object field
                        If set to "none" then indicates table does not have an object field
   XYZ                  Do not define so we can compare against an empty string

   See docs for explanation of replication macros 
*/   

&SCOPED-DEFINE TRIGGER_TABLE ryc_render_type
&SCOPED-DEFINE TRIGGER_FLA rycrt
&SCOPED-DEFINE TRIGGER_OBJ render_type_obj


DEFINE BUFFER lb_table FOR ryc_render_type.      /* Used for recursive relationships */
DEFINE BUFFER lb1_table FOR ryc_render_type.     /* Used for lock upgrades */

DEFINE BUFFER o_ryc_render_type FOR ryc_render_type.

/* Standard top of DELETE trigger code */
{af/sup/aftrigtopd.i}

  




/* Generated by ICF ERwin Template */
/* ryc_render_type has ryc_ui_event ON PARENT DELETE RESTRICT */
IF CAN-FIND(FIRST ryc_ui_event WHERE
    ryc_ui_event.render_type_obj = ryc_render_type.render_type_obj) THEN
    DO:
      /* Cannot delete parent because child exists! */
      ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 101 lv-include = "ryc_render_type|ryc_ui_event":U.
      RUN error-message (lv-errgrp, lv-errnum, lv-include).
    END.



/* Generated by ICF ERwin Template */
/* ryc_render_type has ryc_attribute_value ON PARENT DELETE RESTRICT */
IF CAN-FIND(FIRST ryc_attribute_value WHERE
    ryc_attribute_value.render_type_obj = ryc_render_type.render_type_obj) THEN
    DO:
      /* Cannot delete parent because child exists! */
      ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 101 lv-include = "ryc_render_type|ryc_attribute_value":U.
      RUN error-message (lv-errgrp, lv-errnum, lv-include).
    END.



/* Generated by ICF ERwin Template */
/* ryc_render_type is used in gst_session ON PARENT DELETE SET NULL */

&IF DEFINED(lbe_session) = 0 &THEN
  DEFINE BUFFER lbe_session FOR gst_session.
  &GLOBAL-DEFINE lbe_session yes
&ENDIF
FOR EACH gst_session NO-LOCK
   WHERE gst_session.render_type_obj = ryc_render_type.render_type_obj
   ON STOP UNDO, RETURN ERROR "AF^104^rycrttrigd.p^update gst_session":U:
    FIND FIRST lbe_session EXCLUSIVE-LOCK
         WHERE ROWID(lbe_session) = ROWID(gst_session)
         NO-ERROR.
    IF AVAILABLE lbe_session THEN
      DO:
        
        ASSIGN lbe_session.render_type_obj = 0 .
      END.
END.





/* Generic comments deletion */
DEFINE BUFFER lbx_gsm_comment FOR gsm_comment.
DEFINE BUFFER lby_gsm_comment FOR gsm_comment.
IF CAN-FIND(FIRST lbx_gsm_comment 
            WHERE lbx_gsm_comment.owning_obj = ryc_render_type.{&TRIGGER_OBJ}) THEN
    FOR EACH lbx_gsm_comment NO-LOCK
       WHERE lbx_gsm_comment.owning_obj = ryc_render_type.{&TRIGGER_OBJ}
       ON STOP UNDO, RETURN ERROR "AF^104^rycrttrigd.p^delete gsm_comment":U:
        FIND FIRST lby_gsm_comment EXCLUSIVE-LOCK
             WHERE ROWID(lby_gsm_comment) = ROWID(lbx_gsm_comment)
             NO-ERROR.
        IF AVAILABLE lby_gsm_comment THEN
          DO:
            {af/sup/afvalidtrg.i &action = "DELETE" &table = "lby_gsm_comment"}
          END.
    END.
/* Generic security allocation deletion */
DEFINE BUFFER lbx_gsm_user_allocation FOR gsm_user_allocation.
DEFINE BUFFER lby_gsm_user_allocation FOR gsm_user_allocation.
IF CAN-FIND(FIRST lbx_gsm_user_allocation 
            WHERE lbx_gsm_user_allocation.owning_obj = ryc_render_type.{&TRIGGER_OBJ}) THEN
    FOR EACH lbx_gsm_user_allocation NO-LOCK
       WHERE lbx_gsm_user_allocation.owning_obj = ryc_render_type.{&TRIGGER_OBJ}
       ON STOP UNDO, RETURN ERROR "AF^104^rycrttrigd.p^delete gsm_user_allocation":U:
        FIND FIRST lby_gsm_user_allocation EXCLUSIVE-LOCK
             WHERE ROWID(lby_gsm_user_allocation) = ROWID(lbx_gsm_user_allocation)
             NO-ERROR.
        IF AVAILABLE lby_gsm_user_allocation THEN
          DO:
            {af/sup/afvalidtrg.i &action = "DELETE" &table = "lby_gsm_user_allocation"}
          END.
    END.
/* Generic multi-media deletion */
DEFINE BUFFER lbx_gsm_multi_media FOR gsm_multi_media.
DEFINE BUFFER lby_gsm_multi_media FOR gsm_multi_media.
IF CAN-FIND(FIRST lbx_gsm_multi_media 
            WHERE lbx_gsm_multi_media.owning_obj = ryc_render_type.{&TRIGGER_OBJ}) THEN
    FOR EACH lbx_gsm_multi_media NO-LOCK
       WHERE lbx_gsm_multi_media.owning_obj = ryc_render_type.{&TRIGGER_OBJ}
       ON STOP UNDO, RETURN ERROR "AF^104^rycrttrigd.p^delete gsm_multi_media":U:
        FIND FIRST lby_gsm_multi_media EXCLUSIVE-LOCK
             WHERE ROWID(lby_gsm_multi_media) = ROWID(lbx_gsm_multi_media)
             NO-ERROR.
        IF AVAILABLE lby_gsm_multi_media THEN
          DO:
            {af/sup/afvalidtrg.i &action = "DELETE" &table = "lby_gsm_multi_media"}
          END.
    END.










/* Update Audit Log */
IF CAN-FIND(FIRST gsc_entity_mnemonic
            WHERE gsc_entity_mnemonic.entity_mnemonic = 'rycrt':U
              AND gsc_entity_mnemonic.auditing_enabled = YES) THEN
  RUN af/app/afauditlgp.p (INPUT "DELETE":U, INPUT "rycrt":U, INPUT BUFFER ryc_render_type:HANDLE, INPUT BUFFER o_ryc_render_type:HANDLE).

/* Standard bottom of DELETE trigger code */
{af/sup/aftrigendd.i}


/* Place any specific DELETE trigger customisations here */