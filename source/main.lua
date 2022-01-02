

car = require 'car'
track = require 'track'
cf = require 'commonfunctions'
inspect = require 'inspect'
fun = require 'functions'
runDijsktra = require 'lib.dijkstra'
grid = require 'lib.grid'

CURRENT_TRACK = 1
CELLSIZE = 40		-- width/height
CARS = {}
TRACKS = {}
TRACKSDATA = {}

function love.graphics.setRGBColor(r,g,b,a)
	r, g, b = r/255, g/255, b/255
	love.graphics.setColor(r,g,b,a)
end

function love.load()

	love.graphics.setBackgroundColor( 0, 0, 0, 1 )
		
	track.fetchTrack(CURRENT_TRACK)
	
	print("Current track:")
	track.print(TRACKS[CURRENT_TRACK])
	
	car.create(CURRENT_TRACK)
	
	
	-- cf.getDijkstraDistance(TRACKS[CURRENT_TRACK], CARS[1].row, CARS[1].col, TRACKSDATA[CURRENT_TRACK].stoprow, TRACKSDATA[CURRENT_TRACK].stopcol)
	
end

function love.draw()

	track.draw(TRACKS[CURRENT_TRACK], TRACKSDATA[CURRENT_TRACK])
	
	car.draw()

end


function love.update()

	car.update()




end


