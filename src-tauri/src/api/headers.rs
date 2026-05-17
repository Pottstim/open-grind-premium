use rand;
use reqwest::header::{HeaderMap, HeaderValue};

const APP_VERSION: &str = "26.7.0.159416";
const BUILD_NUMBER: &str = "147239";
const MAX_ANDROID_VERSION: u8 = 16;

struct DeviceProfile {
    manufacturer: &'static str,
    device_model: &'static str,
    screen_resolution: &'static str,
    total_ram: &'static str,
    min_android: u8,
}

const DEVICE_PROFILES: &[DeviceProfile] = &[
    // Google Pixel
    DeviceProfile {
        manufacturer: "Google",
        device_model: "Pixel 6",
        screen_resolution: "2400x1080",
        total_ram: "8026152960",
        min_android: 12,
    },
    DeviceProfile {
        manufacturer: "Google",
        device_model: "Pixel 6 Pro",
        screen_resolution: "3120x1440",
        total_ram: "12017676288",
        min_android: 12,
    },
    DeviceProfile {
        manufacturer: "Google",
        device_model: "Pixel 6a",
        screen_resolution: "2400x1080",
        total_ram: "5938152960",
        min_android: 12,
    },
    DeviceProfile {
        manufacturer: "Google",
        device_model: "Pixel 7",
        screen_resolution: "2400x1080",
        total_ram: "8026152960",
        min_android: 13,
    },
    DeviceProfile {
        manufacturer: "Google",
        device_model: "Pixel 7 Pro",
        screen_resolution: "3120x1440",
        total_ram: "12017676288",
        min_android: 13,
    },
    DeviceProfile {
        manufacturer: "Google",
        device_model: "Pixel 7a",
        screen_resolution: "2400x1080",
        total_ram: "8026152960",
        min_android: 13,
    },
    DeviceProfile {
        manufacturer: "Google",
        device_model: "Pixel 8",
        screen_resolution: "2400x1080",
        total_ram: "8026152960",
        min_android: 14,
    },
    DeviceProfile {
        manufacturer: "Google",
        device_model: "Pixel 8 Pro",
        screen_resolution: "2992x1344",
        total_ram: "12017676288",
        min_android: 14,
    },
    DeviceProfile {
        manufacturer: "Google",
        device_model: "Pixel 8a",
        screen_resolution: "2400x1080",
        total_ram: "8026152960",
        min_android: 14,
    },
    DeviceProfile {
        manufacturer: "Google",
        device_model: "Pixel 9",
        screen_resolution: "2424x1080",
        total_ram: "12017676288",
        min_android: 14,
    },
    DeviceProfile {
        manufacturer: "Google",
        device_model: "Pixel 9 Pro",
        screen_resolution: "2856x1280",
        total_ram: "16065654784",
        min_android: 14,
    },
    DeviceProfile {
        manufacturer: "Google",
        device_model: "Pixel 9 Pro XL",
        screen_resolution: "2992x1344",
        total_ram: "16065654784",
        min_android: 14,
    },
    // Samsung
    DeviceProfile {
        manufacturer: "samsung",
        device_model: "SM-S901B",
        screen_resolution: "2340x1080",
        total_ram: "8026152960",
        min_android: 12,
    },
    DeviceProfile {
        manufacturer: "samsung",
        device_model: "SM-S906B",
        screen_resolution: "2340x1080",
        total_ram: "8026152960",
        min_android: 12,
    },
    DeviceProfile {
        manufacturer: "samsung",
        device_model: "SM-S908B",
        screen_resolution: "3088x1440",
        total_ram: "12017676288",
        min_android: 12,
    },
    DeviceProfile {
        manufacturer: "samsung",
        device_model: "SM-S911B",
        screen_resolution: "2340x1080",
        total_ram: "8026152960",
        min_android: 13,
    },
    DeviceProfile {
        manufacturer: "samsung",
        device_model: "SM-S916B",
        screen_resolution: "2340x1080",
        total_ram: "8026152960",
        min_android: 13,
    },
    DeviceProfile {
        manufacturer: "samsung",
        device_model: "SM-S918B",
        screen_resolution: "3088x1440",
        total_ram: "12017676288",
        min_android: 13,
    },
    DeviceProfile {
        manufacturer: "samsung",
        device_model: "SM-S921B",
        screen_resolution: "2340x1080",
        total_ram: "8026152960",
        min_android: 14,
    },
    DeviceProfile {
        manufacturer: "samsung",
        device_model: "SM-S926B",
        screen_resolution: "2340x1080",
        total_ram: "12017676288",
        min_android: 14,
    },
    DeviceProfile {
        manufacturer: "samsung",
        device_model: "SM-S928B",
        screen_resolution: "3120x1440",
        total_ram: "12017676288",
        min_android: 14,
    },
    DeviceProfile {
        manufacturer: "samsung",
        device_model: "SM-A546B",
        screen_resolution: "2340x1080",
        total_ram: "8026152960",
        min_android: 13,
    },
    DeviceProfile {
        manufacturer: "samsung",
        device_model: "SM-A346B",
        screen_resolution: "2340x1080",
        total_ram: "8026152960",
        min_android: 13,
    },
    DeviceProfile {
        manufacturer: "samsung",
        device_model: "SM-A145F",
        screen_resolution: "2408x1080",
        total_ram: "3852152832",
        min_android: 13,
    },
    DeviceProfile {
        manufacturer: "samsung",
        device_model: "SM-F731B",
        screen_resolution: "2640x1080",
        total_ram: "8026152960",
        min_android: 13,
    },
    DeviceProfile {
        manufacturer: "samsung",
        device_model: "SM-F946B",
        screen_resolution: "2176x1812",
        total_ram: "12017676288",
        min_android: 13,
    },
    // Xiaomi / Redmi / POCO
    DeviceProfile {
        manufacturer: "Xiaomi",
        device_model: "2201123G",
        screen_resolution: "2400x1080",
        total_ram: "8026152960",
        min_android: 12,
    },
    DeviceProfile {
        manufacturer: "Xiaomi",
        device_model: "2211133G",
        screen_resolution: "2400x1080",
        total_ram: "8026152960",
        min_android: 13,
    },
    DeviceProfile {
        manufacturer: "Xiaomi",
        device_model: "23078PND5G",
        screen_resolution: "2712x1220",
        total_ram: "8026152960",
        min_android: 13,
    },
    DeviceProfile {
        manufacturer: "Xiaomi",
        device_model: "23127PN0CG",
        screen_resolution: "2670x1200",
        total_ram: "12017676288",
        min_android: 14,
    },
    DeviceProfile {
        manufacturer: "Xiaomi",
        device_model: "23021RAA2Y",
        screen_resolution: "2400x1080",
        total_ram: "3852152832",
        min_android: 12,
    },
    DeviceProfile {
        manufacturer: "Xiaomi",
        device_model: "23117RA68G",
        screen_resolution: "2712x1220",
        total_ram: "8026152960",
        min_android: 13,
    },
    DeviceProfile {
        manufacturer: "Xiaomi",
        device_model: "23049PCD8G",
        screen_resolution: "2400x1080",
        total_ram: "8026152960",
        min_android: 13,
    },
    // OnePlus
    DeviceProfile {
        manufacturer: "OnePlus",
        device_model: "NE2213",
        screen_resolution: "3216x1440",
        total_ram: "8026152960",
        min_android: 12,
    },
    DeviceProfile {
        manufacturer: "OnePlus",
        device_model: "CPH2449",
        screen_resolution: "3216x1440",
        total_ram: "8026152960",
        min_android: 13,
    },
    DeviceProfile {
        manufacturer: "OnePlus",
        device_model: "CPH2581",
        screen_resolution: "3168x1440",
        total_ram: "12017676288",
        min_android: 14,
    },
    DeviceProfile {
        manufacturer: "OnePlus",
        device_model: "CPH2491",
        screen_resolution: "2772x1240",
        total_ram: "8026152960",
        min_android: 13,
    },
    // Motorola
    DeviceProfile {
        manufacturer: "motorola",
        device_model: "motorola edge 40",
        screen_resolution: "2400x1080",
        total_ram: "8026152960",
        min_android: 13,
    },
    DeviceProfile {
        manufacturer: "motorola",
        device_model: "motorola g84 5G",
        screen_resolution: "2400x1080",
        total_ram: "8026152960",
        min_android: 13,
    },
    // Sony
    DeviceProfile {
        manufacturer: "Sony",
        device_model: "XQ-DQ54",
        screen_resolution: "3840x1644",
        total_ram: "12017676288",
        min_android: 13,
    },
    DeviceProfile {
        manufacturer: "Sony",
        device_model: "XQ-DE54",
        screen_resolution: "2520x1080",
        total_ram: "8026152960",
        min_android: 13,
    },
    // Nothing
    DeviceProfile {
        manufacturer: "Nothing",
        device_model: "A065",
        screen_resolution: "2412x1080",
        total_ram: "12017676288",
        min_android: 13,
    },
    DeviceProfile {
        manufacturer: "Nothing",
        device_model: "A142",
        screen_resolution: "2412x1084",
        total_ram: "8026152960",
        min_android: 14,
    },
    // Asus
    DeviceProfile {
        manufacturer: "asus",
        device_model: "ASUS_AI2205",
        screen_resolution: "2448x1080",
        total_ram: "12017676288",
        min_android: 13,
    },
];

/// (timezone, L-Locale, Accept-Language)
pub const SAFE_TIMEZONES: &[(&str, &str, &str)] = &[
    // Europe
    ("Europe/Dublin", "en_IE", "en-IE"),
    ("Europe/Zurich", "de_CH", "de-CH"),
    ("Europe/Zurich", "fr_CH", "fr-CH"),
    ("Europe/Prague", "cs_CZ", "cs-CZ"),
    ("Europe/Bratislava", "sk_SK", "sk-SK"),
    ("Europe/Budapest", "hu_HU", "hu-HU"),
    ("Europe/Bucharest", "ro_RO", "ro-RO"),
    ("Europe/Sofia", "bg_BG", "bg-BG"),
    ("Europe/Zagreb", "hr_HR", "hr-HR"),
    ("Europe/Vilnius", "lt_LT", "lt-LT"),
    ("Europe/Riga", "lv_LV", "lv-LV"),
    ("Europe/Tallinn", "et_EE", "et-EE"),
    ("Europe/Luxembourg", "fr_LU", "fr-LU"),
    ("Europe/Malta", "en_MT", "en-MT"),
    // Americas
    ("America/Mexico_City", "es_MX", "es-MX"),
    ("America/Argentina/Buenos_Aires", "es_AR", "es-AR"),
    ("America/Santiago", "es_CL", "es-CL"),
    ("America/Bogota", "es_CO", "es-CO"),
    ("America/Lima", "es_PE", "es-PE"),
    ("America/Montevideo", "es_UY", "es-UY"),
    // Asia-Pacific
    ("Asia/Tokyo", "ja_JP", "ja-JP"),
    ("Asia/Tokyo", "en_US", "en-US"),
    ("Asia/Taipei", "zh_TW", "zh-TW"),
    ("Asia/Seoul", "ko_KR", "ko-KR"),
    ("Asia/Bangkok", "th_TH", "th-TH"),
    ("Asia/Manila", "en_PH", "en-PH"),
    ("Asia/Singapore", "en_SG", "en-SG"),
];

pub struct DeviceInfo {
    pub device_type: u8,
    pub device_id: String,
    pub os: &'static str,
    pub screen_resolution: &'static str,
    pub total_ram: &'static str,
    pub advertising_id: String,
    pub device_model: &'static str,
    pub manufacturer: &'static str,
    pub timezone: &'static str,
    pub locale: &'static str,
    pub accept_language: &'static str,
}

impl Default for DeviceInfo {
    fn default() -> Self {
        let profile = &DEVICE_PROFILES[rand::random::<u64>() as usize % DEVICE_PROFILES.len()];
        let (timezone, locale, accept_language) =
            SAFE_TIMEZONES[rand::random::<u64>() as usize % SAFE_TIMEZONES.len()];

        let device_id = format!("{:016x}", rand::random::<u64>());

        let range = MAX_ANDROID_VERSION.saturating_sub(profile.min_android) + 1;
        let android_version = profile.min_android + rand::random::<u8>() % range;
        let os = Box::leak(format!("Android {android_version}").into_boxed_str());

        Self {
            device_type: 2,
            device_id,
            os,
            screen_resolution: profile.screen_resolution,
            total_ram: profile.total_ram,
            advertising_id: uuid::Uuid::new_v4().to_string(),
            device_model: profile.device_model,
            manufacturer: profile.manufacturer,
            timezone,
            locale,
            accept_language,
        }
    }
}

pub fn build_user_agent(device: &DeviceInfo, subscription_tier: &str) -> String {
    format!(
        "grindr3/{APP_VERSION};{BUILD_NUMBER};{subscription_tier};{};{};{}",
        device.os, device.device_model, device.manufacturer
    )
}

pub fn build_default_headers(device: &DeviceInfo, user_agent: &str) -> HeaderMap {
    let mut headers = HeaderMap::new();

    let device_info = format!(
        "{};GLOBAL;{};{};{};{}",
        device.device_id,
        device.device_type,
        device.total_ram,
        device.screen_resolution,
        device.advertising_id
    );
    headers.insert(
        "L-Device-Info",
        HeaderValue::from_str(&device_info).unwrap(),
    );
    headers.insert("User-Agent", HeaderValue::from_str(user_agent).unwrap());
    headers.insert("requireRealDeviceInfo", HeaderValue::from_static("true"));
    headers.insert(
        "L-Time-Zone",
        HeaderValue::from_str(device.timezone).unwrap(),
    );
    headers.insert("L-Locale", HeaderValue::from_str(device.locale).unwrap());
    headers.insert(
        "Accept-Language",
        HeaderValue::from_str(device.accept_language).unwrap(),
    );
    headers.insert("Accept", HeaderValue::from_static("application/json"));

    headers
}

#[cfg(test)]
mod tests {
    use super::*;

    fn test_device() -> DeviceInfo {
        DeviceInfo {
            device_type: 2,
            device_id: "device123".to_owned(),
            os: "Android 14",
            screen_resolution: "1080x2400",
            total_ram: "8026152960",
            advertising_id: "ad-id-123".to_owned(),
            device_model: "Pixel 8",
            manufacturer: "Google",
            timezone: "Europe/Madrid",
            locale: "en_US",
            accept_language: "en-US",
        }
    }

    #[test]
    fn default_headers_include_grindr_device_identity() {
        let device = test_device();
        let user_agent = build_user_agent(&device, "Free");
        let headers = build_default_headers(&device, &user_agent);
        let expected_user_agent =
            format!("grindr3/{APP_VERSION};{BUILD_NUMBER};Free;Android 14;Pixel 8;Google");

        assert_eq!(
            headers.get("L-Device-Info").unwrap(),
            "device123;GLOBAL;2;8026152960;1080x2400;ad-id-123"
        );
        assert_eq!(
            headers.get("User-Agent").unwrap(),
            expected_user_agent.as_str()
        );
        assert_eq!(headers.get("requireRealDeviceInfo").unwrap(), "true");
    }

    #[test]
    fn default_headers_include_locale_timezone_and_json_accepts() {
        let device = test_device();
        let user_agent = build_user_agent(&device, "Unlimited");
        let headers = build_default_headers(&device, &user_agent);

        assert_eq!(headers.get("L-Time-Zone").unwrap(), "Europe/Madrid");
        assert_eq!(headers.get("L-Locale").unwrap(), "en_US");
        assert_eq!(headers.get("Accept-Language").unwrap(), "en-US");
        assert_eq!(headers.get("Accept").unwrap(), "application/json");
    }
}
