use std::sync::atomic::AtomicBool;
use std::sync::{Arc, OnceLock};
use tokio::sync::{mpsc, Notify};

use crate::api::client::GrindrClient;
use crate::api::ws::WsCommand;
use crate::error::AppError;

pub struct AppState {
    pub client: OnceLock<Arc<GrindrClient>>,
    pub ws_tx: mpsc::Sender<WsCommand>,
    pub ws_rx: tokio::sync::Mutex<Option<mpsc::Receiver<WsCommand>>>,
    pub auth_notify: Arc<Notify>,
    /// true when the WebView is visible/active; false when app is backgrounded.
    /// Used by the WS loop to decide whether to post system notifications.
    pub is_foreground: AtomicBool,
}

impl AppState {
    pub fn client(&self) -> Result<Arc<GrindrClient>, AppError> {
        self.client.get().cloned().ok_or(AppError::NotInitialized)
    }
}
