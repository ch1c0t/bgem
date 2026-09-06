class ::String
  def to_snake_case
    self
      .split(/([A-Z][a-z]+)/)
      .delete_if(&:empty?)
      .map(&:downcase)
      .join('_')
  end
end
