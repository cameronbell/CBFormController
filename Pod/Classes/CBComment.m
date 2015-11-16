//
//  CBComment.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBComment.h"
#import "CBCommentCell.h"
#import "CBFormController.h"

@implementation CBComment
@synthesize save;
@synthesize validation;


-(CBFormItemType)type {
    return CBFormItemTypeComment;
}

-(void)configure {
    [super configure];
    
    [self.textView setUserInteractionEnabled:NO];
    [self.textView setDelegate:self];
    [self.donelabel setHidden:YES];
    
    //Uses a cocoapod that provides a category on UITextField that adds a placeholder property
    [self.textView setPlaceHolder:self.placeholder];
    
    //Hide the pencilIcon if the cell is not editable
    [formItem setIcon:FAComment];
    [self.pencilIcon setHidden:!formItem.formController.editing];
    
    [self.textView setText:(NSString *)formItem.initialValue];
    
    //[self.textView addTarget:formItem action:@selector(textViewEditingChange) forControlEvents:UIControlEventEditingChanged];
}

//Ensures that this FormItem's initialValue can only be set to a string
-(void)setInitialValue:(NSObject *)initialValue {
    
    if (!initialValue || [initialValue isKindOfClass:[NSString class]]) {
        _initialValue = initialValue;
    }else{
        NSAssert(NO, @"The initialValue of a CBComment must be a NSString.");
    }
}

//Ensures that this FormItem's value can only be set to a string
-(void)setValue:(NSObject *)value {
    if ([value isKindOfClass:[NSString class]]) {
        _value = value;
    }else{
        NSAssert(NO, @"The value of a CBComment must be a NSString.");
    }
}

-(NSObject *)value {
    return [(CBCommentCell *)self.cell textView].text;
}

//Ensures that initialValue is never nil
-(NSObject *)initialValue {
    return [(NSString *)_initialValue length] ? _initialValue : @"";
}

-(BOOL)isEdited {
    return ![(NSString *)self.initialValue isEqualToString:(NSString *)self.value];
}

-(void)engage {
    [super engage];
    
    CBCommentCell *commentCell = (CBCommentCell *)self.cell;
    
    [self.formController updates];
    [commentCell.textView setUserInteractionEnabled:YES];
    [commentCell.textView becomeFirstResponder];
    [commentCell.pencilIcon setHidden:YES];
    [commentCell.donelabel setHidden:NO];

    
}

-(void)dismiss {
    [super dismiss];
    
    CBCommentCell *commentCell = (CBCommentCell *)self.cell;

    [commentCell.textView setUserInteractionEnabled:NO];
    [commentCell.textView resignFirstResponder];
    [commentCell.textView setContentOffset:CGPointMake(0, 0)];
    [commentCell.pencilIcon setHidden:NO];
    [commentCell.donelabel setHidden:YES];
    [self.formController updates];
}


-(void)textViewDidChange:(UITextView *)textView {
    if ([self isEdited]) {
        [self valueChanged];
    }
}

-(CGFloat)height {
    return 120.0f;
}

@end
