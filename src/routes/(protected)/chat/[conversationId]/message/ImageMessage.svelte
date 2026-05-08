<script lang="ts">
	import type { ExpiringImageMessage, ImageMessage } from "$lib/model/message";
	import { getMessageContext } from "./context";

	let {
		message,
		ref = $bindable(),
		clone,
	}: {
		message: ImageMessage["body"] | ExpiringImageMessage["body"];
		ref?: HTMLDivElement;
		clone?: boolean;
	} = $props();

	const { lastInStack, msgOut } = $derived(getMessageContext()());
</script>

<div class={{ "w-2/5 min-w-35 max-w-60 ms-3": !clone }} bind:this={ref}>
	<img
		src={message.url}
		alt=""
		class={[
			"w-full rounded-lg bg-card-foreground/10 object-cover",
			{
				"rounded-es-[6px]": lastInStack && !msgOut,
				"rounded-ee-[6px]": lastInStack && msgOut,
			},
		]}
		style:aspect-ratio={message.width !== null && message.height !== null
			? `${message.width} / ${message.height}`
			: undefined}
	/>
</div>
