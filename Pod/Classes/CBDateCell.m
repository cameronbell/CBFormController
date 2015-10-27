//
//  CBDateCell.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBDateCell.h"
#import "CBFormController.h"

@implementation CBDateCell
@synthesize dateField,datePicker,engagedHeight;


-(void)configureForFormItem:(CBDate *)formItem {
    
    [super configureForFormItem:formItem];
    
    [self.dateField setUserInteractionEnabled:NO];

    [self.datePicker addTarget:formItem action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];

    //Trying this out
    //[self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //The dateField can be nil if both initialValue and defaultDate are nil
    NSString *string = [formItem.dateFormatter stringFromDate:formItem.initialValue? (NSDate *)formItem.initialValue : formItem.formController.defaultDate];
    [self.dateField setText:string];
    
    //The date picker must set to some value; If initialValue is nil, show defaultDate, but if that is nil then show today's date.
    [self.datePicker setDate:formItem.initialValue ? (NSDate*)formItem.initialValue : (formItem.formController.defaultDate ? formItem.formController.defaultDate : [NSDate date])];

    //This is a temporary fix for the iOS9 Datepicker bug.
    [self.datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];

}

@end
