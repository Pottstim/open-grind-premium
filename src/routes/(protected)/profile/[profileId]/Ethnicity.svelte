<script lang="ts">
	import { GlobeStandIcon } from "phosphor-svelte";
	import ProfileField from "./ProfileField.svelte";
	import { ethnicities, type EthnicityId } from "$lib/model/profile";

	let {
		ethnicity,
	}: {
		ethnicity: EthnicityId | null;
	} = $props();
</script>

{#if ethnicity !== null}
	<ProfileField>
		<GlobeStandIcon class="shrink-0" />
		{ethnicities[ethnicity]}
	</ProfileField>
{/if}
