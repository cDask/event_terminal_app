class InvalidTalkInput < StandardError
  def initialize(msg='Invalid input for talk')
    super
  end
end