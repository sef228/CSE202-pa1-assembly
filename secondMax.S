.global secondMax
# v1 in %di, v2 in %si, v3 in %dx, v4 in %cx  (signed 16-bit); result in %ax
secondMax:
  cmpw %si, %di # compare v1 and v2
  jge .Lsm_v1_larger # if v1 >= v2
  movw %si, %r8w # first v2
  movw %di, %ax # second = v1
  jmp .Lsm_check_v3

.Lsm_v1_larger:
  movw %di, %r8w # first = v1
  movw %si, %ax # second = v2

.Lsm_check_v3: 
  cmpw %r8w, %dx #compare v3 with first
  jg .Lsm_v3_largest 
  cmpw %ax, %dx # compare v3 with second 
  jle .Lsm_check_v4 # v3 <= second so keep both
  movw %dx, %ax # second = v3
  jmp .Lsm_check_v4

.Lsm_v3_largest: 
  movw %r8w, %ax # Old first becomes second 

  movw %dx, %r8w # first = v3

.Lsm_check_v4:
  cmpw %r8w, %cx # compare v4 with first 
  jg .Lsm_v4_largest 

  cmpw %ax, %cx #Compare v4 with second
  jle .Lsm_done #if v4 <= second, keep both
  movw %cx, %ax # second = v4
  jmp .Lsm_done

.Lsm_v4_largest:
  movw %r8w, %ax # old first becomes second 
  movw %cx, %r8w # first v4
.Lsm_done:
  retq

# short secondMax(short v1, short v2, short v3, short v4){
#     short first, second;
#     if(v1 >= v2){ first = v1; second = v2; }
#     else        { first = v2; second = v1; }
#     if(v3 > first)       { second = first; first = v3; }
#     else if(v3 > second) { second = v3; }
#     if(v4 > first)       { second = first; first = v4; }
#     else if(v4 > second) { second = v4; }
#     return second;
# }
