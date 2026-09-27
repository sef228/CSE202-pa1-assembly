.global binsearch
# arr in %rdi, n in %esi, target in %edx
binsearch:
  movl $0, %ecx #lo = 0
  subl $1, %esi #hi = int(n) -1

.Lsearch:
  cmpl %esi, %ecx #Compare lo with hi
  jg .Lnot_found  #If lo > hi stop searching

  movl %esi, %eax # net 4 making mid mid = hi
  subl %ecx, %eax # mid = high - low
  shrl $1, %eax   # mid = (high - low) /2 
  addl %ecx, %eax #  mid = lo + (high - lo_/2)

  movl (%rdi,%rax,4), %r8d # get arr[mid]
  cmpl %edx, %r8d # compare arr[mid] with the target
  je .Lfound #If equal, return mid
  jl .Lright_half # if arr[mid] < target search the right side
  leal -1(%rax), %esi # hi = mid - 1
  jmp .Lsearch

.Lright_half:
  leal 1(%rax), %ecx # lo = mid + 1 
  jmp .Lsearch

.Lnot_found:
  movl $-1, %eax # set the return value to -1 when target is absent 

.Lfound:
  ret


# binary search over a sorted int array; returns the index of target, or -1
# int binsearch(int *arr, unsigned n, int target){
#     int lo = 0;
#     int hi = (int)n - 1;
#     while(lo <= hi){
#         int mid = lo + (hi - lo) / 2;
#         if(arr[mid] == target)
#             return mid;
#         else if(arr[mid] < target)
#             lo = mid + 1;
#         else
#             hi = mid - 1;
#     }
#     return -1;
# }
