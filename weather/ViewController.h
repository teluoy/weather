#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface ViewController : UIViewController<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *Button3;//城市地区
@property (weak, nonatomic) IBOutlet UILabel *Label2;//当前日期
@property (weak, nonatomic) IBOutlet UILabel *Label2_1;//温度
@property (weak, nonatomic) IBOutlet UILabel *Label2_2;//天气状况
@property (weak, nonatomic) IBOutlet UILabel *Label2_3;//风向
@property (weak, nonatomic) IBOutlet UILabel *Label2_3_1;//级数
@property (weak, nonatomic) IBOutlet UILabel *Label2_5;//紫外线指数
@property (weak, nonatomic) IBOutlet UILabel *Label2_6;//户外运动指数
@property (weak, nonatomic) IBOutlet UILabel *Label2_6_1;//湿度指数
@property (weak, nonatomic) IBOutlet UILabel *Label2_7;//紫外线
@property (weak, nonatomic) IBOutlet UILabel *Label2_8;//户外运动
@property (weak, nonatomic) IBOutlet UILabel *Label2_9;//湿度
@property (weak, nonatomic) IBOutlet UIImageView *image1;//当天天气图片
@property (weak, nonatomic) IBOutlet UIWebView *view1;//一周天气概况
@property NSString *city_name;
@property int count;
@property int countt;
- (void) show : (NSString *) city;
@end
