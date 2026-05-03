<script lang="ts">
	import { page } from "$app/state";
	import { getConversationMessages } from "$lib/api/conversation";
	import type { Message as MessageType } from "$lib/model/message";
	import { Skeleton } from "$lib/components/ui/skeleton";
	import Message from "./Message.svelte";
	import { getStackedMessages, groupMessagesByDate } from "./messages";

	let { ourProfileId }: { ourProfileId: number } = $props();

	if (page.params.conversationId === undefined) {
		throw new Error("conversationId is required");
	}

	let messages = $derived(
		getConversationMessages(page.params.conversationId).then((res) => {
			const stackedMessages = getStackedMessages({
				messages: res.messages,
				ourProfileId,
			});
			const groupedMessages = groupMessagesByDate({
				messages: stackedMessages,
			});
			return {
				...res,
				messages: groupedMessages,
			};
		}),
	);
</script>

<div class="flex-1 flex flex-col-reverse min-h-0 overflow-auto gap-1 p-2">
	{#await messages}
		{#each Array(20)}
			<Skeleton
				class={[
					"h-9 shrink-0 max-w-full",
					Math.random() < 0.5 ? "self-start" : "self-end",
				]}
				style="width: {Math.floor(Math.random() * 400) + 100}px"
			/>
		{/each}
	{:then { messages }}
		{#each messages as message (message.messageId)}
			<Message
				{message}
				{ourProfileId}
				indexInStack={message.indexInStack}
				stackLength={message.stackLength}
				dayStart={message.dayStart}
			/>
		{/each}
	{/await}
</div>
