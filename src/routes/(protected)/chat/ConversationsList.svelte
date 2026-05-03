<script lang="ts">
	import { getConversations } from "$lib/api/conversation";
	import Skeleton from "$lib/components/ui/skeleton/skeleton.svelte";
	import Conversation from "./Conversation.svelte";

	let {
		class: className,
	}: {
		class?: import("svelte/elements").ClassValue;
	} = $props();

	let conversations = $state(getConversations());
</script>

<div
	class={[
		"flex flex-col gap-1 p-4 w-full h-full overflow-auto min-w-29.25",
		className,
	]}
>
	{#await conversations}
		{#each Array(8)}
			<Skeleton class="w-full h-24.5 shrink-0" />
		{/each}
	{:then { entries }}
		{#each entries as conversation}
			<Conversation {conversation} />
		{/each}
	{/await}
</div>
