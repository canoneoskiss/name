
#import <UIKit/UIKit.h>


@interface OthersViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray *filenames;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionOthers;
@property (nonatomic, strong) NSCache *imageCache;

@end
