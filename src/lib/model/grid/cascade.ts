import z from "zod";
import {
	filterAcceptNSFWPicsSchema,
	filterBodyTypeSchema,
	filterHealthPracticesSchema,
	filterLookingForSchema,
	filterMeetAtSchema,
	filterPositionSchema,
	filterRelationshipStatusSchema,
	filterTribesSchema,
} from "$lib/components/filters/filters";
import { gridQuerySchema } from "$lib/model/grid";
import { unixTimestampMsSchema } from "$lib/model/types";
import {
	bodyTypeSchema,
	lookingForSchema,
	profileFieldsSchema,
	sexualPositionSchema,
	socialNetworksSchema,
	tribeSchema,
} from "$lib/model/profile";
import { mediaHashPublicSchema } from "$lib/model/media";

export const cascadeQuerySchema = gridQuerySchema.extend({
	onlineOnly: z.boolean().optional(),
	ageMin: z.int().nonnegative().optional(),
	ageMax: z.int().nonnegative().optional(),
	heightCmMin: z.number().nonnegative().optional(),
	heightCmMax: z.number().nonnegative().optional(),
	weightGramsMin: z.number().nonnegative().optional(),
	weightGramsMax: z.number().nonnegative().optional(),
	tribes: filterTribesSchema.optional(),
	lookingFor: filterLookingForSchema.optional(),
	relationshipStatuses: filterRelationshipStatusSchema.optional(),
	bodyTypes: filterBodyTypeSchema.optional(),
	sexualPositions: filterPositionSchema.optional(),
	meetAt: filterMeetAtSchema.optional(),
	nsfwPics: filterAcceptNSFWPicsSchema.optional(),
	tags: z.string().optional(),
	rightNow: z.boolean().optional(),
	favorites: z.boolean().optional(),
	showSponsoredProfiles: z.boolean().optional(),
	shuffle: z.boolean().optional(),
	hot: z.boolean().optional(),
});

export const cascadeV3QuerySchema = cascadeQuerySchema.extend({
	exploreUuid: z.unknown().optional(),
	sexualHealth: filterHealthPracticesSchema.optional(),
});

export const cascadeResponseProfileSchema = z.object({
	profileId: z.number().int().nonnegative(),
	onlineUntil: unixTimestampMsSchema.nullable(),
	displayName: z.string().nullable(),
	distanceMeters: z.number().int().nonnegative().optional(),
	rightNow: z.string(),
	unreadCount: z.number().int().nonnegative(),
	isVisiting: z.boolean(),
	isPopular: z.boolean(),
});

export const cascadeV3ResponseProfileSchema =
	cascadeResponseProfileSchema.extend({
		lastOnline: unixTimestampMsSchema,
		photoMediaHashes: z.array(mediaHashPublicSchema).nullable(),
		lookingFor: z.array(lookingForSchema).nullable(),
		sexualPosition: sexualPositionSchema.optional(),
		approximateDistance: z.boolean().optional(),
		isFavorite: z.boolean(),
		isBoosting: z.boolean(),
		hasChattedInLast24Hrs: z.boolean(),
		hasUnviewedSpark: z.boolean(),
		isTeleporting: z.boolean(),
		isRoaming: z.boolean(),
		isRightNow: z.boolean(),
		hasUnreadThrob: z.boolean(),
		isBlockable: z.boolean(),
		isBoostingSomewhereElse: z.boolean(),
	});

export const cascadeV4ResponseProfileSchema =
	cascadeResponseProfileSchema.extend({
		primaryImageUrl: z.url(),
		favorite: z.boolean(),
		viewed: z.boolean(),
		chatted: z.boolean(),
		roaming: z.boolean(),
	});

export const cascadeV3ResponseProfileFullProfileV1Schema = z.object({
	type: z.literal("full_profile_v1"),
	data: cascadeV3ResponseProfileSchema.extend({
		...profileFieldsSchema.shape,
		"@type": z.literal("CascadeItemData$FullProfileV1"),
		tribes: z.array(tribeSchema),
		socialNetworks: z.array(socialNetworksSchema),
		takenOnGrindrMetadata: z.record(
			mediaHashPublicSchema,
			z.object({
				takenOnGrindr: z.boolean(),
				createdAt: unixTimestampMsSchema,
			}),
		),
	}),
});

export const cascadeV4ResponseProfileFullProfileV1Schema = z.object({
	type: z.literal("full_profile_v1"),
	data: cascadeV3ResponseProfileSchema.extend({
		...profileFieldsSchema.shape,
		age: z.number().int().nonnegative().optional(),
		heightCm: z.number().nonnegative().optional(),
		weightGrams: z.number().nonnegative().optional(),
		bodyType: bodyTypeSchema,
	}),
});

export const cascadeV3ResponseItemSchema = z.union([
	cascadeV3ResponseProfileFullProfileV1Schema,
]);

export const cascadeV4ResponseItemSchema = z.union([
	cascadeV4ResponseProfileFullProfileV1Schema,
]);
