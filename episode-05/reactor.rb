# The Reactor is what powers the ship.
# It uses dilithium crystals as its fuel.
# If it runs out of dilithium crystals, the power is turned off.
# The Replicator and Transporter both rely on the
# Reactor for power.

# It's also responsbile for heating
# and cooling the glass.

# If it's working properly, when it's instantiated
# the power should be turned on and it should be
# stocked with @dilithium_crystals

class Reactor

  def initialize(enterprise)
    @enterprise         = enterprise
    @core               = Location.new
    @on                 = false
    @dilithium_crystals = 0
    stock
    turn_on
  end

  def core
    @core
  end

  def on
    @on
  end

  def stock
    @dilithium_crystals += 100
  end

  def draw_power(amount = 1)
    amount.times do
      return false if off?
      drain_power
    end
  end

  def drain_power
    @dilithium_crystals -= 1 if on?
    turn_off if @dilithium_crystals <= 0
  end

  def turn_on
    @on = true if @dilithium_crystals > 0
  end

  def turn_off
    @on = false
  end

  def on?
    @on
  end

  def off?
    !@on
  end

  def datas_cat_eats_dilithium_crystals
    @dilithium_crystals -= 50
  end

  def heat_items_in_core
    @core.contents.each do |item|
      # datas_cat_eats_dilithium_crystals
      item.temperature += 1 if draw_power
    end
  end

  def cool_items_in_core
    @core.contents.each do |item|
      item.temperature -= 1 if draw_power(2)
    end
  end

end
