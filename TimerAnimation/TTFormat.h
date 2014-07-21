//
//  TTFormat.h
//  TTMobile
//
//  Created by Brim, Daniel on 7/16/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TTFormat)

- (NSString *)nicelyFormatted;

@end

@interface UIColor (TTFormat)

+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end