//
//  ViewController.m
//  Public Radio
//
//  Created by Tran Ngoc Linh on 6/15/18.
//  Copyright © 2018 Tran Ngoc Linh. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@property (nonatomic,strong) MPMoviePlayerController* mc;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *ffff;
@property (weak, nonatomic) IBOutlet UITextField *uuuuuu;


@end

@implementation ViewController

NSArray *tableData;
NSArray *tableDataUrl;
NSMutableArray *radioName;
NSMutableArray *radioURL;

NSMutableArray *radioNameG;
NSMutableArray *radioURLG;
UITableView * tb;
UITextField* txt;


- (IBAction)onEditText:(UITextField *)sender {
     NSLog(@" ok @", @"ok");
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_uuuuuu resignFirstResponder];
    [self.view endEditing:YES];
}

- (IBAction)editingChanged:(UITextField *)sender {
    NSLog(@"%@", sender.text);
    txt = sender;
    
    if(sender.text.length < 2)
        return;
    
    NSMutableArray* radioName2 = [[NSMutableArray alloc] init];
    NSMutableArray* radioURL2 = [[NSMutableArray alloc] init];
    
    for(id line in radioNameG){
        NSString *l = (NSString*) line;
        if([l rangeOfString:sender.text options:NSCaseInsensitiveSearch].location != NSNotFound){
            [radioName2 addObject:l];
            NSInteger index = [radioNameG indexOfObject:l];
            [radioURL2 addObject:[radioURLG objectAtIndex:index]];
            
        }
        
    }
    
    radioName = radioName2;
    radioURL = radioURL2;
    
    [tb reloadData];
}

- (void) readData {
    radioName = [[NSMutableArray alloc] init];
    radioURL = [[NSMutableArray alloc] init];
    radioNameG = [[NSMutableArray alloc] init];
    radioURLG = [[NSMutableArray alloc] init];
    
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"1"
                                                     ofType:@"m3u8"];
    
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    NSString *new = [content stringByReplacingOccurrencesOfString: @"#EXTINF:0," withString:@""];
    //NSLog(@"%@", content);
    NSArray* allLinedStrings =  [new componentsSeparatedByCharactersInSet:
     [NSCharacterSet newlineCharacterSet]];
    
    int index =0;
    for( id line in allLinedStrings){
        if(index % 2 == 0)
            [radioName addObject:line];
        else
            [radioURL addObject:line];
        
        index ++;
        
    }
    [radioName removeLastObject];
    
    radioURLG = radioURL;
    radioNameG = radioName;
    
    NSLog(@" ok @", @"ok");    //NSLog(@"@", allLinedStrings[0]);
}


-(void) dismissKeyboard{
    [_uuuuuu resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


- (void)viewDidLoad {
    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback    error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    
    self.view.userInteractionEnabled = YES;
    _uuuuuu.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    
    [self readData];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
   
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tb = tableView;
    tableView.userInteractionEnabled = YES;
    return [radioName count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
    }
    cell.userInteractionEnabled = YES;
    //cell.backgroundColor = [UIColor colorWithDisplayP3Red:0.0 green:1.0 blue:0.0 alpha:1.0];

    cell.textLabel.text = [radioName objectAtIndex:indexPath.row];
    return cell;
}	

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", [radioName objectAtIndex:indexPath.row]);
    NSLog(@"%@", [radioURL objectAtIndex:indexPath.row]);
    
    NSString *urlString = [[radioURL objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString: @"," withString:@""];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    @try {
        MPMoviePlayerController *controller = [[MPMoviePlayerController alloc]
                                                  initWithContentURL:url];
        [self.mc stop];
        self.mc = controller; //Super important
        controller.view.frame = self.view.bounds; //Set the size
        
        CGRect frame = self.view.bounds;
        frame.origin.y = frame.size.height - 43;
        frame.size.height = 43;
        controller.view.frame = frame;
        
        controller.view.backgroundColor = [UIColor colorWithDisplayP3Red:0.7 green:0.7 blue:0.7 alpha:0.3];
        
        [self.view addSubview:controller.view]; //Show the view
        [controller play]; //Start playing a = [test characterAtIndex:index];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }

    
   //tableView.backgroundColor = [UIColor colorWithDisplayP3Red:0.0 green:0.0 blue:0.0 alpha:1.0];
    
}

@end
