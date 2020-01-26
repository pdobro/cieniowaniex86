section .data
	LFTX:		DD	0;left x
	RTX:		DD	0;right x
	CURRX:		DD	0;current x
	CURRY:		DD  0;current y

	RC:			DD	0;current red
	GC:			DD	0;current green
	BC:			DD	0;current blue

	DR:			DD	0
	DG:			DD	0
	DB:			DD	0

	WYN:		DD	0;result
	TMP1:		DD	0;temp
	TMP2:		DD	0
	RES:		DD 	0

	DAB:		DD	0;delta ab = ax - bx/ ay - by
	DAC:		DD	0

	LFTR:		DD	0;left edge colors
	LFTG:		DD	0
	LFTB:		DD	0

	RTR:		DD	0;right edge colors
	RTG:		DD	0
	RTB:		DD	0

	RAB:		DD	0;colors incementers at AB edge
	GAB:		DD	0
	BAB:		DD	0

	RAC:		DD	0;colors incementers at AC edge
	GAC:		DD	0
	BAC:		DD	0

	RBC:		DD	0;colors incementers at BC edge
	GBC:		DD	0
	BBC:		DD	0

	XLFT2:		DD	0;left x - second triangle
	XRT2:		DD	0;right x - secon triangle
	LFTB2:		DD	0;left edge colors - second triangle
	LFTG2:		DD	0
	LFTR2:		DD	0
	RTB2:		DD	0;right edge colors - second triangle
	RTG2:		DD	0
	RTR2:		DD	0
	RC2:		DD	0;current red - second triangle
	GC2:		DD	0;current green - second triangle
	BC2:		DD	0;current blue -second triangle
	

section .text
	
	global shading

shading:
	push rbp
	mov rbp, rsp	 


	mov	r15, r8;triangle struct
	mov r14, rcx;row size
	mov	r13, rsi;width
	mov	r12, rdx;height
	mov r11, rdi;beg color array

firstTriangle:
	
	mov		r8d, dword [r15]
	;mov	esi, dword [r15 + 12];rsi = bx
	mov		r9d, dword [r15 + 4];r9=y
	;mov	edi, dword [r15 + 16] edi

	mov		r10, r9;ay
	imul	r10, r14;ay * row size
	mov		rax, r8;ax
	lea		rax, [rax* 2 + rax];ax*3
	add		r10, rax;ay + row size + ax  *3
	add		r10, r11;+= beg of pixrl

	mov		rdi, r10
	
	mov		al,	[r15 + 8];a red
	stosb
	mov		al,	[r15 + 9];a green
	stosb
	mov		al,	[r15 + 10];a blue
	stosb;



	mov		eax, [r15 + 4];ay
	sub		eax, [r15 + 28];ay - cy
	mov		[TMP1], eax

	mov		eax, [r15 + 24];cx
	sub		eax, [r15];cx - ax
	mov		[TMP2],	eax

	fild	dword [TMP2]
	fidiv	dword [TMP1];delta x/ delta y
	fstp	dword [DAC];store answer in DAC


	mov		eax, [r15 + 4];ay
	sub		eax, [r15 + 16];ay - by
	mov		[TMP1],	eax

	mov		eax, [r15 + 12]
	sub		eax, [r15]
	mov		[TMP2],	eax

	fild	dword [TMP2]
	fidiv	dword [TMP1];delta x/ delta y
	fstp	dword [DAB];store answer in DAB

getIncremeters:
	;calculate color incrementers
	mov		esi, [r15 + 4];ay
	sub		esi, [r15 + 16]	;ay - by
	mov		[TMP1],	esi

	;RED
	xor		rax, rax
	xor		rbx, rbx
	mov		al,		[r15 + 22];red val of b
	mov		bl,		[r15 + 10];red val of a
	sub		eax,	ebx;delta color
	mov		[TMP2],	eax

	fild	dword [TMP2]
	fidiv	dword [TMP1];delta y/ delta col
	fstp	dword [RAB];store in RAB

	;GREEN
	xor		rax, rax
	xor		rbx, rbx
	mov		al,	[r15 + 21];green val of b
	mov		bl,	[r15 + 9];grean val of a
	sub		eax, ebx
	mov		[TMP2],	eax

	fild	dword [TMP2]
	fidiv	dword [TMP1];delta y/ delta col
	fstp	dword [GAB];store in GAB

	;BLYUE
	xor		rax, rax
	xor		rbx, rbx
	mov		al,	[r15 + 20];blue val of b
	mov		bl,	[r15 + 8];blue val of a
	sub		eax, ebx;delta color
	mov		[TMP2],	eax

	fild	dword [TMP2]
	fidiv	dword [TMP1];delta y/ delta col
	fstp	dword [BAB];store in BAB




	mov		esi, [r15 + 4];ay
	sub		esi, [r15 + 28];ay - cy
	mov		[TMP1],	esi
	;RED
	xor		rax, rax
	xor		rbx, rbx
	mov		al,	[r15 + 34];red val of c
	mov		bl,	[r15 + 10];red val of a
	sub		eax,ebx
	mov		[TMP2],	eax

	fild	dword [TMP2]
	fidiv	dword [TMP1];delta y/ delta col
	fstp	dword [RAC];store answer

	;GREEN
	xor		rax, rax
	xor		rbx, rbx
	mov		al,	[r15 + 33];grean val of c
	mov		bl,	[r15 + 9];grean val of a
	sub		eax,ebx
	mov		[TMP2],	eax

	fild	dword [TMP2]
	fidiv	dword [TMP1];delta y/ delta col
	fstp	dword [GAC];store answer

	;BLUE
	xor		rax, rax
	xor		rbx, rbx
	mov		al,	[r15 + 32];blue val of c
	mov		bl,	[r15 + 8];blue val of a
	sub		eax, ebx
	mov		[TMP2],	eax

	fild	dword [TMP2]
	fidiv	dword [TMP1];delta y/ delta col
	fstp	dword [BAC];store answer

getColVal:;calculate begin color values

	mov		ecx, [r15 + 4]	
	sub		ecx, [r15+28];ay - cy
	xor		rax, rax
	xor		rdx, rdx

	mov		al,	[r15+10];red val of a 
	mov		[TMP1],	eax
	fild	dword [TMP1];load
	fst		dword [LFTR];copy tmp
	fstp	dword [RTR];copy tmp, pop stack

	mov		al,	[r15+9];green val of a
	mov		[TMP1],	eax
	fild	dword [TMP1];load
	fst		dword [LFTG];copy tmp
	fstp	dword [RTG];copy tmp, pop stack

	mov		al,	[r15+8];blue val of a
	mov		[TMP1],	eax
	fild	dword [TMP1];load int
	fst		dword [LFTB];copy tmp to left blue
	fstp	dword [RTB];copy tmp to right blue, pop stac
preLoop:
	mov		edx, [r15 + 4];ay
	sub		edx, 1
	imul	rdx, r14; ay * row size
	add		rdx, r11;ay * row size + beg of pixel array

	mov		eax, [r15];ax
	mov		[TMP1],	eax
	fild	dword [TMP1];load ax
	fild	dword [TMP1];load ax
	fdecstp;-- fpu stack pointer

	xor		rax, rax


	mov rsp, rbp	
	pop rbp		
	ret

