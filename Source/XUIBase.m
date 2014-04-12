/*
    XUIBase.m
    Copyright (c) 2012-2013, Ricci Adams.  All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following condition is met:
        * Redistributions of source code must retain the above copyright
          notice, this list of conditions and the following disclaimer.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL RICCI ADAMS BE LIABLE FOR ANY
    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import <objc/runtime.h>
#import <objc/message.h>

#import <XUIKit/XUIKit.h>

BOOL XUISwizzleMethod(Class cls, char plusOrMinus, SEL selA, SEL selB)
{
    if (plusOrMinus == '+') {
        const char *clsName = class_getName(cls);
        cls = objc_getMetaClass(clsName);
    }

	Method methodA = class_getInstanceMethod(cls, selA);
    if (!methodA) return NO;
	
	Method methodB = class_getInstanceMethod(cls, selB);
	if (!methodB) return NO;
	
	class_addMethod(cls, selA, class_getMethodImplementation(cls, selA), method_getTypeEncoding(methodA));
	class_addMethod(cls, selB, class_getMethodImplementation(cls, selB), method_getTypeEncoding(methodB));
	
	method_exchangeImplementations(class_getInstanceMethod(cls, selA), class_getInstanceMethod(cls, selB));

	return YES;
}


BOOL XUIAliasMethod(Class cls, char plusOrMinus, SEL originalSel, SEL aliasSel)
{
    BOOL result = NO;

    if (plusOrMinus == '+') {
        const char *clsName = class_getName(cls);
        cls = objc_getMetaClass(clsName);
    }

    Method method = class_getInstanceMethod(cls, originalSel);

    if (method) {
        IMP         imp    = method_getImplementation(method);
        const char *types  = method_getTypeEncoding(method);

        result = class_addMethod(cls, aliasSel, imp, types);
    }

#if DEBUG
    if (!result) {
        @autoreleasepool {
            NSLog(@"XUIAliasMethod(): could not alias '%@' to '%@'", NSStringFromSelector(originalSel), NSStringFromSelector(aliasSel));
        }
    }
#endif

    return result;
}

