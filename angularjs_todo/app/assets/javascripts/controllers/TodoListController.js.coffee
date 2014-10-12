angular.module('todoApp').controller "TodoListController", ($scope, $timeout, $routeParams, Task, TaskList) ->
  $scope.sortMethod      = 'priority'
  $scope.sortableEnabled = true

  $scope.init = () ->
    @taskService = new Task($routeParams.list_id, serverErrorHandler)
    @listService = new TaskList()
    @listService.find $routeParams.list_id, (list) ->
      $scope.tasks = list.tasks

  $scope.addTask = ->
    raisePriorities()
    task = @taskService.create(description: $scope.taskDescription)
    task.priority = 1
    $scope.tasks.unshift(task)
    $scope.taskDescription = ""

  $scope.deleteTask = (task) ->
    lowerPrioritiesBelow(task)
    @taskService.delete(task)
    $scope.tasks.splice($scope.tasks.indexOf(task), 1)

  $scope.toggleTask = (task) ->
    @taskService.update(task, completed: task.completed)

  $scope.taskEdited = (task) ->
    @taskService.update(task, description: task.description)

  $scope.dueDatePicked = (task) ->
    @taskService.update(task, due_date: task.due_date)


  $scope.priorityChanged = (task) ->
    @taskService.update(task, target_priority: task.priority)
    updatePriorities()

  $scope.sortableOptions =
    update: (e, ui) ->
      domIndexOf = (e) -> e.siblings().andSelf().index(e)
      newPriority = domIndexOf(ui.item) + 1

      task = ui.item.scope().task
      task.priority = newPriority

      $scope.priorityChanged(task)

  $scope.changeSortMethod = (sortMethod) ->
    $scope.sortMethod = sortMethod
    if sortMethod == 'priority'
      $scope.sortableEnabled = true
    else
      $scope.sortableEnabled = false

  $scope.dueDateNullLast = (task) ->
    task.due_date ? '2999-12-31'

  serverErrorHandler = ->
    alert("サーバーでエラーが発生しました。画面を更新し、もう一度実行して下さい。")

  updatePriorities = ->
    # During reordering it's simplest to just mirror priorities based on task positions in the list.
    $timeout ->
      angular.forEach $scope.tasks, (task, index) ->
        task.priority = index + 1

  raisePriorities = ->
    angular.forEach $scope.tasks, (t) ->
      t.priority += 1

  lowerPrioritiesBelow = (task) ->
    angular.forEach tasksBelow(task), (t) ->
      t.priority -= 1

  tasksBelow = (task) ->
    $scope.tasks.slice($scope.tasks.indexOf(task), $scope.tasks.length)
