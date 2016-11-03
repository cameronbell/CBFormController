//
//  CBCellSet1Text.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import "CBCellSet2Text.h"
//#import "CBCell+CBCellSet1.h"

@implementation CBCellSet2Text


-(void)configureForFormItem:(CBText *)formItem {
    
    [super configureForFormItem:formItem];
    
    [self.textField setPlaceholder:formItem.placeholder];
    
    [self.titleLabel setText:formItem.title];
}


@end
