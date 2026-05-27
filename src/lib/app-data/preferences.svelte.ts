import { decode, encode } from "@msgpack/msgpack";
import { toast } from "svelte-sonner";
import z from "zod";

import { gridSearchFiltersSchema } from "$lib/components/filters/filters";
import { geohashSchema } from "$lib/model/geohash";
import { existsAppDataFile, readAppDataFile, writeAppDataFile } from ".";

const preferencesSchema = z.object({
	geohash: geohashSchema.nullable().default(null),
	gridSearchFilters: gridSearchFiltersSchema.optional(),
	revealMessageRead: z.boolean().default(false),
	revealProfileViews: z.boolean().default(false),
	warnBeforeCopyingErrorDetails: z.boolean().default(true),
});

export async function getPreferences(): Promise<
	z.infer<typeof preferencesSchema>
> {
	if (await existsAppDataFile("preferences.data")) {
		return await readAppDataFile("preferences.data")
			.then(decode)
			.then((data) => preferencesSchema.parse(data))
			.catch((e) => {
				toast.error("Failed to load preferences. Reset to defaults?", {
					action: {
						label: "Reset",
						onClick: async () => {
							await writeAppDataFile(
								"preferences.data",
								encode(preferencesSchema.parse({})),
							);
							window.location.reload();
						},
					},
					duration: 10000,
					id: "load-preferences-error",
				});
				throw e;
			});
	} else {
		return preferencesSchema.parse({});
	}
}

export async function setPreferences(
	newValues: Partial<z.infer<typeof preferencesSchema>>,
): Promise<void> {
	const oldValues = await getPreferences();
	const preferences = {
		...oldValues,
		...newValues,
	};
	preferencesSchema.parse(preferences);
	await writeAppDataFile("preferences.data", encode(preferences));
}
