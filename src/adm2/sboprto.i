/*
 * Prototype include file: src\adm2\sboprto.i
 * Created from procedure: \adm2\sbo.p at 12:55 on 12/11/00
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE assignMaxGuess IN SUPER:
  DEFINE INPUT PARAMETER piMaxGuess AS INTEGER.
END PROCEDURE.

PROCEDURE commitTransaction IN SUPER:
END PROCEDURE.

PROCEDURE dataAvailable IN SUPER:
  DEFINE INPUT PARAMETER pcRelative AS CHARACTER.
END PROCEDURE.

PROCEDURE fetchBatch IN SUPER:
  DEFINE INPUT PARAMETER plForwards AS LOGICAL.
END PROCEDURE.

PROCEDURE fetchContainedData IN SUPER:
  DEFINE INPUT PARAMETER pcObject AS CHARACTER.
END PROCEDURE.

PROCEDURE fetchDOProperties IN SUPER:
END PROCEDURE.

PROCEDURE fetchFirst IN SUPER:
END PROCEDURE.

PROCEDURE fetchLast IN SUPER:
END PROCEDURE.

PROCEDURE fetchNext IN SUPER:
END PROCEDURE.

PROCEDURE fetchPrev IN SUPER:
END PROCEDURE.

PROCEDURE initializeObject IN SUPER:
END PROCEDURE.

PROCEDURE postCreateObjects IN SUPER:
END PROCEDURE.

PROCEDURE prepareErrorsForReturn IN SUPER:
  DEFINE INPUT PARAMETER pcReturnValue AS CHARACTER.
  DEFINE INPUT PARAMETER pcASDivision AS CHARACTER.
  DEFINE INPUT-OUTPUT PARAMETER pcMessages AS CHARACTER.
END PROCEDURE.

PROCEDURE serverContainedSendRows IN SUPER:
  DEFINE INPUT PARAMETER piStartRow AS INTEGER.
  DEFINE INPUT PARAMETER pcRowIdent AS CHARACTER.
  DEFINE INPUT PARAMETER plNext AS LOGICAL.
  DEFINE INPUT PARAMETER piRowsToReturn AS INTEGER.
  DEFINE INPUT PARAMETER pcObjectName AS CHARACTER.
  DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject.
END PROCEDURE.

PROCEDURE serverFetchContainedData IN SUPER:
  DEFINE INPUT PARAMETER pcQueries AS CHARACTER.
  DEFINE INPUT PARAMETER pcPositions AS CHARACTER.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject1.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject2.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject3.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject4.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject5.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject6.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject7.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject8.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject9.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject10.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject11.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject12.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject13.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject14.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject15.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject16.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject17.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject18.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject19.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject20.
END PROCEDURE.

PROCEDURE serverFetchDOProperties IN SUPER:
  DEFINE OUTPUT PARAMETER pcPropList AS CHARACTER.
END PROCEDURE.

PROCEDURE undoTransaction IN SUPER:
END PROCEDURE.

PROCEDURE updateState IN SUPER:
  DEFINE INPUT PARAMETER pcState AS CHARACTER.
END PROCEDURE.

FUNCTION addQueryWhere RETURNS LOGICAL
  (INPUT pcWhere AS CHARACTER,
   INPUT pcBuffer AS CHARACTER,
   INPUT pcAndOr AS CHARACTER) IN SUPER.

FUNCTION addRow RETURNS CHARACTER
  (INPUT pcViewColList AS CHARACTER) IN SUPER.

FUNCTION assignCurrentMappedObject RETURNS LOGICAL
  (INPUT phRequester AS HANDLE,
   INPUT pcObjectName AS CHARACTER) IN SUPER.

FUNCTION assignQuerySelection RETURNS LOGICAL
  (INPUT pcColumns AS CHARACTER,
   INPUT pcValues AS CHARACTER,
   INPUT pcOperators AS CHARACTER) IN SUPER.

FUNCTION cancelRow RETURNS CHARACTER IN SUPER.

FUNCTION columnColumnLabel RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnDataType RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnDbColumn RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnExtent RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnFormat RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnHelp RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnInitial RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnLabel RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnMandatory RETURNS LOGICAL
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnModified RETURNS LOGICAL
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnObjectHandle RETURNS HANDLE
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnPrivateData RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnQuerySelection RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnReadOnly RETURNS LOGICAL
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnStringValue RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnTable RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnValExp RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnValMsg RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnValue RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnWidth RETURNS DECIMAL
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION colValues RETURNS CHARACTER
  (INPUT pcViewColList AS CHARACTER) IN SUPER.

FUNCTION copyRow RETURNS CHARACTER
  (INPUT pcViewColList AS CHARACTER) IN SUPER.

FUNCTION currentMappedObject RETURNS CHARACTER
  (INPUT phRequester AS HANDLE) IN SUPER.

FUNCTION dataObjectHandle RETURNS HANDLE
  (INPUT pcObjectName AS CHARACTER) IN SUPER.

FUNCTION deleteRow RETURNS LOGICAL
  (INPUT pcRowIdent AS CHARACTER) IN SUPER.

FUNCTION getAppService RETURNS CHARACTER IN SUPER.

FUNCTION getASDivision RETURNS CHARACTER IN SUPER.

FUNCTION getASHandle RETURNS HANDLE IN SUPER.

FUNCTION getAutoCommit RETURNS LOGICAL IN SUPER.

FUNCTION getCascadeOnBrowse RETURNS LOGICAL IN SUPER.

FUNCTION getCommitSource RETURNS HANDLE IN SUPER.

FUNCTION getCommitSourceEvents RETURNS CHARACTER IN SUPER.

FUNCTION getContainedDataColumns RETURNS CHARACTER IN SUPER.

FUNCTION getContainedDataObjects RETURNS CHARACTER IN SUPER.

FUNCTION getDataColumns RETURNS CHARACTER IN SUPER.

FUNCTION getDataHandle RETURNS HANDLE IN SUPER.

FUNCTION getDataObjectNames RETURNS CHARACTER IN SUPER.

FUNCTION getDataObjectOrdering RETURNS CHARACTER IN SUPER.

FUNCTION getDataQueryBrowsed RETURNS LOGICAL IN SUPER.

FUNCTION getDataTargetEvents RETURNS CHARACTER IN SUPER.

FUNCTION getForeignFields RETURNS CHARACTER IN SUPER.

FUNCTION getForeignValues RETURNS CHARACTER IN SUPER.

FUNCTION getMasterDataObject RETURNS HANDLE IN SUPER.

FUNCTION getNavigationSource RETURNS CHARACTER IN SUPER.

FUNCTION getNavigationSourceEvents RETURNS CHARACTER IN SUPER.

FUNCTION getObjectMapping RETURNS CHARACTER IN SUPER.

FUNCTION getQueryPosition RETURNS CHARACTER IN SUPER.

FUNCTION getRowObjectState RETURNS CHARACTER IN SUPER.

FUNCTION getRowsToBatch RETURNS INTEGER IN SUPER.

FUNCTION getServerFileName RETURNS CHARACTER IN SUPER.

FUNCTION getUpdatableColumns RETURNS CHARACTER IN SUPER.

FUNCTION openQuery RETURNS LOGICAL IN SUPER.

FUNCTION removeQuerySelection RETURNS LOGICAL
  (INPUT pcColumns AS CHARACTER,
   INPUT pcValues AS CHARACTER,
   INPUT pcOperators AS CHARACTER) IN SUPER.

FUNCTION resetQuery RETURNS LOGICAL
  (INPUT pcObject AS CHARACTER) IN SUPER.

FUNCTION setAppService RETURNS LOGICAL
  (INPUT pcService AS CHARACTER) IN SUPER.

FUNCTION setASDivision RETURNS LOGICAL
  (INPUT pcDivision AS CHARACTER) IN SUPER.

FUNCTION setASHandle RETURNS LOGICAL
  (INPUT phAppServer AS HANDLE) IN SUPER.

FUNCTION setAutoCommit RETURNS LOGICAL
  (INPUT plCommit AS LOGICAL) IN SUPER.

FUNCTION setCascadeOnBrowse RETURNS LOGICAL
  (INPUT plCascade AS LOGICAL) IN SUPER.

FUNCTION setCommitSource RETURNS LOGICAL
  (INPUT phSource AS HANDLE) IN SUPER.

FUNCTION setContainedDataColumns RETURNS LOGICAL
  (INPUT pcColumns AS CHARACTER) IN SUPER.

FUNCTION setDataObjectNames RETURNS LOGICAL
  (INPUT pcNames AS CHARACTER) IN SUPER.

FUNCTION setDataQueryBrowsed RETURNS LOGICAL
  (INPUT plBrowsed AS LOGICAL) IN SUPER.

FUNCTION setForeignFields RETURNS LOGICAL
  (INPUT pcFields AS CHARACTER) IN SUPER.

FUNCTION setForeignValues RETURNS LOGICAL
  (INPUT pcValues AS CHARACTER) IN SUPER.

FUNCTION setNavigationSource RETURNS LOGICAL
  (INPUT pcSource AS CHARACTER) IN SUPER.

FUNCTION setObjectMapping RETURNS LOGICAL
  (INPUT pcMapping AS CHARACTER) IN SUPER.

FUNCTION setRowObjectState RETURNS LOGICAL
  (INPUT pcState AS CHARACTER) IN SUPER.

FUNCTION setServerFileName RETURNS LOGICAL
  (INPUT pcFileName AS CHARACTER) IN SUPER.

FUNCTION submitRow RETURNS LOGICAL
  (INPUT pcRowIdent AS CHARACTER,
   INPUT pcValueList AS CHARACTER) IN SUPER.

FUNCTION getObjectType RETURNS CHARACTER IN SUPER.
