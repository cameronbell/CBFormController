//
//  DDVCPopupPickerView.m
//  UTTI
//
//  Created by Cameron Bell on 2015-08-05.
//  Copyright (c) 2015 Cameron Bell. All rights reserved.
//

#import "CBPopupPickerCell.h"
#import "CBFormController.h"

@interface CBPopupPickerView () {
    NSMutableArray *_results;
    NSMutableArray *_selections;
    CBPopupPicker *_formItem;
    NSString *_searchTerm;
}

@end

@implementation CBPopupPickerView
@synthesize titleBar,searchField,searchTable;
@synthesize delegate = _delegate;

-(id)initForFormItem:(CBPopupPicker *)formItem withDelegate:(id <CBPopupPickerViewDelegate>)delegate allowsMultipleSelection:(BOOL)multipleSelections allowsCustomItems:(BOOL)customItems selections:(NSArray *)selections {
    if (self = [super initWithNibName:@"CBPopupPickerView" bundle:[NSBundle bundleForClass:[self class]]]) {
        _delegate = delegate;
        _formItem = formItem;
        _results = [NSMutableArray arrayWithArray:formItem.items];
        _selections = selections ? [NSMutableArray arrayWithArray:selections] : [NSMutableArray array];
        _searchTerm = @"";
        _allowsCustomItems = customItems && !multipleSelections; //If multipleSelections is allowed then don't allow customItems
        _allowsMultipleSelections = multipleSelections;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UINavigationItem *titleItem = [[UINavigationItem alloc]initWithTitle:_formItem.title];
    
    [titleItem setRightBarButtonItem:_allowsMultipleSelections ? [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(multipleSelectionDoneButton:)] : nil];

    [self.titleBar setItems:@[titleItem]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.topOfTable setConstant: _allowsCustomItems ? 96 : self.titleBar.frame.size.height];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]
            initWithStyle:UITableViewCellStyleDefault
            reuseIdentifier:@"cell"];
    
    [cell setClipsToBounds:YES];
    
    int customItemCellOffset = 0;
    if (_searchTerm.length > 0) {
        customItemCellOffset = -1;
    }
    
    if (indexPath.row == 0 && customItemCellOffset < 0) {
        [cell.textLabel setText:[NSString stringWithFormat:@"Add item named %@ ...",_searchTerm]];
    }else{
        [cell.textLabel setText:[_results objectAtIndex:indexPath.row + customItemCellOffset]];
        if (_allowsMultipleSelections) {
            if ([_selections containsObject:cell.textLabel.text]) {
                //Add checkbox to cell
                UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"checkmark"]];
                [imgView setFrame:CGRectMake(cell.frame.size.width-22-50, (cell.frame.size.height-22)/2, 22, 22)];
                [cell addSubview:imgView];
            } else {
                UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"checkmark-future"]];
                [imgView setFrame:CGRectMake(cell.frame.size.width-22-50, (cell.frame.size.height-22)/2, 22, 22)];
                [cell addSubview:imgView];
            }
        }
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
    
    
    if(_allowsMultipleSelections) {
        if([_selections containsObject:result]) {
            [_selections removeObject:result];
        }else{
            [_selections addObject:result];
        }
        [self.searchTable reloadData];
    }else{
        [self.delegate popupPickerForFormItem:_formItem didSelectItems:@[result]];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.searchField.text.length > 1) {
        return NO;
    }
    
    return YES;
}

-(IBAction)multipleSelectionDoneButton:(id)sender {
    [self.delegate popupPickerForFormItem:_formItem didSelectItems:_selections];
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
