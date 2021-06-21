extensions
[
  py
  matrix
]

globals [
  n-sprint
  repository
  sprint-status

  workers_table
  tasks_table
]

tasks-own [
  stage
  my-current-assigned
  level-required
  level-required-list
  task-level-required
  weight
  file
]

workers-own [
  working
  my-current-task
  skill-level
  skill-level-list
  knowledge-list
]

breed [workers worker]
breed [managers manager]
breed [tasks task]

to setup

  __clear-all-and-reset-ticks
  random-seed 42
  ;set approach_type one-of ["Random" "Best" "GA"]
  ;set worker_number one-of [12]
  ;set task_number one-of [10]
  ;set n_skill_level one-of [10]
  ;set n_sprints one-of [50]
  ;set n_files one-of [12]

  setup-turtles
  set n-sprint 0
  set sprint-status 1
  ask patches [ set pcolor white]
  ; Quantidade de energia que o funcionário produz em cima da tarefa.
  ask workers [set color red set skill-level (random 10) + 1]

  file-open "data/test_case_1.txt"
  file-write approach_type
  file-write task_number
  file-write worker_number
  file-write n_skill_level
  file-write n_sprints
  file-write n_files
  file-close-all

  ask workers [
    set skill-level-list []
    set knowledge-list []
    foreach range n_skill_level [
      set skill-level-list lput (random 10 + 1) skill-level-list
      set knowledge-list lput (random 10 + 1) knowledge-list
    ]
  ]

  set repository matrix:make-constant n_files worker_number 0


end

to go

  if n-sprint >= n_sprints [
    py:setup "venv/bin/python"
    ;py:run "import src.tf.truckfactor as tf"
    py:set "repository" matrix:to-row-list repository
    ;show py:runresult "tf.start_tf(repository)"
    ; ask workers [show variance knowledge-list]
    ; show repository
    ; write "Varianca : " print mean [variance knowledge-list] of workers
    ; write "Media : " print mean [mean knowledge-list] of workers
    ;file-open "data/test_case_1.txt"
    ;file-print ""
    ;file-close-all
    print matrix:pretty-print-text repository
    ;py:setup "venv/bin/python"
    py:run "import src.ga as ga"
    ;py:set "repository" matrix:to-row-list repository
    py:run "print(ga.evaluate_repository(repository))"
    ; setup
    stop
  ]
  create-sprint
  set-run-tasks
  set-tasks-done

  tick
end

to setup-turtles

  set-default-shape workers "person"

  create-workers worker_number [
    set xcor random -15  set ycor random-ycor
    set color blue
  ]

  create-managers 1 [
    setxy 0 5
    set color yellow
    set shape "person business"
  ]

  ask turtles [
    set size 1.5
  ]

end

to set-run-tasks

  ask links [
    let nivel nobody

    ask end1 [
      set nivel skill-level-list
    ]

    ask end2 [
      set level-required  level-required - (item task-level-required nivel)
    ]
  ]

  ask tasks [
    ifelse show-task-level? [set label level-required set label-color red] [set label ""]
  ]

end

to add-tasks-to-doing
  if (count tasks with [stage = 1]) = 0 [
    create-tasks task_number [
      set xcor random 15 set ycor random-ycor
      set color gray
      set shape "letter sealed"
      set stage 1
      set color white
      set size 1.5
      set file random n_files
    ]

    ask tasks [
      set level-required-list []

      foreach range n_skill_level [
        ; set level-required-list lput ((random 100) + 1) level-required-list
        set level-required-list lput one-of [1] level-required-list
      ]

      set task-level-required random n_skill_level
      set level-required ((item task-level-required level-required-list) * 1)
    ]
    set n-sprint (n-sprint + 1)
  ]
end

to set-tasks-done
  ask tasks [
    if level-required <= 0
    [

      let weight_task nobody
      let tsk-lv-required nobody
      let level nobody
      let file_h nobody
      let lr-list nobody

      set weight_task weight
      set tsk-lv-required task-level-required
      set file_h file
      set lr-list level-required-list

      ask my-links [
        ask end1 [
          set level item tsk-lv-required knowledge-list
          set knowledge-list remove-item tsk-lv-required knowledge-list
          set knowledge-list insert-item tsk-lv-required knowledge-list (level + item tsk-lv-required lr-list)
          matrix:set repository file_h who (matrix:get repository file_h who) + item tsk-lv-required lr-list
        ]
      ]

      ask my-links [die]
      set stage 2
      set color red
      hide-turtle
    ]
  ]
  if length [who] of tasks with [stage = 1] = 0 [set sprint-status 1]
end

to create-sprint

  if sprint-status = 1 and n-sprint < n_sprints [

    add-tasks-to-doing
    fill-matrix2
    py:setup "venv/bin/python"
    py:run "import src.ga as ga"
    py:set "repository" matrix:to-row-list repository
    py:set "agents_table" matrix:to-row-list workers_table
    py:set "tasks_table" matrix:to-row-list tasks_table
    py:set "type" approach_type
    let result nobody
    set result py:runresult "ga.main(repository, agents_table, tasks_table, type)"
    ; show result
    py:setup "venv/bin/python"
    py:run "import src.tf.truckfactor as tf"
    py:set "repository" matrix:to-row-list repository
    let tf 0
    set tf py:runresult "tf.start_tf(repository)"
    ;show tf
    file-open "data/test_case_1.txt"
    file-write tf
    file-close-all
    ; show repository
    ; ask workers [show variance knowledge-list]
    ; show result

    let tasks_ids nobody
    set tasks_ids sort [who] of tasks with [stage = 1]
    ; show tasks_ids

    let i 0
    foreach result [x ->
      ask worker x [ create-link-to task item i tasks_ids ]
      set i i + 1
    ]
    set sprint-status 0
  ]
end

to fill-matrix
  set workers_table matrix:make-constant worker_number n_skill_level 0

  set tasks_table matrix:make-constant task_number n_skill_level 0

  let workers_ids nobody
  set workers_ids sort [who] of workers

  let i 0

  foreach workers_ids [x ->
    ask worker x [ matrix:set-row workers_table i skill-level-list ]
    set i i + 1
  ]

  let tasks_ids nobody
  set tasks_ids sort [who] of tasks with [stage = 1]

  let j 0

  foreach tasks_ids [x ->
    ask task x [ matrix:set-row tasks_table j level-required-list]
    set j j + 1
  ]
end

to fill-matrix2
  set workers_table matrix:make-constant worker_number n_skill_level 0

  set tasks_table matrix:make-constant task_number 3 0

  let workers_ids nobody
  set workers_ids sort [who] of workers

  let i 0

  foreach workers_ids [x ->
    ask worker x [ matrix:set-row workers_table i skill-level-list ]
    set i i + 1
  ]

  let tasks_ids nobody
  set tasks_ids sort [who] of tasks with [stage = 1]

  let j 0

  foreach tasks_ids [x ->
    ask task x [ matrix:set-row tasks_table j (list (item  task-level-required level-required-list)task-level-required file)]
    set j j + 1
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
481
19
929
468
-1
-1
13.33333333333334
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
15
43
89
76
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
103
42
166
75
Go
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
192
22
276
67
ToDo
count tasks with [color = white]
17
1
11

MONITOR
193
91
302
136
Workers
count workers
17
1
11

BUTTON
103
87
166
120
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
362
22
457
67
Done
count tasks with [stage = 2]
17
1
11

MONITOR
309
91
383
136
Manager
count managers
17
1
11

MONITOR
282
22
356
67
Doing
count links
17
1
11

SLIDER
5
199
177
232
task_number
task_number
1
40
10.0
1
1
NIL
HORIZONTAL

PLOT
204
157
473
417
Tarefas da Sprint
time
total
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count tasks"

SWITCH
8
447
181
480
show-task-level?
show-task-level?
0
1
-1000

SLIDER
7
240
180
273
worker_number
worker_number
2
20
5.0
1
1
NIL
HORIZONTAL

SLIDER
7
283
180
316
n_skill_level
n_skill_level
1
30
1.0
1
1
NIL
HORIZONTAL

MONITOR
391
91
448
136
Sprint
n-sprint
17
1
11

INPUTBOX
8
318
181
378
n_sprints
10.0
1
0
Number

INPUTBOX
9
382
181
442
n_files
2.0
1
0
Number

CHOOSER
6
143
178
188
approach_type
approach_type
"GA" "Random" "Best"
0

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

letter opened
false
0
Rectangle -7500403 true true 30 90 270 225
Rectangle -16777216 false false 30 90 270 225
Line -16777216 false 150 30 270 105
Line -16777216 false 30 105 150 30
Line -16777216 false 270 225 181 161
Line -16777216 false 30 225 119 161
Polygon -6459832 true false 30 105 150 30 270 105 150 180
Line -16777216 false 30 105 270 105
Line -16777216 false 270 105 150 180
Line -16777216 false 30 105 150 180

letter sealed
false
0
Rectangle -7500403 true true 30 90 270 225
Rectangle -16777216 false false 30 90 270 225
Line -16777216 false 270 105 150 180
Line -16777216 false 30 105 150 180
Line -16777216 false 270 225 181 161
Line -16777216 false 30 225 119 161

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person business
false
0
Rectangle -1 true false 120 90 180 180
Polygon -13345367 true false 135 90 150 105 135 180 150 195 165 180 150 105 165 90
Polygon -7500403 true true 120 90 105 90 60 195 90 210 116 154 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 183 153 210 210 240 195 195 90 180 90 150 165
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 76 172 91
Line -16777216 false 172 90 161 94
Line -16777216 false 128 90 139 94
Polygon -13345367 true false 195 225 195 300 270 270 270 195
Rectangle -13791810 true false 180 225 195 300
Polygon -14835848 true false 180 226 195 226 270 196 255 196
Polygon -13345367 true false 209 202 209 216 244 202 243 188
Line -16777216 false 180 90 150 165
Line -16777216 false 120 90 150 165

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
