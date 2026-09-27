.global product
# a in %rdi, b in %rsi, c in %rdx, size in %ecx
product:
    movl $0, %eax # i = 0

.Lproduct_loop:
    cmpl %ecx, %eax #compare i with size
    jae .Lproduct_done # Stop if i >= size 

    movss (%rdi,%rax,4), %xmm0 #a[i]
    mulss (%rsi, %rax, 4), %xmm0 # xmm0 = a[i] * b[i]
    movss %xmm0, (%rdx,%rax, 4) #c[i] = result
    
    incl %eax #i++
    jmp .Lproduct_loop

.Lproduct_done:
    ret

# Product of two vectors in C
# void product(float *a, float *b, float *c, unsigned size){
#    for(int i=0; i<size; i++){
#        c[i] = a[i] * b[i];
#    }
# }
