//
//  FeedFetcher.m
//  Feedonimy
//
//  Created by Ashmit Chhabra on 8/14/14.
//  Copyright (c) 2014 ARO. All rights reserved.
//

#import "FeedFetcher.h"

@implementation FeedFetcher
+(NSArray *)URLForTrending{
    return @[@"http://www.faroo.com/api?q=&start=1&length=10&l=en&src=news&f=rss&key=dLOJpu4z8GjMyottrSavk5UhA6k_"];//@"http://www.buzzfeed.com/index.xml"];
   }
+(NSArray *)URLForTech{
   // return @[@"http://feeds.wired.com/wired/index",@"http://www.engadget.com/rss.xml",@"http://feeds.gawker.com/gizmodo/full",@"http://feeds.gawker.com/lifehacker/full",@"http://recode.net/feed/"];
    return @[@"http://feeds.feedburner.com/techspot/news",@"http://recode.net/feed/",@"http://www.engadget.com/rss.xml",@"http://www.cnet.com/rss/news/",@"http://feeds2.feedburner.com/thenextwebtopstories",@"http://feeds.macrumors.com/MacRumors-All?format=xml",@"http://online.wsj.com/xml/rss/3_7455.xml"];

}
+(NSArray *)URLForHeadlines{
    return @[@"http://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml",@"http://feeds.hindustantimes.com/HT-HomePage-TopStories?format=xml",@"http://news.yahoo.com/rss/topstories",@"http://online.wsj.com/xml/rss/3_7085.xml",@"http://nypost.com/news/feed/"];
}
+(NSArray *)URLForSports{
    return @[@"http://rss.nytimes.com/services/xml/rss/nyt/Sports.xml",@"http://www.latimes.com/sports/rss2.0.xml",@"http://nypost.com/sports/feed/"];
}
+(NSArray *)URLForEntertainment{
    //return @[@"http://feeds.eonline.com/eonline/topstories",@"http://feeds.feedburner.com/thr/news",@"http://feeds.ew.com/entertainmentweekly/latest"];
    return @[@"http://feeds.feedburner.com/thr/news",@"http://feeds.ew.com/entertainmentweekly/latest",@"http://rss.feedsportal.com/c/592/f/7507/index.rss",@"http://feeds.people.com/people/headlines",@"http://feeds.feedburner.com/uproxx/features?format=xml",@"http://www.latimes.com/entertainment/rss2.0.xml",@"http://nypost.com/entertainment/feed/"];
}
+(NSArray *)URLForBusiness{
    return @[@"http://feeds.feedburner.com/venturebeat",@"http://rss.cnn.com/rss/money_topstories.rss",@"http://online.wsj.com/xml/rss/3_7014.xml",@"http://nypost.com/business/feed/"];
}
+(NSArray *)URLForGaming{
    return @[@"http://www.gamespot.com/feeds/news/"];
}
@end
//http://feeds.mashable.com/Mashable?format=xml
//http://www.huffingtonpost.com/feeds/verticals/entertainment/index.xml