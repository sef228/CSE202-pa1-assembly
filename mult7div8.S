.global mult7div8
# a in %dil (signed char), overflow pointer in %rsi; result in %eax
mult7div8:
  movsbl %dil, %ecx # extend a into a 32 bit pointer 

  movl %ecx, %eax # eax now stores a 
  sall $3, %eax # a * 8
  subl %ecx, %eax # 8a -a = 7a
  movsbl %al, %eax #Keep low byte, interpret as signed

  movb $0, (%rsi) # overflow = 0 at the start

  cmpl $0, %ecx # check original a
  jg .Lpositive_a
  jl .Lnegative_a
  jmp .Ldivide # a == 0

.Lpositive_a:
  cmpl $0, %eax 
  jl .Loverflow #a > 0 and mult < 0
  jmp .Ldivide 

.Lnegative_a:
  cmpl $0, %eax 
  jg .Loverflow # a < 0 and mult > 0
  jmp .Ldivide

.Loverflow:
  movb $1, (%rsi) # *overflow = 1

.Ldivide:
  cmpl $0, %eax
  jge .Lshift
  addl $7, %eax #negatives round towards 0

.Lshift:
  sarl $3, %eax #division by 8 as a correction 
  ret


# char mult7div8(char a, char *overflow){
#     char mult = (7 * a);
#     if(a > 0 && mult < 0 || a < 0 && mult > 0)
#       *overflow = 1;
#     else
#       *overflow = 0;
#     return mult/8;
# }
