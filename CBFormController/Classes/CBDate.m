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
@synthesize showClearButton = _showClearButton;
-(CBFormItemType)type {
    return CBFormItemTypeDate;
}

-(void)configureCell:(CBCell *)cell {
    [cell configureForFormItem:self];
    [super configureCell:cell];
}

//Ensures that this FormItem's initialValue can only be set to a date
-(void)setInitialValue:(NSObject *)initialValue {
    if (!initialValue || [initialValue isKindOfClass:[NSDate class]]) {
        _initialValue = initialValue;
    }else{
        NSAssert(NO, @"The initialValue of a CBDate must be a NSDate.");
    }
}

//Ensures that this FormItem's value can only be set to a date
-(void)setValue:(NSObject *)value {
    
    // If the value is a nsdate or is nil
    if ([value isKindOfClass:[NSDate class]] || !value) {
        _value = value;
        
        CBDateCell *dateCell = (CBDateCell *)self.cell;
        
        NSString *dateString = [self.dateFormatter stringFromDate:_value];
        UITextField *dateField = [dateCell dateField];
        [dateField setText:dateString];
        
        // If value is not nil then set the date of the picker
        if (_value) {
            [dateCell.datePicker setDate:_value];
            [dateCell.clearButton setEnabled:YES];
        }else{
            [dateCell.clearButton setEnabled:NO];
        }
        
        // Always call valueChanged unless 
        if (self.formController.editMode == CBFormEditModeEdit) {
            if([self isEdited]) [self valueChanged];
        } else {
            [self valueChanged];
        }
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
    return _value ? _value : _initialValue;
}

-(NSObject *)initialValue {
    return _initialValue ? _initialValue : self.formController.defaultDate;
}

-(BOOL)isEdited {
    
    //If both value and initialValue are nil then the formItem has not been edited
    if (![self value] && ![self initialValue]) return NO;
    
    //If one is nil and the other is not then one of them has changed
    if ((!self.initialValue)^(!self.value)) return YES;
    
    return ![CBDate date:(NSDate *)self.initialValue isSameDayAsDate:(NSDate *)self.value];
}

+ (BOOL)date:(NSDate *)date1 isSameDayAsDate:(NSDate *)date2 {
    // Both dates must be defined, or they're not the same
    //assertnotnil(date1);
    //assertnotnil(date2);
    
    if (date1 == nil || date2 == nil) {
        return NO;
    }
    
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *day = [calendar components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date1];
    NSDateComponents *day2 = [calendar components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date2];
    return ([day2 day] == [day day] &&
            [day2 month] == [day month] &&
            [day2 year] == [day year] &&
            [day2 era] == [day era]);
}


//Updating the height of the cell is the only change required for engaging an dismissing CBDate items
-(void)engage {
    [super engage];
    
    // If no value nor initialValue is provided then load the current date
    if (!_value && !_initialValue) {
        [self setValue:[NSDate date]];
    }
    
    [self selected];
    
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
    if (self.engaged && self.showClearButton) {
        return [(CBDateCell *)[self cell] engagedHeight]
            + [(CBDateCell *)[self cell] clearButtonHeight];
    } else if (self.engaged) {
        return [(CBDateCell *)[self cell] engagedHeight];
    } else {
        return [super height];
    }
}

-(IBAction)dateChanged:(id)sender {
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    [self setValue:datePicker.date];
}

-(IBAction)clear:(id)sender {
    [self setValue:nil];
}

@end
