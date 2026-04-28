<script lang="ts">
	import { CameraIcon } from "phosphor-svelte";
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
	<div class="flex items-center gap-1.5 text-sm">
		<CameraIcon class="shrink-0" />
		<div class="flex items-center gap-1">
			<div class="gap-1">
				<span class="text-neutral-500">NSFW pics?</span>
				{acceptNSFWPicsOptions[nsfwPics]}
			</div>
		</div>
	</div>
{/if}
