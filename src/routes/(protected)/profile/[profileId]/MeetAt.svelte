<script lang="ts">
	import { HouseIcon } from "phosphor-svelte";
	import { meetAt as meetAtOptions, type MeetAtId } from "$lib/model/profile";

	let {
		meetAt = null,
	}: {
		meetAt?: MeetAtId[] | null;
	} = $props();
</script>

{#if meetAt !== null && meetAt.length > 0}
	<div class="flex items-center gap-1.5 text-sm">
		<HouseIcon class="shrink-0" />
		<div class="gap-1">
			<span class="text-neutral-500">Meet At</span>
			{meetAt.map((option) => meetAtOptions[option]).join(", ")}
		</div>
	</div>
{/if}
