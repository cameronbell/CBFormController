//
//  CBCell+CBCellSet1.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBCell+CBCellSet1.h"
#import "CBText.h"
#import <FontAwesome/NSString+FontAwesome.h>


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
    
    NSNumber *iconInteger = [formItem.addOns objectForKey:@"CBCellSet1_icon"];
    if (iconInteger) {
        self.icon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
        [self.icon setTextColor:[formItem.addOns objectForKey:@"CBCellSet1_icon_color"]];
        NSString *string = [NSString fontAwesomeIconStringForEnum:[iconInteger integerValue]];
        [self.icon setText:string];
        
    }else {
        [self.icon setText:@""];
    }
}


@end
