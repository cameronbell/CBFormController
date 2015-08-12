//
//  CBCommentCell.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBCommentCell.h"
#import "UITextView+Placeholder.h"

@implementation CBCommentCell
@synthesize textView = _textView;
@synthesize pencilIcon = _pencilIcon;
@synthesize donelabel = _donelabel;

-(void)configureForFormItem:(CBComment *)formItem {
    
    [super configureForFormItem:formItem];
    
    [self.textView setUserInteractionEnabled:NO];
    [self.textView setDelegate:formItem];
    [self.donelabel setHidden:YES];
    
    //Uses a cocoapod that provides a category on UITextField that adds a placeholder property
    [self.textView setPlaceholder:formItem.placeholder];
    
    [self.textView setText:(NSString *)formItem.initialValue];
}


@end
