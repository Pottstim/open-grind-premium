<script lang="ts">
	import { format } from "date-fns";
	import { ClockIcon } from "phosphor-svelte";

	let {
		lastTestedDate,
	}: {
		lastTestedDate: number | null;
	} = $props();
</script>

{#if lastTestedDate !== null}
	<div class="flex items-center gap-1.5 text-sm">
		<ClockIcon class="shrink-0" />
		<div class="flex items-center gap-1">
			<div class="gap-1">
				<span class="text-neutral-500">Last Tested</span>
				{format(new Date(lastTestedDate), "LLLL yyyy")}
			</div>
		</div>
	</div>
{/if}
