//
//  CBCellSet1Comment.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBCellSet1Comment.h"
#import "UITextView+Placeholder.h"
#import "CBCell+CBCellSet1.h"
#import "CBFormItem+CBCellSet1.h"
#import <FontAwesome/NSString+FontAwesome.h>

@implementation CBCellSet1Comment

-(void)configureForFormItem:(CBComment *)formItem {
    
    //Call this before calling super so that if the subclass does set an icon for this formitem that that icon is shown
    [formItem setIcon:FAComment];
    
    [super configureForFormItem:formItem];
    
    [self.textView setPlaceholder:formItem.title];
    
    
}

-(CGFloat)height {
    return 120.0f;
}


@end
