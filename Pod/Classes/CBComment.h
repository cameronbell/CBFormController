//
//  CBComment.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBFormItem.h"

@interface CBComment : CBFormItem <UITextViewDelegate>

//The input view for the user's comments
@property (nonatomic,retain) IBOutlet UITextView *textView;

@end
