class Replicator

  # When the Enterprise calls Replicator.new, this method executes.
  def initialize(enterprise)

    # Setup an accessor so we can access other parts of the Enterprise from this instance.
    @enterprise = enterprise

    # Setup the inside of the replicator. This is where the drink is made.
    @inside_replicator = Location.new

    # Setup the outside of the replicator. This is where the
    # final drink should end up for the character to consume.
    @plate = Location.new

    # Setup the power for the replicator.
    @power = false

    # Connect the power to the reactor (the reactor is the power source).
    connect_to_power
  end

  # This sets up an accessor to the replicator plate, so that in the main
  # geordis-replicator.rb program, we can see what's on the replicator plate (if anything)
  def plate
    @plate
  end

  def connect_to_power
    # In Ruby, nil and false are "falsey" and everything else is a "truthy",
    # including the number 0, empty arrays, and anything else (strings, classes, instances, etc.).
    # This should report back a "truthy" for the power to work.
    @power = @enterprise.reactor.on
  end

  # After the Enterprise is put together, this is the
  # key method responsible for creating the drink.
  # This is where your pry debugging should begin.
  # Put a `binding.pry` at the beginning of this method
  # and then manually execute each method to ensure
  # it returns what's expect.
  def replicate(recipe)

    # Setup an instance variable for the recipe
    # so that other methods can see what the recipe is
    @recipe = recipe

    # This transports a glass from the cupboard to inside the replicator.
    # If this method is successful, it will return the glass that was
    # transported and @inside_replicator will contain the glass
    # in its contents.
    retrieve_glass

    # Setup an instance variable to access the glass.
    @glass = @inside_replicator.contents.first

    # Transport each ingredient the recipe calls for
    # from the pantry to the glass.
    # If this method is successful, it should return
    # the ingredients the recipe has listed, and the glass
    # shoud contain the proper ingredients.

    # To retrieve the glass from inside the replicator, use:
    #   glass_inside_replicator
    # And then to see what's inside the glass, use:
    #   glass_inside_replicator.inside.contents
    transport_ingredients_to_glass

    # This methods mixes the ingredients in the glass around.
    # It returns nil, even if successful, but if you look at:
    #   glass_inside_replicator.inside.contents
    # then you may find the ingredients order has changed.
    # If it's successful, all the ingredients should still be in the glass.
    mix

    # This method adjusts the temperature of the contents in the glass.
    # If you read back `glass.temperature`, then it should be set
    # to the temperature the recipe calls for if this method executed properly.
    adjust_temperature

    # This method moves the glass from @inside_replicator to @plate
    # so that the character can pick it up and drink it.
    # If it's successful, glass_inside_replicator should be nil
    # and now @plate.contents should contain the glass at
    # the proper temperature and with the proper ingredients.
    transport_glass_to_replicator_plate
  end

  # This moves the glass from the cupboard to inside the replicator.
  def retrieve_glass
    @enterprise.transporter.energize(
      @enterprise.cupboard.find_glass,
      @enterprise.cupboard.shelf,
      @inside_replicator
    )
  end

  def glass_inside_replicator
    # This reaches into the @inside_replicator location instance
    # and then into the `contents` of that instance, which is an array
    # and obtains the first element of that array.
    @inside_replicator.contents.first
  end

  # This transports ingredients into the glass.
  def transport_ingredients_to_glass

    # Abort if there is no glass inside the replicator or no power.
    return unless glass_inside_replicator && @power

    # Go through recipe and transport each ingredient
    # from pantry to glass, one by one.
    @recipe.ingredients.each do |ingredient_name|
      @enterprise.transporter.energize(
        @enterprise.pantry.find_ingredient(ingredient_name),
        @enterprise.pantry.shelf,
        glass_inside_replicator.inside
      )
    end
  end

  # This mixes the ingredients around inside the replicator.
  def mix

    # Abort if there is no glass inside the replicator or no power.
    return unless glass_inside_replicator && @power

    # mouse_chews_through_power_cord

    # Draw power if possible and then mix ingredients around.
    if @enterprise.reactor.draw_power(3)
      glass_inside_replicator.inside.contents.shuffle!.compact!
    end
  end

  # This adjusts the temperature of the glass to
  # what the recipes calls for.
  def adjust_temperature

    # Abort if there is no glass inside the replicator or no power.
    return unless glass_inside_replicator && @power

    # Transport glass to the reactor where the temperature adjustment will take place.
    # If successful, @enterprise.reactor.core will now contain the glass
    # and @inside_replicator will no longer contain the glass.
    transport_glass_to_reactor


    # Setup variables for temperature adjustment loop
    desired_temperature         = @recipe.temperature
    maximum_adjustments_allowed = 50
    number_of_adjustments       = 0

    # Keep adjusting temperature until desired temperature is reached
    # or too many attempts have been made to adjust temperature.
    # If successful, @glass will be set to the proper
    # recipe temperature after the loop has finished.
    while @glass.temperature != desired_temperature &&
          number_of_adjustments <= maximum_adjustments_allowed

      if @glass.temperature > desired_temperature
        @enterprise.reactor.cool_items_in_core
      elsif @glass.temperature < desired_temperature
        @enterprise.reactor.heat_items_in_core
      end

      number_of_adjustments += 1

    end

    # Transport glass from reactor back to inside the replicator.
    # If successful, @enterprise.reactor.core will now be empty
    # and @inside_replicator will once again contain the glass.
    transport_glass_from_reactor

  end

  def transport_glass_to_reactor
    @enterprise.transporter.energize(
      glass_inside_replicator,
      @inside_replicator,
      @enterprise.reactor.core
    )
  end

  def transport_glass_from_reactor
    @enterprise.transporter.energize(
      @glass,
      @enterprise.reactor.core,
      @inside_replicator
    )
  end

  def transport_glass_to_replicator_plate
    @enterprise.transporter.energize(
      glass_inside_replicator,
      @inside_replicator,
      @plate
    )
  end

  def mouse_chews_through_power_cord
    @power = false
  end

end
