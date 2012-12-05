Slim::Engine.set_default_options :shortcut => {'&' => 'input type', '#' => 'id', '.' => 'class'}
Slim::EmbeddedEngine.default_options[:markdown] = {:auto_ids => false}