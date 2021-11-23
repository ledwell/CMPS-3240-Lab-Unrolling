	.file	"iaxpy.c"
	.text
	.globl	iaxpy
	.type	iaxpy, @function
iaxpy:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	push 	%r12d
	push 	%r13d
	push	%r14d
	push	%r15d
	movl	%edi, -20(%rbp) #length
	movl	%esi, -24(%rbp)	#A
	movq	%rdx, -32(%rbp)	#*X
	movq	%rcx, -40(%rbp)	#*Y
	movq	%r8, -48(%rbp)	#*Result
	movl	$0, -4(%rbp)	#i = 0
	jmp	.L2
.L3:
	movl	-4(%rbp), %eax		#i -> %eax
	cltq
	leaq	0(,%rax,4), %rdx	#4*i -> %rdx
	movq	-32(%rbp), %rax		#*x -> %rax
	addq	%rdx, %rax			#x[i] -> %rax
	#NEW
	leaq 	4(%rax), %r12d		#x[i+1] -> %r12d
	#**
	movl	(%rax), %eax		#x[i] -> %eax		
	imull	-24(%rbp), %eax		#A*x[i] -> %eax
	movl	%eax, %ecx			#a*x[i] -> %ecx
	#NEW
	movl 	(%r12d), %eax		#x[i=1]-> %eax
	imull	-24(%rbp),	%eax	#A*x[i] -> %eax
	movl	%eax, %r15d			#A*x[i]-> %r15d
	#**
	movl	-4(%rbp), %eax		#reload i
	cltq
	leaq	0(,%rax,4), %rdx 	#i*4->%rdx
	movq	-40(%rbp), %rax		#*Y -> %rax
	addq	%rdx, %rax			#y[i]->%rax
	#NEW
	leaq	4(%rax), %r13d		#y[i+1] -> %r13d
	#**
	movl	(%rax), %edx		#y[i] -> %edx
	movl	-4(%rbp), %eax		#reload i
	cltq
	leaq	0(,%rax,4), %rsi 	#i*4 -> %rsi
	movq	-48(%rbp), %rax		#Result -> %rax
	addq	%rsi, %rax			#result[i] -> %rax
	#NEW
	leaq	4(%rsi), %r14d		#result[i+1] -> %r14d
	#**
	addl	%ecx, %edx			#a*x[i]+y[i]->%edx
	movl	%edx, (%rax)		#axpy-> Result[i]
	#NEW
	addl	%r13d, %r15d
	movl	%r15d, (%r14d)
	#**
	#NEW - INCREMENT I BY 2
	addl	$2, -4(%rbp)		
.L2:
	movl	-4(%rbp), %eax	#move i into %eax
	cmpl	-20(%rbp), %eax	#if i < length, jump L3
	jl	.L3
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	iaxpy, .-iaxpy
	.section	.rodata
	.align 8
.LC0:
	.string	"Running IAXPY operation of size %d x 1\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	$200000000, -4(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$13, -8(%rbp)
	movl	-4(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -16(%rbp)
	movl	-4(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -24(%rbp)
	movl	-4(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rdi
	movq	-24(%rbp), %rcx
	movq	-16(%rbp), %rdx
	movl	-8(%rbp), %esi
	movl	-4(%rbp), %eax
	movq	%rdi, %r8
	movl	%eax, %edi
	call	iaxpy
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movl	$0, %eax
	pop		%r14
	pop 	%r13
	pop		%r12
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	main, .-main
	.ident	"GCC: (Debian 8.3.0-6) 8.3.0"
	.section	.note.GNU-stack,"",@progbits
