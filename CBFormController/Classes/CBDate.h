//
//  CBDate.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBFormItem.h"
#import "CBDateCell.h"

@interface CBDate : CBFormItem

@property (nonatomic,retain) NSDateFormatter *dateFormatter;
@property (nonatomic,assign) BOOL showClearButton;
-(IBAction)dateChanged:(id)sender;
@property (nonatomic, copy) void (^save)(NSDate *value); //Called to ask the subclass to save the value to the data source
@property (nonatomic, copy) BOOL (^validation)(NSDate *value); //Called to verify that the new value is acceptable to be saved to the data source.

@end
