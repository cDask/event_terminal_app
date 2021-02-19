class EventAlreadyExists < StandardError
  def initialize(msg="That event already exists")
    super
  end
end