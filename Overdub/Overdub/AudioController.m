//
//  AudioController.m
//  Overdub
//
//  Created by Naoki Tsutsui on 2014/06/14.
//  Copyright (c) 2014年 Naoki Tsutsui. All rights reserved.
//

#import "AudioController.h"
#import <TheAmazingAudioEngine/TheAmazingAudioEngine.h>
#import <TheAmazingAudioEngine/AERecorder.h>


@interface AudioController ()

@property (nonatomic, strong) AEAudioController *audioController;

@property (nonatomic, strong) AERecorder *recorder;
@property (nonatomic, strong) AEAudioFilePlayer *loop0;
@property (nonatomic, strong) AEBlockChannel *blockChannel;

@end


@implementation AudioController
- (void)hoge
{
    NSLog(@"Hoge");
    
    // Create an instance of the audio controller
    AudioStreamBasicDescription audioDescription = [AEAudioController nonInterleaved16BitStereoAudioDescription];
    self.audioController = [[AEAudioController alloc] initWithAudioDescription:audioDescription inputEnabled:YES];


    NSError *error = NULL;
    BOOL result = [_audioController start:&error];
    if ( !result ) {
        // Report error
    }

    NSURL *file = [[NSBundle mainBundle] URLForResource:@"Loop" withExtension:@"m4a"];
    self.loop0 = [AEAudioFilePlayer audioFilePlayerWithURL:file audioController:_audioController error:NULL];
    

    
}

/*
- (void)record:(id)sender {
    if ( _recorder ) {
        [_recorder finishRecording];
        [_audioController removeOutputReceiver:_recorder];
        [_audioController removeInputReceiver:_recorder];
        self.recorder = nil;
        _recordButton.selected = NO;
    } else {
        self.recorder = [[AERecorder alloc] initWithAudioController:_audioController];
        NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Recording.aiff"];
        NSError *error = nil;
        if ( ![_recorder beginRecordingToFileAtPath:path fileType:kAudioFileAIFFType error:&error] ) {
//            [[[UIAlertView alloc] initWithTitle:@"Error"
//                                         message:[NSString stringWithFormat:@"Couldn't start recording: %@", [error localizedDescription]]
//                                        delegate:nil
//                               cancelButtonTitle:nil
//                               otherButtonTitles:@"OK", nil] show];
            self.recorder = nil;
            return;
        }
        
        _recordButton.selected = YES;
        
        [_audioController addOutputReceiver:_recorder];
        [_audioController addInputReceiver:_recorder];
    }
}
*/


- (void)beginRecording
{
    // Init recorder
    self.recorder = [[AERecorder alloc] initWithAudioController:_audioController];
    
    NSString *documentsFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsFolder stringByAppendingPathComponent:@"Recording.aiff"];
    
    // Start the recording process
    NSError *error = NULL;
    if (![_recorder beginRecordingToFileAtPath:filePath fileType:kAudioFileAIFFType error:&error]) {
        // Report error
        return;
    }
    
    // Receive both audio input and audio output. Note that if you're using
    // AEPlaythroughChannel, mentioned above, you may not need to receive the input again.
    [_audioController addInputReceiver:_recorder];
    [_audioController addOutputReceiver:_recorder];
}

// To complete the recording, call [finishRecording](@ref AERecorder::finishRecording).
- (void)endRecording {
    [_audioController removeInputReceiver:_recorder];
    [_audioController removeOutputReceiver:_recorder];
    
    [_recorder finishRecording];
    
    self.recorder = nil;
}


- (void)hogehoge
{
    int _bpm;
    
    // Create the audio controller
    self.audioController = [[AEAudioController alloc]
                            initWithAudioDescription:[AEAudioController nonInterleaved16BitStereoAudioDescription]
                            inputEnabled:NO]; // don't forget to autorelease if you don't use ARC!
    
    
    // Start the audio controller
    NSError *error = NULL;
    
    BOOL result = [_audioController start:&error];
    
    if (!result)
        {
        NSLog(@"_audioController start error: %@", [error localizedDescription]);
        return;
        }
    
    //Set the bpm
    _bpm = 150; // you don't have to round
    
    // The total frames that have passed
    static UInt64 total_frames = 0;
    
    // The next frame that the beat will play on
    static UInt64 next_beat_frame = 0;
    
    // YES if we are currently sounding a beat
    static BOOL making_beat = NO;
    
    // Oscillator specifics - instead you can easily load the samples from cowbell.aif or somesuch
    float oscillatorRate = 440./44100.0;
    __block float oscillatorPosition = 0; // this is outside the block since beats can span calls to the block
    
    // The block that is our metronome
    self.blockChannel = [AEBlockChannel channelWithBlock:^(const AudioTimeStamp *time, UInt32 frames, AudioBufferList *audio) {

        // How many frames pass between the start of each beat
        UInt64 frames_between_beats = 44100 / (_bpm / 60.0);
                         
        // For each frame, count and if we reach the frame that should start a beat, start the beat
        for (int i=0; i<frames; i++) { // frame...by frame...
            // Set a flag that triggers code below to start a beat
            if (next_beat_frame == total_frames) {
                //                NSLog(@"i: %d", i);
                //                NSLog(@"total_frames: %llu", total_frames);
                //                NSLog(@"THUD %llu %llu %llu", next_beat_frame, total_frames, frames_between_beats);
                                 
                making_beat = YES;
                oscillatorPosition = 0; // reset the osc position to make them all sound the same
                next_beat_frame += frames_between_beats;
            }
                             
            // We are making the beat, play a sine-like click (from TheAmazingAudioEngine sample project)
            if (making_beat) {
                float x = oscillatorPosition;
                                 
                // make x in the range 0...1
                x *= x;
                x -= 1.0;
                x *= x;
                
                x *= INT16_MAX;
                x -= INT16_MAX / 2;
                
                oscillatorPosition += oscillatorRate;
                
                if (oscillatorPosition > 1.0) { // turn off the beat, just a quick tick!
                    /* oscillatorPosition -= 2.0; */
                    making_beat = NO;
                }
                
                //actually insert the sound into the buffer
                ((SInt16*)audio->mBuffers[0].mData)[i] = x;
                ((SInt16*)audio->mBuffers[1].mData)[i] = x;
                
                // Wanting to instead insert frames from _loop0 instead
                
                
                // NOTE: We should always make sure we play a minimal number of frames here that prevent overlap
                //       If we the next_beat_frame was only 100 away and we played 200 frames of the metronome sound,
                //       the metronome would never stop and likely create some interesting artifacts. Try setting the
                //       the kMaxTempo to 100000.
            }
                             
            // Increment the count
            total_frames++;
        }
    }];
    
    // Add the block channel to the audio controller
    [_audioController addChannels:[NSArray arrayWithObject:_blockChannel]];
}

@end
