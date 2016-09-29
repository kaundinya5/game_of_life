	#!/usr/bin/ruby
require 'matrix'
require_relative 'gol_spec'

class Matrix
	public "[]=", :set_element, :set_component
	# Make matrix readable
	def  to_readable
		i = 0
		self.each do |number|
			print number.to_s + " "
			i+= 1
			if i == self.column_size
				print "\n"
				i = 0
			end
		end
	end
end

# Implementation of the program
require 'securerandom'
system("clear")
puts "Enter the size of the grid"
print "Rows = "
r = gets.chomp().to_i
print "Columns = "
c = gets.chomp().to_i
world = World.new(r,c)
#$grid.to_readable
print "Enter the percentage of the grid that you want to be populated: "
per = gets.chomp().to_i
percent = ((r * c) * per)/100
print "The number of cells to be populated is "; p percent
cell = []
i = 0
c.times do
	cell << Array.new(r)
end
while i < percent do
	x = SecureRandom.random_number (r-1)
	y = SecureRandom.random_number (c-1)
	cell[x][y] = world.populate(true,x,y)
	i+= 1
end

i=0;j=0;k=1
c.times do
	r.times do
		if(cell[i][j].is_a?(Cell))
			j+=1
			next
		else
			cell[i][j] = world.populate(false,i,j)
			j+= 1
		end
	
	end
	j=0
	i+= 1
end
puts "Press Enter"
a = gets.chomp()
system("clear")
$grid.to_readable
print "\nTick 0"
while 1 do
	world.tick!
	i = 0
	j = 0
	c.times do
		r.times do
			if cell[i][j].alive?
				$grid[cell[i][j].x,cell[i][j].y] = "."
			else
				$grid[cell[i][j].x,cell[i][j].y] = " "
			end
			j+= 1
		end
		j = 0
		i+= 1
	end
	sleep(1)
	system("clear")
	$grid.to_readable
	print "\nTick "; p k;
	k+= 1
end



