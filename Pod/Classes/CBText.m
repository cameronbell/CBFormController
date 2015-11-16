//
//  CBTextFormItem.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import "CBText.h"
#import "CBFormController.h"

@implementation CBText

- (void)configure {
    [super configure];
    [self.textField setUserInteractionEnabled:NO];
    [self.textField setDelegate:self];
    [self.textField setText:(NSString *)self.initialValue];
    [self.textField setTag:[self.formController rowIndexForFormItem:self]];
    [self.textField addTarget:self action:@selector(textFieldEditingChange)
             forControlEvents:UIControlEventEditingChanged];
    [self.textField setKeyboardType:self.keyboardType];
}

- (NSObject *)value {
    return self.textField.text;
}

//Ensuring that this never returns nil so that isEdited works properly.
- (NSObject *)initialValue {
    return [(NSString *)super.initialValue length] ? super.initialValue : @"";
}

- (BOOL)isEdited {
    return ![(NSString *)self.initialValue isEqualToString:(NSString *)self.value];
}

- (void)engage {
    [super engage];
    
    [self.textField setUserInteractionEnabled:YES];
    [self.textField becomeFirstResponder];
}

- (void)dismiss {
    [super dismiss];
    [self.textField resignFirstResponder];
    [self.textField setUserInteractionEnabled:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //Let the formController decide the actual return value of this function
    //  as it manages the selection of formitems in response to the return key.
    return [self.formController textFieldShouldReturnForFormItem:self];
}

- (void)textFieldEditingChange {
    if ([self isEdited]) {
        [self valueChanged];
    }
}

//Checks that the given value is a String
- (void) validateValue:(NSObject *)value {
    if (![value isKindOfClass:[NSString class]]) {
        NSAssert(NO, @"The value of a CBText must be a NSString.");
    }
}

@end
