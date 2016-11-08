//
//  CBView.m
//  Pods
//
//  Created by Cameron Bell on 2016-11-07.
//
//

#import "CBView.h"
#import "CBFormController.h"


@implementation CBView


-(CBFormItemType)type {
    return CBFormItemTypeView;
}

-(void)configureCell:(CBCell *)cell {
    [super configureCell:cell];
    [cell configureForFormItem:self];
}

- (CGFloat)height {
    return 300;
}

@end
