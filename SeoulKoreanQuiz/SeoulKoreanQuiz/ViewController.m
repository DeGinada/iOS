//
//  ViewController.m
//  SeoulKoreanQuiz
//
//  Created by DeGi on 2017. 6. 23..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "ViewController.h"
#import "GameViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar.topItem setTitle:@""];
    
//    [self.navigationController.navigationBar setHidden:YES];
}


- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
    [self.navigationController.navigationBar.topItem setTitle:@""];
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"Game"]) {
        GameViewController* vcGame = [segue destinationViewController];
        vcGame.nType = 0;
        vcGame.strNowQuizDate = @"";
    }
    
}


@end
