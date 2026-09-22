class ::String
  def to_snake_case
    self
      .split(/([A-Z][a-z]+)/)
      .delete_if(&:empty?)
      .map(&:downcase)
      .join('_')
  end

  def to_pascal_case
    self
      .split('_')
      .map(&:capitalize)
      .join
  end

  def ending_with_newline
    end_with?("\n") ? self : "#{self}\n"
  end
end
