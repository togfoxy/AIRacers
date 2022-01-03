functions = {}

function functions.getXYFromRowCol(row,col)
	-- converts a row/col into a y/x pair for drawing to screen
	-- returns x, y (not y/x)
	local x,y
	x = 10 + (col * CELLSIZE)
	y = 10 + (row * CELLSIZE)
	return x, y
end

function functions.saveMemory(car)
	-- uses the globals because too hard to pass params

    local savefile
    local contents
    local success, message
    local savedir = love.filesystem.getSource()

    savefile = savedir .. "/savedata/" .. "trackmemory" .. car.index .. ".dat"
    serialisedString = bitser.dumps(car.track[CURRENT_TRACK])
    success, message = Nativefs.write(savefile, serialisedString )

	-- LovelyToasts.show("Game saved",3, "middle")
end

function functions.loadMemory(car)

    local savedir = love.filesystem.getSource()
    love.filesystem.setIdentity( savedir )

    local savefile
    local contents
	local size
	local error = false

	savefile = savedir .. "/savedata/" .. "trackmemory" .. car.index .. ".dat"
	if Nativefs.getInfo(savefile) then
		contents, size = Nativefs.read(savefile)
	    car.track[CURRENT_TRACK] = bitser.loads(contents)
	else
		error = true
	end

	if error then
		-- no memory on file. Initialise
		car.track = {}	-- records what it knows about each track
		car.track[CURRENT_TRACK] = {}
		car.track[CURRENT_TRACK][car.row] = {}
		car.track[CURRENT_TRACK][car.row][car.col] = {}
	end
end

return functions
