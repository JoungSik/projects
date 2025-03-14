module ApplicationHelper
  def options_for_enum(model_class, enum)
    enum_hash = model_class.send(enum.to_s.pluralize)

    enum_hash.map do |key, _|
      [t("activerecord.attributes.#{model_class.to_s.downcase}.#{enum}.#{key}"), key]
    end
  end
end
