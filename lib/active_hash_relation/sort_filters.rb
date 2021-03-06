module ActiveHashRelation::SortFilters
  def apply_sort(resource, params, model = nil)
    if model.columns.map(&:name).include?(params[:property])
      resource = resource.order(params[:property] => (params[:order] || :desc) )
    end

    return resource
  end
end
