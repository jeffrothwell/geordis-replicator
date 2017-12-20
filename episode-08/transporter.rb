# The Transporter moves the glass around
# the ship and ingredients into the glass.
# It requires power to work properly.

class Transporter

  def initialize(enterprise)
    @enterprise = enterprise
    @power = false
    connect_to_power
  end

  def connect_to_power
    @power = @enterprise.reactor.on
  end

  def energize(obj, from, to)
    # binding.pry
    return unless @power
    # the following if code block never runs, the conditional returns false
    # we're asking too much of draw_power
    # going to drop it from 300 to 3, like it previous episodes
    if @enterprise.reactor.draw_power(3)
      to.contents << from.contents.delete(obj)
      return obj
    end
  end

end
