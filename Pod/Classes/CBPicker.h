//
//  CBPicker.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-13.
//
//

#import "CBFormItem.h"

@interface CBPicker : CBFormItem <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,retain) IBOutlet UITextField *pickerField; //The field that contains the selected item text
@property (nonatomic,retain) IBOutlet UIPickerView *picker; //The picker object itself
@property (nonatomic,assign) CGFloat engagedHeight;
@property (nonatomic,retain) NSArray *items;
@property (nonatomic, copy) void (^save)(NSString *value); //Called to ask the subclass to save the value to the data source
@property (nonatomic, copy) BOOL (^validation)(NSString *value); //Called to verify that the new value is acceptable to be saved to the data source.

@end
