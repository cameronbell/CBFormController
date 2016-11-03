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
#import <FontAwesome/NSString+FontAwesome.h>

@implementation CBCellSet2Comment
/*
-(void)configureForFormItem:(CBComment *)formItem {
    
    //Call this before calling super so that if the subclass does set an icon for this formitem that that icon is shown
    [formItem setIcon:FAComment];
    
    [super configureForFormItem:formItem];
    
    [self.textView setPlaceholder:formItem.title];
    
    
}
*/
-(CGFloat)height {
    return 120.0f;
}


@end
