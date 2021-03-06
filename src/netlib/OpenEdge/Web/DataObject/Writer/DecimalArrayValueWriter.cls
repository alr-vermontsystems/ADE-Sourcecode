/* *************************************************************************************************************************
Copyright (c) 2016, 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : IntegerValueWriter
    Purpose     : Writes a primitive value to a IInt64Holder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IDecimalArrayHolder.
using Ccs.Common.Support.IDecimalHolder.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Collections.List.
using OpenEdge.Core.Decimal.
using OpenEdge.Core.DecimalArrayHolder.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.Writer.DecimalArrayValueWriter inherits ArgumentValueWriter:
    /* Since arrays are hard to dynamically extend, use a backing IList (ordered collection) to store the 
       values passed in until we Flush()/Close() the writer */
    define variable mBackingList as IList no-undo.
    
    constructor public DecimalArrayValueWriter ():
        super(get-class(IDecimalArrayHolder)).
        
        assign mBackingList = new List().
    end constructor.
    
    method override public void Clear():
        mBackingList:Clear().
        
        super:Clear().
    end method.
    
    method override public void Flush():
        define variable holder as decimal extent no-undo.
        define variable iter as IIterator no-undo.
        define variable idx as integer no-undo.
        
        super:Flush().
        
        if mBackingList:Size gt 0 then
        do:
            assign iter           = mBackingList:Iterator()
                   extent(holder) = mBackingList:Size
                   idx            = 1
                   .
            do while iter:HasNext():
                assign holder[idx] = cast(iter:Next(), IDecimalHolder):Value
                       idx         = idx + 1
                       .
            end.
        end.
        
        assign this-object:Value = new DecimalArrayHolder(holder).
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object extent):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        
        assign cnt = extent(pData).
        do loop = 1 to cnt:
            this-object:Write(pData[loop]).
        end.
    end method.
    
    method override public void Write( input pData as decimal extent):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        
        assign cnt = extent(pData).
        do loop = 1 to cnt:
            mBackingList:Add(new Decimal(pData[loop])).
        end.
    end method.
    
    method override public void Write( input pData as decimal):
        mBackingList:Add(new Decimal(pData)).
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object):
        define variable cnt as integer no-undo.
        define variable loop as integer no-undo.
        
        case true:
            when not valid-object(pData) then
                mBackingList:Add(new Decimal(?)).
            
            when type-of(pData, JsonArray) then
            do:
                assign cnt = cast(pData, JsonArray):Length.
                do loop = 1 to cnt:
                    if cast(pData, JsonArray):IsNull(loop) then
                        mBackingList:Add(new Decimal(?)).
                    else
                        mBackingList:Add(new Decimal(cast(pData, JsonArray):GetDecimal(loop))).
                end.
            end.
            
            when type-of(pData, IDecimalArrayHolder) then
               this-object:Write(cast(pData, IDecimalArrayHolder):Value).

            when type-of(pData, IDecimalHolder) then
                mBackingList:Add(pData).
            
            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
        end case.
    end method.

end class.