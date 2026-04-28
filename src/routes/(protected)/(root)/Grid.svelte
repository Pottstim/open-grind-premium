<script lang="ts">
	import type z from "zod";
	import { onMount } from "svelte";
	import {
		getV3Cascade,
		searchProfiles,
		type searchProfileSchema,
	} from "./grid";
	import { getPreferences } from "$lib/app-data/preferences.svelte";
	import ProfileMiniCard from "./ProfileMiniCard.svelte";
	import Filters from "./GridFilters.svelte";

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
			return await getV3Cascade({
				nearbyGeoHash: geohash,
				// favorite || undefined
				onlineOnly: gridSearchFilters?.isOnline || undefined,
				// right now || undefined
				...(gridSearchFilters?.ageEnabled && {
					ageMinimum: gridSearchFilters?.age[0],
					ageMaximum: gridSearchFilters?.age[1],
				}),
				...(gridSearchFilters?.genderEnabled && {
					genders: gridSearchFilters?.genders,
				}),
				...(gridSearchFilters?.positionEnabled && {
					sexualPositionIds: gridSearchFilters?.positions,
				}),
				...(gridSearchFilters?.photosEnabled && {
					photoOnly: gridSearchFilters?.photos.includes("has-photos"),
					hasAlbum: gridSearchFilters?.photos.includes("has-albums"),
					faceOnly: gridSearchFilters?.photos.includes("has-face-pics"),
				}),
				...(gridSearchFilters?.tribesEnabled && {
					grindrTribesIds: gridSearchFilters?.tribes,
				}),
				...(gridSearchFilters?.bodyTypesEnabled && {
					bodyTypeIds: gridSearchFilters?.bodyTypes,
				}),
				...(gridSearchFilters?.heightEnabled && {
					heightMinimum: gridSearchFilters?.height[0],
					heightMaximum: gridSearchFilters?.height[1],
				}),
				...(gridSearchFilters?.weightEnabled && {
					weightMinimum: gridSearchFilters?.weight[0],
					weightMaximum: gridSearchFilters?.weight[1],
				}),
				...(gridSearchFilters?.relationshipStatusesEnabled && {
					relationshipStatusIds: gridSearchFilters?.relationshipStatuses,
				}),
				...(gridSearchFilters?.acceptNSFWPicsEnabled &&
					gridSearchFilters?.acceptNSFWPics !== undefined && {
						nsfwIds: gridSearchFilters?.acceptNSFWPics,
					}),
				...(gridSearchFilters?.lookingForEnabled && {
					lookingForIds: gridSearchFilters?.lookingFor,
				}),
				...(gridSearchFilters?.meetAtEnabled && {
					meetAtIds: gridSearchFilters?.meetAt,
				}),
				notRecentlyChatted:
					gridSearchFilters?.haventChattedTodayEnabled || undefined,
				// healthPractices
			});
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
		{#each items as { data: { displayName, age, profileId, photoMediaHashes } } (profileId)}
			<ProfileMiniCard
				id={profileId}
				{displayName}
				{age}
				distance={null}
				medias={photoMediaHashes?.map((mediaHash) => ({ mediaHash })) ?? []}
			/>
		{/each}
	{/await}
</div>
