<script lang="ts">
	import FilterDropdown from "$lib/components/filters/FilterDropdown.svelte";
	import { Slider } from "$lib/components/ui/slider";

	let {
		checked = $bindable(),
		value = $bindable(),
	}: { checked: boolean; value: number[] } = $props();
</script>

<div class="block space-y-3 w-full">
	<FilterDropdown
		id="height"
		label="Height"
		bind:checked
		endLabel={`${value[0] === 120 ? "No min" : value[0] + " cm"} - ${
			value[1] === 242 ? "No max" : value[1] + " cm"
		}`}
		contentClass="ps-7 h-5"
	>
		<Slider
			type="multiple"
			bind:value={
				() => value,
				(v: number[]) => {
					checked = true;
					value = v;
				}
			}
			min={120}
			max={242}
			step={1}
		/>
	</FilterDropdown>
</div>
