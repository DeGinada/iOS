//
//  WordTableViewController.m
//  JapaneseStudy
//
//  Created by DeGi on 2017. 5. 5..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "WordTableViewController.h"

@interface WordTableViewController ()

@end

@implementation WordTableViewController {
    NSArray* g_arWords;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setWordArray];
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


// [170505] word 정보를 세팅한다
- (void) setWordArray {
    g_arWords = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"word" ofType:@"plist"]];
}


#pragma mark - TABLE_VIEW

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString* identifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    // 정보 표시 해주기
    [cell.textLabel setText:[[g_arWords objectAtIndex:indexPath.row] objectForKey:@"jp"]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"  %@", [[g_arWords objectAtIndex:indexPath.row] objectForKey:@"kr"]]];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14.0]];

    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return g_arWords.count;
}

@end
