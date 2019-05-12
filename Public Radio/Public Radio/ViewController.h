//
//  ViewController.h
//  Public Radio
//
//  Created by Tran Ngoc Linh on 6/15/18.
//  Copyright © 2018 Tran Ngoc Linh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController :UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *uiTextField;

@end

