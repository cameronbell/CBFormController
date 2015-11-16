//
//  CBTextFormItem.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import "CBFormItem.h"
#import "CBTextCell.h"

@interface CBText : CBFormItem <UITextFieldDelegate>

@property (nonatomic,retain) IBOutlet UITextField *textField; //This is the field that the user types into
@property (nonatomic,retain) IBOutlet NSLayoutConstraint *textFieldWidth; //This controls the width of the textField
@property (nonatomic, copy) void (^save)(NSString *value);
@property (nonatomic, copy) BOOL (^validation)(NSString *value);

-(void)textFieldEditingChange;
@end
