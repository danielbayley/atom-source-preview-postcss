[ postcss, config, valid ] = plugins = []

module.exports =
class PostCSSprovider

	fromGrammarName: 'PostCSS'
	fromScopeName: 'source.css.postcss'
	toScopeName: 'source.css'
#-------------------------------------------------------------------------------

	filter: (dependencies) ->
		for plugin of dependencies #.concat devDependencies
			if plugin in valid or plugin.match /postcss/ #.startsWith 'postcss-'
				#console.log "#{config.name}: `required` #{plugin}" if @debug
				plugins.push require plugin
#-------------------------------------------------------------------------------

	transform: (code, { filePath, sourceMap } = {}) ->
		postcss ?= require 'postcss'
		{config: {valid}} = config ?= require '../package.json'
		#console.log "#{config.name}: #{valid}" if @debug

		# Determine PostCSS plugins
		project = atom.project.getPaths()[0]
		{dependencies, devDependencies} = require "#{project}/package.json"

		# Merge dependencies
		#for dep of devDependencies
			#if dep in valid or dep.match /postcss/ #.startsWith 'postcss-'
				#dependencies[dep] = devDependencies[dep]

		@filter dependencies
		@filter devDependencies unless plugins.length #Object.keys plugins

		options =
			#parser:
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
