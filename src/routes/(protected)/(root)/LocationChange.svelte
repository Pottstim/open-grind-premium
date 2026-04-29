<script lang="ts">
	import toast from "svelte-french-toast";
	import { GpsFixIcon, PencilSimpleIcon } from "phosphor-svelte";
	import { Button } from "$lib/components/ui/button";
	import { setPreferences } from "$lib/app-data/preferences.svelte";
	import LocationChooser from "$lib/components/location-chooser/LocationChooser.svelte";

	let {
		onUpdate,
		expanded,
	}: {
		onUpdate?: () => void;
		expanded?: boolean;
	} = $props();

	let geoMapPickerOpen = $state(false);

	function onSubmit(geohash: string) {
		setPreferences({ geohash })
			.then(() => {
				geoMapPickerOpen = false;
				onUpdate?.();
			})
			.catch((e) => {
				console.error(e);
				toast.error("Failed to save location");
			});
	}
</script>

<Button
	variant="secondary"
	class={{ "w-full": expanded }}
	onclick={() => (geoMapPickerOpen = true)}
>
	{#if expanded}
		<PencilSimpleIcon weight="fill" />
		Change location
	{:else}
		<GpsFixIcon weight="fill" />
	{/if}
</Button>
<LocationChooser {onSubmit} bind:open={geoMapPickerOpen} />
