# Please note, that [ ..., ..., function ] syntax is needed
# since AngularJS won't be able to inject variables when minified.
# You can also restrict angularjs injection keywords in
# configuration file and skip this.
MainController = ['$scope', ($scope) ->
  $scope.keydowns = []
  $scope.keyups = []
  $scope.times = []
  $scope.pauses = []
  $scope.timeData = {}
  $scope.lastTimeData = {}
  $scope.keyword = ""
  $scope.history = []


  $scope.calculateTimes = ->
    if $scope.keydowns.length ==
    $scope.keyups.length
      
      for i in [0..$scope.keydowns.length-1]
        pressed = $scope.keyups[i] - $scope.keydowns[i]
        $scope.times[i] = pressed

      if $scope.keydowns.length > 1
        for i in [0..$scope.keydowns.length-2]
          pause = $scope.keydowns[i+1] - $scope.keyups[i]
          $scope.pauses[i] = pause

      $scope.$apply()


  $scope.formatTimes = (x) ->
    if x.length > 0
      (i + "ms" for i in x).join(" ")

  $scope.disableLogging = ->
    logging = false
    $scope.disableInput()

    $('#main').unbind('keydown')
    $('#main').unbind('keyup')

  $scope.draw = ->
    if not $scope.keyword
      return
    $scope.calculateTimes()
    if $scope.previousKeyword == $scope.keyword
      wc = $scope.wordCount
      if wc < 10
        $scope.wordCount += 1
        $scope.history.push
          times: $scope.times
          pauses: $scope.pauses

        times_mapped = $scope.history
          .map (el,idx) ->
            el.times

        for i in [0..times_mapped[0].length-1]
          sum = ( d[i] for d in times_mapped).reduce (prev, next) -> prev + next
          $scope.timeData['times'][i] = sum/(times_mapped.length)

        pauses_mapped = []
        for i in $scope.history
          if i.pauses
            pauses_mapped.push(i.pauses)



        for i in [0..pauses_mapped[0].length-1]
          sum = ( d[i] for d in pauses_mapped).reduce (prev, next) ->
            prev + next
          $scope.timeData['pauses'][i] = sum/(pauses_mapped.length)

      else
        $scope.persisted = true
      if $scope.wordCount >= 10
        $scope.persisted = true

      

      $scope.lastTimeData['times'] = $scope.times
      $scope.lastTimeData['pauses'] = $scope.pauses
      $scope.lastTimeData['keys'] = $scope.keyword.split("")
    else
      $scope.wordCount = 1
      $scope.previousKeyword = $scope.keyword
      $scope.lastTimeData['times'] = $scope.times
      $scope.lastTimeData['pauses'] = $scope.pauses
      $scope.lastTimeData['keys'] = $scope.keyword.split("")
      $scope.timeData['times'] = $scope.times
      $scope.timeData['pauses'] = $scope.pauses
      $scope.timeData['keys'] = $scope.keyword.split("")
      $scope.history = [{
          times: $scope.timeData['times']
          keys: $scope.timeData['pauses']
      }]
    $scope.$apply()
    $('#main').attr('maxlength', 0)

  $scope.enableInput = ->
    $('#main').removeAttr('maxlength')
  $scope.disableInput = ->
    $('#main').attr('maxlength', 0)
  $scope.enableLogging = ->
    logging = true
    $('#main').on 'keydown', (e) ->
      if not logging
        return false
      if e.keyCode == 18
        return
      if e.keyCode == 13
        $scope.draw()
        $scope.disableLogging()
        $scope.reset()
        return
      if e.keyCode == 8
        $scope.disableLogging()
        $scope.resetInput()
        return
      $scope.keydowns.push(new Date().getTime())
      $scope.$apply()
    $('#main').on('keyup', (e) ->
      if not logging
        return false
      if e.keyCode == 18
        return
      $scope.keyups.push(new Date().getTime())
      $scope.$apply()
    )
    $('#main').removeAttr('maxlength')

  $scope.resetInput = ->
    $scope.disableLogging()
    $scope.keydowns = []
    $scope.keyups = []
    $scope.times = []
    $scope.pauses = []
    $scope.keyword = ""
    $scope.$apply()
    setTimeout( ->
      $scope.enableLogging()
    ,500)

  $scope.reset = ->
    $('#main').attr('maxlength', 0)
    $scope.keydowns = []
    $scope.keyups = []
    $scope.times = []
    $scope.pauses = []
    $scope.keyword = ""
    $scope.$apply()
    setTimeout( ->
      $scope.enableLogging()
      $('#main').removeAttr('maxlength')
    ,1000)

  $(document).ready ->
    $scope.enableLogging()
    $('#main').focus()



]
