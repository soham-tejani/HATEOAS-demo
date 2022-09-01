# frozen_string_literal: true

require 'rails_helper'

module SwaggerSchemaHelpers
  def list_schema(items:)
    schema(
      type: :object,
      properties: {
        data: {
          type: :array,
          items:
        },
        meta: { '$ref': '#/components/schemas/listMeta' },
        links: { '$ref': '#/components/schemas/listLinks' }
      },
      required: %w[data meta links]
    )
  end

  def record_schema(data)
    schema(
      type: :object,
      properties: {
        data:
      },
      required: %w[data]
    )
  end

  def schema_attributes(required: {}, optional: {})
    properties = required.merge(optional).sort.to_h
    required_attributes = required.keys.map(&:to_s).sort

    config = {
      type: :object,
      properties:,
      additionalProperties: false
    }
    config[:required] = required_attributes if required_attributes.present?
    config
  end

  def jsonapi_response_schema(serializer, properties:, optional: [])
    required_attributes = serializer.attributes_to_serialize.keys.map(&:to_sym) - optional.map(&:to_sym)

    required_properties = required_attributes.index_with { |attr| properties.fetch(attr) }
    optional_properties = properties.except(*required_properties.keys)
    type = serializer.record_type.to_s

    {
      type: :object,
      properties: {
        id: { type: :string },
        type: { type: :string, enum: [type] },
        attributes: schema_attributes(required: required_properties, optional: optional_properties)
      },
      additionalProperties: false,
      required: %w[id type attributes]
    }
  end
end

RSpec.configure do |config|
  include SwaggerSchemaHelpers
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API Docs',
        version: 'v1',
        description: 'This is the API only rails app, and this is the doc for our APIs'
      },
      paths: {},
      servers: [
        {
          url: 'https://hateoas-demo.herokuapp.com/api/v1'
        }
      ],
      components: {
        securitySchemes: {
          Bearer: {
            description: 'Bearer Authentication',
            type: :apiKey,
            name: 'Authorization',
            in: :header
          }
        },
        parameters: {
          perPage: {
            in: 'query',
            name: 'perPage',
            required: false,
            description: 'Number of items per page',
            schema: {
              type: :integer,
              default: 10,
              minimum: 1,
              maximum: 100
            }
          },
          page: {
            in: 'query',
            name: 'page',
            required: false,
            description: 'Page number of a list of resources',
            schema: {
              type: :integer,
              minimum: 1,
              default: 1
            }
          }
        },
        schemas: {
          user: jsonapi_response_schema(
            UserSerializer,
            properties: {
              first_name: { type: :string },
              last_name: { type: :string },
              email: { type: :string }
            }
          ),
          listMeta: {
            description: 'Additional details for a list',
            type: :object,
            properties: {
              count: {
                description: 'Total count of list items',
                type: :integer
              }
            },
            required: %w[count]
          },
          listLinks: {
            type: :object,
            description: 'Pagination links',
            properties: {
              first: {
                description: 'First page URL',
                type: :string
              },
              self: {
                description: 'Current page URL',
                type: :string
              },
              last: {
                description: 'Last page URL',
                type: :string
              },
              prev: {
                description: 'Previous page URL',
                type: :string, nullable: true
              },
              next: {
                description: 'Next page URL',
                type: :string, nullable: true
              }
            },
            required: %w[first self last]
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end
