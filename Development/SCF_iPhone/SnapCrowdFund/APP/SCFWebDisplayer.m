//
//  SCFWebDisplayer.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/24/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFWebDisplayer.h"
#import "StringConstants.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"

//#import "SBJSON.h"

@interface SCFWebDisplayer ()

@end

@implementation SCFWebDisplayer

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
        [notifyCenter addObserver:self selector:@selector(addBankAccount:) name:SCFADDBANKACCOUNTNOTIFICATION object:nil];
        [notifyCenter addObserver:self selector:@selector(addCreditCard:) name:SCFADDCREDITCARDNOTIFICATION object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [self enableCustomClassForProtocol:YES];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customizeNavigationBar];
    
    if (self.htmlString) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.htmlString]]];
    }
}

#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}

- (void)dealloc{
    
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    [notifyCenter removeObserver:self name:SCFADDBANKACCOUNTNOTIFICATION object:nil];
    [notifyCenter removeObserver:self name:SCFADDCREDITCARDNOTIFICATION object:nil];
    
    [self enableCustomClassForProtocol:NO];
    [self.webView setDelegate:nil];
    [self setWebView:nil];
}

#pragma mark - Private Methods

-(void)customizeNavigationBar
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 29)];
    //[backButton setBackgroundImage:[UIImage imageNamed:@"back button normal.png"] forState:UIControlStateNormal];
    //[backButton setBackgroundImage:[UIImage imageNamed:@"back button pressed.png"] forState:UIControlStateHighlighted];
    [backButton setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton setTitleColor:[UIColor colorWithRed:117/255.0 green:126/255.0 blue:134/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
    [backButton.titleLabel setShadowColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [backButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    //[backButton setContentEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 29)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
    [titleLabel setTextColor:[UIColor colorWithRed:61/255.0 green:66/255.0 blue:70/255.0 alpha:1.0f]];
    [titleLabel setShadowColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [titleLabel setShadowOffset:CGSizeMake(0, 1)];
//    titleLabel.text = self.title;
    titleLabel.minimumFontSize=15.0;
    titleLabel.numberOfLines = 1;
    
    switch (_screenType) {
        case eSCFWebDisplayerAddCreditCard:
            titleLabel.text = @"Add Credit Card";
            break;
            
        case eSCFWebDisplayerAddBankAccount:
            titleLabel.text = @"Add Bank Account";
            break;
            
        default:
            break;
    }
    
    self.navigationItem.titleView = titleLabel;
}

- (void)enableCustomClassForProtocol:(BOOL)iShouldenable
{
    if (iShouldenable) {
        [NSURLProtocol registerClass:NSClassFromString(@"SCFUrlProtocol")];

    }
    else{
        [NSURLProtocol unregisterClass:NSClassFromString(@"SCFUrlProtocol")];
    }
}

//#pragma mark - UIWebViewDelegates
//
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    // "callback:saveBankAccount"
//    NSLog(@"Url : %@",request.URL);
//    NSLog(@"Body : %@",[request HTTPBody]);
//    return YES;
//}
//
//
//- (void)webViewDidStartLoad:(UIWebView *)webView {
//    NSLog(@"page is loading");
//}
//
//-(void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSLog(@"finished loading");
//}

#pragma mark - Button Actions

- (void)backButtonAction:(id)sender
{
    [self.sidePanelController showLeftPanelAnimated:YES];
}

#pragma mark - Helper Methods

- (BOOL)isCreditCardValid:(NSDictionary *)iResponse
{
    BOOL retVal = NO;
    
    NSNumber *statusCode = [iResponse objectForKey:kAPIResponseStatusCodeKey];
    if (statusCode && [statusCode isKindOfClass:[NSNumber class]]) {
        
        NSString *the_msgString = nil;
        
        switch (statusCode.intValue) {
            case 201:
            {
                // response.data.uri == uri of the card resource, submit to your server
                break;
            }
                
            case 404:
            {
                // your marketplace URI is incorrect
                the_msgString = @"Your market palce URL is incorrect";
                break;
            }
                
                // missing/malformed data - check response.error for details
            case 400:
            case 403:
                
                // we couldn't authorize the buyer's credit card - check response.error for details
            case 402:
            {
                NSDictionary *errorDict = [iResponse objectForKey:kAPIResponseErrorKey];
                if ([errorDict isKindOfClass:[NSDictionary class]]) {
                    the_msgString = [[errorDict allValues] objectAtIndex:0];
                }
                break;
            }
                
                // we did something unexpected - check response.error for details
            default:
            {
                NSDictionary *errorDict = [iResponse objectForKey:kAPIResponseErrorKey];
                if ([errorDict isKindOfClass:[NSDictionary class]]) {
                    the_msgString = [[errorDict allValues] objectAtIndex:0];
                }
                break;
            }
        }
        
        if (statusCode.intValue != 201) {
            
            if (the_msgString == nil) {
                the_msgString = @"Error";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"__ProjectName__", @"")
                                                            message:the_msgString
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                  otherButtonTitles:nil, nil];
            [alert show];
            retVal = NO;
        }
        else
            retVal = YES;
    }
    return retVal;
}

#pragma mark - NSNotification

- (void)addBankAccount:(NSNotification *)iNotify
{
    // Converting the request data to json string.
    NSString  *rspString = [[NSString alloc] initWithData:[iNotify object] encoding:NSUTF8StringEncoding];
    rspString = [rspString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    rspString = [rspString stringByReplacingOccurrencesOfString:@"=" withString:@"\":\""];
    rspString = [rspString stringByReplacingOccurrencesOfString:@"&" withString:@"\",\""];
    
    NSDictionary *the_receivedData = [NSJSONSerialization JSONObjectWithData:[rspString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    if ([self isCreditCardValid:the_receivedData] == NO) {
        return;
    }
    
    PFObject *bankAccount = [PFObject objectWithClassName:@"BankAccount"];
    [bankAccount setObject:[the_receivedData objectForKey:@"id"] forKey:@"accountId"];
    [bankAccount setObject:[the_receivedData objectForKey:@"credits_uri"] forKey:@"credis_uri"];
    [bankAccount setObject:[the_receivedData objectForKey:@"uri"] forKey:@"uri"];
    BOOL saveStatus = [bankAccount save];
    
    
    if (saveStatus == NO) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"SCF"
                                                             message:@"Unable to save your Bank Account Details"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil, nil];
        [errorAlert show];
    }
    
}

- (void)addCreditCard:(NSNotification *)iNotify
{
    // Converting the request data to json string.
    NSString  *rspString = [[NSString alloc] initWithData:[iNotify object] encoding:NSUTF8StringEncoding];    
    rspString = [rspString stringByReplacingOccurrencesOfString:@"=" withString:@"\":\""];
    rspString = [rspString stringByReplacingOccurrencesOfString:@"&" withString:@"\",\""];

    NSDictionary *the_receivedData = [NSJSONSerialization JSONObjectWithData:[rspString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    if ([self isCreditCardValid:the_receivedData] == NO) {
        return;
    }
        
    NSDictionary *the_postData = [the_receivedData objectForKey:kAPIResponseDataKey];
    
    [PFCloud callFunctionInBackground:kParseAPIAddCreditCard
                       withParameters:the_postData
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        // result is @"Hello world!"
                                        NSLog(@"Result : %@",result);
                                        
                                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"__ProjectName__", @"")
                                                                                         message:@"Your Bank Account details have been successfully updated" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
                                        [alert show];
                                    }
                                    else
                                    {
                                        NSLog(@"error : %@",error.description);
                                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"__ProjectName__", @"")
                                                                                         message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
                                        [alert show];
                                    }
                                }];
}

@end
