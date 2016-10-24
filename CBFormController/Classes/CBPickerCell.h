//
//  CBPickerCell.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-13.
//
//

#import <CBFormController/CBFormController.h>

@interface CBPickerCell : CBCell

@property (nonatomic,retain) IBOutlet UITextField *pickerField; //The field that contains the selected item text
@property (nonatomic,retain) IBOutlet UIPickerView *picker; //The picker object itself
@property (nonatomic,assign) CGFloat engagedHeight;

@end
