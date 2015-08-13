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

@property (nonatomic,retain) NSString *placeholder;
@property (nonatomic, copy) void (^save)(NSString *value);
@property (nonatomic, copy) BOOL (^validation)(NSString *value);

-(void)textFieldEditingChange;
@end
