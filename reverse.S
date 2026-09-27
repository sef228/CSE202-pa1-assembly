.global reverse
# list in %rdi (array of char*), n in %esi
reverse:
  movl $0, %ecx # i = 0
  movl %esi, %edx # Copy n
  shrl $1, %edx #edx = n/2 

.Lreverse_loop: 
  cmpl %edx, %ecx # Compare i with n/2
  jae .Lreverse_done # stop if i >= n/2

  movl %esi, %eax # eax = n
  subl %ecx, %eax # eax = n-i
  subl $1, %eax # eax =n - i - 1 

  movq (%rdi,%rcx,8), %r8 #temp = list[i]
  movq (%rdi,%rax, 8), %r9 #get list[n-i-1]

  movq %r9, (%rdi,%rcx, 8) #list[i] = list[n-i-1]
  movq %r8, (%rdi, %rax, 8) #list(n-i-1) = temp

  incl %ecx #i++
  jmp .Lreverse_loop

.Lreverse_done:
  retq


# void reverse(char **list, unsigned n){
#     unsigned i = 0;
#     while (i < n/2){
#      char *temp = list[i];
#      list[i] = list[n-i-1];
#      list[n-i-1] = temp;
#      i++;
#     }
# }
