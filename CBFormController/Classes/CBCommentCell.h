//
//  CBCommentCell.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBCell.h"
#import "CBComment.h"

@interface CBCommentCell : CBCell

@property (nonatomic,retain) IBOutlet UITextView *textView;
//@property (nonatomic,retain) IBOutlet UIView *gradientView;
@property (nonatomic,retain) IBOutlet UIImageView *pencilIcon;
@property (nonatomic,retain) IBOutlet UILabel *donelabel;

@end
