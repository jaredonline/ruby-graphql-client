require 'rubygems'
require 'active_support/inflector'

module GraphqlClient
  module Errors
    class NotImplementedError < StandardError; end
  end

  class Record
    class << self
      def all(options = {})
        init_fields()
        options = default_options().merge({
          _name: model_name.downcase.pluralize,
        }).merge(options)
        QueryProxy.new options
      end

      def find(id, options = {})
        init_fields()
        options = default_options().merge({
          _name: model_name.downcase,
          _args: {
            id: id
          }
        }).merge(options)
        QueryProxy.new options
      end

      protected
      def model_name
        self.name
      end

      def graphql_fields(*fields)
        init_fields()
        fields.each do |field|
          @fields.push(field)
        end
      end

      private
      def init_fields
        if @fields.nil?
          @fields = []
        end
      end

      def default_options
        {
          _model_name: model_name,
          _name: model_name.downcase.pluralize,
          fields: @fields
        }
      end
    end
  end

  class RequestProxy
    attr_accessor :model_name, :name, :fields, :args

    def initialize(options = {})
      options = {
        :fields => [],
        :_args => {},
      }.merge(options)

      self.model_name = options[:_model_name]
      self.name = options[:_name]
      self.fields = options[:fields]
      self.args = options[:_args]
    end

    def query
      f_fields = fields.join(",")
      f_args = format_args()
      "#{type} #{model_name}Query { #{name}: #{name}#{f_args} { #{f_fields} } }"
    end

    private
    def format_args
      if args.keys.count > 0
        f_args = args.inject([]) do |arg_list, (key, value)|
          arg_list.push("#{key}:#{value}")
        end.join(",")

        return "(#{f_args})"
      end
    end

    def type
      raise NotImplementedError, "#type must be implemented on children of RequestProxy"
    end
  end

  class MutationProxy < RequestProxy
    private
    def type
      "mutation"
    end
  end

  class QueryProxy < RequestProxy
    private
    def type
      "query"
    end
  end

  class Request
  end
end
