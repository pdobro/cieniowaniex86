section .data
	RAB:		DD	0;colors incementers at AB edge
	GAB:		DD	0
	BAB:		DD	0

	RAC:		DD	0;colors incementers at AC edge
	GAC:		DD	0
	BAC:		DD	0

	RBC:		DD	0;colors incementers at BC edge
	GBC:		DD	0
	BBC:		DD	0

	DR:			DD	0;color incrementer  (inside not edge)
	DG:			DD	0
	DB:			DD	0
	
	DAB:		DD	0;delta(slope) ab = ax - bx/ ay - by
	DAC:		DD	0
	DBC:		DD	0;

	LFTR:		DD	0;left edge colors
	LFTG:		DD	0
	LFTB:		DD	0

	RTR:		DD	0;right edge colors
	RTG:		DD	0
	RTB:		DD	0

	LFTX:		DD	0;left x
	RTX:		DD	0;right x
	CURRX:		DD	0;current x
	;CURRY:		DD  0;current y

	RC:			DD	0;current red
	GC:			DD	0;current green
	BC:			DD	0;current blue


	WYN:		DD	0;result
	TMP1:		DD	0;temp
	TMP2:		DD  0
	TMP3:		DD  0
	TMP4:		DD	0
	RES:		DD 	0

	RC2:		DD	0;current red - second triangle
	GC2:		DD	0;current green - second triangle
	BC2:		DD	0;current blue -second triangle
	

section .text
	
	global shading

shading:
	push rbp
	mov rbp, rsp	 

	;col array, height, width, rowsize, triangle
	; ​%rdi​, 		%rsi​, ​%rdx​,		​%rcx​, 	​%r8​, ​\\\\\%r9
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
	;mov		[TMP1],	eax
	movd	xmm1, eax

	mov		eax, [r15 + 12]
	sub		eax, [r15]
	;mov		[TMP2],	eax
	movd	xmm2, eax

	;fild	dword [TMP2]
	;fidiv	dword [TMP1];delta x/ delta y
	;fstp	dword [DAB];store answer in DAB


	divss	xmm2, xmm1
	movss	[DAB],xmm2

getIncremeters:
	;calculate color incrementers
	;AB
	mov		esi, [r15 + 4];ay
	sub		esi, [r15 + 16]	;ay - by
	mov		[TMP1],	esi

	xor		rax, rax
	xor		rbx, rbx
	mov		al,	[r15 + 22];red val of b
	mov		bl,	[r15 + 10];red val of a
	sub		eax, ebx;delta color
	mov		[TMP2],	eax

	movd	xmm1, esi
	movd	xmm2, eax
	divss	xmm2, xmm1
	movss	[RAB], xmm2
	;fild	dword [TMP2]
	;fidiv	dword [TMP1];delta color;/ delta y
	;fstp	dword [RAB];store in RAB

	xor		rax, rax
	xor		rbx, rbx
	mov		al,	[r15 + 21];green val of b
	mov		bl,	[r15 + 9];grean val of a
	sub		eax, ebx
	mov		[TMP2],	eax

	fild	dword [TMP2]
	fidiv	dword [TMP1];d col/ dy
	fstp	dword [GAB];store in GAB

	xor		rax, rax
	xor		rbx, rbx
	mov		al,	[r15 + 20];blue val of b
	mov		bl,	[r15 + 8];blue val of a
	sub		eax, ebx;delta color
	mov		[TMP2],	eax

	fild	dword [TMP2]
	fidiv	dword [TMP1];d col/ dy
	fstp	dword [BAB];store in BAB

;AC
	mov		esi, [r15 + 4];ay
	sub		esi, [r15 + 28];ay - cy
	mov		[TMP1],	esi

	xor		rax, rax
	xor		rbx, rbx
	mov		al,	[r15 + 34];red val of c
	mov		bl,	[r15 + 10];red val of a
	sub		eax,ebx
	mov		[TMP2],	eax

	fild	dword [TMP2]
	fidiv	dword [TMP1];delta y/ delta col
	fstp	dword [RAC];store answer

	xor		rax, rax
	xor		rbx, rbx
	mov		al,	[r15 + 33];grean val of c
	mov		bl,	[r15 + 9];grean val of a
	sub		eax,ebx
	mov		[TMP2],	eax

	fild	dword [TMP2]
	fidiv	dword [TMP1];delta y/ delta col
	fstp	dword [GAC];store answer

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
begdraw:
	;y = y + slope
	;x = x + 1
	;rdx current row
	fxch;swap st0 st1
	fadd	dword [DAB];x + slope
	fist	dword [LFTX];save to left x
	fist	dword [CURRX];save to current x
	fxch

	imul	edi, [CURRX], 3
	add		rdi, rdx; curr pos in pixel array
	inc		dword [CURRX];x++

	;colors of left edge
	;BGR
	fld		dword [LFTB];load left blue
	fadd	dword [BAB];+=incrementer
	fst		dword [LFTB];save to lftb
	fst		dword [BC];current blue
	fistp	dword [WYN]
	mov		al,	[WYN];save to pixel array
	stosb

	fld		dword [LFTG];load left green
	fadd	dword [GAB];+=incrementer
	fst		dword [LFTG];save
	fst		dword [GC];current green
	fistp	dword [WYN];save to pixel array
	mov		al,	[WYN]
	stosb

	fld		dword [LFTR];load left red
	fadd	dword [RAB];+=incrementer
	fst		dword [LFTR]
	fst		dword [RC]
	fistp	dword [WYN];save to pixel array
	mov		al,	[WYN]
	stosb

	fxch	st2;swap st2 st0
	fadd	dword [DAC];add slope
	fist	dword [RTX];right pos
	fxch	st2

;color right edge
	imul	edi,	[RTX],	3;
	add		rdi,	rdx;pos of right side

	fld		dword [RTB];load right blue
	fadd	dword [BAC];+=incrementer
	fst		dword [RTB]
	fistp	dword [WYN];save to pixel array
	mov		al,[WYN]
	stosb

	fld		dword [RTG];load right blue
	fadd	dword [GAC];+=incrementer
	fst		dword [RTG]
	fistp	dword [WYN];save to pixel array
	mov		al,	[WYN]
	stosb

	fld		dword [RTR];load right red
	fadd	dword [RAC];+=incrementer
	fst		dword [RTR]
	fistp	dword [WYN];save to pixel array
	mov		al,	[WYN]
	stosb

	xor		rdi, rdi
	imul	edi,[CURRX],3; go back to left side
	add		rdi,rdx;set pos


	;calculate incrementers
	mov		ebx, [RTX]
	sub		ebx, [LFTX]
	mov		[TMP1],	ebx;delta x (line length)


	fld		dword [RTR]
	fsub	dword [LFTR]
	fidiv	dword [TMP1];delta color/ line leght
	fstp	dword [DR];save to delta red

	fld		dword [RTG]
	fsub	dword [LFTG]
	fidiv	dword [TMP1];delta color/line lenght
	fstp	dword [DG];save to delta green

	fld		dword [RTB];
	fsub	dword [LFTB]
	fidiv	dword [TMP1];delta color/ line lenght
	fstp	dword [DB];save to delta green

	mov		ebx, [CURRX]
	cmp		ebx, [RTX]
	jae		endloop

color:
	;BGR! not RBG
	fld		dword [BC];load curr blue(floating point)
	fadd	dword [DB];add incrementer
	fst		dword [BC];save 
	fistp	dword [WYN];save asnwer to WYN, pop stack
	mov		al,	[WYN]
	stosb;store al at rdi

	fld		dword [GC];;load curr green
	fadd	dword [DG];add incrementer
	fst		dword [GC];save next green
	fistp	dword [WYN];save to array
	mov		al,	[WYN]
	stosb

	fld		dword [RC];load current red
	fadd	dword [DR];add incrementer
	fst		dword [RC];save next red
	fistp	dword [WYN];save
	mov		al,	[WYN]
	stosb

	add		ebx, 1
	cmp		ebx, [RTX];
	jne		color;if went full right, break

endloop:
	;line ended
	sub		rdx, r14;curr row - row size

	sub		rcx, 1;if zero go to second triangle
	jnz		begdraw

secondTriangle:
	
	mov		ebx,	[r15 + 16]
	mov		ecx,	[r15 + 28]

;BY < CY
	;mov		r8d, dword [r15]
	mov	r8d, dword [r15 + 12];r8 = bx
	;mov		r9d, dword [r15 + 4];r9=y
	mov	r9d, dword [r15 + 16] 

	mov		r10, r9;ay
	imul	r10, r14;ay * row size
	mov		rax, r8;ax
	lea		rax, [rax* 2 + rax];ax*3
	add		r10, rax;ay + row size + ax  *3
	add		r10, r11;+= beg of pixrl		 	
	mov		rdi, r10
	
	mov		al,	[r15 + 20];a red
	stosb
	mov		al,	[r15 + 21];b green
	stosb
	mov		al,	[r15 + 22];b blue
	stosb;



	mov		[TMP1],	ecx
	sub		[TMP1],	ebx;cy - by
	mov		r8d,	[TMP1]

	mov		eax, [r15 + 12];cy
	sub		eax, [r15 + 24];bx - cx
	mov		[TMP2],	eax	

	fild	dword [TMP2]
	fidiv	dword [TMP1];delta x /delta y
	fstp	dword [DBC];slope
	;DAB second slope

getIncremeters2:
;AB ALREADY CALCULATED
;BC
	xor		rax, rax
	xor		rbx, rax

	mov		al,		[r15 + 22];red val of b
	mov		bl,		[r15 + 34];red val of c
	sub		eax,	ebx;delta color
	mov		[TMP2],	eax
	fild	dword [TMP2]
	fidiv	dword [TMP1];delta col / delta y
	fstp	dword [RBC];store

	xor		rax, rax
	xor		rbx, rax

	mov		al,	[r15 + 21];green val of b
	mov		bl,	[r15 + 33];green val of c
	sub		eax,	ebx
	mov		[TMP2],	eax
	fild	dword [TMP2]
	fidiv	dword [TMP1];delta color / delta y
	fstp	dword [GBC];store

	xor		rax, rax
	xor		rbx, rax

	mov		al,	[r15 + 20];blue val of b
	mov		bl,	[r15 + 32];blue val of c
	sub		eax,	ebx
	mov		[TMP2],	eax
	fild	dword [TMP2]
	fidiv	dword [TMP1];delta color. delta y
	fstp	dword [BBC];store


	xor		rax, rax
	xor		rbx, rbx
	dec		r8d

begdraw2:
	
	fxch;swap st0, st1
	fadd	dword [DAB];+= slope
	fist	dword [LFTX];save to left x
	fist	dword [CURRX];save to current x
	fxch

	imul	edi,	[CURRX],	3
	add		rdi,	rdx;curr pos in pixel array
	inc		dword [CURRX]

	;colors of left edge
	;BGR
	fld		dword [LFTB];load left blue
	fadd	dword [BAB];+=incrementer
	fst		dword [LFTB];save to lftb
	fst		dword [BC];current blue
	fistp	dword [WYN]
	mov		al,	[WYN];save to pixel array
	stosb

	fld		dword [LFTG];load left green
	fadd	dword [GAB];+=incrementer
	fst		dword [LFTG];save
	fst		dword [GC];current green
	fistp	dword [WYN];save to pixel array
	mov		al,	[WYN]
	stosb

	fld		dword [LFTR];load left red
	fadd	dword [RAB];+=incrementer
	fst		dword [LFTR]
	fst		dword [RC]
	fistp	dword [WYN];save to pixel array
	mov		al,	[WYN]
	stosb

	fxch	st2;swap st2 st0
	fadd	dword [DBC];add slope
	fist	dword [RTX];pos right edge
	fxch	st2

;color right edge
	imul	edi,	[RTX],	3
	add		rdi,	rdx;rt pos in pixel array

	
	fld		dword [RTB];load right blue
	fadd	dword [BBC];+=incrementer
	fst		dword [RTB]
	fistp	dword [WYN];save to pixel array
	mov		al,		[WYN]
	stosb

	fld		dword [RTG];load right blue
	fadd	dword [GBC];+=incrementer
	fst		dword [RTG]
	fistp	dword [WYN];save to pixel array
	mov		al,		[WYN]
	stosb

	fld		dword [RTR];load right red
	fadd	dword [RBC];+=incrementer
	fst		dword [RTR]
	fistp	dword [WYN];save to pixel array
	mov		al,	[WYN]
	stosb

	xor		rdi, rdi
	imul	edi,[CURRX],3; go back to left side
	add		rdi,rdx;set pos

;calculate increments
	mov		ebx, [RTX]
	sub		ebx, [LFTX]
	mov		[TMP1],	ebx;delta x (line length)


	fld		dword [RTR]
	fsub	dword [LFTR]
	fidiv	dword [TMP1];delta color/ line leght
	fstp	dword [DR];save to delta red

	fld		dword [RTG]
	fsub	dword [LFTG]
	fidiv	dword [TMP1];delta color/line lenght
	fstp	dword [DG];save to delta green

	fld		dword [RTB];
	fsub	dword [LFTB]
	fidiv	dword [TMP1];delta color/ line lenght
	fstp	dword [DB];save to delta green

	mov		ebx, [CURRX]
	cmp		ebx, [RTX]
	jae		endloop2

color2:
	;BGR! not RBG
	fld		dword [BC];load curr blue (floating point)
	fadd	dword [DB];add incrementer
	fst		dword [BC];save answet to BC
	fistp	dword [WYN];save asnwer to WYN, pop stack
	mov		al,	[WYN]
	stosb;store al at rdi

	fld		dword [GC];;load curr green
	fadd	dword [DG];add incrementer
	fst		dword [GC];save next green
	fistp	dword [WYN];save to array
	mov		al,	[WYN]
	stosb

	fld		dword [RC];load current red
	fadd	dword [DR];add incrementer
	fst		dword [RC];save next red
	fistp	dword [WYN];save
	mov		al,	[WYN]
	stosb

	add		ebx, 1
	cmp		ebx,[RTX];
	jne		color2

endloop2:
	;line ended
	sub		rdx,	r14;curr row - row size

	sub		r8, 1;if zero go to second triangle
	jnz		begdraw2

endProgram:
	mov rsp, rbp
	pop rbp		
	ret

