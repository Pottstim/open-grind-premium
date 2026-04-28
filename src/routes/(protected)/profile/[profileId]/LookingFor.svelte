<script lang="ts">
	import { EyesIcon } from "phosphor-svelte";
	import {
		lookingFor as lookingForOptions,
		type LookingForId,
	} from "$lib/model/profile";

	let {
		lookingFor,
	}: {
		lookingFor: LookingForId[] | null;
	} = $props();
</script>

{#if lookingFor !== null && lookingFor.length > 0}
	<div class="flex items-center gap-1.5 text-sm">
		<EyesIcon class="shrink-0" weight="fill" />
		<div class="gap-1">
			<span class="text-neutral-500">Looking For</span>
			{lookingFor.map((option) => lookingForOptions[option]).join(", ")}
		</div>
	</div>
{/if}
