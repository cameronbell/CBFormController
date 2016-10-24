//
//  CBViewController.m
//  CBFormController
//
//  Created by Cameron Bell on 08/10/2015.
//  Copyright (c) 2015 Cameron Bell. All rights reserved.
//

#import "CBViewController.h"
#import "City.h"
#import "NSString+FontAwesome.h"


@interface CBViewController () {
    NSString *_text1;
    NSString *_text2;
    NSNumber *_switch1;
    IJCity *_city;
    NSArray *_cities;
}

@end

@implementation CBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _text1 = @"Cameron";
    _text2 = @"Bell";
    _switch1 = [NSNumber numberWithBool:YES];
    
    //get json from cities.json
    
    NSArray *json = [CBViewController arrayWithContentsOfJSONString:@"cities.json"];
    
    BOOL success = [self parseJSONIntoCities:json];
    
    if (!success) {
//        DDLogError(@"Cities.json parsing error");
//        ANN(nil); // if this happens it means the cities.json file can not be parsed correctly. so don't ship this build
    }

}

//same code as method above but returns an Array
+ (NSArray *)arrayWithContentsOfJSONString:(NSString *)fileLocation {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileLocation stringByDeletingPathExtension] ofType:[fileLocation pathExtension]];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    __autoreleasing NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:NSJSONReadingAllowFragments error:&error];
    // Be careful here. You add this as a category to NSDictionary
    // but you get an id back, which means that result
    // might be an NSArray as well!
    if (error != nil) return nil;
    return result;
}

- (BOOL)parseJSONIntoCities:(NSArray *)json {
    
    @try {
        //parse cities here
        
        NSMutableArray *cities = [NSMutableArray array];
        
        //NSNumber *cityVersion = [json objectForKey:@"version"];
        
        NSArray *cityData = json;
        
        for (int i = 0; i < [cityData count]; i++) {
            NSDictionary *cityDict = [cityData objectAtIndex:i];
            
            IJCity *city = [[IJCity alloc]init];
            
            NSString *name = [cityDict objectForKey:@"n"];
            NSString *region = [cityDict objectForKey:@"r"];
            NSString *cityId = [cityDict objectForKey:@"cityId"];
            [city setName:name];
            [city setCityId:cityId];
            [city setRegion:region];
            [cities addObject:city];
        }
        
//        [self setCities:[NSArray arrayWithArray:cities]];
        
//        [self alphabetizeCities];
        _cities = cities;
        
        //save cityVersion into defaults
        //[[NSUserDefaults standardUserDefaults] setObject:cityVersion forKey:@"cityVersion"];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLoadedCities"];
//        DDLogInfo(@"Successfully parsed City JSON");
        
        return YES;
    }
    @catch (NSException *exception)
    {
//        DDLogError(@"Error parsing City json");
        //loads the config from config.json if there was an error parsing the downloaded json
        
        return NO;
    }
}


-(NSArray *)getFormConfiguration {
    
    self.editMode = CBFormEditModeEdit;
    
    //[self setDefaultDate:[NSDate date]];
    
    NSMutableArray *sections = [NSMutableArray array];
    
    CBText *textItem = [[CBText alloc]initWithName:@"item1"];
    [textItem setTitle:@"Name"];
    [textItem setInitialValue:_text1];
    [textItem setIcon:FAUser];
    [textItem setConfigureCell:^void (CBCell *cell){
        CBTextCell *textCell = (CBTextCell *)cell;
        [textCell.textField setAdjustsFontSizeToFitWidth:NO];
    }];
    
    [sections addObject:@[textItem]];
    
    [textItem setSave:^(NSString *value) {
        _text1 = value;
    }];
    
    [textItem setValidation:^(NSString *value) {
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
    [switchItem setValidation:^BOOL (NSNumber *value) {
        return true;
    }];
    
    CBPicker *maleFemale = [[CBPicker alloc]initWithName:@"picker1"];
    [maleFemale setItems:@[@"Male",@"Female"]];
    [maleFemale setTitle:@"Sex"];
    [maleFemale setIcon:FAtransgender];
    
    CBAutoComplete *autoComplete = [[CBAutoComplete alloc]initWithName:@"autocomplete"];
    [autoComplete setObjectClass:[IJCity class]];
    [autoComplete setTitle:@"City"];
    [autoComplete setInitialValue:_city];
    [autoComplete setIcon:FAbuilding];
    [autoComplete setGetAutoCompletions:^NSArray* (NSString *queryString) {
        return _cities;
    }];
    [autoComplete setSave:^(NSObject *value) {
        _city = (IJCity *)value;
    }];
    
    [sections addObject:@[autoComplete]];
    
    
    CBPopupPicker *popup1 = [[CBPopupPicker alloc]initWithName:@"popup1"];
    [popup1 setItems:[NSMutableArray arrayWithArray:@[@"Male",@"Female"]]];
    [popup1 setAllowsCustomItems:YES];
    [popup1 setAllowsMultipleSelection:NO];
    [popup1 setTitle:@"Medication"];
    [popup1 setIcon:FAMedkit];
    [popup1 setIconColor:[UIColor redColor]];
    
    CBText *textItem2 = [[CBText alloc]initWithName:@"item3"];
    [textItem2 setTitle:@"Last Name"];
    [textItem2 setInitialValue:_text2];
    [textItem2 setChange:^(NSObject *initialValue, NSObject *newValue) {
        NSLog(@"Old: %@ New: %@",initialValue,newValue);
    }];
    [textItem2 setSave:^(NSString *value) {
        _text2 = value;
    }];
    [sections addObject:@[switchItem,textItem2,popup1,maleFemale]];
    
    CBDate *date1 = [[CBDate alloc]initWithName:@"date1"];
    [date1 setTitle:@"Birthdate"];
    [date1 setIcon:FACalendar];
    
    CBButton *button1 = [[CBButton alloc]initWithName:@"button1"];
    [button1 setButtonType:CBButtonTypeDelete];
    [button1 setSelect:^{
        NSLog(@"Button 1 Pressed!");
    }];
    [sections addObject:@[button1,date1]];
    
    CBComment *comment1 = [[CBComment alloc]initWithName:@"Comment1"];
    [comment1 setTitle:@"Comments"];
    [comment1 setIcon:FAComment];
    [sections addObject:@[comment1]];

    return sections;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
