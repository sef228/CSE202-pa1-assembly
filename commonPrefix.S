.global commonPrefix
# a in %rdi, b in %rsi; result (prefix length) in %eax
commonPrefix:
  movl $0, %eax #n = 0

.Lprefix_loop:
  movb (%rdi,%rax), %dl # dl = a[n]
  cmpb $0, %dl # is a[n] null

  je .Lprefix_done 

  cmpb (%rsi,%rax), %dl #compare a[n] with b[n]
  jne .Lprefix_done #stop if they are different 

  incl %eax #n++
  jmp .Lprefix_loop #check the next character
.Lprefix_done:
  retq


# length of the longest common prefix of two null-terminated strings
# int commonPrefix(char *a, char *b){
#     int n = 0;
#     while(a[n] && a[n] == b[n])
#         n++;
#     return n;
# }
