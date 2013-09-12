//
//  FTLastBuildInfoCell.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 12/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTLastBuildInfoCell.h"


@interface FTLastBuildInfoCell ()

@property (nonatomic, strong) UIView *statusColorView;

@end


@implementation FTLastBuildInfoCell


#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.textLabel setBackgroundColor:[UIColor clearColor]];
    [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    
    [self.textLabel setWidth:250];
    [self.textLabel setXOrigin:54];
    [self.detailTextLabel setWidth:250];
    [self.detailTextLabel setXOrigin:54];
}

#pragma mark Creating elements

- (void)createIcons {
    _statusColorView = [[UIView alloc] initWithFrame:CGRectMake(14, 14, 26, 26)];
    [_statusColorView.layer setCornerRadius:(_statusColorView.height / 2)];
    [self addSubview:_statusColorView];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createIcons];
}

#pragma mark Settings

- (void)setBuild:(FTAPIJobDetailBuildDataObject *)build {
    _build = build;
    [self.textLabel setText:[NSString stringWithFormat:@"%@ :#%d", FTLangGet(@"Build"), _build.number]];
    [_statusColorView setBackgroundColor:[UIColor redColor]];
}

#pragma mark Initialization

+ (FTBasicCell *)cellForTable:(UITableView *)tableView {
    static NSString *identifier = @"lastBuildInfoCell";
    FTLastBuildInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTLastBuildInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return cell;
}


@end