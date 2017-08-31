//
//  ViewController.m
//  JSDCoreDataManager
//
//  Created by Abner on 2017/8/31.
//  Copyright © 2017年 姜守栋. All rights reserved.
//

#import "ViewController.h"
#import "JSDCoreDataManager.h"
#import "User+CoreDataClass.h"
@interface ViewController ()<NSFetchedResultsControllerDelegate>
//coreData管理器  单例
@property(nonatomic,strong) JSDCoreDataManager *mgr;
//管理对象模型
@property(nonatomic,strong) NSManagedObjectContext *moc;
//查询结果控制器
@property(nonatomic,strong) NSFetchedResultsController *frc;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchMyData];
}
//数据库内数据有改变就会执行这个代理方法
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath{
    [self.tableView reloadData];
}

//查询数据
- (void)fetchMyData{
    [self.frc performFetch:NULL];
}

//添加数据
- (IBAction)addUser:(id)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:nil];
    [alert addTextFieldWithConfigurationHandler:nil];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.moc];
        user.name = alert.textFields[0].text;
        user.age = alert.textFields[1].text.intValue;
        [self.mgr saveContext];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 数据源方法和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _frc.fetchedObjects.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    User *user = _frc.fetchedObjects[indexPath.row];
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",user.age];
    return cell;
}

/**
 修改数据
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    User *user = self.frc.fetchedObjects[indexPath.row];
    user.name = [NSString stringWithFormat:@"zhangsan ---- %zd",arc4random_uniform(1000)];
}

/**
 删除数据
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    User *user = self.frc.fetchedObjects[indexPath.row];
    [self.moc deleteObject:user];
    [self.mgr saveContext];
}
#pragma mark - 懒加载
- (NSFetchedResultsController *)frc{
    if (!_frc) {
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"User"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        _frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.moc sectionNameKeyPath:nil cacheName:nil];
        _frc.delegate = self;
    }
    return _frc;
}
- (JSDCoreDataManager *)mgr{
    if (!_mgr) {
        _mgr = [JSDCoreDataManager sharedManager];
    }
    return _mgr;
}
- (NSManagedObjectContext *)moc{
    if (!_moc) {
        _moc = [self.mgr moc];
    }
    return _moc;
}

@end
