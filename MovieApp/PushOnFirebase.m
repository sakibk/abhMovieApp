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
    NSMutableArray<PlayingHall*> *playingHalls= [[NSMutableArray alloc] init];
    playingDays = [self getPlayingDays];
    playingHalls = [self getPlayingHalls];
    int intCount = 0;
    for(i = 0;i<15;i++){
        RLMovie *mv = [movies objectAtIndex:i];
        if([mv.movieCast count] && [mv.genres count] && [mv.movieCast count]){
            if(intCount<10){
                NSString *str =[NSString stringWithFormat:@"%d",intCount];
                NSString *rate = [NSString stringWithFormat:@"%@",mv.rating];
                NSMutableString *gens=[[NSMutableString alloc] init];
                int j;
                for(j=0; j<[mv.genres count];j++){
                    RLMGenre *g = [mv.genres objectAtIndex:j];
                    [gens appendString:g.genreName];
                    if(j!=[mv.genres count]-1){
                        [gens appendString:@"/"];
                    }
                }
                [[[ref child:@"Movies"] child:str]
                 setValue:@{@"id": [NSString stringWithFormat:@"%@",mv.movieID],
                            @"title": [NSString stringWithFormat:@"%@",mv.title],
                            @"overview": [NSString stringWithFormat:@"%@",mv.overview],
                            @"poster_path": [NSString stringWithFormat:@"%@",mv.posterPath],
                            @"backdrop_path": [NSString stringWithFormat:@"%@",mv.backdropPath],
                            @"release_date": [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:mv.releaseDate]],
                            @"ticket_price": [NSString stringWithFormat:@"%@",@"20.00"],
                            @"vote_average":[NSString stringWithFormat:@"%@",rate],
                            @"genres": [NSString stringWithFormat:@"%@", gens]}];
                for(j=0;j<[playingDays count];j++){
                    NSString *jstr = [NSString stringWithFormat:@"%d",j];
                    DaysPlaying *dp = [playingDays objectAtIndex:j];
                    [[[[[ref child:@"Movies"] child:str] child:@"days_playing"] child:jstr]
                     setValue:@{@"date": [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:dp.playingDate]],
                                @"day": [NSString stringWithFormat:@"%@",dp.playingDay]}];
                    
                    int k;
                    for(k=0;k<[dp.playingHours count];k++){
                        Hours *hr =[dp.playingHours objectAtIndex:k];
                        NSString *kstr = [NSString stringWithFormat:@"%d",k];
                        [[[[[[[ref child:@"Movies"] child:str] child:@"days_playing"] child:jstr]child:@"hours"]child:kstr]
                         setValue:@{@"time": [NSString stringWithFormat:@"%@",hr.playingHour],
                                    @"hall_id":[NSString stringWithFormat:@"%d",intCount]}];
                    }
                }
                PlayingHall *ph = [playingHalls objectAtIndex:intCount];
                int y;
                for(y=0;y<[ph.daysPlaying count];y++){
                    DaysPlaying *dp = [ph.daysPlaying objectAtIndex:y];
                    NSString *ystr=[NSString stringWithFormat:@"%d",y];
                    [[[[ref child:@"Halls"] child:str] child:ystr]
                     setValue:@{@"day": [NSString stringWithFormat:@"%@",dp.playingDay],
                                @"date": [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:dp.playingDate]]}];
                    int h;
                    for(h= 0;h<[dp.playingHours count];h++){
                        Hours *ph =[dp.playingHours objectAtIndex:h];
                        NSString *hstr = [NSString stringWithFormat:@"%d",h];
                        [[[[[ref child:@"Halls"] child:str] child:ystr] child:hstr]
                         setValue:@{@"time": [NSString stringWithFormat:@"%@",ph.playingHour]}];
                        int l;
                        for(l=0;l<[ph.seats count]; l++){
                            Seats *st = [ph.seats objectAtIndex:l];
                            NSString *lstr = [NSString stringWithFormat:@"%d",l];
                            [[[[[[[ref child:@"Halls"] child:str]child:ystr] child:hstr]  child:@"Seats"] child:lstr]
                             setValue:@{@"row": [NSString stringWithFormat:@"%@%@",st.row,st.seatNum],
                                        @"taken": @"NO"}];
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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    int k;
    for(k=0;k<2;k++){
        Hours *hrs = [[Hours alloc]init];
        if (k==0) {
            hrs.playingHour=@"19:00";
        }
        else if (k==1){
            hrs.playingHour=@"21:00";
        }
        [hours addObject:hrs];
    }
    for(k=0;k<7;k++){
        DaysPlaying *dp = [[DaysPlaying alloc]init];
        dp.playingHours=[[NSMutableArray alloc]initWithArray:hours];
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

+(NSMutableArray<PlayingHall*>*)getPlayingHalls{
    NSMutableArray<Seats*>*seats = [[NSMutableArray alloc]init];
    NSMutableArray<PlayingHall*> *playingHalls=[[NSMutableArray alloc]init];
    NSMutableArray<DaysPlaying *> *playingDays = [[NSMutableArray alloc]init];
    NSMutableArray<Hours *> *playingHours = [[NSMutableArray alloc]init];
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
    int j;
    for(j=0;j<2;j++){
        Hours *ph =[[Hours alloc]init];
        ph.seats = [[NSMutableArray alloc]initWithArray:seats];
        if (j==0 ) {
            ph.playingHour=@"19:00";
        }else{
            ph.playingHour =@"21:00";
        }
        [playingHours addObject:ph];
    }
    for(k=0;k<7;k++){
        DaysPlaying *dp = [[DaysPlaying alloc]init];
        dp.playingHours=[[NSMutableArray alloc]initWithArray:playingHours];
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
    int i;
    for(i=0; i<10;i++){
        
        PlayingHall *ph =[[PlayingHall alloc]init];
        ph.daysPlaying = [[NSMutableArray alloc]initWithArray:playingDays];
        ph.playingHallID =[NSNumber numberWithInt:i];
        int j;
        for(j=0;j<2;j++){
            
        }
        [playingHalls addObject:ph];
    }
    
    return playingHalls;
}

@end
