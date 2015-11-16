//
//  CBDate.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBDate.h"
#import "CBFormController.h"

@implementation CBDate

-(void)configure {
    [super configure];
    
    [self.dateField setUserInteractionEnabled:NO];
    [self.datePicker addTarget:self action:@selector(dateChanged:)
              forControlEvents:UIControlEventValueChanged];
    
    //Trying this out
    //[self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //The dateField can be nil if both initialValue and defaultDate are nil
    NSString *string = [self.dateFormatter stringFromDate:self.initialValue ?
                        (NSDate *)self.initialValue : self.formController.defaultDate];
    [self.dateField setText:string];
    
    //The date picker must set to some value; If initialValue is nil, show defaultDate, but if that is nil then show today's date.
    [self.datePicker setDate:self.initialValue ?
     (NSDate *)self.initialValue :
     (self.formController.defaultDate ? self.formController.defaultDate : [NSDate date])];
    
    //This is a temporary fix for the iOS9 Datepicker bug.
    [self.datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc]init];
        [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    }
    return _dateFormatter;
}

- (NSObject *)value {
    return [self.dateFormatter dateFromString:self.dateField.text];
}

- (NSObject *)initialValue {
    //Defaults to today
    return super.initialValue ? super.initialValue : [NSDate date];
}

-(BOOL)isEdited {
    return ![CBDate date:(NSDate *)self.initialValue isSameDayAsDate:(NSDate *)self.value];
}

//Checks if two dates are equal
+ (BOOL)date:(NSDate *)date1 isSameDayAsDate:(NSDate *)date2 {
    if (date1 == nil || date2 == nil) {
        //If they're both nil, consider them equal
        return date1 == nil && date2 == nil;
    }
    
    NSCalendar *calendar =
        [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *day = [calendar components: NSCalendarUnitEra | NSCalendarUnitYear |
                             NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date1];
    NSDateComponents *day2 = [calendar components: NSCalendarUnitEra | NSCalendarUnitYear |
                              NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date2];
    
    return ([day2 day] == [day day] && [day2 month] == [day month] && [day2 year] == [day year] &&
            [day2 era] == [day era]);
}

//Updating the height of the cell is the only change required for engaging an dismissing CBDate items
- (void)engage {
    [super engage];
    [self.formController updates];
}

- (void)dismiss {
    [super dismiss];
    [self.formController updates];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
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

-(CGFloat)engagedHeight {
    return 210.0f;
}

- (void)validateValue:(NSObject *)value {
    if (![value isKindOfClass:[NSDate class]]) {
        NSAssert(NO, @"The value of a CBDate must be a NSDate.");
    }
}

@end
