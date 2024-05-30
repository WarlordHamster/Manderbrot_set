section .text
        global  mandelbrot
default rel
mandelbrot:
;pro
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15
; przypisywanie
; mandelbrot(double x1, double x2, double y1, double y2, 
; int pixelx, int pixely,unsigned char* buffor);
    
    xor r10,r10
    xor rax,rax
    xor rcx,rcx
    pxor XMM7,XMM7
    pxor XMM8,XMM8
    pxor XMM9,XMM9
;counting delta x and y
    movsd XMM4, XMM1
    subsd XMM4, XMM0
    movsd XMM5, XMM3
    subsd XMM5, XMM2
    cvtsi2sd XMM6, rdi          ;convert rdi into double
    divsd XMM4, XMM6            ;XMM4 = delta x
    cvtsi2sd XMM6, rsi          ;convert rsi into double
    divsd XMM5, XMM6            ;XMM5 = delta y
Checking:
    xor r8, r8
    xor r9, r9
Checking_loop:
    ;setting starting values for loops
    ;c = x + jy
    cvtsi2sd XMM6, r8
    cvtsi2sd XMM7, r9
    movsd XMM8, XMM4              ;setting XMM8 = x
    mulsd XMM8, XMM6            ; mul t4, s4, a2#offset x
    addsd XMM8, XMM0            ; adding x1
    movsd XMM9, XMM5              ;setting XMM9 = jy
    mulsd XMM9, XMM7            ; mul t5, s5, a3#offset y
    addsd XMM9, XMM2            ;adding y1
    xor cl,cl
    pxor XMM10,XMM10
    pxor XMM11,XMM11
Checking_mandelbrot:
    ; zn+1 = zn^2 + c
	; c = cx + jcy
	; xtemp = zx^2 - zy^2 + cx
    ; y = 2*zx*zy + cy
    ; x = xtemp
    movsd XMM12, XMM10          ;
    mulsd XMM12, XMM12          ; zx^2
    movsd XMM13, XMM11          ;
    mulsd XMM13, XMM13          ; zy^2
    subsd XMM12, XMM13          ;
    addsd XMM12, XMM8           ; zx^2-zy^2+cx
    ;XMM12 = tempx
    movsd XMM13, XMM10
    mulsd XMM13, XMM11
    mov rax, 2
    cvtsi2sd XMM14, rax
    mulsd XMM13, XMM14          ;
    addsd XMM13, XMM9           ; XMM13 = 2*zx*zy + cy = zy
    movsd XMM11, XMM13          ; y = tempy
    movsd XMM10, XMM12          ; x = tempx
    mulsd XMM13, XMM13
    mulsd XMM12, XMM12
    addsd XMM12, XMM13
    shl rax, 1
    cvtsi2sd XMM14, rax
    comisd XMM12, XMM14
    jae next
    inc cl
    cmp cl, 64
    jnz Checking_mandelbrot
next:
    xor rax,rax
    shl cl, 2
    mov al, cl
    mov ah, cl
    shl rax, 16
    mov ah, cl
    mov al, 255
    mov [rdx], rax
    add rdx, 4
    inc r8
    cmp r8, rdi
    jne Checking_loop
higher_level:
    xor r8, r8                  ;pixelx = 0
    inc r9                      ;pixely +=1
    cmp r9, rsi
    jne Checking_loop
end:
    pop r15
    pop r14
    pop r13
    pop r12
    mov rsp, rbp
    pop rbp
    ret
