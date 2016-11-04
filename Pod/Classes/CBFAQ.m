//
//  CBFAQ.m
//  Pods
//
//  Created by Cameron Bell on 2016-11-03.
//
//

#import "CBFAQ.h"
#import "CBFAQCell.h"

@implementation CBFAQ


-(CBFormItemType)type {
    return CBFormItemTypeFAQ;
}

-(void)configureCell:(CBCell *)cell {
    [super configureCell:cell];
    [cell configureForFormItem:self];
}

-(void)engage {
    
    [super engage];
    [self.formController updates];
}

-(void)dismiss {
    [super dismiss];
    [self.formController updates];
}

//If the cell is engaged return it's engaged height, otherwise load the default
-(CGFloat)height {
    if (self.engaged) {
        return [(CBFAQCell *)[self cell] openHeight];
    }else {
        return [(CBFAQCell *)[self cell] closedHeight];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSString *height = [webView stringByEvaluatingJavaScriptFromString:@"Math.max( document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight );"];
    
    float contentHeight = [height floatValue];
    
    // Add padding
    //contentHeight += 4;
    
    CBFAQCell *faqCell = (CBFAQCell *)self.cell;
    [faqCell.answerWebviewHeight setConstant:contentHeight];
    [faqCell setOpenHeight:contentHeight + 4 + faqCell.closedHeight];
}

@end
