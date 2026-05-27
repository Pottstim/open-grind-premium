<script lang="ts">
	import { ChatCircleSlashIcon } from "phosphor-svelte";

	import * as Empty from "$lib/components/ui/empty";
</script>

<Empty.Root>
	<Empty.Header>
		<Empty.Media variant="icon">
			<ChatCircleSlashIcon weight="fill" />
		</Empty.Media>
		<Empty.Title>No Conversations Yet</Empty.Title>
		<Empty.Description>
			Browse <a href="/">Grid</a> to find people to chat with.
		</Empty.Description>
	</Empty.Header>
</Empty.Root>
