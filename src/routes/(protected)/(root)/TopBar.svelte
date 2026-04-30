<script lang="ts">
	import LocationChange from "./LocationChange.svelte";
	import Filters from "./GridFilters.svelte";
	import ProgressiveBlur from "$lib/components/ProgressiveBlur.svelte";

	let {
		onUpdatePreferences,
		onRefreshGrid,
	}: {
		onUpdatePreferences: () => void;
		onRefreshGrid: () => void;
	} = $props();

	let expanded = $state(false);
</script>

<svelte:window onscroll={() => (expanded = window.scrollY === 0)} />
<ProgressiveBlur
	class={["fixed top-0 left-0 w-full z-10"]}
	bgClass="bg-linear-to-b from-background to-transparent"
	contentClass={[
		"flex gap-2 p-4",
		{
			"flex-col overflow-auto": expanded,
			"": !expanded,
		},
	]}
	direction="topToBottom"
>
	<LocationChange onUpdate={onUpdatePreferences} {expanded} />
	<Filters onUpdate={onRefreshGrid} />
</ProgressiveBlur>
<div class="h-20"></div>
