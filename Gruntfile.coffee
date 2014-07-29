module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    "download-atom-shell":
      version: '0.14.3'
      outputDir: 'bin'

  grunt.loadNpmTasks 'grunt-download-atom-shell'
  grunt.registerTask 'install', 'download-atom-shell'
  grunt.registerTask 'default', '', [ 'install' ]
