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

//The field showing the currently selected item
@property (nonatomic, retain) IBOutlet UITextField *textField;
//True if the user can input their own item, false otherwise
@property (nonatomic, assign) BOOL allowsCustomItems;
//The array of items to show in the picker
@property (nonatomic, retain) NSMutableArray *items;
//Code called when a new item is selected from the picker 
@property (nonatomic, copy) void (^didSelectItem)(NSString *value);

@end
