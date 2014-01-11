module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    bower:
      install:
        options:
          targetDir: 'static'
          layout: 'byComponent'
          install: true
          verbose: false
          cleanTargetDir: false
          cleanBowerDir: false

    jade:
      tmpl:
        options:
          pretty: true

        files: [
          expand: true
          cwd: 'jade/'
          src: ['**/**.jade']
          dest: "tmpl"
          ext: '.tt'
          filter: (path) ->
            not path.match(/\/_parts\//)
        ]

    compass:
      dev:
        options:
          basePath: 'static'
          sassDir: 'sass'
          cssDir: 'css'
          imagesDir: 'img'
          javascriptsDir: 'js'
          noLineComments: true

    watch:
      jade:
        files: 'jade/**/**'
        tasks: ['jade']

      compass:
        files: 'static/sass/**/**'
        tasks: ['compass']

  [
    'grunt-contrib-jade'
    'grunt-contrib-watch'
    'grunt-contrib-compass'
    'grunt-bower-task'
  ].forEach grunt.loadNpmTasks

