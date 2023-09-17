        //Intro strings
        .data
str1:   .asciz  "This program will create a table for values of f(x) = (x^3-x^2-2x)/((((x-2)^4)/11)+3) given bounds\n"
        .align 2

str2:   .asciz  "Enter a lower bound for x: "
        .align 2

str3:   .asciz  "Enter a upper bound for x: "
        .align 2

str4:   .asciz  "Enter the number of rows: "
        .align 2

//static memory to format string
userNum:   .asciz "%d"
        .align 2

divider: .ascii "%f | %f \n"
        .align 2

num:    .word   0



        .text
        .type main, %function
        .global main
main:
    stp x29, x30, [sp, #-16]!
    stp x27, x28, [sp, #-16]!
    stp x25, x26, [sp, #-16]!

    stp q8, q9, [sp, #-32]!
    stp q10, q11, [sp, #-32]!
    

print_and_get:
   //print intro
   adr x0, str1
   bl printf
   
   //get and store lower bound
   adr x0, str2
   bl printf
   adr x0, userNum
   adr x1, num
   bl scanf //scanf("format string", specified memory)
   ldr x25, num //save lower bound

    //get and store upper bound
   adr x0, str3
   bl printf
   adr x0, userNum
   adr x1, num
   bl scanf //scanf("format string", specified memory)
   ldr x26, num //save upper bound
   
   //get and store number of rows
   adr x0, str4
   bl printf
   adr x0, userNum
   adr x1, num
   bl scanf
   ldr w27, num

setUp:
        scvtf  d8, x25 //lower
        scvtf  d9, x26 //upper
        sub x27, x27, #1 //(rows - 1)
        scvtf  d10, x27 //rows-1

        fsub    d0, d9, d8 //high-low
        fdiv    d10, d0, d10 //increment
loop:
        adr x0, divider
        fmov d0, d8
        bl function //return x -> d0 | f(x) -> d1
        bl printf

        fadd d8, d8, d10
        fcmp d8, d9
        bgt end
        
        b loop
 
end:
    ldp q8, q9, [sp], #32
    ldp q10, q11, [sp], #32
    ldp x25, x26, [sp], #16
    ldp x27, x28, [sp], #16
    ldp x29, x30, [sp], #16
    ret

function:
        mov x2, #2
        scvtf d3, x2
        fmul d3, d0, d3 //2x

        fmul d2, d0, d0 //x^2
        fmul d1, d2, d0 //x^3

        fsub d1, d1, d2
        fsub d1, d1, d3 //numerator

        //denominator
        scvtf d3, x2
        
        fsub d2, d0, d3 //x-2
        fmul d2, d2, d2 //(x-2)^2
        fmul d2, d2, d2 //(x-2)^4

        mov x2, #11
        scvtf d3, x2
        fdiv d2, d2, d3
        mov x2, #3
        scvtf d3, x2
        fadd d2, d2, d3
        fdiv d1, d1, d2
        ret