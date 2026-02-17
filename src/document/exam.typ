#import "../state/config.typ"

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

  points-label : "points",
  show-points: false,

  body
) = {
  config.question-numbering.update(question-numbering)
  config.points-label.update(points-label);
  config.show-points.update(show-points);

  set page(
    numbering: page-numbering,
    footer: page-footer
  )

  body
}