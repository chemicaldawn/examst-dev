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
  state.question-number.update(old => (old.at(0) + 1,))

  context {
    let old-question-points = state.question-points.get()
    state.question-point-history.update(old => {
      old.push(old-question-points)
      return old
    })
  }

  state.question-points.update(0)
}

#let conditional-pagebreak() = context {
  if(state.questions.get() != state.questions.final()) {
    pagebreak()
  }
}

#let question(
  title,
  points: auto,
  body
) = [
  #grid(
    columns: (1fr, auto),
    heading(
      numbering: none,
      context [
        #numbering(
          config.question-numbering.get(), 
          ..state.question-number.get()
        )
        #title
      ]
    ),
    context heading(
      numbering: none
    )[
      #let next-end = query(selector(<question-end>).after(here())).first().location()
      (#state.question-points.at(next-end) #config.points-label.get())
    ]
  )

  #enter-question()
  #metadata("") <question-begin>
  
  #body

  #metadata("") <question-end>
  #exit-question()

  #conditional-pagebreak()
]