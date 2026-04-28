<script lang="ts">
	import {
		FilterPosition,
		filterPositionSchema,
	} from "$lib/components/filters/filters";
	import * as ToggleGroup from "$lib/components/ui/toggle-group";
	import type z from "zod";
	import FilterBoolean from "./FilterBoolean.svelte";
	import {
		ArrowDownIcon,
		ArrowDownRightIcon,
		ArrowsDownUpIcon,
		ArrowsLeftRightIcon,
		ArrowUpIcon,
		ArrowUpRightIcon,
		XIcon,
	} from "phosphor-svelte";

	let {
		checked = $bindable(),
		value = $bindable(),
	}: {
		checked: boolean;
		value: z.infer<typeof filterPositionSchema>;
	} = $props();
</script>

<div class="flex flex-col gap-2 min-w-0">
	<FilterBoolean id="position" bind:checked>Position</FilterBoolean>
	<div class="ps-6">
		<ToggleGroup.Root
			type="multiple"
			variant="outline"
			spacing={2}
			class="flex-wrap w-full gap-1"
			bind:value={
				() => value.map(String),
				(v) => (
					(checked = v.length > 0),
					(value = filterPositionSchema.parse(v.map(Number)))
				)
			}
		>
			<ToggleGroup.Item value={FilterPosition.Top.toString()}>
				<ArrowUpIcon />
				Top
			</ToggleGroup.Item>
			<ToggleGroup.Item value={FilterPosition.VersTop.toString()}>
				<ArrowUpRightIcon />
				Vers Top
			</ToggleGroup.Item>
			<ToggleGroup.Item value={FilterPosition.Versatile.toString()}>
				<ArrowsDownUpIcon />
				Versatile
			</ToggleGroup.Item>
			<ToggleGroup.Item value={FilterPosition.VersBottom.toString()}>
				<ArrowDownRightIcon />
				Vers Bottom
			</ToggleGroup.Item>
			<ToggleGroup.Item value={FilterPosition.Bottom.toString()}>
				<ArrowDownIcon />
				Bottom
			</ToggleGroup.Item>
			<ToggleGroup.Item value={FilterPosition.Side.toString()}>
				<ArrowsLeftRightIcon />
				Side
			</ToggleGroup.Item>
			<ToggleGroup.Item value={FilterPosition.NotSpecified.toString()}>
				<XIcon />
				Not Specified
			</ToggleGroup.Item>
		</ToggleGroup.Root>
	</div>
</div>
