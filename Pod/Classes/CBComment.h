//
//  CBComment.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBFormItem.h"

@interface CBComment : CBFormItem <UITextViewDelegate>

@property (nonatomic,retain) IBOutlet UITextView *textView;
//@property (nonatomic,retain) IBOutlet UIView *gradientView;
@property (nonatomic,retain) IBOutlet UIImageView *pencilIcon;
@property (nonatomic,retain) IBOutlet UILabel *donelabel;

@property (nonatomic, copy) void (^save)(NSString *value); //Called to ask the subclass to save the value to the data source
@property (nonatomic, copy) BOOL (^validation)(NSString *value); //Called to verify that the new value is acceptable to be saved to the data source.
@end
