//
//  SCSignUpViewController.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCSignUpViewController.h"
#import "Reachability.h"
#import "SCFUtility.h"
#import "SCAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "StringConstants.h"
#import "UIAlertView+MKNetworkKitAdditions.h"

#import "SCFSocialEngine.h"
#import "SCFSocialEngineFactory.h"

@interface SCSignUpViewController ()

@end

@implementation SCSignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        signupUser = [PFUser user];

    }
    return self;
}

#pragma mark - View Lifecycle -

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"signup_BG.png"]];
    
    self.addPhotoButton.imageView.layer.cornerRadius = 8.0;
    self.facebookButton.tag = eSCSocialEngineFacebook;
    self.twitterButton.tag = eSCSocialEngineTwitter;
    
    [self customizeTheNavigationBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    self.addPhotoButton = nil;
    [self setFacebookButton:nil];
    [self setTwitterButton:nil];
    [super viewDidUnload];
}

#pragma mark - Private Methods -

- (void)customizeTheNavigationBar
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 60, 30)];
    [leftButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [leftButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"signin_unpress.png"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"signin_press.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitleColor:[UIColor colorWithRed:117/255.0 green:126/255.0 blue:134/255.0 alpha:1.0] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0];
    leftButton.titleLabel.shadowOffset = CGSizeMake(0, 0.5);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    // Configuring the Title View
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"Sign Up";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
    titleLabel.shadowOffset = CGSizeMake(0, 1);
    titleLabel.shadowColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self.navigationItem.titleView = titleLabel;

    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 60, 30)];
    [rightButton setTitle:@"Done" forState:UIControlStateNormal];
    [rightButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"signin_unpress.png"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"signin_press.png"] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:[UIColor colorWithRed:117/255.0 green:126/255.0 blue:134/255.0 alpha:1.0] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0];
    rightButton.titleLabel.shadowOffset = CGSizeMake(0, 0.5);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (BOOL)isInputFieldsValid
{
    BOOL retVal = YES;
    
    NSString *the_email = self.emailTextField.text;
    NSString *the_firstName = self.firstameField.text;
    NSString *the_lastName = self.lastNameField.text;
    NSString *the_password = self.passwordField.text;
    
    if ([SCFUtility isValidEmailAddress:the_email] == FALSE)
    {
        // Text was empty or only whitespace.
        UIAlertView *invalidMailAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"__ProjectName__", @"")
                                                        message:NSLocalizedString(@"Please enter a valid email.", @"")
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"")  otherButtonTitles:nil, nil];
        [invalidMailAlert show];
        return NO;
    }
    
    /*to check whether string contains only white charachters*/
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedfirstName = [the_firstName stringByTrimmingCharactersInSet:whitespace];
    if ([trimmedfirstName length] == 0)
    {
        // Text was empty or only whitespace.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"__ProjectName__", @"")
                                                        message:NSLocalizedString(@"First Name cannot be blank.", @"")
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"")  otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    /*to check whether string contains only white charachters*/
    NSString *trimmedlastName = [the_lastName stringByTrimmingCharactersInSet:whitespace];
    if ([trimmedlastName length] == 0)
    {
        // Text was empty or only whitespace.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"__ProjectName__", @"")
                                                        message:NSLocalizedString(@"Last Name cannot be blank.", @"")
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"")  otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    /*to check whether string contains only white charachters*/
    NSString *trimmedpassword = [the_password stringByTrimmingCharactersInSet:whitespace];
    if ([trimmedpassword length] == 0)
    {
        // Text was empty or only whitespace.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"__ProjectName__", @"")
                                                        message:NSLocalizedString(@"Password cannot be blank.", @"")
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"")  otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    return retVal;
}

#pragma mark - Button Actions -

- (void)backButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)signUpButtonTapped:(UIButton *)iButton
{
    [self.view endEditing:YES];
    
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]==NotReachable)
    {
        [(SCAppDelegate *)[[UIApplication sharedApplication] delegate] showAlertWithTitle:NSLocalizedString(@"__ProjectName__", @"") message:NSLocalizedString(@"No Internet Connection!", @"")];
        return;
    }
    
    if ([self isInputFieldsValid] == NO) {
        return;
    }
    
    
    signupUser.username = self.emailTextField.text;
    signupUser.password = self.passwordField.text;
    signupUser.email = self.emailTextField.text;

    
    
    [signupUser setObject:self.firstameField.text forKey:kUserFirstName];
    [signupUser setObject:self.lastNameField.text forKey:kUserLastName];
//    [signupUser setObject:@"415-392-0202" forKey:@"phone"];
    
    __block id blockSelf = self;

    if (mUserImageFile && mUserImageFile.isDirty) {
        NSLog(@"Dirty while image uploading");
        [mUserImageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [SCFUtility stopActivityIndicatorFromView:self.view];
            
            if (error) {
                [(SCAppDelegate *)[[UIApplication sharedApplication] delegate] showAlertWithTitle:@"__ProjectName__" message:[[error userInfo] objectForKey:@"error"]];
            }
            else
                [(UIViewController *) blockSelf dismissModalViewControllerAnimated:NO];
            blockSelf = nil;
        }];
        return;
    }
    
    
    [SCFUtility startActivityIndicatorOnView:self.view withText:@"Loading..." BlockUI:YES];
    [signupUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [SCFUtility stopActivityIndicatorFromView:self.view];
        
        if (error) {
            [(SCAppDelegate *)[[UIApplication sharedApplication] delegate] showAlertWithTitle:@"__ProjectName__" message:[[error userInfo] objectForKey:@"error"]];
        }
        else
            [(UIViewController *) blockSelf dismissModalViewControllerAnimated:NO];
        blockSelf = nil;
    }];

}

- (IBAction)takePhotoButtonClick:(id)sender
{
    [self.view endEditing:YES];
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Add Photo", @"")
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:NSLocalizedString(@"Select from Library", @""),NSLocalizedString(@"Take a New Photo", @"") , nil];
    
    actionSheet.actionSheetStyle  = UIBarStyleDefault;
    
    [actionSheet showInView:[self view]];
}

- (IBAction)facebookButtonAction:(UIButton *)sender {
    [self SocialNetworkIconTapped:sender.tag];
}

- (IBAction)twitterButtonAction:(UIButton *)sender {
    [self SocialNetworkIconTapped:sender.tag];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
	
    [picker dismissViewControllerAnimated:YES completion:nil];
    
	if(image)
	{
        [self.addPhotoButton setImage:image forState:UIControlStateNormal];
        [self.addPhotoButton setImage:image forState:UIControlStateSelected];
        [self.addPhotoButton setImage:image forState:UIControlStateHighlighted];
        
        [mUserImageFile cancel];
        mUserImageFile = [PFFile fileWithName:@"userimage.jpg" data:UIImageJPEGRepresentation(image, 0.8)];
        [signupUser setObject:mUserImageFile forKey:kUserPic];
        [mUserImageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(@"Completed uploading of Image , error : %@",error);
        }];
	}
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate 

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	if(buttonIndex == eSCFPhotoCaptureTypeCancel)
		return;
	
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
	imagePickerController.allowsEditing	   = YES;
	imagePickerController.delegate			= self;
	
	if(buttonIndex == eSCFPhotoCaptureTypeLibrary)
	{
		imagePickerController.sourceType  = UIImagePickerControllerSourceTypePhotoLibrary;
		
	}
	else if(buttonIndex == eSCFPhotoCaptureTypeCamera)
	{
        BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if (hasCamera)
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        else
            imagePickerController.sourceType  = UIImagePickerControllerSourceTypePhotoLibrary;
	}
    
	[self presentViewController:imagePickerController animated:YES completion:nil];
}


#pragma mark - Social Network

- (void)SocialNetworkIconTapped:(WISocialNetworkType)iSocialType
{
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]==NotReachable)
    {
        [(SCAppDelegate *)[[UIApplication sharedApplication] delegate] showAlertWithTitle:NSLocalizedString(@"__ProjectName__", @"") message:NSLocalizedString(@"No Internet Connection!", @"")];
        return;
    }

    [SCFUtility startActivityIndicatorOnView:self.view withText:@"Loading!" BlockUI:YES];
    
    
    SCFSocialEngine *socialEngine = [[SCFSocialEngineFactory sharedFactory] socialEngineForType:iSocialType];
    [socialEngine disconnect:^(NSDictionary *responseInfo) {
        
        if(socialEngine.type == eSCSocialEngineFacebook)
        {
            [(SCFFacebookEngine *) socialEngine setPermissionRequired:eFacebookPermissionRead];
        }
        if (nil != socialEngine)
        {
            /** commented */
            //        [WIUtility startActivityIndicatorOnView:self.view withText:@"Please Wait.." BlockUI:YES];
            BOOL connected = [socialEngine connected];
            
            if (connected)
            {
                __weak SCSignUpViewController *bSelf = self;
                if(socialEngine.userInfo.accessToken == nil && socialEngine.type == eSCSocialEngineTwitter)
                {
                    [(WITwitterEngine *)socialEngine reverseOAuthWithACAccount:nil completionhandler:^(NSDictionary *responseInfo) {
                        if ([responseInfo objectForKey:SCFSocialEngineErrorKey] != nil)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^
                                           {
                                               [SCFUtility stopActivityIndicatorFromView:self.view];
                                               return ;
                                           });
                            return ;
                        }
                        
                        [socialEngine getProfile:^(NSDictionary *responseInfo)
                         {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 //                             [WIUtility stopActivityIndicatorFromView:self.view];
                                 [bSelf handleProfileResponse:responseInfo ForSocialNetwork:iSocialType];
                             });
                         }];
                    }];
                    
                }
                else if (socialEngine.userInfo.accessToken == nil)
                {
                    [socialEngine getProfile:^(NSDictionary *responseInfo)
                     {
                         dispatch_async(dispatch_get_main_queue(), ^
                                        {
                                            [bSelf handleProfileResponse:responseInfo ForSocialNetwork:iSocialType];
                                        });
                     }];
                }
                
            }
            else if([socialEngine canConnect])
            {
                [socialEngine connectWithBaseViewController:self completionHandler:^(NSDictionary *reponseInfo)
                 {
                     if (nil == [reponseInfo objectForKey:SCFSocialEngineErrorKey])
                     {
                         __weak SCSignUpViewController *bSelf = self;
                         
                         if(eSCSocialEngineGoogle != [socialEngine type])
                         {
                             [socialEngine getProfile:^(NSDictionary *responseInfo)
                              {
                                  dispatch_async(dispatch_get_main_queue(), ^
                                                 {
                                                     [bSelf handleProfileResponse:responseInfo ForSocialNetwork:iSocialType];
                                                 });
                              }];
                         }
                         else
                         {
                             dispatch_async(dispatch_get_main_queue(), ^
                                            {
                                                [bSelf handleProfileResponse:reponseInfo ForSocialNetwork:iSocialType];
                                            });
                         }
                         
                     }
                     else
                     {
                         [SCFUtility stopActivityIndicatorFromView:self.view];
                         [self handleSocialNetworkError:[responseInfo objectForKey:SCFSocialEngineErrorKey] forSocialType:iSocialType];
                     }
                 }];
            }
            else
            {
                [UIAlertView alertViewWithTitle:NSLocalizedString(@"Wiink", nil)
                                        message:NSLocalizedString(@"No twitter account present. Please login to twitter from system settings.", @"")
                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                              otherButtonTitles:nil
                                      onDismiss:^(int buttonIndex) {
                                          [self.navigationController popViewControllerAnimated:YES];
                                      } onCancel:^{
                                          [self.navigationController popViewControllerAnimated:YES];
                                      }];
            }
        }
        else
        {
            [UIAlertView alertViewWithTitle:NSLocalizedString(@"Not Supported", nil) message:NSLocalizedString(@"Application currently doesn't support the selected Social Network", nil)];
            
        }}];
}

- (void)handleProfileResponse:(NSDictionary *)inResponse ForSocialNetwork:(WISocialNetworkType) SocialNetworkType
{
    /** changed */
    //    [WIUtility stopActivityIndicatorFromView:self.view];
    
    
    
    if([inResponse objectForKey:SCFSocialEngineErrorKey] != nil)
    {
        [self handleSocialNetworkError:[inResponse objectForKey:SCFSocialEngineErrorKey] forSocialType:SocialNetworkType];
        return;
    }
    
    if (eHTTPResoponseOK == [[inResponse objectForKey:SCFSocialEngineStatusCodeKey] intValue])
    {
        
//        BOOL animate=YES;
//        if(SocialNetworkType == eGoogle || SocialNetworkType == eWeibo)
//            animate=NO;

        [SCFUtility stopActivityIndicatorFromView:[[UIApplication sharedApplication] keyWindow]];
        NSLog(@"FB Success");
        
        [self populateDataWithSocialUser:[[SCFSocialEngineFactory sharedFactory] socialEngineForType:SocialNetworkType].userInfo];
    }
    else
    {

    }
}

- (void)handleSocialNetworkError:(NSError *)iError forSocialType:(WISocialNetworkType)iSocialType
{
    if(iError)
    {
        [SCFUtility stopActivityIndicatorFromView:self.view];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Wiink", @"")
                                                        message:[iError localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)populateDataWithSocialUser:(SCFSocialUser *)iSocialUser
{
    self.emailTextField.text = iSocialUser.email;
    self.firstameField.text = iSocialUser.firstname;
    self.lastNameField.text  = iSocialUser.lastname;
    
    //iSocialUser.profileImageUrl
}


- (void)dealloc
{
    NSLog(@"Dealloc of sign up page");
}
@end
