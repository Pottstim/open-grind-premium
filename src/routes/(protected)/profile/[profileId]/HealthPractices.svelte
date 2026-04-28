<script lang="ts">
	import { HeartbeatIcon } from "phosphor-svelte";
	import {
		healthPractices as healthPracticesOptions,
		type HealthPracticeId,
	} from "$lib/model/profile";

	let {
		healthPractices = null,
	}: {
		healthPractices?: HealthPracticeId[] | null;
	} = $props();
</script>

{#if healthPractices !== null && healthPractices.length > 0}
	<div class="flex items-center gap-1.5 text-sm">
		<HeartbeatIcon class="shrink-0" />
		<div class="gap-1">
			<span class="text-neutral-500">Health Practices</span>
			{healthPractices
				.map((option) => healthPracticesOptions[option])
				.join(", ")}
		</div>
	</div>
{/if}
