//
//  CBButtonCell.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBButtonCell.h"

@implementation CBButtonCell

-(void)configureForFormItem:(CBButton *)formItem {
    
    [super configureForFormItem:formItem];
    
    [self.titleLabel setTextAlignment:formItem.titleAlign];
    [self.titleLabel setTextColor:formItem.titleColor];
    
}

@end
