<script lang="ts">
	import { UsersThreeIcon } from "phosphor-svelte";
	import { type MeetAtId } from "$lib/model/profile";

	let {
		meetAt,
	}: {
		meetAt: MeetAtId[] | null;
	} = $props();
</script>

{#if meetAt !== null && meetAt.length > 0}
	<div class="flex items-center gap-1.5 text-sm">
		<UsersThreeIcon class="shrink-0" />
		<div class="gap-1">
			<span class="text-neutral-500">Meet At</span>
			{meetAt.map((option) => meetAt[option]).join(", ")}
		</div>
	</div>
{/if}
