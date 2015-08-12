//
//  CBButton.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBFormItem.h"

//All CBFormItems have a type which corresponds with an enum value
typedef NS_ENUM(NSInteger, CBButtonType) {
    CBButtonTypeNone,
    CBButtonTypeDelete,
    CBButtonTypeAdd,
    CBButtonTypeSave,
    CBButtonTypeContinue
};


@interface CBButton : CBFormItem

@property (nonatomic,assign) CBButtonType buttonType;
@property (nonatomic,assign) NSTextAlignment titleAlign; //Controls the alignment of the title in the button cell
@property (nonatomic,retain) UIColor *titleColor;

@end
