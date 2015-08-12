//
//  DDVCPopupPickerView.h
//  UTTI
//
//  Created by Cameron Bell on 2015-08-05.
//  Copyright (c) 2015 Sigvaria. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBFormItem;

@protocol CBPopupPickerViewDelegate <NSObject>

-(void)popupPickerForFormItem:(CBFormItem*)formItem didSelectItem:(NSString *)item;

@end

@interface CBPopupPickerView : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate> {
    __weak id <CBPopupPickerViewDelegate> _delegate;
}

@property (nonatomic,retain) IBOutlet UINavigationBar *titleBar;
@property (nonatomic,retain) IBOutlet UITextField *searchField;
@property (nonatomic,retain) IBOutlet UITableView *searchTable;

@property (nonatomic,weak) id <CBPopupPickerViewDelegate> delegate;

-(id)initForFormItem:(CBFormItem *)formItem withDelegate:(id <CBPopupPickerViewDelegate>)delegate;

@end
