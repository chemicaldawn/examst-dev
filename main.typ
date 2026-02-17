#import "examst.typ": *
#import "src/state/state.typ"

#show: exam.with(
  point-counters: ("default", "bonus"),
  point-counter-labels: ("default": "points", "bonus" : "bonus points")
)

#question(points: 10)[
  Question 1
]

#question(points: 5)[
  Question 2
]