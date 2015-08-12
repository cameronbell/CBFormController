//
//  CBCellSet1Text.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import "CBCellSet1Text.h"
#import "CBCell+CBCellSet1.h"

@implementation CBCellSet1Text

-(void)configureForFormItem:(CBText *)formItem {
    
    [super configureForFormItem:formItem];
    [self.textField setPlaceholder:formItem.title];
}

@end
