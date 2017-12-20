# The Glass is where the ingredients will go and what's
# transported around the ship as the drink is made.
# When this is instatiated, it should set its temperature
# and setup a spot inside of itself to store the ingredients.

class Glass

  LUKE_WARM = 37

  def initialize
    @inside      = Location.new
    @temperature = LUKE_WARM
    @errors      = []
  end

  def inside
    @inside
  end

  def temperature
    @temperature
  end

  def temperature=(new_temperature)
    @temperature = new_temperature
  end

  def ingredients
    @inside.contents.map { |item| item.name }
  end

  # These methods are used by the main geordis-replicator.rb
  # program to see if the drink was correctly replicated.
  # When the Validator.new is run, @errors is populated with
  # the issues if the recipe isn't correct.
  def errors
    @errors
  end

  def errors=(new_errors)
    @errors = new_errors
  end

  def errors?
    @errors.size > 0
  end

  def valid?
    @errors.size == 0
  end

end
