#import "../state/config.typ"
#import "../state/state.typ"

#let _enter-question(
  points: auto
) = {
  // Aggregate points
  if points != auto {
    state.question-points.update(old => {
      old = old.map(i => i + points)
      old.push(points)
      return old
    })
  } else {
    state.question-points.update(old => {
      old.push(0)
      return old
    })
  }

  // Increment question-number representation array in case a subpart appears in the body
  state.question-number.update(old => {
    old.push(1)
    return old
  })

  // Add metadata signaling the beginning of an n-depth question
  context [#metadata(state.question-number.get().len() - 1) <question-begin>]
}

#let _exit-question() = {
  // Add metadata signaling the end of an n-depth question
  context [#metadata(state.question-number.get().len() - 1) <question-end>]

  state.questions.step()
  state.question-number.update(old => {
    old.pop()
    old.push(old.pop() + 1)
    return old
  })

  state.question-points.update(old => {
    old.pop()
    return old
  })
}

#let _render-points(
  num_points
) = [
  (#num_points points)
]

#let _show-points(
  points: auto,
  show-points: auto
) = context [
  #let depth = state.question-number.get().len() - 1
  #let num_points = state.question-points.at(
    query(
      selector(
        metadata.where(
          value: depth
        )
      ).after(here())
    ).first().location()
  ).at(depth)

  #if (points != auto) and (show-points == auto) {
    _render-points(num_points)
   } else if (show-points == true) {
    _render-points(num_points)
   }
]

#let _question(
  title: none,
  points: auto,
  show-points: auto,
  body
) = [
  #grid(columns: (auto, 1fr), gutter: 4pt, inset: 0pt,
    par()[
      #context numbering(
        config.question-numbering.get(), 
        ..state.question-number.get()
      )
    ],
    [
      #_enter-question(points: points)
  
      #if title != none [
        #title 
      ]
      #_show-points(points: points, show-points: show-points)
      #body

      #_exit-question()
    ]
  )
]

#let question(
  title: none,
  points: auto,
  show-points: auto,
  body
) = {
  _question(title: title, points: points, show-points: show-points, body)
}

#let part(
  title: none,
  points: auto,
  show-points: auto,
  body
) = {
  _question(title: title, points: points, show-points: show-points, body)
}