import z from "zod";
import { fetchRest } from "$lib/api";
import { fullConversationSchema } from "$lib/model/conversation";
import { messageSchema } from "$lib/model/message";

export async function getConversations(page: number = 1) {
	const conversations = await fetchRest(
		"/v4/inbox?" + new URLSearchParams({ page: String(page) }),
		{
			method: "POST",
		},
	)
		.then((res) => res.json())
		.then((res) =>
			z
				.object({
					entries: z.array(fullConversationSchema),
					nextPage: z.number().nullable(),
				})
				.parse(res),
		);
	return conversations;
}

export async function getConversationMessages(conversationId: string) {
	const messages = await fetchRest(
		`/v5/chat/conversation/${conversationId}/message`,
		{
			method: "GET",
		},
	)
		.then((res) => res.json())
		.then((res) =>
			z
				.object({
					messages: z.array(messageSchema)
				})
				.parse(res),
		);
	return messages;
}