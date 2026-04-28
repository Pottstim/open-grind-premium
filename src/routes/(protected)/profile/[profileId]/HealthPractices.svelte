<script lang="ts">
	import { HeartbeatIcon } from "phosphor-svelte";
	import ProfileField from "./ProfileField.svelte";
	import ProfileValueLabel from "./ProfileValueLabel.svelte";
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
	<ProfileField>
		<HeartbeatIcon class="shrink-0" />
		<ProfileValueLabel label="Health Practices">
			{healthPractices
				.map((option) => healthPracticesOptions[option])
				.join(", ")}
		</ProfileValueLabel>
	</ProfileField>
{/if}
