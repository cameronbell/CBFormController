//
//  CBPicker.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-13.
//
//

#import "CBFormItem.h"

@interface CBPicker : CBFormItem <UIPickerViewDataSource, UIPickerViewDelegate>

//The field that contains the selected item text
@property (nonatomic, retain) IBOutlet UITextField *pickerField;
//The picker object itself
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
//The height of the view when the view is engaged
@property (nonatomic, assign) CGFloat engagedHeight;
//The items to show in the picker
@property (nonatomic, retain) NSArray *items;

@end
