module DataMapper
  module Associations
    class Relationship

      attr_reader :name, :repository_name, :options

      def child_key
        @child_key ||= begin
          model_properties = child_model.properties(@repository_name)

          child_key = parent_key.zip(@child_properties || []).map do |parent_property,property_name|
            # TODO: use something similar to DM::NamingConventions to determine the property name
            property_name ||= "#{@name}_#{parent_property.name}".to_sym
            model_properties[property_name] || child_model.property(property_name, parent_property.type)
          end

          PropertySet.new(child_key)
        end
      end

      def parent_key
        @parent_key ||= begin
          model_properties = parent_model.properties(@repository_name)

          parent_key = if @parent_properties
            model_properties.slice(*@parent_properties)
          else
            model_properties.key
          end

          PropertySet.new(parent_key)
        end
      end

      def get_children(repository, parent)
        repository.all(child_model, child_key.to_query(parent_key.get(parent)))
      end

      def get_parent(repository, child)
        repository.first(parent_model, parent_key.to_query(child_key.get(child)))
      end

      def attach_parent(child, parent)
        child_key.set(child, parent && parent_key.get(parent))
      end

      def parent_model
        find_const(@parent_model_name)
      end

      def child_model
        find_const(@child_model_name)
      end

      private

      # +child_model_name and child_properties refers to the FK, parent_model_name
      # and parent_properties refer to the PK.  For more information:
      # http://edocs.bea.com/kodo/docs41/full/html/jdo_overview_mapping_join.html
      # I wash my hands of it!
      def initialize(name, repository_name, child_model_name, parent_model_name, options = {}, &loader)
        raise ArgumentError, "+name+ should be a Symbol, but was #{name.class}", caller                                unless Symbol === name
        raise ArgumentError, "+repository_name+ must be a Symbol, but was #{repository_name.class}", caller            unless Symbol === repository_name
        raise ArgumentError, "+child_model_name+ must be a String, but was #{child_model_name.class}", caller          unless String === child_model_name
        raise ArgumentError, "+parent_model_name+ must be a String, but was #{parent_model_name.class}", caller        unless String === parent_model_name

        if child_properties = options[:child_key]
          raise ArgumentError, "+options[:child_key]+ must be an Array or nil, but was #{child_properties.class}", caller unless Array === child_properties
        end

        if parent_properties = options[:parent_key]
          raise ArgumentError, "+parent_properties+ must be an Array or nil, but was #{parent_properties.class}", caller unless Array === parent_properties
        end

        @name              = name
        @repository_name   = repository_name
        @child_model_name  = child_model_name
        @child_properties  = child_properties   # may be nil
        @parent_model_name = parent_model_name
        @parent_properties = parent_properties  # may be nil
        @loader            = loader
      end
    end # class Relationship
  end # module Associations
end # module DataMapper
