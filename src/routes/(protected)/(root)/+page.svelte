<script lang="ts">
	import { getPreferences } from "$lib/app-data/preferences";
	import { onMount } from "svelte";
	import Grid from "./Grid.svelte";
	import LocationChooser from "$lib/components/location-chooser/LocationChooser.svelte";

	let loading = $state(true);
	let geohash: string | null = $state(null);

	async function fetchGeohash() {
		const preferences = await getPreferences();
		geohash = preferences?.geohash ?? null;
	}

	onMount(() => {});
</script>

<svelte:head>
	<title>Open Grind</title>
</svelte:head>
<main class="min-h-dvh">
	{#await getPreferences() then { geohash }}
		{#if geohash === null}
			<div class="m-auto flex min-h-dvh pb-16">
				<LocationChooser />
			</div>
		{:else}
			<Grid {geohash} />
		{/if}
	{/await}
</main>
