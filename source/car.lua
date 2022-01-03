local car = {}

local neighbourcells = {}	-- there are eight cells around the car. Get the cost for each.

function car.create(tracknumber)
	-- creates a car and places it on tracknumber

	mycar = {}
	mycar.index = #CARS + 1
	mycar.row = TRACKSDATA[tracknumber].startrow
	mycar.col = TRACKSDATA[tracknumber].startcol
	mycar.facing = TRACKSDATA[tracknumber].initialfacing		-- numpad directions
	mycar.speed = 0
	mycar.maxspeed = 0
	mycar.acel	= 0
	mycar.nextrow = nil
	mycar.nextcol = nil
	mycar.stepstaken = 0
	mycar.rcolour = love.math.random(0,255)
	mycar.gcolour = love.math.random(0,255)
	mycar.bcolour = love.math.random(0,255)

	mycar.explorerate = love.math.random(5,25)	-- explore vs exploit

	mycar.track = {}	-- records what it knows about each track
	mycar.track[CURRENT_TRACK] = {}
	fun.loadMemory(mycar)

	-- add the very first cell to it's memory
	mycar.track[CURRENT_TRACK][mycar.row][mycar.col] = cf.Findpath(TRACKS[CURRENT_TRACK], mycar.row, mycar.col, TRACKSDATA[CURRENT_TRACK].stoprow, TRACKSDATA[CURRENT_TRACK].stopcol)

	table.insert(CARS, mycar)

end

function car.draw()

	local carsize = 12

	for k, thiscar in pairs(CARS) do
		local x,y = fun.getXYFromRowCol(thiscar.row,thiscar.col)

		-- the x/y is the top left corner. Need to offset to get the centre
		x = x + (CELLSIZE / 2)
		y = y + (CELLSIZE / 2)

		love.graphics.setRGBColor(thiscar.rcolour,thiscar.gcolour,thiscar.bcolour,1)
		love.graphics.circle("fill", x, y, carsize)

	end
end

function moveCar(car)

	car.row = car.nextrow
	car.col = car.nextcol

	car.nextrow, car.nextcol = nil, nil

	-- print("car moved to " .. car.row, car.col)
	-- print("~~~~~~~~~~~~~~~~~~~")
	cf.sleep(1)

	car.stepstaken = car.stepstaken + 1
end

local function getNeighbourCells(car, mytrack)
	-- scans the cells around the car and populates distance informaation for each
	-- mytrack can be the real track or it could be what the car knowns about the track

	-- get the three best cells for car and track
	for row = car.row -1, car.row + 1 do
		neighbourcells[row] = {}
		for col = car.col -1, car.col +1 do
			if  mytrack[row] == nil then
				mytrack[row] = {}
				neighbourcells[row][col] = nil
			end
			if mytrack[row][col] == 5 then
				-- cell = wall. Do nothing
				neighbourcells[row][col] = 999
			elseif row == car.row and col == car.col then
				-- this is the same cell as the car. Do nothing
				neighbourcells[row][col] = 999
			else
				neighbourcells[row][col] = nil
				neighbourcells[row][col] = cf.round(cf.Findpath(mytrack, row, col, TRACKSDATA[CURRENT_TRACK].stoprow, TRACKSDATA[CURRENT_TRACK].stopcol),3)
			end
		end
	end
	assert(neighbourcells[car.row][car.col] == 999)
end

local function getNextCell(car)
	-- determines which row/col the car will move to


	-- peek at the real track table and get the three most legitimate tiles
	getNeighbourCells(car, TRACKS[CURRENT_TRACK])		-- populates the neighbourcells table

	-- out of all the neighbouring cells, get the three lowest distances
	local minrow1, mincol1, minvalue1 = nil, nil, math.huge
	local minrow2, mincol2, minvalue2 = nil, nil, math.huge
	local minrow3, mincol3, minvalue3 = nil, nil, math.huge
	for row = car.row -1, car.row + 1 do
		for col = car.col -1, car.col +1 do
			if neighbourcells[row][col] ~= nil then
				if neighbourcells[row][col] < minvalue1 then
					-- this is the lowest so far.
					-- capture it and move the rest down

					-- move min2 into min3 (destroying min3 in the process)
					minvalue3 = minvalue2
					minrow3 = minrow2
					mincol3 = mincol2

					-- move min1 into min2
					minvalue2 = minvalue1
					minrow2 = minrow1
					mincol2 = mincol1

					-- now capture the lowest value
					minvalue1 = neighbourcells[row][col]
					minrow1 = row
					mincol1 = col
				elseif neighbourcells[row][col] < minvalue2 then
					-- this is the 2nd lowest value so far
					-- move min2 into min3 (destroying min3 in the process)
					minvalue3 = minvalue2
					minrow3 = minrow2
					mincol3 = mincol2

					-- now capture the 2nd lowest value
					minvalue2 = neighbourcells[row][col]
					minrow2 = row
					mincol2 = col
				elseif neighbourcells[row][col] < minvalue3 then
					-- capture the 3nd lowest value
					minvalue3 = neighbourcells[row][col]
					minrow3 = row
					mincol3 = col
				end
			end
		end

	end

	-- print("++++")
	-- print("three real cells")
	-- print(minrow1,mincol1,minvalue1)
	-- print(minrow2,mincol2,minvalue2)
	-- print(minrow3,mincol3,minvalue3)

	local rndexplore = love.math.random(1,100)		-- check if exploring or exploiting
	if rndexplore <= car.explorerate then
		-- explore
	print("Exploring")
		local rndnum = love.math.random(1,3)
		if rndnum == 1 then
			car.nextrow = minrow1
			car.nextcol = mincol1
		elseif rndnum == 2 then
			car.nextrow = minrow2
			car.nextcol = mincol2
		elseif rndnum == 3 then
			car.nextrow = minrow3
			car.nextcol = mincol3
		end
	else
	-- if exploiting then peek at it's track memory to see what it knows, if any, then choose the best of those
	print("Exploiting what it knows")
		if car.track[CURRENT_TRACK][minrow1] == nil then
			car.track[CURRENT_TRACK][minrow1] = {}
		end

		if car.track[CURRENT_TRACK][minrow1][mincol1] ~= nil and car.track[CURRENT_TRACK][minrow1][mincol1] < car.track[CURRENT_TRACK][car.row][car.col] then
			car.nextrow = minrow1
			car.nextcol = mincol1
		elseif car.track[CURRENT_TRACK][minrow2][mincol2] ~= nil and car.track[CURRENT_TRACK][minrow2][mincol2] < car.track[CURRENT_TRACK][car.row][car.col]  then
			car.nextrow = minrow2
			car.nextcol = mincol2
		elseif car.track[CURRENT_TRACK][minrow3][mincol3] ~= nil  and car.track[CURRENT_TRACK][minrow3][mincol3] < car.track[CURRENT_TRACK][car.row][car.col]  then
			car.nextrow = minrow3
			car.nextcol = mincol3
		else
			-- all values are nil or it is at risk of moving backwards. It knows nothing. Go random
			print("It knows nothing so exploring")
			local rndnum = love.math.random(1,3)
			if rndnum == 1 then
				car.nextrow = minrow1
				car.nextcol = mincol1
			elseif rndnum == 2 then
				car.nextrow = minrow2
				car.nextcol = mincol2
			elseif rndnum == 3 then
				car.nextrow = minrow3
				car.nextcol = mincol3
			end
		end
	end
end

local function updateMemory(mycar)
	-- for each cell the car visits, record the distance
	-- to the finish line from that cell.
	-- this knowledge will be used in future races

	if mycar.track[CURRENT_TRACK][mycar.row] == nil then
		mycar.track[CURRENT_TRACK][mycar.row] = {}
	end
	mycar.track[CURRENT_TRACK][mycar.row][mycar.col] = cf.Findpath(TRACKS[CURRENT_TRACK], mycar.row, mycar.col, TRACKSDATA[CURRENT_TRACK].stoprow, TRACKSDATA[CURRENT_TRACK].stopcol)

	fun.saveMemory(mycar)

end

function car.update()

	if love.keyboard.isDown('n') then
		for k, thiscar in pairs(CARS) do
			if thiscar.nextrow == nil or thiscar.nextcol == nil then
				-- determine next destination
				getNextCell(thiscar)
			end
			assert(thiscar.nextrow ~= nil and thiscar.nextcol ~= nil)

			moveCar(thiscar)
			updateMemory(thiscar)

			if thiscar.row == TRACKSDATA[CURRENT_TRACK].stoprow and thiscar.col == TRACKSDATA[CURRENT_TRACK].stopcol then
				-- finished
				print("Steps taken = " .. thiscar.stepstaken)
				error()
			end
		end
	end


end

return car
