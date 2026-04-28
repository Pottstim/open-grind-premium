<script lang="ts">
	import { getV3Cascade } from "./grid";
	import { getPreferences } from "$lib/app-data/preferences.svelte";
	import ProfileMiniCard from "./ProfileMiniCard.svelte";
	import Filters from "./GridFilters.svelte";
	import type { cascadeV3QuerySchema } from "$lib/model/grid/cascade";
	import type z from "zod";

	let {
		geohash,
	}: {
		geohash: string;
	} = $props();

	// <button
	// 	onclick={async () => {
	// 		const profile = await fetchRest("/v7/profiles/22323233");
	// 		console.log(await profile?.json());
	// 	}}>Fetch profile</button
	// >
	// <button
	// 	onclick={async () => {
	// 		await callMethod("logout");
	// 		goto("/auth/sign-in");
	// 	}}>Log out</button
	// >

	let profiles = $state(fetchProfiles());

	async function fetchProfiles() {
		try {
			const { gridSearchFilters } = await getPreferences();
			const query: z.infer<typeof cascadeV3QuerySchema> = {
				nearbyGeoHash: geohash,
				favorites: gridSearchFilters?.isFavorite || undefined,
				onlineOnly: gridSearchFilters?.isOnline || undefined,
				rightNow: gridSearchFilters?.isRightNow || undefined,
				...(gridSearchFilters?.ageEnabled && {
					ageMin: gridSearchFilters?.age[0],
					ageMax: gridSearchFilters?.age[1],
				}),
				...(gridSearchFilters?.genderEnabled && {
					genders: gridSearchFilters?.genders,
				}),
				...(gridSearchFilters?.positionEnabled && {
					sexualPositions: gridSearchFilters?.positions,
				}),
				...(gridSearchFilters?.photosEnabled &&
					gridSearchFilters?.photos.includes("has-photos") && {
						photoOnly: true,
					}),
				...(gridSearchFilters?.photosEnabled &&
					gridSearchFilters?.photos.includes("has-albums") && {
						hasAlbum: gridSearchFilters?.photos.includes("has-albums"),
					}),
				...(gridSearchFilters?.photosEnabled &&
					gridSearchFilters?.photos.includes("has-profile-pic") && {
						faceOnly: gridSearchFilters?.photos.includes("has-face-pics"),
					}),
				...(gridSearchFilters?.tribesEnabled && {
					tribes: gridSearchFilters?.tribes,
				}),
				...(gridSearchFilters?.bodyTypesEnabled && {
					bodyTypes: gridSearchFilters?.bodyTypes,
				}),
				...(gridSearchFilters?.heightEnabled && {
					heightCmMin: gridSearchFilters?.height[0],
					heightCmMax: gridSearchFilters?.height[1],
				}),
				...(gridSearchFilters?.weightEnabled && {
					weightGramsMin: gridSearchFilters?.weight[0],
					weightGramsMax: gridSearchFilters?.weight[1],
				}),
				...(gridSearchFilters?.relationshipStatusesEnabled && {
					relationshipStatuses: gridSearchFilters?.relationshipStatuses,
				}),
				...(gridSearchFilters?.acceptNSFWPicsEnabled &&
					gridSearchFilters?.acceptNSFWPics !== undefined && {
						nsfwPics: gridSearchFilters?.acceptNSFWPics,
					}),
				...(gridSearchFilters?.lookingForEnabled && {
					lookingFor: gridSearchFilters?.lookingFor,
				}),
				...(gridSearchFilters?.meetAtEnabled && {
					meetAt: gridSearchFilters?.meetAt,
				}),
				notRecentlyChatted:
					gridSearchFilters?.haventChattedTodayEnabled || undefined,
				...(gridSearchFilters?.healthPracticesEnabled && {
					sexualHealth: gridSearchFilters?.healthPractices,
				}),
			} satisfies z.infer<typeof cascadeV3QuerySchema>;
				console.log({ query });
			return await getV3Cascade(query);
		} catch (e) {
			console.error(e);
			throw new Error("Failed to fetch profiles");
		}
	}
</script>

<Filters onUpdate={() => (profiles = fetchProfiles())} />
<div
	class="grid grid-cols-2 xs:grid-cols-3 sm:grid-cols-4 md:grid-cols-5 lg:grid-cols-6 xl:grid-cols-7 w-full gap-0.5 px-1"
>
	{#await profiles}
		{#each Array.from({ length: 20 })}
			<div class="aspect-square bg-stone-700 animate-pulse"></div>
		{/each}
	{:then { items }}
		{@const fullProfiles = items.filter(
			(i) => i.type === "full_profile_v1" || i.type === "partial_profile_v1",
		)}
		{#each fullProfiles as { data: { displayName, profileId, isVisiting, onlineUntil, rightNow, unreadCount, ...props } } (profileId)}
			<ProfileMiniCard
				id={profileId}
				displayName={displayName ?? null}
				distance={null}
				medias={"photoMediaHashes" in props
					? (props.photoMediaHashes?.map((mediaHash) => ({ mediaHash })) ?? [])
					: []}
			/>
		{/each}
	{/await}
</div>
