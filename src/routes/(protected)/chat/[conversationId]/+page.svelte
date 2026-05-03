<script lang="ts">
	import * as Card from "$lib/components/ui/card";
	import MessagesList from "./MessagesList.svelte";
	import MessageComposer from "./MessageComposer.svelte";

	let { data }: import("./$types").PageProps = $props();
</script>

<Card.Content class="flex flex-col flex-1 pb-2 px-0 max-h-full">
	<MessagesList ourProfileId={data.profileId} />
	<MessageComposer />
</Card.Content>
