//
//  DDVCPopupPickerView.m
//  UTTI
//
//  Created by Cameron Bell on 2015-08-05.
//  Copyright (c) 2015 Cameron Bell. All rights reserved.
//

#import "CBPopupPickerView.h"
#import "CBPopupPicker.h"
#import "CBFormController.h"

@interface CBPopupPickerView () {
    NSMutableArray *_results;
    CBPopupPicker *_formItem;
    NSString *_searchTerm;
}

@end

@implementation CBPopupPickerView
@synthesize titleBar,searchField,searchTable;
@synthesize delegate = _delegate;


-(id)initForFormItem:(CBPopupPicker *)formItem withDelegate:(id <CBPopupPickerViewDelegate>)delegate{
    if (self = [super initWithNibName:@"CBPopupPickerView" bundle:[NSBundle bundleForClass:[self class]]]) {
        _delegate = delegate;
        _formItem = formItem;
        _results = [NSMutableArray arrayWithArray:formItem.items];
        
        _searchTerm = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UINavigationItem *titleItem = [[UINavigationItem alloc]initWithTitle:_formItem.title];
    
    [self.titleBar setItems:@[titleItem]];
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring
                 stringByReplacingCharactersInRange:range withString:string];
    _searchTerm = substring;
    [self searchAutocompleteEntriesWithSubstring:substring];
    return YES;
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    
    //Show all of the items when the string is empty
    if ([substring isEqualToString:@""]) {
        _results = [NSMutableArray arrayWithArray:_formItem.items];
        [self.searchTable reloadData];
        return;
    }
    
    [_results removeAllObjects];
    for(NSString *curString in _formItem.items) {
        NSRange substringRange = [[curString lowercaseString] rangeOfString:[substring lowercaseString]];
        if (substringRange.location == 0) {
            [_results addObject:curString];
        }
    }
    
    [self.searchTable reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    //Add an extra row for the custom item cell
    if (_searchTerm.length > 0) {
        return [_results count] + 1;
    }
    
    return [_results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]
            initWithStyle:UITableViewCellStyleDefault
            reuseIdentifier:@"cell"];
    
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setClipsToBounds:YES];
    
    
    int customItemCellOffset = 0;
    if (_searchTerm.length > 0) {
        customItemCellOffset = -1;
    }
    
    if (indexPath.row == 0 && customItemCellOffset < 0) {
        [cell.textLabel setText:[NSString stringWithFormat:@"Add item named %@ ...",_searchTerm]];
    }else{
        [cell.textLabel setText:[_results objectAtIndex:indexPath.row + customItemCellOffset]];
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int customItemCellOffset = 0;
    if (self.searchField.text.length > 0) {
        customItemCellOffset = -1;
    }
    
    NSString *result;
    if (indexPath.row == 0 && customItemCellOffset < 0) {
        result = self.searchField.text;
    }else{
        result = [_results objectAtIndex:indexPath.row + customItemCellOffset];
    }
    
    
    
    [self.delegate popupPickerForFormItem:_formItem didSelectItem:result];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.searchField.text.length > 1) {
        return NO;
    }
    
    return YES;
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
