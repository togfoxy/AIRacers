functions = {}

function functions.getXYFromRowCol(row,col)
	-- converts a row/col into a y/x pair for drawing to screen
	-- returns x, y (not y/x)
	local x,y
	x = 10 + (col * CELLSIZE)
	y = 10 + (row * CELLSIZE)	
	return x, y
end

	




return functions