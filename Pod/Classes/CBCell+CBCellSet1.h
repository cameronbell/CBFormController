//
//  CBCell+CBCellSet1.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import <CBFormController/CBFormController.h>

@interface CBCell (CBCellSet1)

@property (nonatomic,retain) IBOutlet UILabel *icon;

-(void)setIcon:(UILabel *)icon;
-(UILabel *)icon;

@end
