.global area
# a in %edi, b in %esi, c in %edx; result in %eax
area:
    movl %edi, %eax # eax = a
    addl %esi, %eax 
    addl %edx, %eax #eax = a + b + C

    #divide by 2
    movl %eax, %r8d
    shrl $31, %r8d             # 1 if the sum is negative otherwise 0
    addl %r8d, %eax             # Correct rounding for negative sums
    sarl $1, %eax               # eax = p

    movl %eax, %r8d
    subl %edi, %r8d #r8d = p-a

    movl %eax, %r9d
    subl %esi, %r9d             # r9d = p - b

    movl %eax, %r10d
    subl %edx, %r10d            # r10d = p - c

    imull %r8d, %eax            # p * (p - a)
    imull %r9d, %eax            # Multiply by (p - b)
    imull %r10d, %eax           # Multiply by (p - c)

    movl %eax, %edi #argument for r_sqrt
    subq $8, %rsp #align stack before the call
    call r_sqrt 
    addq $8, %rsp #restore the stack
    retq

r_sqrt:
    cmpl $0, %edi 
    jl .Lsqrt_negative #if x < 0 return -1
    
    cmpl $2, %edi 
    jl .Lsqrt_base #if x < 2, return x

    pushq %rdi # saves the original x and it aligns the stack
    sarl $2, %edi # argument = x >> 2
    call r_sqrt
    popq %rdi #restores the originlal  and the stack 

    sall $1, %eax #small_cand = recursive result * 2
    leal 1(%rax), %edx #large_cand = small_cand + 1

    movl %edx, %ecx     
    imulq %rcx, %rcx # square using the 64 bit register
    movl %edi, %r8d # copy positive x, zero extending

    cmpq %r8, %rcx #compare large_cand squared with x
    jg .Lsqrt_done #if greater return small cand 

    movl %edx, %eax # return the large cand 

.Lsqrt_done:
    ret 

.Lsqrt_base: 
    movl %edi, %eax 
    ret 

.Lsqrt_negative: 
    movl $-1, %eax 
    ret




# int area(int a, int b, int c){
#     int p = (a + b + c)/2;
#     p = p * (p-a) * (p-b) * (p-c);
#     return sqrt(p);
# }
# calculate recursively the square root of an int (in C)
# int r_sqrt(int x){
#    if(x < 0)
#        return -1;
#    if (x < 2)
#        return x;
#   /* recursive call */
#    int small_cand = r_sqrt(x >> 2) << 1;
#    int large_cand = small_cand + 1;
#    if (large_cand * large_cand > x)
#        return small_cand;
#    else
#        return large_cand;
# }
