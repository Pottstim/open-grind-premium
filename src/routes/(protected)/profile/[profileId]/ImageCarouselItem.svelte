<script lang="ts">
	import { expoOut } from "svelte/easing";
	import { fade } from "svelte/transition";

	let {
		src,
		thumb,
	}: {
		src: string;
		thumb: string;
	} = $props();

	let focused:
		| {
				startX: number;
				startY: number;
		  }
		| false = $state(false);
	const id = $props.id();

	let width: number | null = $state(null);
	let height: number | null = $state(null);

	// function onclick(event: MouseEvent) {
	// 	focused = !focused;
	// 	if (focused) {
	// 		document.documentElement.classList.add(`scroll-lock-${id}`);
	// 	} else {
	// 		document.documentElement.classList.remove(`scroll-lock-${id}`);
	// 	}
	// 	event.clientX;
	// }
</script>

<a
	class="item h-full w-full aspect-auto block relative max-h-[inherit] shrink-0"
	data-cropped="true"
	data-pswp-width={width}
	data-pswp-height={height}
	href={src}
	aria-label="Open image"
>
	<img
		src={thumb}
		draggable="false"
		class="w-full h-full absolute top-0 left-0 object-cover object-center bg-stone-700"
		alt=""
		onload={(event) => {
			const img = event.currentTarget;
			if (img instanceof HTMLImageElement) {
				width = img.naturalWidth;
				height = img.naturalHeight;
			}
		}}
	/>
</a>

<!-- {#if focused}
	<button
		class="bg-black/50 fixed top-0 left-0 size-full z-99"
		transition:fade={{ duration: 500, easing: expoOut }}
		onclick={() => (focused = false)}
		aria-label="Close image"
	></button>
	<div
		class="fixed top-0 left-0 size-full z-100 flex justify-center items-center p-4"
	>
		<img
			src="https://placehold.co/600x400"
			alt=""
			draggable="false"
			class="z-100 w-full h-full object-contain"
		/>
	</div>
{/if} -->

<style lang="postcss">
	@reference "$layout";
	.item {
		scroll-snap-stop: always;
	}
</style>
