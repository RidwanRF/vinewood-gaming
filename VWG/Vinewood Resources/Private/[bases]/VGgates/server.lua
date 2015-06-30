local arr = exports.VGtables:getTable('gates')

local data = {}

function open ( hElm, mDim )
    if ( data[ source ] ) and ( mDim ) then
        if ( getElementType( hElm ) == 'player' ) then
            if ( allowed( hElm, data[ source ] ) ) then
                local g = data[ source ]
                moveObject( g.elm, 400, g.data[2].x, g.data[2].y, g.data[2].z )
            end
        elseif ( getElementType( hElm ) == 'vehicle' ) then
            for _, occupant in pairs( getVehicleOccupants( hElm ) or {} ) do
                if ( getElementType( occupant ) == 'player' ) then
                    if ( allowed( occupant, data[ source ] ) ) then
                        local g = data[ source ]
                        moveObject( g.elm, 400, g.data[2].x, g.data[2].y, g.data[2].z )
                    end
                end
            end
        end
    end 
end

function close ( hElm, mDim )
    if ( data[ source ] ) and ( mDim ) then
        if ( getElementType( hElm ) == 'player' ) then
            if ( allowed( hElm, data[ source ] ) ) then
                local g = data[ source ]
                moveObject( g.elm, 400, g.data[1].x, g.data[1].y, g.data[1].z )
            end
        elseif ( getElementType( hElm ) == 'vehicle' ) then
            for _, occupant in pairs( getVehicleOccupants( hElm ) or {} ) do
                if ( getElementType( occupant ) == 'player' ) then
                    if ( allowed( occupant, data[ source ] ) ) then
                        local g = data[ source ]
                        moveObject( g.elm, 400, g.data[1].x, g.data[1].y, g.data[1].z )
                    end
                end
            end
        end
    end 
end

function allowed( plr, tbl )
    if ( getPlayerTeam( plr ) ) and ( getTeamName( getPlayerTeam( plr ) ) == 'Staff' ) then
        return true
    end
    
    -- local group = exports.VGgroups:getPlayerGroupName( plr )
    local group = false
    if ( group ) and ( tbl.data.group == group ) or ( getPlayerTeam( plr ) ) and ( tbl.data.team == getTeamName( getPlayerTeam( plr ) ) ) then
        return true
    end

    return false
end

for _, row in ipairs( arr ) do
    local col = createColSphere ( row[1].x, row[1].y, row[1].z, row[1].col )
    local gate = createObject ( row[1].model, row[1].x, row[1].y, row[1].z, row[1].rx, row[1].ry, row[1].rz )

    data[ col ] = { id = _, elm = gate, data = row }

    addEventHandler( "onColShapeHit", col, open )
    addEventHandler( "onColShapeLeave", col, close )
end
