module ActiveHashRelation::AssociationFilters
  #def filter_associations(resource, params, model: nil)
  # Hani added this, ruby 1.9.3 compatible (JRuby 1.7.20.1)
  def filter_associations(resource, params, opts = {})
    model = opts[:model] || nil

    unless model
      model = model_class_name(resource)
    end

    model.reflect_on_all_associations.map(&:name).each do |association|
      if params[association]
        association_name = association.to_s.titleize.split.join
        if self.configuration.has_filter_classes
          puts self.filter_class(association_name)
          association_filters = self.filter_class(association_name).new(
            association_name.singularize.constantize.all,
            params[association]
          ).apply_filters
        else
          association_filters = ActiveHashRelation::FilterApplier.new(
            association_name.singularize.constantize.all,
            params[association],
            include_associations: true
          ).apply_filters
        end
        resource = resource.joins(association).merge(association_filters)
      end
    end

    return resource
  end
end
