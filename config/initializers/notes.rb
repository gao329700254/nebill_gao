Rails.application.config.annotations.register_extensions('scss')   { |annotation| %r{//\s*(#{annotation}):?\s*(.*?)$} }
Rails.application.config.annotations.register_extensions('slim')   { |annotation| %r{/\s*(#{annotation}):?\s*(.*?)$} }
Rails.application.config.annotations.register_extensions('coffee') { |annotation|   /#\s*(#{annotation}):?\s*(.*?)$/ }
