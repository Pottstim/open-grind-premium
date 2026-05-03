<script lang="ts">
	import { page } from "$app/state";
	import NavBar from "$lib/components/NavBar.svelte";

	let { children }: { children?: import("svelte").Snippet } = $props();
</script>

{@render children?.()}
<NavBar />
