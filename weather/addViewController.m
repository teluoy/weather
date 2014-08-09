#import "addViewController.h"
#import "ViewController.h"
@interface addViewController ()
{
    NSMutableDictionary *tu;
    NSMutableArray *Array_Forecast;
    NSMutableArray *Array_City;
    NSMutableArray *Array_Picture;
    NSDictionary *Dic;
    NSDictionary *a;
    NSString *fileName;
    NSDictionary *readDict;
}
@end
@implementation addViewController
@synthesize myTableView;
@synthesize arrayOfRows;
- (IBAction)text:(id)sender
{
    [self sou];
}
- (IBAction)button1:(id)sender
{
    [self sou];
}
//输入框判断
- (void)sou
{
    if(self.text1.text.length == 0)
    {
        self.text1.text = @"";
        self.text1.placeholder = @"不能为空";
    }
    else
    {
        if( [Array_City indexOfObject:self.text1.text] != NSNotFound)
            
        {
            self.text1.text = @"";
            self.text1.placeholder = @"此城市以已存在 请重新输入";
        }
        else
        {
            [self show:self.text1.text];
            NSLog(@"Select City %@",self.text1.text);
            [self.view1 reloadData];
            [self Write_city];
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self Background];
    //TextField透明色
    [self.text1 setBackgroundColor:[UIColor clearColor]];
    //TableView透明色
    self.view1.backgroundColor = [UIColor clearColor];
    Array_Forecast = [[NSMutableArray alloc] init];
    Array_City = [[NSMutableArray alloc] init];
    Array_Picture = [[NSMutableArray alloc] init];
    self.view1.delegate = self;//设置代理为自身
    self.view1.dataSource = self;//设置数据源为自身
    [self Read_city];
}
//读取已有城市
- (void) Read_city
{
    fileName = [NSString stringWithFormat:@"%@%@",NSHomeDirectory(),@"/Documents/City.txt"];
    readDict = [NSDictionary dictionaryWithContentsOfFile:fileName];
    for(NSString * str in readDict)
    {
        NSArray * citys = readDict[@"dad"];
        NSLog(@"%@",citys);
        for(int i = 0; i < [citys count]; i++)
        {
            [self show:[readDict objectForKey:str][i]];
        }
    }
}
//存取城市
- (void) Write_city
{
    fileName = [NSString stringWithFormat:@"%@%@",NSHomeDirectory(),@"/Documents/City.txt"];
    NSDictionary *data= [NSDictionary dictionaryWithObjectsAndKeys:Array_City,@"dad", nil];
    [data writeToFile:fileName atomically:YES];
}
//删除城市
- (void) Delete_city
{
    fileName = [NSString stringWithFormat:@"%@%@",NSHomeDirectory(),@"/Documents/City.txt"];
    NSDictionary *data= [NSDictionary dictionaryWithObjectsAndKeys:Array_City,@"dad", nil];
    [data writeToFile:fileName atomically:YES];
}
//存储第二页呈现数据
- (void) show : (NSString *) city
{
    //天气图片匹配
    [self weather_Picture];
    //从接口获取数据到存储为字典
    NSString *urlstring = [NSString stringWithFormat:@"http://v.juhe.cn/weather/index?cityname=%@&key=d0a50be56cc0afb009aaca0fde0552ad",[city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
        NSString *urlstring = [NSString stringWithFormat:@"http://v.juhe.cn/weather/index?cityname=%@&key=6f85229d8401f96f1b03ec686356fe08",[city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSURL *url = [NSURL URLWithString:urlstring];
        
        NSString *string = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        
        NSData *data =[ string dataUsingEncoding:NSUTF8StringEncoding];
        Dic = [NSJSONSerialization JSONObjectWithData:data
                                              options:NSJSONReadingMutableContainers
                                                error:nil];
        [self Show];
    }
}
- (void) Show
{
    //TextField判断是否输入正确到城市名称
    if([Dic[@"reason"] isEqualToString:@"查询不到该城市的信息"])
    {
        self.text1.text = @"";
        self.text1.placeholder = @"查询不到该城市的信息 请重新输入";
    }
    else
    {
        //格式
        a = [[Dic objectForKey:@"result"] objectForKey:@"today"];
        [NSString stringWithFormat:@"<table><tr><td width=\"100\">%@</td><td width=\"100\">%@</td><td width=\"100\">%@</td><td width=\"100\">%@</td><td width=\"100\"><img width=\"40\" height=\"40\" src=\"%@\"/></tr></table>",a[@"city"],a[@"week"],a[@"temperature"],a[@"weather"],[tu objectForKey:a[@"weather"]]];
        //添加城市天气预报简介weather、temperature、city
        NSString *Forecast = [NSString stringWithFormat:@"%@    %@    ",a[@"temperature"],a[@"city"]];
        //添加的城市
        NSString *City = [NSString stringWithFormat:@"%@",a[@"city"]];
        NSString *Picture_all = [tu objectForKey:a[@"weather"]];
        NSString *Picture_a = [tu objectForKey:@"other"];
        //把数据存到可变数组
        [Array_Forecast addObject:Forecast];
        [Array_City addObject:City];
        //判断库里是否有对应图片
        if([tu objectForKey:a[@"weather"]])
        {
            [Array_Picture addObject:Picture_all];
        }
        else
        {
            [Array_Picture addObject:Picture_a];
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Array_Forecast count];
}
//第二页呈现数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"tables1Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [Array_Forecast objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[Array_Picture objectAtIndex:indexPath.row]];
    return cell;
}
//把点击的城市传到首页
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewController *tian = [self.navigationController.viewControllers objectAtIndex:0];
    tian.self.city_name = [Array_City objectAtIndex:indexPath.row];
    NSLog(@"City_name %@",tian.self.city_name);
    [self.navigationController popViewControllerAnimated:YES];
}
//删除tableview整行
//*********************************************************************
//要求委托方的编辑风格在表视图的一个特定的位置。
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;//默认没有编辑风格
    if ([tableView isEqual:self.view1])
    {
        result = UITableViewCellEditingStyleDelete;//设置编辑风格为删除风格
    }
    return result;
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [self.view1 setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{//请求数据源提交的插入或删除指定行接收者。
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        if (indexPath.row<[Array_Forecast count]) {
            [Array_Forecast removeObjectAtIndex:indexPath.row];//移除数据源的数据
            [Array_City removeObjectAtIndex:indexPath.row];//移除数据源的数据
            [Array_Picture removeObjectAtIndex:indexPath.row];//移除数据源的数据
            [self Delete_city];
            [self.view1 deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
        }
    }
}
//*********************************************************************
//背景图片自适应屏幕
- (void) Background
{
    UIImage *img_m = [UIImage imageNamed:@"two.jpg"];
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
-(void) weather_Picture
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
