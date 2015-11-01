//  The main UI ViewController that generates the forms.
//  @author Cameron Bell
//  @author Julien Guerinet
//  Copyright (c) 2015 Cameron Bell. All rights reserved.

#import <UIKit/UIKit.h>
#import "CBFormItem.h"
#import <FontAwesome/FAImageView.h>
#import <FontAwesome/NSString+FontAwesome.h>
#import <FontAwesome/UIFont+FontAwesome.h>

//Quickly creates a UIColor from RGB
#define RGB(R,G,B) [UIColor colorWithRed:(R/255.) green:(G/255.) blue:(B/255.) alpha:1.0]
//Apple Blue
//TODO: This should be changed
#define COLOR_APPLE_BLUE RGB(13., 122., 255.)
//Blue
#define COLOR_BLUE RGB(30., 103., 189.)
//Grey
#define COLOR_GREY RGB(80., 80., 80.)
//Red
#define COLOR_RED RGB(219., 36., 42.)

//Enum for the different modes of the CBFormController
typedef NS_ENUM(NSInteger, CBFormMode) {
    CBFormModeEdit = 1,
    CBFormModeFrozen,
    CBFormModeSave,
    CBFormModeFree
};

@interface CBFormController : UIViewController <UITableViewDelegate, UITableViewDataSource>

//Tableview which contains the cells
@property (nonatomic, retain) IBOutlet UITableView *formTable;
//The current mode that the CBFormController is in
@property (nonatomic, assign) CBFormMode mode;
//True if the form is currently being edited, false otherwise
@property (nonatomic, assign) BOOL editing;
//The right button on the navigation bar
@property (nonatomic, retain) UIButton *rightButton;
//TODO The left button on the navigation bar
@property (nonatomic, retain) UIButton *cancelButton;
//TODO
@property (nonatomic,retain) NSDate *defaultDate;
//Block that gets called after the save function succeeds
@property (nonatomic, copy) void (^saveSucceeded)(CBFormController *formController);

//Method to override where the user adds the form items. Must call super
- (void)loadForm;

//Starts a new section. Also used to start the form 
- (void)startSection;

//Adds a new form item
- (void)addFormItem:(CBFormItem *)item; 

//Ends the form
- (void)endForm;

//TODO What is this ?
- (BOOL)textFieldShouldReturnForFormItem:(CBFormItem *)formItem;

//Returns YES if any of the values of any of the form items have been changed
- (BOOL)isFormEdited;

//TODO
//Called by a formitem's valueChanged method
- (void)formWasEdited;
- (void)updates;
- (BOOL)save;
- (void)cancel;
- (BOOL)validate;
- (void)showValidationErrorWithMessage:(NSString *)message;

//Returns the form item for the given name
- (CBFormItem *)formItem:(NSString *)name;

//Returns the form item for the given index path
- (CBFormItem *)formItemForIndexPath:(NSIndexPath *)indexPath;

//Returns the row index for the given form item
- (int)rowIndexForFormItem:(CBFormItem *)formItem;

@end
