<script lang="ts">
	import {
		FacebookLogoIcon,
		InstagramLogoIcon,
		XLogoIcon,
	} from "phosphor-svelte";

	import { type SocialNetworks } from "$lib/model/profile";
	import ProfileField from "./ProfileField.svelte";

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
			<ProfileField>
				{#if platform === "instagram"}
					<InstagramLogoIcon class="shrink-0" />
					<a
						href="https://instagram.com/{social.userId}"
						target="_blank"
						rel="noopener noreferrer"
					>
						{social.userId}
					</a>
				{:else if platform === "twitter"}
					<XLogoIcon class="shrink-0" />
					<a
						href="https://x.com/{social.userId}"
						target="_blank"
						rel="noopener noreferrer"
					>
						{social.userId}
					</a>
				{:else if platform === "facebook"}
					<FacebookLogoIcon class="shrink-0" />
					<a
						href="https://facebook.com/profile.php?id={social.userId}"
						target="_blank"
						rel="noopener noreferrer"
					>
						{social.userId}
					</a>
				{/if}
			</ProfileField>
		{/if}
	{/each}
{/if}
