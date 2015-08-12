//
//  CBDateCell.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBCell.h"

@interface CBDateCell : CBCell

@property (nonatomic,retain) IBOutlet UITextField *dateField;
@property (nonatomic,retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic,assign) CGFloat engagedHeight;

@end
