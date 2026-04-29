import z from "zod";
import { fetchRest } from "$lib/api";
import { urlSearchParamsCodec } from "$lib/utils";
import { searchProfileSchema, searchQuerySchema } from "$lib/model/grid/search";
import {
	cascadeV3QuerySchema,
	cascadeV3ResponseItemSchema,
} from "$lib/model/grid/cascade";
import { profileRightNowSchema, profileShortSchema } from "$lib/model/profile";

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

/**
 * Main endpoint used in the source apk. /v4/cascade is currently feature-flagged, /v7/search is only for profile tags
 */
export async function getV3Cascade(
	query: z.infer<typeof cascadeV3QuerySchema>,
) {
	return await fetchRest(
		"/v3/cascade?" +
			new URLSearchParams(
				urlSearchParamsCodec(cascadeV3QuerySchema).encode(query),
			),
	)
		.then((res) => res.json())
		.then((data) => {
			console.log({ data });
			return z
				.object({
					items: z.array(cascadeV3ResponseItemSchema),
					nextPage: z.number().int().nonnegative(),
					shuffled: z.boolean(),
					hiddenProfiles: z.unknown(),
					hiddenProfileInfo: z.unknown(),
				})
				.parse(data);
		});
}

export async function getGrid(query: Parameters<typeof getV3Cascade>[0]) {
	const response = await getV3Cascade(query);
	const profiles: {
		id: number;
		displayName: string | null;
		distance: number | null;
		profilePhotosHashes: string[] | null;
		unread: number | null;
	}[] = [];
	const partialProfileBatchStack: { profileId: number }[] = [];
	for (const item of response.items) {
		if (item.type === "full_profile_v1") {
			const profile = item.data;
			profiles.push({
				id: profile.profileId,
				displayName: profile.displayName ?? null,
				distance: profile.distanceMeters ?? null,
				profilePhotosHashes: profile.photoMediaHashes,
				unread: profile.unreadCount ?? null,
			});
		} else if (item.type === "partial_profile_v1") {
			partialProfileBatchStack.push({ profileId: item.data.profileId });
		}
		if (partialProfileBatchStack.length >= 150) {
			const partialProfileIds = partialProfileBatchStack
				.splice(0, 150)
				.map((p) => p.profileId);
			console.log({ partialProfileIds });
			const partialProfilesResolved = await fetchRest("/v3/profiles", {
				method: "POST",
				body: { targetProfileIds: partialProfileIds },
			})
				.then((res) => res.json())
				.then((data) => {
					console.log(data);
					return z
						.object({
							profiles: z.array(
								z.object({
									...profileShortSchema.shape,
									...profileRightNowSchema.shape,
								}),
							),
						})
						.parse(data)
						.profiles.filter(({ profileId }) =>
							partialProfileIds.includes(profileId),
						)
						.sort(
							(a, b) =>
								partialProfileIds.indexOf(a.profileId) -
								partialProfileIds.indexOf(b.profileId),
						);
				});
			for (const profile of partialProfilesResolved) {
				profiles.push({
					id: profile.profileId,
					displayName: profile.displayName ?? null,
					distance: profile.distance ?? null,
					profilePhotosHashes: profile.medias?.map((m) => m.mediaHash) ?? null,
					unread: null, // TODO: fetch unread count for partial profiles
				});
			}
		}
	}
	return {
		items: profiles.toSorted((a, b) => {
			const aDis = a.distance;
			const bDis = b.distance;
			if (aDis === null && bDis === null) return 0;
			if (aDis === null) return 1;
			if (bDis === null) return -1;
			return aDis - bDis;
		}),
		nextPage: response.nextPage,
		shuffled: response.shuffled,
	};
}
