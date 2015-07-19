{CompositeDisposable} = require 'atom'
_  = require 'underscore-plus'

module.exports =
  subscriptions: null

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'close-pane-with-moving-items:close-pane-with-moving-items': => @closeOtherPanes()

  deactivate: ->
    @subscriptions.dispose()

  closeOtherPanes: ->
    currentPane = atom.workspace.getActivePane()
    panes = atom.workspace.getPanes()

    anotherPane = undefined
    for pane in panes
      unless pane is currentPane
        anotherPane = pane
        break

    if anotherPane
      anotherPanePathes = _.map(anotherPane.getItems(), (item) ->
        if item
          item.getPath()
      )
      for item, i in currentPane.getItems()
        unless item || _.contains(anotherPanePathes, item.getPath())
          currentPane.moveItemToPane(item, anotherPane, i)

    currentPane.close()
