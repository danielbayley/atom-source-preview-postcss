[ postcss, config, valid ] = []

module.exports =
class PostCSSprovider

	fromGrammarName: 'PostCSS'
	fromScopeName: 'source.css.postcss'
	toScopeName: 'source.css'
#-------------------------------------------------------------------------------

	filter: (dependency) ->
		dependency in valid or
		dependency.startsWith 'postcss-' #.match /postcss/
		#console.log "#{config.name}: `require`d #{dependency}." if @debug
		# TODO dependency.match /^[import]/

	transform: (code, { filePath, sourceMap } = {}) ->
		postcss ?= require 'postcss'
		{config: {valid}} = config ?= require '../package.json' #__dirname
		#console.log "#{config.name}: #{valid}" if @debug

		options =
			#parser:
			#syntax:
			#from: filePath
			#to: 'preview.css' #post.css
			map: { inline: false, annotation: false } if sourceMap
				#prev: '[sl][ae]ss-css.map'

		# Determine PostCSS plugins
		project = atom.project.getPaths()[0]
		{devDependencies, dependencies} = require "#{project}/package.json"

		plugins = Object.keys devDependencies ? dependencies #? peerDependencies
			.filter @filter
			.map (plugin) -> require plugin

		postcss plugins
			.process code, options
			.then (preview) ->
				code: preview.css
				sourceMap: preview.map?.toString()
			#.catch (err) ->
