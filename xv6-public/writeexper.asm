
_writeexper:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 14             	sub    $0x14,%esp
    int fd;
    char *filename = "newfile.txt";
    char *data = "Hello, World!\n";

    fd = open(filename, O_CREATE | O_WRONLY);
  13:	68 01 02 00 00       	push   $0x201
  18:	68 68 08 00 00       	push   $0x868
  1d:	e8 d1 03 00 00       	call   3f3 <open>
    if(fd < 0) {
  22:	83 c4 10             	add    $0x10,%esp
  25:	85 c0                	test   %eax,%eax
  27:	0f 88 00 01 00 00    	js     12d <main+0x12d>
        printf(1, "Failed to create file %s\n", filename);
        exit();
    }

    if(write(fd, data, strlen(data)) != strlen(data)) {
  2d:	83 ec 0c             	sub    $0xc,%esp
  30:	89 c3                	mov    %eax,%ebx
  32:	68 8e 08 00 00       	push   $0x88e
  37:	e8 b4 01 00 00       	call   1f0 <strlen>
  3c:	83 c4 0c             	add    $0xc,%esp
  3f:	50                   	push   %eax
  40:	68 8e 08 00 00       	push   $0x88e
  45:	53                   	push   %ebx
  46:	e8 88 03 00 00       	call   3d3 <write>
  4b:	c7 04 24 8e 08 00 00 	movl   $0x88e,(%esp)
  52:	89 c6                	mov    %eax,%esi
  54:	e8 97 01 00 00       	call   1f0 <strlen>
  59:	83 c4 10             	add    $0x10,%esp
  5c:	39 c6                	cmp    %eax,%esi
  5e:	74 17                	je     77 <main+0x77>
        printf(1, "Failed to write to file %s\n", filename);
  60:	50                   	push   %eax
  61:	68 68 08 00 00       	push   $0x868
  66:	68 9d 08 00 00       	push   $0x89d
  6b:	6a 01                	push   $0x1
  6d:	e8 ce 04 00 00       	call   540 <printf>
        exit();
  72:	e8 3c 03 00 00       	call   3b3 <exit>
    }

    if(write(fd, data, strlen(data)) != strlen(data)) {
  77:	83 ec 0c             	sub    $0xc,%esp
  7a:	68 8e 08 00 00       	push   $0x88e
  7f:	e8 6c 01 00 00       	call   1f0 <strlen>
  84:	83 c4 0c             	add    $0xc,%esp
  87:	50                   	push   %eax
  88:	68 8e 08 00 00       	push   $0x88e
  8d:	53                   	push   %ebx
  8e:	e8 40 03 00 00       	call   3d3 <write>
  93:	c7 04 24 8e 08 00 00 	movl   $0x88e,(%esp)
  9a:	89 c6                	mov    %eax,%esi
  9c:	e8 4f 01 00 00       	call   1f0 <strlen>
  a1:	83 c4 10             	add    $0x10,%esp
  a4:	39 c6                	cmp    %eax,%esi
  a6:	75 b8                	jne    60 <main+0x60>
        printf(1, "Failed to write to file %s\n", filename);
        exit();
    }

    printf(1, "Successfully wrote to file %s\n", filename);
  a8:	51                   	push   %ecx
  a9:	68 68 08 00 00       	push   $0x868
  ae:	68 e0 08 00 00       	push   $0x8e0
  b3:	6a 01                	push   $0x1
  b5:	e8 86 04 00 00       	call   540 <printf>

    close(fd);
  ba:	89 1c 24             	mov    %ebx,(%esp)
  bd:	e8 19 03 00 00       	call   3db <close>

    char *newdata = "New content!\n";

    fd = open(filename, O_WRONLY);
  c2:	5b                   	pop    %ebx
  c3:	5e                   	pop    %esi
  c4:	6a 01                	push   $0x1
  c6:	68 68 08 00 00       	push   $0x868
  cb:	e8 23 03 00 00       	call   3f3 <open>
    if(fd < 0) {
  d0:	83 c4 10             	add    $0x10,%esp
    fd = open(filename, O_WRONLY);
  d3:	89 c3                	mov    %eax,%ebx
    if(fd < 0) {
  d5:	85 c0                	test   %eax,%eax
  d7:	78 6b                	js     144 <main+0x144>
        printf(1, "Failed to open file %s\n", filename);
        exit();
    }

    if(write(fd, newdata, strlen(data)) != strlen(data)) {
  d9:	83 ec 0c             	sub    $0xc,%esp
  dc:	68 8e 08 00 00       	push   $0x88e
  e1:	e8 0a 01 00 00       	call   1f0 <strlen>
  e6:	83 c4 0c             	add    $0xc,%esp
  e9:	50                   	push   %eax
  ea:	68 d1 08 00 00       	push   $0x8d1
  ef:	53                   	push   %ebx
  f0:	e8 de 02 00 00       	call   3d3 <write>
  f5:	c7 04 24 8e 08 00 00 	movl   $0x88e,(%esp)
  fc:	89 c6                	mov    %eax,%esi
  fe:	e8 ed 00 00 00       	call   1f0 <strlen>
 103:	83 c4 10             	add    $0x10,%esp
 106:	39 c6                	cmp    %eax,%esi
 108:	0f 85 52 ff ff ff    	jne    60 <main+0x60>
        printf(1, "Failed to write to file %s\n", filename);
        exit();
    }

    printf(1, "Successfully wrote to file %s\n", filename);
 10e:	50                   	push   %eax
 10f:	68 68 08 00 00       	push   $0x868
 114:	68 e0 08 00 00       	push   $0x8e0
 119:	6a 01                	push   $0x1
 11b:	e8 20 04 00 00       	call   540 <printf>

    close(fd);
 120:	89 1c 24             	mov    %ebx,(%esp)
 123:	e8 b3 02 00 00       	call   3db <close>

    exit();
 128:	e8 86 02 00 00       	call   3b3 <exit>
        printf(1, "Failed to create file %s\n", filename);
 12d:	50                   	push   %eax
 12e:	68 68 08 00 00       	push   $0x868
 133:	68 74 08 00 00       	push   $0x874
 138:	6a 01                	push   $0x1
 13a:	e8 01 04 00 00       	call   540 <printf>
        exit();
 13f:	e8 6f 02 00 00       	call   3b3 <exit>
        printf(1, "Failed to open file %s\n", filename);
 144:	52                   	push   %edx
 145:	68 68 08 00 00       	push   $0x868
 14a:	68 b9 08 00 00       	push   $0x8b9
 14f:	6a 01                	push   $0x1
 151:	e8 ea 03 00 00       	call   540 <printf>
        exit();
 156:	e8 58 02 00 00       	call   3b3 <exit>
 15b:	66 90                	xchg   %ax,%ax
 15d:	66 90                	xchg   %ax,%ax
 15f:	90                   	nop

00000160 <strcpy>:
 160:	55                   	push   %ebp
 161:	31 c0                	xor    %eax,%eax
 163:	89 e5                	mov    %esp,%ebp
 165:	53                   	push   %ebx
 166:	8b 4d 08             	mov    0x8(%ebp),%ecx
 169:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 170:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 174:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 177:	83 c0 01             	add    $0x1,%eax
 17a:	84 d2                	test   %dl,%dl
 17c:	75 f2                	jne    170 <strcpy+0x10>
 17e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 181:	89 c8                	mov    %ecx,%eax
 183:	c9                   	leave  
 184:	c3                   	ret    
 185:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 18c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000190 <strcmp>:
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	53                   	push   %ebx
 194:	8b 55 08             	mov    0x8(%ebp),%edx
 197:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 19a:	0f b6 02             	movzbl (%edx),%eax
 19d:	84 c0                	test   %al,%al
 19f:	75 17                	jne    1b8 <strcmp+0x28>
 1a1:	eb 3a                	jmp    1dd <strcmp+0x4d>
 1a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1a7:	90                   	nop
 1a8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
 1ac:	83 c2 01             	add    $0x1,%edx
 1af:	8d 59 01             	lea    0x1(%ecx),%ebx
 1b2:	84 c0                	test   %al,%al
 1b4:	74 1a                	je     1d0 <strcmp+0x40>
 1b6:	89 d9                	mov    %ebx,%ecx
 1b8:	0f b6 19             	movzbl (%ecx),%ebx
 1bb:	38 c3                	cmp    %al,%bl
 1bd:	74 e9                	je     1a8 <strcmp+0x18>
 1bf:	29 d8                	sub    %ebx,%eax
 1c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1c4:	c9                   	leave  
 1c5:	c3                   	ret    
 1c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1cd:	8d 76 00             	lea    0x0(%esi),%esi
 1d0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 1d4:	31 c0                	xor    %eax,%eax
 1d6:	29 d8                	sub    %ebx,%eax
 1d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1db:	c9                   	leave  
 1dc:	c3                   	ret    
 1dd:	0f b6 19             	movzbl (%ecx),%ebx
 1e0:	31 c0                	xor    %eax,%eax
 1e2:	eb db                	jmp    1bf <strcmp+0x2f>
 1e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1ef:	90                   	nop

000001f0 <strlen>:
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	8b 55 08             	mov    0x8(%ebp),%edx
 1f6:	80 3a 00             	cmpb   $0x0,(%edx)
 1f9:	74 15                	je     210 <strlen+0x20>
 1fb:	31 c0                	xor    %eax,%eax
 1fd:	8d 76 00             	lea    0x0(%esi),%esi
 200:	83 c0 01             	add    $0x1,%eax
 203:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 207:	89 c1                	mov    %eax,%ecx
 209:	75 f5                	jne    200 <strlen+0x10>
 20b:	89 c8                	mov    %ecx,%eax
 20d:	5d                   	pop    %ebp
 20e:	c3                   	ret    
 20f:	90                   	nop
 210:	31 c9                	xor    %ecx,%ecx
 212:	5d                   	pop    %ebp
 213:	89 c8                	mov    %ecx,%eax
 215:	c3                   	ret    
 216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 21d:	8d 76 00             	lea    0x0(%esi),%esi

00000220 <memset>:
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	57                   	push   %edi
 224:	8b 55 08             	mov    0x8(%ebp),%edx
 227:	8b 4d 10             	mov    0x10(%ebp),%ecx
 22a:	8b 45 0c             	mov    0xc(%ebp),%eax
 22d:	89 d7                	mov    %edx,%edi
 22f:	fc                   	cld    
 230:	f3 aa                	rep stos %al,%es:(%edi)
 232:	8b 7d fc             	mov    -0x4(%ebp),%edi
 235:	89 d0                	mov    %edx,%eax
 237:	c9                   	leave  
 238:	c3                   	ret    
 239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000240 <strchr>:
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
 24a:	0f b6 10             	movzbl (%eax),%edx
 24d:	84 d2                	test   %dl,%dl
 24f:	75 12                	jne    263 <strchr+0x23>
 251:	eb 1d                	jmp    270 <strchr+0x30>
 253:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 257:	90                   	nop
 258:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 25c:	83 c0 01             	add    $0x1,%eax
 25f:	84 d2                	test   %dl,%dl
 261:	74 0d                	je     270 <strchr+0x30>
 263:	38 d1                	cmp    %dl,%cl
 265:	75 f1                	jne    258 <strchr+0x18>
 267:	5d                   	pop    %ebp
 268:	c3                   	ret    
 269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 270:	31 c0                	xor    %eax,%eax
 272:	5d                   	pop    %ebp
 273:	c3                   	ret    
 274:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 27f:	90                   	nop

00000280 <gets>:
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	57                   	push   %edi
 284:	56                   	push   %esi
 285:	8d 7d e7             	lea    -0x19(%ebp),%edi
 288:	53                   	push   %ebx
 289:	31 db                	xor    %ebx,%ebx
 28b:	83 ec 1c             	sub    $0x1c,%esp
 28e:	eb 27                	jmp    2b7 <gets+0x37>
 290:	83 ec 04             	sub    $0x4,%esp
 293:	6a 01                	push   $0x1
 295:	57                   	push   %edi
 296:	6a 00                	push   $0x0
 298:	e8 2e 01 00 00       	call   3cb <read>
 29d:	83 c4 10             	add    $0x10,%esp
 2a0:	85 c0                	test   %eax,%eax
 2a2:	7e 1d                	jle    2c1 <gets+0x41>
 2a4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2a8:	8b 55 08             	mov    0x8(%ebp),%edx
 2ab:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
 2af:	3c 0a                	cmp    $0xa,%al
 2b1:	74 1d                	je     2d0 <gets+0x50>
 2b3:	3c 0d                	cmp    $0xd,%al
 2b5:	74 19                	je     2d0 <gets+0x50>
 2b7:	89 de                	mov    %ebx,%esi
 2b9:	83 c3 01             	add    $0x1,%ebx
 2bc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2bf:	7c cf                	jl     290 <gets+0x10>
 2c1:	8b 45 08             	mov    0x8(%ebp),%eax
 2c4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
 2c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2cb:	5b                   	pop    %ebx
 2cc:	5e                   	pop    %esi
 2cd:	5f                   	pop    %edi
 2ce:	5d                   	pop    %ebp
 2cf:	c3                   	ret    
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
 2d3:	89 de                	mov    %ebx,%esi
 2d5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
 2d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2dc:	5b                   	pop    %ebx
 2dd:	5e                   	pop    %esi
 2de:	5f                   	pop    %edi
 2df:	5d                   	pop    %ebp
 2e0:	c3                   	ret    
 2e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ef:	90                   	nop

000002f0 <stat>:
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	56                   	push   %esi
 2f4:	53                   	push   %ebx
 2f5:	83 ec 08             	sub    $0x8,%esp
 2f8:	6a 00                	push   $0x0
 2fa:	ff 75 08             	push   0x8(%ebp)
 2fd:	e8 f1 00 00 00       	call   3f3 <open>
 302:	83 c4 10             	add    $0x10,%esp
 305:	85 c0                	test   %eax,%eax
 307:	78 27                	js     330 <stat+0x40>
 309:	83 ec 08             	sub    $0x8,%esp
 30c:	ff 75 0c             	push   0xc(%ebp)
 30f:	89 c3                	mov    %eax,%ebx
 311:	50                   	push   %eax
 312:	e8 f4 00 00 00       	call   40b <fstat>
 317:	89 1c 24             	mov    %ebx,(%esp)
 31a:	89 c6                	mov    %eax,%esi
 31c:	e8 ba 00 00 00       	call   3db <close>
 321:	83 c4 10             	add    $0x10,%esp
 324:	8d 65 f8             	lea    -0x8(%ebp),%esp
 327:	89 f0                	mov    %esi,%eax
 329:	5b                   	pop    %ebx
 32a:	5e                   	pop    %esi
 32b:	5d                   	pop    %ebp
 32c:	c3                   	ret    
 32d:	8d 76 00             	lea    0x0(%esi),%esi
 330:	be ff ff ff ff       	mov    $0xffffffff,%esi
 335:	eb ed                	jmp    324 <stat+0x34>
 337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 33e:	66 90                	xchg   %ax,%ax

00000340 <atoi>:
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	53                   	push   %ebx
 344:	8b 55 08             	mov    0x8(%ebp),%edx
 347:	0f be 02             	movsbl (%edx),%eax
 34a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 34d:	80 f9 09             	cmp    $0x9,%cl
 350:	b9 00 00 00 00       	mov    $0x0,%ecx
 355:	77 1e                	ja     375 <atoi+0x35>
 357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 35e:	66 90                	xchg   %ax,%ax
 360:	83 c2 01             	add    $0x1,%edx
 363:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 366:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
 36a:	0f be 02             	movsbl (%edx),%eax
 36d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 370:	80 fb 09             	cmp    $0x9,%bl
 373:	76 eb                	jbe    360 <atoi+0x20>
 375:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 378:	89 c8                	mov    %ecx,%eax
 37a:	c9                   	leave  
 37b:	c3                   	ret    
 37c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000380 <memmove>:
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	8b 45 10             	mov    0x10(%ebp),%eax
 387:	8b 55 08             	mov    0x8(%ebp),%edx
 38a:	56                   	push   %esi
 38b:	8b 75 0c             	mov    0xc(%ebp),%esi
 38e:	85 c0                	test   %eax,%eax
 390:	7e 13                	jle    3a5 <memmove+0x25>
 392:	01 d0                	add    %edx,%eax
 394:	89 d7                	mov    %edx,%edi
 396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 39d:	8d 76 00             	lea    0x0(%esi),%esi
 3a0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
 3a1:	39 f8                	cmp    %edi,%eax
 3a3:	75 fb                	jne    3a0 <memmove+0x20>
 3a5:	5e                   	pop    %esi
 3a6:	89 d0                	mov    %edx,%eax
 3a8:	5f                   	pop    %edi
 3a9:	5d                   	pop    %ebp
 3aa:	c3                   	ret    

000003ab <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3ab:	b8 01 00 00 00       	mov    $0x1,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <exit>:
SYSCALL(exit)
 3b3:	b8 02 00 00 00       	mov    $0x2,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <wait>:
SYSCALL(wait)
 3bb:	b8 03 00 00 00       	mov    $0x3,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <pipe>:
SYSCALL(pipe)
 3c3:	b8 04 00 00 00       	mov    $0x4,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <read>:
SYSCALL(read)
 3cb:	b8 05 00 00 00       	mov    $0x5,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <write>:
SYSCALL(write)
 3d3:	b8 10 00 00 00       	mov    $0x10,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <close>:
SYSCALL(close)
 3db:	b8 15 00 00 00       	mov    $0x15,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <kill>:
SYSCALL(kill)
 3e3:	b8 06 00 00 00       	mov    $0x6,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <exec>:
SYSCALL(exec)
 3eb:	b8 07 00 00 00       	mov    $0x7,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <open>:
SYSCALL(open)
 3f3:	b8 0f 00 00 00       	mov    $0xf,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <mknod>:
SYSCALL(mknod)
 3fb:	b8 11 00 00 00       	mov    $0x11,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <unlink>:
SYSCALL(unlink)
 403:	b8 12 00 00 00       	mov    $0x12,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <fstat>:
SYSCALL(fstat)
 40b:	b8 08 00 00 00       	mov    $0x8,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <link>:
SYSCALL(link)
 413:	b8 13 00 00 00       	mov    $0x13,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <mkdir>:
SYSCALL(mkdir)
 41b:	b8 14 00 00 00       	mov    $0x14,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <chdir>:
SYSCALL(chdir)
 423:	b8 09 00 00 00       	mov    $0x9,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <dup>:
SYSCALL(dup)
 42b:	b8 0a 00 00 00       	mov    $0xa,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <getpid>:
SYSCALL(getpid)
 433:	b8 0b 00 00 00       	mov    $0xb,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <sbrk>:
SYSCALL(sbrk)
 43b:	b8 0c 00 00 00       	mov    $0xc,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <sleep>:
SYSCALL(sleep)
 443:	b8 0d 00 00 00       	mov    $0xd,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <uptime>:
SYSCALL(uptime)
 44b:	b8 0e 00 00 00       	mov    $0xe,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <getfilename>:
SYSCALL(getfilename)
 453:	b8 16 00 00 00       	mov    $0x16,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <wmap>:
SYSCALL(wmap)
 45b:	b8 17 00 00 00       	mov    $0x17,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <wunmap>:
SYSCALL(wunmap)
 463:	b8 18 00 00 00       	mov    $0x18,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <wremap>:
SYSCALL(wremap)
 46b:	b8 19 00 00 00       	mov    $0x19,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <getpgdirinfo>:
SYSCALL(getpgdirinfo)
 473:	b8 1b 00 00 00       	mov    $0x1b,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <getwmapinfo>:
SYSCALL(getwmapinfo)
 47b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    
 483:	66 90                	xchg   %ax,%ax
 485:	66 90                	xchg   %ax,%ax
 487:	66 90                	xchg   %ax,%ax
 489:	66 90                	xchg   %ax,%ax
 48b:	66 90                	xchg   %ax,%ax
 48d:	66 90                	xchg   %ax,%ax
 48f:	90                   	nop

00000490 <printint>:
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	57                   	push   %edi
 494:	56                   	push   %esi
 495:	53                   	push   %ebx
 496:	83 ec 3c             	sub    $0x3c,%esp
 499:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
 49c:	89 d1                	mov    %edx,%ecx
 49e:	89 45 b8             	mov    %eax,-0x48(%ebp)
 4a1:	85 d2                	test   %edx,%edx
 4a3:	0f 89 7f 00 00 00    	jns    528 <printint+0x98>
 4a9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4ad:	74 79                	je     528 <printint+0x98>
 4af:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
 4b6:	f7 d9                	neg    %ecx
 4b8:	31 db                	xor    %ebx,%ebx
 4ba:	8d 75 d7             	lea    -0x29(%ebp),%esi
 4bd:	8d 76 00             	lea    0x0(%esi),%esi
 4c0:	89 c8                	mov    %ecx,%eax
 4c2:	31 d2                	xor    %edx,%edx
 4c4:	89 cf                	mov    %ecx,%edi
 4c6:	f7 75 c4             	divl   -0x3c(%ebp)
 4c9:	0f b6 92 60 09 00 00 	movzbl 0x960(%edx),%edx
 4d0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 4d3:	89 d8                	mov    %ebx,%eax
 4d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
 4d8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
 4db:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
 4de:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 4e1:	76 dd                	jbe    4c0 <printint+0x30>
 4e3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 4e6:	85 c9                	test   %ecx,%ecx
 4e8:	74 0c                	je     4f6 <printint+0x66>
 4ea:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 4ef:	89 d8                	mov    %ebx,%eax
 4f1:	ba 2d 00 00 00       	mov    $0x2d,%edx
 4f6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 4f9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 4fd:	eb 07                	jmp    506 <printint+0x76>
 4ff:	90                   	nop
 500:	0f b6 13             	movzbl (%ebx),%edx
 503:	83 eb 01             	sub    $0x1,%ebx
 506:	83 ec 04             	sub    $0x4,%esp
 509:	88 55 d7             	mov    %dl,-0x29(%ebp)
 50c:	6a 01                	push   $0x1
 50e:	56                   	push   %esi
 50f:	57                   	push   %edi
 510:	e8 be fe ff ff       	call   3d3 <write>
 515:	83 c4 10             	add    $0x10,%esp
 518:	39 de                	cmp    %ebx,%esi
 51a:	75 e4                	jne    500 <printint+0x70>
 51c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 51f:	5b                   	pop    %ebx
 520:	5e                   	pop    %esi
 521:	5f                   	pop    %edi
 522:	5d                   	pop    %ebp
 523:	c3                   	ret    
 524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 528:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 52f:	eb 87                	jmp    4b8 <printint+0x28>
 531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 538:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 53f:	90                   	nop

00000540 <printf>:
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	57                   	push   %edi
 544:	56                   	push   %esi
 545:	53                   	push   %ebx
 546:	83 ec 2c             	sub    $0x2c,%esp
 549:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 54c:	8b 75 08             	mov    0x8(%ebp),%esi
 54f:	0f b6 13             	movzbl (%ebx),%edx
 552:	84 d2                	test   %dl,%dl
 554:	74 6a                	je     5c0 <printf+0x80>
 556:	8d 45 10             	lea    0x10(%ebp),%eax
 559:	83 c3 01             	add    $0x1,%ebx
 55c:	8d 7d e7             	lea    -0x19(%ebp),%edi
 55f:	31 c9                	xor    %ecx,%ecx
 561:	89 45 d0             	mov    %eax,-0x30(%ebp)
 564:	eb 36                	jmp    59c <printf+0x5c>
 566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 56d:	8d 76 00             	lea    0x0(%esi),%esi
 570:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 573:	b9 25 00 00 00       	mov    $0x25,%ecx
 578:	83 f8 25             	cmp    $0x25,%eax
 57b:	74 15                	je     592 <printf+0x52>
 57d:	83 ec 04             	sub    $0x4,%esp
 580:	88 55 e7             	mov    %dl,-0x19(%ebp)
 583:	6a 01                	push   $0x1
 585:	57                   	push   %edi
 586:	56                   	push   %esi
 587:	e8 47 fe ff ff       	call   3d3 <write>
 58c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 58f:	83 c4 10             	add    $0x10,%esp
 592:	0f b6 13             	movzbl (%ebx),%edx
 595:	83 c3 01             	add    $0x1,%ebx
 598:	84 d2                	test   %dl,%dl
 59a:	74 24                	je     5c0 <printf+0x80>
 59c:	0f b6 c2             	movzbl %dl,%eax
 59f:	85 c9                	test   %ecx,%ecx
 5a1:	74 cd                	je     570 <printf+0x30>
 5a3:	83 f9 25             	cmp    $0x25,%ecx
 5a6:	75 ea                	jne    592 <printf+0x52>
 5a8:	83 f8 25             	cmp    $0x25,%eax
 5ab:	0f 84 07 01 00 00    	je     6b8 <printf+0x178>
 5b1:	83 e8 63             	sub    $0x63,%eax
 5b4:	83 f8 15             	cmp    $0x15,%eax
 5b7:	77 17                	ja     5d0 <printf+0x90>
 5b9:	ff 24 85 08 09 00 00 	jmp    *0x908(,%eax,4)
 5c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5c3:	5b                   	pop    %ebx
 5c4:	5e                   	pop    %esi
 5c5:	5f                   	pop    %edi
 5c6:	5d                   	pop    %ebp
 5c7:	c3                   	ret    
 5c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5cf:	90                   	nop
 5d0:	83 ec 04             	sub    $0x4,%esp
 5d3:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 5d6:	6a 01                	push   $0x1
 5d8:	57                   	push   %edi
 5d9:	56                   	push   %esi
 5da:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5de:	e8 f0 fd ff ff       	call   3d3 <write>
 5e3:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
 5e7:	83 c4 0c             	add    $0xc,%esp
 5ea:	88 55 e7             	mov    %dl,-0x19(%ebp)
 5ed:	6a 01                	push   $0x1
 5ef:	57                   	push   %edi
 5f0:	56                   	push   %esi
 5f1:	e8 dd fd ff ff       	call   3d3 <write>
 5f6:	83 c4 10             	add    $0x10,%esp
 5f9:	31 c9                	xor    %ecx,%ecx
 5fb:	eb 95                	jmp    592 <printf+0x52>
 5fd:	8d 76 00             	lea    0x0(%esi),%esi
 600:	83 ec 0c             	sub    $0xc,%esp
 603:	b9 10 00 00 00       	mov    $0x10,%ecx
 608:	6a 00                	push   $0x0
 60a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 60d:	8b 10                	mov    (%eax),%edx
 60f:	89 f0                	mov    %esi,%eax
 611:	e8 7a fe ff ff       	call   490 <printint>
 616:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 61a:	83 c4 10             	add    $0x10,%esp
 61d:	31 c9                	xor    %ecx,%ecx
 61f:	e9 6e ff ff ff       	jmp    592 <printf+0x52>
 624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 628:	8b 45 d0             	mov    -0x30(%ebp),%eax
 62b:	8b 10                	mov    (%eax),%edx
 62d:	83 c0 04             	add    $0x4,%eax
 630:	89 45 d0             	mov    %eax,-0x30(%ebp)
 633:	85 d2                	test   %edx,%edx
 635:	0f 84 8d 00 00 00    	je     6c8 <printf+0x188>
 63b:	0f b6 02             	movzbl (%edx),%eax
 63e:	31 c9                	xor    %ecx,%ecx
 640:	84 c0                	test   %al,%al
 642:	0f 84 4a ff ff ff    	je     592 <printf+0x52>
 648:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 64b:	89 d3                	mov    %edx,%ebx
 64d:	8d 76 00             	lea    0x0(%esi),%esi
 650:	83 ec 04             	sub    $0x4,%esp
 653:	83 c3 01             	add    $0x1,%ebx
 656:	88 45 e7             	mov    %al,-0x19(%ebp)
 659:	6a 01                	push   $0x1
 65b:	57                   	push   %edi
 65c:	56                   	push   %esi
 65d:	e8 71 fd ff ff       	call   3d3 <write>
 662:	0f b6 03             	movzbl (%ebx),%eax
 665:	83 c4 10             	add    $0x10,%esp
 668:	84 c0                	test   %al,%al
 66a:	75 e4                	jne    650 <printf+0x110>
 66c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 66f:	31 c9                	xor    %ecx,%ecx
 671:	e9 1c ff ff ff       	jmp    592 <printf+0x52>
 676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 67d:	8d 76 00             	lea    0x0(%esi),%esi
 680:	83 ec 0c             	sub    $0xc,%esp
 683:	b9 0a 00 00 00       	mov    $0xa,%ecx
 688:	6a 01                	push   $0x1
 68a:	e9 7b ff ff ff       	jmp    60a <printf+0xca>
 68f:	90                   	nop
 690:	8b 45 d0             	mov    -0x30(%ebp),%eax
 693:	83 ec 04             	sub    $0x4,%esp
 696:	8b 00                	mov    (%eax),%eax
 698:	6a 01                	push   $0x1
 69a:	57                   	push   %edi
 69b:	56                   	push   %esi
 69c:	88 45 e7             	mov    %al,-0x19(%ebp)
 69f:	e8 2f fd ff ff       	call   3d3 <write>
 6a4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 6a8:	83 c4 10             	add    $0x10,%esp
 6ab:	31 c9                	xor    %ecx,%ecx
 6ad:	e9 e0 fe ff ff       	jmp    592 <printf+0x52>
 6b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 6b8:	88 55 e7             	mov    %dl,-0x19(%ebp)
 6bb:	83 ec 04             	sub    $0x4,%esp
 6be:	e9 2a ff ff ff       	jmp    5ed <printf+0xad>
 6c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6c7:	90                   	nop
 6c8:	ba ff 08 00 00       	mov    $0x8ff,%edx
 6cd:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 6d0:	b8 28 00 00 00       	mov    $0x28,%eax
 6d5:	89 d3                	mov    %edx,%ebx
 6d7:	e9 74 ff ff ff       	jmp    650 <printf+0x110>
 6dc:	66 90                	xchg   %ax,%ax
 6de:	66 90                	xchg   %ax,%ax

000006e0 <free>:
 6e0:	55                   	push   %ebp
 6e1:	a1 10 0c 00 00       	mov    0xc10,%eax
 6e6:	89 e5                	mov    %esp,%ebp
 6e8:	57                   	push   %edi
 6e9:	56                   	push   %esi
 6ea:	53                   	push   %ebx
 6eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 6f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6f8:	89 c2                	mov    %eax,%edx
 6fa:	8b 00                	mov    (%eax),%eax
 6fc:	39 ca                	cmp    %ecx,%edx
 6fe:	73 30                	jae    730 <free+0x50>
 700:	39 c1                	cmp    %eax,%ecx
 702:	72 04                	jb     708 <free+0x28>
 704:	39 c2                	cmp    %eax,%edx
 706:	72 f0                	jb     6f8 <free+0x18>
 708:	8b 73 fc             	mov    -0x4(%ebx),%esi
 70b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 70e:	39 f8                	cmp    %edi,%eax
 710:	74 30                	je     742 <free+0x62>
 712:	89 43 f8             	mov    %eax,-0x8(%ebx)
 715:	8b 42 04             	mov    0x4(%edx),%eax
 718:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 71b:	39 f1                	cmp    %esi,%ecx
 71d:	74 3a                	je     759 <free+0x79>
 71f:	89 0a                	mov    %ecx,(%edx)
 721:	5b                   	pop    %ebx
 722:	89 15 10 0c 00 00    	mov    %edx,0xc10
 728:	5e                   	pop    %esi
 729:	5f                   	pop    %edi
 72a:	5d                   	pop    %ebp
 72b:	c3                   	ret    
 72c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 730:	39 c2                	cmp    %eax,%edx
 732:	72 c4                	jb     6f8 <free+0x18>
 734:	39 c1                	cmp    %eax,%ecx
 736:	73 c0                	jae    6f8 <free+0x18>
 738:	8b 73 fc             	mov    -0x4(%ebx),%esi
 73b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 73e:	39 f8                	cmp    %edi,%eax
 740:	75 d0                	jne    712 <free+0x32>
 742:	03 70 04             	add    0x4(%eax),%esi
 745:	89 73 fc             	mov    %esi,-0x4(%ebx)
 748:	8b 02                	mov    (%edx),%eax
 74a:	8b 00                	mov    (%eax),%eax
 74c:	89 43 f8             	mov    %eax,-0x8(%ebx)
 74f:	8b 42 04             	mov    0x4(%edx),%eax
 752:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 755:	39 f1                	cmp    %esi,%ecx
 757:	75 c6                	jne    71f <free+0x3f>
 759:	03 43 fc             	add    -0x4(%ebx),%eax
 75c:	89 15 10 0c 00 00    	mov    %edx,0xc10
 762:	89 42 04             	mov    %eax,0x4(%edx)
 765:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 768:	89 0a                	mov    %ecx,(%edx)
 76a:	5b                   	pop    %ebx
 76b:	5e                   	pop    %esi
 76c:	5f                   	pop    %edi
 76d:	5d                   	pop    %ebp
 76e:	c3                   	ret    
 76f:	90                   	nop

00000770 <malloc>:
 770:	55                   	push   %ebp
 771:	89 e5                	mov    %esp,%ebp
 773:	57                   	push   %edi
 774:	56                   	push   %esi
 775:	53                   	push   %ebx
 776:	83 ec 1c             	sub    $0x1c,%esp
 779:	8b 45 08             	mov    0x8(%ebp),%eax
 77c:	8b 3d 10 0c 00 00    	mov    0xc10,%edi
 782:	8d 70 07             	lea    0x7(%eax),%esi
 785:	c1 ee 03             	shr    $0x3,%esi
 788:	83 c6 01             	add    $0x1,%esi
 78b:	85 ff                	test   %edi,%edi
 78d:	0f 84 9d 00 00 00    	je     830 <malloc+0xc0>
 793:	8b 17                	mov    (%edi),%edx
 795:	8b 4a 04             	mov    0x4(%edx),%ecx
 798:	39 f1                	cmp    %esi,%ecx
 79a:	73 6a                	jae    806 <malloc+0x96>
 79c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7a1:	39 de                	cmp    %ebx,%esi
 7a3:	0f 43 de             	cmovae %esi,%ebx
 7a6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 7ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 7b0:	eb 17                	jmp    7c9 <malloc+0x59>
 7b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 7b8:	8b 02                	mov    (%edx),%eax
 7ba:	8b 48 04             	mov    0x4(%eax),%ecx
 7bd:	39 f1                	cmp    %esi,%ecx
 7bf:	73 4f                	jae    810 <malloc+0xa0>
 7c1:	8b 3d 10 0c 00 00    	mov    0xc10,%edi
 7c7:	89 c2                	mov    %eax,%edx
 7c9:	39 d7                	cmp    %edx,%edi
 7cb:	75 eb                	jne    7b8 <malloc+0x48>
 7cd:	83 ec 0c             	sub    $0xc,%esp
 7d0:	ff 75 e4             	push   -0x1c(%ebp)
 7d3:	e8 63 fc ff ff       	call   43b <sbrk>
 7d8:	83 c4 10             	add    $0x10,%esp
 7db:	83 f8 ff             	cmp    $0xffffffff,%eax
 7de:	74 1c                	je     7fc <malloc+0x8c>
 7e0:	89 58 04             	mov    %ebx,0x4(%eax)
 7e3:	83 ec 0c             	sub    $0xc,%esp
 7e6:	83 c0 08             	add    $0x8,%eax
 7e9:	50                   	push   %eax
 7ea:	e8 f1 fe ff ff       	call   6e0 <free>
 7ef:	8b 15 10 0c 00 00    	mov    0xc10,%edx
 7f5:	83 c4 10             	add    $0x10,%esp
 7f8:	85 d2                	test   %edx,%edx
 7fa:	75 bc                	jne    7b8 <malloc+0x48>
 7fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7ff:	31 c0                	xor    %eax,%eax
 801:	5b                   	pop    %ebx
 802:	5e                   	pop    %esi
 803:	5f                   	pop    %edi
 804:	5d                   	pop    %ebp
 805:	c3                   	ret    
 806:	89 d0                	mov    %edx,%eax
 808:	89 fa                	mov    %edi,%edx
 80a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 810:	39 ce                	cmp    %ecx,%esi
 812:	74 4c                	je     860 <malloc+0xf0>
 814:	29 f1                	sub    %esi,%ecx
 816:	89 48 04             	mov    %ecx,0x4(%eax)
 819:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
 81c:	89 70 04             	mov    %esi,0x4(%eax)
 81f:	89 15 10 0c 00 00    	mov    %edx,0xc10
 825:	8d 65 f4             	lea    -0xc(%ebp),%esp
 828:	83 c0 08             	add    $0x8,%eax
 82b:	5b                   	pop    %ebx
 82c:	5e                   	pop    %esi
 82d:	5f                   	pop    %edi
 82e:	5d                   	pop    %ebp
 82f:	c3                   	ret    
 830:	c7 05 10 0c 00 00 14 	movl   $0xc14,0xc10
 837:	0c 00 00 
 83a:	bf 14 0c 00 00       	mov    $0xc14,%edi
 83f:	c7 05 14 0c 00 00 14 	movl   $0xc14,0xc14
 846:	0c 00 00 
 849:	89 fa                	mov    %edi,%edx
 84b:	c7 05 18 0c 00 00 00 	movl   $0x0,0xc18
 852:	00 00 00 
 855:	e9 42 ff ff ff       	jmp    79c <malloc+0x2c>
 85a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 860:	8b 08                	mov    (%eax),%ecx
 862:	89 0a                	mov    %ecx,(%edx)
 864:	eb b9                	jmp    81f <malloc+0xaf>
