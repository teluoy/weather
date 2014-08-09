#import <UIKit/UIKit.h>
@interface addViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *text1;
@property (weak, nonatomic) IBOutlet UITableView *view1;
@property (nonatomic, strong) UITableView *myTableView;
@property(nonatomic,strong) NSMutableArray *arrayOfRows;
@end
