# import common.coffee and jquery

window.CommitSearch =
  init: ->
    $("#commitSearch .submit").click @onSearchClick.proxy(@)
    $("#commitSearch input[name=filter_value]").focus()
    $("#commitSearch input[name=filter_value]").keydown @onKeydownInSearchbox.proxy(@)
    $(document).keydown @onKeydown.proxy(@)
    selectedGroup = $(".savedSearch:first-of-type")
    while selectedGroup.size() > 0
      selected = selectedGroup.find(".commitsList tr:first-of-type")
      if selected.size() > 0
        selected.addClass "selected"
        break
      selectedGroup = selectedGroup.next()

  onSearchClick: ->
    $("#commitSearch input[name=filter_value]").blur()
    authors = $("#commitSearch input[name=filter_value]").val()
    return unless authors
    queryParams = { authors: authors }
    $.post("/saved_searches", queryParams, @onSearchSaved.proxy(@))

  onSearchSaved: (responseHtml) ->
    $("#savedSearches").prepend responseHtml
    $(".selected").removeClass "selected"
    $(".savedSearch:first-of-type .commitsList tr:first-of-type").addClass "selected"

  onKeydownInSearchbox: (event) ->
    event.stopPropagation()
    switch event.which
      when Constants.KEY_RETURN
        @onSearchClick()
      when Constants.KEY_ESC
        $("#commitSearch input[name=filter_value]").blur()

  onKeydown: (event) ->
    event.stopPropagation()
    switch event.which
      when Constants.KEY_SLASH
        $("#commitSearch input[name=filter_value]").focus()
        return false
      when Constants.KEY_J
        @selectDiff(true)
      when Constants.KEY_K
        @selectDiff(false)

  selectDiff: (next = true) ->
    selected = $(".selected")
    group = selected.parents(".savedSearch")
    newlySelected = if next then selected.next() else selected.prev()
    while newlySelected.size() == 0
      group = if next then group.next() else group.prev()
      return if group.size() == 0
      newlySelected = if next then group.find("tr:first-of-type") else group.find("tr:last-of-type")
    selected.removeClass "selected"
    newlySelected.addClass "selected"

$(document).ready(-> CommitSearch.init())