<script lang="ts">
	let { type, ref = $bindable() }: { type: string; ref?: HTMLDivElement } =
		$props();
</script>

<div
	class="bg-card text-muted-foreground/30 w-full rounded-lg p-2 max-w-full text-center text-sm"
	bind:this={ref}
>
	Unsupported message type: {type}
</div>
