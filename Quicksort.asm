.data
v: .word -10, -20,3,8,-7,5
n: .word 6
space: .byte ' ' 

.text

   main:
   move  $s0 , $zero   #primul element
   lw $s1,  n     #ultimul element
   add $s1, $s1,-1 #de la 0 la n-1
   move $t8,$s1
   
   move $a0, $s0
   move $a1, $s1
   la $s3, v   #aici pastram vectorul
   
   
   quicksort:
   
    beq $a0, $a1, jra
    blt $a1,$a0, jra
    
    add $t9,$a0,$a1
    beq $t9,$t8,GATA
    
    add $sp,$sp,-4
    sw $ra,0($sp)
    
    jal apelQS
    
    lw $ra,0($sp)
    add $sp,$sp,4
    
    jra:
    jr $ra
 
    GATA:
     jal apelQS
     
     lw $s1,n
     
     
     add $t0,$zero,1
     for:
     
     add $v0,$zero,1
     lw $a0,0($s3)
     syscall
     li $v0,4
     la $a0,space
     syscall
     
     blt $t0,$s1,incrementare
     
     li $v0,10
     syscall
   
    incrementare:
    add $t0,$t0,1
    add $s3,$s3,4
    j for
    
   apelQS:
   #pastram inceputul si sfarsitul ca sa nu fie modificate de quicksorturile urmatoare
    add $sp, $sp, -16
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $ra, 12($sp)
    
    move $a0, $s0
    move $a1, $s1
    
    jal pivotare
    
    #in a2 pastram pivotul
    
    add $a1, $a2, -1  #facem partea din dreapta
    move $s1,$a1
    move $s2,$a2  #pastram pivotul
    
    jal quicksort
   
    add $a0, $s2, 1
    lw $a1, 4($sp)
    move $s0,$a0
    lw $s1, 4($sp)
    
    jal quicksort
    
    #retrieve inceput si sfarsit
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $ra, 12($sp)
    add $sp, $sp, 16
    jr $ra
   

  pivotare:
  
   move $s5,$s3 #inceputul secventei
   move $s6,$s3#safrsitul secventei
   move $t0,$zero
  #facem inceputul
  forStanga:
   blt $t0,$s0 Incrementare1  
  
  move $t0,$zero
  
  forDreapta:
   blt $t0,$s1 Incrementare2 
  
  add $t3,$zero,1
  while:  #s5<s6
    
  beq $s5,$s6 done
  lw $t1,0($s5)
  lw $t2,0($s6)
  
  blt $t2,$t1 interschimbare
  
  beq $t3,1,scademDreapta
  add $s5, $s5, 4
  j while
  
  
  interschimbare:
  sw $t2,0($s5)#interschimbarea
  sw $t1,0($s6)
  
  add $t4,$zero,3
  sub $t3, $t4, $t3#de unde scadem
  
  beq $t3,1, scademDreapta
  #sau crestemStanga
  add $s5,$s5,4
  j while
   
     
     
  scademDreapta:   
    add $s6,$s6,-4   
    add $t0,$t0,-1   
       
   j while        
   
  done:
    move $a2,$t0 
    #adresa elementului
    jr $ra #ne intoarcem in quicksort
  
  Incrementare1:
    add $t0,$t0,1
    add $s5,$s5,4
    j forStanga
  
  Incrementare2:
    add $t0,$t0,1
    add $s6,$s6,4
    j forDreapta
