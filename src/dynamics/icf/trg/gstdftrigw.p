/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/

TRIGGER PROCEDURE FOR WRITE OF gst_dataset_file OLD BUFFER o_gst_dataset_file.

/* Created automatically using ERwin ICF Trigger template db/af/erw/afercustrg.i
   Do not change manually. Customisations to triggers should be placed in separate
   include files pulled into the trigger. ICF auto generates write trigger custom
   include files. Delete or create customisation include files need to be created
   manually. Be sure to put the hook in ERwin directly so as not to have you changes
   overwritten.
   User defined Macro (UDP) Summary (case sensitive)
   gst_dataset_file           Expands to full table name, e.g. gsm_user
   %TableFLA            Expands to table unique code, e.g. gsmus
   %TableObj            If blank or not defined expands to table_obj with no prefix (framework standard)
                        If defined, uses this field as the object field
                        If set to "none" then indicates table does not have an object field
   XYZ                  Do not define so we can compare against an empty string

   See docs for explanation of replication macros 
*/   

&SCOPED-DEFINE TRIGGER_TABLE gst_dataset_file
&SCOPED-DEFINE TRIGGER_FLA gstdf
&SCOPED-DEFINE TRIGGER_OBJ dataset_file_obj


DEFINE BUFFER lb_table FOR gst_dataset_file.      /* Used for recursive relationships */
DEFINE BUFFER lb1_table FOR gst_dataset_file.     /* Used for lock upgrades */



/* Standard top of WRITE trigger code */
{af/sup/aftrigtopw.i}

/* properform fields if enabled for table */
IF CAN-FIND(FIRST gsc_entity_mnemonic
            WHERE gsc_entity_mnemonic.entity_mnemonic = 'gstdf':U
              AND gsc_entity_mnemonic.auto_properform_strings = YES) THEN
  RUN af/app/afpropfrmp.p (INPUT BUFFER gst_dataset_file:HANDLE).
  



/* Generated by ICF ERwin Template */
/* gst_deployment consists of gst_dataset_file ON CHILD UPDATE SET NULL */
IF NEW gst_dataset_file OR  gst_dataset_file.deployment_obj <> o_gst_dataset_file.deployment_obj  THEN
  DO:
    IF NOT(CAN-FIND(FIRST gst_deployment WHERE
        gst_dataset_file.deployment_obj = gst_deployment.deployment_obj)) THEN DO:
        
        ASSIGN gst_dataset_file.deployment_obj = 0 .
    END.
    
    
  END.

/* Generated by ICF ERwin Template */
/* gsc_deploy_dataset generated gst_dataset_file ON CHILD UPDATE RESTRICT */
IF NEW gst_dataset_file OR  gst_dataset_file.deploy_dataset_obj <> o_gst_dataset_file.deploy_dataset_obj  THEN
  DO:
    IF NOT(CAN-FIND(FIRST gsc_deploy_dataset WHERE
        gst_dataset_file.deploy_dataset_obj = gsc_deploy_dataset.deploy_dataset_obj)) THEN
              DO:
                /* Cannot update child because parent does not exist ! */
                ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 103 lv-include = "gst_dataset_file|gsc_deploy_dataset":U.
                RUN error-message (lv-errgrp, lv-errnum, lv-include).
              END.
    
    
  END.








IF NOT NEW gst_dataset_file AND gst_dataset_file.{&TRIGGER_OBJ} <> o_gst_dataset_file.{&TRIGGER_OBJ} THEN
    DO:
        ASSIGN lv-error = YES lv-errgrp = "AF":U lv-errnum = 13 lv-include = "table object number":U.
        RUN error-message (lv-errgrp,lv-errnum,lv-include).
    END.

/* Customisations to WRITE trigger */
{icf/trg/gstdftrigw.i}



/* Update Audit Log */
IF CAN-FIND(FIRST gsc_entity_mnemonic
            WHERE gsc_entity_mnemonic.entity_mnemonic = 'gstdf':U
              AND gsc_entity_mnemonic.auditing_enabled = YES) THEN
  RUN af/app/afauditlgp.p (INPUT "WRITE":U, INPUT "gstdf":U, INPUT BUFFER gst_dataset_file:HANDLE, INPUT BUFFER o_gst_dataset_file:HANDLE).

/* Standard bottom of WRITE trigger code */
{af/sup/aftrigendw.i}



