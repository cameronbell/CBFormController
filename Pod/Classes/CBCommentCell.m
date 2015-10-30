//
//  CBCommentCell.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBCommentCell.h"
#import "UITextView+Placeholder.h"
#import "CBFormController.h"

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
    
    //Hide the pencilIcon if the cell is not editable
    [formItem setIcon:FAComment];
    [self.pencilIcon setHidden:!formItem.formController.editing];
    
    [self.textView setText:(NSString *)formItem.initialValue];
    
    //[self.textView addTarget:formItem action:@selector(textViewEditingChange) forControlEvents:UIControlEventEditingChanged];
}

-(CGFloat)height {
    return 120.0f;
}

@end
