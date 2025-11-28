// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation

#if SKIP
import com.posthog.PostHog
import com.posthog.android.PostHogAndroid
import com.posthog.android.PostHogAndroidConfig
#else
import PostHog
#endif

/// Skip interface to PostHog.
///
/// - See: [https://posthog.com/docs/libraries/ios](https://posthog.com/docs/libraries/ios)
/// - See: [https://posthog.com/docs/libraries/android](https://posthog.com/docs/libraries/android)
public class SkipPostHog {
    public static let shared = SkipPostHog()

    init() {
    }

    public func setup(apiKey: String, host: String) {
        #if SKIP
        PostHogAndroid.setup(ProcessInfo.processInfo.androidContext, PostHogAndroidConfig(apiKey: apiKey, host: host))
        #else
        PostHogSDK.shared.setup(PostHogConfig(apiKey: apiKey, host: host))
        #endif
    }

    public func flush() {
        #if SKIP
        PostHog.flush()
        #else
        PostHogSDK.shared.flush()
        #endif
    }

    /// Opt users out on a per-person basis by calling optOut()
    public func optOut() {
        #if SKIP
        PostHog.optOut()
        #else
        PostHogSDK.shared.optOut()
        #endif
    }

    public func isOptOut() -> Bool {
        #if SKIP
        PostHog.isOptOut()
        #else
        PostHogSDK.shared.isOptOut()
        #endif
    }

    public func optIn() {
        #if SKIP
        PostHog.optIn()
        #else
        PostHogSDK.shared.optIn()
        #endif
    }


    /// To reset the user's ID and anonymous ID, call reset. Usually you would do this right after the user logs out.
    public func reset() {
        #if SKIP
        PostHog.reset()
        #else
        PostHogSDK.shared.reset()
        #endif
    }

    /// Sometimes, you want to assign multiple distinct IDs to a single user. This is helpful when your primary distinct ID is inaccessible. For example, if a distinct ID used on the frontend is not available in your backend. In this case, you can use alias to assign another distinct ID to the same user.
    public func alias(_ alias: String) {
        #if SKIP
        PostHog.alias(alias)
        #else
        PostHogSDK.shared.alias(alias)
        #endif
    }

    /// Super properties are properties associated with events that are set once and then sent with every capture call, be it a $screen, or anything else. They are set using PostHogSDK.shared.register, which takes a properties object as a parameter, and they persist across sessions.
    public func register(_ properties: [String: Any]) {
        #if SKIP
        for (key, value) in properties {
            PostHog.register(key, value)
        }
        #else
        PostHogSDK.shared.register(properties)
        #endif
    }

    /// Super properties persist across sessions so you have to explicitly remove them if they are no longer relevant.
    public func unregister(_ property: String) {
        #if SKIP
        PostHog.unregister(property)
        #else
        PostHogSDK.shared.unregister(property)
        #endif
    }

    // MARK: Feature Flags

    public func reloadFeatureFlags() {
        #if SKIP
        PostHog.reloadFeatureFlags()
        #else
        PostHogSDK.shared.reloadFeatureFlags()
        #endif
    }

    public func isFeatureEnabled(_ featureFlag: String) -> Bool {
        #if SKIP
        PostHog.isFeatureEnabled(featureFlag)
        #else
        PostHogSDK.shared.isFeatureEnabled(featureFlag)
        #endif
    }

    public func getFeatureFlag(_ featureFlag: String) -> Any? {
        #if SKIP
        PostHog.getFeatureFlag(featureFlag)
        #else
        PostHogSDK.shared.getFeatureFlag(featureFlag)
        #endif
    }

    public func getFeatureFlagPayload(_ featureFlag: String) -> Any? {
        #if SKIP
        PostHog.getFeatureFlagPayload(featureFlag)
        #else
        PostHogSDK.shared.getFeatureFlagPayload(featureFlag)
        #endif
    }

    // MARK: Group analytics

    public func group(type: String, key: String, groupProperties: [String: Any]? = nil) {
        #if SKIP
        PostHog.group(type: type, key: key, groupProperties: convertAnyMap(groupProperties))
        #else
        PostHogSDK.shared.group(type: type, key: key, groupProperties: groupProperties)
        #endif
    }

    /// Using identify, you can associate events with specific users. This enables you to gain full insights as to how they're using your product across different sessions, devices, and platforms.
    ///
    /// See: [https://posthog.com/docs/product-analytics/identify](https://posthog.com/docs/product-analytics/identify)
    public func identify(distinctId: String, userProperties: [String: Any]? = nil, userPropertiesSetOnce: [String: Any]? = nil) {
        #if SKIP
        PostHog.identify(distinctId: distinctId, userProperties: convertAnyMap(userProperties), userPropertiesSetOnce: convertAnyMap(userPropertiesSetOnce))
        #else
        PostHogSDK.shared.identify(distinctId, userProperties: userProperties, userPropertiesSetOnce: userPropertiesSetOnce)
        #endif
    }

    /// You can send custom events using capture.
    public func capture(_ event: String, distinctId: String? = nil, properties: [String: Any]? = nil, userProperties: [String: Any]? = nil, userPropertiesSetOnce: [String: Any]? = nil, groups: [String: String]? = nil, timestamp: Date? = nil) {
        #if SKIP
        PostHog.capture(event: event, distinctId: distinctId, properties: convertAnyMap(properties), userProperties: convertAnyMap(userProperties), userPropertiesSetOnce: convertAnyMap(userPropertiesSetOnce), groups: convertStringMap(groups), timestamp: timestamp?.kotlin())
        #else
        PostHogSDK.shared.capture(event, distinctId: distinctId, properties: properties, userProperties: userProperties, userPropertiesSetOnce: userPropertiesSetOnce, groups: groups, timestamp: timestamp)
        #endif
    }

    #if SKIP
    /// Converts the given typed SkipFoundation Dictionary into a Kotlin Map
    func convertAnyMap(_ map: [String: Any]?) -> Map<String, Any>? {
        guard let map else { return nil }
        var mmap: MutableMap<String, Any> = mutableMapOf()
        for (key, value) in map {
            mmap[key] = value.kotlin()
        }
        return mmap
    }

    /// Converts the given typed SkipFoundation Dictionary into a Kotlin Map
    func convertStringMap(_ map: [String: String]?) -> Map<String, String>? {
        guard let map else { return nil }
        var mmap: MutableMap<String, String> = mutableMapOf()
        for (key, value) in map {
            mmap[key] = value
        }
        return mmap
    }
    #endif
}
#endif

