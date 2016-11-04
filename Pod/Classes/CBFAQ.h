//
//  CBFAQ.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-13.
//
//

#import "CBFormItem.h"

@interface CBFAQ : CBFormItem <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,retain) NSString *question;
@property (nonatomic,retain) NSString *answer;

//Called to ask the subclass to save the value to the data source
@property (nonatomic, copy) void (^save)(NSString *value);

//Called to verify that the new value is acceptable to be saved to the data source.
@property (nonatomic, copy) BOOL (^validation)(NSString *value);

@end
