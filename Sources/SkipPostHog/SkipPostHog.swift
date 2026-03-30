// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
import Foundation

#if SKIP
import com.posthog.PostHog
import com.posthog.android.PostHogAndroid
import com.posthog.android.PostHogAndroidConfig
import com.posthog.FeatureFlagResult
import com.posthog.PersonProfiles
import com.posthog.PostHogOnFeatureFlags
#else
import PostHog
#endif

/// Skip interface to PostHog, which matches the API surface of the PostHog iOS SDK.
///
/// - See: [https://posthog.com/docs/libraries/ios](https://posthog.com/docs/libraries/ios)
/// - See: [https://posthog.com/docs/libraries/android](https://posthog.com/docs/libraries/android)
public class PostHogSDK {
    public static let shared = PostHogSDK()

    init() {
    }

    public func setup(_ config: PostHogConfig) {
        #if !SKIP
        PostHog.PostHogSDK.shared.setup(config.platformValue)
        #else
        PostHogAndroid.setup(ProcessInfo.processInfo.androidContext, config.platformValue)
        #endif
    }

    public func close() {
        #if !SKIP
        PostHog.PostHogSDK.shared.close()
        #else
        PostHog.close()
        #endif
    }

    public func flush() {
        #if !SKIP
        PostHog.PostHogSDK.shared.flush()
        #else
        PostHog.flush()
        #endif
    }

    public func getDistinctId() -> String {
        #if !SKIP
        PostHog.PostHogSDK.shared.getDistinctId()
        #else
        PostHog.distinctId()
        #endif
    }

    /// Returns the anonymous ID for the current user.
    public func getAnonymousId() -> String {
        #if !SKIP
        PostHog.PostHogSDK.shared.getAnonymousId()
        #else
        PostHog.distinctId() // Android SDK does not expose a separate anonymous ID; distinct ID is used
        #endif
    }

    public func getSessionId() -> String? {
        #if !SKIP
        PostHog.PostHogSDK.shared.getSessionId()
        #else
        PostHog.getSessionId()?.toString() // UUID
        #endif
    }

    public func startSession() {
        #if !SKIP
        PostHog.PostHogSDK.shared.startSession()
        #else
        PostHog.startSession()
        #endif
    }

    public func endSession() {
        #if !SKIP
        PostHog.PostHogSDK.shared.endSession()
        #else
        PostHog.endSession()
        #endif
    }

    /// Opt users out on a per-person basis by calling optOut()
    public func optOut() {
        #if !SKIP
        PostHog.PostHogSDK.shared.optOut()
        #else
        PostHog.optOut()
        #endif
    }

    public func isOptOut() -> Bool {
        #if !SKIP
        PostHog.PostHogSDK.shared.isOptOut()
        #else
        PostHog.isOptOut()
        #endif
    }

    public func optIn() {
        #if !SKIP
        PostHog.PostHogSDK.shared.optIn()
        #else
        PostHog.optIn()
        #endif
    }

    /// To reset the user's ID and anonymous ID, call reset. Usually you would do this right after the user logs out.
    public func reset() {
        #if !SKIP
        PostHog.PostHogSDK.shared.reset()
        #else
        PostHog.reset()
        #endif
    }

    /// Sometimes, you want to assign multiple distinct IDs to a single user. This is helpful when your primary distinct ID is inaccessible. For example, if a distinct ID used on the frontend is not available in your backend. In this case, you can use alias to assign another distinct ID to the same user.
    public func alias(_ alias: String) {
        #if !SKIP
        PostHog.PostHogSDK.shared.alias(alias)
        #else
        PostHog.alias(alias)
        #endif
    }

    /// Super properties are properties associated with events that are set once and then sent with every capture call, be it a $screen, or anything else. They are set using PostHogSDK.shared.register, which takes a properties object as a parameter, and they persist across sessions.
    public func register(_ properties: [String: Any]) {
        #if !SKIP
        PostHog.PostHogSDK.shared.register(properties)
        #else
        for (key, value) in properties {
            PostHog.register(key, value)
        }
        #endif
    }

    /// Super properties persist across sessions so you have to explicitly remove them if they are no longer relevant.
    public func unregister(_ property: String) {
        #if !SKIP
        PostHog.PostHogSDK.shared.unregister(property)
        #else
        PostHog.unregister(property)
        #endif
    }

    // MARK: Feature Flags

    public func reloadFeatureFlags() {
        #if !SKIP
        PostHog.PostHogSDK.shared.reloadFeatureFlags()
        #else
        PostHog.reloadFeatureFlags()
        #endif
    }

    public func isFeatureEnabled(_ featureFlag: String) -> Bool {
        #if !SKIP
        PostHog.PostHogSDK.shared.isFeatureEnabled(featureFlag)
        #else
        PostHog.isFeatureEnabled(featureFlag)
        #endif
    }

    public func getFeatureFlag(_ featureFlag: String) -> Any? {
        #if !SKIP
        PostHog.PostHogSDK.shared.getFeatureFlag(featureFlag)
        #else
        PostHog.getFeatureFlag(featureFlag)
        #endif
    }

    public func getFeatureFlagPayload(_ featureFlag: String) -> Any? {
        #if !SKIP
        PostHog.PostHogSDK.shared.getFeatureFlagPayload(featureFlag)
        #else
        PostHog.getFeatureFlagPayload(featureFlag)
        #endif
    }

    // MARK: Group analytics

    public func group(type: String, key: String, groupProperties: [String: Any]? = nil) {
        #if !SKIP
        PostHog.PostHogSDK.shared.group(type: type, key: key, groupProperties: groupProperties)
        #else
        PostHog.group(type: type, key: key, groupProperties: convertAnyMap(groupProperties))
        #endif
    }

    /// Using identify, you can associate events with specific users. This enables you to gain full insights as to how they're using your product across different sessions, devices, and platforms.
    ///
    /// See: [https://posthog.com/docs/product-analytics/identify](https://posthog.com/docs/product-analytics/identify)
    public func identify(distinctId: String, userProperties: [String: Any]? = nil, userPropertiesSetOnce: [String: Any]? = nil) {
        #if !SKIP
        PostHog.PostHogSDK.shared.identify(distinctId, userProperties: userProperties, userPropertiesSetOnce: userPropertiesSetOnce)
        #else
        PostHog.identify(distinctId: distinctId, userProperties: convertAnyMap(userProperties), userPropertiesSetOnce: convertAnyMap(userPropertiesSetOnce))
        #endif
    }

    /// You can send custom events using capture.
    public func capture(_ event: String, distinctId: String? = nil, properties: [String: Any]? = nil, userProperties: [String: Any]? = nil, userPropertiesSetOnce: [String: Any]? = nil, groups: [String: String]? = nil, timestamp: Date? = nil) {
        #if !SKIP
        PostHog.PostHogSDK.shared.capture(event, distinctId: distinctId, properties: properties, userProperties: userProperties, userPropertiesSetOnce: userPropertiesSetOnce, groups: groups, timestamp: timestamp)
        #else
        PostHog.capture(event: event, distinctId: distinctId, properties: convertAnyMap(properties), userProperties: convertAnyMap(userProperties), userPropertiesSetOnce: convertAnyMap(userPropertiesSetOnce), groups: convertStringMap(groups), timestamp: timestamp?.kotlin())
        #endif
    }

    // MARK: Screen Tracking

    /// Track a screen view event.
    public func screen(_ screenTitle: String, properties: [String: Any]? = nil) {
        #if !SKIP
        PostHog.PostHogSDK.shared.screen(screenTitle, properties: properties)
        #else
        PostHog.screen(screenTitle: screenTitle, properties: convertAnyMap(properties))
        #endif
    }

    // MARK: Debug

    /// Enable or disable debug logging.
    public func debug(_ enabled: Bool = true) {
        #if !SKIP
        PostHog.PostHogSDK.shared.debug(enabled)
        #else
        PostHog.debug(enable: enabled)
        #endif
    }

    // MARK: Person Properties

    /// Set person properties on the current user without creating an identify event.
    public func setPersonProperties(userPropertiesToSet: [String: Any]? = nil, userPropertiesToSetOnce: [String: Any]? = nil) {
        #if SKIP
        PostHog.setPersonProperties(userPropertiesToSet: convertAnyMap(userPropertiesToSet), userPropertiesToSetOnce: convertAnyMap(userPropertiesToSetOnce))
        #else
        // Equivalent to setPersonProperties: re-identify the current user with the given properties
        let distinctId = PostHog.PostHogSDK.shared.getDistinctId()
        PostHog.PostHogSDK.shared.identify(distinctId, userProperties: userPropertiesToSet, userPropertiesSetOnce: userPropertiesToSetOnce)
        #endif
    }

    // MARK: Feature Flag Overloads

    /// Reload feature flags from the server with a completion callback.
    public func reloadFeatureFlags(_ callback: @escaping () -> Void) {
        #if !SKIP
        PostHog.PostHogSDK.shared.reloadFeatureFlags(callback)
        #else
        PostHog.reloadFeatureFlags(onFeatureFlags: PostHogOnFeatureFlags { callback() })
        #endif
    }

    /// Check if a feature flag is enabled, optionally controlling whether a `$feature_flag_called` event is sent.
    public func isFeatureEnabled(_ featureFlag: String, sendFeatureFlagEvent: Bool) -> Bool {
        #if SKIP
        PostHog.isFeatureEnabled(key: featureFlag, sendFeatureFlagEvent: sendFeatureFlagEvent)
        #else
        // The sendFeatureFlagEvent overload may not be available in all iOS SDK versions
        PostHog.PostHogSDK.shared.isFeatureEnabled(featureFlag)
        #endif
    }

    /// Get the value of a feature flag, optionally controlling whether a `$feature_flag_called` event is sent.
    public func getFeatureFlag(_ featureFlag: String, sendFeatureFlagEvent: Bool) -> Any? {
        #if SKIP
        PostHog.getFeatureFlag(key: featureFlag, sendFeatureFlagEvent: sendFeatureFlagEvent)
        #else
        // The sendFeatureFlagEvent overload may not be available in all iOS SDK versions
        PostHog.PostHogSDK.shared.getFeatureFlag(featureFlag)
        #endif
    }

    /// Get a structured feature flag result including enabled state, variant, and payload.
    public func getFeatureFlagResult(_ featureFlag: String) -> PostHogFeatureFlagResult? {
        #if SKIP
        guard let result = PostHog.getFeatureFlagResult(key: featureFlag) else { return nil }
        return PostHogFeatureFlagResult(result)
        #else
        let flagValue = PostHog.PostHogSDK.shared.getFeatureFlag(featureFlag)
        guard flagValue != nil else { return nil }
        let enabled = PostHog.PostHogSDK.shared.isFeatureEnabled(featureFlag)
        let variant = flagValue as? String
        let payload = PostHog.PostHogSDK.shared.getFeatureFlagPayload(featureFlag)
        return PostHogFeatureFlagResult(key: featureFlag, enabled: enabled, variant: variant, payload: payload)
        #endif
    }

    /// Get a structured feature flag result, optionally controlling whether a `$feature_flag_called` event is sent.
    public func getFeatureFlagResult(_ featureFlag: String, sendFeatureFlagEvent: Bool) -> PostHogFeatureFlagResult? {
        #if SKIP
        guard let result = PostHog.getFeatureFlagResult(key: featureFlag, sendFeatureFlagEvent: sendFeatureFlagEvent) else { return nil }
        return PostHogFeatureFlagResult(result)
        #else
        // Fallback: sendFeatureFlagEvent not available on all iOS SDK versions
        return getFeatureFlagResult(featureFlag)
        #endif
    }

    // MARK: Person Properties for Flags

    /// Set person properties used for local feature flag evaluation.
    public func setPersonPropertiesForFlags(_ properties: [String: Any], reloadFeatureFlags: Bool = true) {
        #if !SKIP
        PostHog.PostHogSDK.shared.setPersonPropertiesForFlags(properties, reloadFeatureFlags: reloadFeatureFlags)
        #else
        PostHog.setPersonPropertiesForFlags(userProperties: convertAnyMap(properties)!, reloadFeatureFlags: reloadFeatureFlags)
        #endif
    }

    /// Reset person properties used for local feature flag evaluation.
    public func resetPersonPropertiesForFlags(reloadFeatureFlags: Bool = true) {
        #if !SKIP
        PostHog.PostHogSDK.shared.resetPersonPropertiesForFlags(reloadFeatureFlags: reloadFeatureFlags)
        #else
        PostHog.resetPersonPropertiesForFlags(reloadFeatureFlags: reloadFeatureFlags)
        #endif
    }

    // MARK: Group Properties for Flags

    /// Set group properties used for local feature flag evaluation.
    public func setGroupPropertiesForFlags(_ groupType: String, properties: [String: Any], reloadFeatureFlags: Bool = true) {
        #if !SKIP
        PostHog.PostHogSDK.shared.setGroupPropertiesForFlags(groupType, properties: properties, reloadFeatureFlags: reloadFeatureFlags)
        #else
        PostHog.setGroupPropertiesForFlags(type: groupType, groupProperties: convertAnyMap(properties)!, reloadFeatureFlags: reloadFeatureFlags)
        #endif
    }

    /// Reset all group properties used for local feature flag evaluation.
    public func resetGroupPropertiesForFlags(reloadFeatureFlags: Bool = true) {
        #if !SKIP
        PostHog.PostHogSDK.shared.resetGroupPropertiesForFlags(reloadFeatureFlags: reloadFeatureFlags)
        #else
        PostHog.resetGroupPropertiesForFlags(reloadFeatureFlags: reloadFeatureFlags)
        #endif
    }

    /// Reset group properties for a specific group type used for local feature flag evaluation.
    public func resetGroupPropertiesForFlags(_ groupType: String, reloadFeatureFlags: Bool = true) {
        #if !SKIP
        PostHog.PostHogSDK.shared.resetGroupPropertiesForFlags(groupType, reloadFeatureFlags: reloadFeatureFlags)
        #else
        PostHog.resetGroupPropertiesForFlags(type: groupType, reloadFeatureFlags: reloadFeatureFlags)
        #endif
    }

    // MARK: Session Replay

    /// Whether a session is currently active.
    public func isSessionActive() -> Bool {
        #if SKIP
        PostHog.isSessionActive()
        #elseif os(iOS)
        // iOS SDK doesn't expose isSessionActive directly; check if session ID exists
        PostHog.PostHogSDK.shared.getSessionId() != nil
        #else
        false
        #endif
    }

    // MARK: Capture Exception

    /// Capture an exception/error as a PostHog event.
    ///
    /// On Android, the error is wrapped in a `RuntimeException`.
    /// On iOS, this method is not available (the PostHog iOS SDK's `captureException` is marked `@_spi`).
    /// Use `capture("$exception", properties: ...)` as an alternative on iOS.
    public func captureException(_ error: Error, properties: [String: Any]? = nil) {
        #if SKIP
        // SKIP INSERT: com.posthog.PostHog.captureException(java.lang.RuntimeException(error.description), convertAnyMap(properties) ?: emptyMap())
        #else
        // captureException is @_spi on iOS; use capture instead
        var props = properties ?? [:]
        props["$exception_type"] = "\(type(of: error))"
        props["$exception_message"] = error.localizedDescription
        PostHog.PostHogSDK.shared.capture("$exception", properties: props)
        #endif
    }

    // MARK: Feature Flag Interaction Tracking

    /// Track when a user views a feature controlled by a feature flag.
    ///
    /// - Parameters:
    ///   - flag: The feature flag key.
    ///   - flagVariant: The variant of the flag, if applicable.
    public func captureFeatureView(flag: String, flagVariant: String? = nil) {
        #if SKIP
        PostHog.captureFeatureView(flag: flag, flagVariant: flagVariant)
        #else
        PostHog.PostHogSDK.shared.captureFeatureView(flag: flag, flagVariant: flagVariant)
        #endif
    }

    /// Track when a user interacts with a feature controlled by a feature flag.
    ///
    /// - Parameters:
    ///   - flag: The feature flag key.
    ///   - flagVariant: The variant of the flag, if applicable.
    public func captureFeatureInteraction(flag: String, flagVariant: String? = nil) {
        #if SKIP
        PostHog.captureFeatureInteraction(flag: flag, flagVariant: flagVariant)
        #else
        PostHog.PostHogSDK.shared.captureFeatureInteraction(flag: flag, flagVariant: flagVariant)
        #endif
    }

    // MARK: Session Replay

    /// Whether session replay is currently recording.
    public func isSessionReplayActive() -> Bool {
        #if SKIP
        PostHog.isSessionReplayActive()
        #elseif os(iOS)
        PostHog.PostHogSDK.shared.isSessionReplayActive()
        #else
        false
        #endif
    }

    /// Start session recording. If `resumeCurrent` is true, the current session is resumed rather than starting a new one.
    public func startSessionRecording(resumeCurrent: Bool = false) {
        #if SKIP
        PostHog.startSessionReplay(resumeCurrent: resumeCurrent)
        #elseif os(iOS)
        PostHog.PostHogSDK.shared.startSessionRecording(resumeCurrent: resumeCurrent)
        #endif
    }

    /// Stop session recording.
    public func stopSessionRecording() {
        #if SKIP
        PostHog.stopSessionReplay()
        #elseif os(iOS)
        PostHog.PostHogSDK.shared.stopSessionRecording()
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


/// Skip interface to `PostHogConfig`, which matches the API surface of the PostHog iOS SDK.
///
/// - See: [https://posthog.com/docs/libraries/ios](https://posthog.com/docs/libraries/ios)
/// - See: [https://posthog.com/docs/libraries/android](https://posthog.com/docs/libraries/android)
public class PostHogConfig {
    #if !SKIP
    let platformValue: PostHog.PostHogConfig
    #else
    let platformValue: PostHogAndroidConfig
    #endif

    public init(apiKey: String) {
        #if !SKIP
        self.platformValue = PostHog.PostHogConfig(apiKey: apiKey)
        #else
        self.platformValue = PostHogAndroidConfig(apiKey: apiKey)
        #endif
    }

    public init(apiKey: String, host: String) {
        #if !SKIP
        self.platformValue = PostHog.PostHogConfig(apiKey: apiKey, host: host)
        #else
        self.platformValue = PostHogAndroidConfig(apiKey: apiKey, host: host)
        #endif
    }

    public var host: URL {
        #if !SKIP
        self.platformValue.host
        #else
        URL(string: (self.platformValue.host.hasPrefix("http") ? "" : "https://") + self.platformValue.host)!
        #endif
    }

    public var apiKey: String {
        self.platformValue.apiKey
    }

    public var flushAt: Int {
        get {
            #if !SKIP
            self.platformValue.flushAt
            #else
            self.platformValue.flushAt
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.flushAt = newValue
            #else
            self.platformValue.flushAt = newValue
            #endif
        }
    }

    public var maxQueueSize: Int {
        get {
            #if !SKIP
            self.platformValue.maxQueueSize
            #else
            self.platformValue.maxQueueSize
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.maxQueueSize = newValue
            #else
            self.platformValue.maxQueueSize = newValue
            #endif
        }
    }

    public var maxBatchSize: Int {
        get {
            #if !SKIP
            self.platformValue.maxBatchSize
            #else
            self.platformValue.maxBatchSize
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.maxBatchSize = newValue
            #else
            self.platformValue.maxBatchSize = newValue
            #endif
        }
    }

    public var flushIntervalSeconds: TimeInterval {
        get {
            #if !SKIP
            self.platformValue.flushIntervalSeconds
            #else
            TimeInterval(self.platformValue.flushIntervalSeconds) // Int on Android
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.flushIntervalSeconds = newValue
            #else
            self.platformValue.flushIntervalSeconds = Int(newValue) // Int on Android
            #endif
        }
    }

    public var sendFeatureFlagEvent: Bool {
        get {
            #if !SKIP
            self.platformValue.sendFeatureFlagEvent
            #else
            self.platformValue.sendFeatureFlagEvent
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.sendFeatureFlagEvent = newValue
            #else
            self.platformValue.sendFeatureFlagEvent = newValue
            #endif
        }
    }

    public var preloadFeatureFlags: Bool {
        get {
            #if !SKIP
            self.platformValue.preloadFeatureFlags
            #else
            self.platformValue.preloadFeatureFlags
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.preloadFeatureFlags = newValue
            #else
            self.platformValue.preloadFeatureFlags = newValue
            #endif
        }
    }

    public var remoteConfig: Bool {
        get {
            #if !SKIP
            self.platformValue.remoteConfig
            #else
            self.platformValue.remoteConfig
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.remoteConfig = newValue
            #else
            self.platformValue.remoteConfig = newValue
            #endif
        }
    }

    public var captureApplicationLifecycleEvents: Bool {
        get {
            #if !SKIP
            self.platformValue.captureApplicationLifecycleEvents
            #else
            self.platformValue.captureApplicationLifecycleEvents
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.captureApplicationLifecycleEvents = newValue
            #else
            self.platformValue.captureApplicationLifecycleEvents = newValue
            #endif
        }
    }

    public var captureScreenViews: Bool {
        get {
            #if !SKIP
            self.platformValue.captureScreenViews
            #else
            self.platformValue.captureScreenViews
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.captureScreenViews = newValue
            #else
            self.platformValue.captureScreenViews = newValue
            #endif
        }
    }

    public var enableSwizzling: Bool {
        get {
            #if !SKIP
            self.platformValue.enableSwizzling
            #else
            false
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.enableSwizzling = newValue
            #else
            // no-op: Android doesn't support swizzling
            #endif
        }
    }

    /// Whether to capture element interactions (autocapture). iOS only.
    public var captureElementInteractions: Bool {
        get {
            #if os(iOS) && !SKIP
            self.platformValue.captureElementInteractions
            #else
            false
            #endif
        }

        set {
            #if os(iOS) && !SKIP
            self.platformValue.captureElementInteractions = newValue
            #endif
        }
    }

    public var debug: Bool {
        get {
            #if !SKIP
            self.platformValue.debug
            #else
            self.platformValue.debug
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.debug = newValue
            #else
            self.platformValue.debug = newValue
            #endif
        }
    }

    public var optOut: Bool {
        get {
            #if !SKIP
            self.platformValue.optOut
            #else
            self.platformValue.optOut
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.optOut = newValue
            #else
            self.platformValue.optOut = newValue
            #endif
        }
    }

    public var reuseAnonymousId: Bool {
        get {
            #if !SKIP
            self.platformValue.reuseAnonymousId
            #else
            self.platformValue.reuseAnonymousId
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.reuseAnonymousId = newValue
            #else
            self.platformValue.reuseAnonymousId = newValue
            #endif
        }
    }

    public var personProfiles: PostHogPersonProfiles {
        get {
            #if !SKIP
            switch self.platformValue.personProfiles {
            case .never: return .never
            case .always: return .always
            case .identifiedOnly: return .identifiedOnly
            @unknown default: return .identifiedOnly
            }
            #else
            let p = self.platformValue.personProfiles
            if p == PersonProfiles.NEVER { return .never }
            if p == PersonProfiles.ALWAYS { return .always }
            return .identifiedOnly
            #endif
        }

        set {
            #if !SKIP
            switch newValue {
            case .never: self.platformValue.personProfiles = .never
            case .always: self.platformValue.personProfiles = .always
            case .identifiedOnly: self.platformValue.personProfiles = .identifiedOnly
            }
            #else
            switch newValue {
            case .never: self.platformValue.personProfiles = PersonProfiles.NEVER
            case .always: self.platformValue.personProfiles = PersonProfiles.ALWAYS
            case .identifiedOnly: self.platformValue.personProfiles = PersonProfiles.IDENTIFIED_ONLY
            }
            #endif
        }
    }

    public var sessionReplay: Bool {
        get {
            #if SKIP
            self.platformValue.sessionReplay
            #elseif os(iOS)
            self.platformValue.sessionReplay
            #else
            false
            #endif
        }

        set {
            #if SKIP
            self.platformValue.sessionReplay = newValue
            #elseif os(iOS)
            self.platformValue.sessionReplay = newValue
            #endif
        }
    }

    public var setDefaultPersonProperties: Bool {
        get {
            #if !SKIP
            self.platformValue.setDefaultPersonProperties
            #else
            self.platformValue.setDefaultPersonProperties
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.setDefaultPersonProperties = newValue
            #else
            self.platformValue.setDefaultPersonProperties = newValue
            #endif
        }
    }

    public var surveys: Bool {
        get {
            #if SKIP
            self.platformValue.surveys
            #elseif os(iOS)
            if #available(iOS 15.0, *) {
                return self.platformValue.surveys
            } else {
                return false
            }
            #else
            false
            #endif
        }

        set {
            #if SKIP
            self.platformValue.surveys = newValue
            #elseif os(iOS)
            if #available(iOS 15.0, *) {
                self.platformValue.surveys = newValue
            }
            #endif
        }
    }

}

/// Person profile processing mode.
///
/// Controls when PostHog creates person profiles for events.
public enum PostHogPersonProfiles: Int {
    /// No person profiles are created for any event.
    case never = 0
    /// Person data is processed for all events.
    case always = 1
    /// Person profiles are only created on `identify`, `alias`, and `group` calls.
    case identifiedOnly = 2
}

/// A structured result from a feature flag evaluation, including enabled state, variant, and payload.
public class PostHogFeatureFlagResult {
    /// The feature flag key.
    public let key: String
    /// Whether the feature flag is enabled.
    public let enabled: Bool
    /// The variant name for multivariate flags, or `nil`.
    public let variant: String?
    /// The JSON payload associated with the flag, or `nil`.
    public let payload: Any?

    init(key: String, enabled: Bool, variant: String?, payload: Any?) {
        self.key = key
        self.enabled = enabled
        self.variant = variant
        self.payload = payload
    }

    #if SKIP
    init(_ result: FeatureFlagResult) {
        self.key = result.key
        self.enabled = result.enabled
        self.variant = result.variant
        self.payload = result.payload
    }
    #endif
}

#if SKIP
extension PostHogConfig: KotlinConverting<PostHogAndroidConfig> {
    // SKIP @nobridge
    public override func kotlin(nocopy: Bool = false) -> PostHogAndroidConfig {
        return platformValue
    }
}
#endif
#endif
