//
//  CBPopupPicker.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBFormItem.h"
#import "CBPopupPickerView.h"

@interface CBPopupPicker : CBFormItem <CBPopupPickerViewDelegate>


@property (nonatomic,assign) BOOL allowsCustomItems;
@property (nonatomic,assign) BOOL allowsMultipleSelection;
@property (nonatomic,retain) NSMutableArray *items;
@property (nonatomic, copy) void (^save)(NSArray *items); //Called to ask the subclass to save the value to the data source
@property (nonatomic, copy) BOOL (^validation)(NSArray *items); //Called to verify that the new value is acceptable to be saved to the data source.

@property (nonatomic, copy) void (^didSelectItems)(NSArray *items);

@end
