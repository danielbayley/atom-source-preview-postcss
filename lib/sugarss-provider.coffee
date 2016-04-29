[ postcss, sugarss, config, valid ] = plugins = []

module.exports =
class SugarSSprovider

	fromGrammarName: 'SugarSS' #PostCSS (SugarSS)
	fromScopeName: 'source.postcss' #source.css.sugarss
	toScopeName: 'source.css'
#-------------------------------------------------------------------------------

	filter: (dependencies) ->
		for plugin of dependencies
			if plugin in valid or plugin.match /postcss/ #.startsWith 'postcss-'
				plugins.push require plugin
#-------------------------------------------------------------------------------

	transform: (code, { filePath, sourceMap } = {}) ->
		postcss ?= require 'postcss'
		sugarss ?= require 'sugarss'
		{config: {valid}} = config ?= require '../package.json'

		# Determine PostCSS plugins
		project = atom.project.getPaths()[0]
		{dependencies, devDependencies} = require "#{project}/package.json"

		@filter dependencies
		@filter devDependencies unless plugins.length #Object.keys plugins

		options =
			parser: sugarss
			#syntax:
			#from: filePath
			#to: 'preview.css' #post.css
			map: { inline: false, annotation: false } if sourceMap
				#prev: '[sl][ae]ss-css.map'

		postcss plugins
			.process code, options
			.then (preview) ->
				{
					code: preview.css
					sourceMap: preview.map?.toString()
				}
