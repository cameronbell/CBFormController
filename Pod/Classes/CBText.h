//
//  CBTextFormItem.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import "CBFormItem.h"

@interface CBText : CBFormItem <UITextFieldDelegate>

//This field that the user types into
@property (nonatomic,retain) IBOutlet UITextField *textField;
//Controls the width of the textField
@property (nonatomic,retain) IBOutlet NSLayoutConstraint *textFieldWidth;

//Called when the textfield has been edited
- (void)textFieldEditingChange;

@end
