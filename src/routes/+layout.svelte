<script lang="ts">
	import "@fontsource-variable/ibm-plex-sans/wght.css";
	import "@fontsource-variable/ibm-plex-sans/wght-italic.css";

	import "../layout.css";
	import { IconContext } from "phosphor-svelte";
	import { Toaster } from "svelte-french-toast";

	import favicon from "$lib/assets/favicon.png";

	let {
		children,
	}: {
		children?: import("svelte").Snippet;
	} = $props();
</script>

<svelte:head>
	<link rel="icon" href={favicon} />
</svelte:head>
<Toaster
	position="bottom-center"
	toastOptions={{
		style: "background-color: var(--accent); color: var(--popover)",
	}}
/>
<!-- TODO: migrate to svelte-sonner (svelte-french-toast is dead) -->
<IconContext values={{}}>
	{@render children?.()}
</IconContext>
