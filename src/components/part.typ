#import "../state/config.typ"
#import "../state/state.typ"

/*

*/
#let enter-part() = {
  state.question-number.update(old => {
    old.push(1)
    return old
  })  
}

/*

*/
#let exit-part() = {
  state.question-number.update(old => {
    old.pop()
    old.push(old.pop() + 1)
    return old
  })
}

#let part(
  points: auto,
  show-points: auto,
  body
) = {
  grid(columns: (auto, 1fr), gutter: 4pt, inset: 0pt,
    context [
      #numbering( 
        config.question-numbering.get(),
        ..state.question-number.get()
      )
    ],
    [
      #enter-part()
      #metadata("") <part-begin>

      #if(points != auto) {
        state.question-points.update(old => old + points)
      }

      #context[
        #let points-toggle = show-points
        #if (show-points == auto) {
          points-toggle = (points != auto) and config.show-points.get()
        }
        #if(points-toggle) [
          (#points #config.points-label.get())
        ]
      ]
      #body

      #metadata("") <part-end>
      #exit-part()
    ]
  )
}