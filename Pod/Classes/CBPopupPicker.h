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

@property (nonatomic,retain) NSString *placeholder;
@property (nonatomic,assign) BOOL allowsCustomItems;
@property (nonatomic,retain) NSMutableArray *items;

@end
