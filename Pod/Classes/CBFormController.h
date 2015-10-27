//
//  CBFormController.h
//  CBFormController
//
//  Created by Cameron Bell on 2015-08-10.
//  Copyright (c) 2015 Cameron Bell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBFormItem.h"
#import "CBText.h"
#import "CBSwitch.h"
#import "CBButton.h"
#import "CBDate.h"
#import "CBComment.h"
#import "CBPopupPicker.h"
#import "CBPicker.h"
#import "CBCellSet.h"
#import "CBCellSet1.h"



//TODO: This should be changed
#define APPLE_BLUE RGB(13., 122., 255.)
//defines for easy colour entry
#define  RGB(R,G,B) [UIColor colorWithRed:(R/255.) green:(G/255.) blue:(B/255.) alpha:1.0] //Inputs must be of form ##. (float)
#define RGBA(R,G,B,A) [UIColor colorWithRed:(R) green:(G) blue:(B) alpha:(A)]
//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define APPLE_BLUE RGB(13., 122., 255.)
#define COLOUR_GREY_BACKGROUND RGB(200.,200.,200.)
#define APPLE_TABLEVIEW_BACKGROUND_DEFAULT RGB(235.,235.,241.)
#define COLOUR_SUCCESS_GREEN RGB(0.,181.,0.)
//#define COLOUR_ALERT_RED RGB(181.,0.,0.)
#define COLOUR_ALERT_RED RGB(219,36.,42.)
#define COLOUR_ALERT_GREY RGB(80.,80.,80.)
#define COLOUR_ALERT_YELLOW RGB(253.,204.,5.)
#define COLOUR_BLUE RGB(30.,103.,189.)
#define COLOUR_BLUE_TINT UIColorFromRGB(0x1b5eac)
#define COLOUR_GREEN RGB(72.,162.,4.)


//Enum for the different editing modes of the CBFormController
typedef NS_ENUM(NSInteger, CBFormEditMode) {
    CBFormEditModeEdit = 1,
    CBFormEditModeFrozen,
    CBFormEditModeSave,
    CBFormEditModeFree
};


@interface CBFormController : UIViewController <UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,retain) IBOutlet UITableView *formTable; //This is the tableview which contains the form cells
@property (nonatomic,retain) CBCellSet *cellSet;
@property (nonatomic,assign) CBFormEditMode editMode;
@property (nonatomic,assign) BOOL editing;

// Buttons
@property (nonatomic,retain) UIButton *rightButton;
@property (nonatomic,retain) UIButton *cancelButton;

@property (nonatomic,retain) NSDate *defaultDate;

@property (nonatomic, copy) void (^saveSucceeded)(CBFormController *formController); //Block that gets called after the save function succeeds

-(NSArray *)getFormConfiguration; //This function is called to collect all the necessary information from the subclass about how to build the form
-(int)rowIndexForFormItem:(CBFormItem *)formItem;
-(BOOL)textFieldShouldReturnForFormItem:(CBFormItem *)formItem;
-(BOOL)isFormEdited;//Returns YES if any of the values of any of the form items have been changed
-(void)formWasEdited;//Called by a formitem's valueChanged method
-(void)updates;
-(BOOL)save;
-(void)cancel;  
-(BOOL)validate;
-(void)showValidationErrorWithMessage:(NSString *)message;
-(CBFormItem *)formItem:(NSString *)name;

@end
