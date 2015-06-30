tbl = {}

function START_DOUBLE_SIDED_TRANSACTION ()
    tbl.func = createObject

    createObject = function ( modelid, x, y, z, rx, ry, rz, _, frozen, scale, breakable, doublesided )
        local obj = tbl.func( modelid, x, y, z, rx, ry, rz )

        setElementDoubleSided ( obj, not doublesided )
        setObjectBreakable( obj, breakable or false )
        setElementFrozen( obj, not frozen )
        setObjectScale( obj, ( scale ) and scale or 1 )

        return obj
    end

    createObjectLOD = function ( modelid, x, y, z, rx, ry, rz, _, frozen, scale, breakable, doublesided )
        local obj = tbl.func( modelid[1], x, y, z, rx, ry, rz )
        local objLOD = tbl.func( modelid[2], x, y, z, rx, ry, rz, true )

        setLowLODElement ( obj, objLOD )

        setElementDoubleSided ( obj, not doublesided )
        setObjectBreakable( obj, breakable or false )
        setElementFrozen( obj, not frozen )
        setObjectScale( obj, ( scale ) and scale or 1 )

        return obj, objLOD
    end
end

function END_DOUBLE_SIDED_TRANSACTION ()
    createObject = tbl.func
    createObjectLOD = nil
end