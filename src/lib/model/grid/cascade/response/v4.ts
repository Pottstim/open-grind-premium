import z from "zod";

import { bodyTypeSchema } from "$lib/model/profile";
import {
	cascadeResponseAdvertV1Schema,
	cascadeResponseBoostUpsellV1Schema,
	cascadeResponseExploreAggregationV1Schema,
	cascadeResponseFavHeaderV1Schema,
	cascadeResponseFullProfileV1Schema,
	cascadeResponsePartialProfileV1Schema,
	cascadeResponseProfileSchema,
	cascadeResponseSchema,
	cascadeResponseTopPicksV1Schema,
	cascadeResponseUnlimitedMpuV1Schema,
	cascadeResponseXtraMpuV1Schema,
} from ".";

const cascadeV4ResponseProfileSchema = z.object({
	...cascadeResponseProfileSchema.shape,
	primaryImageUrl: z.url(),
	favorite: z.boolean().optional(),
	viewed: z.boolean().optional(),
	chatted: z.boolean().optional(),
	roaming: z.boolean().optional(),
});

export const cascadeV4ResponseFullProfileV1Schema = z.object({
	...cascadeResponseFullProfileV1Schema.shape,
	data: z.object({
		...cascadeResponseFullProfileV1Schema.shape.data.shape,
		...cascadeV4ResponseProfileSchema.shape,
		age: z.number().int().nonnegative().optional(),
		heightCm: z.number().nonnegative().optional(),
		weightGrams: z.number().nonnegative().optional(),
		bodyType: bodyTypeSchema,
	}),
});

export const cascadeV4ResponseAdvertV1Schema = z.object({
	...cascadeResponseAdvertV1Schema.shape,
});

export const cascadeV4ResponseTopPicksV1Schema = z.object({
	...cascadeResponseTopPicksV1Schema.shape,
});

export const cascadeV4ResponsePartialProfileV1Schema = z.object({
	...cascadeResponsePartialProfileV1Schema.shape,
	data: z.object({
		...cascadeResponsePartialProfileV1Schema.shape.data.shape,
		...cascadeV4ResponseProfileSchema.shape,
	}),
});

export const cascadeV4ResponseExploreAggregationV1Schema = z.object({
	...cascadeResponseExploreAggregationV1Schema.shape,
});

export const cascadeV4ResponseBoostUpsellV1Schema = z.object({
	...cascadeResponseBoostUpsellV1Schema.shape,
});

export const cascadeV4ResponseUnlimitedMpuV1Schema = z.object({
	...cascadeResponseUnlimitedMpuV1Schema.shape,
});

export const cascadeV4ResponseXtraMpuV1Schema = z.object({
	...cascadeResponseXtraMpuV1Schema.shape,
});

export const cascadeV4ResponseFavHeaderV1Schema = z.object({
	...cascadeResponseFavHeaderV1Schema.shape,
});

export const cascadeV4ResponseItemSchema = z.discriminatedUnion("type", [
	cascadeV4ResponseFullProfileV1Schema,
	cascadeV4ResponsePartialProfileV1Schema,
	cascadeV4ResponseAdvertV1Schema,
	cascadeV4ResponseTopPicksV1Schema,
	cascadeV4ResponseExploreAggregationV1Schema,
	cascadeV4ResponseBoostUpsellV1Schema,
	cascadeV4ResponseUnlimitedMpuV1Schema,
	cascadeV4ResponseXtraMpuV1Schema,
	cascadeV4ResponseFavHeaderV1Schema,
]);

export const cascadeV4ResponseSchema = z.object({
	...cascadeResponseSchema.shape,
	items: z.array(cascadeV4ResponseItemSchema),
});
