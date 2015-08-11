//
//  CBFormController.h
//  CBFormController
//
//  Created by Cameron Bell on 2015-08-10.
//  Copyright (c) 2015 Cameron Bell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBFormItem.h"
#import "CBCellSet.h"
#import "CBText.h"
#import "CBSwitch.h"

//Enum for the different editing modes of the CBFormController
typedef NS_ENUM(NSInteger, CBFormEditMode) {
    FROZEN,
    EDIT,
    SAVE,
    FREE
};


@interface CBFormController : UIViewController <UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,retain) UITableView *formTable; //This is the tableview which contains the form cells
@property (nonatomic,retain) CBCellSet *cellSet;
@property (nonatomic,assign) CBFormEditMode editMode;
@property (nonatomic,assign) BOOL editing;

// Buttons
@property (nonatomic,retain) UIButton *rightButton;
@property (nonatomic,retain) UIButton *cancelButton;

-(NSArray *)getFormConfiguration; //This function is called to collect all the necessary information from the subclass about how to build the form
-(int)rowIndexForFormItem:(CBFormItem *)formItem;
-(BOOL)textFieldShouldReturnForFormItem:(CBFormItem *)formItem;
-(BOOL)isFormEdited;//Returns YES if any of the values of any of the form items have been changed
-(void)formWasEdited;//Called by a formitem's valueChanged method

@end
