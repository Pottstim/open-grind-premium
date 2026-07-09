//! Data-driven premium feature injection and gate removal.
//! Add new rules here — no more giant if-else chains.

use serde_json::{json, Map, Value};
use std::sync::OnceLock;

pub struct RewriteRule {
    pub path_prefix: &'static str,
    pub transform: fn(&mut Value),
}

pub fn get_rewrite_rules() -> &'static [RewriteRule] {
    static RULES: OnceLock<Vec<RewriteRule>> = OnceLock::new();

    RULES.get_or_init(|| vec![
        // === Core Premium ===
        RewriteRule {
            path_prefix: "/v3/bootstrap",
            transform: |json| {
                json["userRole"] = json!("UNLIMITED");
                json["subscriptionTier"] = json!("UNLIMITED");

                let mut flags: Map<String, Value> = json
                    .get("featureFlags").and_then(|f| f.as_object()).cloned().unwrap_or_default();

                for key in [
                    "readReceipts", "tapAndGo", "unlimitedTaps", "unlimitedFavorites",
                    "unlimitedBlocks", "incognitoMode", "typingStatus", "expire24hProfile",
                    "hideDistance", "boosts", "profileViews",
                ] {
                    flags.insert(key.to_string(), json!(true));
                }
                json["featureFlags"] = Value::Object(flags);
            },
        },

        RewriteRule {
            path_prefix: "/v1/entitlements",
            transform: |json| {
                json["rightNow"] = json!(15);
                json["total"] = json!(15);
            },
        },

        RewriteRule {
            path_prefix: "/v1/me",
            transform: |json| {
                json["subscription"] = json!({
                    "premium": true, "userRole": "UNLIMITED", "subscriptionTier": "UNLIMITED"
                });
            },
        },

        RewriteRule {
            path_prefix: "/v3/me/profile",
            transform: |json| {
                json["subscription"] = json!({
                    "premium": true, "userRole": "UNLIMITED", "subscriptionTier": "UNLIMITED"
                });
            },
        },

        RewriteRule {
            path_prefix: "/v4/subscriptions",
            transform: |json| {
                json["subscription"] = json!({
                    "premium": true, "userRole": "UNLIMITED", "subscriptionTier": "UNLIMITED"
                });
            },
        },

        // === Gate Removal ===
        RewriteRule { path_prefix: "/v2/inbox", transform: |json| { json.as_object_mut().map(|m| m.remove("upgradeRequired")); } },
        RewriteRule { path_prefix: "/v3/inbox", transform: |json| { json.as_object_mut().map(|m| m.remove("upgradeRequired")); } },
        RewriteRule { path_prefix: "/v1/views",  transform: |json| { json.as_object_mut().map(|m| m.remove("upgradeRequired")); } },
        RewriteRule { path_prefix: "/v1/favorites", transform: |json| { json.as_object_mut().map(|m| m.remove("upgradeRequired")); } },
        RewriteRule { path_prefix: "/v3/explore", transform: |json| { json.as_object_mut().map(|m| m.remove("upgradeRequired")); } },
        RewriteRule { path_prefix: "/v4/album",   transform: |json| { json.as_object_mut().map(|m| m.remove("upgradeRequired")); } },

        // === Settings Injection ===
        RewriteRule {
            path_prefix: "/v3/me/settings",
            transform: |json| {
                if let Some(obj) = json.as_object_mut() {
                    obj.entry("showDistance".to_string()).or_insert(json!(true));
                    obj.entry("incognito".to_string()).or_insert(json!(false));
                }
            },
        },
        RewriteRule {
            path_prefix: "/v3/me/prefs",
            transform: |json| {
                if let Some(obj) = json.as_object_mut() {
                    obj.entry("showDistance".to_string()).or_insert(json!(true));
                }
            },
        },
    ])
}

pub fn apply_rewrites(path: &str, json: &mut Value) {
    let path_lower = path.to_lowercase();
    for rule in get_rewrite_rules() {
        if path_lower.starts_with(rule.path_prefix) {
            (rule.transform)(json);
            return;
        }
    }
}