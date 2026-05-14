use reqwest::Client;
use tokio::sync::{Mutex, RwLock};

use crate::error::AppError;

use super::auth::{AuthStorage, Session};
use super::headers::{build_default_headers, build_user_agent, DeviceInfo};

pub const BASE_URL: &str = "https://grindr.mobi";

pub struct GrindrClient {
    pub(super) http: Client,
    pub(super) session: RwLock<Option<Session>>,
    pub(super) refresh_lock: Mutex<()>,
    pub user_agent: String,
}

impl GrindrClient {
    pub fn new() -> Result<Self, AppError> {
        let device = DeviceInfo::default();
        let user_agent = build_user_agent(&device, "Free");
        let headers = build_default_headers(&device, &user_agent);

        let http = Client::builder().default_headers(headers).build()?;

        let session = AuthStorage::get_session()?;

        Ok(Self {
            http,
            session: RwLock::new(session),
            refresh_lock: Mutex::new(()),
            user_agent,
        })
    }
}
