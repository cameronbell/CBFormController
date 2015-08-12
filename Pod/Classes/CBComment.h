//
//  CBComment.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBFormItem.h"

@interface CBComment : CBFormItem <UITextViewDelegate>
@property (nonatomic,retain) NSString *placeholder;
-(void)textViewEditingChange;
@end
