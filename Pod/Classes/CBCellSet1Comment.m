//
//  CBCellSet1Comment.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBCellSet1Comment.h"
#import "UITextView+Placeholder.h"

@implementation CBCellSet1Comment

-(void)configureForFormItem:(CBComment *)formItem {
    
    [super configureForFormItem:formItem];
    
    [self.textView setPlaceholder:formItem.title];
    
}

-(CGFloat)height {
    return 120.0f;
}


@end
