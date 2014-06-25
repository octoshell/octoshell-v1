$ ->
  $("ul.members.expandable").expander(
    slicePoint:       50,
    expandPrefix:     ' ',
    expandText:       '[развернуть]',
    userCollapseText: '[свернуть]',
    expandEffect: 'show',
    expandSpeed: 0,
    collapseEffect: 'hide',
    collapseSpeed: 0
  )

  $("ul.faults.expandable").expander(
    slicePoint:       0,
    expandPrefix:     '',
    expandText:       '[показать список проблем]',
    userCollapseText: '[свернуть]',
    expandEffect: 'show',
    expandSpeed: 0,
    collapseEffect: 'hide',
    collapseSpeed: 0
  )
