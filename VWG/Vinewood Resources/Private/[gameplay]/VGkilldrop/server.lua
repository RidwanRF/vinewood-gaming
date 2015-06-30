local arr = {};

function dropMoney( thePlayer )
    local amount = math.random( 1000, 6000 );

    if ( amount > getPlayerMoney( thePlayer ) ) then
        amount = getPlayerMoney( thePlayer );
    end

    takePlayerMoney( thePlayer, amount );

    local x, y, z = getElementPosition( thePlayer );

    local k = math.random( 1, 8 )

    for i = 1, k do
        arr[ createPickup( x + math.random( 2 ) - math.random( 2 ), y + math.random( 2 ) - math.random( 2 ), z - 0.8, 3, 1212 ) ] = { math.floor( amount / k ), getTickCount(), thePlayer };
    end
end

addEventHandler( "onPlayerWasted", root,
    function( ammo, attacker, weapon, bodypart )
        if ( attacker ) and ( getElementType( attacker ) == "player" ) and ( attacker ~= source ) then
            dropMoney( source )
        end
    end
)    

addEventHandler( "onPlayerPickupUse", root,    
    function ( thePickup )
        if ( getElementType( source ) ~= "player" ) then
            cancelEvent();
            return;
        end

        if ( arr[ thePickup ] ) then
            if ( getTickCount() - arr[ thePickup ][2] < 6000 ) and ( source == arr[ thePickup ][3] ) then
                cancelEvent();
                return;
            end

            givePlayerMoney( source, arr[ thePickup ][1] );

            destroyElement( thePickup );
        end
    end
)