//
//  CBFAQCell.m
//  Pods
//
//  Created by Cameron Bell on 2016-11-03.
//
//

#import "CBFAQCell.h"

@implementation CBFAQCell

-(void)configureForFormItem:(CBFAQ *)formItem {
    
    [super configureForFormItem:formItem];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    /* Configure Question */
    
    // TODO: This value should be obtained from the view, not from the screen size
    CGFloat tableWidth = [[UIScreen mainScreen] bounds].size.width;
    
    // TODO: 28 refers to the 2*14px constraints on the questionLabel; shouldn't be hardcoded
    CGSize questionSize = [formItem.question sizeWithFont:self.questionLabel.font
                                        constrainedToSize:CGSizeMake(tableWidth-28, 9999)
                                            lineBreakMode:NSLineBreakByWordWrapping];
    
    self.closedHeight = ceil(questionSize.height + 24);// < 30 ? 45 : 66;
    [self.questionViewHeight setConstant:self.closedHeight];

    [self.questionLabel setUserInteractionEnabled:NO];
    [self.questionLabel setText:formItem.question];
    [self.questionLabel setNumberOfLines:0];
    
    /* Configure Answer Webview */
    
    NSString *helvetica = @"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"></head><body style=\"font-family:HelveticaNeue-Light;font-size:17px;\">";
    NSString *fontedString = [[helvetica stringByAppendingString:formItem.answer] stringByAppendingString:@"</body></html>"];

    [self.answerWebview setDelegate:formItem];
    
    [self.answerWebview loadHTMLString:fontedString baseURL:nil];
    [self.answerWebview.scrollView setScrollEnabled:NO];
    [self.answerWebview setUserInteractionEnabled:NO];
    [self.answerWebview setBackgroundColor:[UIColor whiteColor]];
    [self.answerWebview setScalesPageToFit:YES];
    [self.answerWebview setContentMode:UIViewContentModeScaleAspectFit];
    
    // Set this to the same so that it can't be opened until the webview come back with the proper
    // openHeight
    self.openHeight = self.closedHeight;
}




@end
