//
//  MainController.m
//  MGAvatar
//
//  Created by Gaomingyang on 2022/4/21.
//

#import "MainController.h"
#import "GameViewController.h"
#import "BobController.h"
#import "OBJController.h"
#import "FBXController.h"

@interface MainController ()
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation MainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self commonInit];
}

-(void)commonInit{
    self.title = @"Avatar";
    [self loadData];
}
-(void)loadData{
    [self.dataSource addObject:@"Plane"];
    [self.dataSource addObject:@"BobManAvatar"];
    [self.dataSource addObject:@"OBJSpider"];
    [self.dataSource addObject:@"FBX"];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCellID = @"modelViewCell";
    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:myCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellID];
    }
    // Configure the cell...
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    switch (index) {
        case 0:
            [self.navigationController pushViewController:[GameViewController new] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[BobController new] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[OBJController new] animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:[FBXController new
                                                          ] animated:YES];
            break;
        default:
            break;
    }
}

#pragma mark -- lazy load
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray new];
    }
    return  _dataSource;
}
@end
