#import "../state/state.typ"

#let gradetable() = context {
  let points = state.question-point-history.final()
  points
}