class Events
  attr_accessor :events
  
  def initialize
    @events = {}
  end


  def add_event(title)
    @events[title] = {}
  end
  
    
    
end