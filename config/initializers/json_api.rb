require 'active_model_serializers/register_jsonapi_renderer'
# Valid adapters are: ["attributes", "json", "json_api"])
ActiveModelSerializers.config.adapter = :json