//
//  ViewController.m
//  jobs123
//
//  Created by liyong on 15/8/2.
//  Copyright (c) 2015年 dothink. All rights reserved.
//

#import "ViewController.h"
//引用dropdown菜单
#import "DOPDropDownMenu - Enhanced/DOPDropDownMenu.h"
//引用afnetworking
#import "AFNetworking.h"

@interface ViewController ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UITableViewDelegate, UITableViewDataSource>

//下拉菜单变量
@property (nonatomic, strong) NSArray *classifys;
@property (nonatomic, strong) NSArray *areas;
@property (nonatomic, strong) NSArray *sorts;
//tabaleview变量
@property (strong, nonatomic) NSArray *list;
//tableview的数据
@property(weak,nonatomic) IBOutlet UITableView *vTableView;

@end

@implementation ViewController
@synthesize vTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //self.title = @"DOPDropDownMenu";
    
    // 数据
    self.classifys = @[@"全部分类",@"今日新单",@"电影",@"酒店"];
    self.areas = @[@"全部地区",@"芙蓉区",@"雨花区",@"天心区",@"开福区",@"岳麓区"];
    self.sorts = @[@"默认排序",@"离我最近",@"好评优先",@"人气优先",@"最新发布"];
    
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
    
    [menu selectDefalutIndexPath];
    
    
    //读取网络信息
    AFHTTPRequestOperationManager *manager            = [AFHTTPRequestOperationManager manager];
    
    // 设置回复内容信息
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    

    [manager GET:@"http://jobs123.cn/api.php/Index/getJzInfo"
       parameters:nil
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           
           
           //定义一个变量 然后输出结果根据key来读取value
           NSArray *arr = [responseObject objectForKey:@"JzInfo"];
           NSMutableArray *jobsTemp = [[NSMutableArray alloc] initWithCapacity:arr.count];
           NSLog(@"%@",arr);
           //NSArray
           for(NSDictionary *jobsInfo in arr) {
               
               NSArray *jobby = [[NSArray alloc] init];
               
               jobby= [jobsInfo objectForKey:@"name"];
               [jobsTemp addObject:jobby];
           }
           self.list=jobsTemp;
           [vTableView reloadData];
           
          
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               NSLog(@"%@",error);                                                                                          }];

}


- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 3;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return self.classifys.count;
    }else if (column == 1){
        return self.areas.count;
    }else {
        return self.sorts.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return self.classifys[indexPath.row];
    } else if (indexPath.column == 1){
        return self.areas[indexPath.row];
    } else {
        return self.sorts[indexPath.row];
    }
}



- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
    }else {
        NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *TableSampleIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
    }

   
    NSUInteger row = [indexPath row];
       cell.textLabel.text = [self.list objectAtIndex:row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSString *rowString = [self.list objectAtIndex:row];
    NSLog(@"选中的行信息:%@", rowString);
}


- (void)didReceiveMemoryWarning {
    
    //[self.list release];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.list = nil;
    
}

@end
