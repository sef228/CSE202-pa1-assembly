.global gcd
# a in %edi, b in %esi; result in %eax
gcd:
    cmpl $0, %esi # Is b == 0
    je .Lgcd_base #return a

    movl %edi, %eax # eax = a
    cltd #extend eax into edx:eax
    idivl %esi #divide by b remainder in edx

    movl %esi, %edi # first argument = old b 
    movl %edx, %esi # second argument = a %b

    subq $8, %rsp #align stack before calling 
    call gcd # gcd(b, a %b)
    addq $8, %rsp

    retq
.Lgcd_base:
    movl %edi, %eax #return a
    retq



# greatest common divisor via Euclid's algorithm (recursive)
# int gcd(int a, int b){
#     if(b == 0)
#         return a;
#     /* recursive call */
#     return gcd(b, a % b);
# }
