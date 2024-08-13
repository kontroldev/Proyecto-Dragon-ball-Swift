//
//  AudioPlayerActivityUseCaseViewModel.swift
//  DragonBallSwift
//
//  Created by Manuel Bermudo on 9/8/24.
//

import ActivityKit
import Foundation

final class AudioPlayerActivityUseCaseViewModel {
    
    static func startActivity(songName: String) throws -> String {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return "" }
        let initialState = AudioPlayerAttributesModel.ContentState(songName: songName, isPlaying: false)
        
        let futureDate = .now + 3600
        let activityContent = ActivityContent(state: initialState, staleDate: futureDate)
        
        let atributes = AudioPlayerAttributesModel()
        
        do{
            let activity = try Activity.request(attributes: atributes, content: activityContent)
            return activity.id
        } catch {
            throw error
        }
    }
    static func updateActivity(activityIdentifier: String, songName: String, isPlaying: Bool, url: URL?, currentTime: Double, duration: Double) async {

        let updateContentState = AudioPlayerAttributesModel.ContentState(songName: songName, currentTime: currentTime, duration: duration, isPlaying: isPlaying)
        let activity = Activity<AudioPlayerAttributesModel>.activities.first(where: { $0.id == activityIdentifier })
        let activityContent = ActivityContent(state: updateContentState, staleDate: .now)
        
        await activity?.update(activityContent)
        }
    static func endActivity(withActivityIdentifier activityIdentifier: String) async {
        let value = Activity<AudioPlayerAttributesModel>.activities.first(where: { $0.id == activityIdentifier})
        await value?.end(nil)
    }
}
