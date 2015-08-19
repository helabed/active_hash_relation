require "active_record/scope_names"
require "active_hash_relation/version"
require "active_hash_relation/helpers"
require "active_hash_relation/column_filters"
require "active_hash_relation/scope_filters"
require "active_hash_relation/sort_filters"
require "active_hash_relation/limit_filters"
require "active_hash_relation/association_filters"
require "active_hash_relation/filter_applier"

require "active_hash_relation/aggregation"

module ActiveHashRelation
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration
    yield(configuration)
  end

  def self.configuration
    @configuration ||= Configuration.new do
      self.has_filter_classes = false
    end
  end

  #def apply_filters(resource, params, include_associations: false, model: nil)
  # Hani added this, ruby 1.9.3 compatible (JRuby 1.7.20.1)
  def apply_filters(resource, params, opts = {})
    include_associations = opts[:include_associations] || false
    model                = opts[:model]                || nil
    FilterApplier.new(
      resource,
      params,
      include_associations: include_associations,
      model: model
    ).apply_filters
  end

  def aggregations(resource, params)
    Aggregation.new(resource, params).apply
  end

  class Configuration
    attr_accessor :has_filter_classes, :filter_class_prefix, :filter_class_suffix
  end
end
