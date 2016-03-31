//
//  AddSoundTagsViewController.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-07-13.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "AddSoundTagsViewController.h"
#import "AppDelegate.h"
#import "GeneralUtility.h"
#import "CategorySelectionViewController.h"
#import "DubSoundCreator.h"

@interface AddSoundTagsViewController ()

@end


@implementation AddSoundTagsViewController{
    TITokenFieldView * _tokenFieldView;
    UITextView * _messageView;
    
    CGFloat _keyboardHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"UIVIEW Frame is %f %f %f %f", _theUIView.frame.origin.x, _theUIView.frame.origin.y, _theUIView.frame.size.width, _theUIView.frame.size.height);
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
      _tokenFieldView = [[TITokenFieldView alloc] initWithFrame: CGRectOffset( _theUIView.frame, 0, _theUIView.frame.size.height+10 )];
   // _tokenFieldView.
      [self.view addSubview:_tokenFieldView];
    
    [_tokenFieldView.tokenField setDelegate:self];
    [_tokenFieldView setShouldSearchInBackground:NO];
    [_tokenFieldView setShouldSortResults:NO];
    
    [_tokenFieldView.tokenField addTarget:self action:@selector(tokenFieldFrameDidChange:) forControlEvents:TITokenFieldControlEventFrameDidChange];
    
    [_tokenFieldView.tokenField setTokenizingCharacters:[NSCharacterSet characterSetWithCharactersInString:@",;."]]; // Default is a comma
    [_tokenFieldView.tokenField setPromptText:@"Tags:"];
    [_tokenFieldView.tokenField setPlaceholder:@"Type a tag and hit return button."];
    
    [_tokenFieldView.tokenField addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidBegin];
    
    [_tokenFieldView.tokenField addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // You can call this on either the view on the field.
    // They both do the same thing.
    [_tokenFieldView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
   
}

- (void)resizeViews {
    int tabBarOffset = self.tabBarController == nil ?  0 : self.tabBarController.tabBar.frame.size.height;
    [_tokenFieldView setFrame:((CGRect){_tokenFieldView.frame.origin, {self.view.bounds.size.width, self.view.bounds.size.height + tabBarOffset - _keyboardHeight}})];
    [_messageView setFrame:_tokenFieldView.contentView.bounds];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardHeight = keyboardRect.size.height > keyboardRect.size.width ? keyboardRect.size.width : keyboardRect.size.height;
    [self resizeViews];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _keyboardHeight = 0;
    [self resizeViews];
}

- (BOOL)tokenField:(TITokenField *)tokenField willRemoveToken:(TIToken *)token {
    
    return YES;
}

- (void)tokenField:(TITokenField *)tokenField didAddToken:(TIToken *)token
{

}

- (BOOL)tokenField:(TITokenField *)tokenField willAddToken:(TIToken *)token
{
    //NSLog(@"willAddToken %@", token.title);
    
    if([token.title length]<3)
    {
        _warningMsg.hidden = NO;
        _warningMsg.text = @"Please enter at least 3 characters for a tag.";
        return NO;
    }
    
    _warningMsg.hidden = YES;
    return YES;
}

- (void)tokenFieldChangedEditing:(TITokenField *)tokenField {
    // There's some kind of annoying bug where UITextFieldViewModeWhile/UnlessEditing doesn't do anything.
    //NSLog(@"tokenFieldChangedEditing");
    [tokenField setRightViewMode:(tokenField.editing ? UITextFieldViewModeAlways : UITextFieldViewModeNever)];
}

- (void)tokenFieldFrameDidChange:(TITokenField *)tokenField {
   // [self textViewDidChange:_messageView];
    //NSLog(@"tokenFieldFrameDidChange");
}

#pragma mark - Custom Search

- (BOOL)tokenField:(TITokenField *)field shouldUseCustomSearchForSearchString:(NSString *)searchString
{
    return ([searchString isEqualToString:@"contributors"]);
}

- (void)tokenField:(TITokenField *)field performCustomSearchForSearchString:(NSString *)searchString withCompletionHandler:(void (^)(NSArray *))completionHandler
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Send a Github API request to retrieve the Contributors of this project.
        //Using a syncrhonous request in a Background Thread to not over-complexify the demo project
        NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.github.com/repos/thermogl/TITokenField/contributors"]];
        NSURLResponse * response = nil;
        NSError * error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
        
        NSMutableArray *results = [[NSMutableArray alloc] init];
        
        if (error == nil) {
            NSError *errorJSON;
            NSArray *contributors = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJSON];
            
            for (NSDictionary *user in contributors) {
                [results addObject:[user objectForKey:@"login"]];
            }
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            //Finally call the completionHandler with the results array!
            completionHandler(results);
        });
    });
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)cancelClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)nextClicked:(id)sender {
    if([_tokenFieldView.tokenField.tokenObjects count]<3)
    {
        _warningMsg.hidden = NO;
        _warningMsg.text = @"Please add at least 3 tags for your sound.";
        return;
    }
    
    //NSLog(@"Tags are %@", _tokenFieldView.tokenField.tokenObjects);
    
    [DubSoundCreator setTags: _tokenFieldView.tokenField.tokenObjects];
    
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    CategorySelectionViewController *controller = [delegate.navi.storyboard instantiateViewControllerWithIdentifier:@"CategorySelectionViewController"];
    
    // [controller setConnectedDubUser: connectedActivity.fromUserRef];
    controller.hidesBottomBarWhenPushed = YES;
    controller.mode = SOUND_CATEGORY_SELECTION_MODE;
    //   controller.exploreResultViewController = self;
    
    [GeneralUtility pushViewController: controller animated: YES];
    
    
}

@end
