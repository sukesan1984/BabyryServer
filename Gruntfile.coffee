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
          ext: '.tx'
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

    coffee:
      dev:
        options:
          sourceMap: true
        expand: true
        cwd: 'static/coffee'
        src: ['**/**.coffee']
        dest: 'static/js'
        ext: '.js'

    watch:
      jade:
        files: 'jade/**/**'
        tasks: ['jade']

      compass:
        files: 'static/sass/**/**'
        tasks: ['compass']

      coffee:
        files: 'static/coffee/**/**'
        tasks: ['coffee']

  [
    'grunt-contrib-jade'
    'grunt-contrib-watch'
    'grunt-contrib-compass'
    'grunt-contrib-coffee'
    'grunt-bower-task'
  ].forEach grunt.loadNpmTasks

