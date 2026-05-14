import z from "zod";
import { listen } from "@tauri-apps/api/event";
import { invoke } from "@tauri-apps/api/core";

export const wsMessageSentPayloadSchema = z.object({
	type: z.literal("chat.v1.message_sent"),
	notificationId: z.string().nullable(),
	ref: z.null(),
	payload: z.looseObject({
		conversationId: z.string(),
		messageId: z.string(),
		senderId: z.number().int(),
		timestamp: z.number(),
		type: z.string(),
	}),
});

export const wsConversationDeletePayloadSchema = z.object({
	type: z.literal("chat.v1.conversation.delete"),
	notificationId: z.string().nullable(),
	ref: z.null(),
	payload: z.object({
		conversationIds: z.array(z.string()),
	}),
});

export type WsMessageSentPayload = z.infer<typeof wsMessageSentPayloadSchema>;
export type WsConversationDeletePayload = z.infer<
	typeof wsConversationDeletePayloadSchema
>;

export type WsStatus = "disconnected" | "connecting" | "connected" | "error";

class WsState {
	status = $state<WsStatus>("disconnected");

	constructor() {
		listen<void>("ws:connected", () => {
			this.status = "connected";
		}).catch(console.error);

		listen<void>("ws:disconnected", () => {
			this.status = "disconnected";
		}).catch(console.error);

		listen<string>("ws:ws.error", (event) => {
			console.error("[ws] server error", event.payload);
		}).catch(console.error);
	}

	connect(): void {
		if (this.status === "connecting" || this.status === "connected") return;
		this.status = "connecting";
		invoke("ws_send").catch((e: unknown) => {
			console.error("[ws] connect failed", e);
			this.status = "error";
		});
	}

	send(type: string, payload: unknown): void {
		const ref_id = crypto.randomUUID();
		invoke("ws_send", { command: { type, ref_id, payload } }).catch(
			(e: unknown) => {
				console.error("[ws] send failed", type, e);
			},
		);
	}

	on<T>(
		eventType: string,
		schema: z.ZodType<T>,
		handler: (payload: T) => void,
	): Promise<() => void> {
		return listen<unknown>(`ws:${eventType}`, (event) => {
			const result = schema.safeParse(event.payload);
			if (result.success) {
				handler(result.data);
			} else {
				console.error(
					`[ws] unexpected payload for ${eventType}:`,
					result.error,
					event.payload,
				);
			}
		});
	}
}

export const ws = new WsState();
