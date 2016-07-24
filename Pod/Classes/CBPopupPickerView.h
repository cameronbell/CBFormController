//
//  DDVCPopupPickerView.h
//  UTTI
//
//  Created by Cameron Bell on 2015-08-05.
//  Copyright (c) 2015 Cameron Bell. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CBPopupPicker;

@protocol CBPopupPickerViewDelegate <NSObject>

-(void)popupPickerForFormItem:(CBFormItem*)formItem didSelectItems:(NSArray *)items;

@end

@interface CBPopupPickerView : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate> {
    __weak id <CBPopupPickerViewDelegate> _delegate;
}

@property (nonatomic,retain) IBOutlet UINavigationBar *titleBar;
@property (nonatomic,retain) IBOutlet UITextField *searchField;
@property (nonatomic,retain) IBOutlet UITableView *searchTable;
@property (nonatomic,assign) BOOL allowsMultipleSelections;
@property (nonatomic,assign) BOOL allowsCustomItems;
@property (nonatomic,retain) IBOutlet NSLayoutConstraint *topOfTable;

@property (nonatomic,weak) id <CBPopupPickerViewDelegate> delegate;

-(id)initForFormItem:(CBPopupPicker *)formItem withDelegate:(id <CBPopupPickerViewDelegate>)delegate allowsMultipleSelection:(BOOL)multipleSelections allowsCustomItems:(BOOL)customItems selections:(NSArray *)selections;
@end
