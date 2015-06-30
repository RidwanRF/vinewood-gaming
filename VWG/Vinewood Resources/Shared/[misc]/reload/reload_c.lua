addCommandHandler("Reload weapon",
	function()
		local task = getPedSimplestTask(localPlayer)
		if (task == "TASK_SIMPLE_JUMP" or task == "TASK_SIMPLE_IN_AIR" or task == "TASK_SIMPLE_CLIMB" or task == "TASK_SIMPLE_LAND" and not doesPedHaveJetPack(localPlayer)) then return false end
		triggerServerEvent("onPlayerReload", localPlayer)
	end
)

bindKey("r","down","Reload weapon")