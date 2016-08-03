//
//  CBAutoCompleteModalController.m
//  Pods
//
//  Created by Cameron Bell on 2016-08-03.
//
//

#import "CBAutoCompleteModalController.h"

@interface CBAutoCompleteModalController () {
    
    //Weak reference to the formItem that created this controller
    __weak CBFormItem *_formItem;
}

@end

@implementation CBAutoCompleteModalController

-(id)initForFormItem:(CBFormItem *)formItem {
    if (self = [super initWithNibName:@"CBAutoCompleteModalController" bundle:nil]) {
        _formItem = formItem;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
