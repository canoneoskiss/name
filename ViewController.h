
#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"
#define genre 0

@interface ViewController : UIViewController <UIAccelerometerDelegate> {

    UIAccelerometer *accelerometer;
    
    float xoff;
    float yoff;
    float xvelocity;
    float yvelocity;
    float xaccel;
    float yaccel;
    

}

@property (nonatomic, retain) UIAccelerometer *accelerometer;
@property (weak,nonatomic) IBOutlet UIScrollView *BGScrollView;
@property (nonatomic, strong) NSCache *imageCache;
@property(nonatomic, strong) IBOutlet UITableView *tableView;


@end
