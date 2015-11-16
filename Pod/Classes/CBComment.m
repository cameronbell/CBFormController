//
//  CBComment.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBComment.h"
#import "CBFormController.h"
#import <UITextView+Placeholder/UITextView+Placeholder.h>

@implementation CBComment

- (void)configure {
    [super configure];
    
    [self.textView setUserInteractionEnabled:NO];
    [self.textView setDelegate:self];
    [self.textView setPlaceholder:self.placeholder];
    [self.textView setText:(NSString *)self.initialValue];
}

//Ensures that this FormItem's initialValue can only be set to a string
- (void)setInitialValue:(NSObject *)initialValue {
    [self validateValue:initialValue];
    self.initialValue = initialValue;
}

//Ensures that this FormItem's value can only be set to a string
- (void)setValue:(NSObject *)value {
    [self validateValue:value];
    self.value = value;
}

- (NSObject *)value {
    return self.textView.text;
}

//Ensures that initialValue is never nil
- (NSObject *)initialValue {
    return [(NSString *)self.initialValue length] ? self.initialValue : @"";
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

//Checks that the given value is a String
- (void) validateValue:(NSObject *)value {
    if (![value isKindOfClass:[NSString class]]) {
        NSAssert(NO, @"The value of a CBComment must be a NSString.");
    }
}

@end
