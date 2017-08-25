#import "AdvertisingView.h"
#import "UIImageView+WebCache.h"
@interface AdvertisingView()

@property(nonatomic,strong) UIImageView * advertisingView;
@property(nonatomic,strong) UIButton * advertisingJumpButton;
@property(nonatomic,strong) UILabel * timeLabel;
@property(nonatomic,assign) int secondsCountDown;
@property(nonatomic,strong) NSTimer * countDownTimer;
/** 定时器(这里不用带*，因为dispatch_source_t就是个类，内部已经包含了*) */
@property (nonatomic, strong) dispatch_source_t timer;

@end
@implementation AdvertisingView
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.advertisingView];
        [self addSubview:self.advertisingJumpButton];
        [self addSubview:self.timeLabel];
    }
    return self;
}
-(void)startplayAdvertisingView:(void (^)(AdvertisingView *))advertisingview
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    // 这里的block advertisingview ;
    // advertisingview(); 你要调用就要传参数过去，调用的具体代码在 APPdelegate 里面调用的时候添加这个 block具体的代码、、、
    __block int count = 3;
    // 获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
    // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
    // 何时开始执行第一个任务
    // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚3秒
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    // 设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        /**
         *  回主线程更新UI
         */
        count--;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (count == 0) {
                // 取消定时器
                dispatch_cancel(self.timer);
                self.timer = nil;
                [self removeFromSuperview];
                /**
                 *  广告显示完，就调用 block 更换 rootcontroller
                 */
                advertisingview(self);
            }
            else{
                _timeLabel.text = [NSString  stringWithFormat:@"%d",count];}
        });
    });
    // 启动定时器
    dispatch_resume(self.timer);
}
-(UIImageView * )advertisingView
{
    if (_advertisingView == nil) {
        _advertisingView =[[UIImageView  alloc]initWithFrame:self.bounds];
        [_advertisingView sd_setImageWithURL:[NSURL URLWithString:@"http://g.hiphotos.baidu.com/zhidao/pic/item/f2deb48f8c5494ee665ec00f29f5e0fe99257eac.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    }
    return _advertisingView;
}
-(UILabel * )timeLabel
{
    if (_timeLabel == nil) {
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width - 50, 50, 50, 40)];
        _timeLabel.backgroundColor =[UIColor blackColor];
        _timeLabel.alpha = 0.5;
        _timeLabel.textColor = [UIColor whiteColor];
    }
    return _timeLabel;
}
-(UIButton * )advertisingJumpButton
{
    if (_advertisingJumpButton == nil) {
        _advertisingJumpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _advertisingJumpButton.frame =  CGRectMake(0, self.bounds.size.height - 80, self.bounds.size.width, 60);
        [_advertisingJumpButton setTitle:@"了解详情" forState:UIControlStateNormal];
        [_advertisingJumpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_advertisingJumpButton addTarget:self action:@selector(buttonclick) forControlEvents:UIControlEventTouchUpInside];
        _advertisingJumpButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _advertisingJumpButton.backgroundColor = [UIColor blackColor];
        _advertisingJumpButton.alpha = 0.5;
        _advertisingJumpButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _advertisingJumpButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return _advertisingJumpButton;
}
-(void)buttonclick
{
}
@end
