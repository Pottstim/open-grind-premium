import { unixTimestampMsSchema } from "$lib/model/types";
import z from "zod";

const messageBaseSchema = z.object({
	messageId: z.string(),
	conversationId: z.string(),
	senderId: z.number().int().nonnegative(),
	timestamp: unixTimestampMsSchema,
	unsent: z.boolean(),
	reactions: z.array(
		z.object({
			profileId: z.number().int().nonnegative(),
			reactionType: z.number().int().nonnegative(),
		}),
	),
	type: z.string(),
	body: z.unknown(),
	// replyToMessage: z.unknown().nullable(),
	// dynamic: z.boolean(),
	// chat1Type: z.string(),
	// replyPreview: z.unknown().nullable(),
});

export const textMessageSchema = messageBaseSchema.safeExtend({
	type: z.literal("Text"),
	body: z.object({
		text: z.string(),
	}),
});

export const messageSchema = z.discriminatedUnion("type", [textMessageSchema]);

export type Message = z.infer<typeof messageSchema>;
