library(dplyr)
library(stringr)

widebody = scan(what=character(), text="
A38
A35
A34
A33
A30
B78
B77
B74
B76
DC87
DC10
MD11
T154
")

single_aisle = scan(what=character(), text="
A32
A31
B71
B72
B73
B75
DC9
MD8
MD9
S320
")

regional_jets = scan(what=character(), text="
E13
E14
E17
E19
E45
E75S
CRJ1
CRJ2
CRJ7
CRJ9
J328
")

# gulfstreams, learjets, hawkers, bombardiers, etc
bizjets = scan(what=character(), text="
ASTR
BE4
C25B
C680
GLF
GAL
LJ2
LJ3
LJ4
LJ5
LJ6
LJ7
H25
HA4
HDJ
C50
C52
C55
C56
C75
CL6
CL3
G15
G28
GLE
GL5
GL6
EA5
E50
E54
E55
E35
F2T
FA1
FA5
FA7
FA8
F90
L29B
L35
SBR
WW24
")


regional_turboprops = scan(what=character(), text="
DH6
DH8
AT72
E12
SF34
")

# mix of single and dual engine recreational
general_aviation = scan(what=character(), text="
AC5
BE19
BE5
C17
C18
C206
C402
BE2
BE3
BE9
C208
BE9
DA4
M20
M32
M7
N8B
P180
P28
PA2
PA3
PAY
PC1
S180
S33
SR22
")

# A124? - might be a giant Russian transport plane
helicopters = scan(what=character(), text="
A109
A124
A139
B412
B429
EC35
HELI
HELO
S300
S76
SK76
")

make_re = function(prefixes) {
  paste0('^', paste(prefixes, collapse='|'))
}
equip_category = function(equip) {
  case_when(
    str_detect(equip, make_re(widebody)) ~ 'Wide body',
    str_detect(equip, make_re(single_aisle)) ~ 'Single aisle',
    str_detect(equip, make_re(bizjets)) ~ 'Biz jet',
    str_detect(equip, make_re(regional_jets)) ~ 'Regional jet',
    str_detect(equip, make_re(general_aviation)) ~ 'GA',
    str_detect(equip, make_re(regional_turboprops)) ~ 'Regional prop',
    str_detect(equip, make_re(helicopters)) ~ 'Helo',
    TRUE ~ 'Other'
  )
}

# Equipment types as a named list
equip_types = c(
  'Wide body',
  'Single aisle',
  'Biz jet',
  'Regional jet',
  'GA',
  'Regional prop',
  'Helo'
)

