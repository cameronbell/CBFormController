//
//  CBCellSet.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import "CBCellSet.h"


@implementation CBCellSet


-(CGFloat)defaultHeight {
    NSAssert(NO, @"This method is abstract.");
    return 0;
}

-(CGFloat)defaultTwoLineHeight {
    NSAssert(NO, @"This method is abstract.");
    return 0;
}

-(NSString *)cellClassStringForFormItemClass:(Class)formItemClass {
    
    //Remove the CB prefix from the formItemClass string and fail if it doesn't have that prefix.
    NSString *classString = NSStringFromClass(formItemClass);
    NSString *noprefixClassString = [NSStringFromClass(formItemClass) copy];
    if ([classString hasPrefix:@"CB"]){
        noprefixClassString = [classString substringFromIndex:[@"CB" length]];
    }else{
        NSAssert(NO, @"All FormItem classes should have CBPrefix.");
    }
    
    //Return the name of the cell as the concatenation of the name of this CBCellSet subclass and the name of the CBFormItemClass without the CB prefix.
    return [NSString stringWithFormat:@"%@%@",NSStringFromClass([self class]),noprefixClassString];

}


@end
