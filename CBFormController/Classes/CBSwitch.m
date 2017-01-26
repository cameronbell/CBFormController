//
//  CBSwitch.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import "CBSwitch.h"
#import "CBSwitchCell.h"
#import "CBFormController.h"

@implementation CBSwitch
@synthesize onString = _onString;
@synthesize offString = _offString;
@synthesize save;
@synthesize validation;

-(CBFormItemType)type {
    return CBFormItemTypeSwitch;
}

-(void)configureCell:(CBCell *)cell {
    
    [super configureCell:cell];
    
    [cell configureForFormItem:self];
    
    
}

//Ensures that this FormItem's initialValue can only be set to a nsnumber.
-(void)setInitialValue:(NSObject *)initialValue {
    if (!initialValue || [initialValue isKindOfClass:[NSNumber class]]) {
        _initialValue = initialValue;
    }else{
        NSAssert(NO, @"The initialValue of a CBSwitch must be a NSNumber.");
    }
}

- (void)setValue:(NSObject *)value {

    BOOL newState = [(NSNumber *)value boolValue];
    [[(CBSwitchCell *)self.cell theSwitch] setOn:newState];
}

- (void)setValueWithoutChangeEvent:(NSObject *)value {
    
    [[(CBSwitchCell *)self.cell theSwitch] removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    BOOL newState = [(NSNumber *)value boolValue];
    [[(CBSwitchCell *)self.cell theSwitch] setOn:newState animated:NO];
    
    // This is necessary because there is a async delay between when setOn is called, and when its
    //value changes and consequently when the valueChanged message gets sent. Adding the
    // eventHandler back to the object after a momentary delay solves this problem
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(resetTarget)
                                   userInfo:nil repeats:NO];
     
    
}

- (void)resetTarget {
    [[(CBSwitchCell *)self.cell theSwitch] addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
}

//The value of the switch is always an nsnumber
-(NSObject *)value {
    return [NSNumber numberWithBool:[(CBSwitchCell *)self.cell theSwitch].on];
}

//Ensures that initialValue is never nil so that isEdited functions properly.
-(NSObject *)initialValue {
    return _initialValue ? _initialValue : [NSNumber numberWithBool:NO];
}
-(BOOL)isEdited {
    return ![(NSNumber *)self.initialValue isEqualToNumber:(NSNumber *)self.value];
}

-(IBAction)switchChanged:(id)sender {
    
    // If the form is in editing mode then only call valueChanged when it is edited
    // compared to the initialValue
    // Otherwise call it whenever the switch changes state
    if (self.formController.editMode == CBFormEditModeEdit && [self isEdited]) {
        [self valueChanged];
    }else {
        [self valueChanged];
    }
}

@end
