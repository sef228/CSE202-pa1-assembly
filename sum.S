.global sum
# pointer to list head in %rdi; result in %rax
# struct ll { char *name; long value; struct ll *next; }
#   offset 0  : name
#   offset 8  : value
#   offset 16 : next
sum:
    movq $0, %rax # total = 0

.Lsum_loop:
    cmpq $0, %rdi #is the current pointer null 
    je .Lsum_done # if it is stop

    addq 8(%rdi), %rax # total += ptr->value
    movq 16(%rdi), %rdi # ptr = ptr->next

    jmp .Lsum_loop

.Lsum_done:
    retq


# sum of the elements of a linkedlist in C
# long sum(struct ll *list){
#    long total = 0;
#    struct ll *ptr = list;
#    while(ptr){
#        total += ptr->value;
#        ptr = ptr->next;
#    }
#    return total;
# }
