.section .data

input_prompt  :   .asciz  "Please enter a number betwen 1 and 10 \n"
input_spec  :   .asciz  "%d"
fib      :   .asciz  "%d\n"
oob_mess         : .asciz "Input is out of bounds \n"


.section .text



.global main



main:
        ldr x0, =input_prompt
        bl printf

        sub sp, sp, #16 // Allocating Space for number.

        ldr x0, =input_spec
        mov x1, sp
        bl scanf

        ldr x0, [sp, #0]


        // Validating Input.
        mov x1, #10
        cmp x1, x0
        b.lt invalid

        mov x1, #0
        cmp x1, x0
        b.ge invalid

        // Perform Fib
        mov x29, sp
        bl fib_rec

        mov x1, x0 // Moving return to x1
        ldr x0, =fib
        bl printf

        add sp, sp, #16 // Clearing Stack.

        b exit


fib_rec:

        stp x29, x30, [sp, #-64]! // Each reg is 64 -> 16 bytes. Alligining on word boundary.
        mov x29, sp

        str x0, [sp, #48] // storing n.
        ldr x0, [sp, #48]

        cmp x0, #2
        b.eq two_case

        cmp x0, #1 // Base case: If <= 1 return 0.
        b.le else_case


        sub x0, x0, #1 // n -1 case
        bl fib_rec
        mov x1, x0 // Getting result of func above.
        str x1, [sp, #32] // storing result.


        ldr x0, [sp, #48] // restoring n.
        sub x0, x0, #2 // n - 2 case
        bl fib_rec

        ldr x1, [sp, #32]

        // Sum the results
        add x0, x0, x1
        b return_fib

two_case:
        mov x0, #1 // Wow, spend a while wondering why the result was 0...
        b return_fib

else_case:
        mov x0, #0

return_fib:
        ldp x29, x30, [sp], #64
        ret


invalid:
        ldr x0, =oob_mess
        bl printf


# branch to this label on program completion
exit:
        mov x0, 0
        mov x8, 93
        svc 0
        ret
