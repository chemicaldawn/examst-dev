#import "../state/config.typ"
#import "../state/state.typ"

#let _increment-points(
  points: auto
) = context {
  let modified_counters = ()
  let modifications = (:)
  let ignored_counters = ()

  // For numerical input, modify default
  if (type(points) == int) or (type(points) == float) {
    modified_counters.push("default")
    modifications.insert("default", points)
  } 
  
  // For dictionary input, modify all counters specified
  else if (type(points) == dictionary) {
    modifications = points
    for counter in modifications.keys() {
      modified_counters.push(counter)
    }
  }

  // Correctly partition ignored counters
  ignored_counters = state.point-counters.get().keys().filter(e => {
    return (not modified_counters.contains(e))
  })
  
  // Perform batch update
  state.point-counters.update(old => {
    for counter in modified_counters {
      let points = modifications.at(counter)
      let new_state = old.at(counter).map(i => i + points)
      new_state.push(points)
      old.insert(counter, new_state)
    }
    for counter in ignored_counters {
      let new_state = old.at(counter)
      new_state.push(0)
      old.insert(counter, new_state)
    }
    return old
  })
}

#let _enter-question(
  points: auto
) = {
  // Aggregate points
  _increment-points(points: points)

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
  
  context {
    state.point-counters.update(old => {
      for counter in old.keys() {
        let new_state = old.at(counter)
        let result = new_state.pop()
        old.insert(counter, new_state)
      }
      return old
    })
  }
}

#let _render-points(
  point-counts
) = context [
  (#point-counts.keys().map(counter => 
    [#point-counts.at(counter) #state.point-counter-labels.get().at(counter)]
  ).join(", "))
]

#let _show-points(
  points: auto,
  hide-points: false
) = context [
  #let depth = state.question-number.get().len() - 1
  #let point-histories = state.point-counters.at(
    query(
      selector(
        metadata.where(
          value: depth
        )
      ).after(here())
    ).first().location()
  )
  #let point-counts = (:)
  #for counter in point-histories.keys() {
    point-counts.insert(counter, point-histories.at(counter).at(depth))
  }

  #if (not hide-points) {
    _render-points(point-counts)
   }
]

#let _question(
  title: none,
  points: auto,
  hide-points: false,
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
      #_show-points(points: points, hide-points: hide-points)
      #body

      #_exit-question()
    ]
  )
]

#let question(
  title: none,
  points: auto,
  hide-points: false,
  body
) = {
  _question(title: title, points: points, hide-points: hide-points, body)
}

#let part(
  title: none,
  points: auto,
  hide-points: false,
  body
) = {
  _question(title: title, points: points, hide-points: hide-points, body)
}