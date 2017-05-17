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
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    documentsURL = [documentsURL URLByAppendingPathComponent:@"word.xml"];
    
    g_arWords = [NSArray arrayWithContentsOfURL:documentsURL];
    
    if (!g_arWords) {
        g_arWords = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"word" ofType:@"xml"]];
    }
    
    // [170517] 정렬 
    NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"jp" ascending:YES];
    NSArray* arSorted = [g_arWords sortedArrayUsingDescriptors:@[sort]];
    g_arWords = arSorted;
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

    
    NSInteger nPoint = [[self.m_dicWord objectForKey:cell.textLabel.text] integerValue];
    if (nPoint < 0) {
        [cell.textLabel setTextColor:[UIColor redColor]];
        [cell.detailTextLabel setTextColor:[UIColor redColor]];
    } else if (nPoint >= 10) {
        [cell.textLabel setTextColor:[UIColor blueColor]];
        [cell.detailTextLabel setTextColor:[UIColor blueColor]];
    }
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return g_arWords.count;
}

@end
