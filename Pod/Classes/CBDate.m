//
//  CBDate.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBDate.h"
#import "CBFormController.h"
#import "CBDateCell.h"

@implementation CBDate

@synthesize save;
@synthesize validate;
@synthesize dateFormatter = _dateFormatter;


-(CBFormItemType)type {
    return Date;
}

-(void)configureCell:(CBCell *)cell {
    [cell configureForFormItem:self];
}

//Ensures that this FormItem's initialValue can only be set to a date
-(void)setInitialValue:(NSObject *)initialValue {
    if ([initialValue isKindOfClass:[NSDate class]]) {
        _initialValue = initialValue;
    }else{
        NSAssert(NO, @"The initialValue of a CBDate must be a NSDate.");
    }
}

//Ensures that this FormItem's value can only be set to a date
-(void)setValue:(NSObject *)value {
    if ([value isKindOfClass:[NSDate class]]) {
        _value = value;
    }else{
        NSAssert(NO, @"The value of a CBDate must be a NSDate.");
    }
}

-(NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc]init];
        [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    }
    return _dateFormatter;
}

-(NSObject *)value {
    return [self.dateFormatter dateFromString:[[(CBDateCell *)self. cell dateField] text]];
}

-(BOOL)isEdited {
    return [(NSString *)self.initialValue isEqualToString:(NSString *)self.value];
}

//Updating the height of the cell is the only change required for engaging an dismissing CBDate items
-(void)engage {
    [super engage];
    [self.formController updates];
}
-(void)dismiss {
    [super dismiss];
    [self.formController updates];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //Let the formController decide the actual return value of this function as it manages the selection of formitems in response to the return key.
    return [self.formController textFieldShouldReturnForFormItem:self];
    
}

//If the CBDate is engaged then return the CBDateCell's engagedHeight, otherwise just fall back to the default.
-(CGFloat)height {
    if (self.engaged) {
        return [(CBDateCell *)[self cell] engagedHeight];
    }else {
        return [super height];
    }
}

-(IBAction)dateChanged:(id)sender {
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    [[(CBDateCell *)self.cell dateField] setText:[self.dateFormatter stringFromDate:datePicker.date]];
    
    if ([self isEdited]) {
        [self valueChanged];
    }
}



@end
