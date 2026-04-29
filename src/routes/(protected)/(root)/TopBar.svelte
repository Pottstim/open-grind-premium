<script lang="ts">
	import LocationChange from "./LocationChange.svelte";
	import Filters from "./GridFilters.svelte";

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
<div
	class={[
		"fixed top-0 left-0 w-full flex gap-2 p-4 z-10 bg-background/80 backdrop-blur-2xl border border-x-0 border-t-0",
		{
			"flex-col border-transparent overflow-auto": expanded,
			"border-row border-popover-foreground/20": !expanded,
		},
	]}
>
	<LocationChange onUpdate={onUpdatePreferences} {expanded} />
	<Filters onUpdate={onRefreshGrid} />
</div>
<div class="h-20"></div>
