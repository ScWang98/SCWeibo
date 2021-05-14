//
//  NSObject+Swizzle.h
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Swizzle)

+ (BOOL)sc_swizzleMethod:(SEL)originalSEL withMethod:(SEL)alternateSEL;

+ (BOOL)sc_swizzleClassMethod:(SEL)originalSEL withClassMethod:(SEL)alternateSEL;

@end

NS_ASSUME_NONNULL_END
