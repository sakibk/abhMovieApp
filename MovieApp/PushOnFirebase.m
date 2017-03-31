//
//  PushOnFirebase.m
//  MovieApp
//
//  Created by Sakib Kurtic on 30/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "PushOnFirebase.h"

@implementation PushOnFirebase

+(void)pushMoviesOnFirebase{
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    RLMResults<RLMovie*> *movies = [RLMovie allObjects];
    //    NSMutableArray<Movie*> *mvs= [[NSMutableArray alloc] init];
    int i;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSMutableArray<DaysPlaying*> *playingDays= [[NSMutableArray alloc] init];
    playingDays = [self getPlayingDays];
    int intCount = 0;
    for(i = 0;i<15;i++){
        RLMovie *mv = [movies objectAtIndex:i];
        if([mv.movieCast count] && [mv.genres count] && [mv.movieCast count]){
            if(intCount<10){
            NSString *str =[NSString stringWithFormat:@"%d",i];
            NSString *rate = [NSString stringWithFormat:@"%@",mv.rating];
            [[[ref child:@"Movies"] child:str]
             setValue:@{@"id": [NSString stringWithFormat:@"%@",mv.movieID],
                        @"title": [NSString stringWithFormat:@"%@",mv.title],
                        @"overview": [NSString stringWithFormat:@"%@",mv.overview],
                        @"poster_path": [NSString stringWithFormat:@"%@",mv.posterPath],
                        @"backdrop_path": [NSString stringWithFormat:@"%@",mv.backdropPath],
                        @"release_date": [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:mv.releaseDate]],
                        @"ticket_price": [NSString stringWithFormat:@"%@",@"20.00"],
                        @"vote_average":[NSString stringWithFormat:@"%@",rate]}];
            int j;
            for(j=0; j<[mv.genres count];j++){
                RLMGenre *g = [mv.genres objectAtIndex:j];
                NSString *jstr = [NSString stringWithFormat:@"%d",j];
                [[[[[ref child:@"Movies"] child:str] child:@"genres"]child:jstr]
                 setValue:@{jstr: [NSString stringWithFormat:@"%@",g.genreName]}];
            }
            int kru=0;
            for(j=0; j<[mv.movieCrew count]+3;j++){
                NSString *jobName;
                NSString *crewName;
                BOOL doContinue = NO;
                if(kru<3){
                    RLMCast *cs = [mv.movieCast objectAtIndex:j];
                    jobName=@"star";
                    crewName=cs.castName;
                    kru++;
                    doContinue=YES;
                }
                else{
                    RLMCrew *cr = [mv.movieCrew objectAtIndex:j-3];
                if([cr.jobName isEqualToString:@"director"] || [cr.jobName isEqualToString:@"writer"]){
                    jobName=cr.jobName;
                    crewName=cr.crewName;
                    doContinue=YES;
                }
                }
                NSString *jstr = [NSString stringWithFormat:@"%d",j];
                if(doContinue){
                    [[[[[ref child:@"Movies"] child:str] child:@"crew"] child:jstr]
                     setValue:@{@"crew_name": [NSString stringWithFormat:@"%@",crewName],
                                @"job_name": [NSString stringWithFormat:@"%@",jobName]}];
                    doContinue=NO;
                }
            }
            for(j=0;j<[playingDays count];j++){
                NSString *jstr = [NSString stringWithFormat:@"%d",j];
                DaysPlaying *dp = [playingDays objectAtIndex:j];
                [[[[[ref child:@"Movies"] child:str] child:@"days_playing"] child:jstr]
                 setValue:@{@"date": [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:dp.playingDate]],
                            @"day": [NSString stringWithFormat:@"%@",dp.playingDay]}];
//                [[[[[ref child:@"Movies"] child:str] child:@"days_playing"] child:jstr]
//                 setValue:@{@"day": [NSString stringWithFormat:@"%@",dp.playingDay]}];
                int k;
                for(k=0;k<[dp.playingHours count];k++){
                    Hours *hr =[dp.playingHours objectAtIndex:k];
                    NSString *kstr = [NSString stringWithFormat:@"%d",k];
                    [[[[[[[ref child:@"Movies"] child:str] child:@"days_playing"] child:jstr]child:@"hours"]child:kstr]
                     setValue:@{@"time": [NSString stringWithFormat:@"%@",hr.playingHour]}];
                    int l;
                    for(l=0;l<[hr.seats count]; l++){
                        Seats *st = [hr.seats objectAtIndex:l];
                        NSString *lstr = [NSString stringWithFormat:@"%d",l];
                        [[[[[[[[[ref child:@"Movies"] child:str] child:@"days_playing"] child:jstr]child:@"hours"]child:kstr] child:@"seats"]child:lstr]
                         setValue:@{@"row": [NSString stringWithFormat:@"%@",st.row],
                                    @"seat_num": [NSString stringWithFormat:@"%@",st.seatNum],
                                    @"taken": @"NO"}];
//                        [[[[[[[[[ref child:@"Movies"] child:str] child:@"days_playing"] child:jstr]child:@"hours"]child:kstr] child:@"seats"]child:lstr]
//                         setValue:@{@"seat_num": [NSString stringWithFormat:@"%@",st.seatNum]}];
//                        [[[[[[[[[ref child:@"Movies"] child:str] child:@"days_playing"] child:jstr]child:@"hours"]child:kstr] child:@"seats"]child:lstr]
//                         setValue:@{@"taken": @"NO"}];
                    }
                }
            }
                intCount++;
            }
        }
    }
}

+(NSMutableArray<DaysPlaying*>*)getPlayingDays{
    NSMutableArray<DaysPlaying*> *playingDays= [[NSMutableArray alloc] init];
    NSMutableArray<Hours*>*hours = [[NSMutableArray alloc]init];
    NSMutableArray<Seats*>*seats = [[NSMutableArray alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    int k;
    int z;
    for(k = 1; k<8 ;k++){
        Seats *seat = [[Seats alloc]init];
        seat.seatNum=[NSNumber numberWithInt:k];
        seat.row =@"A";
        [seats addObject:seat];
    }
    for(k = 1; k<10 ; k++){
        for(z = 1; z<10 ; z++){
            Seats *seat = [[Seats alloc]init];
            seat.seatNum=[NSNumber numberWithInt:z];
            if (k==1)
                seat.row =@"B";
            else if (k==2)
                seat.row =@"C";
            else if (k==3)
                seat.row =@"D";
            else if (k==4)
                seat.row =@"E";
            else if (k==5)
                seat.row =@"F";
            else if (k==6)
                seat.row =@"G";
            else if (k==7)
                seat.row =@"H";
            else if (k==8)
                seat.row =@"I";
            else if (k==9)
                seat.row =@"J";
            [seats addObject:seat];
        }
    }
    for(k=0;k<3;k++){
        Hours *hrs = [[Hours alloc]init];
        hrs.seats =[[NSMutableArray alloc]initWithArray:seats];
        if (k==0) {
            hrs.playingHour=@"17:00";
        }
        else if (k==1){
            hrs.playingHour=@"19:00";
        }
        else
            hrs.playingHour=@"21:00";
        [hours addObject:hrs];
    }
    for(k=0;k<7;k++){
        DaysPlaying *dp = [[DaysPlaying alloc]init];
        dp.playingHours =[[NSMutableArray alloc]initWithArray:hours];
        if (k==0){
            dp.playingDay=@"Monday";
            NSString *strDate = @"2017-04-03";
            dp.playingDate=[dateFormatter dateFromString:strDate];
        }
        else if (k==1){
            dp.playingDay=@"Tuesday";
            NSString *strDate = @"2017-04-04";
            dp.playingDate=[dateFormatter dateFromString:strDate];
        }
        else if (k==2){
            dp.playingDay=@"Wednesday";
            NSString *strDate = @"2017-04-05";
            dp.playingDate=[dateFormatter dateFromString:strDate];
        }
        else if (k==3){
            dp.playingDay=@"Thursday";
            NSString *strDate = @"2017-04-06";
            dp.playingDate=[dateFormatter dateFromString:strDate];
        }
        else if (k==4){
            dp.playingDay=@"Friday";
            NSString *strDate = @"2017-04-07";
            dp.playingDate=[dateFormatter dateFromString:strDate];
        }
        else if (k==5){
            dp.playingDay=@"Saturday";
            NSString *strDate = @"2017-04-08";
            dp.playingDate=[dateFormatter dateFromString:strDate];
        }
        else if (k==6){
            dp.playingDay=@"Sunday";
            NSString *strDate = @"2017-04-09";
            dp.playingDate=[dateFormatter dateFromString:strDate];
        }
        [playingDays addObject:dp];
    }
    return playingDays;
}

@end
