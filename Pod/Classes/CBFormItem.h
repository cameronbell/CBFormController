//
//  CBFormItem.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import <Foundation/Foundation.h>
#import "CBCell.h"
#import <FontAwesome/NSString+FontAwesome.h>

@class CBFormController;

//All CBFormItems have a type which corresponds with an enum value
typedef NS_ENUM(NSInteger, CBFormItemType) {
    CBFormItemTypeSwitch,
    CBFormItemTypeDate,
    CBFormItemTypeButton,
    CBFormItemTypeFAQ,
    CBFormItemTypeText,
    CBFormItemTypePicker,
    CBFormItemTypeComment,
    CBFormItemTypeView,
    CBFormItemTypeAutoComplete,
    CBFormItemTypeCaption,
    CBFormItemTypeSegmentedControl,
    CBFormItemTypePopupPicker
};


@interface CBFormItem : NSObject {
    @protected
    NSObject *_initialValue;
    NSObject *_value;
    NSString *_title;
}

@property (nonatomic,retain) CBCell *cell; //A reference to the cell which currently represents this form item
@property (nonatomic,retain) NSString *name; //The name and identifier for the cell
@property (nonatomic,assign,getter = isEngaged) BOOL engaged;
@property (nonatomic,assign,getter = isHidden) BOOL hidden;
@property (nonatomic,assign) CGFloat height; // Returns the height the formitem's cell should be. This may be dependent on other properties of the formitem. This is a different property from the height property of the CBCell
@property (nonatomic,assign) int numberOfTitleLines;
@property (nonatomic,assign) Class cellClass; //This property allows the cellClass to be overridden. Normally this will take the value of the formController's cellSetClass property
@property (nonatomic,weak) CBFormController *formController;
@property (nonatomic,retain) NSObject *initialValue;
@property (nonatomic,retain) NSObject *value;
@property (nonatomic,assign,readonly) CBFormItemType type;
@property (nonatomic,retain) NSString *title; //The title that should be displayed on the formItem. Not all cells will display this title and it is not required.
@property (nonatomic,retain) NSString *placeholder; //The prompt shown to enter a value into a field. Not all cells will display.
@property (nonatomic,assign) BOOL enabledWhenNotEditing;
@property (nonatomic, copy) void (^change)(NSObject *initialValue, NSObject *newValue); //Called when the value of the formItem changes if applicable
@property (nonatomic, copy) void (^save)(NSObject *value); //Called to ask the subclass to save the value to the data source
@property (nonatomic, copy) BOOL (^validation)(NSObject *value); //Called to verify that the new value is acceptable to be saved to the data source.
@property (nonatomic, copy) void (^select)(); //Called to verify that the new value is acceptable to be saved to the data source.
@property (nonatomic,retain) NSMutableDictionary *addOns; //A dictionary that categories CBFormItem and CBFormItem cell can use to pass values
@property (nonatomic,assign) UIKeyboardType keyboardType; //Used for formItems that have a keyboard. Determines which keyboard is shown.
@property (nonatomic,assign) BOOL userInteractionEnabled;

-(id)initWithName:(NSString *)name;
-(void)configureCell:(CBCell*)cell; //This function is called when the formitem creates the cell and the cell needs to be configured
-(void)dismiss;
-(void)engage;
-(BOOL)equals:(CBFormItem *)formItem;
-(BOOL)isEdited;
-(void)valueChanged;
-(void)saveValue;
-(BOOL)validate;
-(void)selected; //Currently only called when CBButtons are tapped


-(void)setIcon:(FAIcon)icon;
-(void)setIconColor:(UIColor *)color;

//Sets an icon in the given color
- (void)setIcon:(FAIcon)icon withColor:(UIColor *)color;

@end
