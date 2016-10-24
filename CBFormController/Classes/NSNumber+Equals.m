//
//  NSNumber+Equals.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import "NSNumber+Equals.h"

@implementation NSNumber (Equals)

-(BOOL)equals:(NSNumber *)number {
    return [self isEqualToNumber:number];
}
@end
