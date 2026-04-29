<script lang="ts">
	import ImageCarouselItem from "./ImageCarouselItem.svelte";
	import PhotoSwipeLightbox from "photoswipe/lightbox";
	import "photoswipe/style.css";

	let gallery: HTMLDivElement;

	$effect(() => {
		let lightbox = new PhotoSwipeLightbox({
			gallery,
			children: ".item",
			pswpModule: () => import("photoswipe"),
			mainClass: `pswp--buttons-visible`,
		});
		lightbox.addFilter("itemData", (itemData, index) => {
			const img = itemData.element?.querySelector("img");
			if (img?.naturalWidth) {
				itemData.width = img.naturalWidth;
				itemData.height = img.naturalHeight;
			}
			return itemData;
		});
		// lightbox.addFilter("thumbBounds", (thumbBounds, itemData) => {
		// 	const img = itemData.element?.querySelector("img");
		// 	if (!img) return thumbBounds;
		// 	const rect = img.getBoundingClientRect();
		// 	return { x: rect.left, y: rect.top, w: rect.width };
		// });

		lightbox.on("openingAnimationStart", () => {
			gallery.querySelectorAll(".item").forEach((item) => {
				if (item instanceof HTMLElement) {
					item.style.visibility = "hidden";
				}
			});
		});

		lightbox.on("change", () => {
			gallery.scrollTo({
				top:
					lightbox.pswp?.currSlide?.data.element?.offsetTop ??
					0,
				behavior: "instant",
			});
		});

		lightbox.on("destroy", () => {
			gallery.querySelectorAll(".item").forEach((item) => {
				if (item instanceof HTMLElement) {
					item.style.visibility = "visible";
				}
			});
		});
		lightbox.init();
		return () => lightbox.destroy();
	});
</script>

<div
	class="w-full flex flex-col h-auto aspect-3/4 snap-y snap-mandatory *:snap-center overflow-auto carousel"
	bind:this={gallery}
>
	<ImageCarouselItem />
	<ImageCarouselItem />
	<ImageCarouselItem />
</div>

<style lang="postcss">
	@reference "$layout";
	.carousel::-webkit-scrollbar {
		display: none;
	}
	:global {
		.pswp .pswp__button {
			display: none;
		}
	}
</style>
