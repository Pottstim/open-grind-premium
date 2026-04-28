<script lang="ts">
	import { UsersThreeIcon } from "phosphor-svelte";
	import { type LookingForId } from "$lib/model/profile";

	let {
		lookingFor,
	}: {
		lookingFor: LookingForId[] | null;
	} = $props();
</script>

{#if lookingFor !== null && lookingFor.length > 0}
	<div class="flex items-center gap-1.5 text-sm">
		<UsersThreeIcon class="shrink-0" />
		<div class="gap-1">
			<span class="text-neutral-500">Looking For</span>
			{lookingFor.map((option) => lookingFor[option]).join(", ")}
		</div>
	</div>
{/if}
