<script lang="ts">
	import type { FilterTribeId } from "$lib/components/filters/filters";
	import { tribes } from "$lib/model/profile";
	import FilterSimpleArray from "./FilterSimpleArray.svelte";

	let {
		checked = $bindable(),
		value = $bindable(),
	}: { checked: boolean; value: FilterTribeId[] } = $props();
</script>

<FilterSimpleArray
	bind:checked
	bind:value
	id="tribes"
	label="Tribes"
	items={[
		...Object.entries(tribes).map(([value, label]) => ({
			value: Number(value),
			label,
		})),
		{
			value: -1,
			label: "Not Specified",
		},
	]}
	convert={Number}
/>
