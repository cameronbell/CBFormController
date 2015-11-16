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
@synthesize save;
@synthesize validation;


-(CBFormItemType)type {
    return CBFormItemTypeText;
}

-(void)configure {
    [super configure];
    [self.textField setUserInteractionEnabled:NO];
    [self.textField setDelegate:self];
    [self.textField setText:(NSString *)self.initialValue];
    [self.textField setTag:[self.formController rowIndexForFormItem:formItem]];
    [self.textField addTarget:self action:@selector(textFieldEditingChange)
             forControlEvents:UIControlEventEditingChanged];
    [self.textField setKeyboardType:self.keyboardType];
}

//Ensures that this FormItem's initialValue can only be set to a string
-(void)setInitialValue:(NSObject *)initialValue {
    
    if (!initialValue || [initialValue isKindOfClass:[NSString class]]) {
        _initialValue = initialValue;
    }else{
        NSAssert(NO, @"The initialValue of a CBText must be a NSString.");
    }
}

//Ensures that this FormItem's value can only be set to a string
-(void)setValue:(NSObject *)value {
    if ([value isKindOfClass:[NSString class]]) {
        _value = value;
    }else{
        NSAssert(NO, @"The value of a CBText must be a NSString.");
    }
}

-(NSObject *)value {
    return [(CBTextCell *)self.cell textField].text;
}

//Ensuring that this never returns nil so that isEdited works properly.
-(NSObject *)initialValue {
    return [(NSString *)_initialValue length] ? _initialValue : @"";
}

-(BOOL)isEdited {
    return ![(NSString *)self.initialValue isEqualToString:(NSString *)self.value];
}

-(void)engage {
    [super engage];
    
    CBTextCell *textCell = (CBTextCell *)self.cell;
    
    [textCell.textField setUserInteractionEnabled:YES];
    [textCell.textField becomeFirstResponder];
    
}

-(void)dismiss {
    [super dismiss];
    
    CBTextCell *textCell = (CBTextCell *)self.cell;
    [textCell.textField resignFirstResponder];
    [textCell.textField setUserInteractionEnabled:NO];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //Let the formController decide the actual return value of this function as it manages the selection of formitems in response to the return key.
    return [self.formController textFieldShouldReturnForFormItem:self];

}

-(void)textFieldEditingChange {
    if ([self isEdited]) {
        [self valueChanged];
    }
}

@end
