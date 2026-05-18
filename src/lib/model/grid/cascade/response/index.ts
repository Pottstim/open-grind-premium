import z from "zod";

import { unixTimestampMsSchema } from "$lib/model/types";

export const cascadeResponseProfileSchema = z.object({
	profileId: z.number().int().nonnegative(),
	onlineUntil: unixTimestampMsSchema.nullable(),
	displayName: z.string().nullable().optional(),
	distanceMeters: z.number().int().nonnegative().optional(),
	rightNow: z.string(),
	unreadCount: z.number().int().nonnegative(),
	isVisiting: z.boolean(),
	isPopular: z.boolean(),
});

export const cascadeResponseFullProfileV1Schema = z.object({
	type: z.literal("full_profile_v1"),
	data: z.object({
		...cascadeResponseProfileSchema.shape,
	}),
});

export const cascadeResponsePartialProfileV1Schema = z.object({
	type: z.literal("partial_profile_v1"),
	data: z.object({
		...cascadeResponseProfileSchema.shape,
		upsellItemType: z.string(),
	}),
});

export const cascadeResponseBoostUpsellV1Schema = z.object({
	type: z.literal("boost_upsell_v1"),
	data: z.object({}),
});

export const cascadeResponseUnlimitedMpuV1Schema = z.object({
	type: z.literal("unlimited_mpu_v1"),
	data: z.object({}),
});

export const cascadeResponseXtraMpuV1Schema = z.object({
	type: z.literal("xtra_mpu_v1"),
	data: z.object({}),
});

export const cascadeExploreAggregationLocationItemSchema = z.object({
	"@type": z.literal("ExploreAggregationItem$Location"),
	data: z.object({
		onlineCount: z.number().int().nonnegative(),
		uuid: z.string(),
		location: z.object({
			id: z.number().int(),
			name: z.string(),
			suffix: z.string(),
			lat: z.number(),
			lon: z.number(),
		}),
		profiles: z.array(z.object({ profileImageUrl: z.url() })),
	}),
});

export const cascadeExploreAggregationCtaItemSchema = z.object({
	"@type": z.literal("ExploreAggregationItem$Cta"),
});

export const cascadeResponseExploreAggregationV1Schema = z.object({
	type: z.literal("explore_aggregation_v1"),
	data: z.object({
		uuid: z.string(),
		headerName: z.string(),
		source: z.string(),
		items: z.array(
			z.discriminatedUnion("@type", [
				cascadeExploreAggregationLocationItemSchema,
				cascadeExploreAggregationCtaItemSchema,
			]),
		),
	}),
});

export const cascadeResponseFavHeaderV1Schema = z.object({
	type: z.literal("favs_header_v1"),
	data: z.object({
		available: z.number().int().nonnegative(),
		displayed: z.number().int().nonnegative(),
		total: z.number().int().nonnegative(),
	}),
});

export const cascadeResponseAdvertV1Schema = z.object({
	type: z.literal("advert_v1"),
	data: z.object({
		cascadePlacementName: z.string(),
	}),
});

export const cascadeResponseTopPicksV1Schema = z.object({
	type: z.literal("top_picks_v1"),
	data: z.object({}),
});

export const cascadeResponseSchema = z.object({
	items: z.array(z.unknown()),
	nextPage: z.number().int().nonnegative().nullable(),
	shuffled: z.boolean(),
	hiddenProfiles: z.unknown(),
	hiddenProfileInfo: z.unknown(),
});
