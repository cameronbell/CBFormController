//
//  CBSwitchCell.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import "CBFormItem.h"

@interface CBSwitchCell : CBCell

@property (nonatomic,retain) IBOutlet UILabel *titleLabel;
@property (nonatomic,retain) IBOutlet UISwitch *theSwitch;
@property (nonatomic,retain) IBOutlet UILabel *yesLabel;
@property (nonatomic,retain) IBOutlet UILabel *noLabel;

@end
