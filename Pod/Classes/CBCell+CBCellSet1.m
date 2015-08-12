//
//  CBCell+CBCellSet1.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBCell+CBCellSet1.h"
#import "CBText.h"
#import "FAKFontAwesome.h"

//Using the address of this char as a key for the associated object created for the custom property
static char iconKey;

@implementation CBCell (CBCellSet1)

- (void)setIcon:(UILabel *)icon {
    [self setCustomPropertyWithObject:icon forKey:&iconKey];
}

- (UILabel *)icon {
    return (UILabel *)[self getCustomPropertyWithKey:&iconKey];
}

-(void)configureAddonsForFormItem:(CBText *)formItem {
    [self.icon setAttributedText:[(FAKIcon *)[formItem.addOns objectForKey:@"CBCellSet1_icon"] attributedString]];
}


@end
