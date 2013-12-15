
#import "ViewController.h"
#define kFilteringFactor 0.1



@interface ViewController ()

@end

@implementation ViewController


@synthesize accelerometer;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _BGScrollView.contentSize = CGSizeMake(_BGScrollView.frame.size.width+30, _BGScrollView.frame.size.width+30);
    
    self.accelerometer = [UIAccelerometer sharedAccelerometer];
    self.accelerometer.updateInterval = 0.05;
    self.accelerometer.delegate = self;
    
    // Start the physics timer
    [NSTimer scheduledTimerWithTimeInterval: 0.05f target: self selector: @selector(tick) userInfo: nil repeats: YES];
        

    }
    
    
   

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    xvelocity = (acceleration.x * kFilteringFactor) + (xvelocity * (1.0f - kFilteringFactor));
    
    yvelocity = (acceleration.y * kFilteringFactor) + (yvelocity * (1.0f - kFilteringFactor));
    
    
    // Accelerate. To increase viscosity lower the additive value
    xoff = xvelocity * 20;
    yoff = yvelocity * 20;
}

- (void) tick {
    //NSLog(@"x:%f y:%f", xoff, yoff);
    _BGScrollView.contentOffset = CGPointMake(xoff, -yoff);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.imageCache removeAllObjects];
}




@end
