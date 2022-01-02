local car = {}

function car.create(tracknumber)
	-- creates a car and places it on tracknumber

	mycar = {}
	mycar.row = TRACKSDATA[tracknumber].startrow
	mycar.col = TRACKSDATA[tracknumber].startcol
	mycar.facing = TRACKSDATA[tracknumber].initialfacing		-- numpad directions
	mycar.speed = 0
	mycar.maxspeed = 0
	mycar.acel	= 0
	mycar.nextrow = nil
	mycar.nextcol = nil
	mycar.rcolour = love.math.random(0,255)
	mycar.gcolour = love.math.random(0,255)
	mycar.bcolour = love.math.random(0,255)
	
	mycar.explorerate = love.math.random(1,25)	-- explore vs exploit
	
	mycar.track = {}	-- records what it knows about each track
	
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
	
print("car moved to " .. car.row, car.col)
print("~~~~~~~~~~~~~~~~~~~")
	cf.sleep(1)
end

local function getNextCell(car)
	-- determines which row/col the car
	-- will move to next
	
	-- get the three best cells
	local neighbourcells = {}	-- there are eight cells around the car. Get the cost for each.
	
	
track.print(TRACKS[CURRENT_TRACK])

	for row = car.row -1, car.row + 1 do
		neighbourcells[row] = {}
		for col = car.col -1, car.col +1 do

			if TRACKS[CURRENT_TRACK][row][col] == 5 then
				-- cell = wall. Do nothing
			elseif row == car.row and col == car.col then
				-- this is the same cell as the car. Do nothing
				neighbourcells[row][col] = nil
			else
				neighbourcells[row][col] = nil
				neighbourcells[row][col] = cf.Findpath(TRACKS[CURRENT_TRACK], row, col, TRACKSDATA[CURRENT_TRACK].stoprow, TRACKSDATA[CURRENT_TRACK].stopcol)
			end
		end
	end
	
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
					mincol2 = minrow1
					
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
	
	-- print(minrow1,mincol1,minvalue1)
	-- print(minrow2,mincol2,minvalue2)
	-- print(minrow3,mincol3,minvalue3)
	
	car.nextrow = minrow1
	car.nextcol = mincol1
	
end

function car.updateMemory()
	-- for each cell the car visits, record the distance
	-- to the finish line from that cell.
	-- this knowledge will be used in future races




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
		
		
		end
	end


end

return car
