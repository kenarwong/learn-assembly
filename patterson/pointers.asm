# Using array and indices
# clear1(int array[], int size)
# {
#   int i;
#   for (i = 0; i < size; i += 1)
#    array[i] = 0;
# }

# Using pointers
# clear2(int *array, int size)
# {
#   int *p;
#   for (p = &array[0]; p < &array[size]; p = p + 1)
#     *p = 0;
# }

main:
  # $a0 = array[0]
  # $a1 = size
  # $t0 = i or p

clear1:
  move $t0,$zero          # i = 0

  loop1: 
    sll $t1,$t0,2         # $t1 = i * 4
    add $t2,$a0,$t1       # $t2 = address of array[i]
    sw $zero,0($t2)       # array[i] = 0
    addi $t0,$t0,1        # i = i + 1
    slt $t3,$t0,$a1       # $t3 = (i < size)
    bne $t3,$zero,loop1   # if (i < size) go to loop1

clear2:
  move $t0,$a0            # p = address of array[0]

  # predetermine ending condition
  sll $t1,$a1,2         # $t1 = size * 4
  add $t2,$a0,$t1       # $t2 = address of array[size], this is address of word after array
  
  # pointer arithmetic is more efficient
  loop2:
    sw $zero,0($t0)       # Memory[p] = 0
    addi $t0,$t0,4        # p = p + 4 
    slt $t3,$t0,$t2       # $t3 = (p<&array[size])
    bne $t3,$zero,loop2   # if (p<&array[size]) go to loop2