

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *buttonImage;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImage *image = [UIImage imageNamed:@"button.png"];
    // 元画像の高さが56pxだとして、110まで引き延ばしたい、引き延ばす範囲は、2px〜8pxの間と、46px〜52pxの間
    UIImage *newImage = [self pbResizedImageWithWidth:image newHeight:110 resizeFrom:2 to:8 andFrom:56-10 to:56-4];
    
    [self.buttonImage setBackgroundImage:newImage forState:UIControlStateNormal];
    
    
}

- (UIImage *)pbResizedImageWithWidth:(UIImage*)orijinalImage
                           newHeight:(CGFloat)newHeight
                          resizeFrom:(CGFloat)from1 // 引き延ばす範囲1 開始ポイント
                                  to:(CGFloat)to1   // 引き延ばす範囲1 終了ポイント
                             andFrom:(CGFloat)from2 // 引き延ばす範囲2
                                  to:(CGFloat)to2   // 引き延ばす範囲2
{
    NSAssert(orijinalImage.size.height < newHeight, @"Cannot scale NewWidth %f > self.size.width %f",
             newHeight, orijinalImage.size.height);
    
    CGFloat originalHeight = orijinalImage.size.height;
    CGFloat tiledAreaHeight = (newHeight - originalHeight)/2;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(orijinalImage.size.width,originalHeight + tiledAreaHeight), NO, orijinalImage.scale);
    
    UIImage *firstResizable = [orijinalImage resizableImageWithCapInsets:UIEdgeInsetsMake(from1, 0,originalHeight - to1,0)];
    [firstResizable drawInRect:CGRectMake(0, 0, orijinalImage.size.width,originalHeight + tiledAreaHeight)];
    
    UIImage *leftPart = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(orijinalImage.size.width,newHeight), NO, orijinalImage.scale);
    
    UIImage *secondResizable = [leftPart resizableImageWithCapInsets:UIEdgeInsetsMake(from2 + tiledAreaHeight, 0, originalHeight - to2,0)];
    [secondResizable drawInRect:CGRectMake(0, 0, orijinalImage.size.width,newHeight)];
    
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return fullImage;
}

@end
