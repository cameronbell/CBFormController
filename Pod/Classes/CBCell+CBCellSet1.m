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
    
    UILabel *label = self.icon;
    label.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
    NSString *string = [NSString fontAwesomeIconStringForEnum:[[formItem.addOns objectForKey:@"CBCellSet1_icon"] integerValue]];
    [self.icon setText:string];
}


@end
