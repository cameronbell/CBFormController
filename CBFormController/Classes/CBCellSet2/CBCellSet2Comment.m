//
//  CBCellSet2Comment.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBCellSet2Comment.h"
#import "UITextView+Placeholder.h"
//#import "CBCell+CBCellSet2.h"
//#import "CBFormItem+CBCellSet2.h"

@implementation CBCellSet2Comment

-(void)configureForFormItem:(CBComment *)formItem {
    
    [super configureForFormItem:formItem];
    
    [self.textView setPlaceholder:formItem.placeholder];
    [self.titleLabel setText:formItem.title];
}

-(CGFloat)height {
    return 120.0f;
}


@end
