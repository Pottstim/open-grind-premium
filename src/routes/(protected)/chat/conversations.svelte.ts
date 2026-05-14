import toast from "svelte-french-toast";

import {
	getConversations,
	markConversationAsRead,
} from "$lib/api/conversation";
import type { Conversation } from "$lib/model/conversation";
import {
	ws,
	wsConversationDeletePayloadSchema,
	wsMessageSentPayloadSchema,
} from "$lib/ws.svelte";

const wsPromises: Promise<() => void>[] = [];

class ConversationsState {
	entries = $state<Conversation[]>([]);
	nextPage = $state<number | null>(null);
	loadingMore = $state(false);
	initial: Promise<void>;

	constructor() {
		this.initial = this.#load(1);

		wsPromises.push(
			ws.on("chat.v1.message_sent", wsMessageSentPayloadSchema, (event) => {
				const { conversationId, type, timestamp } = event.payload;
				const entry = this.entries.find((e) => e.data.conversationId === conversationId);
				if (entry) {
					entry.data.unreadCount += 1;
					this.updatePreview({
						conversationId,
						preview: {
							type,
							text: (event.payload as { text?: string | null }).text ?? null,
							albumId: null,
							imageHash: null,
						},
						timestamp,
					});
				} else {
					void this.ensureLoaded(conversationId);
				}
			}),
			ws.on("chat.v1.conversation.delete", wsConversationDeletePayloadSchema, (event) => {
				for (const id of event.payload.conversationIds) {
					this.remove(id);
				}
			}),
		);
	}

	async #load(page: number): Promise<void> {
		const result = await getConversations(page);
		this.entries.push(...result.entries);
		this.nextPage = result.nextPage;
	}

	async loadMore(): Promise<void> {
		if (this.loadingMore || this.nextPage === null) return;
		this.loadingMore = true;
		try {
			await this.#load(this.nextPage);
		} catch (error) {
			console.error(error);
			toast.error("Failed to load more conversations");
		} finally {
			this.loadingMore = false;
		}
	}

	async ensureLoaded(conversationId: string): Promise<void> {
		if (this.entries.some((e) => e.data.conversationId === conversationId)) {
			return;
		}
		try {
			const result = await getConversations(1);
			const newEntries = result.entries.filter(
				(entry) =>
					!this.entries.some(
						(e) => e.data.conversationId === entry.data.conversationId,
					),
			);
			this.entries.unshift(...newEntries);
		} catch (error) {
			console.error("Failed to sync conversation into sidebar", error);
		}
	}

	remove(conversationId: string) {
		const index = this.entries.findIndex(
			(e) => e.data.conversationId === conversationId,
		);
		let revert = () => {};
		if (index > -1) {
			const [removed] = this.entries.splice(index, 1);
			revert = () => {
				if (removed) {
					this.entries.splice(index, 0, removed);
				}
			};
		}
		return {
			revert,
		};
	}

	markRead(conversationId: string): void {
		const entry = this.entries.find(
			(e) => e.data.conversationId === conversationId,
		);
		if (entry) {
			const unreadCount = entry.data.unreadCount;
			if (unreadCount > 0) {
				entry.data.unreadCount = 0;
				markConversationAsRead({ conversationId }).catch((error) => {
					console.error("Failed to mark conversation as read", error);
					toast.error("Failed to mark conversation as read");
					entry.data.unreadCount = unreadCount;
				});
			}
		}
	}

	updatePreview({
		conversationId,
		preview,
		timestamp,
	}: {
		conversationId: Conversation["data"]["conversationId"];
		preview: Conversation["data"]["preview"];
		timestamp: Conversation["data"]["lastActivityTimestamp"];
	}): void {
		const entry = this.entries.find(
			(e) => e.data.conversationId === conversationId,
		);
		if (!entry) return;
		entry.data.preview = preview;
		entry.data.lastActivityTimestamp = timestamp;
	}
}

export const conversations = new ConversationsState();
