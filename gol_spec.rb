require 'rspec'
require "matrix"
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :should
  end
end

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

class Cell
  attr_accessor :x, :y, :world, :alive,:marked,:modified
  #@convert_according_to_mark = {:stay_dead => Proc.new{|cell| }, :turn_alive => Proc.new {|cell| be_live!} , :stay_alive => Proc.new{|cell| }, :turn_dead => Proc.new{|cell| die!} }
  def initialize(world,alive=true,x=0,y=0)
    @world = world
    @x = x
    @y = y
    @alive = alive
    @marked = false
    @modified = false
    world.cells << self
    if @alive
      $grid[@x,@y] = "."
    else
      $grid[@x,@y] = " "
    end
  end 

  def die!
    @alive=false
    @neighbours-= [self]
    self
  end

  def dead?
    !@alive
  end
  
  def alive?
    @alive
  end
    
  def be_live!
    @alive=true
    @neighbours+= [self]
    self
  end
  
  def neighbours
    @neighbours = []
    world.cells.each do |cell|
      #Detecting the neighbours
        #North
        if self.x == cell.x && self.y == cell.y + 1 && cell.alive? 
          @neighbours << cell
        end

        #North East
        if self.x == cell.x + 1 && self.y == cell.y + 1 && cell.alive?
          @neighbours << cell
        end

        #North West
        if self.x == cell.x - 1 && self.y == cell.y + 1 && cell.alive?
          @neighbours << cell
        end

        #South
        if self.x == cell.x && self.y == cell.y - 1 && cell.alive?
          @neighbours << cell
        end

        #South West
        if self.x == cell.x - 1 && self.y == cell.y - 1 && cell.alive?
          @neighbours << cell
        end

        #South East
        if self.x == cell.x + 1 && self.y == cell.y - 1 && cell.alive?
          @neighbours << cell
        end

        #East
        if self.x == cell.x - 1 && self.y == cell.y && cell.alive?
          @neighbours << cell
        end

        #West
        if self.x == cell.x + 1 && self.y == cell.y && cell.alive?
          @neighbours << cell
        end
    end
    @neighbours
  end

  def spawns_at(relative_x,relative_y,alive=true)
    #if relative_x.abs <= 1 && relative_y.abs <= 1
      Cell.new(world,alive,relative_x,relative_y)
    #else
      #false
    #end
  end
end

class World
  attr_accessor :cells,:all_cells

  def initialize(rows,column)
    @cells = []
    #@all_cells = []
    $grid = Matrix.build(rows,column) {|row,col| "."}
  end

  def populate(alive=true,x=0,y=0)
    cell = Cell.new(self,alive,x,y)
    cell
  end

  def tick!
   # ObjectSpace.each_object(Cell) do |cell|
   cells.each do |cell|
      if cell.neighbours.count < 2 && cell.alive?
        cell.marked = false
        cell.modified = true   
      elsif cell.neighbours.count > 3 && cell.alive?
        cell.marked = false
        cell.modified = true
      elsif cell.neighbours.count == 3 && cell.dead?
        cell.marked = true
        cell.modified = true
      elsif (cell.neighbours.count == 2 || cell.neighbours.count == 3) && cell.alive?
        cell.marked = true
      end
    end

    cells.each do |cell|
      if !cell.marked && cell.modified && cell.alive?
        cell.die!
      elsif cell.marked && cell.modified && cell.dead?
        cell.be_live!
      end
    end
        
  end
end
describe 'Game of Life' do

  let (:world) { World.new(10,10) }

  context "Cell utility methods" do
     subject {world.populate()}

     it "Spwans relative to" do
      cell = subject.spawns_at(4,2)
      cell.is_a?(Cell).should be true
      cell.x = 4
      cell.y = 2
      cell.world.should == subject.world
    end

    it "Detects a neighbour to the north" do
      cell = subject.spawns_at(0,1)
      subject.neighbours.count == 1
    end

    it "Detects a neighbour to the north east" do
      cell = subject.spawns_at(1,1)
      subject.neighbours.count == 1
    end

    it "Detects a neigbhour to the north west" do
      cell = subject.spawns_at(-1,1)
      subject.neighbours.count == 1
    end

    it "Detects a neighbour to the south" do
      cell = subject.spawns_at(0,-1)
      subject.neighbours.count == 1
    end

    it "Detects a neighbour to the south east" do
      cell = subject.spawns_at(1,-1)
      subject.neighbours.count == 1
    end

    it "Detects a neighbour to the south west" do
      cell = subject.spawns_at(-1,-1)
      subject.neighbours.count == 1
    end

    it "Detects a neighbour to the east" do
      cell = subject.spawns_at(1,0)
      subject.neighbours.count == 1
    end

    it "Detects a neighbour to the west" do
      cell = subject.spawns_at(-1,0)
      subject.neighbours.count == 1
    end
    
    it "Dies" do
      subject.die!
      subject.alive.should be false
    end
  end
  
  it "Rule 1: Any live cell with fewer than two live neighbours dies, as if caused by under-population." do
    world = World.new(10,10)
    cell = world.populate()
    new_cell = cell.spawns_at(2,0)
    world.tick!
    cell.should be_dead
  end

  it "Rule 2: Any live cell with two or three live neighbours lives on to the next generation." do
    world = World.new(10,10)
    cell = world.populate()
    new_neighbour = cell.spawns_at(0,-1)
    new_neighbour1 = cell.spawns_at(-1,0)
    world.tick!
    cell.should be_alive
    cell1 = world.populate(true,5,5)
    new_neighbour = cell1.spawns_at(5,4)
    new_neighbour1 = cell1.spawns_at(5,6)
    cell_neighbour3 = cell1.spawns_at(4,5)
    world.tick!
    cell1.should be_alive
  end

  it "Rule 3: Any live cell with more than three live neighbours dies, as if by over-population." do
    world = World.new(10,10)
    cell = world.populate()
    cell_neighbour = cell.spawns_at(1,0)
    cell_neighbour1 = cell.spawns_at(-1,0)
    cell_neighbour2 = cell.spawns_at(1,1)
    cell_neighbour3 = cell.spawns_at(-1,0)
    world.tick!
    cell.should be_dead
  end
  it "Rule 4: Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction." do
    world = World.new(10,10)
    cell = world.populate(false)
    cell.should be_dead
    cell_neighbour = cell.spawns_at(1,0)
    cell_neighbour1 = cell.spawns_at(-1,0)
    cell_neighbour2 = cell.spawns_at(1,1)
    world.tick!
    cell.should be_alive
  end
  it "Sample test to test if program is working fine" do
    world = World.new(10,10)
    cell = world.populate()
    cell_neighbour = cell.spawns_at(0,1)
    cell_neighbour1 = cell.spawns_at(0,2)
    cell_neighbour2 = cell.spawns_at(-1,1,false)
    cell_neighbour2 = cell.spawns_at(1,1,false)
    world.tick!
    cell.should be_dead
    cell_neighbour.should be_alive
    cell_neighbour1.should be_dead
    world.tick!
    cell.should be_alive
    cell_neighbour.should be_alive
    cell_neighbour1.should be_alive
    world.tick!
    cell.should be_dead
    cell_neighbour.should be_alive
    cell_neighbour1.should be_dead
    world.tick!
    cell.should be_alive
    cell_neighbour.should be_alive
    cell_neighbour1.should be_alive
    world.tick!
    cell.should be_dead
    cell_neighbour.should be_alive
    cell_neighbour1.should be_dead
    
  end

end 