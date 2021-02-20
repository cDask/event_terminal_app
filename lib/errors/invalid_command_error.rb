
class InvalidCommandError < StandardError
  def initialize(msg="That command doesn't exists")
    super
  end
end