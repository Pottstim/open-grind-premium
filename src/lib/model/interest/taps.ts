import z from "zod";

// Existing schema retained for the profile model's stored `tapType` field.
export const tapIdSchema = z.number().int().min(0).max(3);

// Tap types sent via the /v2/taps/add endpoint (ported from open-grind).
export const TapType = {
	Friendly: 0,
	Hot: 1,
	Looking: 2,
} as const;

export const tapTypes: Record<(typeof TapType)[keyof typeof TapType], string> = {
	[TapType.Friendly]: "Cookie",
	[TapType.Hot]: "Fire",
	[TapType.Looking]: "Demon",
};

export const tapTypeSchema = z.nativeEnum(TapType);

export type TapType = z.infer<typeof tapTypeSchema>;
