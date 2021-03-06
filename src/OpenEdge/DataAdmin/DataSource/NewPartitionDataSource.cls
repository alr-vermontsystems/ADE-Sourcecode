 /*************************************************************/
  /* Copyright (c) 2011 by progress Software Corporation.      */
  /*                                                           */
  /* all rights reserved.  no part of this program or document */
  /* may be  reproduced in  any form  or by  any means without */
  /* permission in writing from progress Software Corporation. */
  /*************************************************************/
 /*------------------------------------------------------------------------
    Purpose     : new partitions before create
                 - for new tenant or group       
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :  2011
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.
 
using OpenEdge.DataAdmin.DataSource.PartitionDataSource from propath.
using OpenEdge.DataAdmin.Lang.QueryString from propath.
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
 
class OpenEdge.DataAdmin.DataSource.NewPartitionDataSource inherits PartitionDataSource: 
    
    define variable mType as char no-undo.
    define variable mKey as char no-undo.
    define variable mDataArea as char no-undo.
    define variable mIndexArea as char no-undo.
    define variable mLobArea as char no-undo.
    define variable mAllocation as char no-undo.
    define variable mRefTable as character no-undo.
         
    define protected property FileExpression as char no-undo
        get():
             return DatabaseInfo:FileExpression.       
        end.
            
	constructor public NewPartitionDataSource (pcTables  as char,
                                               pcPhysicalTables as char,
                                               pcMapping     as char) :
        super(pcTables,pcPhysicalTables,pcMapping,yes ). 
    end constructor.
    
    method protected override logical Prepare(phBuffer as handle,pcBaseQuery as char,pcTargetQuery as char,pcJoin as char):
        define variable oQueryString as class QueryString.
        define variable lOk          as logical    no-undo.
        define variable hParentRel   as handle     no-undo.
        define variable cQuery       as character no-undo.
        
        /* this override was added before we supported the optional basequery 
           It is not needed here since it currently only handle single key, but add an error for protection 
           (it is easy to add if needed)*/  
        
        if pcBaseQuery > "" then
            undo, throw new UnsupportedOperationError("Prepare query with key is not supported").
        
        DataBuffer = phBuffer.    
        
        phBuffer:set-callback("After-Row-fill","AfterRow").              
        CreateQuery().    
        hParentRel = ParentRelation.
        
        /* fieldmapping is set from constructor */
        DataBuffer:attach-data-source(DataSourceHandle:handle,FieldMapping) .
       
/*        hParentRel = ParentRelation.*/
        
        if pcTargetQuery > "" or pcJoin > '' or valid-handle(hParentRel) then
        do:
            oQueryString = new QueryString(pcTargetQuery,this-object).

            if pcJoin > '' then
            do:
                     
                oQueryString:addExpression(pcJoin).
                
            end.
            /* Data-Sources are defined with queries in the constructor in the event that
               there is a join involved. Add and transform the fill-where-string for the dependent 
               tables so that Progress can identify the related when filling the temp-tables.
              (columnValue ensures parent reference is NOT transformed) */
            else if valid-handle(hParentRel) and hParentRel:active and not hParentRel:reposition then
                oQueryString:addExpression(DataSourceHandle:fill-where-string).
            if mType = "P" then
                 oQueryString:AddExpression(" _file._file-attributes[1] = 'false'").
            else
                 oQueryString:AddExpression(" _file._file-attributes[1] = 'true'").
            cQuery = oQueryString:BuildQueryString(Tables).
         
/*              oQueryString:showdata() .*/
 
            lok = QueryHandle:query-prepare (cQuery).
            delete object oQueryString. 
        end.
        else
            lok = Prepare().
        return lok.    
    end method. 
    
    method public override void AfterRow(dataset-handle hds):
         
        define variable hbuffer as handle    no-undo.
         
        hBuffer = hds:get-buffer-handle("ttPartition") .
                            
        if hBuffer::IndexName <> "" then
            hBuffer::ObjectType = "Index".   
        else if hBuffer::FieldName <> "" then
            hBuffer::ObjectType = "Field".   
        else
            hBuffer::ObjectType = "Table".   
        
        hBuffer::AllocationState = mAllocation.
  
        if mType = "T" then 
        do:
            hBuffer::TenantName = mKey.
            hBuffer::TenantGroupName = ?.  /* avoid unique index error */
            hBuffer::PartitionPolicyDetailName = ?.  /* avoid unique index error */
        end.
        else if mType = "G" then
        do:
            hBuffer::TenantGroupName = mKey. 
            hBuffer::TenantName = ?.  /* avoid unique index error */
            hBuffer::PartitionPolicyDetailName = ?.  /* avoid unique index error */
        end.
        else do:
            hBuffer::PartitionPolicyDetailName = mKey. 
            hBuffer::TenantGroupName = ?.  /* avoid unique index error */
            hBuffer::TenantName = ?.  /* avoid unique index error */
            /*the default is two levels up so the mAllocation field is currently typically blank  */
            if hBuffer::AllocationState = "" then
                hBuffer::AllocationState = "None".
        end.
         
        /*    DEFAULT    hBuffer::BufferPool = partition:ObjectLevelBufferPool.*/
        hBuffer::CanAssignAlternateBufferPool = true.
        if hBuffer::ObjectType = "table" then 
            hBuffer::Areaname = mDataArea.
        else if hBuffer::ObjectType = "index" then 
            hBuffer::Areaname = mIndexArea.
        else if hBuffer::ObjectType = "field" then 
            hBuffer::Areaname = mLobArea.
        
        /** no url - external caller simulates from schema request 
        if hBuffer::AreaName > "" then
            hBuffer::AreaUrl    = AreaURL + WebUtil:UrlEncode(hBuffer::AreaName).
        
        if hBuffer::TenantName > "" then
        do:
            hBuffer::TenantUrl  = TenantURL + WebUtil:UrlEncode(hBuffer::TenantName).
            if  hBuffer::ObjectType = "table" 
            and hBuffer::AllocationState = "Allocated" then
                hBuffer::DeallocateUrl = hBuffer::TenantUrl + "/partitions/" + WebUtil:UrlEncode(hBuffer::TableName) + "/deallocate".
        end.
        if hBuffer::TenantGroupName > "" then
            hBuffer::TenantGroupUrl  = GroupUrl + WebUtil:UrlEncode(hBuffer::TenantGroupName).
        **/
    end method. 
    
    /** check and set parent key value if ok (parent is tenant or group)
        @throws IllegalArgumentError if  
            - this is not the only parent expression in the query 
            - the parent expression is not unique
            - an expression for the other parent has already been encountered 
            - the group or tenant exist 
         
        */
    method public void CheckParentExpression(pccol as char,pcop as char,pcVal as char):
        define variable cMsgMany as character no-undo         
               init "Can only have one unique expression (ttTenant.Name, ttTenantGroup.Name or ttPartitionPolicy.Name) to identify the new owner in a request for new partitions.".
        define variable cMsgOp as character no-undo         
               init "Invalid expression &1 &2 &3 in new partition request. Can only have equals operator in &1 expression.".
        define variable cMsgBoth as character no-undo         
               init "Cannot reference both &1 and &2 in new partition request.". 
        define variable ctable  as character no-undo. 
        define variable lError  as logical no-undo. 
        define variable hPolicyDet as handle no-undo.
        if pccol  = "ttPartition.TenantName" then 
            cTable = "ttTenant".
        else if pccol  = "ttPartition.TenantGroupName" then 
            cTable = "ttTenantGroup".
        else if pccol  = "ttPartition.PartitionPolicyDetailName" then 
            cTable = "ttPartitionPolicyDetail".
        else       
            ctable = entry(1,pccol,".").    
        
        if lookup(pcop,"EQ,=") = 0 then 
            undo, throw new IllegalArgumentError(substitute (cMsgOp,pccol,pcop,quoter(pcval))).
        if mType <> "" then
            undo, throw new IllegalArgumentError(cMsgMany).
        if mRefTable <> "" and mRefTable <> cTable then
            undo, throw new IllegalArgumentError(substitute (cMsgboth,mRefTable,cTable)).
                
        case cTable:
            when "ttTenant" then
                lError = can-find(dictdb._tenant where _tenant._tenant-name = pcVal).
            when "ttTenantGroup" then
                lError = can-find(dictdb._Partition-set where _Partition-set._Pset-name = pcVal).
            when "ttPartitionPolicyDetail" then
            do on error undo, throw:
                /* could define this as property/field, but assumption is that this happens rarely (once or never) */
                create buffer hPolicyDet for table "_Partition-policy-detail".
                hPolicyDet:find-unique ("where _Partition-policy-detail._Policy-name = " + quoter(pcVal)) no-error.
                catch e as Progress.Lang.Error :
                   message e:GetMessage(1)
                   view-as alert-box.		
                end catch.
                finally:
                    delete object hPolicyDet no-error.		
                end finally.
            end.         
            otherwise 
               undo, throw new IllegalArgumentError("Invalid column refeference in new partition query. " + pccol). 
        end.
        
        if lError then
            undo, throw new IllegalArgumentError(substr(cTable,3) + " " + pcval
                                         + " already exists. Cannot retrieve partitions for a new "
                                          + substr(cTable,3) + " with the same name." ). 
                   
        mRefTable = ctable.
        mType = if cTable = "ttTenant" then "T" else if cTable = "ttTenantGroup" then "G" else "P".
        mKey = pcVal. 
        
    end method.
    
    method public override char ColumnExpression(pccol as char,pcop as char,pcVal as char):
        define variable ctable  as character no-undo.
        define variable cColumn as character no-undo.
        define variable iVal    as integer no-undo.
        define variable cMsgMany as character no-undo         
               init "Can only have one unique expression (ttTenant.Name or ttTenantGroup.Name) to identify the new owner in a request for new partitions.".
        define variable cMsgOp as character no-undo         
               init "Invalid expression &1 &2 &3 in new partition request. Can only have equals operator in &1 expression.".
        define variable cMsgBoth as character no-undo         
               init "Cannot reference both ttTenant and ttTenantGroup in new partition request.". 
      
        ctable = entry(1,pccol,".") no-error. 
        if lookup(pccol,"ttTenant.Name,ttPartition.TenantName,ttTenantGroup.Name,ttPartition.TenantGroupName,ttPartitionPolicyDetail.name,ttPartition.PartitionPolicyDetailName") > 0 then
        do:
            CheckParentExpression(pccol,pcop,pcval).
            return ?.        
        end.          
        else if cTable = "ttTenant" or cTable = "ttTenantGroup" or  cTable = "ttPartitionPolicyDetail" then 
        do:
            if mRefTable <> "" and mRefTable <> cTable then
                undo, throw new IllegalArgumentError(cMsgBoth).
            mRefTable = ctable.      
                      
            cColumn = entry(2,pccol,".").
            case ccolumn:
                when "DefaultAllocation" then
                do:
                    if pcVal = "Immediate" then 
                        mAllocation = "Allocated".
                    else do:    
                        iVal = lookup(pcVal,ValidAllocationList).
                        if iVal = 0 then
                             undo, throw new IllegalArgumentError("Invalid AllocationState value " 
                                                                   + quoter(pcVal) + " in new partition request."). 
                       /* use the value from the list to get consistent values */
                        mAllocation = entry(iVal,ValidAllocationList).
                    end.
                end.
                when "DefaultDataArea" then
                     mDataArea = pcval.
                when "DefaultLobArea" then
                     mLobArea = pcval.
                when "DefaultIndexArea" then
                     mIndexArea = pcval.
                otherwise   
                     undo, throw new IllegalArgumentError("Can only reference Default* fields of "
                                                          + cTable + " in new partition request.").
            end.
            return ?.
            
        end.

        return super:ColumnExpression(pccol,pcop,pcVal).
    end method.    
    
      /* convert istype2 value in query to the expression required in the db */
    method public override character ColumnSortSource(pcColumn as char):
        undo, throw new IllegalArgumentError("Cannot sort new partition request.").
    end method.
        
    method public override character ColumnSource (pcColumn as char):
        define variable cTable as character no-undo.        
        define variable cColumn as character no-undo.  
              
        ctable = entry(1,pccolumn,".") no-error. 
       
        if lookup(cTable,"ttTenant,ttTenantGroup,ttPartitionPolicyDetail,_file") > 0  then 
            return pccolumn. 
     
        /* keep the fields that we'll validate and grab the value from in columnExpression as-is */
        if pcColumn  = "ttPartition.TenantName" then 
            return pccolumn.
        
        if pcColumn = "ttPartition.TenantGroupName" then 
            return pccolumn. 
        
        if pcColumn = "ttPartition.PartitionPolicyDetailName" then 
            return pccolumn. 
        
         
        if pcColumn = "ttPartition.TableName" 
        or pcColumn = "ttPartition.IndexName" 
        or pcColumn = "ttPartition.FieldName"
        or pcColumn = "ttPartition.ObjectType"
        /* this will require mapped source to same dataset */
        or lookup(cTable,"ttTable,ttField,ttIndex") <> 0 then
        do:
            return super:Columnsource(pccolumn). 
        end.
        else 
            undo, throw new IllegalArgumentError("Cannot reference " + pccolumn + " in new partition request.").
            
       
    end method.  
       
end class.