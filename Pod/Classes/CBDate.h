//
//  CBDate.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBFormItem.h"

@interface CBDate : CBFormItem

//Displays the currently selected date
@property (nonatomic,retain) IBOutlet UITextField *dateField;
//The picker used to select the date
@property (nonatomic,retain) IBOutlet UIDatePicker *datePicker;
//The height of the view when engaged
@property (nonatomic,assign) CGFloat engagedHeight;
//The formatter used for the displayed date text
@property (nonatomic,retain) NSDateFormatter *dateFormatter;
//Called when the date has been changed
-(IBAction)dateChanged:(id)sender;
@end
