require "pry"
# The Transporter moves the glass around
# the ship and ingredients into the glass.
# It requires power to work properly.

class Transporter

  def initialize(enterprise)
    @enterprise = enterprise
    @power = false
    connect_to_power
    # obriens_repairs_transporter
  end

  def connect_to_power
    @power = @enterprise.reactor.on
  end

  def obriens_repairs_transporter
    @power = false
  end

  def energize(obj, from, to)
    # binding.pry
    return unless @power

    if @enterprise.reactor.draw_power(3)
      to.contents << from.contents.delete(obj)
      return obj
    end
  end

end
