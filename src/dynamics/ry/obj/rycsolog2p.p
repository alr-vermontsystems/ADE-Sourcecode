&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" DataLogicProcedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" DataLogicProcedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" DataLogicProcedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DataLogicProcedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rytemlogic.p

  Description:  ryc_smartobject Data Logic Procedure Library Template

  Purpose:      A procedure library (PLIP) to support the maintenance of the ryc_smartobject table
                The following internal procedures may be added or modified
                to act as validation to creation, modification, or deletion of
                records in the database table

                Client-side:
                rowObjectValidate***

                Server-side upon create:
                createPreTransValidate***
                createBeginTransValidate
                createEndTransValidate
                createPostTransValidate

                Server-side upon write (create and modify):
                writePreTransValidate***
                writeBeginTransValidate
                writeEndTransValidate
                writePostTransValidate

                Server-side upon delete:
                deletePreTransValidate
                deleteBeginTransValidate
                deleteEndTransValidate
                deletePostTransValidate

                *** The rowObjectValidate, createPreTransValidate and writePreTransValidate
                internal procedures are automatically generated by the SDO generator

  Parameters:

  History:
  --------
  (v:010000)    Task:    90000033   UserRef:    POSSE
                Date:   20/04/2001  Author:     Phil Magnay

  Update Notes: Data Logic Procedure Auto-Generation

  (v:010001)    Task:    90000119   UserRef:    posse
                Date:   06/05/2001  Author:     Haavard Danielsen

  Update Notes: Point to src/adm2/logic.i

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rycsolog2p.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.
DEFINE VARIABLE gcSmartObjectObjBI  AS DECIMAL    NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO


/* Data Preprocessor Definitions */
&GLOB DATA-LOGIC-TABLE ryc_smartobject
&GLOB DATA-FIELD-DEFS  "ry/obj/rycsoful2o.i"

/* Error handling definitions */
{af/sup2/afcheckerr.i &define-only = YES}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DataLogicProcedure
&Scoped-define DB-AWARE yes


/* Db-Required definitions. */
&IF DEFINED(DB-REQUIRED) = 0 &THEN
    &GLOBAL-DEFINE DB-REQUIRED TRUE
&ENDIF
&GLOBAL-DEFINE DB-REQUIRED-START   &IF {&DB-REQUIRED} &THEN
&GLOBAL-DEFINE DB-REQUIRED-END     &ENDIF





/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isFieldBlank DataLogicProcedure 
FUNCTION isFieldBlank RETURNS LOGICAL
  ( INPUT pcFieldValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DataLogicProcedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE APPSERVER DB-AWARE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DataLogicProcedure ASSIGN
         HEIGHT             = 13.71
         WIDTH              = 59.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DataLogicProcedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/logic.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DataLogicProcedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createBeginTransValidate DataLogicProcedure  _DB-REQUIRED
PROCEDURE createBeginTransValidate :
/*------------------------------------------------------------------------------
  Purpose:     Checks whether the object being copied belongs to the SmartToolbar
               class. If so, it Copies all child bands.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cToolbarClasses AS CHARACTER  NO-UNDO.
 /* Check whether object is a smartToolbar logical object and a copy is being performed. */
  FIND gsc_object_type NO-LOCK 
       WHERE gsc_object_type.object_type_obj = b_ryc_smartObject.OBJECT_type_obj NO-ERROR.
  IF AVAILABLE gsc_object_type THEN
  DO:
       ASSIGN cToolbarClasses = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "SmartToolbar").
       IF LOOKUP(gsc_object_type.object_type_code,cToolbarClasses) > 0 THEN
          ASSIGN gcSmartObjectObjBI = b_ryc_smartObject.smartObject_obj.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createEndTransValidate DataLogicProcedure  _DB-REQUIRED
PROCEDURE createEndTransValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cMessageList                AS CHARACTER                NO-UNDO.

/* If no security object exists, make this object secure itself. */
IF b_ryc_smartobject.security_smartobject_obj EQ 0 OR b_ryc_smartobject.security_smartobject_obj EQ ? 
THEN DO:
    FIND ryc_smartobject WHERE
         ryc_smartobject.smartobject_obj = b_ryc_smartobject.smartobject_obj
         EXCLUSIVE-LOCK NO-WAIT NO-ERROR.

    IF LOCKED ryc_smartobject THEN
        ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList, CHR(3)) EQ 0 THEN "":U ELSE CHR(3))
                            + {af/sup2/aferrortxt.i 'AF' '104' 'ryc_smartobject' '?' '"update the object record"'}.        
    ELSE
        IF AVAILABLE ryc_smartobject THEN
        DO:
            ASSIGN ryc_smartobject.security_smartobject_obj = ryc_smartobject.smartobject_obj.
            VALIDATE ryc_smartobject NO-ERROR.
            ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList, CHR(3)) EQ 0 THEN "":U ELSE CHR(3))
                                + RETURN-VALUE.
        END.
END.

/* If a smartToolbar was created, copy all child bands */
DEFINE BUFFER b_gsm_toolbar_menu_structure FOR gsm_toolbar_menu_structure.
IF cMessageList = "" AND gcSmartObjectObjBI > 0 THEN
DO:
   FOR EACH gsm_toolbar_menu_structure NO-LOCK
        WHERE gsm_toolbar_menu_structure.OBJECT_obj = gcSmartObjectObjBI :

     CREATE b_gsm_toolbar_menu_structure.
     BUFFER-COPY gsm_toolbar_menu_structure EXCEPT OBJECT_obj toolbar_menu_structure_obj TO b_gsm_toolbar_menu_structure.
     ASSIGN b_gsm_toolbar_menu_structure.OBJECT_obj = b_ryc_smartObject.smartobject_obj.  
   END.
   ASSIGN gcSmartObjectObjBI = 0.
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createPreTransValidate DataLogicProcedure  _DB-REQUIRED
PROCEDURE createPreTransValidate :
/*------------------------------------------------------------------------------
  Purpose:     Procedure used to validate records server-side before the transaction scope upon create
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cMessageList    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cValueList      AS CHARACTER    NO-UNDO.

  IF CAN-FIND(FIRST ryc_smartobject 
              WHERE ryc_smartobject.object_filename = b_ryc_smartobject.object_filename
                AND ryc_smartobject.customization_result_obj = b_ryc_smartobject.customization_result_obj) THEN
  DO:
     ASSIGN
        cValueList   = STRING(b_ryc_smartobject.object_filename) + ', ' + STRING(b_ryc_smartobject.customization_result_obj)
        cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                      {aferrortxt.i 'AF' '8' 'ryc_smartobject' '' "'object_filename, customization_result_obj, '" cValueList }.
  END.


  IF CAN-FIND(FIRST ryc_smartobject 
              WHERE ryc_smartobject.product_module_obj = b_ryc_smartobject.product_module_obj
                AND ryc_smartobject.object_filename = b_ryc_smartobject.object_filename
                AND ryc_smartobject.customization_result_obj = b_ryc_smartobject.customization_result_obj) THEN
  DO:
     ASSIGN
        cValueList   = STRING(b_ryc_smartobject.product_module_obj) + ', ' + STRING(b_ryc_smartobject.object_filename) + ', ' + STRING(b_ryc_smartobject.customization_result_obj)
        cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                      {aferrortxt.i 'AF' '8' 'ryc_smartobject' '' "'product_module_obj, object_filename, customization_result_obj, '" cValueList }.
  END.


  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deletePreTransValidate DataLogicProcedure  _DB-REQUIRED
PROCEDURE deletePreTransValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cMessageList AS CHARACTER NO-UNDO.

ASSIGN cMessageList = "":U.

/* Check that we do not delete an object where the object is used as an *
 * instance on another object                                           */

IF CAN-FIND(FIRST ryc_object_instance
            WHERE ryc_object_instance.smartobject_obj = b_ryc_smartobject.smartobject_obj) THEN
    ASSIGN 
           cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                          {af/sup2/aferrortxt.i 'AF' '101' 'ryc_smartobject' '' "'object'" "'object instance'" "'This object is used as an instance on another object and may not be deleted.'"}.


IF cMessageList = "":U THEN DO:
  /* Cascade delete all Instances on object, all Links, all attributes,
     all pages and all UI Events. */
  /* DELETE OBJECT INSTANCES */
  SESSION:SET-WAIT-STATE("GENERAL":U).
  FOR EACH  ryc_object_instance
      WHERE ryc_object_instance.container_smartobject_obj = b_ryc_smartobject.smartobject_obj
      EXCLUSIVE-LOCK:
    /* DELETE OBJECT INSTANCE ATTRIBUTE VALUES */
    FOR EACH  ryc_attribute_value
        WHERE ryc_attribute_value.object_type_obj          <> 0
        AND   ryc_attribute_value.container_smartobject_obj = b_ryc_smartobject.smartobject_obj
        AND   ryc_attribute_value.smartobject_obj           = ryc_object_instance.smartobject_obj
        AND   ryc_attribute_value.object_instance_obj       = ryc_object_instance.object_instance_obj
        EXCLUSIVE-LOCK:
      DELETE ryc_attribute_value.
      IF RETURN-VALUE <> "":U THEN DO:
        cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + RETURN-VALUE.
        ERROR-STATUS:ERROR = NO.
        RETURN cMessageList.
      END.
    END.
    /* DELETE OBJECT INSTANCE UI EVENTS */
    FOR EACH  ryc_ui_event
        WHERE ryc_ui_event.object_type_obj          <> 0
        AND   ryc_ui_event.container_smartobject_obj = b_ryc_smartobject.smartobject_obj
        AND   ryc_ui_event.smartobject_obj           = ryc_object_instance.smartobject_obj
        AND   ryc_ui_event.object_instance_obj       = ryc_object_instance.object_instance_obj
        EXCLUSIVE-LOCK:
      DELETE ryc_ui_event.
      IF RETURN-VALUE <> "":U THEN DO:
        cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + RETURN-VALUE.
        ERROR-STATUS:ERROR = NO.
        RETURN cMessageList.
      END.
    END.

    DELETE ryc_object_instance.
    IF RETURN-VALUE <> "":U THEN DO:
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + RETURN-VALUE.
      ERROR-STATUS:ERROR = NO.
      RETURN cMessageList.
    END.
  END.

  /* DELETE ATTRIBUTE VALUES */
  FOR EACH  ryc_attribute_value
      WHERE ryc_attribute_value.object_type_obj           = b_ryc_smartobject.object_type_obj
      AND   ryc_attribute_value.container_smartobject_obj = 0
      AND   ryc_attribute_value.smartobject_obj           = b_ryc_smartobject.smartobject_obj
      AND   ryc_attribute_value.object_instance_obj       = 0
      EXCLUSIVE-LOCK:
    DELETE ryc_attribute_value.
    IF RETURN-VALUE <> "":U THEN DO:
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + RETURN-VALUE.
      ERROR-STATUS:ERROR = NO.
      RETURN cMessageList.
    END.
  END.
  /* DELETE UI EVENTS */
  FOR EACH  ryc_ui_event
      WHERE ryc_ui_event.object_type_obj           = b_ryc_smartobject.object_type_obj
      AND   ryc_ui_event.container_smartobject_obj = 0
      AND   ryc_ui_event.smartobject_obj           = b_ryc_smartobject.smartobject_obj
      AND   ryc_ui_event.object_instance_obj       = 0
      EXCLUSIVE-LOCK:
    DELETE ryc_ui_event.
    IF RETURN-VALUE <> "":U THEN DO:
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + RETURN-VALUE.
      ERROR-STATUS:ERROR = NO.
      RETURN cMessageList.
    END.
  END.

  /* DELETE LINKS */
  FOR EACH  ryc_smartlink
      WHERE ryc_smartlink.container_smartobject_obj = b_ryc_smartobject.smartobject_obj
      EXCLUSIVE-LOCK:
    DELETE ryc_smartlink.
    IF RETURN-VALUE <> "":U THEN DO:
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + RETURN-VALUE.
      ERROR-STATUS:ERROR = NO.
      RETURN cMessageList.
    END.
  END.

  /* DELETE PAGES */
  FOR EACH  ryc_page
      WHERE ryc_page.container_smartobject_obj = b_ryc_smartobject.smartobject_obj
      EXCLUSIVE-LOCK:
    DELETE ryc_page.
    IF RETURN-VALUE <> "":U THEN DO:
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + RETURN-VALUE.
      ERROR-STATUS:ERROR = NO.
      RETURN cMessageList.
    END.
  END.
  SESSION:SET-WAIT-STATE("":U).
END.

ERROR-STATUS:ERROR = NO.
RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip DataLogicProcedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     entry point to instantly kill the plip if it should get lost in memory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  {ry/app/ryplipkill.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription DataLogicProcedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

  ASSIGN cDescription = "Dynamics ryc_smartobject Data Logic Procedure #2".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup DataLogicProcedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

  {ry/app/ryplipsetu.i}  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown DataLogicProcedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  {ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowObjectValidate DataLogicProcedure 
PROCEDURE rowObjectValidate :
/*------------------------------------------------------------------------------
  Purpose:     Procedure used to validate RowObject record client-side
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cMessageList    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cValueList      AS CHARACTER    NO-UNDO.

  IF isFieldBlank(b_ryc_smartobject.object_filename) THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {aferrortxt.i 'AF' '1' 'ryc_smartobject' 'object_filename' "'Object Filename'"}.

  IF b_ryc_smartobject.product_module_obj = 0 OR b_ryc_smartobject.product_module_obj = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {aferrortxt.i 'AF' '1' 'ryc_smartobject' 'product_module_obj' "'Product Module Obj'"}.

  IF b_ryc_smartObject.container_object AND b_ryc_smartobject.runnable_from_menu = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {aferrortxt.i 'AF' '1' 'ryc_smartobject' 'runnable_from_menu' "'Runnable From Menu'"}.

  IF b_ryc_smartObject.container_object 
     AND (b_ryc_smartobject.layout_obj = 0 OR b_ryc_smartobject.layout_obj = ?) THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {aferrortxt.i 'AF' '1' 'ryc_smartobject' 'layout_obj' "'Layout Obj'"}.

  IF b_ryc_smartobject.object_type_obj = 0 OR b_ryc_smartobject.object_type_obj = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {aferrortxt.i 'AF' '1' 'ryc_smartobject' 'object_type_obj' "'Object Type Obj'"}.

  /** Issue #6736 requests that we allow the changing of the object types
  /* ObjType - The object exists already, if the object type is being changed, raise an error */

  IF NOT isCreate() THEN
      IF  AVAILABLE old_ryc_smartobject
      AND AVAILABLE b_ryc_smartobject
      AND old_ryc_smartobject.object_type_obj <> b_ryc_smartobject.object_type_obj THEN
          ASSIGN
            cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                          {aferrortxt.i 'AF' '36' 'ryc_smartobject' 'object_type_obj' "'the repository object'" "'object types can not be updated once assigned'"}.

  ***************************/

  IF isFieldBlank(b_ryc_smartobject.object_description) THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {aferrortxt.i 'AF' '1' 'ryc_smartobject' 'object_description' "'Object Description'"}.

  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writePreTransValidate DataLogicProcedure  _DB-REQUIRED
PROCEDURE writePreTransValidate :
/*------------------------------------------------------------------------------
  Purpose:     Procedure used to validate records server-side before the transaction scope upon write
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMessageList     AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cValueList       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE iCnt             AS INTEGER      NO-UNDO.
  DEFINE VARIABLE cToolbarChildren AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lCheckChanged    AS LOGICAL      NO-UNDO.
  
  
  IF NOT isCreate() AND CAN-FIND(FIRST ryc_smartobject 
              WHERE ryc_smartobject.object_filename = b_ryc_smartobject.object_filename
                AND ryc_smartobject.customization_result_obj = b_ryc_smartobject.customization_result_obj
                AND ROWID(ryc_smartobject) <> TO-ROWID(ENTRY(1,b_ryc_smartobject.RowIDent))) THEN
  DO:
     ASSIGN
        cValueList   = STRING(b_ryc_smartobject.object_filename) + ', ' + STRING(b_ryc_smartobject.customization_result_obj)
        cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                      {aferrortxt.i 'AF' '8' 'ryc_smartobject' '' "'object_filename, customization_result_obj, '" cValueList }.
  END.


  IF NOT isCreate() AND CAN-FIND(FIRST ryc_smartobject 
              WHERE ryc_smartobject.product_module_obj = b_ryc_smartobject.product_module_obj
                AND ryc_smartobject.object_filename = b_ryc_smartobject.object_filename
                AND ryc_smartobject.customization_result_obj = b_ryc_smartobject.customization_result_obj
                AND ROWID(ryc_smartobject) <> TO-ROWID(ENTRY(1,b_ryc_smartobject.RowIDent))) THEN
  DO:
     ASSIGN
        cValueList   = STRING(b_ryc_smartobject.product_module_obj) + ', ' + STRING(b_ryc_smartobject.object_filename) + ', ' + STRING(b_ryc_smartobject.customization_result_obj)
        cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                      {aferrortxt.i 'AF' '8' 'ryc_smartobject' '' "'product_module_obj, object_filename, customization_result_obj, '" cValueList }.
  END.

  /* Ensure that toolbar security objects are not zero. Issue 2393 (Don B)*/

  IF  b_ryc_smartobject.security_smartobject_obj = 0
  THEN DO:
      ASSIGN cToolbarChildren = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "SmartToolbar").

      DO iCnt = 1 TO NUM-ENTRIES(cToolbarChildren):
          FIND gsc_object_type NO-LOCK
               WHERE gsc_object_type.object_type_code  = ENTRY(iCnt, cToolbarChildren)
               NO-ERROR.

          IF AVAILABLE gsc_object_type THEN
              IF b_ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj THEN
                  ASSIGN b_ryc_smartobject.security_smartobject_obj = b_ryc_smartobject.smartobject_obj.
      END.
  END.
  IF b_ryc_smartobject.deployment_type = ? THEN
     b_ryc_smartobject.deployment_type = "":U.
    
    /* Change the Obejct Type before any other updates */
    IF NOT isCreate() AND b_ryc_smartobject.object_type_obj NE old_ryc_smartobject.object_type_obj THEN
    DO:
        /* Changing the object type will cause errors when we try to commit any further changes
         * to this record. Make sure that we turn the checking off.                             */
        {get CheckCurrentChanged lCheckChanged}.
        {set CheckCurrentChanged NO}.

        RUN changeObjectType IN gshRepositoryManager ( INPUT b_ryc_smartobject.smartobject_obj,
                                                       INPUT b_ryc_smartobject.object_type_obj,
                                                       INPUT old_ryc_smartobject.object_type_obj ) NO-ERROR.

        /* Reset to previous value. */
        {set CheckCurrentChanged lCheckChanged}.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
            ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + RETURN-VALUE.
    END.  /* object type has changed. */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN cMessageList.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isFieldBlank DataLogicProcedure 
FUNCTION isFieldBlank RETURNS LOGICAL
  ( INPUT pcFieldValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Checks whether a character field is blank
    Notes:  
------------------------------------------------------------------------------*/

  IF LENGTH(TRIM(pcFieldValue)) = 0 OR LENGTH(TRIM(pcFieldValue)) = ? THEN
    RETURN TRUE.
  ELSE
    RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

