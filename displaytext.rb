# frozen_string_literal: true

# Used for Game class
module DisplayText
  def display_hash(hash)
    condensed_vals = []
    hash.each do |key, _|
      condensed_vals << format(hash, key, 9)
    end
    condensed_vals.join
  end

  def format(hash, key, size)
    initial_format = "#{key}: #{hash[key].join}"
    initial_format + (' ' * (size - initial_format.length))
  end
end
