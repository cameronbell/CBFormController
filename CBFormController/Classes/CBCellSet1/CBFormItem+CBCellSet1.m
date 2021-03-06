//
//  CBFormItem+CBCellSet1.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBFormItem+CBCellSet1.h"



@implementation CBFormItem (CBCellSet1)

-(void)setIcon:(FAIcon)icon {
    [self.addOns setObject:[NSNumber numberWithInteger:icon] forKey:@"CBCellSet1_icon"];
}

-(void)setIconColor:(UIColor *)color {
    [self.addOns setObject:color forKey:@"CBCellSet1_icon_color"];
}

- (void)setIcon:(FAIcon)icon withColor:(UIColor *)color {
    [self setIcon:icon];
    [self setIconColor:color];
}

@end
