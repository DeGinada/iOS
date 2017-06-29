//
//  QuizInfoViewController.m
//  SeoulKoreanQuiz
//
//  Created by Sora Yeo on 2017. 6. 27..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "QuizInfoViewController.h"
#import "GameViewController.h"

@interface QuizInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (retain, readwrite) NSMutableArray* arQuizInfo;
@property (retain, readwrite) NSString* strQuizDate;

@property IBOutlet UITableView* tableView;


@end

@implementation QuizInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    UIView* viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0.5)];
//    [viewHeader setBackgroundColor:[UIColor lightGrayColor]];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = [[UIView alloc] init];
    
    
    // 기존에 저장되어 있는 퀴즈 정보 가져오기
    NSArray* arSaved = [[NSUserDefaults standardUserDefaults] objectForKey:@"QuizListInfo"];
    if (arSaved.count > 0) {
        self.arQuizInfo = [[NSMutableArray alloc] initWithArray:arSaved];
    } else {
        self.arQuizInfo = [[NSMutableArray alloc] init];
    }
    
    
    NSLog(@"%@", self.arQuizInfo);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"CheckQuiz"]) {
        GameViewController* vcGame = [segue destinationViewController];
        vcGame.isCheckQuiz = YES;
        vcGame.strNowQuizDate = self.strQuizDate;
    }
    
}




- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = false;
    
//    [self.navigationController.navigationBar setHidden:NO];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
//    
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init]
//                                                 forBarPosition:UIBarPositionAny
//                                                     barMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}


- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    // 차이가 뭘까? viewWillAppear에서 바꾸면 안바뀌는데 여기서는 정상적으로 바뀜
    [self.navigationController.navigationBar.backItem setTitle:@"Main"];
    [self.navigationController.navigationBar.topItem setTitle:@""];
}
//
//- (void) viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    
//    self.navigationController.navigationBar.translucent = true;
//}


#pragma mark - TABLE_VIEW

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.arQuizInfo.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    
    // 역순으로 보여줄때 -> self.arQuizInfo.count-1-indexPath.row
    NSDictionary* dicInfo = [self.arQuizInfo objectAtIndex:(indexPath.row)];
    
    NSString* strCorrect = @"";
    if ([[dicInfo objectForKey:@"UserAnswer"] isEqualToString:[dicInfo objectForKey:@"Correct"]]) {
        strCorrect = @"O";
    } else {
        strCorrect = @"X";
    }
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"\t%@\t\tQ.%@\t\t[ %@ ]", [dicInfo objectForKey:@"QuizDate"], [dicInfo objectForKey:@"QuizNum"], strCorrect];
    
    return cell;
}


// cell 버튼 선택시
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary* dicInfo = [self.arQuizInfo objectAtIndex:(indexPath.row)];
    self.strQuizDate = [dicInfo objectForKey:@"QuizDate"];
    
    return indexPath;
}


@end
