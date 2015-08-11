//
//  CBTextCell.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import <UIKit/UIKit.h>
#import "CBCell.h"

@interface CBTextCell : CBCell


@property (nonatomic,retain) IBOutlet UITextField *textField; //This is the field that the user types into
@property (nonatomic,retain) IBOutlet NSLayoutConstraint *textFieldWidth; //This controls the width of the textField

@end
