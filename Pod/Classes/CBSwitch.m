//
//  CBSwitch.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import "CBSwitch.h"

@implementation CBSwitch

- (void)configure {
    [super configure];
    
    //Set the labels for this cell
    [self.titleLabel setText:self.title];
    [self.onLabel setText:self.onString];
    [self.offLabel setText:self.offString];
    
    //Switch cells are not selectable
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //If the form is not editing then the user should not be able to flip the switch
    [self.theSwitch setUserInteractionEnabled:[self.formController editing]];1
    
    //Set initial value
    //This initialValue of a CBSwitch is stored as an NSNumber ( 0 or 1 )
    [self.theSwitch setOn:[(NSNumber *)self.initialValue boolValue]];
    
    //Calls the function switchChanged on the corresponding formItem when the switch is flipped
    [self.theSwitch addTarget:self action:@selector(switchChanged) forControlEvents:UIControlEventValueChanged];
}

//The value of the switch is always an nsnumber
- (NSObject *)value {
    return [NSNumber numberWithBool:self.theSwitch.on];
}

//Ensures that initialValue is never nil so that isEdited functions properly.
- (NSObject *)initialValue {
    return super.initialValue ? super.initialValue : [NSNumber numberWithBool:NO];
}

- (BOOL)isEdited {
    return ![(NSNumber *)self.initialValue isEqualToNumber:(NSNumber *)self.value];
}

- (void)switchChanged {
    if ([self isEdited]) {
        [self valueChanged];
    }
}

//Checks that the given value is a String
- (void) validateValue:(NSObject *)value {
    if (![value isKindOfClass:[NSNumber class]]) {
        NSAssert(NO, @"The value of a CBSwitch must be a NSNumber.");
    }
}

@end
