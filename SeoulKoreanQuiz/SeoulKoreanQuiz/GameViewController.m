//
//  GameViewController.m
//  SeoulKoreanQuiz
//
//  Created by DeGi on 2017. 6. 23..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "GameViewController.h"

#define API_URL         @"http://openAPI.seoul.go.kr:8088/sample/xml/KoreanAnswerInfo/1/5/"

@interface GameViewController ()

@property (nonatomic, readwrite) NSInteger nQuizYear;
@property (nonatomic, readwrite) NSInteger nQuizMonth;
@property (nonatomic, readwrite) NSInteger nQuizDay;

@property IBOutlet UILabel* lbQuizDate;
@property IBOutlet UILabel* lbQuiz;
@property IBOutlet UIButton* btnAnswer1;
@property IBOutlet UIButton* btnAnswer2;
@property IBOutlet UIButton* btnAnswer3;
@property IBOutlet UIButton* btnAnswer4;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.btnAnswer1.layer.cornerRadius = 8;
    self.btnAnswer2.layer.cornerRadius = 8;
    self.btnAnswer3.layer.cornerRadius = 8;
    self.btnAnswer4.layer.cornerRadius = 8;
    
    
    // 최근에 푼 문제 날짜 정보 가져오기
    NSString* strCurrent = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentDateKey"];
    if (strCurrent.length == 0) {
        self.nQuizYear = 2012;
        self.nQuizMonth = 6;
        self.nQuizDay = 25;
        
        strCurrent = [NSString stringWithFormat:@"%ld%02ld%02ld", self.nQuizYear, self.nQuizMonth, self.nQuizDay];
        [[NSUserDefaults standardUserDefaults] setObject:strCurrent forKey:@"CurrentDateKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        self.nQuizYear = [[strCurrent substringWithRange:NSMakeRange(0, 4)] integerValue];
        self.nQuizMonth = [[strCurrent substringWithRange:NSMakeRange(4, 2)] integerValue];
        self.nQuizDay = [[strCurrent substringWithRange:NSMakeRange(6, 2)] integerValue];
    }
    
    
    // 퀴즈 정보 가져오기
    [self placeGetRequest:strCurrent WithHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
        parser.delegate = self;
        if ([parser parse])  {
            NSLog(@"%@", dicQuizInfo);
            
            if ([[dicQuizInfo objectForKey:@"Result"] isEqualToString:@"INFO-000"]) {
                [self.lbQuizDate setText:[NSString stringWithFormat:@"%ld.%02ld.%02ld\tQ.%@", self.nQuizYear, self.nQuizMonth, self.nQuizDay, [dicQuizInfo objectForKey:@"QuizNum"]]];
                [self.lbQuiz setText:[dicQuizInfo objectForKey:@"Quiz"]];
                [self.btnAnswer1 setTitle:[[[dicQuizInfo objectForKey:@"Answers"] objectAtIndex:0] objectForKey:@"Answer"] forState:UIControlStateNormal];
                [self.btnAnswer2 setTitle:[[[dicQuizInfo objectForKey:@"Answers"] objectAtIndex:1] objectForKey:@"Answer"] forState:UIControlStateNormal];
                [self.btnAnswer3 setTitle:[[[dicQuizInfo objectForKey:@"Answers"] objectAtIndex:2] objectForKey:@"Answer"] forState:UIControlStateNormal];
                [self.btnAnswer4 setTitle:[[[dicQuizInfo objectForKey:@"Answers"] objectAtIndex:3] objectForKey:@"Answer"] forState:UIControlStateNormal];
            } else {
                
                // 네트워크 재요청
                // 문제가 없는 경우는 문제값 바꿔서 재요청
            }
            
            
        }
        
    }];
    
    
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


- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}


- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // 차이가 뭘까? viewWillAppear에서 바꾸면 안바뀌는데 여기서는 정상적으로 바뀜
    [self.navigationController.navigationBar.backItem setTitle:@"Main"];
}



#pragma mark - QUIZ


- (IBAction) checkAnswer:(id)sender {
    
}


#pragma mark - REQUEST

- (void) placeGetRequest:(NSString*)quizeNum WithHandler:(void (^) (NSData* data, NSURLResponse* response, NSError* error))ourBlock {
    
    NSString* strUrl = [NSString stringWithFormat:@"%@%@", API_URL, quizeNum];
    
    NSURL* url = [NSURL URLWithString:strUrl];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:ourBlock] resume];
}



#pragma mark - XML_PARSER

- (void) parserDidStartDocument:(NSXMLParser *)parser {
    
    // 해석중인 태그 초기화
    nowTagStr = [NSString stringWithFormat:@""];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    if ([elementName isEqualToString:@"KoreanAnswerInfo"]) {
        arQuiz = [[NSMutableArray alloc] init];
    } else if ([elementName isEqualToString:@"CODE"]) {
        nowTagStr = [NSString stringWithString:elementName];
        dicQuizInfo = [[NSMutableDictionary alloc] init];
    } else if ([elementName isEqualToString:@"row"]) {
        nowTagStr = [NSString stringWithString:elementName];
        dicRowData = [[NSMutableDictionary alloc] init];
    } else if ([elementName isEqualToString:@"Q_NAME"]) {
        nowTagStr = [NSString stringWithString:elementName];
    } else if ([elementName isEqualToString:@"Q_SEQ"]) {
        nowTagStr = [NSString stringWithString:elementName];
    } else if ([elementName isEqualToString:@"Q_OPEN"]) {
        nowTagStr = [NSString stringWithString:elementName];
    } else if ([elementName isEqualToString:@"A_SEQ"]) {
        nowTagStr = [NSString stringWithString:elementName];
    } else if ([elementName isEqualToString:@"A_NAME"]) {
        nowTagStr = [NSString stringWithString:elementName];
    } else if ([elementName isEqualToString:@"A_CORRECT"]) {
        nowTagStr = [NSString stringWithString:elementName];
    }
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([nowTagStr isEqualToString:@"CODE"]) {
        [dicQuizInfo setObject:string forKey:@"Result"];
    } else if ([nowTagStr isEqualToString:@"Q_NAME"]) {
        [dicQuizInfo setObject:string forKey:@"Quiz"];
    } else if ([nowTagStr isEqualToString:@"Q_SEQ"]) {
        [dicQuizInfo setObject:string forKey:@"QuizNum"];
    } else if ([nowTagStr isEqualToString:@"Q_OPEN"]) {
        [dicQuizInfo setObject:string forKey:@"QuizDate"];
    } else if ([nowTagStr isEqualToString:@"A_SEQ"]) {
        [dicRowData setObject:string forKey:@"AnswerNum"];
    } else if ([nowTagStr isEqualToString:@"A_NAME"]) {
        [dicRowData setObject:string forKey:@"Answer"];
    } else if ([nowTagStr isEqualToString:@"A_CORRECT"]) {
//        [dicRowData setObject:string forKey:@"Correct"];
        [dicQuizInfo setObject:[dicRowData objectForKey:@"AnswerNum"] forKey:@"Correct"];
    }
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"row"]) {
        [arQuiz addObject:dicRowData];
    } else if ([elementName isEqualToString:@"KoreanAnswerInfo"]) {
        [dicQuizInfo setObject:arQuiz forKey:@"Answers"];
    }
    
    // 태그 초기화
    nowTagStr = @"";
}



@end
