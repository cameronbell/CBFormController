//
//  CBCellSet1Date.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBCellSet2Date.h"
#import "CBDate.h"

@implementation CBCellSet2Date

-(void)configureForFormItem:(CBDate *)formItem {
    
    [super configureForFormItem:formItem];

    //Sets the placeholder of the dateField to the title which is the theme of this cell set
    [self.dateField setPlaceholder:formItem.placeholder];
    [self.titleLabel setText:formItem.title];
    [self.dateField setTextAlignment:NSTextAlignmentRight];
    
}

-(CGFloat)engagedHeight {
    return 210.0f;
}

-(CGFloat)clearButtonHeight {
    return 42.0f;
}

@end
