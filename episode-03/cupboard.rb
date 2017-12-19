# The Cupboard is where empty glasses are stored.
# When this is instatiated, it should put some empty
# glasses onto its shelf if it's working properly.

class Cupboard

  def initialize
    # binding.pry

    @shelf = Location.new
    stock_shelf
    # wesley_takes_glasses_for_a_science_project
  end

  def shelf
    @shelf
  end

  def stock_shelf
    5.times do
      @shelf.contents << Glass.new
    end
  end

  def find_glass
    @shelf.contents.find { |obj| obj.class == Glass }
  end

  def wesley_takes_glasses_for_a_science_project
    @shelf.contents.size.times { @shelf.contents.pop }
  end

end
