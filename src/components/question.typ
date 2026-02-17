#import "../state/config.typ"
#import "../state/state.typ"

#let enter-question() = {
  state.question-number.update(old => {
    old.push(1)
    return old
  })
}

#let exit-question() = {
  state.questions.step()
  state.question-number.update(old => {
    old.pop()
    old.push(old.pop() + 1)
    return old
  })

  context {
    let old-question-points = state.question-points.get()
    state.question-point-history.update(old => {
      old.push(old-question-points)
      return old
    })
  }

  state.question-points.update(0)
}

#let _question(
  title: none,
  points: auto,
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
      #metadata("") <question-begin>
      #enter-question()
  
      #if title != none [
        #title 
      ]
      #if points != auto [
        (#points points)
      ]
      #body 

      #metadata("") <question-end>
      #exit-question()
    ]
  )
]

#let question(
  title: none,
  points: auto,
  body
) = {
  _question(title: title, points: points, body)
}

#let part(
  title: none,
  points: auto,
  body
) = {
  _question(title: title, points: points, body)
}