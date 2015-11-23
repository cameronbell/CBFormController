//  Base class for all form items
//  @author Cameron Bell
//  @authot Julien Guerinet

#import <Foundation/Foundation.h>
#import <FontAwesome/NSString+FontAwesome.h>

@class CBFormController;

@interface CBFormItem : UITableViewCell

//The label used for the form item title
@property (nonatomic,retain) IBOutlet UILabel *titleLabel;
//The label used for the form item icon
@property (nonatomic,retain) IBOutlet UILabel *iconLabel;
//The FormController instance that this form item belongs to
@property (nonatomic, weak) CBFormController *formController;
//The cell name and identifier
@property (nonatomic, retain) NSString *name;
//True if the current item is selected by the user, false otherwise
@property (nonatomic, assign, getter = isEngaged) BOOL engaged;
//True if the current item is hidden, false otherwise
@property (nonatomic, assign, getter = isHidden) BOOL hidden;
//The total number of title lines
@property (nonatomic, assign) int numberOfTitleLines;
//The initial value
@property (nonatomic, retain) NSObject *initialValue;
//The current value
@property (nonatomic, retain) NSObject *value;
//The form item title
@property (nonatomic, retain) NSString *title;
//The form item placeholder
@property (nonatomic, retain) NSString *placeholder;
//The form item icon
@property (nonatomic, assign) FAIcon icon;
//The form item icon color
@property (nonatomic, retain) UIColor *iconColor;
//Called when the value of the form item changes
@property (nonatomic, copy) void (^change)(NSObject *initialValue, NSObject *newValue);
//Called when the value of the form item should be saves
@property (nonatomic, copy) void (^save)(NSObject *value);
//Called when the value of the form item should be validated before being saved
@property (nonatomic, copy) BOOL (^validation)(NSObject *value);
//Called when the form item is selected
@property (nonatomic, copy) void (^select)(); 
//The keyboard type to use if a keyboard should be shown
@property (nonatomic, assign) UIKeyboardType keyboardType;
//True if the user can interact with the form item, false otherwise
@property (nonatomic, assign) BOOL userInteractionEnabled;
//The view's default height
@property (nonatomic,assign) CGFloat defaultHeight;
//The view's default height for 2 lines 
@property (nonatomic,assign) CGFloat defaultTwoLineHeight;
//TODO
@property (nonatomic, assign) BOOL enabledWhenNotEditing; 

//Initializes the form item with the given name/identifier
- (id)initWithName:(NSString *)name;

//Configures the view once created
- (void)configure;

//@return True if it is equal to the given form item, false otherwise
- (BOOL)equals:(CBFormItem *)formItem;

//@return true if the form item has been edited, false otherwise
- (BOOL)isEdited;

//Called when the value has been changed
- (void)valueChanged;

//Calls the save lambda
- (void)saveValue;

//Calls the validate lamba
- (BOOL)validate;

//Checks that the value is acceptable for the type of form item and crashes the app if it isn't
- (void)validateValue:(NSObject *)value;

//@return the height to use for this form item 
- (CGFloat)height;

//Sets an icon in the given color
- (void)setIcon:(FAIcon)icon withColor:(UIColor *)color;

@end
