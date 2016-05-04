[ postcss, sugarss, config, valid ] = []

module.exports =
class SugarSSprovider

	fromGrammarName: 'SugarSS' #PostCSS (SugarSS)
	fromScopeName: 'source.postcss' #source.css.sugarss
	toScopeName: 'source.css'
#-------------------------------------------------------------------------------

	filter: (dependency) ->
		dependency in valid or
		dependency.startsWith 'postcss-'

	transform: (code, { filePath, sourceMap } = {}) ->
		postcss ?= require 'postcss'
		sugarss ?= require 'sugarss'
		{config: {valid}} = config ?= require '../package.json'

		options =
			parser: sugarss
			map: { inline: false, annotation: false } if sourceMap

		# Determine PostCSS plugins
		project = atom.project.getPaths()[0]
		{devDependencies, dependencies} = require "#{project}/package.json"

		plugins = Object.keys devDependencies ? dependencies
			.filter @filter
			.map (plugin) -> require plugin

		postcss plugins
			.process code, options
			.then (preview) ->
				code: preview.css
				sourceMap: preview.map?.toString()
