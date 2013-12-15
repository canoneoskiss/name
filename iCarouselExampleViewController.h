
#import <UIKit/UIKit.h>
#import "iCarousel.h"


@interface iCarouselExampleViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>{
    NSMutableArray *allImagesArray;
    NSMutableArray *imageArray1;
    NSMutableArray *imageArray2;
}

@property (nonatomic, retain) IBOutlet iCarousel *carousel1;
@property (nonatomic, retain) IBOutlet iCarousel *carousel2;

@end
