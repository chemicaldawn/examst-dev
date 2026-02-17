#let questions = counter("questions")
#let question-number = state("question-number", (1,))
#let question-points = state("question-points", (0,))

#let point-counters = state("point-counters", ("default": (0,), "bonus": (0,)))
#let point-counter-labels = state("point-counter-labels", ("default": "points"))