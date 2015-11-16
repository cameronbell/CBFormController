//
//  CBButton.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBFormItem.h"

@interface CBButton : CBFormItem

//Title alignment
@property (nonatomic, assign) NSTextAlignment titleAlignment;
//Title color
@property (nonatomic, retain) UIColor *titleColor;

@end
