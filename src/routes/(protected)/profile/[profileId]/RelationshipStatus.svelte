<script lang="ts">
	import { UsersIcon } from "phosphor-svelte";
	import ProfileField from "./ProfileField.svelte";
	import {
		relationshipStatuses,
		type RelationshipStatusId,
	} from "$lib/model/profile";

	let {
		relationshipStatus,
	}: {
		relationshipStatus: RelationshipStatusId | null;
	} = $props();
</script>

{#if relationshipStatus !== null}
	<ProfileField>
		<UsersIcon class="shrink-0" />
		{relationshipStatuses[relationshipStatus]}
	</ProfileField>
{/if}
