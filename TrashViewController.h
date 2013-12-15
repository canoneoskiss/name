#import <UIKit/UIKit.h>

@interface TrashViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray *filenames;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionTrash;
@property (nonatomic, strong) NSCache *imageCache;
- (BOOL)removeFilePath:(NSString*)path;

@end
