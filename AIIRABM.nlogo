;; Author(s): T. E. Wood, G. C. An
;; Code written on NetLogo 6.4.0
;; Code written 2024


breed [epithelial-cells epithelial-cell]
breed [macrophages macrophage]

turtles-own ;; variables assigned to all turtles
[
  cell-death-status ;; 0 = alive, 1 = apoptosed, 2 = necroptosed, 3 = pyroptosed, 4 = death by viral shedding/ROS-damage/lytic apoptosis/unprogrammed lysis/another form of lytic cell death?
  ROS-damage-count
  cell-membrane
  intracellular-virus-count

  RIGI-active? ;; PRRs
  MDA5-active?
  TLR-active?
  NFκB/AP1-active? ;; TFs
  IRF7-active?

  JAKSTAT-pathway-count ;; IFN-stimulated
  type1ISG-active?

  NLRP-count
  primed-inflammasome?
  activated-inflammasome?
  pyroptosis-count

  RIPK3-active? ;; cell death pathways
  caspase8/9-active?
  apoptosis-count
  lytic-apoptosis-count
  MLKL-active?
  necrosis-count
  unprogrammed-lysis-count

  nucleus-vRNP-count
  intracellular-virus-synthesised-within-tick
]


macrophages-own ;; variables specific to macrophages
[
  activated?
  phagocytosing?
  capacity-for-phagocytosis
  maximum-capacity-for-phagocytosis
  phagocytosis-recovery-rate
  macrophage-speed
]


patches-own ;; will add more extracellular signalling molecules with additional cell types
            ;; will simplify/remove some extracellular signalling molecules = aggregate them by function
[
  extracellular-virus-count
  P/DAMP-count
  ROS-count
  TNFα-count
  type1IFN-count
  RANTES-count
  MCP1-count
  TGFβ-count
  IL8-count
  IL18-count
  IL6-count
  MCP3-count
  MIP1-count
  MIP3-count
  IP10-count
]


globals ;; will add more global vairables with more cell types to keep track of/total
[
  grid-size ;; enables user to change the grid's size in only one line of code

  total-days
  total-hours
  total-continuous-days

  total-dead-epis
  total-apoptosed-epis
  total-necroptosed-epis
  total-pyroptosed-epis
  total-infected-epis
  total-undefined-lysed-epis
  total-phagocytosed-epis

  total-extracellular-virus
  total-intracellular-virus

  total-P/DAMP
  total-ROS
  total-TNFα
  total-type1IFN
  total-RANTES
  total-MCP1
  total-TGFβ
  total-IL8
  total-IL18
  total-NLRP

  total-dead-macros
  total-apoptosed-macros
  total-necroptosed-macros
  total-infected-macros
  total-undefined-lysed-macros
]


to setup
  ca
  reset-ticks
  if random-seed? = FALSE
  [random-seed user-random-seed]

  set grid-size 16 ;; half the length of one side of the box ; enables user to change the grid's size in only one line of code
  resize-world -1 * (grid-size) grid-size -1 * (grid-size) grid-size

  ask patches
  [sprout-epithelial-cells 1 ;; create epithelial cell grid
    [set shape "square"
      set color 106 ;; blue
      set cell-death-status 0
      set ROS-damage-count 0
      set cell-membrane 2000 + random 100 ;; arbitrary value with an added stochastic element, AIV burst size in the 1000s
      set intracellular-virus-count 0
      set RIGI-active? FALSE
      set MDA5-active? FALSE
      set TLR-active? FALSE
      set NFκB/AP1-active? FALSE
      set IRF7-active? FALSE
      set JAKSTAT-pathway-count 0
      set type1ISG-active? FALSE
      ifelse duck? = TRUE
      [set NLRP-count 0]
      [ifelse chicken-NLRP-expression-ubiquitous = TRUE
        [set NLRP-count 2] ;; 2 arbitrary ; differentiates duck/chicken metabolisms
        [set NLRP-count 0]]
      set primed-inflammasome? FALSE
      set activated-inflammasome? FALSE
      set pyroptosis-count 0
      set RIPK3-active? FALSE
      set caspase8/9-active? FALSE
      set apoptosis-count 0
      set lytic-apoptosis-count 0
      set MLKL-active? FALSE
      set necrosis-count 0
      set unprogrammed-lysis-count 0
      set nucleus-vRNP-count 0
      set intracellular-virus-synthesised-within-tick 0
      ;; set the values of subsequently added epithelial variables
    ]

    ;; set patches' variables
    set extracellular-virus-count 0
    set P/DAMP-count 0
    set ROS-count 0
    set TNFα-count 0
    set type1IFN-count 0
    set RANTES-count 0
    set MCP1-count 0
    set TGFβ-count 0
    set IL8-count 0
    set IL18-count 0
    set IL6-count 0
    set MCP3-count 0
    set MIP1-count 0
    set MIP3-count 0
    set IP10-count 0
  ]

  ;; infect patches
  infect

  ;; sprout macrophages and set their variables
  repeat initial-number-of-macrophages
   [ask patch ((random ((2 * grid-size) + 1)) - grid-size) ((random ((2 * grid-size) + 1)) - grid-size) ;; random patch co-ordinate
      [sprout-macrophages 1
        [set shape "triangle"
      set color 114 ;; violet
      set cell-death-status 0
      set ROS-damage-count 0
      set cell-membrane 2000 + random 100 ;; arbitrary value with an added stochastic element, AIV burst size in the 1000s
      set intracellular-virus-count 0
      set RIGI-active? FALSE
      set MDA5-active? FALSE
      set TLR-active? FALSE
      set NFκB/AP1-active? FALSE
      set IRF7-active? FALSE
      set JAKSTAT-pathway-count 0
      set type1ISG-active? FALSE
      ifelse duck? = TRUE
      [set NLRP-count 0]
      [ifelse chicken-NLRP-expression-ubiquitous = TRUE
        [set NLRP-count 2] ;; 2 arbitrary ; differentiates duck/chicken metabolisms
        [set NLRP-count 0]]
      set primed-inflammasome? FALSE
      set activated-inflammasome? FALSE
      set pyroptosis-count 0
      set RIPK3-active? FALSE
      set caspase8/9-active? FALSE
      set apoptosis-count 0
      set lytic-apoptosis-count 0
      set MLKL-active? FALSE
      set necrosis-count 0
      set unprogrammed-lysis-count 0
      set nucleus-vRNP-count 0
      set intracellular-virus-synthesised-within-tick 0

      ;; set the values of macrophage-specific variables
      set phagocytosis-recovery-rate 10 ;; 10 arbitrary
      set maximum-capacity-for-phagocytosis 100 ;; 100 arbitrary
      set capacity-for-phagocytosis 0
      set phagocytosing? FALSE
      ;set activated? FALSE
    ]]]

  ;; setting the values of global variables
  set total-days 0
  set total-hours 0

  set total-dead-epis 0
  set total-apoptosed-epis 0
  set total-necroptosed-epis 0
  set total-pyroptosed-epis 0
  set total-infected-epis 0
  set total-undefined-lysed-epis 0
  set total-phagocytosed-epis 0

  set total-extracellular-virus 0
  set total-intracellular-virus 0

  set total-P/DAMP 0
  set total-ROS 0
  set total-TNFα 0
  set total-type1IFN 0
  set total-RANTES 0
  set total-MCP1 0
  set total-TGFβ 0
  set total-IL8 0
  set total-NLRP 0
  ;; set the values of subsequently added global variables
end


to go
  tick ;; 1 tick = 1 hour

  set total-days floor (ticks / 360) ;; update the days-hours GUI counter
  set total-hours floor ((ticks - 360 * (floor (ticks / 360))) / 15)
  set total-continuous-days ticks / 360

  ;; update the total count variables for the GUI plots
  set total-dead-epis count epithelial-cells with [cell-death-status > 0] ;; 0 = alive, 1 = apoptosed, 2 = necroptosed, 3 = pyroptosed, 4 = death by viral shedding/ROS-damage/another form of lytic cell death?
  set total-apoptosed-epis count epithelial-cells with [cell-death-status = 1]
  set total-necroptosed-epis count epithelial-cells with [cell-death-status = 2]
  ;set total-pyroptosed-epis count epithelial-cells with [cell-death-status = 3]
  set total-infected-epis count epithelial-cells with [intracellular-virus-count > 0 and cell-death-status = 0]
  set total-undefined-lysed-epis count epithelial-cells with [cell-death-status = 4]
  set total-phagocytosed-epis ((((2 * grid-size) + 1) ^ 2) - (count epithelial-cells))

  set total-extracellular-virus sum [extracellular-virus-count] of patches
  set total-intracellular-virus sum [intracellular-virus-count] of turtles

  set total-P/DAMP sum [P/DAMP-count] of patches
  set total-ROS sum [ROS-count] of patches
  set total-TNFα sum [TNFα-count] of patches
  set total-type1IFN sum [type1IFN-count] of patches
  set total-IL8 sum [IL8-count] of patches
  set total-IL18 sum [IL18-count] of patches
  set total-RANTES sum [RANTES-count] of patches
  set total-MCP1 sum [MCP1-count] of patches
  set total-TGFβ sum [TGFβ-count] of patches
  set total-NLRP sum [NLRP-count] of epithelial-cells with [cell-death-status = 0]

  set total-dead-macros count macrophages with [cell-death-status > 0] ;; 0 = alive, 1 = apoptosed, 2 = necroptosed, 3 = pyroptosed, 4 = death by viral shedding/ROS-damage/another form of lytic cell death?
  set total-apoptosed-macros count macrophages with [cell-death-status = 1]
  set total-necroptosed-macros count macrophages with [cell-death-status = 2]
  set total-infected-macros count macrophages with [intracellular-virus-count > 0 and cell-death-status = 0]
  set total-undefined-lysed-macros count macrophages with [cell-death-status = 4]

  ;; remove extracellular virions if no neighbouring alive epithelial cells
  ask patches [remove-extracellular-virions-without-host]

  ;; call each breed/cell type
  ask epithelial-cells [epithelial-cell-function]
  ask macrophages [macrophage-function]

  ;; call the diffuse, evaporate and cleanup functions
  diffuse-function
  ask patches [evaporate-function]
  ask patches [cleanup-function]

  ;; update the patches' backgrounds
  patch-background-function

  ;; Stopping condition
  if count epithelial-cells with [cell-death-status = 0] <= 0 or (count epithelial-cells with [intracellular-virus-count > 10 and cell-death-status = 0] + count patches with [extracellular-virus-count > 0]) <= 0
    [stop]
end

to infect
  ;; total epi cells/patches = (((2 * grid-size) + 1) ^ 2))
  ;; can determine the % of patches infected with virus
  ;; for each patch infected can determine the no. virions on each patch

  ifelse all-patches-initially-infected = FALSE
  [repeat (floor ((((2 * grid-size) + 1) ^ 2) / 100)) * 5 ;; 5% of patches infected
   [ask patch ((random ((2 * grid-size) + 1)) - grid-size) ((random ((2 * grid-size) + 1)) - grid-size) ;; random patch co-ordinate
      [set extracellular-virus-count round (initial-extracellular-virus-count + ((random initial-extracellular-virus-count / 2.5) - (initial-extracellular-virus-count / 5)))]]] ;; some stochasticity in viral innoculation, +-20% of initial-extracellular-virus-count
  [ask patches
      [ifelse initial-extracellular-virus-count > 10
       [set extracellular-virus-count round (initial-extracellular-virus-count + ((random initial-extracellular-virus-count / 2.5) - (initial-extracellular-virus-count / 5)))]
      [set extracellular-virus-count initial-extracellular-virus-count + random 5 - 2]]] ;; uniform distribution btw initial-extracellular-virus-count - 2 and initial-extracellular-virus-count + 2 ; might want to model as a gaussian distibution instead

  patch-background-function
end


to remove-extracellular-virions-without-host ;; removal of extracellular virions after a tick if no neighbouring epithelial cells to infect
  if not any? (epithelial-cells-on neighbors) with [cell-death-status = 0] and not any? (epithelial-cells-on self) with [cell-death-status = 0]
    [ask self [set extracellular-virus-count 0]]
end


to epithelial-cell-function
  ;; Must work backwards through the cell's metabolism within one tick
  ;; Most of the time arbitrarily outputting +1 metabolites, -0.1/-1 consuming metabolites

  ;; check if epi is dead
  if cell-death-status > 0
  [if not (random element-of-stochasticity = 0)
  [set P/DAMP-count P/DAMP-count + 1
    if cell-death-status = 1 ;; if cell apoptotic but not phagocytosed quickly enough it could lead to necrosis
    [ifelse necrosis-count > 200 and not (random element-of-stochasticity = 0) ;; 200 arbitrary ; want a value in which most of the time macrophages successfully reach apoptotic cells and phagocytose them
      [set cell-death-status 2
       set color 6 ;; grey
        set shape "square"
       set P/DAMP-count P/DAMP-count + 10
        set extracellular-virus-count extracellular-virus-count + (min list (50 + random 10) (intracellular-virus-count * 0.5))]
        [set necrosis-count necrosis-count + 1]]] ;; if apoptotic cell left for too long then it undergoes necrosis
    stop]

  ;; check if epi should die from non-necrosis lytic cell death - viral budding, ROS dmagae, lytic apoptosis, unprogrammed lysis
  if (ROS-damage-count >= ROS-damage-threshold) or (cell-membrane < 1) or (lytic-apoptosis-count > lytic-apoptosis-threshold) or (unprogrammed-lysis-count > unprogrammed-lysis-threshold) and not (random element-of-stochasticity = 0)
  [set cell-death-status 4
    set color 6 ;; grey
    set P/DAMP-count P/DAMP-count + 10
    set extracellular-virus-count extracellular-virus-count + (min list (50 + random 10) (intracellular-virus-count * 0.5))
    ;; are any other signals emitted with these forms of cell death??
    stop]

  ;; check if epi should die from pyroptosis - assumed preference over apoptosis, so pyroptosis-count checked before apoptosis-count
  ;; no pyroptotic cells as no gasdermin e in aves

  ;; check if epi should die from apoptosis
  ;; if apoptosis-count and necrosis-count both greater than their thresholds then randomly choose one of the two processes to occur
  if not (random element-of-stochasticity = 0)
  [ifelse (apoptosis-count > apoptosis-threshold and necrosis-count <= necrosis-threshold) or (apoptosis-count > apoptosis-threshold and random 2 = 0)
  [set cell-death-status 1
    set shape "petals" ;; apoptosis cause cell membrane blebbing
    set necrosis-count 0 ;; used to count if dead apoptotic cell needs to change to necrotic cell
    set color 6 ;; grey
    stop]
  ;; check if epi should die from necrosis
  [if necrosis-count > necrosis-threshold
  [set cell-death-status 2
    set color 6 ;; grey
    set P/DAMP-count P/DAMP-count + 10
    set extracellular-virus-count extracellular-virus-count + (min list (50 + random 10) (intracellular-virus-count * 0.5))
        stop]]]

  ;; setting cell death pathway counts
  ifelse activated-inflammasome? = TRUE
  [][] ;; no pyroptosis in aves, no significant inflammatory cytokine production in epithelial cells

  ifelse caspase8/9-active? = TRUE and not (random element-of-stochasticity = 0)
  [set apoptosis-count apoptosis-count + 1]
  [set apoptosis-count max (list (apoptosis-count - 1) 0)] ;; degradation of cell death pathway counts/activation

  ifelse caspase8/9-active? = TRUE and not (random element-of-stochasticity = 0)
  [set lytic-apoptosis-count lytic-apoptosis-count + 1]
  [set lytic-apoptosis-count max (list (lytic-apoptosis-count - 1) 0)] ;; degradation of cell death pathway counts/activation

  ifelse MLKL-active? = TRUE and not (random element-of-stochasticity = 0)
  [set necrosis-count necrosis-count + 1]
  [set necrosis-count max (list (necrosis-count - 1) 0)] ;; degradation of cell death pathway counts/activation

  ;; activating caspase-8/9
  ;; activating MLKL
  ifelse RIPK3-active? = TRUE and not (random element-of-stochasticity = 0)
  [set caspase8/9-active? TRUE
    set MLKL-active? TRUE
    set unprogrammed-lysis-count unprogrammed-lysis-count + 1]
  [set caspase8/9-active? FALSE
    set MLKL-active? FALSE
    set unprogrammed-lysis-count max (list (unprogrammed-lysis-count - 1) 0)]

  ;; viral shedding
  let extracellular-virus-shed-within-tick 0

  ifelse intracellular-virus-count >= virus-infection-threshold and not (random element-of-stochasticity = 0) ;; viral budding above a certain no. intracellular particles
  [ifelse type1ISG-active? = TRUE
    [if random 4 < 3 ;; want less AIV budding with active type1ISGs = 0.75% chance of budding
      [ifelse intracellular-virus-count > virus-released-in-one-tick
        [set extracellular-virus-shed-within-tick virus-released-in-one-tick ;; more than one virus buds / tick? instead a % of the intracellular-virus-count?
          set cell-membrane cell-membrane - virus-released-in-one-tick
          set intracellular-virus-count intracellular-virus-count - virus-released-in-one-tick]
        [set extracellular-virus-shed-within-tick (intracellular-virus-count - 1) ;; more than one virus buds / tick? instead a % of the intracellular-virus-count?
          set cell-membrane cell-membrane - (intracellular-virus-count - 1)
          set intracellular-virus-count intracellular-virus-count - (intracellular-virus-count - 1)]]]
    [ifelse intracellular-virus-count > virus-released-in-one-tick
        [set extracellular-virus-shed-within-tick virus-released-in-one-tick ;; more than one virus buds / tick? instead a % of the intracellular-virus-count?
          set cell-membrane cell-membrane - virus-released-in-one-tick
          set intracellular-virus-count intracellular-virus-count - virus-released-in-one-tick]
        [set extracellular-virus-shed-within-tick (intracellular-virus-count - 1) ;; more than one virus buds / tick? instead a % of the intracellular-virus-count?
          set cell-membrane cell-membrane - (intracellular-virus-count - 1)
        set intracellular-virus-count intracellular-virus-count - (intracellular-virus-count - 1)]]]
  [set extracellular-virus-shed-within-tick 0]

  ;; intracellular virus replication from nuclear vRNPs
  set intracellular-virus-synthesised-within-tick 0 ; variable prevents viruses synthesised in this tick affecting other processes/calculations below

  if not (random element-of-stochasticity = 0)
  [ifelse type1ISG-active? = TRUE ;; reduced viral replication with active type 1 ISGs
  [set intracellular-virus-synthesised-within-tick (floor (nucleus-vRNP-count * 0.75)) * virus-replication-rate]
    [set intracellular-virus-synthesised-within-tick nucleus-vRNP-count * virus-replication-rate]] ;; intracellular-virus-synthesised-within-tick added onto intracellular-virus-count at the end of epithelial-cell-function

  ;; AIV replication: transport of vRNPs into nucleus
  ifelse not (random element-of-stochasticity = 0) and intracellular-virus-count >= 1
  [if type1ISG-active? = TRUE and RIGI-active? = TRUE ;; inhibitory effect of type1ISGs and RIG-I on viral replication
    [set nucleus-vRNP-count 0.25]
  ;set intracellular-virus-count (intracellular-virus-count * 0.75)]
  if type1ISG-active? = TRUE xor RIGI-active? = TRUE
    [set nucleus-vRNP-count 0.50]
  ;set intracellular-virus-count (intracellular-virus-count * 0.50)]
  if type1ISG-active? = FALSE and RIGI-active? = FALSE
    [set nucleus-vRNP-count 1]]
      ;set intracellular-virus-count (intracellular-virus-count * 0.25)]]
  [set nucleus-vRNP-count 0]

  ;; type1IFN production:
  let type1IFN-produced-within-tick 0

  if (IRF7-active? = TRUE or type1ISG-active? = TRUE) and not (random element-of-stochasticity = 0)
  [set type1IFN-produced-within-tick 1]

  ;; inflammasome activation: extracellular P/DAMP + intracellular JAK-STAT signalling pathway
  ifelse primed-inflammasome? = TRUE and not (random element-of-stochasticity = 0)
  [ifelse P/DAMP-count >= 10 or MDA5-active? = TRUE or RIGI-active? = TRUE ;; 10 arbitrary
    [set activated-inflammasome? TRUE
      if P/DAMP-count >= 10 [set P/DAMP-count max (list (P/DAMP-count - 10) 0)]]
    [set activated-inflammasome? FALSE]]
  [set activated-inflammasome? FALSE]

  ;; inflammasome priming:
  ifelse NLRP-count > 3 and not (random element-of-stochasticity = 0) ;; 3 arbitrary
  [set primed-inflammasome? TRUE]
  [set primed-inflammasome? FALSE]

  ;; type 1 ISGs activated:
  ifelse JAKSTAT-pathway-count > 3 and not (random element-of-stochasticity = 0) ;; 2 arbitrary
  [set type1ISG-active? TRUE]
  [set type1ISG-active? FALSE]

  ;; JAK-STAT pathway activation: effect of type1IFN
  ifelse type1IFN-count >= 10 and not (random element-of-stochasticity = 0)
  [set JAKSTAT-pathway-count min list (JAKSTAT-pathway-count + 1) 5
    if type1IFN-count >= 10 [set type1IFN-count type1IFN-count - 10]]
  [set JAKSTAT-pathway-count max (list (JAKSTAT-pathway-count - 1) 0)]

  ;; pro-inflammatory cytokines and NLRP production:
  ifelse NFκB/AP1-active? = TRUE and not (random element-of-stochasticity = 0)
  [set RANTES-count RANTES-count + 1 ;; could alter outputs (not just all +1)
    set MCP1-count MCP1-count + 1
    set TGFβ-count TGFβ-count + 1
    set TNFα-count TNFα-count + 1
    set IL8-count IL8-count + 1
    set NLRP-count min (list (NLRP-count + 1) 5)]
  [ifelse duck? = TRUE or chicken-NLRP-expression-ubiquitous = FALSE
    [set NLRP-count max (list (NLRP-count - 1) 0)] ;; degradation of NLRP without stimulation
    [set NLRP-count max (list (NLRP-count - 1) 2)]] ;; 2 arbitrary ; differentiates duck/chicken metabolisms

  ;; NFκB/AP1 activation: TLRs and extracellular TNFα
  ifelse (TLR-active? = TRUE or TNFα-count >= 10) and not (random element-of-stochasticity = 0)
  [set NFκB/AP1-active? TRUE
    if TNFα-count >= 10 [set TNFα-count TNFα-count - 10]]
  [set NFκB/AP1-active? FALSE]

  ;; IRF7 activation: RIG-I and MDA5
  ifelse (RIGI-active? = TRUE or (MDA5-active? = TRUE and random 4 = 0)) and not (random element-of-stochasticity = 0)
  [set IRF7-active? TRUE]
  [set IRF7-active? FALSE]

  ;; PRR activation: effect of intracellular virus particles
  ifelse sensitivity-to-infection < intracellular-virus-count and not (random element-of-stochasticity = 0)
    [set MDA5-active? TRUE]
    [set MDA5-active? FALSE]

  ifelse sensitivity-to-infection < intracellular-virus-count and not (random element-of-stochasticity = 0)
    [set TLR-active? TRUE]
    [set TLR-active? FALSE]

  ifelse sensitivity-to-infection < intracellular-virus-count and not (random element-of-stochasticity = 0)
    [if duck? = TRUE or working-duRIGI-added-in-chicken = TRUE [set RIGI-active? TRUE]] ;; differentiating between chicken and duck metabolism
    [set RIGI-active? FALSE]

  ;; RIPK3 activation: effect of TNFα signalling and detection of intracellular virus
  ifelse (TNFα-count >= 10 or intracellular-virus-count > sensitivity-to-infection) and not (random element-of-stochasticity = 0)
  [set RIPK3-active? TRUE
    if TNFα-count >= 10 [set TNFα-count TNFα-count - 10]]
  [set RIPK3-active? FALSE]

  ;; should cell be infected?
  if cell-infection-threshold < extracellular-virus-count and not (random element-of-stochasticity = 0)
  [let q random (cell-infection-threshold) + 1
    set intracellular-virus-count intracellular-virus-count + q ;; at leats one extracellular virus particles can infect per tick
    set extracellular-virus-count extracellular-virus-count - q
    set color 48 ;; yellow
  ]

  ;; updating epithelial variables with the placeholder local variables in this tick/run of the procedure
  set type1IFN-count type1IFN-count + type1IFN-produced-within-tick
  set extracellular-virus-count extracellular-virus-count + extracellular-virus-shed-within-tick
  set intracellular-virus-count intracellular-virus-count + intracellular-virus-synthesised-within-tick
end


to macrophage-function
  ;; Must work backwards through the cell's metabolism within one tick
  ;; Most of the time arbitrarily outputting +1 metabolites, -0.1/-1 consuming metabolites

  ;; (1) Macrophage infection metabolism
  ;; (2) Macrophage phagocytosis metabolism
  ;; (3) Macrophage movement

  ;; (1) Macrophage infection metabolism

  ;; check if epi dead
  if cell-death-status > 0
  [set P/DAMP-count P/DAMP-count + 1
  if cell-death-status = 1 ;; cell apoptotis but not pyroptosed
    [ifelse necrosis-count > 200 and not (random element-of-stochasticity = 0)
      [set cell-death-status 2
        set color 6 ;; grey
        set P/DAMP-count P/DAMP-count + 10
        set extracellular-virus-count extracellular-virus-count + (min list (50 + random 10) (intracellular-virus-count * 0.5))]
      [set necrosis-count necrosis-count + 1]]
  stop]

  ;; check if epi should die from non-necrosis lytic cell death - viral budding, ROS dmagae, lytic apoptosis, unprogrammed lysis
  if (ROS-damage-count >= ROS-damage-threshold) or (cell-membrane < 1) or (lytic-apoptosis-count > lytic-apoptosis-threshold) or (unprogrammed-lysis-count > unprogrammed-lysis-threshold)
  [set cell-death-status 4
    set color 6 ;; grey
    set P/DAMP-count P/DAMP-count + 10
    set extracellular-virus-count extracellular-virus-count + (min list (50 + random 10) (intracellular-virus-count * 0.5))
    ;; are any other signals emitted with these forms of cell death??
    stop]

  ;; check if epi should die from apoptosis
  ;; if apoptosis-count and necrosis-count both greater than their thresholds then randomly choose one of the two processes to occur
  ifelse (apoptosis-count > apoptosis-threshold and necrosis-count <= necrosis-threshold) or (apoptosis-count > apoptosis-threshold and random 2 = 0)
  [set cell-death-status 1
    set necrosis-count 0 ;; used to count if dead apoptotic cell needs to change to necrotic cell
    set color 6 ;; grey
    stop]
  ;; check if epi should die from necrosis
  [if necrosis-count > necrosis-threshold
  [set cell-death-status 2
    set color 6 ;; grey
    set P/DAMP-count P/DAMP-count + 10
    set extracellular-virus-count extracellular-virus-count + (min list (50 + random 10) (intracellular-virus-count * 0.5))
      stop]]

  ;; setting cell death pathway counts
  if activated-inflammasome? = TRUE
  [set IL18-count IL18-count + 1] ;; no pyroptosis in aves, significant inflammatory cytokine production in macrophages

  ifelse caspase8/9-active? = TRUE and not (random element-of-stochasticity = 0)
  [set apoptosis-count apoptosis-count + 1]
  [set apoptosis-count max (list (apoptosis-count - 1) 0)] ;; degradation of cell death pathway counts/activation

  ifelse caspase8/9-active? = TRUE and not (random element-of-stochasticity = 0)
  [set lytic-apoptosis-count lytic-apoptosis-count + 1]
  [set lytic-apoptosis-count max (list (lytic-apoptosis-count - 1) 0)] ;; degradation of cell death pathway counts/activation

  ifelse MLKL-active? = TRUE and not (random element-of-stochasticity = 0)
  [set necrosis-count necrosis-count + 1]
  [set necrosis-count max (list (necrosis-count - 1) 0)] ;; degradation of cell death pathway counts/activation

  ;; activating caspase-8/9
  ;; activating MLKL
  ifelse RIPK3-active? = TRUE and not (random element-of-stochasticity = 0)
  [set caspase8/9-active? TRUE
    set MLKL-active? TRUE
    set unprogrammed-lysis-count unprogrammed-lysis-count + 1]
  [set caspase8/9-active? FALSE
    set MLKL-active? FALSE
    set unprogrammed-lysis-count max (list (unprogrammed-lysis-count - 1) 0)]

  ;; viral shedding
  let extracellular-virus-shed-within-tick 0

  ifelse intracellular-virus-count >= virus-infection-threshold and not (random element-of-stochasticity = 0) ;; viral budding above a certain no. intracellular particles
  [ifelse type1ISG-active? = TRUE
    [if random 4 < 3 ;; want less AIV budding with active type1ISGs = 0.75% chance of budding
      [ifelse intracellular-virus-count > virus-released-in-one-tick
        [set extracellular-virus-shed-within-tick virus-released-in-one-tick ;; more than one virus buds / tick? instead a % of the intracellular-virus-count?
          set cell-membrane cell-membrane - virus-released-in-one-tick
          set intracellular-virus-count intracellular-virus-count - virus-released-in-one-tick]
        [set extracellular-virus-shed-within-tick (intracellular-virus-count - 1) ;; more than one virus buds / tick? instead a % of the intracellular-virus-count?
          set cell-membrane cell-membrane - (intracellular-virus-count - 1)
          set intracellular-virus-count intracellular-virus-count - (intracellular-virus-count - 1)]]]
    [ifelse intracellular-virus-count > virus-released-in-one-tick
        [set extracellular-virus-shed-within-tick virus-released-in-one-tick ;; more than one virus buds / tick? instead a % of the intracellular-virus-count?
          set cell-membrane cell-membrane - virus-released-in-one-tick
          set intracellular-virus-count intracellular-virus-count - virus-released-in-one-tick]
        [set extracellular-virus-shed-within-tick (intracellular-virus-count - 1) ;; more than one virus buds / tick? instead a % of the intracellular-virus-count?
          set cell-membrane cell-membrane - (intracellular-virus-count - 1)
        set intracellular-virus-count intracellular-virus-count - (intracellular-virus-count - 1)]]]
  [set extracellular-virus-shed-within-tick 0]

  ;; intracellular virus replication from nuclear vRNPs
  set intracellular-virus-synthesised-within-tick 0 ; variable prevents viruses synthesised in this tick affecting other processes/calculations below

  ifelse type1ISG-active? = TRUE and not (random element-of-stochasticity = 0) ;; reduced viral replication with active type 1 ISGs
  [set intracellular-virus-synthesised-within-tick (floor (nucleus-vRNP-count * 0.75)) * virus-replication-rate]
  [set intracellular-virus-synthesised-within-tick nucleus-vRNP-count * virus-replication-rate] ;; intracellular-virus-synthesised-within-tick added onto intracellular-virus-count at the end of epithelial-cell-function

  ;; AIV replication: transport of vRNPs into nucleus
  ifelse not (random element-of-stochasticity = 0) and intracellular-virus-count >= 1
  [if type1ISG-active? = TRUE and RIGI-active? = TRUE ;; inhibitory effect of type1ISGs and RIG-I on viral replication
    [set nucleus-vRNP-count 0.25]
  if type1ISG-active? = TRUE xor RIGI-active? = TRUE
    [set nucleus-vRNP-count 0.50]
  if type1ISG-active? = FALSE and RIGI-active? = FALSE
    [set nucleus-vRNP-count 1]]
  [set nucleus-vRNP-count 0]

  ;; type1IFN production:
  let type1IFN-produced-within-tick 0

  if (IRF7-active? = TRUE or type1ISG-active? = TRUE) and not (random element-of-stochasticity = 0)
  [set type1IFN-produced-within-tick 1]

  ;; inflammasome activation: extracellular P/DAMP + intracellular JAK-STAT signalling pathway
  ifelse primed-inflammasome? = TRUE and not (random element-of-stochasticity = 0)
  [ifelse P/DAMP-count >= 10 or MDA5-active? = TRUE or RIGI-active? = TRUE ;; 10 arbitrary
    [set activated-inflammasome? TRUE
      if P/DAMP-count >= 10 [set P/DAMP-count max (list (P/DAMP-count - 10) 0)]]
    [set activated-inflammasome? FALSE]]
  [set activated-inflammasome? FALSE]

  ;; inflammasome priming:
  ifelse NLRP-count > 3 and not (random element-of-stochasticity = 0) ;; 3 arbitrary
  [set primed-inflammasome? TRUE]
  [set primed-inflammasome? FALSE]

  ;; type 1 ISGs activated:
  ifelse JAKSTAT-pathway-count > 3 and not (random element-of-stochasticity = 0) ;; 2 arbitrary
  [set type1ISG-active? TRUE]
  [set type1ISG-active? FALSE]

  ;; JAK-STAT pathway activation: effect of type1IFN
  ifelse type1IFN-count >= 10 and not (random element-of-stochasticity = 0)
  [set JAKSTAT-pathway-count min list (JAKSTAT-pathway-count + 1) 5
    if type1IFN-count >= 10 [set type1IFN-count type1IFN-count - 10]]
  [set JAKSTAT-pathway-count max (list (JAKSTAT-pathway-count - 1) 0)]

  ;; pro-inflammatory cytokines and NLRP production:
  ifelse NFκB/AP1-active? = TRUE and not (random element-of-stochasticity = 0)
  [set RANTES-count RANTES-count + 1 ;; could alter outputs (not just all +1)
    set MCP1-count MCP1-count + 1
    set TNFα-count TNFα-count + 1
    set IL6-count IL6-count + 1
    set MCP3-count MCP3-count + 1
    set MIP1-count MIP1-count + 1
    set MIP3-count MIP3-count + 1
    set NLRP-count min (list (NLRP-count + 1) 5)]
  [ifelse duck? = TRUE or chicken-NLRP-expression-ubiquitous = FALSE
    [set NLRP-count max (list (NLRP-count - 1) 0)] ;; degradation of NLRP without stimulation
    [set NLRP-count max (list (NLRP-count - 1) 2)]] ;; 2 arbitrary ; differentiates duck/chicken metabolisms

  ;; NFκB/AP1 activation: TLRs and extracellular TNFα
  ifelse (TLR-active? = TRUE or TNFα-count >= 10) and not (random element-of-stochasticity = 0)
  [set NFκB/AP1-active? TRUE
    if TNFα-count >= 10 [set TNFα-count TNFα-count - 10]]
  [set NFκB/AP1-active? FALSE]

  ;; IRF7 activation: RIG-I and MDA5
  ifelse (RIGI-active? = TRUE or (MDA5-active? = TRUE and random 4 = 0)) and not (random element-of-stochasticity = 0)
  [set IRF7-active? TRUE]
  [set IRF7-active? FALSE]

  ;; PRR activation: effect of intracellular virus particles
  ifelse sensitivity-to-infection < intracellular-virus-count and not (random element-of-stochasticity = 0)
    [set MDA5-active? TRUE]
    [set MDA5-active? FALSE]

  ifelse sensitivity-to-infection < intracellular-virus-count and not (random element-of-stochasticity = 0)
    [set TLR-active? TRUE]
    [set TLR-active? FALSE]

  ifelse sensitivity-to-infection < intracellular-virus-count and not (random element-of-stochasticity = 0)
    [if duck? = TRUE or working-duRIGI-added-in-chicken = TRUE [set RIGI-active? TRUE]] ;; differentiating between chicken and duck metabolism
    [set RIGI-active? FALSE]

  ;; RIPK3 activation: effect of TNFα signalling and detection of intracellular virus
  ifelse (TNFα-count >= 10 or intracellular-virus-count > sensitivity-to-infection) and not (random element-of-stochasticity = 0)
  [set RIPK3-active? TRUE
    if TNFα-count >= 10 [set TNFα-count TNFα-count - 10]]
  [set RIPK3-active? FALSE]

  ;; should cell be infected?
  if cell-infection-threshold < extracellular-virus-count and not (random element-of-stochasticity = 0)
  [let q random (cell-infection-threshold) + 1
    set intracellular-virus-count intracellular-virus-count + q ;; minimum one extracellular virus infects per tick
    set extracellular-virus-count extracellular-virus-count - q]

  ;; updating epithelial variables with the placeholder local variables in this tick/run of the procedure
  set type1IFN-count type1IFN-count + type1IFN-produced-within-tick
  set extracellular-virus-count extracellular-virus-count + extracellular-virus-shed-within-tick
  set intracellular-virus-count intracellular-virus-count + intracellular-virus-synthesised-within-tick


  ;; (2) Macrophage phagocytosis metabolism
  ;; If macrophage is phagocytosing, activate the PRRs
  if phagocytosing? = TRUE and not (random element-of-stochasticity = 0)
  [set NFκB/AP1-active? TRUE]
  if phagocytosing? = TRUE and not (random element-of-stochasticity = 0)
  [set IRF7-active? TRUE]

  ;; If macrophage is phagocytosing, then it produces ROS
  if phagocytosing? = TRUE and not (random element-of-stochasticity = 0)
  [set ROS-count ROS-count + 1]

  ;; If macrophage is phagocytosing, then it produces IP-10
  if phagocytosing? = TRUE and not (random element-of-stochasticity = 0)
  [set IP10-count IP10-count + 1]

  ;; Phagocytosis of infected epithelial cell and/or dead epithelial cell and/or extracellular virus on current patch
  ifelse (count epithelial-cells-here with [cell-death-status > 0 or intracellular-virus-count > 10] > 0 or extracellular-virus-count > 0) and capacity-for-phagocytosis < maximum-capacity-for-phagocytosis ;and activated? = TRUE
  [set capacity-for-phagocytosis max list 0 (capacity-for-phagocytosis + count (epithelial-cells-here with [cell-death-status > 0 or intracellular-virus-count > 10]) + extracellular-virus-count / 50 - phagocytosis-recovery-rate)
    set phagocytosing? TRUE
    ask epithelial-cells-here
    [if cell-death-status > 0 [die]
      if intracellular-virus-count > 10 [die]]]
  [set phagocytosing? FALSE
  set capacity-for-phagocytosis max list 0 (capacity-for-phagocytosis - phagocytosis-recovery-rate)]

  ifelse intracellular-virus-count > 0
  [ifelse capacity-for-phagocytosis < maximum-capacity-for-phagocytosis
    [set color 67] ;; green = infected but not reached maximum phagocytosis capacity
    [set color 36]] ;; brown = infected and reached maximum phagocytosis capacity
  [ifelse (capacity-for-phagocytosis < maximum-capacity-for-phagocytosis)
    [set color 114] ;; violet = not infected and not reached maximum phagocytosis capacity
    [set color 125]] ;; magenta = not infected and reached maximum phagocytosis capacity

  ;; Activation of macrophage for phagocytosis
  ;ifelse P/DAMP-count >= 1
  ;[set activated? TRUE]
  ;[set activated? FALSE]

  ;; (3) Macrophage movement
  ;; Macrophage chemotaxins: RANTES, MCP-1, IL-8 (better known as a neutrophil chemotaxin)
  let x max-one-of neighbors [RANTES-count + MCP1-count + IL8-count]

  ifelse [RANTES-count + MCP1-count + IL8-count] of x > [RANTES-count + MCP1-count + IL8-count] of self and [RANTES-count + MCP1-count + IL8-count] of x != 0
  [face x
    forward 0.2
    ;; check for other macrophages on the patch already
    if count macrophages-here > 1 and any? macrophages-here with [cell-death-status = 0]
    [left (45 - random 91)
      forward 1]]
  [left (45 - random 91)
  forward 1]

end


to patch-background-function ;; may need to scale these variables differently
  if background-variable = "extracellular-virus-count"
  [ask patches
    [set pcolor scale-color red extracellular-virus-count 0 (initial-extracellular-virus-count * 2)]]

  if background-variable = "P/DAMP-count"
  [ask patches
    [set pcolor scale-color red P/DAMP-count 0 100]]

  if background-variable = "ROS-count"
  [ask patches
    [set pcolor scale-color red ROS-count 0 10]]

  if background-variable = "TNFα-count"
  [ask patches
    [set pcolor scale-color red TNFα-count 0 10]]

  if background-variable = "type1IFN-count"
  [ask patches
    [set pcolor scale-color red type1IFN-count 0 10]]

  if background-variable = "RANTES-count"
  [ask patches
    [set pcolor scale-color red RANTES-count 0 10]]

  if background-variable = "MCP1-count"
  [ask patches
    [set pcolor scale-color red MCP1-count 0 10]]

  if background-variable = "TGFβ-count"
  [ask patches
    [set pcolor scale-color red TGFβ-count 0 10]]

  if background-variable = "IL8-count"
  [ask patches
    [set pcolor scale-color red IL8-count 0 10]]

  if background-variable = "IL18-count"
  [ask patches
    [set pcolor scale-color red IL18-count 0 5]]

    if background-variable = "IL6-count"
  [ask patches
    [set pcolor scale-color red IL6-count 0 5]]

    if background-variable = "MCP3-count"
  [ask patches
    [set pcolor scale-color red MCP3-count 0 5]]

    if background-variable = "MIP1-count"
  [ask patches
    [set pcolor scale-color red MIP1-count 0 5]]

    if background-variable = "MIP3-count"
  [ask patches
    [set pcolor scale-color red MIP3-count 0 5]]

    if background-variable = "IP10-count"
  [ask patches
    [set pcolor scale-color red IP10-count 0 5]]
end


to diffuse-function
  diffuse extracellular-virus-count 0.1 ;; could tailor these diffuse values for each molecule
  diffuse P/DAMP-count 0.1
  diffuse ROS-count 0.1
  diffuse TNFα-count 0.1
  diffuse type1IFN-count 0.1
  diffuse RANTES-count 0.1
  diffuse MCP1-count 0.1
  diffuse TGFβ-count 0.1
  diffuse IL8-count 0.1
  diffuse IL18-count 0.1
  diffuse IL6-count 0.1
  diffuse MCP3-count 0.1
  diffuse MIP1-count 0.1
  diffuse MIP3-count 0.1
  diffuse IP10-count 0.1
end


to evaporate-function
  set P/DAMP-count P/DAMP-count * 0.9
  set ROS-count ROS-count * 0.9
  set TNFα-count TNFα-count * 0.9
  set type1IFN-count type1IFN-count * 0.9
  set RANTES-count RANTES-count * 0.9
  set MCP1-count MCP1-count * 0.9
  set TGFβ-count TGFβ-count * 0.9
  set IL8-count IL8-count * 0.9
  set IL18-count IL18-count * 0.9
  set IL6-count IL6-count * 0.9
  set MCP3-count MCP3-count * 0.9
  set MIP1-count MIP1-count * 0.9
  set MIP3-count MIP3-count * 0.9
  set IP10-count IP10-count * 0.9
end


to cleanup-function
  if extracellular-virus-count < 1
  [set extracellular-virus-count 0]

  if P/DAMP-count < 1
  [set P/DAMP-count 0]

  if ROS-count < 0.1
  [set ROS-count 0]

  if TNFα-count < 0.1
  [set TNFα-count 0]

  if type1IFN-count < 0.1
  [set type1IFN-count 0]

  if RANTES-count < 0.1
  [set RANTES-count 0]

  if MCP1-count < 0.1
  [set MCP1-count 0]

  if TGFβ-count < 0.1
  [set TGFβ-count 0]

  if IL8-count < 0.1
  [set IL8-count 0]

  if IL18-count < 0.1
  [set IL8-count 0]

  if IL6-count < 0.1
  [set IL8-count 0]

  if MCP3-count < 0.1
  [set IL8-count 0]

  if MIP1-count < 0.1
  [set IL8-count 0]

  if MIP3-count < 0.1
  [set IL8-count 0]

  if IP10-count < 0.1
  [set IL8-count 0]
end
@#$#@#$#@
GRAPHICS-WINDOW
351
10
788
448
-1
-1
13.0
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

SWITCH
9
50
139
83
random-seed?
random-seed?
1
1
-1000

SLIDER
145
50
339
83
user-random-seed
user-random-seed
0
1000
10.0
1
1
NIL
HORIZONTAL

BUTTON
104
10
159
43
NIL
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
164
10
219
43
NIL
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

BUTTON
224
10
279
43
go-one
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
793
10
843
55
Days
total-days
0
1
11

MONITOR
839
10
889
55
Hours
total-hours
0
1
11

SLIDER
9
295
179
328
ROS-damage-threshold
ROS-damage-threshold
0
100
20.0
1
1
NIL
HORIZONTAL

SLIDER
9
334
180
367
cell-infection-threshold
cell-infection-threshold
1
100
5.0
1
1
NIL
HORIZONTAL

SWITCH
9
10
99
43
duck?
duck?
1
1
-1000

PLOT
794
113
1112
326
Epithelial cells
t (hrs)
% of epithelial cells
0.0
10.0
0.0
100.0
true
true
"" ""
PENS
"Generally dead" 1.0 0 -16777216 true "" "plot 100 * (total-dead-epis / (((2 * grid-size) + 1) ^ 2))"
"Apoptosed" 1.0 0 -5825686 true "" "plot 100 * (total-apoptosed-epis / (((2 * grid-size) + 1) ^ 2))"
"Necroptosed" 1.0 0 -10899396 true "" "plot 100 * (total-necroptosed-epis / (((2 * grid-size) + 1) ^ 2))"
"Infected" 1.0 0 -4079321 true "" "plot 100 * (total-infected-epis / (((2 * grid-size) + 1) ^ 2))"
"Undefined lysis" 1.0 0 -7500403 true "" "plot 100 * (total-undefined-lysed-epis / (((2 * grid-size) + 1) ^ 2))"
"Phagocytosed epis" 1.0 0 -2674135 true "" "ifelse ticks = 0\n[plot 0]\n[plot 100 * total-phagocytosed-epis / ((grid-size * 2 + 1) ^ 2)]"

SLIDER
9
374
166
407
sensitivity-to-infection
sensitivity-to-infection
1
100
3.0
1
1
NIL
HORIZONTAL

SLIDER
9
414
221
447
virus-infection-threshold
virus-infection-threshold
1
100
10.0
1
1
NIL
HORIZONTAL

SLIDER
175
178
331
211
necrosis-threshold
necrosis-threshold
1
100
40.0
1
1
NIL
HORIZONTAL

SLIDER
9
178
166
211
apoptosis-threshold
apoptosis-threshold
1
100
40.0
1
1
NIL
HORIZONTAL

SLIDER
9
217
231
250
lytic-apoptosis-threshold
lytic-apoptosis-threshold
1
200
80.0
1
1
NIL
HORIZONTAL

CHOOSER
9
89
136
134
background-variable
background-variable
"extracellular-virus-count" "P/DAMP-count" "ROS-count" "TNFα-count" "type1IFN-count" "RANTES-count" "MCP1-count" "TGFβ-count" "IL8-count" "IL18-count" "IL6-count" "MCP3-count" "MIP1-count" "MIP3-count" "IP10-count"
0

BUTTON
145
96
207
129
hide epis
ask epithelial-cells [ht]
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
213
96
280
129
show epis
ask epithelial-cells [set hidden? FALSE]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
9
454
197
487
virus-replication-rate
virus-replication-rate
1
20
2.0
1
1
NIL
HORIZONTAL

PLOT
1118
113
1369
326
Extracellular molecules
NIL
Total molecules
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"TNFα" 1.0 0 -2674135 true "" "plot total-TNFα"
"type1-IFN" 1.0 0 -13345367 true "" "plot total-type1IFN\n"
"RANTES" 1.0 0 -6459832 true "" "plot total-RANTES"
"MCP-1" 1.0 0 -8630108 true "" "plot total-MCP1"
"IL-8" 1.0 0 -1184463 true "" "plot total-IL8"
"TGF-β" 1.0 0 -10899396 true "" "plot total-TGFβ"

PLOT
1117
330
1368
521
Extracellular molecules 2
NIL
Total molecules
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"P/DAMP" 1.0 0 -955883 true "" "plot total-P/DAMP"
"ROS" 1.0 0 -7500403 true "" "plot total-ROS"
"IL-18" 1.0 0 -10899396 true "" "plot sum [IL18-count] of patches"

PLOT
794
330
1113
521
Virus particles
NIL
Total particles
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Intracellular" 1.0 0 -16777216 true "" "plot sum [intracellular-virus-count] of turtles with [cell-death-status = 0]"
"Extracellular" 1.0 0 -7500403 true "" "plot sum [extracellular-virus-count] of patches"

BUTTON
9
140
127
173
Default values
set cell-infection-threshold 5\nset sensitivity-to-infection 3\nset virus-released-in-one-tick 10\n\nset ROS-damage-threshold 20\nset lytic-apoptosis-threshold 80\nset unprogrammed-lysis-threshold 80\nset apoptosis-threshold 40\nset necrosis-threshold 40\n\nset virus-infection-threshold 10\nset virus-replication-rate 2\n\nset chicken-NLRP-expression-ubiquitous TRUE\nset working-duRIGI-added-in-chicken FALSE\n\nset initial-extracellular-virus-count 50\nset all-patches-initially-infected FALSE\n\nset element-of-stochasticity 20\n\nset initial-number-of-macrophages 25
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
351
455
533
500
Number of Alive Epithelial Cells
count epithelial-cells with [cell-death-status = 0]
17
1
11

SLIDER
350
525
579
558
Initial-extracellular-virus-count
Initial-extracellular-virus-count
1
500
50.0
1
1
NIL
HORIZONTAL

MONITOR
894
10
1003
55
intracellular virus
sum [intracellular-virus-count] of turtles with [cell-death-status = 0]
17
1
11

MONITOR
894
61
1003
106
extracellular virus
sum [extracellular-virus-count] of patches
17
1
11

MONITOR
540
455
727
500
Number of Dead Epithelial Cells
count epithelial-cells with [cell-death-status != 0]
17
1
11

SLIDER
9
256
231
289
unprogrammed-lysis-threshold
unprogrammed-lysis-threshold
1
200
80.0
1
1
NIL
HORIZONTAL

SWITCH
350
566
611
599
chicken-NLRP-expression-ubiquitous
chicken-NLRP-expression-ubiquitous
0
1
-1000

SWITCH
617
566
888
599
working-duRIGI-added-in-chicken
working-duRIGI-added-in-chicken
1
1
-1000

TEXTBOX
353
507
503
525
Experimental conditions:
12
0.0
0

SWITCH
586
525
819
558
all-patches-initially-infected
all-patches-initially-infected
1
1
-1000

TEXTBOX
10
538
160
556
Model features:
12
0.0
1

SLIDER
9
558
211
591
Element-of-stochasticity
Element-of-stochasticity
1
100
20.0
1
1
NIL
HORIZONTAL

SLIDER
169
374
348
407
virus-released-in-one-tick
virus-released-in-one-tick
1
50
10.0
1
1
NIL
HORIZONTAL

SLIDER
9
495
261
528
Initial-number-of-macrophages
Initial-number-of-macrophages
0
100
25.0
1
1
NIL
HORIZONTAL

MONITOR
1007
10
1079
55
type1-IFNs
sum [type1IFN-count] of patches
17
1
11

MONITOR
1008
61
1061
106
RANTES
sum [RANTES-count] of patches
17
1
11

MONITOR
1084
10
1134
55
TNFα
sum [TNFα-count] of patches
17
1
11

MONITOR
1065
61
1115
106
MCP-1
sum [MCP1-count] of patches
17
1
11

MONITOR
1119
61
1169
106
IL-8
sum [il8-count] of patches
17
1
11

MONITOR
1138
10
1199
55
P/DAMPs
sum [P/DAMP-count] of patches
17
1
11

MONITOR
1172
61
1222
106
TGFβ
sum [TGFβ-count] of patches
17
1
11

MONITOR
1204
10
1254
55
ROS
sum [ROS-count] of patches
17
1
11

MONITOR
1227
61
1277
106
IL-18
sum [IL18-count] of patches
17
1
11

MONITOR
793
61
891
106
NIL
total-continuous-days
17
1
11

@#$#@#$#@
## WHAT IS IT?

Model name: avian innate immune response agent-based model (AIIRABM)

Purpose: Simulates the epithelial cells and macrophages of the innate immune response in chickens and ducks. The two molecular differences modelled in the AIIRABM are:

1. The absence of retinoic acid-inducible gene-I (RIG-I) in the chicken pattern recognition receptors
2. Greater NLRP expression in the chicken system than in the duck system

## HOW TO USE THE AIIRABM

The  World  view is a 33 x 33 square grid in the middle of the User Interface. The agent shapes seen on the view corrospond to:

Blue Square = uninfected epithelial cell
Yellow Square = infected epithelial cell
Grey Square = dead epithelial cell
Grey Petal = dead apoptotic epithelial cell
Violet Triangle = uninfected macrophage, not reached maximum phagocytosis capacity
Magenta Triangle = uninfected macrophage, reached maximum phagocytosis capacity
Green Triangle = infected macrophage, not reached maximum phagocytosis capacity
Brown Triangle = infected macrophage, reached maximum phagocytosis capacity
Grey Triangle = dead macrophage

With 'setup' each of the world-space grids is filled with an unifected epithelial cell (Blue Square). When dead Epithelial Cells of both types are cleared by phagocytosis what remains is black space. The levels of extracellular virus and different molecular mediators can be seen in the world view's background behind the epithelial cells. The more extracellular virus or molecular mediation present on a grid space the greater degree of red in the grid's background; a black background represents minimal extracellular virus/molecular mediator, white represents maximal. For a clearer view of the grid's background colour epithelial cells can be hidden using the 'hide epis' button.

The green sliders and switches in the Interface tab enable the user to change key parameter values in the AIIRABM. The user must press the 'setup' button each time they want to update these key model parameters. The 'go' button starts the model. The 'go-one' button moves a model simulation on by one tick.

The sandy coloured monitors and plots display updates of key values in the model for the current tick.

## HOW TO CHANGE THE INTERACTION TYPE BETWEEN RIG-I AND MDA5

The interaction between RIG-I and MDA5 is currently modelled as functionally redundant in activating IRF7, and that RIG-I is a better IRF7 activator. This interaction is modelled by the line 'ifelse (RIGI-active? = TRUE or (MDA5-active? = TRUE and random 4 = 0)) and not (random element-of-stochasticity = 0)' from the 'IRF7 activation' section in “to epithelial-cell-function” and “to macrophage-function”.

To model RIG-I and MDA5 as functionally redundant and equally good at
activating IRF7 the line of code was replaced with 'ifelse (RIGI-active? = TRUE or MDA5-active? = TRUE) and not (random element-of-stochasticity = 0)'.

To model the RIG-I and MDA5 interaction as having a synergistic effect and both equally good at activating IRF7 the line of code was replaced with 'ifelse (((RIGI-active? = TRUE xor MDA5-active? = TRUE) and not (random 2 * element-of-stochasticity = 0)) or ((RIGI-active? = TRUE and MDA5-active? = TRUE) and not (random element-of-stochasticity = 0)))'.

## SIMULATION EXEPRIMENTS (Also see BehaviorSpace under the Tools tab)

Simulation experiments were run with the 'random-seed?' switch 'Off' and stochastic replicates achieved by incrementing the random number seed between 1 and 10. This enables specific runs to be traced.

The default values of the adjustable model parameters were used for all simulation experiments: 
cell-infection-threshold = 5
sensitivity-to-infection = 3
virus-released-in-one-tick = 10
ROS-damage-threshold = 20
lytic-apoptosis-threshold = 80
unprogrammed-lysis-threshold = 80
apoptosis-threshold = 40
necrosis-threshold = 40
virus-infection-threshold = 10
virus-replication-rate = 2
chicken-NLRP-expression-ubiquitous = TRUE
working-duRIGI-added-in-chicken = FALSE
initial-extracellular-virus-count = 50
all-patches-initially-infected = FALSE
element-of-stochasticity = 20
initial-number-of-macrophages = 25

Except initial-extracellular-virus-count was varied for its parameter sweep and working-duRIGI-added-in-chicken was TRUE for the in silico reinstatment of RIG-I into the chicken system.

## RELATED MODELS

Cockrell C, An G. Comparative Computational Modeling of the Bat and Human Immune Response to Viral Infection with the Comparative Biology Immune Agent Based Model. Viruses. 2021 Aug 16;13(8):1620. doi: 10.3390/v13081620. PMID: 34452484; PMCID: PMC8402910.

## CREDITS AND REFERENCES

The model can be downloaded at: https://github.com/An-Cockrell/Digital_Fowl
Author(s): T. E. Wood, G. C. An
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

petals
false
0
Circle -7500403 true true 117 12 66
Circle -7500403 true true 116 221 67
Circle -7500403 true true 41 41 67
Circle -7500403 true true 11 116 67
Circle -7500403 true true 41 191 67
Circle -7500403 true true 191 191 67
Circle -7500403 true true 221 116 67
Circle -7500403 true true 191 41 67
Circle -7500403 true true 60 60 180

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
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="Fig.6: AIIRABM parameter sweep of inoculum dose" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="720"/>
    <metric>total-extracellular-virus</metric>
    <metric>total-intracellular-virus</metric>
    <metric>total-dead-epis</metric>
    <metric>total-apoptosed-epis</metric>
    <metric>total-necroptosed-epis</metric>
    <metric>total-pyroptosed-epis</metric>
    <metric>total-infected-epis</metric>
    <metric>total-undefined-lysed-epis</metric>
    <metric>total-phagocytosed-epis</metric>
    <metric>total-P/DAMP</metric>
    <metric>total-ROS</metric>
    <metric>total-TNFα</metric>
    <metric>total-type1IFN</metric>
    <metric>total-TGFβ</metric>
    <metric>total-IL8</metric>
    <metric>total-RANTES</metric>
    <metric>total-MCP1</metric>
    <metric>total-dead-macros</metric>
    <metric>total-apoptosed-macros</metric>
    <metric>total-necroptosed-macros</metric>
    <metric>total-infected-macros</metric>
    <metric>total-undefined-lysed-macros</metric>
    <metric>total-continuous-days</metric>
    <metric>total-IL18</metric>
    <enumeratedValueSet variable="duck?">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Initial-extracellular-virus-count">
      <value value="10"/>
      <value value="50"/>
      <value value="100"/>
      <value value="150"/>
      <value value="200"/>
    </enumeratedValueSet>
    <steppedValueSet variable="user-random-seed" first="1" step="1" last="10"/>
    <enumeratedValueSet variable="apoptosis-threshold">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="necrosis-threshold">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="lytic-apoptosis-threshold">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="unprogrammed-lysis-threshold">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ROS-damage-threshold">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cell-infection-threshold">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sensitivity-to-infection">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="virus-released-in-one-tick">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="virus-infection-threshold">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="virus-replication-rate">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Initial-number-of-macrophages">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="all-patches-initially-infected">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="working-duRIGI-added-in-chicken">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chicken-NLRP-expression-ubiquitous">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Element-of-stochasticity">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Fig.3-5: AIIRABM at low initial inoculum" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="720"/>
    <metric>total-extracellular-virus</metric>
    <metric>total-intracellular-virus</metric>
    <metric>total-dead-epis</metric>
    <metric>total-apoptosed-epis</metric>
    <metric>total-necroptosed-epis</metric>
    <metric>total-pyroptosed-epis</metric>
    <metric>total-infected-epis</metric>
    <metric>total-undefined-lysed-epis</metric>
    <metric>total-phagocytosed-epis</metric>
    <metric>total-P/DAMP</metric>
    <metric>total-ROS</metric>
    <metric>total-TNFα</metric>
    <metric>total-type1IFN</metric>
    <metric>total-TGFβ</metric>
    <metric>total-IL8</metric>
    <metric>total-RANTES</metric>
    <metric>total-MCP1</metric>
    <metric>total-dead-macros</metric>
    <metric>total-apoptosed-macros</metric>
    <metric>total-necroptosed-macros</metric>
    <metric>total-infected-macros</metric>
    <metric>total-undefined-lysed-macros</metric>
    <metric>total-continuous-days</metric>
    <metric>total-IL18</metric>
    <enumeratedValueSet variable="duck?">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Initial-extracellular-virus-count">
      <value value="50"/>
    </enumeratedValueSet>
    <steppedValueSet variable="user-random-seed" first="1" step="1" last="10"/>
    <enumeratedValueSet variable="apoptosis-threshold">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="necrosis-threshold">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="lytic-apoptosis-threshold">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="unprogrammed-lysis-threshold">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ROS-damage-threshold">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cell-infection-threshold">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sensitivity-to-infection">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="virus-released-in-one-tick">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="virus-infection-threshold">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="virus-replication-rate">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Initial-number-of-macrophages">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="all-patches-initially-infected">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="working-duRIGI-added-in-chicken">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chicken-NLRP-expression-ubiquitous">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Element-of-stochasticity">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Fig.7: AIIRABM in silico RIG-I reinstatement in chicken" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="720"/>
    <metric>total-extracellular-virus</metric>
    <metric>total-intracellular-virus</metric>
    <metric>total-dead-epis</metric>
    <metric>total-apoptosed-epis</metric>
    <metric>total-necroptosed-epis</metric>
    <metric>total-pyroptosed-epis</metric>
    <metric>total-infected-epis</metric>
    <metric>total-undefined-lysed-epis</metric>
    <metric>total-phagocytosed-epis</metric>
    <metric>total-P/DAMP</metric>
    <metric>total-ROS</metric>
    <metric>total-TNFα</metric>
    <metric>total-type1IFN</metric>
    <metric>total-TGFβ</metric>
    <metric>total-IL8</metric>
    <metric>total-RANTES</metric>
    <metric>total-MCP1</metric>
    <metric>total-dead-macros</metric>
    <metric>total-apoptosed-macros</metric>
    <metric>total-necroptosed-macros</metric>
    <metric>total-infected-macros</metric>
    <metric>total-undefined-lysed-macros</metric>
    <metric>total-continuous-days</metric>
    <metric>total-IL18</metric>
    <enumeratedValueSet variable="duck?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Initial-extracellular-virus-count">
      <value value="50"/>
    </enumeratedValueSet>
    <steppedValueSet variable="user-random-seed" first="1" step="1" last="10"/>
    <enumeratedValueSet variable="apoptosis-threshold">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="necrosis-threshold">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="lytic-apoptosis-threshold">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="unprogrammed-lysis-threshold">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ROS-damage-threshold">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cell-infection-threshold">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sensitivity-to-infection">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="virus-released-in-one-tick">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="virus-infection-threshold">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="virus-replication-rate">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Initial-number-of-macrophages">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="all-patches-initially-infected">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="working-duRIGI-added-in-chicken">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chicken-NLRP-expression-ubiquitous">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Element-of-stochasticity">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Additional experiment: AIIRABM at low initial inoculum, no ubiquitous NLRP expression in chickens" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="720"/>
    <metric>total-extracellular-virus</metric>
    <metric>total-intracellular-virus</metric>
    <metric>total-dead-epis</metric>
    <metric>total-apoptosed-epis</metric>
    <metric>total-necroptosed-epis</metric>
    <metric>total-pyroptosed-epis</metric>
    <metric>total-infected-epis</metric>
    <metric>total-undefined-lysed-epis</metric>
    <metric>total-phagocytosed-epis</metric>
    <metric>total-P/DAMP</metric>
    <metric>total-ROS</metric>
    <metric>total-TNFα</metric>
    <metric>total-type1IFN</metric>
    <metric>total-TGFβ</metric>
    <metric>total-IL8</metric>
    <metric>total-RANTES</metric>
    <metric>total-MCP1</metric>
    <metric>total-dead-macros</metric>
    <metric>total-apoptosed-macros</metric>
    <metric>total-necroptosed-macros</metric>
    <metric>total-infected-macros</metric>
    <metric>total-undefined-lysed-macros</metric>
    <metric>total-continuous-days</metric>
    <metric>total-IL18</metric>
    <metric>total-NLRP</metric>
    <enumeratedValueSet variable="duck?">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Initial-extracellular-virus-count">
      <value value="50"/>
    </enumeratedValueSet>
    <steppedValueSet variable="user-random-seed" first="1" step="1" last="10"/>
    <enumeratedValueSet variable="apoptosis-threshold">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="necrosis-threshold">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="lytic-apoptosis-threshold">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="unprogrammed-lysis-threshold">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ROS-damage-threshold">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cell-infection-threshold">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sensitivity-to-infection">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="virus-released-in-one-tick">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="virus-infection-threshold">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="virus-replication-rate">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Initial-number-of-macrophages">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="all-patches-initially-infected">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="working-duRIGI-added-in-chicken">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chicken-NLRP-expression-ubiquitous">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Element-of-stochasticity">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
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
