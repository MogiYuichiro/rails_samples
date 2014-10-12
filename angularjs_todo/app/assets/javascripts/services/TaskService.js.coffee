angular.module('todoApp').factory 'Task', ($resource, $http) ->
  class Task
    constructor: (taskListId) ->
      @service = $resource('/api/task_lists/:task_list_id/tasks/:id',
        { task_list_id: taskListId },
        { update: { method: 'PUT' }})

      # # Fix needed for the PATCH method to use application/json content type.
      # defaults = $http.defaults.headers
      # defaults.patch = defaults.patch || {}
      # defaults.patch['Content-Type'] = 'application/json'

    create: (attrs) ->
      new @service(task: attrs).save()

    update: (task, attrs) ->
      new @service(task: attrs).$update(id: task.id)

    all: ->
      @service.query()
