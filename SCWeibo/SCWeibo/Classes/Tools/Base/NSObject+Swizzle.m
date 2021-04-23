//
//  NSObject+Swizzle.m
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/23.
//

#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

@implementation NSObject (Swizzle)

+ (BOOL)sc_swizzleMethod:(SEL)originalSEL withMethod:(SEL)alternateSEL {
	Method originalMethod = class_getInstanceMethod(self, originalSEL);
	if (!originalMethod) {
		return NO;
	}

	Method alternateMethod = class_getInstanceMethod(self, alternateSEL);
	if (!alternateMethod) {
		return NO;
	}

	class_addMethod(self,
	                originalSEL,
	                class_getMethodImplementation(self, originalSEL),
	                method_getTypeEncoding(originalMethod));
	class_addMethod(self,
	                alternateSEL,
	                class_getMethodImplementation(self, alternateSEL),
	                method_getTypeEncoding(alternateMethod));

	method_exchangeImplementations(class_getInstanceMethod(self, originalSEL), class_getInstanceMethod(self, alternateSEL));

	return YES;
}

+ (BOOL)sc_swizzleClassMethod:(SEL)originalSEL withClassMethod:(SEL)alternateSEL {
	return [object_getClass(self) sc_swizzleMethod:originalSEL withMethod:alternateSEL];
}

@end
