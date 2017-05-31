class Message, :body
  attr_accessor :receiver, :sender
  def initialize( receiver, sender, body)
    # raise TypeError if ([receiver, sender].all? { |arg| arg.is_a?(Person) })
    @receiver = receiver
    @body = body[0...140]
    # raise TypeError unless body.is_a?(String)
    @sender = sender
  end

  def send!
    Twilio.send_email!
  end
end

class Person
end

class Twilio
  def self.send_email!
    fail
  end
end
