<script lang="ts">
	import { page } from "$app/state";
	import { tabsListVariants } from "$lib/components/ui/tabs";
	import DotsNineIcon from "phosphor-svelte/lib/DotsNineIcon";
	import DropIcon from "phosphor-svelte/lib/DropIcon";
	import FireIcon from "phosphor-svelte/lib/FireIcon";
	import ChatCircleIcon from "phosphor-svelte/lib/ChatCircleIcon";
	import ProgressiveBlur from "$lib/components/ProgressiveBlur.svelte";
</script>

<ProgressiveBlur
	direction="bottomToTop"
	tag="nav"
	class="fixed bottom-0 z-50 w-full py-2"
	bgClass="bg-linear-to-t from-background to-transparent"
	contentClass="overflow-auto no-scrollbar left-1/2 -translate-x-1/2 m-auto flex justify-center"
>
	<div class={[tabsListVariants({ variant: "default" }), "[&>a>svg]:size-5!"]}>
		<a href="/" data-active={page.route.id === "/(protected)/(root)"}>
			<DotsNineIcon weight="fill" />
			Browse
		</a>
		<a
			href="/right-now"
			data-active={page.route.id === "/(protected)/right-now"}
		>
			<DropIcon weight="fill" />
			Right Now
		</a>
		<a href="/interest" data-active={page.route.id === "/(protected)/interest"}>
			<FireIcon weight="fill" />
			Interest
		</a>
		<a href="/chat" data-active={page.route.id === "/(protected)/chat"}>
			<ChatCircleIcon weight="fill" />
			Inbox
		</a>
	</div>
</ProgressiveBlur>

<style lang="postcss">
	@reference "../../layout.css";

	a {
		@apply rounded-full border border-transparent! px-3 py-1 text-xs data-active:font-medium group-data-vertical/tabs:rounded-2xl group-data-vertical/tabs:px-3 group-data-vertical/tabs:py-1.5 [&_svg:not([class*='size-'])]:size-4 focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:outline-ring text-foreground/60 hover:bg-input/20 dark:text-muted-foreground dark:hover:bg-input/20 relative inline-flex h-[calc(100%-1px)] flex-col gap-0.5 flex-1 items-center justify-center whitespace-nowrap focus-visible:ring-[3px] focus-visible:outline-1 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:shrink-0 dark:data-active:text-accent dark:data-active:border-input  data-active:text-foreground;
	}
</style>
