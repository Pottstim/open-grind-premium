use tokio::sync::mpsc;

use crate::api::client::GrindrClient;
use crate::api::ws::WsCommand;
use crate::error::AppError;

pub struct AppState {
    pub client: Option<GrindrClient>,
    pub ws_tx: mpsc::Sender<WsCommand>,
    pub ws_rx: tokio::sync::Mutex<Option<mpsc::Receiver<WsCommand>>>,
}

impl AppState {
    pub fn client(&self) -> Result<&GrindrClient, AppError> {
        self.client.as_ref().ok_or_else(|| AppError::NotInitialized)
    }
}
