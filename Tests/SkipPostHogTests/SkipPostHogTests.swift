// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
import OSLog
import Foundation
@testable import SkipPostHog

let logger: Logger = Logger(subsystem: "SkipPostHog", category: "Tests")

@available(macOS 13, *)
final class SkipPostHogTests: XCTestCase {
    func testSkipPostHog() throws {
        PostHogSDK.shared.setup(PostHogConfig(apiKey: ""))
    }

    // MARK: - API Surface Validation Tests
    // These tests validate that the API compiles identically on Swift and Kotlin.
    // They are guarded by `if false` so they type-check but never execute.

    func testPostHogConfigAPI() throws {
        if false {
            // Initializers
            let config1 = PostHogConfig(apiKey: "test-key")
            let config2 = PostHogConfig(apiKey: "test-key", host: "https://eu.posthog.com")

            // Read-only properties
            let _: String = config1.apiKey
            let _: URL = config1.host
            let _ = config2

            // Read-write properties
            var config = PostHogConfig(apiKey: "key")
            config.flushAt = 10
            let _: Int = config.flushAt

            config.maxQueueSize = 500
            let _: Int = config.maxQueueSize

            config.maxBatchSize = 25
            let _: Int = config.maxBatchSize

            config.flushIntervalSeconds = 60.0
            let _: TimeInterval = config.flushIntervalSeconds

            config.sendFeatureFlagEvent = false
            let _: Bool = config.sendFeatureFlagEvent

            config.preloadFeatureFlags = false
            let _: Bool = config.preloadFeatureFlags

            config.remoteConfig = false
            let _: Bool = config.remoteConfig

            config.captureApplicationLifecycleEvents = false
            let _: Bool = config.captureApplicationLifecycleEvents

            config.captureScreenViews = false
            let _: Bool = config.captureScreenViews

            config.enableSwizzling = false
            let _: Bool = config.enableSwizzling

            config.debug = true
            let _: Bool = config.debug

            config.optOut = true
            let _: Bool = config.optOut

            config.reuseAnonymousId = true
            let _: Bool = config.reuseAnonymousId

            config.personProfiles = .identifiedOnly
            config.personProfiles = .always
            config.personProfiles = .never
            let _: PostHogPersonProfiles = config.personProfiles

            config.sessionReplay = true
            let _: Bool = config.sessionReplay

            config.setDefaultPersonProperties = false
            let _: Bool = config.setDefaultPersonProperties

            config.surveys = true
            let _: Bool = config.surveys
        }
    }

    func testPostHogSDKLifecycleAPI() throws {
        if false {
            let sdk = PostHogSDK.shared

            // Setup and lifecycle
            sdk.setup(PostHogConfig(apiKey: "key"))
            sdk.close()
            sdk.flush()

            // Debug
            sdk.debug()
            sdk.debug(true)
            sdk.debug(false)
        }
    }

    func testPostHogSDKIdentityAPI() throws {
        if false {
            let sdk = PostHogSDK.shared

            // Identity
            let _: String = sdk.getDistinctId()
            let _: String? = sdk.getSessionId()

            sdk.identify(distinctId: "user-123")
            sdk.identify(distinctId: "user-123", userProperties: ["name": "Test"])
            sdk.identify(distinctId: "user-123", userProperties: ["name": "Test"], userPropertiesSetOnce: ["created": "2024-01-01"])

            sdk.alias("other-id")
            sdk.reset()

            // Person properties
            sdk.setPersonProperties(userPropertiesToSet: ["key": "value"])
            sdk.setPersonProperties(userPropertiesToSet: ["key": "value"], userPropertiesToSetOnce: ["once": "val"])
            sdk.setPersonProperties(userPropertiesToSet: nil, userPropertiesToSetOnce: nil)
        }
    }

    func testPostHogSDKCaptureAPI() throws {
        if false {
            let sdk = PostHogSDK.shared

            // Capture
            sdk.capture("event_name")
            sdk.capture("event_name", properties: ["key": "value"])
            sdk.capture("event_name", distinctId: "user-123", properties: ["key": "value"])
            sdk.capture("event_name", properties: ["key": "value"], userProperties: ["name": "Test"])
            sdk.capture("event_name", properties: nil, userProperties: nil, userPropertiesSetOnce: nil, groups: nil, timestamp: nil)
            sdk.capture("event_name", distinctId: "user-123", properties: ["key": "value"], userProperties: ["up": "val"], userPropertiesSetOnce: ["once": "val"], groups: ["company": "acme"], timestamp: Date())

            // Screen tracking
            sdk.screen("HomeScreen")
            sdk.screen("HomeScreen", properties: ["tab": "feed"])
        }
    }

    func testPostHogSDKOptInOutAPI() throws {
        if false {
            let sdk = PostHogSDK.shared

            sdk.optOut()
            let _: Bool = sdk.isOptOut()
            sdk.optIn()
        }
    }

    func testPostHogSDKSuperPropertiesAPI() throws {
        if false {
            let sdk = PostHogSDK.shared

            sdk.register(["plan": "premium", "version": "2.0"])
            sdk.unregister("plan")
        }
    }

    func testPostHogSDKGroupAPI() throws {
        if false {
            let sdk = PostHogSDK.shared

            sdk.group(type: "company", key: "acme-inc")
            sdk.group(type: "company", key: "acme-inc", groupProperties: ["name": "Acme Inc", "size": 100])
        }
    }

    func testPostHogSDKSessionAPI() throws {
        if false {
            let sdk = PostHogSDK.shared

            sdk.startSession()
            sdk.endSession()
            let _: String? = sdk.getSessionId()
        }
    }

    func testPostHogSDKFeatureFlagsAPI() throws {
        if false {
            let sdk = PostHogSDK.shared

            // Reload
            sdk.reloadFeatureFlags()
            sdk.reloadFeatureFlags {
                // callback when flags are loaded
            }

            // Check flags
            let _: Bool = sdk.isFeatureEnabled("flag-key")
            let _: Bool = sdk.isFeatureEnabled("flag-key", sendFeatureFlagEvent: false)

            let _: Any? = sdk.getFeatureFlag("flag-key")
            let _: Any? = sdk.getFeatureFlag("flag-key", sendFeatureFlagEvent: false)

            let _: Any? = sdk.getFeatureFlagPayload("flag-key")

            // Feature flag result
            let result: PostHogFeatureFlagResult? = sdk.getFeatureFlagResult("flag-key")
            let result2: PostHogFeatureFlagResult? = sdk.getFeatureFlagResult("flag-key", sendFeatureFlagEvent: true)
            if let r = result {
                let _: String = r.key
                let _: Bool = r.enabled
                let _: String? = r.variant
                let _: Any? = r.payload
            }
            let _ = result2
        }
    }

    func testPostHogSDKFlagPropertiesAPI() throws {
        if false {
            let sdk = PostHogSDK.shared

            // Person properties for flags
            sdk.setPersonPropertiesForFlags(["plan": "premium"])
            sdk.setPersonPropertiesForFlags(["plan": "premium"], reloadFeatureFlags: false)
            sdk.resetPersonPropertiesForFlags()
            sdk.resetPersonPropertiesForFlags(reloadFeatureFlags: false)

            // Group properties for flags
            sdk.setGroupPropertiesForFlags("company", properties: ["size": 100])
            sdk.setGroupPropertiesForFlags("company", properties: ["size": 100], reloadFeatureFlags: false)
            sdk.resetGroupPropertiesForFlags()
            sdk.resetGroupPropertiesForFlags(reloadFeatureFlags: false)
            sdk.resetGroupPropertiesForFlags("company")
            sdk.resetGroupPropertiesForFlags("company", reloadFeatureFlags: false)
        }
    }

    func testPostHogSDKSessionReplayAPI() throws {
        if false {
            let sdk = PostHogSDK.shared

            let _: Bool = sdk.isSessionReplayActive()
            sdk.startSessionRecording()
            sdk.startSessionRecording(resumeCurrent: true)
            sdk.stopSessionRecording()
        }
    }

    func testPostHogPersonProfilesEnum() throws {
        if false {
            let _: PostHogPersonProfiles = .never
            let _: PostHogPersonProfiles = .always
            let _: PostHogPersonProfiles = .identifiedOnly

            let _: Int = PostHogPersonProfiles.never.rawValue
            let _: Int = PostHogPersonProfiles.always.rawValue
            let _: Int = PostHogPersonProfiles.identifiedOnly.rawValue
        }
    }

    func testPostHogSDKAnonymousIdAPI() throws {
        if false {
            let sdk = PostHogSDK.shared
            let _: String = sdk.getAnonymousId()
        }
    }

    func testPostHogSDKSessionActiveAPI() throws {
        if false {
            let sdk = PostHogSDK.shared
            let _: Bool = sdk.isSessionActive()
        }
    }

    func testPostHogSDKCaptureExceptionAPI() throws {
        if false {
            let sdk = PostHogSDK.shared
            sdk.captureException(PostHogTestError())
            sdk.captureException(PostHogTestError(), properties: ["context": "test"])
        }
    }

    func testPostHogSDKFeatureTrackingAPI() throws {
        if false {
            let sdk = PostHogSDK.shared
            sdk.captureFeatureView(flag: "new-dashboard")
            sdk.captureFeatureView(flag: "new-dashboard", flagVariant: "control")
            sdk.captureFeatureInteraction(flag: "new-dashboard")
            sdk.captureFeatureInteraction(flag: "new-dashboard", flagVariant: "test")
        }
    }

    func testPostHogConfigElementInteractions() throws {
        if false {
            let config = PostHogConfig(apiKey: "test-key")
            config.captureElementInteractions = true
            let _: Bool = config.captureElementInteractions
        }
    }
}

struct PostHogTestError: Error { }
