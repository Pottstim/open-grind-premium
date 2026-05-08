<script lang="ts">
	import type { ComponentProps } from "svelte";
	import ContextMenu from "$lib/components/ContextMenu.svelte";
	import { Button } from "$lib/components/ui/button";
	import { writeText } from "@tauri-apps/plugin-clipboard-manager";
	import toast from "svelte-french-toast";
	import { CopyIcon, FlagIcon, TrashIcon } from "phosphor-svelte";

	let {
		textContent,
		...props
	}: ComponentProps<typeof ContextMenu> & {
		textContent?: string;
	} = $props();
</script>

<ContextMenu {...props}>
	{#if textContent !== undefined}
		<Button
			variant="ghost"
			onclick={() => {
				writeText(textContent).then(() => {
					toast.success("Message copied to clipboard");
					props.onClose();
				});
			}}
		>
			<CopyIcon /> Copy message
		</Button>
	{/if}
	<Button variant="ghost">
		<TrashIcon />
		Delete for me
	</Button>
	<Button variant="ghost">
		<FlagIcon /> Report
	</Button>
</ContextMenu>
