

car = require 'car'
track = require 'track'
cf = require 'commonfunctions'
inspect = require 'inspect'
fun = require 'functions'
enum = require 'enum'
Grid = require ("lib.jumper.grid") -- The grid class

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

end

function love.draw()

	track.draw(TRACKS[CURRENT_TRACK], TRACKSDATA[CURRENT_TRACK])
	
	car.draw()

end

function love.update()

	car.update()




end


