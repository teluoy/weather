#import "ViewController.h"
@interface ViewController ()
{
    NSMutableDictionary *tu;
    NSDictionary *Dic;
    NSDictionary *a;
    NSDictionary *b;
    NSString *fileName;
    NSDictionary *readDict;
}
@end
@implementation ViewController
//定位
-(NSString *) Locate
{
    NSString *updateurl = [NSString stringWithFormat:@"http://int.dpool.sina.com.cn/iplookup/iplookup.php"];
    NSURL *url = [NSURL URLWithString:updateurl];
        NSString *returnString = [NSString stringWithContentsOfURL:url encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000) error:nil];
    NSString *city = [[returnString componentsSeparatedByString:@"\t"] objectAtIndex:5];
    NSLog(@"Location City %@",city);
    return city;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.countt = 0;
    [self Background];
    //WebView透明
    [self.view1 setBackgroundColor:[UIColor clearColor]];
    [self.view1 setOpaque:NO];
    //导航透明色
    self.navigationController.navigationBarHidden = YES;
    self.city_name = [self Locate];
    //判断重复定位
    if(self.count != 1)
    {
        [self show:self.city_name];
        self.count = 1;
    }
    else
    {
        [self show:self.city_name];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //webview 自适应高度
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
}
- (void) viewDidAppear:(BOOL)animated
{
    [self show:self.city_name];
    //导航透明色
    self.navigationController.navigationBarHidden = YES;
}
//接口次数判断
- (void) show : (NSString *) city
{
    //天气图片匹配
    [self weather_Picture];
    //从接口获取数据到存储为字典
    NSString *urlstring = [NSString stringWithFormat:@"http://v.juhe.cn/weather/index?cityname=%@&key=59f3b0ad66c8c7d8133e40d8e9366781",[city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSString *string = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSData *data =[ string dataUsingEncoding:NSUTF8StringEncoding];
    Dic = [NSJSONSerialization JSONObjectWithData:data
                                           options:NSJSONReadingMutableContainers
                                             error:nil];
    if([[Dic objectForKey:@"resultcode"] isEqual: @"200"])
    {
        [self Show];
    }
    else
    {
        NSString *urlstring = [NSString stringWithFormat:@"http://v.juhe.cn/weather/index?cityname=%@&key=ebc85589bda7f5386f087d36b755152f",[city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURL *url = [NSURL URLWithString:urlstring];
        NSString *string = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data =[ string dataUsingEncoding:NSUTF8StringEncoding];
        Dic = [NSJSONSerialization JSONObjectWithData:data
                                              options:NSJSONReadingMutableContainers
                                                error:nil];
        if([[Dic objectForKey:@"resultcode"] isEqual: @"200"])
        {
            [self Show];
        }
        else
        {
            NSString *urlstring = [NSString stringWithFormat:@"http://v.juhe.cn/weather/index?cityname=%@&key=9e5c0fe3b7f8f83f19b398010c020a6a",[city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSURL *url = [NSURL URLWithString:urlstring];
            NSString *string = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            NSData *data =[ string dataUsingEncoding:NSUTF8StringEncoding];
            Dic = [NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingMutableContainers
                                                    error:nil];
            [self Show];
        }
    }
}
//首页面呈现数据
- (void) Show
{
    [self.Button3 setTitle:[[[Dic objectForKey:@"result"] objectForKey:@"today"]objectForKey:@"city"] forState:UIControlStateNormal];
    self.Label2.text = [[[Dic objectForKey:@"result"] objectForKey:@"today"]objectForKey:@"date_y"];
    self.Label2_1.text = [[[Dic objectForKey:@"result"] objectForKey:@"today"]objectForKey:@"temperature"];
    self.Label2_2.text = [[[Dic objectForKey:@"result"] objectForKey:@"today"]objectForKey:@"weather"];
    self.Label2_3.text = [[[Dic objectForKey:@"result"]objectForKey:@"sk" ] objectForKey:@"wind_direction"];
    self.Label2_3_1.text = [[[Dic objectForKey:@"result"]objectForKey:@"sk"]objectForKey:@"wind_strength"];
    self.Label2_5.text = [[[Dic objectForKey:@"result"] objectForKey:@"today"]objectForKey:@"uv_index"];
    self.Label2_6.text = [[[Dic objectForKey:@"result"] objectForKey:@"today"]objectForKey:@"travel_index"];
    self.Label2_6_1.text = [[[Dic objectForKey:@"result"]objectForKey:@"sk" ] objectForKey:@"humidity"];
    self.Label2_7.text = @"紫外线指数";
    self.Label2_8.text = @"户外运动指数";
    self.Label2_9.text = @"湿度";
    b = [[Dic objectForKey:@"result"] objectForKey:@"today"];
    NSString *st3 = [tu objectForKey:b[@"weather"]];
    NSString *st4 = [tu objectForKey:@"other"];
    //判断库里是否有对应图片
    if([tu objectForKey:b[@"weather"]])
    {
        self.image1.image = [UIImage imageNamed:st3];
    }
    else
    {
        self.image1.image = [UIImage imageNamed:st4];
    }
    //字典级数
    NSDictionary *future = [[Dic objectForKey:@"result"]objectForKey:@"future"];
    NSString *path = [[NSBundle mainBundle]bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    //字典存数组里面排序
    NSArray *arr = [future allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    NSString *day=@"";
    int cont = 0;
    //获取除当天一周天气状态
    for (int i=0;i<[arr count];i++)
    {
        NSString *Picture = [tu objectForKey:@"other"];
        NSString *a1=arr[i];
        a = future[a1];
        NSString *data;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYYMMdd"];
        data = [formatter stringFromDate:[NSDate date]];
        //不等于当天
        if ([a[@"date"] isEqualToString:data])
        {
            continue;
        }
        if([tu objectForKey:a[@"weather"]])
        {
            Picture =  [tu objectForKey:a[@"weather"]];
        }
        //显示天数
        if(cont < 7 )
        {
            //格式
            NSString *format = [NSString stringWithFormat:@"<table><tr><td width=\"100\">%@</td><td width=\"100\">%@</td><td width=\"200\">%@</td><td width=\"50\"><img width=\"35\" height=\"35\" src=\"%@\"/></tr></table>",a[@"week"],a[@"temperature"],a[@"weather"],
                                Picture];
            //一天天气状态值
            day = [day stringByAppendingString:format];
            cont++;
        }
    }
    //webview输出字体颜色
    NSString *jsString = [NSString stringWithFormat:@"<html> \n"
                          "<head> \n"
                          "<style type=\"text/css\"> \n"
                          "body {color: %@;}\n"
                          "</style> \n"
                          "</head> \n"
                          "<body>%@</body> \n"
                          "</html>",@"#fff", day];
    [self.view1 loadHTMLString:jsString baseURL:baseURL];
    //WebView输出week、temperature、weather、weather.image
    [self.view1 loadHTMLString:jsString baseURL:baseURL];
}
//添加城市按钮
- (IBAction)button1:(id)sender
{
    ViewController *tian  = [self.storyboard instantiateViewControllerWithIdentifier:@"add"];
    [self.navigationController pushViewController:tian animated:YES];
}
//定位按钮Locate
- (IBAction)button2:(id)sender
{
    [self show:[self Locate]];
}
//城市切换按钮
- (IBAction)button3:(id)sender
{
    [self Read_city];
}
//读取已有城市
- (void) Read_city
{
    fileName = [NSString stringWithFormat:@"%@%@",NSHomeDirectory(),@"/Documents/City.txt"];
    readDict = [NSDictionary dictionaryWithContentsOfFile:fileName];
    NSArray * citys = readDict[@"dad"];
    if(self.countt != [citys count])
    {
        [self show:[citys objectAtIndex:self.countt]];
        self.countt ++;
    }
    else
    {
        self.countt = 0;
        [self show:[citys objectAtIndex:self.countt]];
        self.countt ++;
    }
}
//背景图片自适应屏幕
- (void) Background
{
    UIImage *img_m = [UIImage imageNamed:@"one.jpg"];
    UIImage *img_a;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [img_m drawInRect:CGRectMake(0, 0, width, height)];
    img_a = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:img_a];
}
//天气图片匹配
- (void)weather_Picture
{
    tu = [NSMutableDictionary dictionary];
    [tu setObject:@"大到暴雨.png" forKey:@"大到暴雨"];
    [tu setObject:@"小雨转阴.png" forKey:@"小雨转阴"];
    [tu setObject:@"阴转多云.png" forKey:@"阴转多云"];
    [tu setObject:@"中雨转小雨.png" forKey:@"中雨转小雨"];
    [tu setObject:@"阴转小雨.png" forKey:@"阴转小雨"];
    [tu setObject:@"阵雨转阴.png" forKey:@"阵雨转阴"];
    [tu setObject:@"阵雨转小雨.png" forKey:@"阵雨转小雨"];
    [tu setObject:@"阴转阵雨.png" forKey:@"阴转阵雨"];
    [tu setObject:@"多云转晴.png" forKey:@"多云转晴"];
    [tu setObject:@"霾转晴.png" forKey:@"霾转晴"];
    [tu setObject:@"暴雪.png" forKey:@"暴雪"];
    [tu setObject:@"暴雨.png" forKey:@"暴雨"];
    [tu setObject:@"暴雨转大暴雨.png" forKey:@"暴雨转大暴雨"];
    [tu setObject:@"大暴雨转特大暴雨.png" forKey:@"大暴雨转特大暴雨"];
    [tu setObject:@"大雪.png" forKey:@"大雪"];
    [tu setObject:@"大雪转暴雪.png" forKey:@"大雪转暴雪"];
    [tu setObject:@"大雨.png" forKey:@"大雨"];
    [tu setObject:@"大雨转暴雨.png" forKey:@"大雨转暴雨"];
    [tu setObject:@"冻雨.png" forKey:@"冻雨"];
    [tu setObject:@"多云.png" forKey:@"多云"];
    [tu setObject:@"多云转小雨.png" forKey:@"多云转小雨"];
    [tu setObject:@"多云转阴.png" forKey:@"多云转阴"];
    [tu setObject:@"浮尘.png" forKey:@"浮尘"];
    [tu setObject:@"雷阵雨.png" forKey:@"雷阵雨"];
    [tu setObject:@"雷阵雨伴有冰雹.png" forKey:@"雷阵雨伴有冰雹"];
    [tu setObject:@"霾.png" forKey:@"霾"];
    [tu setObject:@"强沙尘暴.png" forKey:@"强沙尘暴"];
    [tu setObject:@"晴.png" forKey:@"晴"];
    [tu setObject:@"晴转多云.png" forKey:@"晴转多云"];
    [tu setObject:@"晴转阴.png" forKey:@"晴转阴"];
    [tu setObject:@"沙尘暴.png" forKey:@"沙尘暴"];
    [tu setObject:@"特大暴雨.png" forKey:@"特大暴雨"];
    [tu setObject:@"雾.png" forKey:@"雾"];
    [tu setObject:@"小雪.png" forKey:@"小雪"];
    [tu setObject:@"小雪转中雪.png" forKey:@"小雪转中雪"];
    [tu setObject:@"小雨.png" forKey:@"小雨"];
    [tu setObject:@"小雨转中雨.png" forKey:@"小雨转中雨"];
    [tu setObject:@"扬沙.png" forKey:@"扬沙"];
    [tu setObject:@"阴.png" forKey:@"阴"];
    [tu setObject:@"阴转晴.png" forKey:@"阴转晴"];
    [tu setObject:@"雨夹雪.png" forKey:@"雨夹雪"];
    [tu setObject:@"阵雪.png" forKey:@"阵雪"];
    [tu setObject:@"阵雨.png" forKey:@"阵雨"];
    [tu setObject:@"中雪.png" forKey:@"中雪"];
    [tu setObject:@"中雪转大雪.png" forKey:@"中雪转大雪"];
    [tu setObject:@"中雨.png" forKey:@"中雨"];
    [tu setObject:@"中雨转大雨.png" forKey:@"中雨转大雨"];
    [tu setObject:@"other.png" forKey:@"other"];
}
- (void)didReceiveMemoryWarning
{
     [super didReceiveMemoryWarning];
}
@end
