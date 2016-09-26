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
	cell = Array.new(r*c)
	i=0;j=0;k=0
	for i in 0..9
		for j in 0..9
			cell[k] = world.populate(false,i,j)
			k+= 1
		end
	end
	i = 0
	while i < percent do
		x = SecureRandom.random_number (r-1)
		y = SecureRandom.random_number (c-1)
		cell[i] = world.populate(true,x,y)
		i+= 1
	end
	$grid.to_readable
	#print world.cells
	#sleep(5)
	world.tick!
	i = 0
	while i < r*c
		if cell[i].alive?
			$grid[cell[i].x,cell[i].y] = 1
		else
			$grid[cell[i].x,cell[i].y] = "."
		end
		i+= 1
	end
	print "\n\n\n"
	$grid.to_readable
	#world.cells.map { |e| print e.dead?; print " " }



