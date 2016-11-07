//
//  CBAutoCompleteCell.h
//  Pods
//
//  Created by Cameron Bell on 2016-08-03.
//
//

#import <CBFormController/CBFormController.h>
#import <MLPAutoCompleteTextField/MLPAutoCompleteTextField.h>

@interface CBAutoCompleteCell : CBCell

@property (nonatomic,retain) IBOutlet MLPAutoCompleteTextField *textField;

@end
