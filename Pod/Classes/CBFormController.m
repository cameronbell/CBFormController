//
//  CBFormController.m
//  CBFormController
//
//  Created by Cameron Bell on 2015-08-10.
//  Copyright (c) 2015 Cameron Bell. All rights reserved.
//

#import "CBFormController.h"




@interface CBFormController () {
    NSMutableArray *_sectionArray;
    
    CBCellSet *_cellSet;
    
    CBFormItem *_engagedItem;
    
    BOOL _scrollAutomationLock;
}

@end

@implementation CBFormController
@synthesize formTable = _formTable;
@synthesize editMode = _editMode;
@synthesize defaultDate = _defaultDate;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _scrollAutomationLock = NO;
        _editing = NO;
    }
    return self;
}

#pragma mark - Configuration Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Makes the formTable and ensures that it is properly setup with in the view
    [self setupTable];
    
    //Get all of the form configuration information from the subclass
    [self loadFormConfiguration];
    
    //This ensures this class gets the OS notifications about when the keyboard is shown
    [self registerForKeyboardNotifications];
    
    //Configures the navigation bar buttons
    [self setupNavigationBar];
    
}

-(void)setupTable {
    
    //Create the form table and set its view to the size of the
    self.formTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.formTable setDelegate:self];
    [self.formTable setDataSource:self];
    
    [self.view addSubview:self.formTable];
    
}

-(void)loadFormConfiguration {
    
    _sectionArray = [NSMutableArray arrayWithArray:[self getFormConfiguration]];
    
    //Ensure the formController property is set for all formItems
    //TODO: This will need to change to facilitate formItems being added.
    for (NSArray *section in _sectionArray) {
        for (CBFormItem *formItem in section) {
            formItem.formController = self;
        }
    }

    
}

//This function is called to collect all the necessary information from the subclass about how to build the form
-(NSArray *)getFormConfiguration {
    
    NSAssert(NO, @"This function must be overridden in the subclass.");
    
    return nil;
}

//Returns the cellSet that should be used to load the cells. Defaults to CBCellSet1.
-(CBCellSet *)cellSet {
    if (!_cellSet) {
        _cellSet = [[CBCellSet1 alloc]init];
    }
    return _cellSet;
}

-(UIEdgeInsets)getOriginalContentInsets {
    return UIEdgeInsetsMake(0, 0, 0, 0);
    //    return self.formTable.contentInset;
}

//If nothing sets the editMode property it defaults to CBFormEditModeFree mode.
-(CBFormEditMode)editMode {
    return _editMode ? _editMode : CBFormEditModeFree;
}

-(BOOL)editing {
    switch ([self editMode]) {
        case CBFormEditModeFrozen:
            return NO;
        case CBFormEditModeEdit:
            return _editing;
        case CBFormEditModeFree:
        case CBFormEditModeSave:
            return YES;
        default:
            break;
    }
}

#pragma mark - FormItem Access Methods

//Returns an array of only the formItems flatened from the sectionArray
-(NSMutableArray *)formItems {
    NSMutableArray *formItems = [NSMutableArray array];
    for (int i = 0; i<[_sectionArray count]; i++) {
        NSMutableArray *itemArray = [_sectionArray objectAtIndex:i];
        [formItems addObjectsFromArray:itemArray];
    }
    return formItems;
}

//Returns the formitem at a given indexPath as represented in the sectionArray
-(CBFormItem *)formItemForIndexPath:(NSIndexPath *)indexPath {
    return [[_sectionArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
}

//Returns the formitem at a given index in a linear list of the cells
-(CBFormItem *)formItemForRowIndex:(int)rowIndex {
    return [self.formItems objectAtIndex:rowIndex];
}

//Returns the
-(int)rowIndexForFormItem:(CBFormItem *)formItem {
    
    int rowIndex = 0;
    for (CBFormItem *formItem in [self formItems]) {
        if ([formItem equals:formItem]) {
            return rowIndex;
        }
        rowIndex++;
    }
    
    NSAssert(NO, @"This method should always find an equivalent formitem.");
    return 0;
}

#pragma mark - Engage/Dismiss Methods


// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    _scrollAutomationLock = YES;
    
    CGFloat topInset = [self getOriginalContentInsets].top;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(topInset, 0.0, kbSize.height, 0.0);
    self.formTable.contentInset = contentInsets;
    self.formTable.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    NSIndexPath *indexPath = [self.formTable indexPathForCell:_engagedItem.cell];
    
    CGRect cellRect = [self.formTable rectForRowAtIndexPath:indexPath];
    cellRect = CGRectMake(cellRect.origin.x, cellRect.origin.y+20, cellRect.size.width, cellRect.size.height);
    
    if (!CGRectContainsPoint(aRect, cellRect.origin) ) {
        
        //[self.formTable setUserInteractionEnabled:NO];
        [self.formTable scrollRectToVisible:cellRect animated:YES];
        //_scrollAutomationLock = NO;
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = [self getOriginalContentInsets];
    self.formTable.contentInset = contentInsets;
    self.formTable.scrollIndicatorInsets = contentInsets;
}

-(void)engageFormItem:(CBFormItem *)formItem {
    _engagedItem = formItem;
    
    [formItem engage];
    
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.formItems];
    [items removeObject:formItem];
    for (int i = 0; i<[items count]; i++) {
        CBFormItem *formItem = [items objectAtIndex:i];
        if ([formItem isEngaged]) {
            [formItem dismiss];
        }
    }
}

-(void)dismissFormItem:(CBFormItem*)formItem {
    [formItem dismiss];
    if ([formItem equals:_engagedItem]) {
        _engagedItem = nil;
    }
}

#pragma mark - Return Key Management

-(BOOL)textFieldShouldReturnForFormItem:(CBFormItem *)formItem {
    CBFormItem *nextItem = [self getNextItemForReturnAfter:formItem];
    if (nextItem == nil) {
        [self dismissFormItem:formItem];
    }else{
        [self engageFormItem:nextItem];
    }
    return NO;
}

-(CBFormItem *)getNextItemForReturnAfter:(CBFormItem *) formItem {
    NSInteger menuOffset = [self.formItems indexOfObject:formItem];
    if ((menuOffset+1)< [self.formItems count]) {
        return  [self.formItems objectAtIndex:(menuOffset+1)];
    }else {
        return nil;
    }
    
}

#pragma mark - UITableView Delegate/Datasource Methods



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return UITableViewAutomaticDimension;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CBFormItem *formItem = [self formItemForIndexPath:indexPath];
    
    return [formItem height];
    
    /*
    switch (formItem.type) {
        case DDVCText:{
            
            NSInteger count = [self numberOfTitleLinesForFormItem:formItem];
            if (count == 2) {
                return 70;
            }else{
                return FORM_CONTROLLER_DEFAULT_FIELD_HEIGHT;
            }
            
            
            break;}
        case DDVCFAQ:{
            NSString *question = [[self faqForIndexPath:indexPath] question];
            CGSize questionSize = [question sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0]
                                       constrainedToSize:CGSizeMake(QUESTION_W, 9999)
                                           lineBreakMode:NSLineBreakByWordWrapping];
            
            
            int questionSizeAdjusted = questionSize.height + FAQ_QUESTION_BOTTOM_PADDING;
            
            if (questionSizeAdjusted < FORM_CONTROLLER_DEFAULT_FIELD_HEIGHT) {
                questionSizeAdjusted = FORM_CONTROLLER_DEFAULT_FIELD_HEIGHT;
            }
            
            if ([formItem isEngaged]) {
                return questionSizeAdjusted + [[formItem.data objectForKey:@"answerHeight"]floatValue]+FAQ_ANSWER_BOTTOM_PADDING;
            }else{
                return questionSizeAdjusted;
            }
            break;}
        case DDVCButton:{
            
            if ([[formItem.data objectForKey:@"height"] intValue]) {
                return [[formItem.data objectForKey:@"height"] intValue];
            }else{
                return FORM_CONTROLLER_DEFAULT_FIELD_HEIGHT;
            }
            break;}
        case DDVCSwitch:{
            NSInteger count = [self numberOfTitleLinesForFormItem:formItem];
            if (count == 4) {
                return 120;
            }else if (count == 2) {
                return 70;
            }else{
                return FORM_CONTROLLER_DEFAULT_FIELD_HEIGHT;
            }
            break;}
        case DDVCDate:{
            if ([formItem isEngaged]) {
                if (IOS7) {
                    return 210;
                }else{
                    return FORM_CONTROLLER_DEFAULT_FIELD_HEIGHT;
                }
                
            }else{
                return FORM_CONTROLLER_DEFAULT_FIELD_HEIGHT;
            }
            break;
        }
        case DDVCDoseCell: {
            return 86;//66;
            break;
        }
        case DDVCPicker: {
            if ([formItem isEngaged] && IOS7) {
                return [[formItem.data objectForKey:@"height"] intValue];
                
            }else{
                return FORM_CONTROLLER_DEFAULT_FIELD_HEIGHT;
            }
            break;
        }
        case DDVCComment: {
            if ([formItem isEngaged]) {
                return [[[self getHeightsForComment:formItem] objectAtIndex:1]floatValue];
            }else{
                return [[[self getHeightsForComment:formItem] objectAtIndex:0]floatValue];
            }
            break;
        }
        case DDVCAutoComplete: {
            
            NSInteger count = [self numberOfTitleLinesForFormItem:formItem];
            if (count == 2) {
                return 70;
            }else{
                return FORM_CONTROLLER_DEFAULT_FIELD_HEIGHT;
            }
            break;
        }
        case DDVCCaption: {
            return FORM_CONTROLLER_DEFAULT_FIELD_HEIGHT*1.5;
            break;
        }
        case DDVCSegmentedControl: {
            
            if (IOS7) {
                return FORM_CONTROLLER_DEFAULT_FIELD_HEIGHT;
            }else{
                return 60;
            }
            
            break;
        }
        default:
            return FORM_CONTROLLER_DEFAULT_FIELD_HEIGHT;
            break;
    }
     
     */
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_sectionArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = 0;
    for (int i = 0; i<[[_sectionArray objectAtIndex:section] count]; i++) {
        CBFormItem *formItem = [[_sectionArray objectAtIndex:section] objectAtIndex:i];
        if (![formItem isHidden]) {
            count++;
        }
    }
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CBFormItem *formItem = [self formItemForIndexPath:indexPath];
    
    return [formItem cell];
    
    
    
    /*
    DDVCCell *returnCell;
    switch (formItem.type) {
        case DDVCButton: {
            DDVCButtonCell *cell;// = [self.formTable dequeueReusableCellWithIdentifier:@"DDVCButtonCell"];
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DDVCButtonCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[DDVCButtonCell class]]) {
                    cell = (DDVCButtonCell*) currentObject;
                    break;
                }
            }
            
            [cell.titleLabel setText:[self titleForCellAtIndexPath:indexPath]];
            returnCell = cell;
            break;
        }
        case DDVCText: {
            
            
            DDVCTextCell *cell;// = [self.formTable dequeueReusableCellWithIdentifier:@"DDVCTextCell"];
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DDVCTextCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[DDVCTextCell class]]) {
                    cell = (DDVCTextCell*) currentObject;
                    break;
                }
            }
            
            [cell.textField setPlaceholder:[self titleForCellAtIndexPath:indexPath]];
            [cell.textField setUserInteractionEnabled:NO];
            [cell.textField setDelegate:self];
            [cell.textField setTag:[self menuOffsetForIndexPath:indexPath]];
            
            NSString *initialValue = (NSString *)[self initialValueForFormItem:formItem];
            if (initialValue) {
                [cell.textField setText:initialValue];
            }
            
            returnCell = cell;
            break;
        }
        case DDVCFAQ: {
            DDVCFAQCell *cell;// = [self.formTable dequeueReusableCellWithIdentifier:@"DDVCFAQCell"];
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DDVCFAQCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[DDVCFAQCell class]]) {
                    cell = (DDVCFAQCell*) currentObject;
                    break;
                }
            }
            
            
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            
            
            NSString *question = [[self faqForIndexPath:indexPath] question];
            NSString *answer = [[self faqForIndexPath:indexPath] answer];
            
            CGSize questionSize = [question sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0]
                                       constrainedToSize:CGSizeMake(QUESTION_W, 9999)
                                           lineBreakMode:NSLineBreakByWordWrapping];
            
            
            int questionSizeAdjusted = questionSize.height + 20;
            
            [cell.questionTextView removeFromSuperview];
            cell.questionTextView = [[UILabel alloc]initWithFrame:CGRectMake(QUESTION_X, QUESTION_VERT_MARGIN, QUESTION_W,questionSizeAdjusted)];
            
            [cell.questionTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0]];
            [cell addSubview:cell.questionTextView];
            [cell.questionTextView setUserInteractionEnabled:NO];
            [cell.questionTextView setText:question];
            [cell.questionTextView setBackgroundColor:[UIColor clearColor]];
            [cell.questionTextView setLineBreakMode:NSLineBreakByWordWrapping];
            [cell.questionTextView setNumberOfLines:0];
            int questionHeightTotal = questionSizeAdjusted + QUESTION_VERT_MARGIN;
            [formItem.data setObject:NUMINT(questionHeightTotal) forKey:@"questionHeight"];
            [formItem.data setObject:NUMINT(0) forKey:@"answerHeight"];
            
            [cell.answerWebView removeFromSuperview];
            
            cell.answerWebView = [[UIWebView alloc]initWithFrame:CGRectZero];
            
            //TODO: This should be YES to enable links but there are some details I don't have the time to work out right now. Double tapping...
            [cell.answerWebView setUserInteractionEnabled:NO];
            
            //cell.answerWebView = [[UIWebView alloc]initWithFrame:CGRectMake(DDVC_FAQ_ANSWER_LEFT_INSET, questionSizeAdjusted, 280,0)];
            
            [cell.answerWebView setFrame:CGRectMake(DDVC_FAQ_ANSWER_LEFT_INSET, questionSizeAdjusted, 280,0)];
            
            NSString *helvetica = @"<body style=\"font-family:HelveticaNeue-Light;font-size:17px;\">";
            //NSString *content =[NSString stringWithFormat:@"<html><body style='background-color: transparent; width: 280px; margin: 0; padding: 0;'><div id='ContentDiv'>%@</div></body></html>",answer];
            
            NSString *fontedString = [[helvetica stringByAppendingString:answer] stringByAppendingString:@"</body>"];
            
            [cell.answerWebView setDelegate:self];
            [cell.answerWebView setTag:[self menuOffsetForIndexPath:indexPath]];
            
            //[cell.answerWebView.scrollView setContentInset:UIEdgeInsetsMake(0,DDVC_FAQ_ANSWER_LEFT_INSET, 0, 0)];
            [cell.answerWebView setBackgroundColor:[UIColor clearColor]];
            [cell.answerWebView setOpaque:NO];
            [cell.answerWebView loadHTMLString:fontedString baseURL:nil];
            [cell.answerWebView.scrollView setScrollEnabled:NO];
            [cell setClipsToBounds:YES];
            [cell addSubview:cell.answerWebView];
            
            
            returnCell = cell;
            
            break;
        }
        case DDVCDate: {
            DATE_FORMATTER
            DDVCDateCell *cell;// = [self.formTable dequeueReusableCellWithIdentifier:@"DDVCDateCell"];
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DDVCDateCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[DDVCDateCell class]]) {
                    cell = (DDVCDateCell*) currentObject;
                    break;
                }
            }
            
            [cell.fieldLabel setPlaceholder:[self titleForCellAtIndexPath:indexPath]];
            [cell.fieldLabel setUserInteractionEnabled:NO];
            
            if (IOS7) {
                [cell.datePicker addTarget:self action:@selector(datePicker:) forControlEvents:UIControlEventValueChanged];
                [cell.datePicker setTag:[self menuOffsetForIndexPath:indexPath]];
            }else{
                [cell.datePicker removeFromSuperview];
                [self.iOS6DatePicker addTarget:self action:@selector(datePicker:) forControlEvents:UIControlEventValueChanged];
                [self.iOS6DatePicker setTag:[self menuOffsetForIndexPath:indexPath]];
                
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            
            
            //Set default date
            //[cell.fieldLabel setText:[dF stringFromDate:[NSDate date]]];
            //[formItem.data setObject:[NSDate date] forKey:@"date"];
            
            //Set initial value
            NSDate *initialValue = (NSDate *)[self initialValueForFormItem:formItem];
            if (initialValue) {
                
                if (IOS7) {
                    [cell.datePicker setDate:initialValue];
                }else{
                    [self.iOS6DatePicker setDate:initialValue];
                }
                
                [cell.fieldLabel setText:[dF stringFromDate:initialValue]];
                [formItem.data setObject:initialValue forKey:@"date"];
            }
            
            
            returnCell = cell;
            break;
        }
        case DDVCSwitch: {
            DDVCSwitchCell *cell;// = [self.formTable dequeueReusableCellWithIdentifier:@"DDVCSwitchCell"];
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DDVCSwitchCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[DDVCSwitchCell class]]) {
                    cell = (DDVCSwitchCell*) currentObject;
                    break;
                }
            }
            
            
            [cell.titleLabel setText:[self titleForCellAtIndexPath:indexPath]];
            if (IOS7) {
                [cell.yesLabel setText:GLS(@"YES")];
                [cell.noLabel setText:GLS(@"NO")];
            }else{
                [cell.yesLabel removeFromSuperview];
                [cell.noLabel removeFromSuperview];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            //[_fields insertObject:cell.theSwitch atIndex:menuOffset];
            
            //Set initial value
            NSNumber *initialValue = (NSNumber *)[self initialValueForFormItem:formItem];
            if (initialValue) {
                [cell.theSwitch setOn:[initialValue boolValue]];
            }
            
            
            
            returnCell = cell;
            break;
        }
        case DDVCPicker: {
            
            
            DDVCPickerCell *cell;// = [self.formTable dequeueReusableCellWithIdentifier:@"DDVCPickerCell"];
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DDVCPickerCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[DDVCPickerCell class]]) {
                    cell = (DDVCPickerCell*) currentObject;
                    break;
                }
            }
            
            [cell.pickerField setPlaceholder:[self titleForCellAtIndexPath:indexPath]];
            [cell.pickerField setUserInteractionEnabled:NO];
            //[cell.pickerButton setTag:[self menuOffsetForIndexPath:indexPath]];
            //[cell.pickerButton setUserInteractionEnabled:NO];
            
            //
            CGFloat f = 180;
            [formItem.data setObject:NUMINT(f) forKey:@"height"];
            if (IOS7) {
                //[cell.picker addTarget:self action:@selector(picker:) forControlEvents:UIControlEventValueChanged];
                [cell.picker setTag:[self menuOffsetForIndexPath:indexPath]];
                
                [cell.picker setDelegate:self];
                [cell.picker setDataSource:self];
                
            }else{
                [cell.picker removeFromSuperview];
                //[self.iOS6Picker addTarget:self action:@selector(datePicker:) forControlEvents:UIControlEventValueChanged];
                [self.iOS6Picker setTag:[self menuOffsetForIndexPath:indexPath]];
                [self.iOS6Picker setDelegate:self];
                [self.iOS6Picker setDataSource:self];
                
            }
            
            //This needs to be called before setSelectedString can be called.
            [formItem setCell:cell];
            
            //Set initial value
            NSString *initialValue = (NSString *)[self initialValueForFormItem:formItem];
            if (initialValue) {
                [self setSelectedString:initialValue forPickerItem:formItem.name];
            }
            
            
            
            returnCell = cell;
            break;
        }
        case DDVCComment: {
            DDVCCommentCell *cell;// = [self.formTable dequeueReusableCellWithIdentifier:@"DDVCCommentCell"];
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DDVCCommentCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[DDVCCommentCell class]]) {
                    cell = (DDVCCommentCell*) currentObject;
                    break;
                }
            }
            
            [cell.titleLabel setText:[self titleForCellAtIndexPath:indexPath]];
            [cell.textView setUserInteractionEnabled:NO];
            [cell.textView setTag:[self menuOffsetForIndexPath:indexPath]];
            [cell.textView setDelegate:self];
            [cell.donelabel setHidden:YES];
            
            [cell.textView setPlaceholder:@"Comments"];
            
            NSString *initialValue = (NSString *)[self initialValueForFormItem:formItem];
            if (initialValue) {
                [cell.textView setText:initialValue];
            }
            
            returnCell = cell;
            break;
        }
        case DDVCAutoComplete: {
            DDVCAutoCompleteCell *cell;// = [self.formTable dequeueReusableCellWithIdentifier:@"DDVCAutoComplete"];
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DDVCAutoCompleteCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[DDVCAutoCompleteCell class]]) {
                    cell = (DDVCAutoCompleteCell*) currentObject;
                    break;
                }
            }
            
            [cell.titleLabel setText:[self titleForCellAtIndexPath:indexPath]];
            [cell.autoCompleteTextField setDelegate:self];
            [cell.autoCompleteTextField setAutoCompleteDelegate:self];
            [cell.autoCompleteTextField setAutoCompleteDataSource:self];
            [cell.autoCompleteTextField setFormItem:formItem];
            [cell.autoCompleteTextField setAutoCompleteTableAppearsAsKeyboardAccessory:NO];
            [cell.autoCompleteTextField registerAutoCompleteCellClass:[AutoCompleteOptionCell class] forCellReuseIdentifier:@"AutoCompleteOptionCell"];
            [cell.autoCompleteTextField setUserInteractionEnabled:NO];
            [cell.autoCompleteTextField setReverseAutoCompleteSuggestionsBoldEffect:YES];
            [cell.autoCompleteTextField setTag:[self menuOffsetForIndexPath:indexPath]];
            [cell.autoCompleteTextField setBackgroundColor:[UIColor whiteColor]];
            
            NSString *initialValue = (NSString *)[self initialValueForFormItem:formItem];
            if (initialValue) {
                [cell.autoCompleteTextField setText:initialValue];
            }
            
            returnCell = cell;
            break;
        }
        case DDVCCaption: {
            DDVCCaptionCell *cell;// = [self.formTable dequeueReusableCellWithIdentifier:@"DDVCCaptionCell"];
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DDVCCaptionCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[DDVCCaptionCell class]]) {
                    cell = (DDVCCaptionCell*) currentObject;
                    break;
                }
            }
            
            [cell.titleLabel setText:[self titleForCellAtIndexPath:indexPath]];
            
            [self refreshCaption:formItem ForCaptionCell:cell forIndexPath:indexPath];
            
            
            
            [cell.cameraIcon setTitle:[NSString fontAwesomeIconStringForEnum:FACamera] forState:UIControlStateNormal];
            [cell.cameraIcon.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:22]];
            [cell.cameraIcon setTitleColor:COLOUR_ALERT_GREY forState:UIControlStateNormal];
            [cell.cameraIcon setUserInteractionEnabled:NO];
            
            
            returnCell = cell;
            break;
        }
        case DDVCSegmentedControl: {
            DDVCSegmentedControlCell *cell;// = [self.formTable dequeueReusableCellWithIdentifier:@"DDVCSegmentedControlCell"];
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DDVCSegmentedControlCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[DDVCSegmentedControlCell class]]) {
                    cell = (DDVCSegmentedControlCell*) currentObject;
                    break;
                }
            }
            
            
            NSArray *segments = [self titleArrayForSegmentedControl:formItem];
            
            [cell.segmentedControl removeAllSegments];
            
            for (int i = 0; i<[segments count]; i++) {
                [cell.segmentedControl insertSegmentWithTitle:[segments objectAtIndex:i] atIndex:i animated:NO];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            
            NSNumber *initialValue = (NSNumber *)[self initialValueForFormItem:formItem];
            if (initialValue) {
                [cell.segmentedControl setSelectedSegmentIndex:[initialValue intValue]];
            }
            
            returnCell = cell;
            break;
        }
        case DDVCPopupPicker: {
            
            DDVCPopupPickerCell *cell;
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DDVCPopupPickerCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[DDVCPopupPickerCell class]]) {
                    cell = (DDVCPopupPickerCell *) currentObject;
                    break;
                }
            }
            
            [cell.textField setPlaceholder:[self titleForCellAtIndexPath:indexPath]];
            [cell.textField setText:(NSString *)[self initialValueForFormItem:formItem]];
            [cell.textField setUserInteractionEnabled:NO];
            [formItem.data setObject:[self getItemsForPopupPickerFormItem:formItem] forKey:@"items"];
            
            returnCell = cell;
            break;
        }
        default:
            break;
    }
    [formItem setCell:returnCell];
    
    FAIcon icon = [self iconForFormItem:formItem];
    if (icon == 0) {
        [returnCell.icon setText:@""];
    }else{
        [returnCell.icon setText:[NSString fontAwesomeIconStringForEnum:icon]];
        [returnCell.icon setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:22]];
        [returnCell.icon setTextColor:COLOUR_BLUE];
    }
    
    
    for(int i = 0;i<[self.formItems count];i++) {
        FormItem *formItemI = [self.formItems objectAtIndex:i];
        if ([formItemI.cell isEqual:formItem.cell] && ![formItem isEqual:formItemI]) {
            NSLog(@"WTF");
        }
    }
    
    if (!IOS7) {
     
        UIView *backGroundView = [[UIView alloc]initWithFrame:CGRectZero];
        [backGroundView setBackgroundColor:[UIColor whiteColor]];
        [returnCell setBackgroundView:backGroundView];
    }
    
    
    
    [returnCell setClipsToBounds:YES];
    
    return returnCell;
    
     */
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBFormItem *formItem = [self formItemForIndexPath:indexPath];
    
    //This ensures that if a FormItem is pressed while the form is not in editing mode that nothing will happen, unless the formItem's enabledWhenNotEditing property is true
    if (!([self editing] || formItem.enabledWhenNotEditing)) {
        return;
    }
    
    switch (formItem.type) {
        case Text:
        case Date:
        case Comment:
        case AutoComplete:
        case FAQ: {
            if ([formItem isEngaged]) {
                [self dismissFormItem:formItem];
            }else{
                [self engageFormItem:formItem];
            }
            break;
        }
        case Picker: {
            break;
        }
        case PopupPicker: {
            break;
        }
        case Button: {
            [formItem selected];
            break;
        }
        case Switch:
        case Caption:
        default:
            break;
    }
    
    //These two things need to be accounted for

    /*
        case DDVCPicker:{
            
            if ([formItem isEngaged]) {
                [self dismissFormItem:formItem];
            }else{
                
                CGFloat f = 180;
                [formItem.data setObject:NUMINT(f) forKey:@"height"];
                [self.iOS6Picker setTag:[self menuOffsetForIndexPath:indexPath]];
                [self.iOS6Picker reloadAllComponents];
                [self engageFormItem:formItem];
                
            }
            break;
        }
               case DDVCPopupPicker: {
            
            DDVCPopupPickerView *pickerPopupView = [[DDVCPopupPickerView alloc]initForFormItem:formItem withTitle:[self titleForCellAtIndexPath:indexPath] withItems:[self getItemsForPopupPickerFormItem:formItem] withDelegate:self];
            
            MZFormSheetController *pickerPopup = [[MZFormSheetController alloc]initWithViewController:pickerPopupView];
            pickerPopup.shouldDismissOnBackgroundViewTap = YES;
            pickerPopup.transitionStyle = MZFormSheetTransitionStyleSlideFromBottom;
            pickerPopup.cornerRadius = 8.0;
            pickerPopup.portraitTopInset = 6.0;
            pickerPopup.landscapeTopInset = 6.0;
            
            CGRect screenSize = [[UIScreen mainScreen]bounds];
            
            pickerPopup.presentedFormSheetSize = CGSizeMake(screenSize.size.width - 40, 350);
            
            pickerPopup.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController){
                presentedFSViewController.view.autoresizingMask = presentedFSViewController.view.autoresizingMask | UIViewAutoresizingFlexibleWidth;
            };
            
            [pickerPopup presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
                
            }];
            
            
            break;
        }
            
        default:
            break;
    }*/

}

#pragma mark - Navigation Bar Management Methods

-(void)setupNavigationBar {
    [self installRightBarButton];
    
    [self updateNavigationBar];
}

-(void)updateNavigationBar {
    
    //The CBFormEditModeFrozen and CBFormEditModeFree Edit modes do not require any changes to the navigation bar buttons
    //The CBFormEditModeEdit and CBFormEditModeSave modes do.
    switch ([self editMode]) {
        case CBFormEditModeFrozen:
        case CBFormEditModeFree:
            break;
        case CBFormEditModeEdit:
        case CBFormEditModeSave:
        {
            [self configureRightBarButton];
            [self configureLeftBarButton];
            break;
        }
        default:
            break;
    }
}


-(void)configureRightBarButton {
    switch ([self editMode]) {
        case CBFormEditModeEdit:{
            if ([self editing]) {
                [self.rightButton setTitle:@"Save" forState:UIControlStateNormal];
                [self.rightButton setEnabled:[self isFormEdited]];
            }else{
                [self.rightButton setTitle:@"Edit" forState:UIControlStateNormal];
            }
            break;
        }
        case CBFormEditModeSave:{
            [self.rightButton setTitle:@"Save" forState:UIControlStateNormal];
            [self.rightButton setEnabled:[self isFormEdited]];
            break;
        }
            
            
            
        default:
            break;
    }
}

-(void)installRightBarButton {
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setFrame:CGRectMake(0, 12, 70, 22)];
    [self.rightButton addTarget:self action:@selector(rightButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    [self.rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.rightButton setTitleColor:APPLE_BLUE forState:UIControlStateNormal];
    [self.rightButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    [self.navigationItem setRightBarButtonItem:saveBarButton animated:YES];
    
}

-(void)configureLeftBarButton {
    
    if ([self editing]) {
        
        
        if ([self isFormEdited]){
            UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
            [cancelButton setFrame:CGRectMake(0, 12, 70, 22)];
            [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
            
            [cancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
            [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
            [cancelButton setTitleColor:APPLE_BLUE forState:UIControlStateNormal];
            [cancelButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
            
            UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
            
            [self.navigationItem setLeftBarButtonItem:cancelBarButton animated:YES];
            [self.navigationItem setHidesBackButton:YES animated:YES];
        }else{
            [self.navigationItem setLeftBarButtonItem:nil animated:YES];
            [self.navigationItem setHidesBackButton:NO animated:YES];
        }
    }else{
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
        [self.navigationItem setHidesBackButton:NO animated:YES];
    }
}

-(IBAction)rightButtonWasPressed:(id)sender {
    switch ([self editMode]) {
        case CBFormEditModeEdit:{
            if ([self editing]) {
                [self save];
            }else{
                [self beginEdit];
            }
            break;
        }
        case CBFormEditModeSave: {
            [self save];
        }
        default:
            break;
    }
}

#pragma mark - Data Methods (Save, etc...)

-(void)save {
    [self dismissAllFields];
    
    BOOL saveSuccess = YES;
    for (CBFormItem *formItem in [self formItems]) {
        if (![formItem attemptSave]) {
            saveSuccess = NO;
            break;
        }
    }
    
    if (saveSuccess) {
        self.editing = NO;
        [self reloadEntireForm];
    }
}

-(void)beginEdit {
    self.editing = YES;
    [self reloadEntireForm];
}

-(void)cancel {
    self.editing = NO;
    [self dismissAllFields];
    [self reloadEntireForm];
}

-(void)formWasEdited {
    [self updateNavigationBar];
}

#pragma mark - Utility Methods

-(BOOL)isFormEdited {
    for (CBFormItem *formItem in [self formItems]) {
        if ([formItem isEdited]) {
            return YES;
        }
    }
    return NO;
}

-(void)reloadEntireForm {
    [self eraseCells];
    [self loadFormConfiguration];
    [self.formTable reloadData];
    [self updateNavigationBar];
}

//this method exists so that a subclass can erase the cells of the formitems so that calling reloadData will actually reload the cell, which is useful in the case where we want to reload the cells from their original content like the cancel button on the profile
-(void)eraseCells {
    
    for (int i = 0; i<[self.formItems count]; i++) {
        CBFormItem *formItem = [self.formItems objectAtIndex:i];
        [formItem setCell:nil];
        
        //TODO: This may need to be accounted for
        /*
        //Clears the selected index of any picker form items
        if (formItem.type == DDVCPicker) {
            [formItem.data removeObjectForKey:@"selectedIndex"];
            [formItem.data removeObjectForKey:@"selectedString"];
        }*/
    }
}

-(void)dismissAllFields {
    for (int i = 0; i<[self.formItems count]; i++) {
        CBFormItem *formItem = [self.formItems objectAtIndex:i];
        [formItem dismiss];
    }
}

//Tells the formTable to update it's view properties. Mainly important for updating the height of the cells.
-(void)updates {
    [self.formTable beginUpdates];
    [self.formTable endUpdates];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
