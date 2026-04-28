<script lang="ts">
	import { CameraIcon } from "phosphor-svelte";
	import ProfileField from "./ProfileField.svelte";
	import ProfileValueLabel from "./ProfileValueLabel.svelte";
	import {
		acceptNSFWPics as acceptNSFWPicsOptions,
		type AcceptNSFWPicsId,
	} from "$lib/model/profile";

	let {
		nsfwPics,
	}: {
		nsfwPics: AcceptNSFWPicsId | null;
	} = $props();
</script>

{#if nsfwPics !== null}
	<ProfileField>
		<CameraIcon class="shrink-0" />
		<ProfileValueLabel label="NSFW pics?">
			{acceptNSFWPicsOptions[nsfwPics]}
		</ProfileValueLabel>
	</ProfileField>
{/if}
