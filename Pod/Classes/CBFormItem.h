//
//  CBFormItem.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import <Foundation/Foundation.h>
#import "CBCell.h"

@class CBFormController;

//All CBFormItems have a type which corresponds with an enum value
typedef NS_ENUM(NSInteger, CBFormItemType) {
    Switch,
    Date,
    Button,
    FAQ,
    Text,
    Picker,
    Comment,
    View,
    AutoComplete,
    Caption,
    SegmentedControl,
    PopupPicker
};

@interface CBFormItem : NSObject {
    NSObject *_initialValue;
    NSObject *_value;
}

@property (nonatomic,retain) CBCell *cell; //A reference to the cell which currently represents this form item
@property (nonatomic,retain) NSString *name; //The name and identifier for the cell
@property (nonatomic,assign,getter = isEngaged) BOOL engaged;
@property (nonatomic,assign,getter = isHidden) BOOL hidden;
@property (nonatomic,assign) CGFloat height; // Returns the height the formitem's cell should be. This may be dependent on other properties of the formitem
@property (nonatomic,assign) int numberOfTitleLines;
@property (nonatomic,assign) Class cellClass; //This property allows the cellClass to be overridden. Normally this will take the value of the formController's cellSetClass property
@property (nonatomic,weak) CBFormController *formController;
@property (nonatomic,retain) NSObject *initialValue;
@property (nonatomic,retain) NSObject *value;
@property (nonatomic,assign,readonly) CBFormItemType type;
@property (nonatomic,retain) NSString *title; //The title that should be displayed on the formItem. Not all cells will display this title and it is not required.
@property (nonatomic,assign) BOOL enabledWhenNotEditing;
@property (nonatomic, copy) void (^change)(NSObject *initialValue, NSObject *newValue);
@property (nonatomic, copy) void (^save)(NSObject *value);
@property (nonatomic, copy) BOOL (^validate)(NSObject *value);


-(id)initWithName:(NSString *)name;
-(void)configureCell:(CBCell*)cell; //This function is called when the formitem creates the cell and the cell needs to be configured
-(void)dismiss;
-(void)engage;
-(BOOL)equals:(CBFormItem *)formItem;
-(BOOL)isEdited;
-(void)valueChanged;
-(BOOL)attemptSave;

@end
