class SpeakerAlreadyExists < StandardError
  def initialize(msg='That speaker already exists')
    super
  end
end