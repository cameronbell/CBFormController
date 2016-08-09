//
//  CBFormItem+CBCellSet1.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBFormItem.h"
#import <FontAwesome/NSString+FontAwesome.h>

@interface CBFormItem (CBCellSet1)
-(void)setIcon:(FAIcon)icon;
-(void)setIconColor:(UIColor *)color;

//Sets an icon in the given color
- (void)setIcon:(FAIcon)icon withColor:(UIColor *)color; 
@end
