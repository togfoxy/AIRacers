local track = {}

function track.print(track)
	-- prints the provided track to the console
	
	if track == nil then
		print("track is empty (nil)")
	else
		for row = 1, #track do
			local str = ""
			for col = 1, #track[row] do
				str = str .. track[row][col] .. " "
			end
			print(str)
		end	
	end
end

function track.draw(track, trackdata)
	-- draw the requested track
	-- track is the track map
	-- trackdata is the track data
		
	for row = 1, #track do
		for col = 1, #track[row] do
			x, y = fun.getXYFromRowCol(row,col)
			
			if track[row][col] == 1 then
				-- draw a black outline
				love.graphics.setColor(0,0,0,1)
				love.graphics.rectangle("line", x,y,CELLSIZE,CELLSIZE)
			
				-- now prep for the fill
				love.graphics.setRGBColor(155,147,147,1)
			else
				love.graphics.setRGBColor(0,153,0,1)
			end
						
			love.graphics.rectangle("fill", x,y,CELLSIZE,CELLSIZE)
			
			if row == trackdata.startrow and col == trackdata.startcol then
				-- starting cell
				love.graphics.setColor(1,1,1,1)
				love.graphics.rectangle("fill", x, y, CELLSIZE, CELLSIZE)
			end
			if row == trackdata.stoprow and col == trackdata.stopcol then
				-- stopping cell
				love.graphics.setColor(51/255,1,1,1)
				love.graphics.rectangle("fill", x, y, CELLSIZE, CELLSIZE)
			end			
		end
	end
end

function track.fetchTrack(tracknumber)
	-- put the requested track into memory into the correct slot
	-- updates the global variable 'TRACKS'
		
	local mymap = {}
	if tracknumber == 1 then
		mymap = {
			{5,5,5,5,5,5,5,5,5,5},
			{5,1,1,1,1,1,1,1,5,5},
			{5,1,1,1,1,1,1,1,1,5},
			{5,5,5,5,5,5,5,1,1,5},
			{5,1,1,1,1,5,5,1,1,5},
			{5,1,1,1,1,1,1,1,1,5},
			{5,1,1,5,5,5,5,5,5,5},
			{5,1,1,1,1,1,1,1,1,5},
			{5,1,1,1,1,1,1,1,1,5},
			{5,5,5,5,5,5,5,5,5,5},
			{5,5,5,5,5,5,5,5,5,5},
		}	
		TRACKSDATA[tracknumber] = {}
		TRACKSDATA[tracknumber].startrow = 2
		TRACKSDATA[tracknumber].startcol = 5
		TRACKSDATA[tracknumber].stoprow = 9
		TRACKSDATA[tracknumber].stopcol = 9
		TRACKSDATA[tracknumber].initialfacing = 6	-- uses numpad directions
	end
	TRACKS[tracknumber] = cf.deepcopy(mymap)
end

return track