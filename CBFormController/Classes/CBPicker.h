//
//  CBPicker.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-13.
//
//

#import "CBFormItem.h"

@interface CBPicker : CBFormItem <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,retain) NSArray *items;

// Called to ask the subclass to save the value to the data source
@property (nonatomic, copy) void (^save)(NSString *value);

// Called to verify that the new value is acceptable to be saved to the data source.
@property (nonatomic, copy) BOOL (^validation)(NSString *value);

// The name of the NSString field that should be used to get the string for the picker
// Defaults to pickerString
// An array of strings can be used in which case this property is ignored
@property (nonatomic,retain) NSString *pickerSelectorString;

- (NSString *)getPickerStringForItem:(NSObject *)obj;

// If this block is defined, the string values for the picker are returned from the block
@property (nonatomic, copy) NSString* (^getPickerStringForItem)(NSObject *item);

- (void)clear;
@end
