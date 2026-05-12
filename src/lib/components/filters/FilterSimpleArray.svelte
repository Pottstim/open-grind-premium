<script lang="ts" generics="T extends unknown">
	import * as ToggleGroup from "$lib/components/ui/toggle-group";
	import FilterDropdown from "./FilterDropdown.svelte";

	let {
		checked = $bindable(),
		value = $bindable(),
		id,
		label,
		items,
		convert,
	}: {
		checked: boolean;
		value: T[];
		id: string;
		label: string;
		items: { value: T; label: string }[];
		convert: (v: string) => T;
	} = $props();
</script>

<div class="flex flex-col min-w-0">
	<FilterDropdown {id} {label} bind:checked>
		<ToggleGroup.Root
			type="multiple"
			variant="outline"
			spacing={2}
			class="flex-wrap w-full gap-1"
			bind:value={
				() => value.map(String),
				(v: string[]) => ((checked = v.length > 0), (value = v.map(convert)))
			}
		>
			{#each items as { value, label }}
				<ToggleGroup.Item value={String(value)}>{label}</ToggleGroup.Item>
			{/each}
		</ToggleGroup.Root>
	</FilterDropdown>
</div>
