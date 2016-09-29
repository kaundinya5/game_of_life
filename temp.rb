#!/usr/bin/ruby
require 'matrix'
require_relative 'gol_spec'

class Matrix
	public "[]=", :set_element, :set_component
	# Make matrix readable
	def  to_readable
		i = 0
		self.each do |number|
			print number.to_s + "\t"
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
c.times do 
	cell << Array.new(r)
end
i=0;j=0;k=0
cell[2][4] = world.populate(true,2,4)
cell[3][4] = world.populate(true,3,4)
#cell[2][4] = world.populate(true,2,4)
cell[4][4] = world.populate(true,4,4)
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
#$grid.to_readable 

=begin
cell[3][5] = cell[0][0].spawns_at(3,3,false)
cell[3][5] = cell[0][0].spawns_at(3,5,false)
cell[2][3] = cell[0][0].spawns_at(2,3,false)
cell[2][5] = cell[0][0].spawns_at(2,5,false)
cell[4][3] = cell[0][0].spawns_at(4,3,false)
cell[4][5] = cell[0][0].spawns_at(4,5,false)
=end
puts "Press Enter"
a = gets.chomp()
system("clear")
$grid.to_readable

print cell[2][4].neighbours.count
print cell[3][4].neighbours.count
#print cell[2][4].neighbours.count
print cell[4][4].neighbours.count
sleep(2)
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
	    i+=1
	end
	system("clear")
	#print "\n\n"
	$grid.to_readable
	print cell[2][4].neighbours.count
	print cell[3][4].neighbours.count
	#print cell[2][4].neighbours.count
	print cell[4][4].neighbours.count
	sleep(2) 
end