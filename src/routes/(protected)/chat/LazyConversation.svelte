<script lang="ts">
	import type { Conversation as ConversationType } from "$lib/model/conversation";
	import Conversation from "./Conversation.svelte";

	let {
		conversation,
	}: {
		conversation: ConversationType;
	} = $props();

	let mounted = $state(false);

	function observe(node: HTMLElement) {
		const observer = new IntersectionObserver(
			(entries) => {
				if (entries[0].isIntersecting) {
					mounted = true;
					observer.disconnect();
				}
			},
			{ rootMargin: "600px" },
		);
		observer.observe(node);
		return {
			destroy() {
				observer.disconnect();
			},
		};
	}
</script>

{#if mounted}
	<Conversation {conversation} />
{:else}
	<div class="w-full h-24.5 shrink-0 rounded-2xl bg-muted/30" use:observe></div>
{/if}
