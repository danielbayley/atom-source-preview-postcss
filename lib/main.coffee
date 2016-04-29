PostCSSprovider = require './postcss-provider'
SugarSSprovider = require './sugarss-provider'

module.exports =

	activate: ->
		@postcssProvider = new PostCSSprovider
		@sugarssProvider = new SugarSSprovider

	deactivate: -> @postcssProvider = @sugarssProvider = null

	provide: -> [ @postcssProvider, @sugarssProvider ]
