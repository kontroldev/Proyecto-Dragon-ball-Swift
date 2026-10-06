import ActivityKit
import Foundation

/// La app conserva IDs; las instancias de Activity no cruzan actores.
enum PlaybackLiveActivity {
    static func start(state: AudioPlayerAttributesModel.ContentState) throws -> String? {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return nil }
        return try Activity.request(
            attributes: AudioPlayerAttributesModel(), content: ActivityContent(state: state, staleDate: nil)
        ).id
    }

    static func update(id: String, state: AudioPlayerAttributesModel.ContentState) async {
        let activity = Activity<AudioPlayerAttributesModel>.activities.first { $0.id == id }
        await activity?.update(ActivityContent(state: state, staleDate: nil))
    }

    static func end(id: String) async {
        let activity = Activity<AudioPlayerAttributesModel>.activities.first { $0.id == id }
        await activity?.end(nil, dismissalPolicy: .immediate)
    }
}
