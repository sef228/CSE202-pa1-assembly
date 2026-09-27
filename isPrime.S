.global isPrime
# n in %edi; result in %eax (1 = prime, 0 = not prime)
isPrime:
  cmpl $2, %edi #compare n with 2
  jl .Lprime_no # n < 2 is not prime 
  je .Lprime_yes #2 is prime

  testl $1, %edi #check the lowest bit
  jz .Lprime_no # even numbers than 2 aren't prime

  movl %edi, %r9d #save positive n as a 64- bit value
  movl $3, %ecx # i = 3

.Lprime_loop: 
  movq %rcx, %r8 #r8 = i
  imulq %rcx, %r8 # r8 = i * i
  cmpq %r9, %r8 # compare i * i with n 
  jg .Lprime_yes # if i*i > n no divisor was found 

  movl %edi, %eax # eax = n 
  cltd # prepare edx:eax for signed division 
  idivl %ecx # divide n by i remainder in edx 

  cmpl $0, %edx # is n %i == 0
  je .Lprime_no  #if so n has a divisor 

  addl $2, %ecx # is n % i == 0
  je .Lprime_no #if so n has a divisor

  addl $2, %ecx #i += 2 try the next odd divisor 

.Lprime_yes: 
  movl $1, %eax 
  ret

.Lprime_no:
  movl $0, %eax 
  
  ret


# int isPrime(int n){
#     if(n < 2)
#         return 0;
#     if(n % 2 == 0)
#         return n == 2;
#     /* only test odd divisors i while i*i <= n */
#     for(int i = 3; i * i <= n; i += 2){
#         if(n % i == 0)
#             return 0;
#     }
#     return 1;
# }
