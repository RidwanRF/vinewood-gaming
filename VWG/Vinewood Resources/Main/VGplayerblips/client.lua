






-- Tables
local playerBlips = {}

-- Create a blip for whenever a player joins
addEventHandler( "onClientResourceStart", resourceRoot,
	function ()
		for k, thePlayer in ipairs ( getElementsByType( "player" ) ) do
			if not ( playerBlips[ thePlayer ] ) then
				playerBlips[ thePlayer ] = createBlipAttachedTo( thePlayer, 0, 2, 0, 0, 0, 255 )
				setBlipVisibleDistance( playerBlips[ thePlayer ], 99999 )
			end
		end
	end
)

-- When a player joins the server
addEventHandler( "onClientPlayerJoin", root,
	function()
		if not ( playerBlips[ source ] ) then
			playerBlips[ source ] = createBlipAttachedTo( source, 0, 2, 0, 0, 0, 255 )
			setBlipVisibleDistance( playerBlips[ source ], 99999 )
		end
	end
)

-- The actual blip stuff
addEventHandler( "onClientRender", root,
	function ()
		for thePlayer, theBlip in pairs( playerBlips ) do
			if ( isElement( thePlayer ) ) and not ( thePlayer == localPlayer ) then
				if ( getPlayerTeam( thePlayer ) ) then					
					-- If the player is invisable
					if ( getElementAlpha( thePlayer ) == 0 ) then
						-- If the player is invisable set the blip color invisable too
						local _, _, _, blipAlpha = getBlipColor ( theBlip )
						local R, G, B = getTeamColor( getPlayerTeam( thePlayer ) )
						setBlipColor( theBlip, R, G, B, 0 )
					else
						-- Change the blip color but keep the alpha the same
						local _, _, _, blipAlpha = getBlipColor ( theBlip )
						local R, G, B = getTeamColor( getPlayerTeam( thePlayer ) )
						setBlipColor( theBlip, R, G, B, 225 )
					end
				end
			end
		end
	end
)

-- Destroy the blip when a player quits
addEventHandler( "onClientPlayerQuit", root,
	function ()
		if ( isElement( playerBlips[ source ] ) ) then
			destroyElement( playerBlips[ source ] )
			playerBlips[ source ] = nil
		end
	end
)