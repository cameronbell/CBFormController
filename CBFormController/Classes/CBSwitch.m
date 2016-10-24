//
//  CBSwitch.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import "CBSwitch.h"
#import "CBSwitchCell.h"

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

////Ensures that this FormItem's value can only be set to a nsnumber
//-(void)setValue:(NSObject *)value {
//    if ([value isKindOfClass:[NSNumber class]]) {
//        _value = value;
//    }else{
//        NSAssert(NO, @"The value of a CBSwitch must be a NSNUmber.");
//    }
//}

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

-(void)switchChanged {
    if ([self isEdited]) {
        [self valueChanged];
    }
}

@end
