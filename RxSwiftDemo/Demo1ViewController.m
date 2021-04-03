//
//  Demo1ViewController.m
//  RxSwiftDemo
//
//  Created by 华&梅 on 2020/12/14.
//

#import "Demo1ViewController.h"

#define WeakSelf(self) __weak __typeof(&*self) weakSelf = self;
//typedef void(^BlockBackVcClick)(NSString *str);

@interface Demo1ViewController ()

@property (nonatomic, strong) NSMutableArray <RACDisposable *>* notiDisposables;

///
@property (nonatomic, assign) NSInteger counter;

@property (nonatomic, copy) void(^blockBackVcClick)(NSString * str);

@end

@implementation Demo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
    WeakSelf(self);
    self.blockBackVcClick = ^(NSString *str) {
        weakSelf.counter = 100;
        NSLog(@"======%@========",str);
    };
    self.blockBackVcClick(@"adaskhdash骄傲圣诞节阿萨德很快就阿萨德哈师大");
    */

    self.view.backgroundColor = [UIColor redColor];
    @weakify(self);
    self.notiDisposables = [NSMutableArray arrayWithCapacity:1];
    RACDisposable * dis1 = [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:NotificationNameDemo1 object:nil] deliverOnMainThread] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        NSLog(@"测试第一种方式--通知：=====%@====%@=====%@===",x.object, x.name, self);
    }];
    [self.notiDisposables addObject:dis1];
    
    /*
     ///这个也是释放不掉的 还是能接受到监听
    [[[[[NSNotificationCenter defaultCenter] rac_addObserverForName:NotificationNameDemo1 object:nil] deliverOnMainThread] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        NSLog(@"测试第二种情况：=====%@====%@=====%@===",x.object, x.name, self);
    }] rac_deallocDisposable];
    */
    
    //创建一个定时器，间隔1s，在主线程中运行
    RACSignal *timerSignal = [RACSignal interval:1.0f onScheduler:[RACScheduler mainThreadScheduler]];
    //定时器总时间3秒
    timerSignal = [timerSignal take:300];
    //定义一个倒计时的NSInteger变量
    self.counter = 300;
    RACDisposable * timerDis = [timerSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.counter--;
        NSLog(@"测试第一种方式--定时器：count = %ld", (long)self.counter);
    } completed:^{
        //计时完成
        NSLog(@"Timer completed");
    }];
    [self.notiDisposables addObject:timerDis];
    /*///这种方式是释放不掉定时器的
    [[timerSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.counter--;
        NSLog(@"测试第二种情况：count = %ld", (long)self.counter);
    } completed:^{
        //计时完成
        NSLog(@"Timer completed");
    }] rac_deallocDisposable];*/
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameDemo1 object:@(true)];
}

- (void)dealloc
{
    if (self.notiDisposables.count) {
        for (RACDisposable * dis1 in self.notiDisposables) {
            [dis1 dispose];
        }
        [self.notiDisposables removeAllObjects];
    }
    NSLog(@"========Dealloc======%@===",self);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
