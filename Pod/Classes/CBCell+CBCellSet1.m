//
//  CBCell+CBCellSet1.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBCell+CBCellSet1.h"
#import <objc/runtime.h>

static char iconKey;

@implementation CBCell (CBCellSet1)

- (void)setIcon:(UILabel *)icon {
    objc_setAssociatedObject(self, &iconKey,
                             icon, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)icon {
    return objc_getAssociatedObject(self, &iconKey);
}

@end
