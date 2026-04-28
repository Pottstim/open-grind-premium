<script lang="ts">
	import { type SocialNetworks } from "$lib/model/profile";
	import {
		FacebookLogoIcon,
		InstagramLogoIcon,
		XLogoIcon,
	} from "phosphor-svelte";

	let {
		socials,
	}: {
		socials: SocialNetworks | null;
	} = $props();
</script>

{#if socials !== null}
	{#each ["instagram", "twitter", "facebook"] as platform}
		{@const social = socials[platform as keyof SocialNetworks]}
		{#if social}
			<div class="flex items-center gap-1.5 text-sm">
				{#if platform === "instagram"}
					<InstagramLogoIcon class="shrink-0" />
				{:else if platform === "twitter"}
					<XLogoIcon class="shrink-0" />
				{:else if platform === "facebook"}
					<FacebookLogoIcon class="shrink-0" />
				{/if}
				{social.userId}
			</div>
		{/if}
	{/each}
{/if}
