//
//  SCSignUpViewController.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    eSCFPhotoCaptureTypeLibrary,
    eSCFPhotoCaptureTypeCamera,
    eSCFPhotoCaptureTypeCancel,
} SCFPhotoCaptureType;

@interface SCSignUpViewController : UIViewController<UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
{
//    PFUser      *signupUser;
    PFFile      *mUserImageFile;
    BOOL        _userAddedImage;
}

@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *firstameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;



- (IBAction)takePhotoButtonClick:(id)sender;
- (IBAction)facebookButtonAction:(id)sender;
- (IBAction)twitterButtonAction:(id)sender;

@end
