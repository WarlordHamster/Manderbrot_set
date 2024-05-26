section .text
        global  mandelbrot
extern SDL_SetRenderDrawColor
extern SDL_RenderDrawPointF
mandelbrot:
;pro
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub     rsp, 16
    movq  qword [rsp], XMM6
    sub     rsp, 16
    movq  qword [rsp], XMM7
    sub     rsp, 16
    movq  qword [rsp], XMM8
    sub     rsp, 16
    movq  qword [rsp], XMM9
    sub     rsp, 16
    movq  qword [rsp], XMM10
    sub     rsp, 16
    movq  qword [rsp], XMM11
    sub     rsp, 16
    movq  qword [rsp], XMM12
    sub     rsp, 16
    movq  qword [rsp], XMM13
    sub     rsp, 16
    movq  qword [rsp], XMM14
;przypisywanie
; mandelbrot(double x1, double x2, double y1, double y2, 
; int pixelx, int pixely, SDL_Renderer* renderer,SDL_Window* window)
    movsd XMM0, [rbp + 16]      ;XMM0 = x1
    movsd XMM1, [rbp + 24]      ;XMM1 = x2
    movsd XMM2, [rbp + 32]      ;XMM2 = y1
    movsd XMM3, [rbp + 40]      ;XMM3 = y2
    mov rdi, [rbp + 48]         ;rdi = pixelx const
    mov rsi, [rbp + 52]         ;rsi = pixely const
    mov rdx, [rbp + 60]         ;rdx = renderer*
    mov r10, [rbp + 68]         ;r10 = window*
    xor r8, r8                   ;r8 = pixel x 
    xor r9, r9                   ;r9 = pixel y
    xor r10,r10
    xor rax,rax
    pxor XMM6,XMM6
    pxor XMM7,XMM7
    pxor XMM8,XMM8
    pxor XMM9,XMM9
    pxor XMM10,XMM10
    pxor XMM10,XMM10
;counting delta x and y
    movsd XMM4, XMM1
    subsd XMM4, XMM0
    movsd XMM5, XMM3
    subsd XMM5, XMM2
    cvtsi2sd XMM6, edi          ;convert edi into double
    divsd XMM4, XMM6            ;XMM4 = delta x
    cvtsi2sd XMM6, esi          ;convert esi into double
    divsd XMM5, XMM6            ;XMM5 = delta y
checking:
    cvtsi2sd XMM6, r8
    cvtsi2sd XMM7, r9
checking_loop:
    ;setting starting values for loops
    ;c = x + jy
    movsd XMM8, XMM4              ;setting XMM8 = x
    mulsd XMM8, XMM6            ; mul t4, s4, a2#offset x
    movsd XMM9, XMM5              ;setting XMM9 = jy
    mulsd XMM9, XMM7            ; mul t5, s5, a3#offset y
    mov rcx, 255
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
    pxor XMM14, XMM14
    mov rax, 2
    cvtsi2sd XMM14, rax
    mulsd XMM13, XMM14          ;
    addsd XMM13, XMM9           ; XMM12 = 2*zx*zy + cy = y
    movsd XMM11, XMM13          ; y = tempy
    movsd XMM10, XMM12          ; x = tempx
    cmpnlesd XMM11, XMM14          ; y < 2
    jnle next
    cmpnlesd XMM10, XMM14          ; x < 2
    jnle next
    mov rax, -2
    cvtsi2sd XMM14, rax
    cmplesd XMM11, XMM14          ; y > -2
    jle next
    cmplesd XMM10, XMM14          ; x > -2
    jle next
    loop Checking_mandelbrot
next:
    call pusher
    push rdi
    push rsi
    push rdx
    push rcx
    push r8
    mov rdi, rdx
    mov rsi, rcx
    mov rdx, rcx
    mov qword r8, 255
    call SDL_SetRenderDrawColor
    pop r8
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    call popper

end:
    movq  XMM14, qword [rsp] 
    add   rsp, 16
    movq  XMM13, qword [rsp] 
    add   rsp, 16
    movq  XMM12, qword [rsp] 
    add   rsp, 16
    movq  XMM11, qword [rsp] 
    add   rsp, 16
    movq  XMM10, qword [rsp]
    add   rsp, 16
    movq  XMM9, qword [rsp] 
    add   rsp, 16
    movq  XMM8, qword [rsp]
    add   rsp, 16
    movq  XMM7, qword [rsp]
    add   rsp, 16
    movq  XMM6, qword [rsp]
    add   rsp, 16
    pop r15
    pop r14
    pop r13
    pop r12
    mov rsp, rbp
    pop rbp
    ret

pusher:
    push rax
    push rdi
    push rsi
    push rdx
    push rcx
    push r8
    push r9
    push r10
    push r11
    sub     rsp, 16
    movq  qword [rsp], XMM0
    sub     rsp, 16
    movq  qword [rsp], XMM1
    sub     rsp, 16
    movq  qword [rsp], XMM2
    sub     rsp, 16
    movq  qword [rsp], XMM3
    sub     rsp, 16
    movq  qword [rsp], XMM4
    sub     rsp, 16
    movq  qword [rsp], XMM5
    ret
popper:
    movq  XMM5, qword [rsp] 
    add   rsp, 16
    movq  XMM4, qword [rsp] 
    add   rsp, 16
    movq  XMM3, qword [rsp] 
    add   rsp, 16
    movq  XMM2, qword [rsp] 
    add   rsp, 16
    movq  XMM1, qword [rsp] 
    add   rsp, 16
    movq  XMM0, qword [rsp]
    add   rsp, 16
    pop r11
    pop r10
    pop r9
    pop r8
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    pop rax
    ret