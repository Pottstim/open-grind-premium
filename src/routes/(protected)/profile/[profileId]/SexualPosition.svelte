<script lang="ts">
	import {
		SexualPosition,
		sexualPositions,
		type SexualPositionId,
	} from "$lib/model/profile";
	import {
		ArrowDownIcon,
		ArrowDownRightIcon,
		ArrowsDownUpIcon,
		ArrowsLeftRightIcon,
		ArrowUpIcon,
		ArrowUpRightIcon,
	} from "phosphor-svelte";

	let { sexualPosition }: { sexualPosition: SexualPositionId } = $props();
</script>

<span class="flex items-center gap-1 whitespace-nowrap *:shrink-0">
	{#if sexualPosition === SexualPosition.Top}
		<ArrowUpIcon class="shrink-0" />
	{:else if sexualPosition === SexualPosition.VersTop}
		<ArrowUpRightIcon class="shrink-0" />
	{:else if sexualPosition === SexualPosition.Versatile}
		<ArrowsDownUpIcon class="shrink-0" />
	{:else if sexualPosition === SexualPosition.VersBottom}
		<ArrowDownRightIcon class="shrink-0" />
	{:else if sexualPosition === SexualPosition.Bottom}
		<ArrowDownIcon class="shrink-0" />
	{:else if sexualPosition === SexualPosition.Side}
		<ArrowsLeftRightIcon class="shrink-0" />
	{/if}
	{sexualPositions[sexualPosition]}
</span>
