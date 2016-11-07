//
//  CBFAQCell.h
//  Pods
//
//  Created by Cameron Bell on 2016-11-03.
//
//

#import <CBFormController/CBFormController.h>

@interface CBFAQCell : CBCell 

@property (nonatomic,retain) IBOutlet UILabel *questionLabel;
@property (nonatomic,retain) IBOutlet UIWebView *answerWebview;
@property (nonatomic,assign) CGFloat openHeight;
@property (nonatomic,assign) CGFloat closedHeight;
@property (nonatomic,retain) IBOutlet NSLayoutConstraint *answerWebviewHeight;
@property (nonatomic,retain) IBOutlet NSLayoutConstraint *questionViewHeight;
@end
