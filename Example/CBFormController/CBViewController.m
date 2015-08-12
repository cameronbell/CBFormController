//
//  CBViewController.m
//  CBFormController
//
//  Created by Cameron Bell on 08/10/2015.
//  Copyright (c) 2015 Cameron Bell. All rights reserved.
//

#import "CBViewController.h"


@interface CBViewController () {
    NSString *_text1;
    NSString *_text2;
    NSNumber *_switch1;
}

@end

@implementation CBViewController

- (void)viewDidLoad
{
    
    _text1 = @"Cameron";
    _text2 = @"Bell";
    _switch1 = [NSNumber numberWithBool:YES];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(NSArray *)getFormConfiguration {
    
    self.editMode = CBFormEditModeFree;
    
    NSMutableArray *sections = [NSMutableArray array];
    
    CBText *textItem = [[CBText alloc]initWithName:@"item1"];
    [textItem setTitle:@"Name"];
    [textItem setInitialValue:_text1];
    [textItem setIcon:[FAKFontAwesome userIconWithSize:18]];
    [sections addObject:@[textItem]];
    
    [textItem setSave:^(NSString *value) {
        _text1 = value;
    }];
    
    [textItem setValidate:^(NSString *value) {
        if (value.length <3) {
            [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Derp" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil] show];
            return NO;
        }
        return YES;
        
    }];
    
    CBSwitch *switchItem = [[CBSwitch alloc]initWithName:@"item2"];
    [switchItem setTitle:@"The Switch"];
    [switchItem setInitialValue:_switch1];
    [switchItem setSave:^(NSNumber *value) {
        _switch1 = value;
    }];
    
    
    CBText *textItem2 = [[CBText alloc]initWithName:@"item3"];
    [textItem2 setTitle:@"Last Name"];
    [textItem2 setInitialValue:_text2];
    [textItem2 setChange:^(NSObject *initialValue, NSObject *newValue) {
        NSLog(@"Old: %@ New: %@",initialValue,newValue);
    }];
    [textItem2 setSave:^(NSString *value) {
        _text2 = value;
    }];
    [sections addObject:@[switchItem,textItem2]];
    
    CBDate *date1 = [[CBDate alloc]initWithName:@"date1"];
    [date1 setTitle:@"Birthdate"];
    [date1 setIcon:[FAKFontAwesome calendarIconWithSize:18]];
    
    CBButton *button1 = [[CBButton alloc]initWithName:@"button1"];
//    [button1 setTitle:@"Press it."];
    [button1 setButtonType:CBButtonTypeDelete];
    [button1 setSelect:^{
        NSLog(@"Button 1 Pressed!");
    }];
    [sections addObject:@[button1,date1]];

    return sections;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
