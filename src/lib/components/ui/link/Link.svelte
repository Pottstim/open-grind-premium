<script lang="ts">
	let {
		onclick,
		children,
		href,
		...props
	}: import("svelte/elements").SvelteHTMLElements["a"] = $props();
</script>

<a
	{href}
	onclick={(event) => {
		onclick?.(event);
		if (href) {
			event.preventDefault();
			void import("@tauri-apps/plugin-opener").then(({ openUrl }) =>
				openUrl(href),
			);
		}
	}}
	{...props}
>
	{@render children?.()}
</a>
