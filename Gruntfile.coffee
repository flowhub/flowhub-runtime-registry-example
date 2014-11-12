module.exports = ->
  # Project configuration
  @initConfig
    pkg: @file.readJSON 'package.json'

    # BDD tests on Node.js
    cafemocha:
      nodejs:
        src: ['spec/*.coffee']
        options:
          reporter: 'spec'

    # Coding standards
    coffeelint:
      root:
        files:
          src: ['*.coffee']
        options:
          max_line_length:
            value: 80
            level: 'warn'

  # Grunt plugins used for testing
  @loadNpmTasks 'grunt-cafe-mocha'
  @loadNpmTasks 'grunt-coffeelint'

  # Our local tasks
  @registerTask 'test', ['coffeelint', 'cafemocha']
  @registerTask 'default', ['test']

