#import "../state/config.typ"
#import "../state/state.typ" as state

#let exam(
  page-numbering: "1",
  page-footer: context [
    #if(calc.odd(counter(page).get().at(0))) {
      align(right)[#counter(page).display()]
    } else {
      align(left)[#counter(page).display()]
    }
  ],

  question-numbering: "1.1",

  point-counters: ("default",),
  point-counter-labels: ("default" : "points"),
  point-aggregators: 0,

  body
) = {
  config.question-numbering.update(question-numbering)

  let point_counter_values = (:)
  for counter in point-counters {
    point_counter_values.insert(counter, (0,))
  }
  state.point-counters.update(point_counter_values)
  state.point-counter-labels.update(point-counter-labels)

  set page(
    numbering: page-numbering,
    footer: page-footer
  )

  body
}