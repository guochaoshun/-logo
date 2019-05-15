//
//  ViewController.m
//  DealWithLogo
//
//  Created by apple on 2019/4/9.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()


@property (weak) IBOutlet NSTextField *textField;

@property (weak) IBOutlet NSImageView *imageView;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString * oldPath = [[NSUserDefaults standardUserDefaults] objectForKey:@"path"];

    if (oldPath) {
        self.textField.stringValue = oldPath;
    }



}
/// 生成图片
- (IBAction)dealWithAction:(id)sender {
    
    
    [[NSUserDefaults standardUserDefaults] setObject:self.textField.stringValue forKey:@"path"];
    
    NSArray * array = @[@(40),@(60),
                        @(58),@(87),
                        @(80),@(120),
                        @(120),@(180),
                        @(1024)];
    
    NSString * toPath = [self.textField.stringValue stringByDeletingLastPathComponent];
    
    for (NSNumber * num in array) {
    
        // 先复制文件
        NSString * newFile = [toPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",num]];
        NSLog(@"%@",newFile);
        NSError * error = nil;
        [[NSFileManager defaultManager] copyItemAtPath:self.textField.stringValue toPath:newFile error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
        // 读取复制的文件
        NSImage * oldImage = [[NSImage alloc] initWithContentsOfFile:newFile];
        
        // 修改新文件的大小
        CGSize newSize = CGSizeMake(num.doubleValue*0.5, num.doubleValue*0.5);
        NSImage * newImage = [[NSImage alloc] initWithSize:newSize];
        [newImage lockFocus];
        [oldImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)
 fromRect:CGRectMake(0, 0, oldImage.size.width, oldImage.size.height) operation:NSCompositingOperationCopy fraction:1.0];
        [newImage unlockFocus];
        
    
        // 新文件存入硬盘
        NSData *imageData = [newImage TIFFRepresentation];
        
        NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
        
        [imageRep setSize:newSize];
        
        
        NSData * imageData1 = [imageRep representationUsingType:NSBitmapImageFileTypePNG properties:@{}];
        [imageData1 writeToFile:newFile atomically:YES];
        
        
    }
    
    
    
}




@end
