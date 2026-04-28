<script lang="ts">
	import { EyesIcon } from "phosphor-svelte";
	import ProfileValueLabel from "./ProfileValueLabel.svelte";
	import ProfileField from "./ProfileField.svelte";
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
	<ProfileField>
		<EyesIcon class="shrink-0" weight="fill" />
		<ProfileValueLabel label="Looking For">
			{lookingFor.map((option) => lookingForOptions[option]).join(", ")}
		</ProfileValueLabel>
	</ProfileField>
{/if}
