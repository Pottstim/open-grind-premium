import z from "zod";

export const geohashSchema = z
	.string()
	.length(12)
	.regex(/^[0-9b-hjkmnp-z]+$/);
