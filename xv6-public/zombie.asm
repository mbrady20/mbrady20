
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  11:	e8 65 02 00 00       	call   27b <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 ef 02 00 00       	call   313 <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  27:	e8 57 02 00 00       	call   283 <exit>
  2c:	66 90                	xchg   %ax,%ax
  2e:	66 90                	xchg   %ax,%ax

00000030 <strcpy>:
  30:	55                   	push   %ebp
  31:	31 c0                	xor    %eax,%eax
  33:	89 e5                	mov    %esp,%ebp
  35:	53                   	push   %ebx
  36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  39:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  40:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  44:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  47:	83 c0 01             	add    $0x1,%eax
  4a:	84 d2                	test   %dl,%dl
  4c:	75 f2                	jne    40 <strcpy+0x10>
  4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  51:	89 c8                	mov    %ecx,%eax
  53:	c9                   	leave  
  54:	c3                   	ret    
  55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000060 <strcmp>:
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	53                   	push   %ebx
  64:	8b 55 08             	mov    0x8(%ebp),%edx
  67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  6a:	0f b6 02             	movzbl (%edx),%eax
  6d:	84 c0                	test   %al,%al
  6f:	75 17                	jne    88 <strcmp+0x28>
  71:	eb 3a                	jmp    ad <strcmp+0x4d>
  73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  77:	90                   	nop
  78:	0f b6 42 01          	movzbl 0x1(%edx),%eax
  7c:	83 c2 01             	add    $0x1,%edx
  7f:	8d 59 01             	lea    0x1(%ecx),%ebx
  82:	84 c0                	test   %al,%al
  84:	74 1a                	je     a0 <strcmp+0x40>
  86:	89 d9                	mov    %ebx,%ecx
  88:	0f b6 19             	movzbl (%ecx),%ebx
  8b:	38 c3                	cmp    %al,%bl
  8d:	74 e9                	je     78 <strcmp+0x18>
  8f:	29 d8                	sub    %ebx,%eax
  91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  94:	c9                   	leave  
  95:	c3                   	ret    
  96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  9d:	8d 76 00             	lea    0x0(%esi),%esi
  a0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  a4:	31 c0                	xor    %eax,%eax
  a6:	29 d8                	sub    %ebx,%eax
  a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  ab:	c9                   	leave  
  ac:	c3                   	ret    
  ad:	0f b6 19             	movzbl (%ecx),%ebx
  b0:	31 c0                	xor    %eax,%eax
  b2:	eb db                	jmp    8f <strcmp+0x2f>
  b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bf:	90                   	nop

000000c0 <strlen>:
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	8b 55 08             	mov    0x8(%ebp),%edx
  c6:	80 3a 00             	cmpb   $0x0,(%edx)
  c9:	74 15                	je     e0 <strlen+0x20>
  cb:	31 c0                	xor    %eax,%eax
  cd:	8d 76 00             	lea    0x0(%esi),%esi
  d0:	83 c0 01             	add    $0x1,%eax
  d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  d7:	89 c1                	mov    %eax,%ecx
  d9:	75 f5                	jne    d0 <strlen+0x10>
  db:	89 c8                	mov    %ecx,%eax
  dd:	5d                   	pop    %ebp
  de:	c3                   	ret    
  df:	90                   	nop
  e0:	31 c9                	xor    %ecx,%ecx
  e2:	5d                   	pop    %ebp
  e3:	89 c8                	mov    %ecx,%eax
  e5:	c3                   	ret    
  e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ed:	8d 76 00             	lea    0x0(%esi),%esi

000000f0 <memset>:
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	57                   	push   %edi
  f4:	8b 55 08             	mov    0x8(%ebp),%edx
  f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	89 d7                	mov    %edx,%edi
  ff:	fc                   	cld    
 100:	f3 aa                	rep stos %al,%es:(%edi)
 102:	8b 7d fc             	mov    -0x4(%ebp),%edi
 105:	89 d0                	mov    %edx,%eax
 107:	c9                   	leave  
 108:	c3                   	ret    
 109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000110 <strchr>:
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	8b 45 08             	mov    0x8(%ebp),%eax
 116:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
 11a:	0f b6 10             	movzbl (%eax),%edx
 11d:	84 d2                	test   %dl,%dl
 11f:	75 12                	jne    133 <strchr+0x23>
 121:	eb 1d                	jmp    140 <strchr+0x30>
 123:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 127:	90                   	nop
 128:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 12c:	83 c0 01             	add    $0x1,%eax
 12f:	84 d2                	test   %dl,%dl
 131:	74 0d                	je     140 <strchr+0x30>
 133:	38 d1                	cmp    %dl,%cl
 135:	75 f1                	jne    128 <strchr+0x18>
 137:	5d                   	pop    %ebp
 138:	c3                   	ret    
 139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 140:	31 c0                	xor    %eax,%eax
 142:	5d                   	pop    %ebp
 143:	c3                   	ret    
 144:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 14b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 14f:	90                   	nop

00000150 <gets>:
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	57                   	push   %edi
 154:	56                   	push   %esi
 155:	8d 7d e7             	lea    -0x19(%ebp),%edi
 158:	53                   	push   %ebx
 159:	31 db                	xor    %ebx,%ebx
 15b:	83 ec 1c             	sub    $0x1c,%esp
 15e:	eb 27                	jmp    187 <gets+0x37>
 160:	83 ec 04             	sub    $0x4,%esp
 163:	6a 01                	push   $0x1
 165:	57                   	push   %edi
 166:	6a 00                	push   $0x0
 168:	e8 2e 01 00 00       	call   29b <read>
 16d:	83 c4 10             	add    $0x10,%esp
 170:	85 c0                	test   %eax,%eax
 172:	7e 1d                	jle    191 <gets+0x41>
 174:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 178:	8b 55 08             	mov    0x8(%ebp),%edx
 17b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
 17f:	3c 0a                	cmp    $0xa,%al
 181:	74 1d                	je     1a0 <gets+0x50>
 183:	3c 0d                	cmp    $0xd,%al
 185:	74 19                	je     1a0 <gets+0x50>
 187:	89 de                	mov    %ebx,%esi
 189:	83 c3 01             	add    $0x1,%ebx
 18c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 18f:	7c cf                	jl     160 <gets+0x10>
 191:	8b 45 08             	mov    0x8(%ebp),%eax
 194:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
 198:	8d 65 f4             	lea    -0xc(%ebp),%esp
 19b:	5b                   	pop    %ebx
 19c:	5e                   	pop    %esi
 19d:	5f                   	pop    %edi
 19e:	5d                   	pop    %ebp
 19f:	c3                   	ret    
 1a0:	8b 45 08             	mov    0x8(%ebp),%eax
 1a3:	89 de                	mov    %ebx,%esi
 1a5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
 1a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1ac:	5b                   	pop    %ebx
 1ad:	5e                   	pop    %esi
 1ae:	5f                   	pop    %edi
 1af:	5d                   	pop    %ebp
 1b0:	c3                   	ret    
 1b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1bf:	90                   	nop

000001c0 <stat>:
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	56                   	push   %esi
 1c4:	53                   	push   %ebx
 1c5:	83 ec 08             	sub    $0x8,%esp
 1c8:	6a 00                	push   $0x0
 1ca:	ff 75 08             	push   0x8(%ebp)
 1cd:	e8 f1 00 00 00       	call   2c3 <open>
 1d2:	83 c4 10             	add    $0x10,%esp
 1d5:	85 c0                	test   %eax,%eax
 1d7:	78 27                	js     200 <stat+0x40>
 1d9:	83 ec 08             	sub    $0x8,%esp
 1dc:	ff 75 0c             	push   0xc(%ebp)
 1df:	89 c3                	mov    %eax,%ebx
 1e1:	50                   	push   %eax
 1e2:	e8 f4 00 00 00       	call   2db <fstat>
 1e7:	89 1c 24             	mov    %ebx,(%esp)
 1ea:	89 c6                	mov    %eax,%esi
 1ec:	e8 ba 00 00 00       	call   2ab <close>
 1f1:	83 c4 10             	add    $0x10,%esp
 1f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1f7:	89 f0                	mov    %esi,%eax
 1f9:	5b                   	pop    %ebx
 1fa:	5e                   	pop    %esi
 1fb:	5d                   	pop    %ebp
 1fc:	c3                   	ret    
 1fd:	8d 76 00             	lea    0x0(%esi),%esi
 200:	be ff ff ff ff       	mov    $0xffffffff,%esi
 205:	eb ed                	jmp    1f4 <stat+0x34>
 207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 20e:	66 90                	xchg   %ax,%ax

00000210 <atoi>:
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	53                   	push   %ebx
 214:	8b 55 08             	mov    0x8(%ebp),%edx
 217:	0f be 02             	movsbl (%edx),%eax
 21a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 21d:	80 f9 09             	cmp    $0x9,%cl
 220:	b9 00 00 00 00       	mov    $0x0,%ecx
 225:	77 1e                	ja     245 <atoi+0x35>
 227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 22e:	66 90                	xchg   %ax,%ax
 230:	83 c2 01             	add    $0x1,%edx
 233:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 236:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
 23a:	0f be 02             	movsbl (%edx),%eax
 23d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 240:	80 fb 09             	cmp    $0x9,%bl
 243:	76 eb                	jbe    230 <atoi+0x20>
 245:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 248:	89 c8                	mov    %ecx,%eax
 24a:	c9                   	leave  
 24b:	c3                   	ret    
 24c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000250 <memmove>:
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	57                   	push   %edi
 254:	8b 45 10             	mov    0x10(%ebp),%eax
 257:	8b 55 08             	mov    0x8(%ebp),%edx
 25a:	56                   	push   %esi
 25b:	8b 75 0c             	mov    0xc(%ebp),%esi
 25e:	85 c0                	test   %eax,%eax
 260:	7e 13                	jle    275 <memmove+0x25>
 262:	01 d0                	add    %edx,%eax
 264:	89 d7                	mov    %edx,%edi
 266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 26d:	8d 76 00             	lea    0x0(%esi),%esi
 270:	a4                   	movsb  %ds:(%esi),%es:(%edi)
 271:	39 f8                	cmp    %edi,%eax
 273:	75 fb                	jne    270 <memmove+0x20>
 275:	5e                   	pop    %esi
 276:	89 d0                	mov    %edx,%eax
 278:	5f                   	pop    %edi
 279:	5d                   	pop    %ebp
 27a:	c3                   	ret    

0000027b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 27b:	b8 01 00 00 00       	mov    $0x1,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <exit>:
SYSCALL(exit)
 283:	b8 02 00 00 00       	mov    $0x2,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <wait>:
SYSCALL(wait)
 28b:	b8 03 00 00 00       	mov    $0x3,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <pipe>:
SYSCALL(pipe)
 293:	b8 04 00 00 00       	mov    $0x4,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <read>:
SYSCALL(read)
 29b:	b8 05 00 00 00       	mov    $0x5,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <write>:
SYSCALL(write)
 2a3:	b8 10 00 00 00       	mov    $0x10,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <close>:
SYSCALL(close)
 2ab:	b8 15 00 00 00       	mov    $0x15,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <kill>:
SYSCALL(kill)
 2b3:	b8 06 00 00 00       	mov    $0x6,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <exec>:
SYSCALL(exec)
 2bb:	b8 07 00 00 00       	mov    $0x7,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <open>:
SYSCALL(open)
 2c3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <mknod>:
SYSCALL(mknod)
 2cb:	b8 11 00 00 00       	mov    $0x11,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <unlink>:
SYSCALL(unlink)
 2d3:	b8 12 00 00 00       	mov    $0x12,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <fstat>:
SYSCALL(fstat)
 2db:	b8 08 00 00 00       	mov    $0x8,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <link>:
SYSCALL(link)
 2e3:	b8 13 00 00 00       	mov    $0x13,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <mkdir>:
SYSCALL(mkdir)
 2eb:	b8 14 00 00 00       	mov    $0x14,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <chdir>:
SYSCALL(chdir)
 2f3:	b8 09 00 00 00       	mov    $0x9,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <dup>:
SYSCALL(dup)
 2fb:	b8 0a 00 00 00       	mov    $0xa,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <getpid>:
SYSCALL(getpid)
 303:	b8 0b 00 00 00       	mov    $0xb,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <sbrk>:
SYSCALL(sbrk)
 30b:	b8 0c 00 00 00       	mov    $0xc,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <sleep>:
SYSCALL(sleep)
 313:	b8 0d 00 00 00       	mov    $0xd,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <uptime>:
SYSCALL(uptime)
 31b:	b8 0e 00 00 00       	mov    $0xe,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <getfilename>:
SYSCALL(getfilename)
 323:	b8 16 00 00 00       	mov    $0x16,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <wmap>:
SYSCALL(wmap)
 32b:	b8 17 00 00 00       	mov    $0x17,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <wunmap>:
SYSCALL(wunmap)
 333:	b8 18 00 00 00       	mov    $0x18,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <wremap>:
SYSCALL(wremap)
 33b:	b8 19 00 00 00       	mov    $0x19,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <getpgdirinfo>:
SYSCALL(getpgdirinfo)
 343:	b8 1b 00 00 00       	mov    $0x1b,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <getwmapinfo>:
SYSCALL(getwmapinfo)
 34b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    
 353:	66 90                	xchg   %ax,%ax
 355:	66 90                	xchg   %ax,%ax
 357:	66 90                	xchg   %ax,%ax
 359:	66 90                	xchg   %ax,%ax
 35b:	66 90                	xchg   %ax,%ax
 35d:	66 90                	xchg   %ax,%ax
 35f:	90                   	nop

00000360 <printint>:
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	56                   	push   %esi
 365:	53                   	push   %ebx
 366:	83 ec 3c             	sub    $0x3c,%esp
 369:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
 36c:	89 d1                	mov    %edx,%ecx
 36e:	89 45 b8             	mov    %eax,-0x48(%ebp)
 371:	85 d2                	test   %edx,%edx
 373:	0f 89 7f 00 00 00    	jns    3f8 <printint+0x98>
 379:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 37d:	74 79                	je     3f8 <printint+0x98>
 37f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
 386:	f7 d9                	neg    %ecx
 388:	31 db                	xor    %ebx,%ebx
 38a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 38d:	8d 76 00             	lea    0x0(%esi),%esi
 390:	89 c8                	mov    %ecx,%eax
 392:	31 d2                	xor    %edx,%edx
 394:	89 cf                	mov    %ecx,%edi
 396:	f7 75 c4             	divl   -0x3c(%ebp)
 399:	0f b6 92 98 07 00 00 	movzbl 0x798(%edx),%edx
 3a0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 3a3:	89 d8                	mov    %ebx,%eax
 3a5:	8d 5b 01             	lea    0x1(%ebx),%ebx
 3a8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
 3ab:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
 3ae:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 3b1:	76 dd                	jbe    390 <printint+0x30>
 3b3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 3b6:	85 c9                	test   %ecx,%ecx
 3b8:	74 0c                	je     3c6 <printint+0x66>
 3ba:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3bf:	89 d8                	mov    %ebx,%eax
 3c1:	ba 2d 00 00 00       	mov    $0x2d,%edx
 3c6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 3c9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 3cd:	eb 07                	jmp    3d6 <printint+0x76>
 3cf:	90                   	nop
 3d0:	0f b6 13             	movzbl (%ebx),%edx
 3d3:	83 eb 01             	sub    $0x1,%ebx
 3d6:	83 ec 04             	sub    $0x4,%esp
 3d9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 3dc:	6a 01                	push   $0x1
 3de:	56                   	push   %esi
 3df:	57                   	push   %edi
 3e0:	e8 be fe ff ff       	call   2a3 <write>
 3e5:	83 c4 10             	add    $0x10,%esp
 3e8:	39 de                	cmp    %ebx,%esi
 3ea:	75 e4                	jne    3d0 <printint+0x70>
 3ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ef:	5b                   	pop    %ebx
 3f0:	5e                   	pop    %esi
 3f1:	5f                   	pop    %edi
 3f2:	5d                   	pop    %ebp
 3f3:	c3                   	ret    
 3f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3f8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 3ff:	eb 87                	jmp    388 <printint+0x28>
 401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 408:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 40f:	90                   	nop

00000410 <printf>:
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	57                   	push   %edi
 414:	56                   	push   %esi
 415:	53                   	push   %ebx
 416:	83 ec 2c             	sub    $0x2c,%esp
 419:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 41c:	8b 75 08             	mov    0x8(%ebp),%esi
 41f:	0f b6 13             	movzbl (%ebx),%edx
 422:	84 d2                	test   %dl,%dl
 424:	74 6a                	je     490 <printf+0x80>
 426:	8d 45 10             	lea    0x10(%ebp),%eax
 429:	83 c3 01             	add    $0x1,%ebx
 42c:	8d 7d e7             	lea    -0x19(%ebp),%edi
 42f:	31 c9                	xor    %ecx,%ecx
 431:	89 45 d0             	mov    %eax,-0x30(%ebp)
 434:	eb 36                	jmp    46c <printf+0x5c>
 436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 43d:	8d 76 00             	lea    0x0(%esi),%esi
 440:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 443:	b9 25 00 00 00       	mov    $0x25,%ecx
 448:	83 f8 25             	cmp    $0x25,%eax
 44b:	74 15                	je     462 <printf+0x52>
 44d:	83 ec 04             	sub    $0x4,%esp
 450:	88 55 e7             	mov    %dl,-0x19(%ebp)
 453:	6a 01                	push   $0x1
 455:	57                   	push   %edi
 456:	56                   	push   %esi
 457:	e8 47 fe ff ff       	call   2a3 <write>
 45c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 45f:	83 c4 10             	add    $0x10,%esp
 462:	0f b6 13             	movzbl (%ebx),%edx
 465:	83 c3 01             	add    $0x1,%ebx
 468:	84 d2                	test   %dl,%dl
 46a:	74 24                	je     490 <printf+0x80>
 46c:	0f b6 c2             	movzbl %dl,%eax
 46f:	85 c9                	test   %ecx,%ecx
 471:	74 cd                	je     440 <printf+0x30>
 473:	83 f9 25             	cmp    $0x25,%ecx
 476:	75 ea                	jne    462 <printf+0x52>
 478:	83 f8 25             	cmp    $0x25,%eax
 47b:	0f 84 07 01 00 00    	je     588 <printf+0x178>
 481:	83 e8 63             	sub    $0x63,%eax
 484:	83 f8 15             	cmp    $0x15,%eax
 487:	77 17                	ja     4a0 <printf+0x90>
 489:	ff 24 85 40 07 00 00 	jmp    *0x740(,%eax,4)
 490:	8d 65 f4             	lea    -0xc(%ebp),%esp
 493:	5b                   	pop    %ebx
 494:	5e                   	pop    %esi
 495:	5f                   	pop    %edi
 496:	5d                   	pop    %ebp
 497:	c3                   	ret    
 498:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 49f:	90                   	nop
 4a0:	83 ec 04             	sub    $0x4,%esp
 4a3:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 4a6:	6a 01                	push   $0x1
 4a8:	57                   	push   %edi
 4a9:	56                   	push   %esi
 4aa:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4ae:	e8 f0 fd ff ff       	call   2a3 <write>
 4b3:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
 4b7:	83 c4 0c             	add    $0xc,%esp
 4ba:	88 55 e7             	mov    %dl,-0x19(%ebp)
 4bd:	6a 01                	push   $0x1
 4bf:	57                   	push   %edi
 4c0:	56                   	push   %esi
 4c1:	e8 dd fd ff ff       	call   2a3 <write>
 4c6:	83 c4 10             	add    $0x10,%esp
 4c9:	31 c9                	xor    %ecx,%ecx
 4cb:	eb 95                	jmp    462 <printf+0x52>
 4cd:	8d 76 00             	lea    0x0(%esi),%esi
 4d0:	83 ec 0c             	sub    $0xc,%esp
 4d3:	b9 10 00 00 00       	mov    $0x10,%ecx
 4d8:	6a 00                	push   $0x0
 4da:	8b 45 d0             	mov    -0x30(%ebp),%eax
 4dd:	8b 10                	mov    (%eax),%edx
 4df:	89 f0                	mov    %esi,%eax
 4e1:	e8 7a fe ff ff       	call   360 <printint>
 4e6:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 4ea:	83 c4 10             	add    $0x10,%esp
 4ed:	31 c9                	xor    %ecx,%ecx
 4ef:	e9 6e ff ff ff       	jmp    462 <printf+0x52>
 4f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 4fb:	8b 10                	mov    (%eax),%edx
 4fd:	83 c0 04             	add    $0x4,%eax
 500:	89 45 d0             	mov    %eax,-0x30(%ebp)
 503:	85 d2                	test   %edx,%edx
 505:	0f 84 8d 00 00 00    	je     598 <printf+0x188>
 50b:	0f b6 02             	movzbl (%edx),%eax
 50e:	31 c9                	xor    %ecx,%ecx
 510:	84 c0                	test   %al,%al
 512:	0f 84 4a ff ff ff    	je     462 <printf+0x52>
 518:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 51b:	89 d3                	mov    %edx,%ebx
 51d:	8d 76 00             	lea    0x0(%esi),%esi
 520:	83 ec 04             	sub    $0x4,%esp
 523:	83 c3 01             	add    $0x1,%ebx
 526:	88 45 e7             	mov    %al,-0x19(%ebp)
 529:	6a 01                	push   $0x1
 52b:	57                   	push   %edi
 52c:	56                   	push   %esi
 52d:	e8 71 fd ff ff       	call   2a3 <write>
 532:	0f b6 03             	movzbl (%ebx),%eax
 535:	83 c4 10             	add    $0x10,%esp
 538:	84 c0                	test   %al,%al
 53a:	75 e4                	jne    520 <printf+0x110>
 53c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 53f:	31 c9                	xor    %ecx,%ecx
 541:	e9 1c ff ff ff       	jmp    462 <printf+0x52>
 546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 54d:	8d 76 00             	lea    0x0(%esi),%esi
 550:	83 ec 0c             	sub    $0xc,%esp
 553:	b9 0a 00 00 00       	mov    $0xa,%ecx
 558:	6a 01                	push   $0x1
 55a:	e9 7b ff ff ff       	jmp    4da <printf+0xca>
 55f:	90                   	nop
 560:	8b 45 d0             	mov    -0x30(%ebp),%eax
 563:	83 ec 04             	sub    $0x4,%esp
 566:	8b 00                	mov    (%eax),%eax
 568:	6a 01                	push   $0x1
 56a:	57                   	push   %edi
 56b:	56                   	push   %esi
 56c:	88 45 e7             	mov    %al,-0x19(%ebp)
 56f:	e8 2f fd ff ff       	call   2a3 <write>
 574:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 578:	83 c4 10             	add    $0x10,%esp
 57b:	31 c9                	xor    %ecx,%ecx
 57d:	e9 e0 fe ff ff       	jmp    462 <printf+0x52>
 582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 588:	88 55 e7             	mov    %dl,-0x19(%ebp)
 58b:	83 ec 04             	sub    $0x4,%esp
 58e:	e9 2a ff ff ff       	jmp    4bd <printf+0xad>
 593:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 597:	90                   	nop
 598:	ba 38 07 00 00       	mov    $0x738,%edx
 59d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 5a0:	b8 28 00 00 00       	mov    $0x28,%eax
 5a5:	89 d3                	mov    %edx,%ebx
 5a7:	e9 74 ff ff ff       	jmp    520 <printf+0x110>
 5ac:	66 90                	xchg   %ax,%ax
 5ae:	66 90                	xchg   %ax,%ax

000005b0 <free>:
 5b0:	55                   	push   %ebp
 5b1:	a1 40 0a 00 00       	mov    0xa40,%eax
 5b6:	89 e5                	mov    %esp,%ebp
 5b8:	57                   	push   %edi
 5b9:	56                   	push   %esi
 5ba:	53                   	push   %ebx
 5bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5be:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 5c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5c8:	89 c2                	mov    %eax,%edx
 5ca:	8b 00                	mov    (%eax),%eax
 5cc:	39 ca                	cmp    %ecx,%edx
 5ce:	73 30                	jae    600 <free+0x50>
 5d0:	39 c1                	cmp    %eax,%ecx
 5d2:	72 04                	jb     5d8 <free+0x28>
 5d4:	39 c2                	cmp    %eax,%edx
 5d6:	72 f0                	jb     5c8 <free+0x18>
 5d8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5db:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5de:	39 f8                	cmp    %edi,%eax
 5e0:	74 30                	je     612 <free+0x62>
 5e2:	89 43 f8             	mov    %eax,-0x8(%ebx)
 5e5:	8b 42 04             	mov    0x4(%edx),%eax
 5e8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5eb:	39 f1                	cmp    %esi,%ecx
 5ed:	74 3a                	je     629 <free+0x79>
 5ef:	89 0a                	mov    %ecx,(%edx)
 5f1:	5b                   	pop    %ebx
 5f2:	89 15 40 0a 00 00    	mov    %edx,0xa40
 5f8:	5e                   	pop    %esi
 5f9:	5f                   	pop    %edi
 5fa:	5d                   	pop    %ebp
 5fb:	c3                   	ret    
 5fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 600:	39 c2                	cmp    %eax,%edx
 602:	72 c4                	jb     5c8 <free+0x18>
 604:	39 c1                	cmp    %eax,%ecx
 606:	73 c0                	jae    5c8 <free+0x18>
 608:	8b 73 fc             	mov    -0x4(%ebx),%esi
 60b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 60e:	39 f8                	cmp    %edi,%eax
 610:	75 d0                	jne    5e2 <free+0x32>
 612:	03 70 04             	add    0x4(%eax),%esi
 615:	89 73 fc             	mov    %esi,-0x4(%ebx)
 618:	8b 02                	mov    (%edx),%eax
 61a:	8b 00                	mov    (%eax),%eax
 61c:	89 43 f8             	mov    %eax,-0x8(%ebx)
 61f:	8b 42 04             	mov    0x4(%edx),%eax
 622:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 625:	39 f1                	cmp    %esi,%ecx
 627:	75 c6                	jne    5ef <free+0x3f>
 629:	03 43 fc             	add    -0x4(%ebx),%eax
 62c:	89 15 40 0a 00 00    	mov    %edx,0xa40
 632:	89 42 04             	mov    %eax,0x4(%edx)
 635:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 638:	89 0a                	mov    %ecx,(%edx)
 63a:	5b                   	pop    %ebx
 63b:	5e                   	pop    %esi
 63c:	5f                   	pop    %edi
 63d:	5d                   	pop    %ebp
 63e:	c3                   	ret    
 63f:	90                   	nop

00000640 <malloc>:
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	57                   	push   %edi
 644:	56                   	push   %esi
 645:	53                   	push   %ebx
 646:	83 ec 1c             	sub    $0x1c,%esp
 649:	8b 45 08             	mov    0x8(%ebp),%eax
 64c:	8b 3d 40 0a 00 00    	mov    0xa40,%edi
 652:	8d 70 07             	lea    0x7(%eax),%esi
 655:	c1 ee 03             	shr    $0x3,%esi
 658:	83 c6 01             	add    $0x1,%esi
 65b:	85 ff                	test   %edi,%edi
 65d:	0f 84 9d 00 00 00    	je     700 <malloc+0xc0>
 663:	8b 17                	mov    (%edi),%edx
 665:	8b 4a 04             	mov    0x4(%edx),%ecx
 668:	39 f1                	cmp    %esi,%ecx
 66a:	73 6a                	jae    6d6 <malloc+0x96>
 66c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 671:	39 de                	cmp    %ebx,%esi
 673:	0f 43 de             	cmovae %esi,%ebx
 676:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 67d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 680:	eb 17                	jmp    699 <malloc+0x59>
 682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 688:	8b 02                	mov    (%edx),%eax
 68a:	8b 48 04             	mov    0x4(%eax),%ecx
 68d:	39 f1                	cmp    %esi,%ecx
 68f:	73 4f                	jae    6e0 <malloc+0xa0>
 691:	8b 3d 40 0a 00 00    	mov    0xa40,%edi
 697:	89 c2                	mov    %eax,%edx
 699:	39 d7                	cmp    %edx,%edi
 69b:	75 eb                	jne    688 <malloc+0x48>
 69d:	83 ec 0c             	sub    $0xc,%esp
 6a0:	ff 75 e4             	push   -0x1c(%ebp)
 6a3:	e8 63 fc ff ff       	call   30b <sbrk>
 6a8:	83 c4 10             	add    $0x10,%esp
 6ab:	83 f8 ff             	cmp    $0xffffffff,%eax
 6ae:	74 1c                	je     6cc <malloc+0x8c>
 6b0:	89 58 04             	mov    %ebx,0x4(%eax)
 6b3:	83 ec 0c             	sub    $0xc,%esp
 6b6:	83 c0 08             	add    $0x8,%eax
 6b9:	50                   	push   %eax
 6ba:	e8 f1 fe ff ff       	call   5b0 <free>
 6bf:	8b 15 40 0a 00 00    	mov    0xa40,%edx
 6c5:	83 c4 10             	add    $0x10,%esp
 6c8:	85 d2                	test   %edx,%edx
 6ca:	75 bc                	jne    688 <malloc+0x48>
 6cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6cf:	31 c0                	xor    %eax,%eax
 6d1:	5b                   	pop    %ebx
 6d2:	5e                   	pop    %esi
 6d3:	5f                   	pop    %edi
 6d4:	5d                   	pop    %ebp
 6d5:	c3                   	ret    
 6d6:	89 d0                	mov    %edx,%eax
 6d8:	89 fa                	mov    %edi,%edx
 6da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 6e0:	39 ce                	cmp    %ecx,%esi
 6e2:	74 4c                	je     730 <malloc+0xf0>
 6e4:	29 f1                	sub    %esi,%ecx
 6e6:	89 48 04             	mov    %ecx,0x4(%eax)
 6e9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
 6ec:	89 70 04             	mov    %esi,0x4(%eax)
 6ef:	89 15 40 0a 00 00    	mov    %edx,0xa40
 6f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6f8:	83 c0 08             	add    $0x8,%eax
 6fb:	5b                   	pop    %ebx
 6fc:	5e                   	pop    %esi
 6fd:	5f                   	pop    %edi
 6fe:	5d                   	pop    %ebp
 6ff:	c3                   	ret    
 700:	c7 05 40 0a 00 00 44 	movl   $0xa44,0xa40
 707:	0a 00 00 
 70a:	bf 44 0a 00 00       	mov    $0xa44,%edi
 70f:	c7 05 44 0a 00 00 44 	movl   $0xa44,0xa44
 716:	0a 00 00 
 719:	89 fa                	mov    %edi,%edx
 71b:	c7 05 48 0a 00 00 00 	movl   $0x0,0xa48
 722:	00 00 00 
 725:	e9 42 ff ff ff       	jmp    66c <malloc+0x2c>
 72a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 730:	8b 08                	mov    (%eax),%ecx
 732:	89 0a                	mov    %ecx,(%edx)
 734:	eb b9                	jmp    6ef <malloc+0xaf>
