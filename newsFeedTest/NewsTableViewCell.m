// //
// //  NewsTableViewCell.m
// //  newsFeedTest
// //
// //  Created by 孔维辰 on 2025/5/21.
// //

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // 创建固定尺寸的图片视图
        self.newsImageView = [[UIImageView alloc] init];
        self.newsImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.newsImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.newsImageView];

        // 创建标题标签
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.titleLabel.numberOfLines = 2;
        [self.contentView addSubview:self.titleLabel];

        // 创建详情标签
        self.detailLabel = [[UILabel alloc] init];
        self.detailLabel.font = [UIFont systemFontOfSize:14];
        self.detailLabel.textColor = [UIColor darkGrayColor];
        self.detailLabel.numberOfLines = 2;
        [self.contentView addSubview:self.detailLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    // 设置固定的图片尺寸
    CGFloat imageSize = 80.0;
    CGFloat margin = 10.0;
    CGFloat contentWidth = self.contentView.bounds.size.width - (margin * 3) - imageSize;

    // 图片位置固定
    self.newsImageView.frame = CGRectMake(margin, margin, imageSize, imageSize);

    // 文本区域位置
    self.titleLabel.frame = CGRectMake(imageSize + (margin * 2), margin, contentWidth, 40);
    self.detailLabel.frame = CGRectMake(imageSize + (margin * 2), margin + 45, contentWidth, 35);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    // 重用前重置图片视图
    self.newsImageView.image = nil;
    self.titleLabel.text = nil;
    self.detailLabel.text = nil;
}

@end
