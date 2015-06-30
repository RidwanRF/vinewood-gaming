local rootElement = getRootElement()

function runString (commandstring, outputTo, source)
	local sourceName
	if source then
		sourceName = getPlayerName(source)
	else
		sourceName = "Console"
	end
	outputChatBoxR(sourceName.." executed command: "..commandstring, outputTo, true)
	local notReturned
	--First we test with return
	local commandFunction,errorMsg = loadstring("return "..commandstring)
	if errorMsg then
		--It failed.  Lets try without "return"
		notReturned = true
		commandFunction, errorMsg = loadstring(commandstring)
	end
	if errorMsg then
		--It still failed.  Print the error message and stop the function
		outputChatBoxR("Error: "..errorMsg, outputTo)
		logRuncode( source, commandstring, "Error: "..errorMsg, "server" )
		return
	end
	--Finally, lets execute our function
	results = { pcall(commandFunction) }
	if not results[1] then
		--It failed.
		outputChatBoxR("Error: "..results[2], outputTo)
		logRuncode( source, commandstring, "Error: "..results[2], "server" )
		return
	end
	if not notReturned then
		local resultsString = ""
		local first = true
		for i = 2, #results do
			if first then
				first = false
			else
				resultsString = resultsString..", "
			end
			local resultType = type(results[i])
			if isElement(results[i]) then
				resultType = "element:"..getElementType(results[i])
			end
			resultsString = resultsString..tostring(results[i]).." ["..resultType.."]"
		end
		outputChatBoxR("Command results: "..resultsString, outputTo)
		logRuncode( source, commandstring, resultsString, "server" )
	elseif not errorMsg then
		outputChatBoxR("Command executed!", outputTo)
		logRuncode( source, commandstring, "Command executed!", "server" )
	end
end

-- run command
addCommandHandler("run",
	function (player, command, ...)
		local commandstring = table.concat({...}, " ")
		return runString(commandstring, rootElement, player)
	end
)

-- silent run command
addCommandHandler("srun",
	function (player, command, ...)
		local commandstring = table.concat({...}, " ")
		return runString(commandstring, player, player)
	end
)

-- clientside run command
addCommandHandler("crun",
	function (player, command, ...)
		local commandstring = table.concat({...}, " ")
		if player then
			return triggerClientEvent(player, "doCrun", rootElement, commandstring)
		else
			return runString(commandstring, false, false)
		end
	end
)