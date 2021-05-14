//
//  UIView+Addition.m
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/23.
//

#import "UIView+Addition.h"
#import <objc/runtime.h>
#import "NSObject+Swizzle.h"

@implementation UIView (Addition)

+ (void)load {
	[UIView sc_swizzleMethod:@selector(pointInside:withEvent:) withMethod:@selector(sc_pointInside:withEvent:)];
}

- (BOOL)sc_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
	if (UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero)) {
		return [self sc_pointInside:point withEvent:event];
	}

	CGRect relativeFrame = self.bounds;
	CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
	return CGRectContainsPoint(hitFrame, point);
}

- (void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets {
	NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
	objc_setAssociatedObject(self, @selector(hitTestEdgeInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)hitTestEdgeInsets {
	NSValue *value = objc_getAssociatedObject(self, @selector(hitTestEdgeInsets));
	if (value) {
		UIEdgeInsets edgeInsets;
		[value getValue:&edgeInsets];
		return edgeInsets;
	} else {
		return UIEdgeInsetsZero;
	}
}

@end
