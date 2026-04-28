import z from "zod";
import { fetchRest } from "$lib/api";
import { geohashSchema } from "$lib/model/geohash";
import { mediaHashPublicSchema } from "$lib/model/media";
import {
	filterAcceptNSFWPicsSchema,
	filterBodyTypeSchema,
	filterGendersSchema,
	filterLookingForSchema,
	filterMeetAtSchema,
	filterPositionSchema,
	filterRelationshipStatusSchema,
	filterTribesSchema,
} from "$lib/components/filters/filters";
import { urlSearchParamsCodec } from "$lib/utils";

export const searchProfileSchema = z.object({
	profileId: z.coerce.number().int().nonnegative(),
	displayName: z.string().nullable(),
	age: z.int().nonnegative().nullable(),
	distance: z.number().nullable(),
	medias: z.array(z.object({ mediaHash: mediaHashPublicSchema })).nullable(),
});

export const gridQuerySchema = z.object({
	nearbyGeoHash: geohashSchema,
	exploreGeoHash: geohashSchema.optional(),
	photoOnly: z.boolean().optional(),
	faceOnly: z.boolean().optional(),
	notRecentlyChatted: z.boolean().optional(),
	hasAlbum: z.boolean().optional(),
	fresh: z.boolean().optional(),
	genders: filterGendersSchema.optional(),
	pageNumber: z.int().nonnegative().optional(),
});

export const searchQuerySchema = gridQuerySchema.extend({
	online: z.boolean().optional(),
	ageMinimum: z.int().nonnegative().optional(),
	ageMaximum: z.int().nonnegative().optional(),
	heightMinimum: z.number().nonnegative().optional(),
	heightMaximum: z.number().nonnegative().optional(),
	weightMinimum: z.number().nonnegative().optional(),
	weightMaximum: z.number().nonnegative().optional(),
	grindrTribesIds: filterTribesSchema.optional(),
	lookingForIds: filterLookingForSchema.optional(),
	relationshipStatusIds: filterRelationshipStatusSchema.optional(),
	bodyTypeIds: filterBodyTypeSchema.optional(),
	sexualPositionIds: filterPositionSchema.optional(),
	meetAtIds: filterMeetAtSchema.optional(),
	nsfwIds: filterAcceptNSFWPicsSchema.optional(),
	profileTags: z.string().optional(),
	searchAfterDistance: z.string().optional(),
	searchAfterProfileId: z.string().optional(),
	freeFilter: z.boolean().optional(),
});

export async function searchProfiles(query: z.infer<typeof searchQuerySchema>) {
	return await fetchRest(
		"/v7/search?" +
			new URLSearchParams(
				urlSearchParamsCodec(searchQuerySchema).encode(query),
			),
	)
		.then((res) => res.json())
		.then((data) =>
			z
				.object({
					profiles: z.array(searchProfileSchema),
				})
				.parse(data),
		);
}
